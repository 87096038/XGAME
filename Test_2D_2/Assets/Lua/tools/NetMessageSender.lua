--[[
    封装网络消息的发送, 向上提供有限接口
--]]

local Net = require("NetManager")

local NetMessageSender={}

function NetMessageSender:Init()

end

function NetMessageSender:SendLogin(userName, password)
    local data = {userName=userName, password=password, response=false}
    Net:TCPSendMessage(1 , data)
end

function NetMessageSender:SendDrawSkin(countType)
    local data = {type=countType, skin = nil, response=-1}
    Net:TCPSendMessage(3, data)
end

function NetMessageSender:SendRefreshSkin(info)
    local data={info = info}
    Net:TCPSendMessage(4, data)
end

function NetMessageSender:SendRefreshCurrency(info)
    local data={info = info, diamond = 0, soulShard= 0}
    Net:TCPSendMessage(5, data)
end

NetMessageSender:Init()
return NetMessageSender