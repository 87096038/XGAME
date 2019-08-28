
--[[
    Battle中显示物品
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local MC = require("MessageCenter")

local BattleItemInfoDlg = Class("BattleItemInfoDlg", require("Base"))

function BattleItemInfoDlg:cotr()
    self.super:cotr()
    self.infoPnls = {}
    self.infoPnls[Enum_ItemType.weapon] = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_WeaponInfo, PathMgr.NamePath.UI_WeaponInfo, Main.UIRoot.transform)
    self.infoPnls[Enum_ItemType.equipment] = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_EquipmentInfo, PathMgr.NamePath.UI_EquipmentInfo, Main.UIRoot.transform)
    self.infoPnls[Enum_ItemType.item] = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_ItemInfo, PathMgr.NamePath.UI_ItemInfo, Main.UIRoot.transform)
    self.lerpTime = 0.04
    self.isShowing = false

    ---coroutine
    self.ShowCos = {}
    self.HideCos = {}

    ------------------添加监听-------------------
    MC:AddListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))
end

--- ItemType: Enum_ItemType
function BattleItemInfoDlg:Show(ItemType, name, info, extraInfo)
    if self.isShowing == true then
        return
    end
    self.isShowing = true
    if ItemType == Enum_ItemType.weapon then
        self:SetWeaponPnl(name, extraInfo, info.demage, info.shootCDTime, info.bulletType, info.clipsAmmoCount, info.reloadTime)
    elseif ItemType == Enum_ItemType.equipment then
        self:SetEquipmentPnl(name, info, extraInfo)
    elseif ItemType == Enum_ItemType.item then
        self:SetItemPnl(name, info, extraInfo)
    end
    self.ShowCos[ItemType] = StartCoroutine(function ()
        local time = 0
        local RectTrans = self.infoPnls[ItemType]:GetComponent(typeof(UE.RectTransform))
        local InitPos = UE.Vector2(0, -RectTrans.rect.height/2)
        local targetPos = UE.Vector2(0, RectTrans.rect.height/2+30)
        while RectTrans.anchoredPosition ~= targetPos do
            local position = UE.Vector2.Lerp(InitPos, targetPos, time)
            RectTrans.anchoredPosition = position
            time = time + self.lerpTime
            coroutine.yield(UE.WaitForSeconds(self.lerpTime/5))
        end
    end)
end

function BattleItemInfoDlg:Hide(ItemType)
    self.HideCos[ItemType] = StartCoroutine(function ()
        local time = 0
        local RectTrans = self.infoPnls[ItemType]:GetComponent(typeof(UE.RectTransform))
        local InitPos = UE.Vector2(0, RectTrans.rect.height/2+30)
        local targetPos = UE.Vector2(0, -RectTrans.rect.height/2)
        while RectTrans.anchoredPosition ~= targetPos do
            local position = UE.Vector2.Lerp(InitPos, targetPos, time)
            RectTrans.anchoredPosition = position
            time = time + self.lerpTime
            coroutine.yield(UE.WaitForSeconds(self.lerpTime/5))
        end
    end)
        self.isShowing = false
    end

------------------private------------------
function BattleItemInfoDlg:SetWeaponPnl(name, extraInfo, damage, shootCD, bulletType, clipsAmmoCount, reloadTime)
    local shootSpeed = 1/shootCD
    local bullet = "???"
    if bulletType == Enum_BulletType.light then bullet = "轻"
    elseif bulletType == Enum_BulletType.heavy then bullet = "重"
    elseif bulletType == Enum_BulletType.energy then bullet = "能量"
    elseif bulletType == Enum_BulletType.shell then bullet = "炮弹"
    end
    self.infoPnls[Enum_ItemType.weapon].transform:Find("Name_Txt"):GetComponent(typeof(UE.UI.Text)).text = name
    self.infoPnls[Enum_ItemType.weapon].transform:Find("WeaponInfo_Txt"):GetComponent(typeof(UE.UI.Text)).text = self:GetColorText("子弹类型: ")..bullet..self:GetColorText(" 伤害: ")..damage..self:GetColorText( " 射速: ")..shootSpeed..self:GetColorText("\n弹夹容量: ")..clipsAmmoCount..self:GetColorText(" 换弹时间: ")..reloadTime
    self.infoPnls[Enum_ItemType.weapon].transform:Find("ExtraInfo_Txt"):GetComponent(typeof(UE.UI.Text)).text = extraInfo

end

function BattleItemInfoDlg:SetEquipmentPnl(name, info, extraInfo)
    self.infoPnls[Enum_ItemType.equipment].transform:Find("Name_Txt"):GetComponent(typeof(UE.UI.Text)).text = name
    self.infoPnls[Enum_ItemType.equipment].transform:Find("EquipmentInfo_Txt"):GetComponent(typeof(UE.UI.Text)).text = info
    self.infoPnls[Enum_ItemType.equipment].transform:Find("ExtraInfo_Txt"):GetComponent(typeof(UE.UI.Text)).text = extraInfo
end

function BattleItemInfoDlg:SetItemPnl(name, info, extraInfo)
    self.infoPnls[Enum_ItemType.item].transform:Find("Name_Txt"):GetComponent(typeof(UE.UI.Text)).text = name
    self.infoPnls[Enum_ItemType.item].transform:Find("ItemInfo_Txt"):GetComponent(typeof(UE.UI.Text)).text = info
    self.infoPnls[Enum_ItemType.item].transform:Find("ExtraInfo_Txt"):GetComponent(typeof(UE.UI.Text)).text = extraInfo
end

function BattleItemInfoDlg:GetColorText(info)
    return "<color=#2D78FF>"..info.."</color>"
end

function BattleItemInfoDlg:OnChangeScene(kv)
    for _, v in pairs(self.ShowCos) do
        if v then
            StopCoroutine(v)
        end
    end
    for _, v in pairs(self.HideCos) do
        if v then
            StopCoroutine(v)
        end
    end
    self:Destroy()
end

return BattleItemInfoDlg