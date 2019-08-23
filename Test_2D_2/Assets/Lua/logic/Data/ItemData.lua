
--[[
    数据层，物品信息
--]]

local ItemData = {}

function ItemData:init()
    self.Items={}
    self.Items[80001] = {ID=80001, preID=-1, cost=0, type=Enum_ItemToolType.AmysBow, name="小艾米的蝴蝶结", info="有一股淡淡的香气。戴上它，虽然显得很奇怪，但是内心却变得很安宁。等等，艾米是谁？", buff={[Enum_CharacterStateChangeType.percent]={[Enum_CharacterStateSpecificChangeType.lightBulletSpeed] = 0.2, [Enum_CharacterStateSpecificChangeType.heavyBulletSpeed] = 0.2}, [Enum_CharacterStateChangeType.specialEffects]={[Enum_SpecialEffectsType.Resurrect] = 1}} }
    self.Items[80002] = {ID=80002, preID=-1, cost=0, type=Enum_ItemToolType.Van, name="《王の哲学》", info="ASS♂WE♂CAN", buff={[Enum_CharacterStateChangeType.number]={[Enum_CharacterStateSpecificChangeType.heath]=50}, [Enum_CharacterStateChangeType.percent]={[Enum_CharacterStateSpecificChangeType.lightBulletDamage] = 0.15, [Enum_CharacterStateSpecificChangeType.heavyBulletDamage] = 0.15}} }
    self.Items[80003] = {ID=80003, preID=-1, cost=0, type=Enum_ItemToolType.PangsSkateboardShoes, name="庞太郎的滑板鞋", info="时尚时尚最时尚", buff={[Enum_CharacterStateChangeType.percent]={[Enum_CharacterStateSpecificChangeType.speed] = 0.5}} }
end

ItemData:init()
return ItemData