--[[
    封装网络消息的发送, 向上提供有限接口
--]]

local Net = require("NetManager")
local MC = require("MessageCenter")

local NetHelper={}

function NetHelper:Init()
    self.IsConnect = false
    ---向服务器发送tick的间隔
    self.tickTime = 0.5
    self.disconnectTime = 2
    self.coroutine = nil
    ---------添加监听-----------
    MC:AddListener(Enum_NetMessageType.Tick, handler(self, self.OnTick))
end

function NetHelper:TCPConnect()
    if Net:TCPConnect() then
        self.IsConnect = true
        StartCoroutine(function ()
            local wait = UE.WaitForSeconds(self.tickTime)
            while self.IsConnect do
                Net:TCPSendMessage(1, {info="Tick"})
                coroutine.yield(wait)
            end
        end)
        return true
    else
        return false
    end
end

function NetHelper:SetMD5(isUseMD5)
    Net.isUseMD5 = isUseMD5
end

function NetHelper:StartHotUpdate(ProcessAction, UpdateCompleteAction)
    Net:StartHotUpdate(ProcessAction, UpdateCompleteAction)
end

-------------------发送消息--------------------------
function NetHelper:SendLogin(userName, password)
    local data = {userName=userName, password=password, response=false}
    Net:TCPSendMessage(2 , data)
end

function NetHelper:SendUserInfoRequire()
    local data = {UID=-1, userName="1", password="1", diamondCount=0, soulShardCount=0, name="1"}
    Net:TCPSendMessage(3, data)
end

function NetHelper:SendDrawSkin(countType)
    local data = {type=countType, skin = nil, response=-1}
    Net:TCPSendMessage(4, data)
end

function NetHelper:SendRefreshSkin(info)
    local data={info = info or "require"}
    Net:TCPSendMessage(5, data)
end

function NetHelper:SendRefreshCurrency(info)
    local data={info = info or "require", diamond = 0, soulShard= 0}
    Net:TCPSendMessage(6, data)
end
function NetHelper:SendBuyOuterThing(ID, outerThingType)
    local data={ID=ID, type=outerThingType}
    Net:TCPSendMessage(7, data)
end
function NetHelper:SendRefreshOuterThing(info)
    local data={info = info or "require"}
    Net:TCPSendMessage(8, data)
end
function NetHelper:SendChangeCurrentRoleAndSkin(role, skin)
    if not role then
        role = require("UserInfoData").currentRole
    end
    if not skin then
        skin = require("UserInfoData").currentSkin
    end
    local data={role=role, skin=skin}
    Net:TCPSendMessage(9, data)
end
function NetHelper:SendLevelReward(levelCount, roomsArray)
    local data={levelCount = levelCount or 1, goldCount=0, souleShardCount=0, AmmoCount=nil, Things=roomsArray}
    Net:TCPSendMessage(10, data)
end

----------------消息回调---------------
function NetHelper:OnTick()
    if self.coroutine then
        StopCoroutine(self.coroutine)
    end
    self.coroutine = StartCoroutine(function ()
        coroutine.yield(UE.WaitForSeconds(self.disconnectTime))
        self.IsConnect = false
        require("SceneManager"):GetMessageBox("您已断开连接。", function () UE.Application.Quit(); end, function ()UE.Application.Quit(); end)
    end)
end

NetHelper:Init()
return NetHelper