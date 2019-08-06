
local Weapon_base=Class("Weapon_base", require("Base"))

function Weapon_base:cotr()
    self.super:cotr()
    ---是否被捡起
    self.isPacked = false
    ---基础伤害
    self.demage = 10
    --- 拥有子弹总数
    self.totalAmmoACount=100
    --- 一弹夹子弹数量
    self.clipsAmmoCount=10
    --- 当前子弹数量
    self.currentAmmoACount=10
    --- 装弹时间
    self.reloadTime=1
end

return Weapon_base