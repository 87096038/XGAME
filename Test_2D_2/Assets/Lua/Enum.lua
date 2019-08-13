--[[
Enum = {}

--参数为表，起始位置
function Enum.createEnumTbl(tbl, index)
    local enumTbl = {}
    local enumIndex = index or 0
    for i, v in ipairs(tbl) do
        enumTbl[v] = enumIndex + i
    end
    return enumTbl
end

return Enum
--]]

IS_RELEASE_MODE = false
IS_ONLINE_MODE = false

--- eggs: 彩蛋
Enum_RoomType={born=1, normal=2, treasure=3, shop=4, boss=5, eggs=6}

--- pistol: 手枪   spear: 长矛   rifle: 步枪
Enum_EnemyType={normal_pistol=1, normal_spear=2, normal_shotgun=3, normal_rifle=4}

--- sniper_rifle: 狙击枪    laser_gun: 激光枪
Enum_WeaponType={normal_pistol=1, normal_rifle=2, normal_shotgun=3, normal_sniper_rifle=4, normal_Laser_gun=5, normal_grenade=6}

--- energy: 能量武器的子弹 shell: 炮弹
Enum_BulletType={light=1, heavy=2, energy=3, shell=4}

--- single: 单发   multiple: 连发
Enum_ShootType={single=1, multiple=2}

--- 物体种类
Enum_ItemType={weapon="weapon", }

--- 这里value的类型可以跟随c#里和lua里的KeyValue的key类型一起改变
Enum_MessageType={ChangeScene="ChangeScene", LateChangeScene="LateChangeScene", PickUp="PickUp", GameOver="GameOver", Login="Login",
                  ApproachItem="ApproachItem", LeaveItem="LeaveItem",
}

--- 网络消息类型
Enum_NetMessageType={[1] = Enum_MessageType.Login, }

--- 角色行为类型
--- sprint: 冲刺   use: 使用东西
Enum_CharacterBehaviorType={idle=1, walk=2, run=3, sprint=4, use=5, attack=6, dead=7}

--- 角色加成来源
--- item: 所持有物体 outer_passive: 地牢外的被动加成
Enum_CharacterPowerSourceType={equipment_body=1, item_1=2, item_2=3, outer_passive=4}

--- 增益和减益
---ice_slow: 冰缓  poisoning: 中毒
Enum_BuffAndDebuffType={ice_slow=1, poisoning=2}

--- 场景索引(依照unity里各场景的Index)
Enum_Scenes={Begin=0, Title=1, Rest=2, Battle=3, Loading=4}
Enum_SceneName = {"Begin", "Title", "Rest", "Battle", "Loading"}