--[[
    所有能力的增加和减少
--]]
local GlobalAbilityScale={}

function GlobalAbilityScale:Init()

    self.Normal_pistol = require("Normal_pistol")
    self.Normal_Sniper_Rifle = require("Normal_Sniper_Rifle")


    ---角色加成
    self.CharacterPower={}

    ---增益和减益
    self.BuffAndDebuff={}

    ---系统奖励
    self.GameReward={}


    -------------全局的增益减益-----------------
--[[
    Change是基础值变化
    Scale是百分比变化
--]]
    -------------Change-------------
    --- 子弹的攻击力
    self.lightBulletDamageChange = 0
    self.heavyBulletDamageChange = 0
    self.energyBulletDamageChange = 0
    self.shellBulletDamageChange = 0

    --- 子弹的速度
    self.lightBulletSpeedChange = 0
    self.heavyBulletSpeedChange = 0
    self.energyBulletSpeedChange = 0
    self.shellBulletSpeedChange = 0

    self.roleSpeedChange = 0

    -----------Scale--------------
    --- 子弹的攻击力
    self.lightBulletDamageScale = 1
    self.heavyBulletDamageScale = 1
    self.energyBulletDamageScale = 1
    self.shellBulletDamageScale = 1

    --- 子弹的速度
    self.lightBulletSpeedScale = 1
    self.heavyBulletSpeedScale = 1
    self.energyBulletSpeedScale = 1
    self.shellBulletSpeedScale = 1

    self.roleSpeedScale = 1
end

function GlobalAbilityScale:ChangeWeaponData(weaponType )

end

function GlobalAbilityScale:ChangeBulletData()

end

function GlobalAbilityScale:AddBuffOrDebuff(buffAndDebuffType, keepTime)

end

GlobalAbilityScale:Init()

return GlobalAbilityScale