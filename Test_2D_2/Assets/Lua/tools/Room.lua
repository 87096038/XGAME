local ResourceMgr = require("ResourceManager")
local MC = require("MessageCenter")

local Room = Class("Room", require("Base"))

-- 构造函数
function Room:cotr(tileMapPath,tileMapName,level,type,length,width)
    -- 基本属性
    self.level = level
    self.type = type
    self.length = length
    self.width = width

    -- 预先资源加载
    self.tileMap = ResourceMgr:Load(tileMapPath,tileMapName)

    -- 下面函数用到的一些东西
    self.gameObject = nil
    self.collision = nil

    -- 坐标位置，相对于tilemap，生成地图时赋予
    self.positionX = nil
    self.positionY = nil

    -- 房间状态
    self.hasVisited = false
    self.active = false

    self.enemyBornPos = {UE.Vector3(-5,-5),UE.Vector3(-5,5),UE.Vector3(5,-5),UE.Vector3(5,5)}
end

-- 实例化
function Room:Instantiate(parent,pos)
    -- 实例化
    self.gameObject = ResourceMgr:Instantiate(self.tileMap,parent,pos)
    -- 绑定碰撞
    self:Collision()
    -- 返回实例对象
    return self.gameObject
end

function Room:Collision()
    local thisTable = self
    if not self.collision then
        self.collision = self.gameObject:AddComponent(typeof(CS.Collision))
    end
    self.collision.CollisionHandle = function(self, type, other)
        if type == Enum_CollisionType.TriggerEnter2D then
            if other.gameObject.layer == 9 then
                print("enter room",thisTable.level,thisTable.type)
                MC:SendMessage(Enum_MessageType.EnterRoom, require("KeyValue"):new(nil, thisTable))
            end
        elseif type == Enum_CollisionType.TriggerExit2D then
            if other.gameObject.layer == 9 then
                MC:SendMessage(Enum_MessageType.EnterRoom, require("KeyValue"):new(nil, thisTable))
            end
        end
    end
end

return Room