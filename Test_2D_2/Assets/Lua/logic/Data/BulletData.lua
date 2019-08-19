
--[[
    数据层，子弹信息(暂未用到)
--]]

local BulletData={}

function BulletData:Init()
    self.Bullets={}
    self.Bullets[Enum_BulletType.light]={}
end

BulletData:Init()
return BulletData