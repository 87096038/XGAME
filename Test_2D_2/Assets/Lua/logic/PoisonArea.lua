
--[[
    毒药区 for test
--]]


local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local PoisonArea={}

function PoisonArea:Init()
    self.position = UE.Vector3(-8, 0, -1)
    self.buff = {[Enum_BuffAndDebuffType.poisoning] = 3}
    self.co = nil
    self.isIn = false
end

function PoisonArea:Generate()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.PoisonArea, PathMgr.NamePath.PoisonArea, nil, self.position)
    self.collsion = self.gameobject:GetComponent(typeof(CS.Collision))
    if not self.collsion then
        self.collsion = self.gameobject:AddComponent(typeof(CS.Collision))
    end
    self.collsion.CollisionHandle = function(self, type, other)
        if type == Enum_CollisionType.TriggerEnter2D then
            if other.gameObject.layer == 9 then
                PoisonArea.isIn = true
                PoisonArea.co = StartCoroutine(function ()
                    local wait = UE.WaitForSeconds(1)
                    local chara = require("BattleData").currentBattle.character
                    while(PoisonArea.isIn) do
                        chara:GetDamage(0, PoisonArea.buff)
                        coroutine.yield(wait)
                    end
                end)
            end
        elseif type == Enum_CollisionType.TriggerExit2D then
            if other.gameObject.layer == 9 then
                PoisonArea.isIn = false
            end
        end
    end
end

PoisonArea:Init()
return PoisonArea