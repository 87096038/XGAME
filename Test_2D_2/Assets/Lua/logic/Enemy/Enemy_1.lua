local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local Timer = require("Timer")

local enemy_base = require("Enemy_base")
local Enemy_1 = Class("Enemy_1",enemy_base)

function Enemy_1:cotr(position)
    ---gameobject---
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Enemy_1, PathMgr.NamePath.Enemy_1,nil,position)

    -----设置成员变量------
    self.speed = 4
    self.rigidbody2d = self.gameobject:GetComponent("Rigidbody2D")
    self.transform = self.gameobject:GetComponent("Transform")
    --self.animatior = self.gameobject:GetComponent("Animator")

    print(self,self.gameobject,self.speed,self.rigidbody2d,self.transform)

    -------状态数据-----
    self.maxHeath = 100
    self.currentHeath = 100

    ---------监听注册--------


    --------添加碰撞--------
    --self:Collision()
    --------添加update()
    self:Start()
end

function Enemy_1:Collision()
    -------绑定碰撞------
    self.collsion = self.gameobject:AddComponent(typeof(CS.Collision))
    self.collsion.CollisionHandle = function(self, type, other)
        if type == Enum_CollisionType.TriggerEnter2D then

        end
    end
end

function Enemy_1:Start()
    self:SetUpdateFunc(self.Update)
end

--- 加入update的函数
function Enemy_1:Update()
    self:MoveToCharacter()
end

function Enemy_1:MoveToCharacter()
    local character = require("RoomManager"):GetCharacter()
    local characterPos = character.rigidbody2d.position
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

    --self.animatior.SetFloat("MoveX",horizontal)
    --self.animatior.SetFloat("MoveY",vertical)

    local position = enemyPos

    position.x = position.x + self.speed * horizontal * Timer.deltaTime
    position.y = position.y + self.speed * vertical * Timer.deltaTime

    --print(position.x, self.speed, horizontal, Timer.deltaTime)

    self.rigidbody2d:MovePosition(position)
end

function Enemy_1:Hurt(damage,buff)
    self.currentHeath = self.currentHeath - damage
    if self.currentHeath <= 0 then
        self:Dead()
    end
end

function Enemy_1:Dead()

end

return Enemy_1