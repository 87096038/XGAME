
--[[
    Battle中显示物品
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local BattleItemInfoDlg = Class("BattleItemInfoDlg", require("Base"))

function BattleItemInfoDlg:cotr()
    self.super:cotr()
    self.infoPnls = {}
    self.infoPnls[Enum_ItemType.weapon] = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_WeaponInfo, PathMgr.NamePath.UI_WeaponInfo, Main.UIRoot.transform)
    self.infoPnls[Enum_ItemType.equipment] = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_EquipmentInfo, PathMgr.NamePath.UI_EquipmentInfo, Main.UIRoot.transform)
    self.infoPnls[Enum_ItemType.item] = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_ItemInfo, PathMgr.NamePath.UI_ItemInfo, Main.UIRoot.transform)
    self.isShowing = false
end

--- ItemType: Enum_ItemType
function BattleItemInfoDlg:Show(ItemType, name, info, extraInfo)
    if self.isShowing == true then
        return
    end
    self.isShowing = true
end

function BattleItemInfoDlg:Hide(ItemType, name, info, extraInfo)

    self.isShowing = false
end

------------------private------------------
function BattleItemInfoDlg:SetWeaponPnl(name)

end

function BattleItemInfoDlg:SetEquipmentPnl()
    local _head = "<color=#2D78FF>"
    local _end = "</color>"
end

function BattleItemInfoDlg:SetItemPnl()

end

return BattleItemInfoDlg