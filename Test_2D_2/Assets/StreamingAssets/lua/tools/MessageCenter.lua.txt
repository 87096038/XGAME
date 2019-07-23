--[[
    信息传输中心
--]]
local MessageCenter={}

function MessageCenter:Init()
    self.ListenerMap = {}
end

function MessageCenter:AddListener(messageType, handler)
    if messageType and handler then
        if type(handler) == "function" then
            if self.ListenerMap[messageType] == nil then
                self.ListenerMap[messageType] = CS.MessageDelivery(handler)
            else
                self.ListenerMap[messageType] = self.ListenerMap[messageType] + handler
            end
        else
            print("Fail to AddListener: wrong handler type!")
        end
    else
        print("Fail to AddListener: nil messageType or handler")
    end
end

function MessageCenter:RemoveListener(messageType, handler)
    if messageType and handler then
        if self.ListenerMap[messageType] ~= nil then
            self.ListenerMap[messageType] = self.ListenerMap[messageType] - handler
            print(self.ListenerMap[messageType])
        else
            print("Fail to remove listener: MessageMap dont have such messageType or listener!")
        end
    end
end

function MessageCenter:RemoveMessageType(messageType)
    if messageType and self.ListenerMap[messageType] ~= nil then
        self.ListenerMap[messageType] = nil
    else
        print("Fail to remove message type!")
    end
end

function MessageCenter:SendMessage(messageType, kv)
    if self.ListenerMap[messageType] ~= nil then
        self.ListenerMap[messageType](kv)
    else
        print("Fail to send message: no one receive message type: "..messageType)
    end
end

MessageCenter:Init()

return MessageCenter