
local Weapon_base=Class("Weapon_base", require("Base"))

function Weapon_base:cotr()
    self.super:cotr()
    ---是否被捡起
    self.isPacked = false
    ---基础伤害
    self.demage = 10
    --- 射击冷却时间
    self.shootCDTime =1
    --- 拥有子弹总数
    self.totalAmmoACount=100
    --- 一弹夹子弹数量
    self.clipsAmmoCount=10
    --- 当前子弹数量
    self.currentAmmoACount=10
    --- 装弹时间
    self.reloadTime=1
end


function Weapon_base:UpdateShoot()
    print("Not implement Exception.")
end

function Weapon_base:Reload()
    print("Not implement Exception.")
end

function Weapon_base:Use()
    print("Not implement Exception.")
end

function Weapon_base:Drop()
    print("Not implement Exception.")
end

--- 刷新数据
function Weapon_base:RefreshData()
    print("Not implement Exception.")
end

return Weapon_base