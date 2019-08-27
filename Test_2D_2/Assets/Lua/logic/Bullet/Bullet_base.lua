
local ResourceMgr = require("ResourceManager")
local Timer = require("Timer")

local Bullet_base = Class("Bullet_base", require("Base"))

function Bullet_base:cotr()
    self.super:cotr()

    self.isBounce = false
    self.explosionEffect = nil

end

function Bullet_base:Destroy()
    if self.explosionEffect then

    end
    if not CS.Util.IsNull(self.gameobject) then
        ResourceMgr:DestroyObject(self.gameobject)
    end
    self.super.super.Destroy(self)
end

return Bullet_base