
local ResourceMgr = require("ResourceManager")
local Timer = require("Timer")

local Bullet_base = Class("Bullet_base", require("Base"))

function Bullet_base:cotr()
    self.super:cotr()

    self.isBounce = false
    self.explosionEffect = nil

end

function Bullet_base:Destroy()
    self.super:Destroy()
    if self.explosionEffect then

    end
    ResourceMgr:DestroyObject(self.gameObject)
end

return Bullet_base