
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Bullet = require("Bullet")
local Timer = require("Timer")

local Normal_Sniper_Rifle = Class("Normal_Sniper_Rifle", require("Weapon_base"))

function Normal_Sniper_Rifle:cotr()
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Normal_Sniper_Rifle, PathMgr.NamePath.Normal_Sniper_Rifle)

end

return Normal_Sniper_Rifle