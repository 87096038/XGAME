
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Timer = require("Timer")

local Bullet = Class("Bullet", require("Base"))

function Bullet:cotr(bulletType, dirction, position, rotation)
    self.super:cotr()
    self.gameobject = nil
    self.type = bulletType
    self.dirction = UE.Vector3(dirction.x, dirction.y, dirction.z)
    self.speed = 5
    self.isBounce = false
    self.explosionEffect = nil

    local isNew
    if self.type == Enum_BulletType.light then
        self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Bullet_1, PathMgr.NamePath.Bullet_1, nil, position)
        if isNew then
            local collisionClass = self.gameobject:GetComponent("Collision")
            if collisionClass.CollisionHandle then
                collisionClass.CollisionHandle = collisionClass.CollisionHandle + self.OnCollision_light
            else
                collisionClass.CollisionHandle = self.OnCollision_light
            end
        end
        Timer:AddUpdateFuc(self, self.UpdateMove_light)
    elseif self.type == Enum_BulletType.heavy then

    elseif self.type == Enum_BulletType.energy then

    elseif self.type == Enum_BulletType.shell then

    end

    self.gameobject.transform.rotation = rotation or UE.Quaternion.identity
end

function Bullet:UpdateMove_light()
    self.gameobject.transform:Translate(Timer.deltaTime * self.dirction *self.speed, UE.Space.World)
end

function Bullet:OnCollision_light(type, other)
    if type == "TriggerEnter2D" then
        local layer = other.gameObject.layer
        --- 敌人和主角的layer
        if layer == 9 or layer == 10 then
            ResourceMgr:DestroyObject(self.gameObject)
        elseif layer == 5 then
            if self.isBounce then
                ResourceMgr:DestroyObject(self.gameObject)
            end
        end
    end
end

function Bullet:Destroy()
    self.super:Destroy()
    if self.explosionEffect then

    end
    ResourceMgr:DestroyObject(self.gameObject)
end

return Bullet