
--[[
    数据层，用户信息
--]]

local UserInfo={}

function UserInfo:Init()
    ----------基础信息----------
    self.UID = -1
    self.name = ""
    self.userName = ""
    self.diamondCount = 125
    self.soulShardCount = 0

    ----------角色和皮肤---------
    self.roles = {}
    self.skins = {}

    ----------解锁与未解锁----------
    self.unlockedItems = {}
    self.lockedItems = {}
    self.unlockedWeapons = {}
    self.lockedWeapons = {}
    self.unlockedEquipments = {}
    self.lockedEquipments = {}
    self.unlockedPassiveSkills = {}
    self.lockedPassiveSkills = {}

end

UserInfo:Init()
return UserInfo