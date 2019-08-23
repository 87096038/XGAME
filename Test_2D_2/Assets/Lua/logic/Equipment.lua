
--[[
    Equipment的类
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local EquipmentData = require("EquipmentData")

local Equipment=Class("Equipment", require("Base"))

function Equipment:cotr(equipmentID, position)
    self.super:cotr()
    local data = EquipmentData.Equipments[equipmentID]
    self.gameobject = ResourceMgr:GetGameObject(data.PrefabPath, data.PrefabName, nil, position)

    ---------------绑定碰撞------------
    --self.collsion = self.gameobject:GetComponent(typeof(CS.Collision))
    --if not self.collsion then
    --    self.collsion = self.gameobject:AddComponent(typeof(CS.Collision))
    --end
    --self.collsion.CollisionHandle = function(self, type, other)
    --    if type == Enum_CollisionType.TriggerEnter2D then
    --        local layer = other.gameObject.layer
    --        --- 主角
    --        if layer == 9 then
--
    --        end
    --    end
    --end
end

function Equipment:Use()

end

return Equipment