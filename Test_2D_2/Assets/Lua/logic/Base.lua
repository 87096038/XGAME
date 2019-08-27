--[[
    所有class的基类
--]]
local MC = require("MessageCenter")
local Timer = require("Timer")

local Base = Class("Base")

function Base:cotr()

end

--[[
    封装事件监听和updateFunc，是为了方便在使用时，可以只管add不管remove(实际上在Destroy时统一remove)
--]]
-----------------事件监听-----------------
function Base:AddMessageListener(messageType, handler)
    if not self.MessageListenerMap then
        self.MessageListenerMap={}
    end
    self.MessageListenerMap[messageType] = handler
    MC:AddListener(messageType, handler)
end

function Base:DestroyMessageListener(messageType, handler)
    self.MessageListenerMap[messageType] = nil
    MC:RemoveListener(messageType, handler)
end

function Base:DestroyAllMessageListener()
    if not self.MessageListenerMap then
        return
    end
    for k, v in pairs(self.MessageListenerMap) do
        if v then
            MC:RemoveListener(k, v)
        end
    end
    self.MessageListenerMap = {}
end
----------updateFunc-----------
function Base:SetUpdateFunc(func)
    self.updateFunc = func
    Timer:AddUpdateFuc(self, func)
end

function Base:RemoveUpdateFunc()
    if self.updateFunc then
        Timer:RemoveUpdateFuc(self,self.updateFunc)
    end
end

------------销毁实例时必须调用该函数-----------
function Base:Destroy()
    self:DestroyAllMessageListener()
    self:RemoveUpdateFunc()
end

return Base