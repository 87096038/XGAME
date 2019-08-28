local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local Timer = require("Timer")
local MC = require("MessageCenter")

local enemy_base = require("Enemy_base")
local Enemy_1 = Class("Enemy_1",enemy_base)

function Enemy_1:cotr(position)
    ---gameobject---
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Enemy_1, PathMgr.NamePath.Enemy_1,nil,position)

    -----设置成员变量------
    self.rigidbody2d = self.gameobject:GetComponent("Rigidbody2D")
    self.transform = self.gameobject:GetComponent("Transform")
    self.animator = self.gameobject:GetComponent("Animator")
    self.collision_attack = self.transform:Find("Collider_Attack").gameObject
    self.collision_findCharacter = self.transform:Find("Collider_FindCharacter").gameObject
    self.character = require("RoomManager"):GetCharacter()
    self.isDead = false
    -------状态数据-----
    self.maxHeath = 13
    self.currentHeath = 13
    self.attack = 5
    self.speed = 2
    self.isFoundCharacter = false

    ---------监听注册--------
    MC:AddListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))

    --------添加碰撞--------
    self:Collision()
    --------添加update()
    self:Start()
end

function Enemy_1:Collision()
    local thisTable = self
    -------绑定碰撞------

    self.collision_a = self.collision_attack:AddComponent(typeof(CS.Collision))
    self.collision_a.CollisionHandle = function(self, type, other)
        if type == Enum_CollisionType.TriggerEnter2D then
            if other.gameObject.layer == 9 then
                thisTable:TouchCharacter()
            end
        end
    end

    self.collision_f = self.collision_findCharacter:AddComponent(typeof(CS.Collision))
    self.collision_f.CollisionHandle = function(self, type, other)
        if type == Enum_CollisionType.TriggerEnter2D then
            if other.gameObject.layer == 9 then
                thisTable.isFoundCharacter = true
            end
        elseif type == Enum_CollisionType.TriggerExit2D then
            if other.gameObject.layer == 9 then
                thisTable.isFoundCharacter = false
            end
        end
    end
end

function Enemy_1:Start()
    self:SetUpdateFunc(self.Update)
    print("生成怪物时的table",self)
end

--- 加入update的函数
function Enemy_1:Update()
    if self.isFoundCharacter then
        self:MoveToCharacter()
    else
        self:Stand()
    end

end

function Enemy_1:Stand()
    self.animator:ResetTrigger("Move")
    self.animator:SetTrigger("Dance")
end

function Enemy_1:MoveToCharacter()

    self.animator:ResetTrigger("Dance")
    self.animator:SetTrigger("Move")

    local characterPos = self.character.rigidbody2d.position
    local enemyPos = self.rigidbody2d.position
    local horizontal = 0
    local vertical = 0

    if enemyPos.y - characterPos.y > 0 then
        vertical = -1
    elseif enemyPos.y - characterPos.y < 0 then
        vertical = 1
    end

    if enemyPos.x - characterPos.x > 0 then
        horizontal = -1
    elseif enemyPos.x - characterPos.x < 0 then
        horizontal = 1
    end

    self.animator:SetFloat("MoveX",horizontal)
    self.animator:SetFloat("MoveY",vertical)

    local position = enemyPos

    position.x = position.x + self.speed * horizontal * Timer.deltaTime
    position.y = position.y + self.speed * vertical * Timer.deltaTime

    self.rigidbody2d:MovePosition(position)
end

function Enemy_1:TouchCharacter()
    --print("get character")
end

function Enemy_1:GetDamage(damage,buff)
    --print("Enemy Injury",damage)
    self.currentHeath = self.currentHeath - damage
    if self.currentHeath <= 0 and not self.isDead then
        self:Dead()
    end
end

function Enemy_1:Dead()
    self:Destroy()
    ResourceMgr:DestroyObject(self.gameobject,true)
    MC:SendMessage(Enum_NormalMessageType.EnemyDead,require("KeyValue"):new(nil, self))
end

------------------消息回调---------------
function Enemy_1:OnChangeScene(kv)
    if not self.isDead then
        self:Destroy()
    end
end
return Enemy_1