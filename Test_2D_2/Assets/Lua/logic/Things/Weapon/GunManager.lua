--[[
    枪
--]]
local WeaponData = require("WeaponData")

local GunManager={}

function GunManager:Init()

end

function GunManager:GetGun(ID)
    local type = WeaponData.Weapons[ID].weaponType
    if not type then
        return
    end
    if type == Enum_WeaponType.normal_pistol then
        return require("NormalPistol"):new(ID)
    elseif type == Enum_WeaponType.normal_rifle then

    elseif type == Enum_WeaponType.normal_sniper_rifle then
        return require("NormalSniperRifle"):new(ID)
    elseif type == Enum_WeaponType.normal_shotgun then

    elseif type == Enum_WeaponType.normal_Laser_gun then

    elseif type == Enum_WeaponType.normal_grenade then

    end
end

GunManager:Init()
return GunManager