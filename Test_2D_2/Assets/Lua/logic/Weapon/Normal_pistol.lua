
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Timer = require("Timer")

local Normal_pistol=Class("Normal_pistol", require("Weapon_base"))

function Normal_pistol:cotr()
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Normal_Rifle, PathMgr.NamePath.Normal_Rifle)
    self.collsion =  self.gameobject:GetComponentInChildren(typeof(UE.BoxCollider2D))
    self.isReloading = false

    ---子弹出口位置距枪的位置的长度的倍率
    self.bulletStartDistance = 1.2
    ---枪口朝向
    self.dirction = UE.Vector3(0, 0, 1)

    ---为了计算是否达到冷却时间
    self.time = 0

    self.weaponType = Enum_WeaponType.normal_pistol

    self.bulletType = Enum_BulletType.light

    self.shootType = Enum_ShootType.single
end

function Normal_pistol:UpdateIdle()

end

function Normal_pistol:UpdateShoot()
    self.time = self.time + Timer.deltaTime
    if self.shootType == Enum_ShootType.single then
        if UE.Input.GetMouseButtonDown(0) and self.time >=  self.shootCDTime and not self.isReloading then
            if self.currentAmmoACount == 0 then
                self:Reload()
            else
                self:GenerateBullet()
                self.time = 0
            end
        end
    elseif self.shootType == Enum_ShootType.multiple then
        if UE.Input.GetMouseButton(0) and self.time >=  self.shootCDTime and not self.isReloading then
            if self.currentAmmoACount == 0 then
                self:Reload()
            else
                self:GenerateBullet()
                self.time = 0
            end
        end
    end
end

function Normal_pistol:GenerateBullet()
    local dir = self.dirction.normalized
    if self.bulletType == Enum_BulletType.light then
        require("LightBullet"):new(dir, self.gameobject.transform.position+dir*self.bulletStartDistance,self.gameobject.transform.rotation)
    elseif self.bulletType == Enum_BulletType.heavy then
        require("HeavyBullet"):new(dir, self.gameobject.transform.position+dir*self.bulletStartDistance,self.gameobject.transform.rotation)
    elseif self.bulletType == Enum_BulletType.energy then
        require("EnergyBullet"):new(dir, self.gameobject.transform.position+dir*self.bulletStartDistance,self.gameobject.transform.rotation)
    elseif self.bulletType == Enum_BulletType.shell then
        require("ShellBullet"):new(dir, self.gameobject.transform.position+dir*self.bulletStartDistance,self.gameobject.transform.rotation)
    end
end

function Normal_pistol:Reload()
    self.isReloading = true
    Timer:InvokeCoroutine(function ()self.isReloading = false end, self.reloadTime)
    --- 播放动画
end

function Normal_pistol:Use()
    if self.isPacked then
        return
    end
    self.collsion.enabled = false
    require("MessageCenter"):SendMessage(Enum_MessageType.PickUp, require("KeyValue"):new(Enum_ItemType.weapon, self))
    self.isPacked = true

end

function Normal_pistol:Drop()
    self.isPacked = true
    self.collsion.enabled = true
end

return Normal_pistol