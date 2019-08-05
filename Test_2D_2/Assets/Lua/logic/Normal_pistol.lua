
local Bullet = require("Bullet")
local Timer = require("Timer")

local Normal_pistol=Class("Normal_pistol", require("Weapon_base"))

function Normal_pistol:cotr()

    ---是否被捡起
    self.isPacked = false
    ---基础伤害
    self.demage = 10
    --- 拥有子弹总数
    self.totalAmmoACount=100
    --- 一弹夹子弹数量
    self.clipsAmmoCount=10
    --- 当前子弹数量
    self.currentAmmoACount=10
    --- 射击冷却时间
    self.shootCDTime =0.5
    --- 装弹时间
    self.reloadTime=1

    ---为了计算是否达到冷却时间
    self.time = 0

    self.weaponType = Enum_WeaponType.normal_pistol

    self.bulletType = Enum_BulletType.light

    self.shootType = Enum_ShootType.single
end

function Normal_pistol:Shoot()
    self.time = self.time + Timer.deltaTime
    if UE.Input.GetMouseButton(0) and self.time >=  self.shootCDTime then
        if self.currentAmmoACount == 0 then
            --处理没子弹
        else
            local bullet = Bullet:new(self.bulletType)
            self.time = 0
        end
    end
end

function Normal_pistol:Changing()

end

function Normal_pistol:Use()
    if self.isPacked then
        return
    end

    require("MessageCenter"):SendMessage(Enum_MessageType.PickUp, require("KeyValue"):new("weapon", self))

end

function Normal_pistol:Drop()

end

return Normal_pistol