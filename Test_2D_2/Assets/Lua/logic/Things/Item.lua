
--[[
    Item的类
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")


local Item = Class("Item", require("Base"))

function Item:cotr(itemID)
    self.super:cotr()

    self.gameobject = ResourceMgr:GetGameObject()
end


function Item:Use()

end

return Item