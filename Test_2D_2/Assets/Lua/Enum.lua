--[[
    所有枚举
--]]
------------------------------------------种类-----------------------------------------------------
--- 房间种类
--- eggs: 彩蛋
Enum_RoomType={born=1, normal=2, treasure=3, shop=4, boss=5, eggs=6}

--- 敌人种类
--- pistol: 手枪   spear: 长矛   rifle: 步枪
Enum_EnemyType={normal_pistol=1, normal_spear=2, normal_shotgun=3, normal_rifle=4}

--- 武器种类
--- sniper_rifle: 狙击枪    laser_gun: 激光枪
Enum_WeaponType={normal_pistol=1, normal_rifle=2, normal_shotgun=3, normal_sniper_rifle=4, normal_Laser_gun=5, normal_grenade=6}

--- 子弹种类
--- energy: 能量武器的子弹 shell: 炮弹
Enum_BulletType={light=1, heavy=2, energy=3, shell=4}

--- 装备种类
Enum_EquipmentType={NormalClothes=1, LightArmour=2, MiddleArmour=3, HeavyArmour=4, CXKVest=5, PRClothes=6, GrandmasVest=7, MomsLongJohns=8, }

--- 武器射击种类
--- single: 单发   multiple: 连发
Enum_ShootType={single=1, multiple=2}

--- 物体种类
Enum_ItemType={weapon="weapon",item="item", equipment = "equipment", bullet="bullet", gold="gold", diamond="diamond", soul_shard = "soul_shard"}

--- 角色种类
Enum_RoleType={Adventurer_1="Adventurer_1"}

--- NPC种类
Enum_NPCType={draw_skin="drawSkin", sell_passive_skill = "sell_passive_skill",}

--- 抽奖种类(数量)
Enum_DrawCountType={single=1, ten=2, }

--- OuterThing种类
Enum_OuterThingType={passiveSkill=1, weapons=2, equipments=3, items=4,}

---碰撞类型
Enum_CollisionType={CollisionEnter2D="CollisionEnter2D", CollisionStay2D="CollisionStay2D", CollisionExit2D="CollisionExit2D",
                    TriggerEnter2D="TriggerEnter2D", TriggerStay2D="TriggerStay2D", TriggerExit2D="TriggerExit2D"}

-----------------------------------------角色加成---------------------------------
--- 角色加成类型
Enum_CharacterStateChangeType = {number="States_Number", percent="States_Percent", buff="buff", specialEffects="Special_Effects"}

--- 角色加成具体类型
Enum_CharacterStateSpecificChangeType = {
    heath=1, armor=2, speed=3, lightBulletDamage=4, heavyBulletDamage=5, energyBulletDamage=6, shellBulletDamage=7,
    lightBulletSpeed=8, heavyBulletSpeed=9, energyBulletSpeed=10,shellBulletSpeed=11,
}
--[[
特殊效果类型
ResistPoisoning: 毒素抵抗    ResistFire: 燃烧抵抗    ResistFrozen: 冰冻抵抗    ResistIceSlow: 冰缓抵抗    CostToResurrect: 复活
RestoreLife_Room: 恢复生命(以房间计)    RestoreLife_Level: 恢复生命(以关卡计)
--]]
Enum_SpecialEffectsType= { ResistPoisoning=1, ResistFire=2, ResistFrozen=3, ResistIceSlow=4, Resurrect=10, RestoreLife_Room=11,RestoreLife_Level=12, }

--- 增益和减益
---burning: 燃烧 ice_slow: 冰缓  poisoning: 中毒
Enum_BuffAndDebuffType={burning=1, ice_slow=2, poisoning=3}

--- 道具物体的种类
--- AmysBow: 小艾米的蝴蝶结    Van: 王の哲学    PangsSkateboardShoes: 庞太郎的滑板鞋
Enum_ItemToolType= {AmysBow=1, Van=2, PangsSkateboardShoes=3, }
------------------------------------------消息类型-----------------------------------------------------
--- 普通消息
Enum_NormalMessageType={
    ChangeScene="ChangeScene", LateChangeScene="LateChangeScene", PickUp="PickUp", GameOver="GameOver", Login="Login", DrawSkin="DrawSkin",
    ApproachItem="ApproachItem", LeaveItem="LeaveItem", ApproachNPC="ApproachNPC", LeaveNPC="LeaveNPC", ChangeSkin="ChangeSkin",
    RefreshCurrency="RefreshCurrency", RefreshSkin="RefreshSkin", RefreshOuterThing="RefreshOuterThing", RefreshCharacterState="RefreshCharacterState",
    ChangeHeath = "ChangeHeath", ChangeArmor = "ChangeArmor", ChangeSpeed="ChangeSpeed", ChangeHeathCeiling="ChangeHeathCeiling", ChangeArmorCeiling = "ChangeArmorCeiling", ChangeSpeedCeiling="ChangeSpeedCeiling",
    AddKeepBuff = "AddKeepBuff", RemoveKeepBuff = "RemoveKeepBuff",EnterRoom = "EnterRoom", LeaveRoom = "LeaveRoom",
}

--- 网络消息
Enum_NetMessageType={
    Tick = "Net_Tick", Login="Net_Login", UserInfo="Net_UserInfo", DrawSkin="Net_DrawSkin", RefreshSkin="Net_RefreshSkin", RefreshCurrency="Net_RefreshCurrency",
    ChangeRole = "Net_ChangeRole", ChangeSkin = "Net_ChangeSkin", BuyOuterThing="Net_BuyOuterThing", RefreshOuterThing="Net_RefreshOuterThing",
}

--- 网络消息(index) 格式为:index - Enum_NetMessageType
Enum_NetMessageType_Index={
    [1] = Enum_NetMessageType.Tick, [2] = Enum_NetMessageType.Login, [3] = Enum_NetMessageType.UserInfo,[4] = Enum_NetMessageType.DrawSkin, [5] = Enum_NetMessageType.RefreshSkin,
    [6] = Enum_NetMessageType.RefreshCurrency, [7] = Enum_NetMessageType.BuyOuterThing, [8] = Enum_NetMessageType.RefreshOuterThing,
}
-------------------------------------------消息Response---------------------------------------------
--- 抽奖反馈
Enum_DrawResponseType={Success = 1, NotEnoughDiamond = 11, }

--- 买outerThing反馈
Enum_BuyOuterThingResponseType = {Success = 1, AlreadyOwn = 10, NotEnoughSoulShard = 11, NotHavePre = 12, }

----------------------------------------------其他-----------------------------------------------------
--- 角色行为类型
--- sprint: 冲刺   use: 使用东西
Enum_CharacterBehaviorType={idle=1, walk=2, run=3, sprint=4, use=5, attack=6, dead=7}

--- 角色加成来源
--- item: 所持有物体 outer_passive: 地牢外的被动加成
Enum_CharacterPowerSourceType={equipment_body=1, item_1=2, item_2=3, outer_passive=4}


--- 场景索引(依照unity里各场景的Index)
Enum_Scenes={Begin=0, Title=1, Rest=2, Battle=3, Loading=4}
Enum_SceneName = {"BeginScene", "TitleScene", "RestScene", "BattleScene", "LoadingScene"}