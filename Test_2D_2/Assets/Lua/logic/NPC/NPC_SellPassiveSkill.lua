
--[[
    卖被动的NPC
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local MC= require("MessageCenter")
local UserData = require("UserInfoData")

local NPC_SellPassiveSkill ={}

function NPC_SellPassiveSkill:Init()
    self.position = UE.Vector3(2, 5, 0)
    self.type = Enum_NPCType.sell_passive_skill
    self.gameobject = nil
    self.SelledItems = nil
end

function NPC_SellPassiveSkill:Generate()
    if self.gameobject then
        return
    end
    local isNew
    self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.NPC_SellPassiveSkill, PathMgr.NamePath.NPC_SellPassiveSkill, nil, self.position)
    self.SelledItems = self.gameobject:GetComponentsInChildren(typeof(UE.Transform))
    --self.FirstObj = self.gameobject.transform:Find("Container"):Find("First").gameObject
    --self.SecondObj = self.gameobject.transform:Find("Container"):Find("Second").gameObject
    --self.ThirdObj = self.gameobject.transform:Find("Container"):Find("Third").gameObject
    self:GenerateItems()
end

function NPC_SellPassiveSkill:GenerateItems()
    --UserData.lockedPassiveSkills
end

return NPC_SellPassiveSkill