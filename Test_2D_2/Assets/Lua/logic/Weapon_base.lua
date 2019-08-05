
local Weapon_base=Class("Weapon_base", require("Base"))

function Weapon_base:cotr()
    --- 拥有子弹总数
    self.totalAmmoACount=0
    --- 一弹夹子弹数量
    self.clipsAmmoCount=0
    --- 当前子弹数量
    self.currentAmmoACount=0
    --- 射击冷却时间
    self.shootCDTime =0
    --- 装弹时间
    self.reloadTime=0
end

return Weapon_base