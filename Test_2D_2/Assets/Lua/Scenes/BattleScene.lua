﻿
--[[
    负责Battle场景的初始化
--]]

local BattleScene = {}

function BattleScene:InitScene()
    local Normal_pistol = require("Normal_pistol"):new()
    local Character = require("Character"):new()
    --local battle = require("Battle"):new(Character)
    --battle:AddWeapon(Normal_pistol)
    --Character:Start()
end

return BattleScene