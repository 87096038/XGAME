
--[[
    数据层，用户信息
--]]
local MC = require("MessageCenter")
local NetHelper = require("NetHelper")

local UserInfoData={}

function UserInfoData:Init()
    ----------基础信息----------
    self.UID = -1
    self.name = ""
    self.userName = ""
    self.diamondCount = 125
    self.soulShardCount = 0

    ----------角色和皮肤---------
    self.currentRole = nil
    self.currentSkin = nil
    self.roles = {}
    self.skins = {}

    ----------解锁与未解锁----------
    self.UnlockedItems = {}
    self.LockedItems = {}
    self.UnlockedWeapons = {}
    self.LockedWeapons = {}
    self.UnlockedEquipments = {}
    self.LockedEquipments = {}
    self.UnlockedPassiveSkills = {}
    self.LockedPassiveSkills = {}

    ---------添加监听---------
    MC:AddListener(Enum_NetMessageType.Login,handler(self, self.OnLogin))
    MC:AddListener(Enum_NetMessageType.RefreshCurrency,handler(self, self.OnRefreshCurrency))
    MC:AddListener(Enum_NetMessageType.DrawSkin,handler(self, self.OnDrawSkin))
    MC:AddListener(Enum_NetMessageType.RefreshSkin, handler(self, self.OnRefreshSkin))
    MC:AddListener(Enum_NetMessageType.UserInfo, handler(self, self.OnUserInfo))
    MC:AddListener(Enum_NetMessageType.BuyOuterThing, handler(self, self.OnBuyOuterThing))
    MC:AddListener(Enum_NetMessageType.RefreshOuterThing, handler(self, self.OnRefreshOuterThing))
    MC:AddListener(Enum_NetMessageType.ChangeCurrentRoleAndSkin, handler(self, self.OnChangeCurrentRoleAndSkin))

end

--------------事件响应----------------

function UserInfoData:OnLogin(kv)
    MC:SendMessage(Enum_NormalMessageType.Login, kv)
end

function UserInfoData:OnRefreshCurrency(kv)
    self.diamondCount = kv.Value.diamond
    self.soulShardCount = kv.Value.soulShard
    MC:SendMessage(Enum_NormalMessageType.RefreshCurrency, nil)
end
--- 游戏结算
function UserInfoData:OnGameSettlement(kv)

end

function UserInfoData:OnDrawSkin(kv)
    if kv.Value.response == Enum_DrawResponseType.Success then
        NetHelper:SendRefreshSkin("require")            ---刷新Skin
        NetHelper:SendRefreshCurrency("require")        ---刷新货币
    end
    MC:SendMessage(Enum_NormalMessageType.DrawSkin, kv)
end

function UserInfoData:OnRefreshSkin(kv)
    self.skins = kv.Value.ownSkin
    MC:SendMessage(Enum_NormalMessageType.RefreshSkin, nil)
end

function UserInfoData:OnUserInfo(kv)
    self.UID = kv.Value.UID
    self.name = kv.Value.name
    self.userName = kv.Value.userName
    self.diamondCount = kv.Value.diamondCount
    self.soulShardCount = kv.Value.soulShardCount
    self.currentRole = kv.Value.currentRole
    self.currentSkin = kv.Value.currentSkin
    self.roles = kv.Value.roles
    self.skins = kv.Value.skins
    self.UnlockedItems = kv.Value.UnlockedItems or {}
    self.LockedItems = kv.Value.LockedItems or {}
    self.UnlockedWeapons = kv.Value.UnlockedWeapons or {}
    self.LockedWeapons = kv.Value.LockedWeapons or {}
    self.UnlockedEquipments = kv.Value.UnlockedEquipments or {}
    self.LockedEquipments = kv.Value.LockedEquipments or {}
    self.UnlockedPassiveSkills = kv.Value.UnlockedPassiveSkills or {}
    self.LockedPassiveSkills = kv.Value.LockedPassiveSkills or {}

    --MC:SendMessage(Enum_NormalMessageType.RefreshOuterThing, require("KeyValue"):new(nil, Enum_OuterThingType.passiveSkill))
end

function UserInfoData:OnBuyOuterThing(kv)
    if kv.Value.response == Enum_BuyOuterThingResponseType.Success then
        NetHelper:SendRefreshOuterThing("require")
        NetHelper:SendRefreshCurrency("require")
    elseif kv.Value.response == Enum_BuyOuterThingResponseType.NotEnoughSoulShard then
        require("SceneManager"):GetMessageBox("灵魂碎片不足~")
    elseif kv.Value.response == Enum_BuyOuterThingResponseType.NotHavePre then
        require("SceneManager"):GetMessageBox("前置还未获得~(按理说这个弹窗不应该出现)")
    end
end

function UserInfoData:OnRefreshOuterThing(kv)
    self.UnlockedItems = kv.Value.UnlockedItems or {}
    self.LockedItems = kv.Value.LockedItems or {}
    self.UnlockedWeapons = kv.Value.UnlockedWeapons or {}
    self.LockedWeapons = kv.Value.LockedWeapons or {}
    self.UnlockedEquipments = kv.Value.UnlockedEquipments or {}
    self.LockedEquipments = kv.Value.LockedEquipments or {}
    self.UnlockedPassiveSkills = kv.Value.UnlockedPassiveSkills or {}
    self.LockedPassiveSkills = kv.Value.LockedPassiveSkills or {}
    MC:SendMessage(Enum_NormalMessageType.RefreshOuterThing, nil)
end

function UserInfoData:OnChangeCurrentRoleAndSkin(kv)
    if kv.Value.role.type ~= self.currentRole.type then
        self.currentRole = kv.Value.role
        MC:SendMessage(Enum_NormalMessageType.ChangeRole,require("KeyValue"):new(nil, kv.Value.role))
    end
    if kv.Value.skin.roleType ~= self.currentSkin.roleType or kv.Value.skin.index ~= self.currentSkin.index then
        self.currentSkin = kv.Value.skin
        MC:SendMessage(Enum_NormalMessageType.ChangeSkin,require("KeyValue"):new(self.currentSkin.roleType, self.currentSkin.index))
    end
end

UserInfoData:Init()
return UserInfoData