
--[[
    卖被动的NPC
--]]

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

    self:GenerateItems()
end

function NPC_SellPassiveSkill:GenerateItems()

end

return NPC_SellPassiveSkill