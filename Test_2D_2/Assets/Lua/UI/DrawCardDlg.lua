
--[[
    抽卡的dlg
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Net = require("NetManager")
local MC = require("MessageCenter")

local DrawCardDlg = Class("DrawCardDlg", require("Base"))

function DrawCardDlg:cotr()
    self.super:cotr()
    local isNew
    self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_DrawCardPnl, PathMgr.NamePath.UI_DrawCardPnl, Main.UIRoot.transform)
    self.resultPnlObj = self.gameobject.transform:Find("Result").gameObject
    self.waiPnlObj = self.gameobject.transform:Find("WaitForResult").gameObject
    self.Draw_btn = self.gameobject.transform:Find("Draw_btn"):GetComponent(typeof(UE.UI.Button))
    if isNew then
        self.gameobject.transform:Find("Exit"):GetComponent(typeof(UE.UI.Button)).onClick:AddListener(function ()
            self:Hide()
        end)
        self.Draw_btn.onClick:AddListener(function ()
            self:DrawCard()
        end)
    end

    -------------注册监听----------
    self:AddMessageListener(Enum_MessageType.DrawSkin, handler(self, self.OnDrawSkin))
end

function DrawCardDlg:DrawCard()
    self.Draw_btn.interactable = false
    self.waiPnlObj:SetActive(true)
    local data = {type=1, skin = nil}
    Net:TCPSendMessage(3, data)
end

function DrawCardDlg:Show()
    self.gameobject:SetActive(true)
end

function DrawCardDlg:Hide()
    self.resultPnlObj:SetActive(false)
    self.gameobject:SetActive(false)
end

function DrawCardDlg:Destroy()
    self.super:Destroy()

end

function DrawCardDlg:OnDrawSkin(kv)
    if kv.Value then
        self.waiPnlObj:SetActive(false)
        self.resultPnlObj:SetActive(true)
        if kv.Value.index == 2 then
            self.resultPnlObj:GetComponent(typeof(UE.UI.Text)).text = "皮肤2"
        end
        ---刷新Skin
        local data={info = "require"}
        Net:TCPSendMessage(4, data)
    end
    self.Draw_btn.interactable = true
end

return DrawCardDlg