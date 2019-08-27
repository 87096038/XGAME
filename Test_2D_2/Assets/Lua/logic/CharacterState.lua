
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
    for k, v in pairs(Enum_BuffAndDebuffType) do
        self.States[Enum_CharacterStateChangeType.buff][v] = 0
    end
    for k, v in pairs(Enum_SpecialEffectsType) do
        self.States[Enum_CharacterStateChangeType.specialEffects][v] = 0
    end

end

function CharacterState:AddBuff(buff)
    if not buff then
        return
    end
    local isChanged = false
    for k, v in pairs(buff) do
        for k1, v1 in pairs(v) do
            if v1 ~= 0 then
                isChanged = true
                if k == Enum_CharacterStateChangeType.buff and self.States[k][k1] ~= 0 then
                    self.States[k][k1] = self.States[k][k1] > v1 and self.States[k][k1] or v1
                else
                    self.States[k][k1] = self.States[k][k1] + v1
                end
            end
        end
    end
    if isChanged then
        MC:SendMessage(Enum_NormalMessageType.AddKeepBuff, require("KeyValue"):new(nil, buff))
        MC:SendMessage(Enum_NormalMessageType.BuffHasChanged, require("KeyValue"):new(nil, self.States))
    end
end

function CharacterState:RemoveBuff(buff)
    if not buff then
        return
    end
    local isChanged = false
    for k, v in pairs(buff) do
        for k1, v1 in pairs(v) do
            if v1 ~= 0 then
                isChanged = true
                self.States[k][k1] = self.States[k][k1] - v1
            end
        end
    end
    if isChanged then
        MC:SendMessage(Enum_NormalMessageType.RemoveKeepBuff, require("KeyValue"):new(nil, buff))
        MC:SendMessage(Enum_NormalMessageType.BuffHasChanged, require("KeyValue"):new(nil, self.States))
    end
end

return CharacterState