
--[[
    选择皮肤的Dlg
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Net = require("NetManager")
local MC = require("MessageCenter")

local SkinSelectDlg = Class("SkinSelectDlg", require("Base"))

function SkinSelectDlg:cotr()
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinSelectPnl, PathMgr.NamePath.UI_SkinSelectPnl, Main.UIRoot.transform)
    self.contentObj = self.gameobject:GetComponentInChildren(typeof(UE.UI.HorizontalLayoutGroup)).gameObject
    self.isActive = false

    ----------Skin---------
    local Skin_1 = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinItem, PathMgr.NamePath.UI_SkinItem, self.contentObj.transform)
    Skin_1:GetComponentInChildren(typeof(UE.UI.Text)).text = "皮肤1"
    Skin_1:GetComponent(typeof(UE.UI.Button)).interactable = false
    local Skin_2 = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinItem, PathMgr.NamePath.UI_SkinItem, self.contentObj.transform)
    Skin_2:GetComponentInChildren(typeof(UE.UI.Text)).text = "皮肤2"
    Skin_2:GetComponent(typeof(UE.UI.Button)).interactable = false
    local Skin_3 = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinItem, PathMgr.NamePath.UI_SkinItem, self.contentObj.transform)
    Skin_3:GetComponentInChildren(typeof(UE.UI.Text)).text = "皮肤3"
    Skin_3:GetComponent(typeof(UE.UI.Button)).interactable = false
    local Skin_4 = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinItem, PathMgr.NamePath.UI_SkinItem, self.contentObj.transform)
    Skin_4:GetComponentInChildren(typeof(UE.UI.Text)).text = "皮肤4"
    Skin_4:GetComponent(typeof(UE.UI.Button)).interactable = false
    local Skin_5 = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinItem, PathMgr.NamePath.UI_SkinItem, self.contentObj.transform)
    Skin_5:GetComponentInChildren(typeof(UE.UI.Text)).text = "皮肤5"
    Skin_5:GetComponent(typeof(UE.UI.Button)).interactable = false
    local Skin_6 = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinItem, PathMgr.NamePath.UI_SkinItem, self.contentObj.transform)
    Skin_6:GetComponentInChildren(typeof(UE.UI.Text)).text = "皮肤6"
    Skin_6:GetComponent(typeof(UE.UI.Button)).interactable = false
    self.ownSkin={}
    self.Role_1_AllSkin={Skin_1, Skin_2}
    ---------消息注册----------
    self:AddMessageListener(Enum_MessageType.RefreshSkin, handler(self, self.OnRefreshSkin))
    local data={info = "require"}
    Net:TCPSendMessage(4, data)
end

function SkinSelectDlg:Show()
    self.gameobject:SetActive(true)
    self.isActive = true
end

function SkinSelectDlg:Hide()
    self.gameobject:GetComponentInChildren(typeof(UE.UI.HorizontalLayoutGroup)):GetComponent(typeof(UE.RectTransform)).anchoredPosition = CS.Vector2.zero
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
            MC:SendMessage(Enum_MessageType.ChangeSkin,require("KeyValue"):new(v.type, v.index))
        end)
        btn.interactable = true
    end
end

function SkinSelectDlg:Destroy()
    self.super:Destroy()

end

return SkinSelectDlg