
--[[
    数据层，被动技能信息
--]]

local PathMgr = require("PathManager")

local PassiveSkillData={}

function PassiveSkillData:Init()
    self.Skills={}
    self.Skills[50001] = {ID=50001, preID=-1, cost=1, name="雪之护", info="生命永久+5", IconResourcePath=PathMgr.ResourcePath.SpriteAtlas_Icons, IconResourceName=PathMgr.NamePath.SpriteAtlas_Icons, AtlasName="Icons_PassiveSkill_HeathUp",buff={[Enum_CharacterStateChangeType.number]={[Enum_CharacterStateSpecificChangeType.heath]=5}}}
    self.Skills[50002] = {ID=50002, preID=-1, cost=1, name="神之护", info="护甲永久+2", IconResourcePath=PathMgr.ResourcePath.SpriteAtlas_Icons, IconResourceName=PathMgr.NamePath.SpriteAtlas_Icons, AtlasName="Icons_PassiveSkill_ArmorUp", buff={[Enum_CharacterStateChangeType.number]={[Enum_CharacterStateSpecificChangeType.armor]=2}}}
    self.Skills[50003] = {ID=50003, preID=-1, cost=1, name="虚之护", info="速度永久加1%", IconResourcePath=PathMgr.ResourcePath.SpriteAtlas_Icons, IconResourceName=PathMgr.NamePath.SpriteAtlas_Icons, AtlasName="Icons_PassiveSkill_SpeedUp",buff={[Enum_CharacterStateChangeType.percent]={[Enum_CharacterStateSpecificChangeType.speed]=0.01}}}
    self.Skills[50004] = {ID=50004, preID=50001, cost=2, name="雪之守护", info="生命永久+10", IconResourcePath=PathMgr.ResourcePath.SpriteAtlas_Icons, IconResourceName=PathMgr.NamePath.SpriteAtlas_Icons, AtlasName="Icons_PassiveSkill_HeathUp",buff={[Enum_CharacterStateChangeType.number]={[Enum_CharacterStateSpecificChangeType.heath]=10}}}
end


PassiveSkillData:Init()
return PassiveSkillData