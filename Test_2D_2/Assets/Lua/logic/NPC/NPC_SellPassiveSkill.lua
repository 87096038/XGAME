
--[[
    卖被动的NPC
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local MC= require("MessageCenter")
local UserData = require("UserInfoData")
local PassiveSkill = require("PassiveSkillData")
local NetHelper = require("NetHelper")

local NPC_SellPassiveSkill ={}

function NPC_SellPassiveSkill:Init()
    self.position = UE.Vector3(4, 5, -1)
    self.lerpTime = 0.04
    self.type = Enum_NPCType.sell_passive_skill

    self.gameobject = nil
    self.SelledItems = {}
    self.SelledItemsTrans = nil
    self.focusItem = nil
    ----infoPnl-------
    self.infoPnl = nil
    self.infoPnlTitle = nil
    self.infoPnlContent = nil
    self.infoPnlPrice = nil

    ---coroutine
    self.showCo = nil
    self.hideCo = nil
    ------------------添加监听-------------------
    MC:AddListener(Enum_NormalMessageType.RefreshOuterThing, handler(self, self.OnRefreshOuterThing))
    MC:AddListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))
end

function NPC_SellPassiveSkill:Generate()
    if not CS.Util.IsNull(self.gameobject) then
        return
    end
    local isNew
    self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.NPC_SellPassiveSkill, PathMgr.NamePath.NPC_SellPassiveSkill, nil, self.position)
    self.infoPnl = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_PassiveSkillInfo, PathMgr.NamePath.UI_PassiveSkillInfo, Main.UIRoot.transform)
    self.infoPnlTitle = self.infoPnl.transform:Find("Title_Txt"):GetComponent(typeof(UE.UI.Text))
    self.infoPnlContent = self.infoPnl.transform:Find("ItemInfo_Txt"):GetComponent(typeof(UE.UI.Text))
    self.infoPnlPrice = self.infoPnl.transform:Find("Price"):GetComponentInChildren(typeof(UE.UI.Text))
    self.SelledItemsTrans = self.gameobject.transform:Find("Container"):GetComponentsInChildren(typeof(UE.Transform))

    -------------------绑定碰撞------------------
    local thisNPC = self
    for i = 1, 3 do
        self.collsion = self.SelledItemsTrans[i].gameObject:GetComponent(typeof(CS.Collision))
        if not self.collsion then
            self.collsion = self.SelledItemsTrans[i].gameObject:AddComponent(typeof(CS.Collision))
        end
        self.collsion.CollisionHandle = function(self, type, other)
            if type == Enum_CollisionType.TriggerEnter2D then
                if other.gameObject.layer ==  9 then
                    if not thisNPC.SelledItems[i] then
                        return
                    end
                    thisNPC.focusItem = thisNPC.SelledItems[i]
                    thisNPC:ShowInfoPnl(i)
                    MC:SendMessage(Enum_NormalMessageType.ApproachNPC, require("KeyValue"):new(thisNPC.type, thisNPC))
                end
            elseif type == Enum_CollisionType.TriggerExit2D then
                if other.gameObject.layer ==  9 then
                    if not thisNPC.SelledItems[i] then
                        return
                    end
                    thisNPC.focusItem = nil
                    thisNPC:HideInfoPnl(i)
                    MC:SendMessage(Enum_NormalMessageType.LeaveNPC, require("KeyValue"):new(thisNPC.type, thisNPC))
                end
            end
        end
    end

    self:GenerateItems()
end

--- 生成售卖的物体
function NPC_SellPassiveSkill:GenerateItems()
    local skills = self:GetReasonableItems(3)
    for i=1, 3 do
        if skills[i] then
            local skill = PassiveSkill.Skills[skills[i]]
            table.insert(self.SelledItems, skill)
            if skill.AtlasName then
                local atlas = ResourceMgr:Load(skill.IconResourcePath, skill.IconResourceName, typeof(UE.U2D.SpriteAtlas))
                if atlas then
                    self.SelledItemsTrans[i]:GetComponent(typeof(UE.SpriteRenderer)).sprite = atlas:GetSprite(skill.AtlasName)
                end
            else
                self.SelledItemsTrans[i]:GetComponent(typeof(UE.SpriteRenderer)).sprite = ResourceMgr:Load(skill.IconResourcePath, skill.IconResourceName, typeof(UE.Sprite))
            end
        else
            --- 这里写死了卖完的图，记得改
            local atlas = ResourceMgr:Load(PathMgr.ResourcePath.SpriteAtlas_Icons, PathMgr.NamePath.SpriteAtlas_Icons, typeof(UE.U2D.SpriteAtlas))
            if atlas then
                self.SelledItemsTrans[i]:GetComponent(typeof(UE.SpriteRenderer)).sprite = atlas:GetSprite("Icon_SelledOut")
            end
        end
    end
end

--- 返回count个合理的Unlocked物体
---isCurrentOut: 是否将当前持有的排除在外
function NPC_SellPassiveSkill:GetReasonableItems(count ,isCurrentOut)
    local lockedSkill = {}
    for _, v in ipairs(UserData.LockedPassiveSkills) do
        table.insert(lockedSkill, v)
    end
    if isCurrentOut then
        for _, v in pairs(self.SelledItems) do
            local i = 1
            while i <= #lockedSkill do
                if v.ID == lockedSkill[i] then
                    table.remove(lockedSkill, i)
                else
                    i = i+1
                end
            end
        end
    end
    --- 将所有可以出现的都放入skillsPool
    local skillsPool = {}
    for _, v in pairs(lockedSkill) do
        local preID = PassiveSkill.Skills[v].preID
        if preID == -1 then
            table.insert(skillsPool, v)
        else
            for _, v1 in pairs(UserData.UnlockedPassiveSkills)do
                if v1 == preID then
                    table.insert(skillsPool, v)
                    break
                end
            end
        end
    end

    --- 开始选择
    local skills = {}
    --- 小于或等于count就不用选了
    if #skillsPool <= count then
        return skillsPool
    else
        local line = count/(#skillsPool)
        while #skills < count do
            for k, v in pairs(skillsPool) do
                if math.random() <= line then
                    table.insert(skills, v)
                    table.remove(skillsPool, k)
                end
            end
        end
    end
    local result = {}
    for i=1, count do
        table.insert(result, skills[i])
    end
    return result
end

function NPC_SellPassiveSkill:ShowInfoPnl(index)
    self.infoPnlTitle.text = self.SelledItems[index].name
    self.infoPnlContent.text = self.SelledItems[index].info
    self.infoPnlPrice.text = self.SelledItems[index].cost
    StartCoroutine(function ()
        local time = 0
        local RectTrans = self.infoPnl:GetComponent(typeof(UE.RectTransform))
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

function NPC_SellPassiveSkill:HideInfoPnl(index)
    StartCoroutine(function ()
        local time = 0
        local RectTrans = self.infoPnl:GetComponent(typeof(UE.RectTransform))
        local InitPos = UE.Vector2(0, RectTrans.rect.height/2+30)
        local targetPos = UE.Vector2(0, -RectTrans.rect.height/2)
        while RectTrans.anchoredPosition ~= targetPos do
            local position = UE.Vector2.Lerp(InitPos, targetPos, time)
            RectTrans.anchoredPosition = position
            time = time + self.lerpTime
            coroutine.yield(UE.WaitForSeconds(self.lerpTime/5))
        end
    end)
end

function NPC_SellPassiveSkill:Use()
    if self.focusItem then
        NetHelper:SendBuyOuterThing(self.focusItem.ID, Enum_OuterThingType.passiveSkill)
    end
end

-----------------消息回调--------------
function NPC_SellPassiveSkill:OnRefreshOuterThing(kv)
    if not self.gameobject then
        return
    end
    for i=1, 3 do
        if self.SelledItems[i] then
            local flag = true
            for _, v in ipairs(UserData.LockedPassiveSkills) do
                if self.SelledItems[i].ID == v then
                    flag = false
                    break
                end
            end

            if flag then
                self:HideInfoPnl(i)
                self.SelledItems[i] = nil
                local newOne = self:GetReasonableItems(1, true)
                if newOne[1] then
                    local skill = PassiveSkill.Skills[newOne[1]]
                    self.SelledItems[i] = skill
                    if skill.AtlasName then
                        local atlas = ResourceMgr:Load(skill.IconResourcePath, skill.IconResourceName, typeof(UE.U2D.SpriteAtlas))
                        if atlas then
                            self.SelledItemsTrans[i]:GetComponent(typeof(UE.SpriteRenderer)).sprite = atlas:GetSprite(skill.AtlasName)
                        end
                    else
                        self.SelledItemsTrans[i]:GetComponent(typeof(UE.SpriteRenderer)).sprite = ResourceMgr:Load(skill.IconResourcePath, skill.IconResourceName, typeof(UE.Sprite))
                    end
                else
                    --- 这里写死了卖完的图，记得改
                    local atlas = ResourceMgr:Load(PathMgr.ResourcePath.SpriteAtlas_Icons, PathMgr.NamePath.SpriteAtlas_Icons, typeof(UE.U2D.SpriteAtlas))
                    if atlas then
                        self.SelledItemsTrans[i]:GetComponent(typeof(UE.SpriteRenderer)).sprite = atlas:GetSprite("Icon_SelledOut")
                    end
                end
            end
        end
    end
end

function NPC_SellPassiveSkill:OnChangeScene(kv)
    if self.showCo then
        StopCoroutine(self.showCo)
    end
    if self.hideCo then
        StopCoroutine(self.hideCo)
    end
end

NPC_SellPassiveSkill:Init()
return NPC_SellPassiveSkill