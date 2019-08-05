
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Timer = require("Timer")

local Bullet = Class("Bullet", require("Base"))

function Bullet:cotr(bulletType, rotation)
    self.super:cotr()
    self.gameobject = nil
    self.type = bulletType
    self.speed = 5

    local isNew
    if self.type == Enum_BulletType.light then
        self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Bullet_1, PathMgr.NamePath.Bullet_1)
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

    self.rotation = rotation or UE.Quaternion.identity

    self.gameobject.transform.rotation = self.rotation
end

function Bullet:UpdateMove_light()
    if self.rotation.z > 0 or self.rotation.z < 90  then
      self.gameobject.transform:Translate(Timer.deltaTime * UE.Vector3.right *self.speed, UE.Space.Self)
    else
        self.gameobject.transform:Translate(Timer.deltaTime * UE.Vector3.left *self.speed, UE.Space.Self)
    end
end

function Bullet:OnCollision_light(type, other)
    if type == "TriggerEnter2D" and other.gameObject.layer == 9 then
        ResourceMgr:DestroyObject(self.gameObject)
    end
end

return Bullet