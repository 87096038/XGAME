
--[[
    负责Title场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local SceneMgr = require("SceneManager")

local Battle = {}

function Battle:InitScene()

    self.mapLevel = nil
    self.weaponPool = {}
end

return Battle