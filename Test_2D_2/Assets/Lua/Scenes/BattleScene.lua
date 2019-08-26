
--[[
    负责Battle场景的初始化
--]]

local Camera =  require("CameraFollowing")

local BeattleScene = {}

function BeattleScene:InitScene()
    local Normal_pistol = require("Normal_pistol"):new()
    local Character = require("Character"):new()
    local battle = require("Battle"):new(Character)
    battle:AddWeapon(Normal_pistol)
    Camera:BeginFollow(Character.gameobject.transform)
    require("RoomManager"):SetCharacter(Character)
    require("RoomManager"):CreateRooms(1,3,1,1)
    Character:Start()
end

return BeattleScene