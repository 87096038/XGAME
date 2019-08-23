local RoleData = require("RoleData")
local SkinData = require("SkinData")
local UserData = require("UserInfoData")
local PassiveSkillData = require("PassiveSkillData")
local BuffData = require("BuffData")

local Timer = require("Timer")
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local MC = require("MessageCenter")

local character_base = require("character_base")
local Character=Class("Character", character_base)

function Character:cotr()
    self.super:cotr()
    self.Left = UE.Vector3(-1, 1, 1)
    self.Right = UE.Vector3(1, 1, 1)

    -----------gameobject---------
    self.super:cotr()
    local mainRole =  ResourceMgr:GetGameObject(PathMgr.ResourcePath.Character_1, PathMgr.NamePath.Character_1)
    self.gameobject = mainRole.transform:Find("Role").gameObject

    --------------绑定碰撞--------------
    self.collsion = self.gameobject:GetComponent(typeof(CS.Collision))
    if not self.collsion then
        self.collsion = self.gameobject:AddComponent(typeof(CS.Collision))
    end
    self.collsion.CollisionHandle = self.OnCollision
    ------------设置成员变量--------------
    self.currentRole = RoleData.Roles[UserData.currentRole.type]
    self.currentSkin = SkinData.Skins[UserData.currentSkin.roleType][UserData.currentSkin.index]

    self.rigidbody2d = self.gameobject:GetComponent("Rigidbody2D")
    self.transform = self.gameobject:GetComponent("Transform")
    self.animatior = self.gameobject:GetComponent("Animator")

    -----------状态数据----------
    self.state = require("CharacterState"):new()
    ---缓存被动技能
    self.passiveSkillCache = {}
    for k,v in pairs(UserData.UnlockedPassiveSkills) do
        table.insert(self.passiveSkillCache, v)
    end
    --- 添加被动技能
    for k,v in pairs(UserData.UnlockedPassiveSkills) do
        self.state:AddBuff(PassiveSkillData.Skills[v].buff)
    end
    --- 设置属性
    self.maxHeath = (self.currentRole.basicHeath + self.state.States[Enum_CharacterStateChangeType.number][Enum_CharacterStateSpecificChangeType.heath])*self.state.States[Enum_CharacterStateChangeType.percent][Enum_CharacterStateSpecificChangeType.heath]
    self.maxArmor = (self.currentRole.basicArmor + self.state.States[Enum_CharacterStateChangeType.number][Enum_CharacterStateSpecificChangeType.armor])*self.state.States[Enum_CharacterStateChangeType.percent][Enum_CharacterStateSpecificChangeType.armor]
    self.speed = (self.currentRole.basicSpeed + self.state.States[Enum_CharacterStateChangeType.number][Enum_CharacterStateSpecificChangeType.speed])*self.state.States[Enum_CharacterStateChangeType.percent][Enum_CharacterStateSpecificChangeType.speed]
    self.currentHeath = self.maxHeath
    self.currentArmor = self.maxArmor

    --- 每秒计算Buff的函数
    self.calcBuffPerSecond = nil
    ---------监听注册--------
    self:AddMessageListener(Enum_NormalMessageType.ChangeSkin, handler(self, self.OnChangeSkin))
    self:AddMessageListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))
    self:AddMessageListener(Enum_NormalMessageType.PickUp, handler(self, self.OnPickUp))
    self:AddMessageListener(Enum_NormalMessageType.RefreshOuterThing, handler(self, self.OnRefreshOuterThing))
    self:AddMessageListener(Enum_NormalMessageType.AddKeepBuff, handler(self, self.OnAddKeepBuff))
    self:AddMessageListener(Enum_NormalMessageType.RemoveKeepBuff, handler(self, self.OnRemoveKeepBuff))


end

function Character:Start()
    self:SetUpdateFunc(self.Update)
end

--- 加入update的函数
function Character:Update()
    self:Move()
end

--- 被Character.Update调用
function Character:Move()
    local horizontal = UE.Input.GetAxisRaw("Horizontal")
    local vertical = UE.Input.GetAxisRaw("Vertical")

    if horizontal ~= 0 or vertical ~= 0 then
        self.animatior:SetFloat("Speed", 0.2)
        if horizontal > 0 then
            self.transform.localScale = self.Right
        elseif horizontal < 0 then
            self.transform.localScale = self.Left
        end
        local position = self.rigidbody2d.position
        position.x = position.x + self.speed * horizontal * Timer.deltaTime
        position.y = position.y + self.speed * vertical * Timer.deltaTime

        self.rigidbody2d:MovePosition(position)
    else
        self.animatior:SetFloat("Speed", 0)
    end
end

--- 刷新属性(目前有血量，护甲，速度)
function Character:RefreshProperty()

    local heath = (self.currentRole.basicHeath + self.state.States[Enum_CharacterStateChangeType.number][Enum_CharacterStateSpecificChangeType.heath])*self.state.States[Enum_CharacterStateChangeType.percent][Enum_CharacterStateSpecificChangeType.heath]
    local armor = (self.currentRole.basicArmor + self.state.States[Enum_CharacterStateChangeType.number][Enum_CharacterStateSpecificChangeType.armor])*self.state.States[Enum_CharacterStateChangeType.percent][Enum_CharacterStateSpecificChangeType.armor]
    local speed = (self.currentRole.basicSpeed + self.state.States[Enum_CharacterStateChangeType.number][Enum_CharacterStateSpecificChangeType.speed])*self.state.States[Enum_CharacterStateChangeType.percent][Enum_CharacterStateSpecificChangeType.speed]
    if self.maxHeath ~= heath then
        local diff = heath-self.maxHeath
        self.maxHeath = heath
        MC:SendMessage(Enum_NormalMessageType.ChangeHeathCeiling,require("KeyValue"):new(diff, self.maxHeath))
    end
    if self.maxArmor ~= armor then
        local diff = armor-self.maxArmor
        self.maxArmor = armor
        MC:SendMessage(Enum_NormalMessageType.ChangeArmorCeiling,require("KeyValue"):new(diff, self.maxArmor))
    end
    if self.speed ~= speed then
        local diff = speed-self.speed
        self.speed = speed
        MC:SendMessage(Enum_NormalMessageType.ChangeSpeedCeiling,require("KeyValue"):new(diff, self.speed))
    end
end

--- isPersent: 是否为百分比   isRelativeToMax: 如果是百分比是否是相对于最大血量
function Character:ChangeHeath(value, isPersent, isRelativeToMax)
    if self:CheckIsDead() then
        return
    end
    if value and value ~= 0 then
        local realValue
        if isPersent then
            if isRelativeToMax then
                realValue = self.maxHeath * value
            else
                realValue = self.currentHeath * value
            end
        else
            realValue = value
        end
        local result = self.currentHeath + realValue
        if result <= 0 then
            self.currentHeath = 0
            MC:SendMessage(Enum_NormalMessageType.ChangeHeath, require("KeyValue"):new(realValue, self.currentHeath))
            self:Dead()
            return
        elseif result > self.maxHeath then
            self.currentHeath = self.maxHeath
        else
            self.currentHeath = result
        end
        MC:SendMessage(Enum_NormalMessageType.ChangeHeath, require("KeyValue"):new(realValue, self.currentHeath))
    end
end

--- isPersent: 是否为百分比   isRelativeToMax: 如果是百分比是否是相对于最大护甲
function Character:ChangeArmor(value, isPersent, isRelativeToMax)
    if value and value ~= 0 then
        local realValue
        if isPersent then
            if isRelativeToMax then
                realValue = self.maxArmor * value
            else
                realValue = self.currentArmor * value
            end
        else
            realValue = value
        end
        local result = self.currentArmor + realValue
        if result <= 0 then
            self.currentArmor = 0
        elseif result > self.maxArmor then
            self.currentArmor = self.maxArmor
        else
            self.currentArmor = result
        end
        MC:SendMessage(Enum_NormalMessageType.ChangeArmor, require("KeyValue"):new(realValue, self.currentArmor))
    end
end

function Character:OnCollision(type, other)
    if type == Enum_CollisionType.TriggerEnter2D then
        --- 武器的layer
        if other.gameObject.layer ==  12 then
            MC:SendMessage(Enum_NormalMessageType.ApproachItem, require("KeyValue"):new(Enum_ItemType.weapon, other.gameobject))
        end
    elseif type == Enum_CollisionType.TriggerExit2D then
        if other.gameObject.layer ==  12 then
            MC:SendMessage(Enum_NormalMessageType.LeaveItem, require("KeyValue"):new(Enum_ItemType.weapon, other.gameobject))
        end
    end
end

function Character:GetDamage(damageValue, buff)
    if buff then
        for k, v in pairs(buff) do
            self.state.States[Enum_CharacterStateChangeType.buff][k] = v
            self.state:AddBuff(BuffData.Buffs[k].buff)
        end
    end
    if damageValue and damageValue > 0 then
        if self.currentArmor > 0 then
            local diff = self.currentArmor - damageValue
            if diff < 0 then
                self:ChangeArmor(-self.currentArmor)
                self:ChangeHeath(diff)
            else
                self:ChangeArmor(-damageValue)
            end
        else
            self:ChangeHeath(-damageValue)
        end
    end
end

function Character:CheckIsDead()
    return self.currentHeath <= 0
end

function Character:Dead()
    print("character die~")
end

--- 每秒计算Buff
function Character:CalcBuffPerSecond()
    local wait = UE.WaitForSeconds(1)
    self.calcBuffPerSecond = StartCoroutine(function ()
        for k, v in pairs(self.state.States[Enum_CharacterStateChangeType.buff]) do
            self:GetDamage(BuffData.Buffs[k].basicDamage)
            v = v-1
            if v <= 0 then
                self.state:RemoveBuff(BuffData.Buffs[k].buff)
                self.state.States[Enum_CharacterStateChangeType.buff][k] = nil
            end
        end
        coroutine.yield(wait)
    end)
end

------------消息回调----------
function Character:OnChangeSkin(kv)
    if kv.Key == self.currentRole.roleType then
        if kv.Value ~= self.currentSkin.index then
            self.currentSkin = SkinData.Skins[kv.Key][kv.Value]
            self.animatior.runtimeAnimatorController = ResourceMgr:Load(self.currentSkin.animationResourcePath, self.currentSkin.animationResourceName)
        end
    end
end

function Character:OnChangeRole(kv)
    --记得换角色时也要换速度
end

function Character:OnPickUp(kv)

end

function Character:OnRefreshOuterThing(kv)
    --- 减去之前的被动技能
    for k,v in pairs(self.passiveSkillCache) do
        self.state:RemoveBuff(PassiveSkillData.Skills[v].buff)
    end
    --- 加上新的被动技能
    for k,v in pairs(UserData.UnlockedPassiveSkills) do
        self.state:AddBuff(PassiveSkillData.Skills[v].buff)
    end
    --- 刷新被动缓存
    self.passiveSkillCache = {}
    for k,v in pairs(UserData.UnlockedPassiveSkills) do
        table.insert(self.passiveSkillCache, v)
    end
end

function Character:OnAddKeepBuff(kv)
    self:RefreshProperty()
end

function Character:OnRemoveKeepBuff(kv)
    self:RefreshProperty()
end

function Character:OnChangeScene(kv)
    if self.calcBuffPerSecond then
        StartCoroutine(self.calcBuffPerSecond)
    end
    self:Destroy()
end

return Character