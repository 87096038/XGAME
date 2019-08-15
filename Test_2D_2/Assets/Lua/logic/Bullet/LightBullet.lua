local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local LightBullet = Class("LightBullet", require("Bullet_base"))

function LightBullet:cotr(dirction, position, rotation)
    self.super:cotr()
    self.gameobject = nil
    self.dirction = UE.Vector3(dirction.x, dirction.y, dirction.z)
    self.speed = 5

    local isNew
    self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Bullet_1, PathMgr.NamePath.Bullet_1, nil, position)
    if isNew then
        local collisionClass = self.gameobject:AddComponent(typeof(CS.Collision))
        if collisionClass.CollisionHandle then
            collisionClass.CollisionHandle = collisionClass.CollisionHandle + self.OnCollision_light
        else
            collisionClass.CollisionHandle = self.OnCollision_light
        end
    end

    self.gameobject.transform.rotation = rotation or UE.Quaternion.identity
    self:SetUpdateFunc(self.UpdateMove)
end


function LightBullet:UpdateMove()
    self.gameobject.transform:Translate(require( "Timer").deltaTime * self.dirction *self.speed, UE.Space.World)
end

function LightBullet:OnCollision_light(type, other)
    if type == Enum_CollisionType.TriggerEnter2D then
        local layer = other.gameObject.layer
        --- 敌人和主角的layer
        if layer == 9 or layer == 10 then
            self:Destroy()
        elseif layer == 5 then
            if not self.isBounce then
                self:Destroy()
            end
        end
    end
end

function LightBullet:Destroy()
    self.super:Destroy()
end

return LightBullet