--[[
    战场中可交互东西的工厂
--]]
local WeaponData = require("WeaponData")
local EquipmentData = require("EquipmentData")
local ItemData = require("ItemData")


local ThingsFactory={}

function ThingsFactory:Init()

end

function ThingsFactory:GetThing(ID, position)
    if WeaponData.Weapons[ID] then
        return self:GetGun(ID, position), Enum_ItemType.weapon
    elseif EquipmentData.Equipments[ID] then
        return self:GetEquipment(ID, position), Enum_ItemType.equipment
    elseif ItemData.Items[ID] then
        return self:GetItem(ID, position), Enum_ItemType.item
    end
end

function ThingsFactory:GetGun(ID, position)
    local type = WeaponData.Weapons[ID].weaponType
    if not type then
        return
    end
    if type == Enum_WeaponType.normal_pistol then
        return require("NormalPistol"):new(ID, position)
    elseif type == Enum_WeaponType.normal_rifle then
        return require("NormalRifle"):new(ID, position)
    elseif type == Enum_WeaponType.normal_sniper_rifle then
        return require("NormalSniperRifle"):new(ID, position)
    elseif type == Enum_WeaponType.normal_shotgun then

    elseif type == Enum_WeaponType.normal_Laser_gun then

    elseif type == Enum_WeaponType.normal_grenade then

    end
end

function ThingsFactory:GetEquipment(ID, position)
    return require("Equipment"):new(ID, position)
end

function ThingsFactory:GetItem(ID, position)
    return require("Item"):new(ID, position)
end

ThingsFactory:Init()
return ThingsFactory