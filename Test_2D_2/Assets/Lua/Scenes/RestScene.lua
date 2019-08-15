
--[[
    负责Title场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local SceneMgr = require("SceneManager")
local Battle = require("Battle")

local Rest = {}

function Rest:InitScene()
    print("switch to Rest Scene")
    local character = require("Character"):new()
    require("CameraFollowing"):BeginFollow(character.gameobject.transform)
    ---地图Init
    self:InitUI()
    ---NPCInit
    ---特殊物体Init
    Battle:new(character)
    character:Start()
end

function Rest:InitUI()
    local UI_Skin_btn = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Skin_btn, PathMgr.NamePath.UI_Skin_btn, Main.UIRoot.transform)
    local UI_CurrencyInfo = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_CurrencyInfo, PathMgr.NamePath.UI_CurrencyInfo, Main.UIRoot.transform)
end

return Rest