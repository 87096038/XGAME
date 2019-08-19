
--[[
    数据层，武器信息
--]]

local WeaponData={}

function WeaponData:Init()
    self.Weapons={}
    self.Weapons[Enum_WeaponType.normal_pistol]={ID = 60001, preID = -1, cost = 0, weaponType = Enum_WeaponType.normal_pistol, bulletType = Enum_BulletType.light, shootType = Enum_ShootType.single, name = "手枪", info = "一把普通的手枪。", basicDamage = 5, basicSpeed = 10, basicCD = 0.8, basicClipsAmmoCount = 6, basicReloadTime = 0.2,}
end

WeaponData:Init()
return WeaponData