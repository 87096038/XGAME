local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Enemy = require("Enemy_1")
local Room = require("Room")
local RoomData = require("RoomData")
local MC = require("MessageCenter")

local RoomManager = {}

function RoomManager:Init()



    -- 添加监听
    MC:AddListener(Enum_NormalMessageType.EnterRoom,handler(self,self.AfterEnterRoom))
    MC:AddListener(Enum_NormalMessageType.EnemyDead,handler(self,self.AfterEnemyDead))

end

function RoomManager:StartBattle()
    -- 房间距离
    self.roomDistance = 40

    -- 当前关卡，当前房间
    self.currentLevel = nil
    self.currentRoom = nil

    -- 房间地图记录
    self.roomMapSize = 20
    self.roomMap = {}
    for i = -self.roomMapSize,self.roomMapSize do
        self.roomMap[i]={}
        for j = -self.roomMapSize,self.roomMapSize do
            self.roomMap[i][j] = nil
        end
    end

    -- 主角、子弹、怪物缓存
    self.character = nil
    self.enemies = {}
end

--生成地图，随机生成房间及连接通路
--关卡、怪物房数量、商店房数量、宝箱房数量
function RoomManager:CreateRooms(mapLevel,normalRoomCnt,shopRoomCnt,treasureRoomCnt)
    -- 房间距离
    self.roomDistance = 40

    -- 当前关卡，当前房间
    self.currentLevel = nil
    self.currentRoom = nil

    -- 房间地图记录
    self.roomMapSize = 20
    self.roomMap = {}
    for i = -self.roomMapSize,self.roomMapSize do
        self.roomMap[i]={}
        for j = -self.roomMapSize,self.roomMapSize do
            self.roomMap[i][j] = nil
        end
    end

    -- 主角、子弹、怪物缓存
    self.character = nil
    self.enemies = {}

    -- 实例化网格和road的tileMap
    self.girdRoot = ResourceMgr:GetGameObject(PathMgr.ResourcePath.GridRoot,PathMgr.NamePath.GridRoot,nil,UE.Vector3(0,0,1))
    self.road = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Road,PathMgr.NamePath.Road,self.girdRoot.transform)

    self.tileBase = ResourceMgr:Load(PathMgr.ResourcePath.Tile_Base, PathMgr.NamePath.Tile_Base)
    self.tileWall = ResourceMgr:Load(PathMgr.ResourcePath.Tile_Wall,PathMgr.NamePath.Tile_Wall)

    -- 时间种子
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))

    -- 将各房间加入房间随机池子
    local randomRoomTable = {}
    for i = 1, normalRoomCnt do
        local id = math.random(1,#RoomData.Rooms[mapLevel][Enum_RoomType.normal])
        local room_info = RoomData.Rooms[mapLevel][Enum_RoomType.normal][id]
        local room = Room:new(room_info.path,room_info.name,mapLevel,Enum_RoomType.normal,room_info.length,room_info.width)
        table.insert(randomRoomTable,room)
    end
    for i = 1, shopRoomCnt do
        local id = math.random(1,#RoomData.Rooms[mapLevel][Enum_RoomType.shop])
        local room_info = RoomData.Rooms[mapLevel][Enum_RoomType.shop][id]
        local room = Room:new(room_info.path,room_info.name,mapLevel,Enum_RoomType.shop,room_info.length,room_info.width)
        table.insert(randomRoomTable,room)
    end
    for i = 1, treasureRoomCnt do
        local id = math.random(1,#RoomData.Rooms[mapLevel][Enum_RoomType.treasure])
        local room_info = RoomData.Rooms[mapLevel][Enum_RoomType.treasure][id]
        local room = Room:new(room_info.path,room_info.name,mapLevel,Enum_RoomType.treasure,room_info.length,room_info.width)
        table.insert(randomRoomTable,room)
    end

    -- 起始房间设置于地图（0，0）
    local id = math.random(1,#RoomData.Rooms[mapLevel][Enum_RoomType.born])
    local room_info = RoomData.Rooms[mapLevel][Enum_RoomType.born][id]
    self.roomMap[0][0] = Room:new(room_info.path,room_info.name,mapLevel,Enum_RoomType.born,room_info.length,room_info.width)
    self.roomMap[0][0].positionX = 0
    self.roomMap[0][0].positionY = 0

    -- boss房间，注意这个room_boss后面会用到
    id = math.random(1,#RoomData.Rooms[mapLevel][Enum_RoomType.boss])
    room_info = RoomData.Rooms[mapLevel][Enum_RoomType.boss][id]
    local room_boss = Room:new(room_info.path,room_info.name,mapLevel,Enum_RoomType.boss,room_info.length,room_info.width)

    -- 记录当前关卡等级和房间
    self.currentLevel = mapLevel
    self.currentRoom = self.roomMap[0][0]

    -- 上下左右
    local DirectionX = {0,0,-1,1}
    local DirectionY = {1,-1,0,0}

    -- 随机生成地图算法
    local q = CS.System.Collections.Queue()
    q:Enqueue(self.roomMap[0][0])
    while(q.Count ~= 0 and #randomRoomTable~=0) do
        local currentRoom = q:Dequeue()
        local currentRoomPosX = currentRoom.positionX
        local currentRoomPosY = currentRoom.positionY

        local setRoomCnt = 0

        for i = 1, 4 do

            if #randomRoomTable == 0 then
                break
            end

            -- 这里的while服务于continue，并不是真正的循环，见末尾的break
            while true do
                -- 下一个房间的相对坐标
                local nextRoomPosX = currentRoomPosX + DirectionX[i]
                local nextRoomPosY = currentRoomPosY + DirectionY[i]

                -- 判断该方向是否有房间
                if self.roomMap[nextRoomPosX][nextRoomPosY] ~= nil then
                    break   --continue
                end

                -- 判断是否要在该方向设置房间
                local setRoomOrNOt = math.random(1,2)
                if setRoomOrNOt == 1 then
                    break   --continue
                end

                setRoomCnt = setRoomCnt + 1

                -- 随机一个取出房间，从池子删除，设置位置
                --print(#randomRoomTable)
                local roomPosInTable = math.random(1,#randomRoomTable)
                local nextRoom = randomRoomTable[roomPosInTable]
                --print(#randomRoomTable,nextRoom)
                table.remove(randomRoomTable,roomPosInTable)

                nextRoom.positionX = nextRoomPosX
                nextRoom.positionY = nextRoomPosY

                self.roomMap[nextRoomPosX][nextRoomPosY] = nextRoom

                -- 进队列
                q:Enqueue(self.roomMap[nextRoomPosX][nextRoomPosY])

                if nextRoom.type == Enum_RoomType.boss then
                    break
                end

                -- 插入boss房
                if #randomRoomTable == 0 then
                    table.insert(randomRoomTable,room_boss)
                end

                break   --这个break绝对不能漏
            end
        end
        -- 将currentRoom标记为已经访问
        --roomFlag[currentRoomPosX][currentRoomPosY] = 1

        -- 感觉这样写好糟糕，到时改
        -- 如果这轮没有设置一个房间，那在所有方向都设置一个房间
        if setRoomCnt == 0 then
            for i = 1,4 do
                if #randomRoomTable == 0 then
                    break
                end
                while true do
                    local nextRoomPosX = currentRoomPosX + DirectionX[i]
                    local nextRoomPosY = currentRoomPosY + DirectionY[i]
                    -- 判断该方向是否有房间
                    if self.roomMap[nextRoomPosX][nextRoomPosY] ~= nil then
                        break   --continue
                    end
                    -- 随机一个取出房间，从池子删除，设置位置
                    --print(#randomRoomTable)
                    local roomPosInTable = math.random(1,#randomRoomTable)
                    local nextRoom = randomRoomTable[roomPosInTable]
                    table.remove(randomRoomTable,roomPosInTable)

                    nextRoom.positionX = nextRoomPosX
                    nextRoom.positionY = nextRoomPosY

                    self.roomMap[nextRoomPosX][nextRoomPosY] = nextRoom
                    -- 进队列
                    q:Enqueue(self.roomMap[nextRoomPosX][nextRoomPosY])

                    if nextRoom.type == Enum_RoomType.boss then
                        break
                    end

                    if #randomRoomTable == 0 then
                        table.insert(randomRoomTable,room_boss)
                    end
                    break
                end
            end
        end
    end
    q = nil

    -- 实例化所有房间（和道路）
    self:InstantiateRooms()
    self.equipmnets = {require("ThingsFactory"):GetThing(70001, UE.Vector3(2, 1, 0))}
    self.Weapons={require("ThingsFactory"):GetThing(60004, UE.Vector3(-2, 1, 0)),
                  require("ThingsFactory"):GetThing(60001, UE.Vector3(0, 1, 0))}
end

-- 实例化所有房间
function RoomManager:InstantiateRooms()

    -- 上下左右
    local DirectionX = {0,0,-1,1}
    local DirectionY = {1,-1,0,0}

    -- 用于标记的二维数组
    local roomHasVisited = {}
    for i = -self.roomMapSize, self.roomMapSize do
        roomHasVisited[i]={}
        for j = -self.roomMapSize, self.roomMapSize do
            roomHasVisited[i][j] = false
        end
    end

    local q = CS.System.Collections.Queue()
    q:Enqueue(self.roomMap[0][0])
    while(q.Count ~= 0) do
        local currentRoom = q:Dequeue()
        local currentRoomPosX = currentRoom.positionX
        local currentRoomPosY = currentRoom.positionY

        --房间实例化
        local currentRoomPos = UE.Vector3(currentRoomPosX * self.roomDistance,currentRoomPosY * self.roomDistance,0)
        local currentRoomIns = currentRoom:Instantiate(self.girdRoot.transform,currentRoomPos)
        --标记为已经访问，此处的已访问指生成地图过程，而非游戏中角色已经访问
        roomHasVisited[currentRoomPosX][currentRoomPosY] = true

        for i = 1, 4 do
            local nextRoomPosX = currentRoomPosX + DirectionX[i]
            local nextRoomPosY = currentRoomPosY + DirectionY[i]

            while true do
                -- 如果该方向没有房间就break
                if self.roomMap[nextRoomPosX][nextRoomPosY] == nil then
                    break
                end
                -- 打墙，这里要传实例化后的房间
                self:replaceRoomsWall(currentRoom,currentRoomIns,DirectionX[i],DirectionY[i],self.tileBase)

                -- 判断该房间是否访问过，如果没有就进队列
                if roomHasVisited[nextRoomPosX][nextRoomPosY] then
                    break
                end
                q:Enqueue(self.roomMap[nextRoomPosX][nextRoomPosY])

                -- 造路
                self:InstantiateRoad(currentRoom,self.roomMap[nextRoomPosX][nextRoomPosY],DirectionX[i],DirectionY[i])

                break
            end
        end

    end
end

-- 将道路实例化，参数为房间1，房间2，房间1方向（x，y）
function RoomManager:InstantiateRoad(room1,room2,dx,dy)

    local roadTileMap = self.road:GetComponent(typeof(UE.Tilemaps.Tilemap))
    --
    if dx == 0 then
        local px_1 = room1.positionX * self.roomDistance
        local py_1 = room1.positionY * self.roomDistance + (room1.width-1)/2 * dy + dy

        local px_2 = room2.positionX * self.roomDistance
        local py_2 = room2.positionY * self.roomDistance - (room2.width-1)/2 * dy - dy
        -- 墙
        for i = py_1, py_2, dy do
            local p1 = UE.Vector3Int(px_1-2,i,0)
            roadTileMap:SetTile(p1,self.tileWall)
            local p2 = UE.Vector3Int(px_1+2,i,0)
            roadTileMap:SetTile(p2,self.tileWall)
        end
        -- 路
        for i = px_1 - 1, px_1 + 1 do
            for j = py_1, py_2, dy do
                local p = UE.Vector3Int(i,j,0)
                roadTileMap:SetTile(p,self.tileBase)
            end
        end
    else
        local px_1 = room1.positionX * self.roomDistance + (room1.length-1)/2 * dx
        local py_1 = room1.positionY * self.roomDistance

        local px_2 = room2.positionX * self.roomDistance - (room2.length-1)/2 * dx
        local py_2 = room2.positionY * self.roomDistance
        -- 墙
        for i = px_1, px_2, dx do
            local p1 = UE.Vector3Int(i,py_1-2,0)
            roadTileMap:SetTile(p1,self.tileWall)
            local p2 = UE.Vector3Int(i,py_1+2,0)
            roadTileMap:SetTile(p2,self.tileWall)
        end
        -- 路
        for i = px_1, px_2, dx do
            for j = py_1-1,py_1+1 do
                local p = UE.Vector3Int(i,j,0)
                roadTileMap:SetTile(p,self.tileBase)
            end
        end
    end
end

-- 替换房间的墙壁/门
function RoomManager:replaceRoomsWall(room,roomIns,dx,dy,tile)

    local roomTileMap = roomIns:GetComponent(typeof(UE.Tilemaps.Tilemap))

    local px = (room.length-1)/2 * dx
    local py = (room.width-1)/2 * dy

    if px == 0 then
        for i = px-2,px+2 do
            local p = UE.Vector3Int(i,py,0)
            roomTileMap:SetTile(p,tile)
        end
    else
        for i = py-2,py+2 do
            local p = UE.Vector3Int(px,i,0)
            roomTileMap:SetTile(p,tile)
        end
    end
end

-- 在进入房间门后触发的事件
function RoomManager:AfterEnterRoom(kv)
    local room = kv.Value
    self.currentRoom = room

    print("hello, get the room",room.type,room.positionX,room.positionY)

    --    -- 房间已经访问过
    if room.hasVisited == true then
        return
    end
    room.hasVisited = true
    -- 房间不存在战斗
    if not (room.type == Enum_RoomType.normal or room.type == Enum_RoomType.boss) then
        return
    end
    -- 关门放狗
    self:CloseCurrentRoomsDoor()
    self:CreateMonster()

end

-- 在怪物死后销毁怪物gameObject及table
-- 若怪物缓存table为空，则生城宝箱及打开房间门
function RoomManager:AfterEnemyDead(kv)
    local enemy = kv.Value
    for k,v in ipairs(self.enemies) do
        if enemy == v then
            table.remove(self.enemies,k)
        end
    end
    if #self.enemies == 0 then
        self:CreateTreasure()
        self:OpenCurrentRoomsDoor()
    end
end

-- 在进入怪物房间后关上房间门
function RoomManager:CloseCurrentRoomsDoor()
    -- 上下左右
    local DirectionX = {0,0,-1,1}
    local DirectionY = {1,-1,0,0}

    local room = self.currentRoom
    local currentRoomPosX = room.positionX
    local currentRoomPosY = room.positionY

    for i = 1, 4 do
        local nextRoomPosX = currentRoomPosX + DirectionX[i]
        local nextRoomPosY = currentRoomPosY + DirectionY[i]

        if self.roomMap[nextRoomPosX][nextRoomPosY] ~= nil then
            self:replaceRoomsWall(room,room.gameObject,DirectionX[i],DirectionY[i],self.tileWall)
        end
    end

end

-- n，创建怪物
function RoomManager:CreateMonster()
    local room = self.currentRoom
    local roomPos = room.gameObject.transform.position

    for _,v in pairs(room.enemyBornPos) do
        local enemyBornPos = roomPos + v
        local enemy = Enemy:new(enemyBornPos)
        table.insert(self.enemies,enemy)
    end
end

-- 在怪物全部消灭后生成宝箱
function RoomManager:CreateTreasure()
    print("生成宝箱")
end

-- 在怪物全部消灭后打开房间门
function RoomManager:OpenCurrentRoomsDoor()
    local DirectionX = {0,0,-1,1}
    local DirectionY = {1,-1,0,0}

    local room = self.currentRoom
    local currentRoomPosX = room.positionX
    local currentRoomPosY = room.positionY

    for i = 1, 4 do
        local nextRoomPosX = currentRoomPosX + DirectionX[i]
        local nextRoomPosY = currentRoomPosY + DirectionY[i]

        if self.roomMap[nextRoomPosX][nextRoomPosY] ~= nil then
            self:replaceRoomsWall(room,room.gameObject,DirectionX[i],DirectionY[i],self.tileBase)
        end
    end
end

-- 角色table缓存
function RoomManager:SetCharacter(character)
    self.character = character
end

-- 获取角色table
function RoomManager:GetCharacter()
    return self.character
end

-- 获取怪物
function RoomManager:GetEnemy(go)
    for _,v in ipairs(self.enemies) do
        if v.collision_attack == go then
            print(v,go,v.collision_attack)
            return v
        end
    end
    return nil
end

-- 获取武器
function RoomManager:GetWeapon(go)
    for _, v in ipairs(self.Weapons) do
        if v.gameobject == go then
            return v
        end
    end
    return nil
end

-- 获取装备
function RoomManager:GetEquipment(go)
    for _, v in ipairs(self.equipmnets) do
        if v.gameobject == go then
            return v
        end
    end
    return nil
end

-- 获取道具
function RoomManager:GetItem(go)

end

RoomManager:Init()

return RoomManager