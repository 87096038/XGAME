
--[[
    数据层，武器信息
--]]

local WeaponData={}

function WeaponData:Init()
    self.Weapons={}
    self.Weapons[Enum_WeaponType.normal_pistol]={ID = 60001, preID = -1, cost = 0, weaponType = Enum_WeaponType.normal_pistol, bulletType = Enum_BulletType.light, shootType = Enum_ShootType.single, name = "手枪", info = "一把普通的手枪。", basicDamage = 5, basicSpeed = 10, basicCD = 0.8, basicClipsAmmoCount = 6, basicReloadTime = 0.2,}
    self.Weapons[Enum_WeaponType.normal_rifle]={ID = 60002, preID = -1, cost = 0, weaponType = Enum_WeaponType.normal_rifle, bulletType = Enum_BulletType.light, shootType = Enum_ShootType.multiple, name = "步枪", info = "一把普通的步枪。", basicDamage = 2, basicSpeed = 20, basicCD = 0.3, basicClipsAmmoCount = 20, basicReloadTime = 0.4,}
    self.Weapons[Enum_WeaponType.normal_shotgun]={ID = 60003, preID = -1, cost = 0, weaponType = Enum_WeaponType.normal_shotgun, bulletType = Enum_BulletType.heavy, shootType = Enum_ShootType.single, name = "散弹枪", info = "一把普通的散弹枪。", basicDamage = 20, basicSpeed = 50, basicCD = 1, basicClipsAmmoCount = 2, basicReloadTime = 0.4,}
end

WeaponData:Init()
return WeaponData