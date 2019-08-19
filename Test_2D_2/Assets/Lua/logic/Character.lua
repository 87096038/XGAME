local GlobalData = require("GlobalData")
local GlobalAbility = require("GlobalAbilityScale")
local RoleData = require("RoleData")
local SkinData = require("SkinData")

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

    ---gameobject---
    self.super:cotr()
    local mainRole, isNew =  ResourceMgr:GetGameObject(PathMgr.ResourcePath.Character_1, PathMgr.NamePath.Character_1)
    self.gameobject = mainRole.transform:Find("Role").gameObject
    -------绑定碰撞------
    self.collsion = self.gameobject:AddComponent(typeof(CS.Collision))
    if isNew then
        if self.collsion.CollisionHandle then
            self.collsion.CollisionHandle = self.collsion.CollisionHandle + self.OnCollision
        else
            self.collsion.CollisionHandle = self.OnCollision
        end
    end
    -----设置成员变量------
    self.currentRole = RoleData.Roles[Enum_RoleType.Adventurer_1]
    self.currentSkin = SkinData.Skins[Enum_RoleType.Adventurer_1][1]

    self.speed = self.currentRole.basicSpeed--(GlobalData.characterSpeed + GlobalAbility.roleSpeedChange)*GlobalAbility.roleSpeedScale
    self.rigidbody2d = self.gameobject:GetComponent("Rigidbody2D")
    self.transform = self.gameobject:GetComponent("Transform")
    self.animatior = self.gameobject:GetComponent("Animator")

    -------状态数据-----
    self.maxHeath = 100
    self.currentHeath = 100
    self.maxArmor = 1
    self.currentArmor = 1

    self.speedChange = 0
    self.speedScale = 1
    --self.Skill_1 =
    ---------监听注册--------
    self:AddMessageListener(Enum_MessageType.ChangeSkin, handler(self, self.OnChangeSkin))
    self:AddMessageListener(Enum_MessageType.ChangeScene, handler(self, self.OnChangeScene))

end

function Character:Start()
    Timer:AddUpdateFuc(self, self.Update)
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

--- isPersent: 是否为百分比   isJustMax: 是否只是最大值更改
function Character:ChangeHeath(count, isPersent, isJustMax)

end

function Character:OnCollision(type, other)
    if type == Enum_CollisionType.TriggerEnter2D then
        --- 武器的layer
        if other.gameObject.layer ==  12 then
            MC:SendMessage(Enum_MessageType.ApproachItem, require("KeyValue"):new(Enum_ItemType.weapon, other.gameobject))
        end
    elseif type == Enum_CollisionType.TriggerExit2D then
        if other.gameObject.layer ==  12 then
            MC:SendMessage(Enum_MessageType.LeaveItem, require("KeyValue"):new(Enum_ItemType.weapon, other.gameobject))
        end
    end
end

function Character:Destroy()
    self.super:Destroy()
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

function Character:OnChangeScene()
    self:Destroy()
end

return Character