
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
    self.collsion =  self.gameobject:GetComponentInChildren(typeof(UE.BoxCollider2D))
    self.type = data.type
    self.name = data.name
    self.info = data.info
    self.extraInfo = data.extraInfo
    self.buff = data.buff
    self.icon = self.gameobject:GetComponentInChildren(typeof(UE.SpriteRenderer)).sprite
    self.isPacked = false
end

function Equipment:Use()
    self.collsion.enabled = false
    MC:SendMessage(Enum_NormalMessageType.PickUp, require("KeyValue"):new(Enum_ItemType.equipment, self))
    self.gameobject:SetActive(false)
    self.isPacked = true
end

function Equipment:Drop()
    self.collsion.enabled = true
    self.gameobject:SetActive(true)
    self.isPacked = false
end

return Equipment