﻿
--[[
    数据层，装备信息
--]]
local PathMgr = require("PathManager")

local EquipmentData={}

function EquipmentData:Init()
    self.Equipments={}
    self.Equipments[70001]={ID=70001, preID=-1, cost=0, type=Enum_EquipmentType.NormalClothes, name="衣服",info="能提供少量的防护，护甲+1", extraInfo="一件普通的衣服", PrefabPath=PathMgr.ResourcePath.Item_NormalClothes, PrefabName=PathMgr.NamePath.Item_NormalClothes, buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=1}}}
    self.Equipments[70002]={ID=70002, preID=-1, cost=0, type=Enum_EquipmentType.LightArmour, name="轻甲", info="银鳞胸甲，五金一件。护甲+3", extraInfo="一件普通的轻甲", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=3}}}
    self.Equipments[70003]={ID=70003, preID=-1, cost=0, type=Enum_EquipmentType.MiddleArmour, name="铠甲", info="制式铠甲，护甲+6", extraInfo="一件普通的铠甲", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=6}, [Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = -0.1}}}
    self.Equipments[70004]={ID=70004, preID=-1, cost=0, type=Enum_EquipmentType.HeavyArmour, name="重甲", info="又热又重，不过足够厚实。护甲+10 速度-20%", extraInfo="一件普通的重甲", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=10}, [Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = -0.2}}}
    self.Equipments[70005]={ID=70005, preID=-1, cost=1, type=Enum_EquipmentType.CXKVest, name="蔡徐坤的背心", info="穿上它，打篮球更花哨了。速度+10%", extraInfo="鸡你太美", buff={[Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = 0.1}}}
    self.Equipments[70006]={ID=70006, preID=-1, cost=1, type=Enum_EquipmentType.PRClothes, name="品如的衣服", info="只薄薄一片。护甲+1 速度+8%", extraInfo="你好骚啊", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor]=1},[Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = 0.08}}}
    self.Equipments[70007]={ID=70007, preID=-1, cost=1, type=Enum_EquipmentType.GrandmasVest, name="外婆的背心", info="不断有力量涌入。护甲+1 速度-1% 每进入一个新房间恢复5%生命", extraInfo="暖暖的，都是外婆的爱", buff={[Enum_CharacterStateChangeType.number] = {[Enum_CharacterStateSpecificChangeType.armor] = 1}, [Enum_CharacterStateChangeType.percent] = {[Enum_CharacterStateSpecificChangeType.speed] = -0.01}, [Enum_CharacterStateChangeType.specialEffects] = {[Enum_SpecialEffectsType.RestoreLife_Room] = 0.05}}}
    self.Equipments[70008]={ID=70008, preID=70007, cost=2, type=Enum_EquipmentType.MomsLongJohns, name="妈妈的秋裤", info="厚厚的秋裤，有着神秘的力量。抵抗所有负面效果", extraInfo="出门在外，记得穿秋裤哦", buff={[Enum_CharacterStateChangeType.specialEffects] = {[Enum_SpecialEffectsType.ResistFire] = 1, [Enum_SpecialEffectsType.ResistFrozen] = 1, [Enum_SpecialEffectsType.ResistIceSlow] = 1, [Enum_SpecialEffectsType.ResistPoisoning] = 1}}}
end

EquipmentData:Init()
return EquipmentData