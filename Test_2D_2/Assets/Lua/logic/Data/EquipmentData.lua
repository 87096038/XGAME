
--[[
    数据层，装备信息
--]]
local PathMgr = require("PathManager")

local EquipmentData={}

function EquipmentData:Init()
    self.Equipments={}
    self.Equipments[70001]={ID=70001, preID=-1, cost=0, type=Enum_EquipmentType.NormalClothes, name="衣服", info="一件普通的衣服", PrefabPath=PathMgr.ResourcePath.Item_NormalClothes, PrefabName=PathMgr.NamePath.Item_NormalClothes, buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=1}}}
    self.Equipments[70002]={ID=70002, preID=-1, cost=0, type=Enum_EquipmentType.LightArmour, name="轻甲", info="一件普通的轻甲", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=3}}}
    self.Equipments[70003]={ID=70003, preID=-1, cost=0, type=Enum_EquipmentType.MiddleArmour, name="铠甲", info="一件普通的铠甲", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=6}, [Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = -0.1}}}
    self.Equipments[70004]={ID=70004, preID=-1, cost=0, type=Enum_EquipmentType.HeavyArmour, name="重甲", info="一件普通的重甲", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=10}, [Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = -0.2}}}
    self.Equipments[70005]={ID=70005, preID=-1, cost=1, type=Enum_EquipmentType.CXKVest, name="蔡徐坤的背心", info="鸡你太美", buff={[Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = 0.1}}}
    self.Equipments[70006]={ID=70006, preID=-1, cost=1, type=Enum_EquipmentType.PRClothes, name="品如的衣服", info="你好骚啊", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=1},[Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = 0.08}}}
    self.Equipments[70007]={ID=70007, preID=-1, cost=1, type=Enum_EquipmentType.GrandmasVest, name="外婆的背心", info="暖暖的，都是外婆的爱", buff={[Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = 0.1}, [Enum_CharacterStateChangeType.specialEffects] = {[Enum_SpecialEffectsType.RestoreLife_Room] = 5}}}
    self.Equipments[70008]={ID=70008, preID=70007, cost=2, type=Enum_EquipmentType.MomsLongJohns, name="妈妈的秋裤", info="出门在外，记得穿秋裤哦", buff={[Enum_CharacterStateChangeType.specialEffects] = {[Enum_SpecialEffectsType.ResistFire] = 1, [Enum_SpecialEffectsType.ResistFrozen] = 1, [Enum_SpecialEffectsType.ResistIceSlow] = 1, [Enum_SpecialEffectsType.ResistPoisoning] = 1}}}
end

EquipmentData:Init()
return EquipmentData