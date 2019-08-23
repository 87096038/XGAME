
--[[
    数据层，Buff信息
--]]

local BuffData={}

function BuffData:Init()
    self.Buffs={}
    self.Buffs[Enum_BuffAndDebuffType.burning] = {ID=20001, name="着火", info="身体着火了!", basicDamage=8,}
    self.Buffs[Enum_BuffAndDebuffType.ice_slow] = {ID=20002, name="冰缓", info="有点点点点点冷冷冷...", basicDamage=0, buff={[Enum_CharacterStateChangeType.percent]={[Enum_CharacterStateSpecificChangeType.speed]=-0.1}}}
    self.Buffs[Enum_BuffAndDebuffType.poisoning] = {ID=20003, name="中毒", info="中毒了!", basicDamage=8,}
end

BuffData:Init()
return BuffData