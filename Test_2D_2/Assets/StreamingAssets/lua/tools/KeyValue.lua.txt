--[[
    用于传输信息
--]]
local KeyValue = Class("KeyValue")

function KeyValue:cotr(key, value)
    self.Key = key or ""
    self.Value = value or CS.null
end

function KeyValue:Update(key, value)
    self.Key = key or self.Key
    self.Value = value or self.Value
end

return KeyValue