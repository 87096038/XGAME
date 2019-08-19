
--[[
    数据层，角色信息
--]]


local RoleData={}

function RoleData:Init()
    self.Roles = {}
    self.Roles[Enum_RoleType.Adventurer_1]={
        roleType=Enum_RoleType.Adventurer_1, basicSpeed = 4, skill={}
    }
end

RoleData:Init()
return RoleData