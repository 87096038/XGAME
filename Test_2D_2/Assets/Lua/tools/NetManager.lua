--[[
    管理TCP，UDP, HTTP连接
    设为全局table主要是为方便C#端获取
    仅提供基础接口, 若非必要, 请不要直接调用此table, 而是用NetHelper
--]]

local MC = require("MessageCenter")
local KV = require("KeyValue")
local pb = require('pb')
local protoc = require('protoc')

NetManager = {}

protoc:loadfile("Assets/lua/protocol/Protocol.proto")

--local data={
--    userName="hahaha",
--    password="123456"
--}
--assert(protoc:load [[
--        message Phone {
--            optional string name        = 1;
--            optional int64  phonenumber = 2;
--        }
--        message Person {
--            optional string name     = 1;
--            optional int32  age      = 2;
--            optional string address  = 3;
--            repeated Phone  contacts = 4;
--        } ]])
--local data = {
--    name = 'ilse',
--    age  = 18,
--    contacts = {
--        { name = 'alice', phonenumber = 12312341234 },
--        { name = 'bob',   phonenumber = 45645674567 }
--    }
--}

--local bytes = pb.encode('User', data)
--print(bytes)
--print(pb.tohex(bytes))
--local data2 = pb.decode('User', bytes)
--print(data2.userName)
--print(data2.password)

---以上为测试代码
--[[
本来想用lua的os.execute写文件夹相关，谁料os.execute为nil ？？？所以本lua代码用的是CS.System.IO.Directory
if not self:FileExists(Path) then
    local str = "sudo mkdir -p "..Path
    print(str)
    os.execute(str)
end
--]]
function NetManager:Init()

    ----------------------TCP--------------------
    self.TCPServer = {IP="127.0.0.1", Port = 10000}
    self.TCPTimeout = 4
    --- 消息队列 index={type, data}
    self.MessageQueue = {}
    require("Timer"):AddUpdateFuc(self, self.UpdateSendQueue)
    ----------------------HTTP-------------------
    self.HTTPServer = {IP="http://localhost", Port = 10001}
    self.HTTPTimeout = 4
    --- 服务器资源根目录
    self.requestUrl = self.HTTPServer.IP..":"..self.HTTPServer.Port
    --- 本地资源根目录
    self.localResourcePath = UE.Application.dataPath
    --- 是否使用MD5
    self.isUseMD5 = true
    --- 要更新的文件的md5码(hex)
    self.md5 = {}
    --- 进度动作
    self.ProcessAction = nil
    --- 更新完成后的动作
    self.UpdateCompleteAction = nil
    --- 更新好了的文件数
    self.completeUpdateFiles = 0
    --- 当前更新的文件index
    self.currentFileIndex = 1
    --- 是否更新成功
    self.isUpdateSuccess = false

    --- 用于版本对比
    self.currentVersion = ""
    self.serverVersion = ""
    -----------------离线-------------------------------
    if not IS_ONLINE_MODE then
        self.MessageReceiveMap={}
        self.UserInfo={}
    end
end

---------------------------TCP--------------------------
---        TCP的实现在c#... 不得已而为之
function NetManager:TCPConnect()
    if IS_ONLINE_MODE then
        if CS.NetManager.Instance:Connect(self.TCPServer.IP, self.TCPServer.Port) then
            return true
        else
            print("connect server failed.")
            return false
        end
    end
end

--- 发送消息
---这里的Type对应枚举 Enum_NetMessageType 的key
function NetManager:TCPSendMessage(type, message)
    if IS_ONLINE_MODE then
        local bytes = pb.encode(Enum_NetMessageType[type], message)
        CS.NetManager.Instance:Send(type, bytes)
    else
        --self.TCPReceiveMessage(type, self.MessageReceiveMap[message])
    end
end


--- 接收消息 这里使用 . 主要因为是由C#端调用的这个接口，免得去传self
function NetManager.TCPReceiveMessage(_type, data)
    if IS_ONLINE_MODE then
        local data2 = pb.decode(Enum_NetMessageType[_type], data)
        table.insert(NetManager.MessageQueue, {type = Enum_NetMessageType[_type], data = data2})
    else
        --MC:SendMessage(Enum_NetMessageType[_type], require("KeyValue"):new(nil, data))
    end
end


--- 每帧查询消息，若有就按顺序广播
function NetManager:UpdateSendQueue()
    if next(self.MessageQueue) then
        for i=1, #self.MessageQueue do
            MC:SendMessage(self.MessageQueue[1].type, KV:new(nil, self.MessageQueue[1].data))
            table.remove(self.MessageQueue, 1)
        end
    end
end
---------------------------HTTP----------------------------
--- 检查更新
function NetManager:StartHotUpdate(ProcessAction, UpdateCompleteAction)
    if IS_ONLINE_MODE then
        self.ProcessAction = ProcessAction
        self.UpdateCompleteAction = UpdateCompleteAction
        StartCoroutine(self.StartHotUpdateCoroutine, self)
    else
        UpdateCompleteAction(true)
    end
end
function NetManager:StartHotUpdateCoroutine()
    print("---------Begin check update---------")
    local localFile = io.open(self.localResourcePath.."/version.txt", "r")
    if localFile then
        self.currentVersion = localFile:read()
        localFile:close()
        local webRequestVersion = UE.Networking.UnityWebRequest.Get(self.requestUrl.."/version.txt")
        webRequestVersion.timeout = self.HTTPTimeout
        coroutine.yield(webRequestVersion:SendWebRequest())
        if webRequestVersion.isNetworkError or webRequestVersion.isHttpError then
            print("CheckUpdate -- "..webRequestVersion.error)
            if self.UpdateCompleteAction then
                self.UpdateCompleteAction(self.isUpdateSuccess)
            end
        else
            self.serverVersion = webRequestVersion.downloadHandler.text
            if self.currentVersion==self.serverVersion then
                print("No need to update")
                print("------------End check update-----------")
                self.isUpdateSuccess = true
                if self.UpdateCompleteAction then
                    self.UpdateCompleteAction(self.isUpdateSuccess)
                end
            else
                print("Your version: "..self.currentVersion.." Server version: "..self.serverVersion)
                if  self.isUseMD5 then
                    local webRequestFileMd5 = UE.Networking.UnityWebRequest.Get(self.requestUrl.."/need-to-update-files/"..self.currentVersion.."md5.txt")
                    webRequestDownloadList.timeout = self.HTTPTimeout
                    webRequestFileMd5.timeout = self.HTTPTimeout
                    coroutine.yield(webRequestFileMd5:SendWebRequest())
                    if webRequestFileMd5.isNetworkError or webRequestFileMd5.isHttpError then
                        print("UpdateFileMd5 -- "..webRequestFileMd5.error)
                    else
                        self.md5 = string.split(webRequestFileMd5.downloadHandler.text, '\n')
                    end
                end
                local webRequestDownloadList = UE.Networking.UnityWebRequest.Get(self.requestUrl.."/need-to-update-files/"..self.currentVersion..".txt")
                webRequestDownloadList.timeout = self.HTTPTimeout
                coroutine.yield(webRequestDownloadList:SendWebRequest())
                if webRequestDownloadList.isNetworkError or webRequestDownloadList.isHttpError then
                    print("UpdateDownloadList -- "..webRequestDownloadList.error)
                else
                    local list = string.split(webRequestDownloadList.downloadHandler.text, '\n')
                    print("-----------End check update----------")
                    print("Need to download "..#list.." files")
                    self:DownloadFlies(list)
                end
            end
        end
    else
        print("CheckUpdate -- Error: Connot find local version file!")
    end
end

--- 下载资源
function NetManager:DownloadFlies(fileUrls)
    print("-----------Begin Download------------")
    local totalCount = #fileUrls
    if self.ProcessAction then
        self.ProcessAction(nil, totalCount)
    end
    for i = 1, totalCount, 1 do
        StartCoroutine(self.DownloadFliesCoroutine, self, self.requestUrl.."/resources/"..fileUrls[i], fileUrls[i], totalCount)
    end
end
--- totalCount: 文件总数
function NetManager:DownloadFliesCoroutine(url, filename, totalCount)

    local webRequest = UE.Networking.UnityWebRequest.Get(url)
    webRequest.timeout = self.HTTPTimeout
    coroutine.yield(webRequest:SendWebRequest())
    if webRequest.isNetworkError or webRequest.isHttpError then
        print("Download "..url.." -- "..webRequest.error)
    else
        if  (not self.isUseMD5) or self.md5[self.currentFileIndex] == pb.tohex(self:GetMD5String(webRequest.downloadHandler.data)) then
            print("Downloading "..self.currentFileIndex.." file\n")
            -- 写入或覆盖本地资源
            self:createDirIfNeed(filename)
            local file = io.open(self.localResourcePath.."/"..filename, "w+")
            if file then
                if file:write(webRequest.downloadHandler.data) then
                    self.completeUpdateFiles = self.completeUpdateFiles+1
                    if self.ProcessAction then
                        self.ProcessAction(1)
                    end
                else
                    print("Writting Error!")
                end
                file:close()
            else
                print("Error to write file "..self.currentFileIndex)
            end
        else
            print("Download "..self.currentFileIndex.." file failed")
        end
    end
    -- 完成
    if self.currentFileIndex == totalCount then
        print("-----------End Download------------")
        if self.completeUpdateFiles == totalCount then
            if self:RefreshVersion() then
                self.isUpdateSuccess = true
            end
        else
            print("Error in Downloading, please retry.")
        end
        if self.UpdateCompleteAction then
            self.UpdateCompleteAction(self.isUpdateSuccess)
        end
    end
    self.currentFileIndex = self.currentFileIndex + 1
end

--- 更新版本号
function NetManager:RefreshVersion()
    local localFile = io.open(self.localResourcePath.."/version.txt", "w+")
    if not localFile then
        print("RefreshVersion -- Error: Connot open local version file!")
        return false
    end
    if localFile:write( self.serverVersion) then
        localFile:close()
        self.currentVersion = self.serverVersion
        return true
    else
        print("RefreshVersion -- Error: Connot write local version file!")
        localFile:close()
        return false
    end
end

--- 计算MD5
function NetManager:GetMD5String(bytes)
    local md5 = CS.System.Security.Cryptography.MD5.Create()
    local md5Bytes = md5:ComputeHash(bytes)
    return md5Bytes
end

--- 如果没有文件夹则创建
function NetManager:createDirIfNeed(filename)
    if filename and filename ~= "" then
        local index = string.findLast(filename, '/')
        if index and index > 1  then
            local dirPath = string.sub(filename, 1, index-1)
            local dirPaths = string.split(dirPath, '/')
            local Path = self.localResourcePath
            for _, v in ipairs(dirPaths) do
                Path = Path..'/'..v
                if not CS.System.IO.Directory.Exists(Path) then
                    CS.System.IO.Directory.CreateDirectory(Path)
                end
            end
        end
    end
end

--- 文件夹是否存在
function NetManager:FileExists(path)
    local file = io.open(path, "rb")
    if file then
        file:close()
    end
    return file ~= nil
end

NetManager:Init()
return NetManager