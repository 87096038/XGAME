--[[
    封装网络消息的发送, 向上提供有限接口
--]]

local Net = require("NetManager")

local NetHelper={}

function NetHelper:Init()

end

function NetHelper:TCPConnect()
    return Net:TCPConnect()
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
    Net:TCPSendMessage(1 , data)
end

function NetHelper:SendDrawSkin(countType)
    local data = {type=countType, skin = nil, response=-1}
    Net:TCPSendMessage(3, data)
end

function NetHelper:SendRefreshSkin(info)
    local data={info = info}
    Net:TCPSendMessage(4, data)
end

function NetHelper:SendRefreshCurrency(info)
    local data={info = info, diamond = 0, soulShard= 0}
    Net:TCPSendMessage(5, data)
end

NetHelper:Init()
return NetHelper