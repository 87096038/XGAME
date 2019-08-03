--[[
    所有class的基类
--]]
local MC = require("MessageCenter")

local Base = Class("Base")

function Base:cotr()
    self.MessageListenerMap={}
end

--[[
    封装事件监听，是为了方便在使用时，可以只管add不管remove(实际上在Destroy时统一remove)
--]]
-----------------事件监听-----------------
function Base:AddMessageListener(messageType, handler)
    self.MessageListenerMap[messageType] = handler
    MC:AddListener(messageType, handler)
end

function Base:DestroyMessageListener(messageType, handler)
    self.MessageListenerMap[messageType] = nil
    MC:RemoveListener(messageType, handler)
end

function Base:DestroyAllMessageListener()
    for k, v in pairs(self.MessageListenerMap) do
        if v then
            MC:RemoveListener(k, v)
        end
    end
    self.MessageListenerMap = {}
end

------------销毁实例时必须调用该函数-----------
function Base:Destroy()
    self:DestroyAllMessageListener()
end

return Base