
--[[
    数据层，角色信息
--]]


local RoleData={}

function RoleData:Init()
    self.Roles = {}
    self.Roles[Enum_RoleType.Adventurer_1]={
        roleType=Enum_RoleType.Adventurer_1, name="小丑凯奇", basicHeath = 100, basicArmor=10, basicSpeed = 5, skill={}
    }
end

RoleData:Init()
return RoleData