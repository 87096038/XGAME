--[[
    所有能力的增加和减少
--]]
local GlobalAbilityScale={}

function GlobalAbilityScale:Init()

    ---角色加成
    self.CharacterPower={[Enum_CharacterPowerSourceType.equipment]=5}

    ---增益和减益
    self.BuffAndDebuff={}

    ---系统奖励
    self.GameReward={}
end

GlobalAbilityScale:Init()

return GlobalAbilityScale