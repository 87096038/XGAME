
--[[
    数据层，物品信息
--]]
local PathMgr = require("PathManager")

local ItemData = {}

function ItemData:init()
    self.Items={}
    self.Items[80001] = {ID=80001, preID=-1, cost=0, type=Enum_ItemToolType.AmysBow, name="小艾米的蝴蝶结", info="有一股淡淡的香气。轻、重子弹速度增加20%", extraInfo="等等，艾米是谁？", PrefabPath=PathMgr.ResourcePath.Item_AmysBow, PrefabName=PathMgr.NamePath.Item_AmysBow, buff={[Enum_CharacterStateChangeType.percent]={[Enum_CharacterStateSpecificChangeType.lightBulletSpeed] = 0.2, [Enum_CharacterStateSpecificChangeType.heavyBulletSpeed] = 0.2}, [Enum_CharacterStateChangeType.specialEffects]={[Enum_SpecialEffectsType.Resurrect] = 1}} }
    self.Items[80002] = {ID=80002, preID=-1, cost=0, type=Enum_ItemToolType.Van, name="《王の哲学》",info="感觉浑身充满力量。生命上限增加50，轻、重子弹伤害增加15%", extraInfo="ASS♂WE♂CAN", PrefabPath=PathMgr.ResourcePath.Item_Van, PrefabName=PathMgr.NamePath.Item_Van, buff={[Enum_CharacterStateChangeType.number]={[Enum_CharacterStateSpecificChangeType.heath]=50}, [Enum_CharacterStateChangeType.percent]={[Enum_CharacterStateSpecificChangeType.lightBulletDamage] = 0.15, [Enum_CharacterStateSpecificChangeType.heavyBulletDamage] = 0.15}} }
    self.Items[80003] = {ID=80003, preID=-1, cost=0, type=Enum_ItemToolType.PangsSkateboardShoes, name="庞太郎的滑板鞋",info="让我们，滑着走。速度增加50%", extraInfo="时尚时尚最时尚", PrefabPath=PathMgr.ResourcePath.Item_PangsSkateboardShoes, PrefabName=PathMgr.NamePath.Item_PangsSkateboardShoes, buff={[Enum_CharacterStateChangeType.percent]={[Enum_CharacterStateSpecificChangeType.speed] = 0.5}} }
end

ItemData:init()
return ItemData