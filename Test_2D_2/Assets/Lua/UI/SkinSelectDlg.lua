﻿
--[[
    选择皮肤的Dlg
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Net = require("NetManager")
local MC = require("MessageCenter")
local NetHelper = require("NetHelper")

local SkinSelectDlg = Class("SkinSelectDlg", require("Base"))

function SkinSelectDlg:cotr()
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinSelectPnl, PathMgr.NamePath.UI_SkinSelectPnl, Main.UIRoot.transform)
    self.contentObj = self.gameobject:GetComponentInChildren(typeof(UE.UI.HorizontalLayoutGroup)).gameObject
    self.isActive = false

    ----------Role---------
    local Role_1 = {}

    ----------Skin---------
    self.ownSkin={}
    self.Role_1_AllSkin={}

    for k, v in ipairs(require("SkinData").Skins[Enum_RoleType.Adventurer_1])do
        local skin = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinItem, PathMgr.NamePath.UI_SkinItem, self.contentObj.transform)
        local skinImg = skin:GetComponent(typeof(UE.UI.Image))
        if v.spritePath then
            skinImg:GetComponent(typeof(UE.UI.Image)).sprite = ResourceMgr:Load(v.spritePath, v.spriteName, typeof(UE.Sprite))
        else
            skinImg:GetComponentInChildren(typeof(UE.UI.Text)).text = "皮肤"
        end
        skin:GetComponent(typeof(UE.UI.Button)).interactable = false
        table.insert(self.Role_1_AllSkin, skin)
    end
    ---------消息注册----------
    self:AddMessageListener(Enum_MessageType.RefreshSkin, handler(self, self.OnRefreshSkin))
    NetHelper:SendRefreshSkin("require")
end

function SkinSelectDlg:Show()
    self.gameobject:SetActive(true)
    self.isActive = true
end

function SkinSelectDlg:Hide()
    self.contentObj:GetComponent(typeof(UE.RectTransform)).anchoredPosition = CS.Vector2.zero
    self.gameobject:SetActive(false)
    self.isActive = false
end

function SkinSelectDlg:OnRefreshSkin(kv)
    self.ownSkin={}
    for k, v in pairs(kv.Value.ownSkin)do
        table.insert(self.ownSkin, v)
    end
    for k,v in pairs(self.ownSkin)do
        local btn = self.Role_1_AllSkin[v.index]:GetComponent(typeof(UE.UI.Button))
        btn.onClick:RemoveAllListeners()
        btn.onClick:AddListener(function ()
            MC:SendMessage(Enum_MessageType.ChangeSkin,require("KeyValue"):new(v.roleType, v.index))
        end)
        btn.interactable = true
    end
end

function SkinSelectDlg:Destroy()
    self.super:Destroy()
end

return SkinSelectDlg