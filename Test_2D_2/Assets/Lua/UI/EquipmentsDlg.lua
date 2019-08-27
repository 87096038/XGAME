
--[[
    放Equipment的Dlg
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local EquipmentsDlg = Class("EquipmentsDlg", require("Base"))

function EquipmentsDlg:cotr(sprite)
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Equipments, PathMgr.NamePath.UI_Equipments, Main.UIRoot.transform)
    self.image = self.gameobject:GetComponentInChildren(typeof(UE.UI.Image))
    if sprite then
        self.image.sprite = sprite
    end
end

function EquipmentsDlg:ChangeSprite(newSprite)
    if newSprite then
        self.image.sprite = newSprite
    end
end

function EquipmentsDlg:RemoveSprite()
    self.image.sprite = nil
end

return EquipmentsDlg