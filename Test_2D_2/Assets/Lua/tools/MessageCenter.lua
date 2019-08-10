--[[
    信息传输中心
--]]
local MessageCenter={}

--- 包装类，用于包装实例的函数
function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function MessageCenter:Init()
    --- 因为在传递物体时会有转换，所以抛弃了C#的委托，自己做了个类似的
    --- 因为加入用的insert，删除用的remove，所以遍历时可直接用ipairs
    self.ListenerMap = {}
end

function MessageCenter:AddListener(messageType, handler)
    if messageType and handler then
        if type(handler) == "function" then
            if self.ListenerMap[messageType] == nil then
                self.ListenerMap[messageType] = {handler}
            else
                table.insert( self.ListenerMap[messageType], handler)
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
            for k, v in ipairs(self.ListenerMap[messageType])do
                if v == handler then
                     table.remove(self.ListenerMap[messageType], k)
                end
            end
        else
            print("Fail to remove listener: MessageMap dont have such messageType or listener!")
        end
    end
end

function MessageCenter:RemoveMessageType(messageType)
    if messageType and self.ListenerMap[messageType] ~= nil then
        self.ListenerMap[messageType] = nil
    else
        print("Fail to remove message type: no such type!")
    end
end

function MessageCenter:SendMessage(messageType, kv)
    if self.ListenerMap[messageType] ~= nil then
        for _, v in ipairs(self.ListenerMap[messageType])do
            if v then
                v(kv)
            end
        end
    else
        print("Fail to send message: no one receive message type: "..messageType)
    end
end

MessageCenter:Init()

return MessageCenter