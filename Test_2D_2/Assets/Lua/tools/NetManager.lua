--[[
    管理TCP，UDP, HTTP连接
--]]

local NetManager = {}

local socket = require("socket")
local pb = require('pb')
local protoc = require('protoc')

protoc:loadfile("Assets/lua/protocol/Protocol.proto")

local data={
    userName="hahaha",
    password="123456"
}
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
--print(pb.tohex(bytes))
--local data2 = pb.decode('User', bytes)
--print(data2.userName)
--print(data2.password)

---以上为测试代码
--[[
本来想用lua的os.execute，谁料os.execute为nil ？？？所以本lua代码用的是CS.System.IO.Directory
if not self:FileExists(Path) then
    local str = "sudo mkdir -p "..Path
    print(str)
    os.execute(str)
end
--]]
function NetManager:Init()

    self.currentVersion = ""
    self.serverVersion = ""

    ---是否开启热更
    self.isHotUpdates = true

    ----------------------TCP--------------------
    self.TCPServer = {IP="127.0.0.1", Port = 10000}
    self.TCPTimeout = 4

    if IS_ONLINE_MODE then
        if not socket then
            print("load socket module failed.")
        else
            print("load socket module successful.")
        end
        self:CheckUpdate()
    else
        self.MessageReceiveMap={}
    end
    ----------------------HTTP-------------------
    self.HTTPServer = {IP="http://localhost", Port = 10001}
    self.HTTPTimeout = 4
    --- 服务器资源根目录
    self.requestUrl = self.HTTPServer.IP..":"..self.HTTPServer.Port
    --- 本地资源根目录
    self.localResourcePath = UE.Application.persistentDataPath.."/resources"
    --- 要更新的文件的md5码(hex)
    self.md5 = {}
    --- 更新完成后的动作
    self.UpdateCompleteAction = nil
    --- 更新好了的文件数
    self.completeUpdateFiles = 0
    --- 当前更新的文件index
    self.currentFileIndex = 1

end

---------------------------TCP--------------------------

function NetManager:StartConnect()
    self:Connect()
end

---建立连接
function NetManager:Connect(ip, port)
    if IS_ONLINE_MODE then
        self.client = socket.connect(ip, port)
        if not self.client then
            print("connect server failed.")
        else
            self.client:settimeout(1)
        end
    end
end

---发送消息
function NetManager:TCPSendMessage(message)
    if IS_ONLINE_MODE then
        self.client:send(message)
    else

    end
end

----接收消息
function NetManager:TCPReceiveMessage()
    if self.client then
        local recvstr, err = self.client:receive()
        print("recvstr, err:", recvstr, err)
    end
end
---------------------------HTTP----------------------------
--- 检查更新
function NetManager:StartUpdate(UpdateCompleteAction)
    self.UpdateCompleteAction = UpdateCompleteAction
    StartCoroutine(self.StartUpdateCoroutine, self)
end
function NetManager:StartUpdateCoroutine()
    print("---------Begin check update---------")
    local localFile = io.open(self.localResourcePath.."/version.txt", "r")
    if localFile then
        self.currentVersion = localFile:read()
        localFile:close()
    else
        print("CheckUpdate -- Error: Connot find local version file!")
        coroutine.yield(nil)
    end
    local webRequestVersion = UE.Networking.UnityWebRequest.Get(self.requestUrl.."/version.txt")
    webRequestVersion.timeout = self.HTTPTimeout
    coroutine.yield(webRequestVersion:SendWebRequest())
    if webRequestVersion.isNetworkError or webRequestVersion.isHttpError then
        print("CheckUpdate -- "..webRequestVersion.error)
    else
        self.serverVersion = webRequestVersion.downloadHandler.text
        if self.currentVersion==self.serverVersion then
            print("No need to update")
            print("------------End check update-----------")
            if self.UpdateCompleteAction then
                self.UpdateCompleteAction()
            end
        else
            print("Your version: "..self.currentVersion.." Server version: "..self.serverVersion)
            local webRequestDownloadList = UE.Networking.UnityWebRequest.Get(self.requestUrl.."/need-to-update-files/"..self.currentVersion..".txt")
            local webRequestFileMd5 = UE.Networking.UnityWebRequest.Get(self.requestUrl.."/need-to-update-files/"..self.currentVersion.."md5.txt")
            webRequestDownloadList.timeout = self.HTTPTimeout
            webRequestFileMd5.timeout = self.HTTPTimeout
            coroutine.yield(webRequestFileMd5:SendWebRequest())
            if webRequestFileMd5.isNetworkError or webRequestFileMd5.isHttpError then
                print("UpdateFileMd5 -- "..webRequestFileMd5.error)
                coroutine.yield(nil)
            else
                self.md5 = string.split(webRequestFileMd5.downloadHandler.text, '\n')
            end
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
end

--- 下载资源
function NetManager:DownloadFlies(fileUrls)
    print("-----------Begin Download------------")
    local totalCount = #fileUrls
    for _, v in ipairs(fileUrls) do
        StartCoroutine(self.DownloadFliesCoroutine, self, self.requestUrl.."/resources/"..v, v, totalCount)
    end
end
--- count: 当前文件index    totalCount: 文件总数
function NetManager:DownloadFliesCoroutine(url, filename, totalCount)

    local webRequest = UE.Networking.UnityWebRequest.Get(url)
    webRequest.timeout = self.HTTPTimeout
    coroutine.yield(webRequest:SendWebRequest())
    if webRequest.isNetworkError or webRequest.isHttpError then
        print("Download "..url.." -- "..webRequest.error)
    else
        if self.md5[self.currentFileIndex] == pb.tohex(self:GetMD5String(webRequest.downloadHandler.data)) then
            print("Downloading "..self.currentFileIndex.." file\n")
            -- 写入或覆盖本地资源
            self:createDirIfNeed(filename)
            local file = io.open(self.localResourcePath.."/"..filename, "w+")
            if file then
                if file:write(webRequest.downloadHandler.data) then
                    self.completeUpdateFiles = self.completeUpdateFiles+1
                else
                    print("Writting Error!")
                end
                file:close()
            else
                print("Error to write file "..self.completeUpdateFiles)
            end
        else
            print("Download "..self.currentFileIndex.." file failed")
        end
    end
    -- 完成
    if self.currentFileIndex == totalCount then
        print("-----------End Download------------")
        if self.completeUpdateFiles == totalCount then
            if self:RefreshVersion() and self.UpdateCompleteAction then
                self:UpdateCompleteAction()
            end
        else
            print("Error in Downloading, please retry.")
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