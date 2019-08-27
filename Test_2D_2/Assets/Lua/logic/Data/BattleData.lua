
--[[
    数据层，战场信息
--]]

local MC = require("MessageCenter")

local BattleData={}

function BattleData:Init()
    self.currentBattle=nil

    MC:AddListener(Enum_NetMessageType.LevelReward, handler(self, self.OnLevelReward))
end

--------------消息回调------------
function BattleData:OnLevelReward(kv)
    MC:SendMessage(Enum_NormalMessageType.LevelReward, kv)
end

BattleData:Init()
return BattleData