
--[[
    负责Battle场景的初始化
--]]

local Camera =  require("CameraFollowing")
local AudioMgr = require("AudioManager")
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local GunMgr = require("GunManager")

local BeattleScene = {}

function BeattleScene:InitScene()
    --- 创建角色
    local Character = require("Character"):new()
    Camera:BeginFollow(Character.gameobject.transform)
    -- 创建Battle
    local battle = require("Battle"):new(Character)
    battle:BeginFight()
    --- 生成地图
    require("RoomManager"):CreateRooms(1,3,1,1)
    --- 播放BGM
    AudioMgr:PlayBackgroundMusic(ResourceMgr:Load(PathMgr.ResourcePath.Audio_Title_BGM, PathMgr.NamePath.Audio_Title_BGM))
    --- 可以开始移动了
    Character:Start()
end

return BeattleScene