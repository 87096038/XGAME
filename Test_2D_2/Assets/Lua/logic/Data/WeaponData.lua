
--[[
    数据层，武器信息
--]]
local PathMgr=require("PathManager")

local WeaponData={}

function WeaponData:Init()
    self.Weapons={}
    self.Weapons[60001]={ID = 60001, preID = -1, cost = 0, PrefabPath=PathMgr.ResourcePath.Gun_Normal_Pistol, PrefabName=PathMgr.NamePath.Gun_Normal_Pistol, weaponType = Enum_WeaponType.normal_pistol, bulletType = Enum_BulletType.light, shootType = Enum_ShootType.single, name = "手枪", info = "一把普通的手枪。", basicDamage = 5, basicSpeed = 10, basicCD = 0.8, basicClipsAmmoCount = 6, basicReloadTime = 0.8,}
    self.Weapons[60002]={ID = 60002, preID = -1, cost = 0, PrefabPath=PathMgr.ResourcePath.Gun_Normal_Rifle, PrefabName=PathMgr.NamePath.Gun_Normal_Rifle, weaponType = Enum_WeaponType.normal_rifle, bulletType = Enum_BulletType.light, shootType = Enum_ShootType.multiple, name = "步枪", info = "一把普通的步枪。", basicDamage = 2, basicSpeed = 20, basicCD = 0.3, basicClipsAmmoCount = 20, basicReloadTime = 1.2,}
    self.Weapons[60003]={ID = 60003, preID = -1, cost = 0, weaponType = Enum_WeaponType.normal_shotgun, bulletType = Enum_BulletType.heavy, shootType = Enum_ShootType.single, name = "散弹枪", info = "一把普通的散弹枪。", basicDamage = 20, basicSpeed = 50, basicCD = 1, basicClipsAmmoCount = 2, basicReloadTime = 0.8,}
    self.Weapons[60004]={ID = 60004, preID = -1, cost = 1, PrefabPath=PathMgr.ResourcePath.Gun_Normal_Sniper_Rifle, PrefabName=PathMgr.NamePath.Gun_Normal_Sniper_Rifle, weaponType = Enum_WeaponType.normal_sniper_rifle, bulletType = Enum_BulletType.heavy, shootType = Enum_ShootType.single, name = "狙击枪", info = "一把普通的狙击枪。", basicDamage = 8, basicSpeed = 50, basicCD = 1, basicClipsAmmoCount = 4, basicReloadTime = 1, storeForceTime = 1, maxTimesCount = 2.5, }
end

WeaponData:Init()
return WeaponData