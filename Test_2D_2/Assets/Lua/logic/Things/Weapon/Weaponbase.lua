
local Weaponbase=Class("Weaponbase", require("Base"))

function Weaponbase:cotr()
    self.super:cotr()
    ---是否被捡起
    self.isPacked = false

    self.weaponType = nil
    self.bulletType = nil
    self.shootType = nil

    self.demage = nil
    self.bulletSpeed = nil
    self.shootCDTime = nil
    self.clipsAmmoCount = nil

    self.isReloading = false
end

function Weaponbase:UpdateShootBegin()
    print("Not implement Exception from "..self.name)
end

function Weaponbase:UpdateShoot()
    print("Not implement Exception from "..self.name)
end

function Weaponbase:UpdateShootEnd()
    print("Not implement Exception from "..self.name)
end

function Weaponbase:Reload()
    print("Not implement Exception from "..self.name)
end

function Weaponbase:Use()
    print("Not implement Exception from "..self.name)
end

function Weaponbase:Drop()
    print("Not implement Exception from "..self.name)
end

return Weaponbase