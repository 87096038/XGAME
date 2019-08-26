
--[[
    Equipment的类
--]]
local EquipmentData = require("EquipmentData")

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local MC = require("MessageCenter")

local Equipment=Class("Equipment", require("Base"))

function Equipment:cotr(equipmentID, position)
    self.super:cotr()
    local data = EquipmentData.Equipments[equipmentID]
    self.gameobject = ResourceMgr:GetGameObject(data.PrefabPath, data.PrefabName, nil, position)
    self.name = data.name
    self.info = data.info
    self.extraInfo = data.extraInfo
    self.isPacked = false
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
    MC:SendMessage(Enum_NormalMessageType.PickUp, require("KeyValue"):new(Enum_ItemType.equipment, self))
    self.isPacked = true
end

return Equipment