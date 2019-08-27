
--[[
    Item的类
--]]
local ResourceMgr = require("ResourceManager")
local MC = require("MessageCenter")
local ItemData = require("ItemData")

local Item = Class("Item", require("Base"))

function Item:cotr(itemID, position)
    self.super:cotr()
    local data = ItemData.Items[itemID]
    self.gameobject = ResourceMgr:GetGameObject(data.PrefabPath, data.PrefabName, nil, position)
    self.collsion =  self.gameobject:GetComponentInChildren(typeof(UE.BoxCollider2D))
    self.type = data.type
    self.name = data.name
    self.info = data.info
    self.extraInfo = data.extraInfo
    self.buff = data.buff
    self.isPacked = false
end


function Item:Use()
    self.collsion.enabled = false
    MC:SendMessage(Enum_NormalMessageType.PickUp, require("KeyValue"):new(Enum_ItemType.item, self))
    self.gameobject:SetActive(false)
    self.isPacked = true
end

function Item:Drop()
    self.gameobject:SetActive(true)
    self.collsion.enabled = true
    self.isPacked = false
end

return Item