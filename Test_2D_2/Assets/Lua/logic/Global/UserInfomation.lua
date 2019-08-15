
--[[
    玩家的信息
--]]

local UserInformation = {}

function UserInformation:SetInformation(uid, name, diamondCount, soulShardCount)
    self.UID = uid
    self.Name = name
    self.diamondCount = diamondCount
    self.soulShardCount = soulShardCount
end

return UserInformation