﻿local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local LightBullet = Class("LightBullet", require("Bullet_base"))

function LightBullet:cotr(dirction, position, rotation, speed, damage)
    self.super:cotr()
    self.damage = damage
    self.dirction = UE.Vector3(dirction.x, dirction.y, dirction.z)
    self.speed = speed
    --- 携带的特殊效果
    self.buffs={}
    --这里应该是从CharacterState获取BUff

    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Bullet_1, PathMgr.NamePath.Bullet_1, nil, position)
    ------------绑定碰撞--------------
    local collisionClass = self.gameobject:GetComponent(typeof(CS.Collision))
    if not collisionClass then
        collisionClass = self.gameobject:AddComponent(typeof(CS.Collision))
    end
    collisionClass.CollisionHandle = function(type, other)
        if type == Enum_CollisionType.TriggerEnter2D then
            local layer = other.gameObject.layer
            --- 主角
            if layer == 9  then
                self:Destroy()
                ---敌人
            elseif layer == 10 then
                local enemy = require("RoomManager"):GetEnemy(other.gameObject)
                enemy:GetDamage(self.damage, self.buffs)
                self:Destroy()
                ---墙
            elseif layer == 5 then
                if not self.isBounce then
                    self:Destroy()
                end
            end
        end
    end

    self.gameobject.transform.rotation = rotation or UE.Quaternion.identity
    self:SetUpdateFunc(self.UpdateMove)
end


function LightBullet:UpdateMove()
    self.gameobject.transform:Translate(require( "Timer").deltaTime * self.dirction *self.speed, UE.Space.World)
end

return LightBullet