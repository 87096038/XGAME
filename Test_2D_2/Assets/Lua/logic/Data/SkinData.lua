
--[[
    数据层，皮肤信息
--]]
local PathMgr = require("PathManager")

local SkinData={}

function SkinData:Init()
    self.Skins={}
    self.Skins[Enum_RoleType.Adventurer_1]={
        [1]={roleType=Enum_RoleType.Adventurer_1, index=1, spritePath=PathMgr.ResourcePath.Sprite_Role_1_Skin_1, spriteName=PathMgr.NamePath.Sprite_Role_1_Skin_1, animationResourcePath = PathMgr.ResourcePath.Animation_Role_1_Skin_1,  animationResourceName = PathMgr.NamePath.Animation_Role_1_Skin_1},
        [2]={roleType=Enum_RoleType.Adventurer_1, index=2, spritePath=PathMgr.ResourcePath.Sprite_Role_1_Skin_2, spriteName=PathMgr.NamePath.Sprite_Role_1_Skin_2, animationResourcePath = PathMgr.ResourcePath.Animation_Role_1_Skin_2,  animationResourceName = PathMgr.NamePath.Animation_Role_1_Skin_2},
        [3]={roleType=Enum_RoleType.Adventurer_1, index=3, spritePath=nil, spriteName=nil, animationResourcePath = PathMgr.ResourcePath.Animation_Role_1_Skin_2,  animationResourceName = PathMgr.NamePath.Animation_Role_1_Skin_2},
        [4]={roleType=Enum_RoleType.Adventurer_1, index=4, spritePath=nil, spriteName=nil, animationResourcePath = PathMgr.ResourcePath.Animation_Role_1_Skin_2,  animationResourceName = PathMgr.NamePath.Animation_Role_1_Skin_2},
        [5]={roleType=Enum_RoleType.Adventurer_1, index=5, spritePath=nil, spriteName=nil, animationResourcePath = PathMgr.ResourcePath.Animation_Role_1_Skin_2,  animationResourceName = PathMgr.NamePath.Animation_Role_1_Skin_2},
        [6]={roleType=Enum_RoleType.Adventurer_1, index=6, spritePath=nil, spriteName=nil, animationResourcePath = PathMgr.ResourcePath.Animation_Role_1_Skin_2,  animationResourceName = PathMgr.NamePath.Animation_Role_1_Skin_2},
        [7]={roleType=Enum_RoleType.Adventurer_1, index=7, spritePath=nil, spriteName=nil, animationResourcePath = PathMgr.ResourcePath.Animation_Role_1_Skin_2,  animationResourceName = PathMgr.NamePath.Animation_Role_1_Skin_2},
    }

end
SkinData:Init()
return SkinData