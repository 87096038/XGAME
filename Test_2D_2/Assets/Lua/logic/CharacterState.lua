
--[[
    角色的各种加成
--]]

local UserData = require("UserInfoData")
local PassiveSkill = require("PassiveSkillData")
local MC = require("MessageCenter")

local CharacterState = Class("CharacterState", require("Base"))

function CharacterState:cotr()
    self.States={}
    self.States[Enum_CharacterStateChangeType.number] = {}
    self.States[Enum_CharacterStateChangeType.percent] = {}
    self.States[Enum_CharacterStateChangeType.buff] = {}
    self.States[Enum_CharacterStateChangeType.specialEffects]={}
    for k, v in pairs(Enum_CharacterStateSpecificChangeType)do
        self.States[Enum_CharacterStateChangeType.number][v] = 0
        self.States[Enum_CharacterStateChangeType.percent][v] = 1
    end



end

function CharacterState:AddBuff(buff)
    for k, v in pairs(buff) do
        for k1, v1 in pairs(v) do
            self.States[k][k1] = self.States[k][k1] + v1
        end
    end
    MC:SendMessage(Enum_NormalMessageType.AddKeepBuff, require("KeyValue"):new(nil, buff))
end

function CharacterState:RemoveBuff(buff)
    for k, v in pairs(buff) do
        for k1, v1 in pairs(v) do
            self.States[k][k1] = self.States[k][k1] - v1
        end
    end
    MC:SendMessage(Enum_NormalMessageType.RemoveKeepBuff, require("KeyValue"):new(nil, buff))
end

return CharacterState