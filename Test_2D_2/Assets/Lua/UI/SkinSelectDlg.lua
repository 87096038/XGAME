
--[[
    选择皮肤的Dlg
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Net = require("NetManager")

local SkinSelectDlg = Class("SkinSelectDlg", require("Base"))

function SkinSelectDlg:cotr()
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_SkinSelectPnl, PathMgr.NamePath.UI_SkinSelectPnl, Main.UIRoot.transform)
    self.contentObj = self.gameobject:GetComponentInChildren(typeof(UE.UI.HorizontalLayoutGroup)).gameObject
    self.isActive = false

    local data={info = "require"}
    ----------Skin---------
    self.Skin={}

    ---------消息注册----------
    self:AddMessageListener(Enum_MessageType.RefreshSkin, handler(self, self.OnRefreshSkin))

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
    print("Refreshhaha")
end

function SkinSelectDlg:Destroy()
    self.super:Destroy()

end

return SkinSelectDlg