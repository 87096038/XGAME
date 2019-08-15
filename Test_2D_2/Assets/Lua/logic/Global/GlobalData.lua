local MC = require("MessageCenter")
local GlobalAbility = require("GlobalAbilityScale")

local GlobalData={}

function GlobalData:Init()


    ---这里是从服务器获取数据后，计算出的各个数值

    self.currentBattle = nil
    ----------基础信息----------
    self.UID = -1
    self.userName = nil
    self.diamondCount = 0
    self.soulShardCount = 0

    ----------角色和皮肤---------
    self.roles = {}
    self.skins = {}
    self.characterSpeed = 5

    ----------解锁与未解锁----------
    self.unlockedItems = {}
    self.lockedItems = {}
    self.unlockedWeapons = {}
    self.lockedWeapons = {}
    self.unlockedEquipments = {}
    self.lockedEquipments = {}
    self.unlockedPassiveSkills = {}
    self.lockedPassiveSkills = {}

    --------------角色相关----------------

    ----------------物品----------------
    self.AmysBow = {ID=80001, preID=-1, cost=0, name="小艾米的蝴蝶结", info="有一股淡淡的香气。戴上它，虽然显得很奇怪，但是内心却变得很安宁。等等，艾米是谁？",
                    Take = function ()
                        GlobalAbility.lightBulletSpeedScale = lightBulletSpeedScale.lightBulletSpeedScale + 0.2
                        GlobalAbility.heavyBulletSpeedScale = lightBulletSpeedScale.heavyBulletSpeedScale + 0.2
                        MC:SendMessage(Enum_MessageType.RefreshData, require("KeyValue"):new(Enum_ItemType.bullet, nil))
                    end, Dorp = function ()
                        GlobalAbility.lightBulletSpeedScale = lightBulletSpeedScale.lightBulletSpeedScale - 0.2
                        GlobalAbility.heavyBulletSpeedScale = lightBulletSpeedScale.heavyBulletSpeedScale - 0.2
                        MC:SendMessage(Enum_MessageType.RefreshData, require("KeyValue"):new(Enum_ItemType.bullet, nil))
                    end, Use = nil }

    self.Van = {ID=80002, preID=-1, cost=0, name="《王の哲学》", info="Ass♂We♂Can。",
                Take = function ()
                    GlobalAbility.shellBulletDamageScale = lightBulletSpeedScale.shellBulletDamageScale + 0.15
                    GlobalAbility.heavyBulletDamageScale = lightBulletSpeedScale.heavyBulletDamageScale + 0.15
                    if self.currentBattle then
                        self.currentBattle.character:ChangeHeath(50)
                    end
                    MC:SendMessage(Enum_MessageType.RefreshData, require("KeyValue"):new(Enum_ItemType.bullet, nil))
                end, Dorp = function ()
                    GlobalAbility.shellBulletDamageScale = lightBulletSpeedScale.shellBulletDamageScale - 0.15
                    GlobalAbility.heavyBulletDamageScale = lightBulletSpeedScale.heavyBulletDamageScale - 0.15
                    MC:SendMessage(Enum_MessageType.RefreshData, require("KeyValue"):new(Enum_ItemType.bullet, nil))
        end, Use = nil }
    self.PangsSkateboardShoes = {ID=80003, preID=-1, cost=0, name="庞太郎的滑板鞋", info="时尚时尚最时尚。",
                                 Take = function ()
                                     if self.currentBattle then
                                         self.currentBattle.character:ChangeSpeed(0.5, true)
                                     end
                                 end}

    ----------------枪------------------
    self.lightSpeed = 10
    self.heavySpeed = 10
    self.shellSpeed = 5
    --激光宽度
    self.laserWidth = 2



    ----------------敌人----------------
    self.enemyBaseSpeed = 5

    ---------添加监听-----------
    --MC:AddListener(Enum_MessageType.UserInfo, handler(self, self.OnGetUserInfo))
end

function GlobalData:OnGetUserInfo(kv)
    if kv.Value then

    end
end

GlobalData:Init()
return GlobalData