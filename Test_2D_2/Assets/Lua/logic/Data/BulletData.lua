
--[[
    数据层，子弹信息(暂未用到)
--]]
local PathMgr = require("PathManager")


local BulletData={}

function BulletData:Init()
    self.Bullets={}
    self.Bullets[Enum_BulletType.light]={IconResourcePath=PathMgr.ResourcePath.Icon_LightBullet, IconResourceName=PathMgr.NamePath.Icon_LightBullet, }
    self.Bullets[Enum_BulletType.heavy]={IconResourcePath=PathMgr.ResourcePath.Icon_LightBullet, IconResourceName=PathMgr.NamePath.Icon_LightBullet, }
    self.Bullets[Enum_BulletType.energy]={IconResourcePath=PathMgr.ResourcePath.Icon_LightBullet, IconResourceName=PathMgr.NamePath.Icon_LightBullet, }
    self.Bullets[Enum_BulletType.shell]={IconResourcePath=PathMgr.ResourcePath.Icon_LightBullet, IconResourceName=PathMgr.NamePath.Icon_LightBullet, }
end

BulletData:Init()
return BulletData