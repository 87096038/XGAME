
local HeavyBullet = Class("HeavyBullet", require("Bullet_base"))

function HeavyBullet:cotr(dirction, position, rotation, speed, damage)
    self.super:cotr()

end

return HeavyBullet