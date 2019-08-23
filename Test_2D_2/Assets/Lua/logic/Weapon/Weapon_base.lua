
local Weapon_base=Class("Weapon_base", require("Base"))

function Weapon_base:cotr()
    self.super:cotr()
    ---是否被捡起
    self.isPacked = false
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

return Weapon_base