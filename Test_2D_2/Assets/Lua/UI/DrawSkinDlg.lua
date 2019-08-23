
--[[
    抽卡的dlg
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Net = require("NetManager")
local MC = require("MessageCenter")
local NetHelper = require("NetHelper")

local DrawSkinDlg = Class("DrawSkinDlg", require("Base"))

function DrawSkinDlg:cotr()
    self.super:cotr()
    local isNew
    self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_DrawCardPnl, PathMgr.NamePath.UI_DrawCardPnl, Main.UIRoot.transform)
    self.resultPnlObj = self.gameobject.transform:Find("Result").gameObject
    self.waiPnlObj = self.gameobject.transform:Find("WaitForResult").gameObject
    self.contentObj = self.resultPnlObj:GetComponentInChildren(typeof(UE.UI.GridLayoutGroup)).gameObject
    self.Draw_btn = self.gameobject.transform:Find("Draw_btn"):GetComponent(typeof(UE.UI.Button))

    if isNew then
        self.gameobject.transform:Find("Exit"):GetComponent(typeof(UE.UI.Button)).onClick:AddListener(function ()
            self:Hide()
        end)
        self.Draw_btn.onClick:AddListener(function ()
            self:DrawSkin()
        end)
    end

    -------------注册监听----------
    self:AddMessageListener(Enum_NormalMessageType.DrawSkin, handler(self, self.OnDrawSkin))
end

--- 抽皮肤
function DrawSkinDlg:DrawSkin()
    self.Draw_btn.interactable = false
    self.waiPnlObj:SetActive(true)
    NetHelper:SendDrawSkin(Enum_DrawCountType.single)

end

function DrawSkinDlg:Show()
    self.gameobject:SetActive(true)
end

function DrawSkinDlg:Hide()
    self.resultPnlObj:SetActive(false)
    self.gameobject:SetActive(false)
    for i=1, self.contentObj.transform.childCount do
        --- GetChild的index从0开始
        ResourceMgr:DestroyObject(self.contentObj.transform:GetChild(i-1).gameObject)
    end
end

function DrawSkinDlg:Destroy()
    self.super:Destroy()

end

function DrawSkinDlg:OnDrawSkin(kv)
    if kv.Value then
        self.waiPnlObj:SetActive(false)
        if kv.Value.response == Enum_DrawResponseType.NotEnoughDiamond then
            require("SceneManager"):GetMessageBox("钻石不够~")
        elseif kv.Value.response == Enum_DrawResponseType.Success then
            --- 显示抽到的东西
            self.resultPnlObj:SetActive(true)
            for k, v in pairs(kv.Value.skin) do
                local skinIcon = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_IconItem, PathMgr.NamePath.UI_IconItem, self.contentObj.transform)
                local skinData = require("SkinData").Skins[v.roleType][v.index]
                if skinData.spritePath then
                    skinIcon:GetComponent(typeof(UE.UI.Image)).sprite = ResourceMgr:Load(skinData.spritePath, skinData.spriteName, typeof(UE.Sprite))
                else
                    skinIcon:GetComponentInChildren(typeof(UE.UI.Text)).text = "皮肤"
                end
            end
        end
    end
    self.Draw_btn.interactable = true
end

return DrawSkinDlg