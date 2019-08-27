
--[[
    持有的Items所放的Container
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local MC = require("MessageCenter")

local ItemsContainerDlg = Class("ItemsContainerDlg", require("Base"))

function ItemsContainerDlg:cotr()
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_ItemsContainer, PathMgr.NamePath.UI_ItemsContainer, Main.UIRoot.transform)
    self.containerTrans = self.gameobject.transform:Find("Content")
    self.infoPnlObj = self.gameobject.transform:Find("Info").gameObject
    self.infoPnlRect = self.infoPnlObj:GetComponent(typeof(UE.RectTransform))
    self.borderTrans = self.gameobject.transform:Find("Border")
    self.infoTxt = self.infoPnlObj.transform:Find("Text"):GetComponent(typeof(UE.UI.Text))
    self.Items={}
end

function ItemsContainerDlg:AddItem(item)
    if not item then
        return
    end
    table.insert(self.Items, item)
    local sprite = item.gameobject:GetComponent(typeof(UE.SpriteRenderer)).sprite
    ----动态创建物体----
    local info = UE.GameObject()
    info:AddComponent(typeof(UE.RectTransform))
    info.transform:SetParent(self.containerTrans)

    local img = info:AddComponent(typeof(UE.UI.Image))
    img.sprite = sprite
    local trigger = info:AddComponent(typeof(UE.EventSystems.EventTrigger))
    --- 进入事件
    local Entry_Enter = UE.EventSystems.EventTrigger.Entry()
    Entry_Enter.eventID = UE.EventSystems.EventTriggerType.PointerEnter;
    Entry_Enter.callback:AddListener(function (eventData)
        self.infoTxt.text = item.info
        self.infoPnlObj:SetActive(true)
        self:SetUpdateFunc(self.UpdateShowInfo)
    end);
    trigger.triggers:Add(Entry_Enter)
    ---出去事件
    local Entry_Exit = UE.EventSystems.EventTrigger.Entry()
    Entry_Exit.eventID = UE.EventSystems.EventTriggerType.PointerExit;
    Entry_Exit.callback:AddListener(function (eventData)
        self.infoPnlObj:SetActive(false)
        self:RemoveUpdateFunc(self.UpdateShowInfo)
    end);
    trigger.triggers:Add(Entry_Exit)
    ---点击事件
    local Entry_Click= UE.EventSystems.EventTrigger.Entry()
    Entry_Click.eventID = UE.EventSystems.EventTriggerType.PointerClick;
    Entry_Click.callback:AddListener(function (eventData)
        if eventData.button == UE.EventSystems.PointerEventData.InputButton.Left then
            self.borderTrans.position = info.transform.position
            MC:SendMessage(Enum_NormalMessageType.SelectItem, require("KeyValue"):new(nil, item))
        end
    end);
    trigger.triggers:Add(Entry_Click)
    if #self.Items == 1 then
        --- GridLayOut的自动布局不会即时生效，所以等到此帧结束再取其中元素(info)的位置
        StartCoroutine(function ()
            coroutine.yield(UE.WaitForEndOfFrame())
            self.borderTrans.gameObject:SetActive(true)
            self.borderTrans.position = info.transform.position
        end)

    end
end

function ItemsContainerDlg:RemoveItem(item)
    for k, v in ipairs(self.Items) do
        if v == item then
            table.remove(self.Items, k)
            ResourceMgr:DestroyObject(self.containerTrans:GetChild(k-1).gameObject, true)
            if #self.Items <= 0 then
                self.borderTrans.gameObject:SetActive(false)
            else
                --- GridLayOut的自动布局不会即时生效，所以等到此帧结束再取其中元素(info)的位置
                StartCoroutine(function ()
                    coroutine.yield(UE.WaitForEndOfFrame())
                    self.borderTrans.position = self.containerTrans:GetChild(0).position
                end)
            end
        end
    end

end

function ItemsContainerDlg:UpdateShowInfo()
    self.infoPnlRect.position = UE.Vector3(UE.Input.mousePosition.x+2, UE.Input.mousePosition.y-2, 0);
end

return ItemsContainerDlg