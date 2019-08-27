local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Room = require("Room")

local RoomManager = {}

function RoomManager:Init()
    -- 房间资源预加载
    self.girdRoot = ResourceMgr:Load(PathMgr.ResourcePath.GridRoot,PathMgr.NamePath.GridRoot)
    self.road = ResourceMgr:Load(PathMgr.ResourcePath.Road ,PathMgr.NamePath.Road)
    self.tileBase = ResourceMgr:Load(PathMgr.ResourcePath.Tile_Base, PathMgr.NamePath.Tile_Base)

    -- 关卡数
    self.levelCount = 3
    -- 房间之间的距离
    self.roomDistance = 40

    -- 房间缓存池
    self.roomTable = {}
    for i = 1, self.levelCount do
        self.roomTable[i]={}
        -- 注意这里的SceneManager与SceneMgr不同
        for j = 1, Room.RoomTypeCnt do
            self.roomTable[i][j]= {}
        end
    end

    -- 房间地图记录
    self.roomMapSize = 20
    self.roomMap = {}
    for i = -self.roomMapSize,self.roomMapSize do
        self.roomMap[i]={}
        for j = -self.roomMapSize,self.roomMapSize do
            self.roomMap[i][j] = nil
        end
    end

end

function RoomManager:GetEquipment(go)
    for _, v in pairs(self.equipmnets) do
        if v.gameobject == go then
            return v
        end
    end
    return nil
end
function RoomManager:GetWeapon(go)
    for _, v in pairs(self.Weapons) do
        if v.gameobject == go then
            return v
        end
    end
end
function RoomManager:GetItem(go)
    for _, v in pairs(self.Items) do
        if v.gameobject == go then
            return v
        end
    end
end
--生成地图，随机生成房间及连接通路
--关卡、怪物房数量、商店房数量、宝箱房数量
function RoomManager:CreateRooms(mapLevel,monsterRoomCnt,shopRoomCnt,treasureRoomCnt)

    -- 将房间放入缓存池
    self:pushRoomsIntoTable()

    -- 时间种子
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))

    local randomRoomTable = {}
    for i = 1, monsterRoomCnt do
        table.insert(randomRoomTable,self.roomTable[mapLevel][Room.RoomType.monster][i])
    end
    for i = 1, shopRoomCnt do
        table.insert(randomRoomTable,self.roomTable[mapLevel][Room.RoomType.shop][i])
    end
    for i = 1, treasureRoomCnt do
        table.insert(randomRoomTable,self.roomTable[mapLevel][Room.RoomType.treasure][i])
    end

    -- 上下左右
    local DirectionX = {0,0,-1,1}
    local DirectionY = {1,-1,0,0}

    -- 起始房间设置于地图（0，0）
    self.roomMap[0][0] = self.roomTable[mapLevel][Room.RoomType.start][1]
    self.roomMap[0][0].positionX = 0
    self.roomMap[0][0].positionY = 0

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

            while true do
                -- 下一个房间的相对坐标
                local nextRoomPosX = currentRoomPosX + DirectionX[i]
                local nextRoomPosY = currentRoomPosY + DirectionY[i]

                -- 判断该方向是否有房间
                --print(nextRoomPosX,nextRoomPosY)
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

                if nextRoom.type == Room.RoomType.boss then
                    break
                end

                -- 插入boss房
                if #randomRoomTable == 0 then
                    table.insert(randomRoomTable,self.roomTable[mapLevel][Room.RoomType.boss][1])
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

                    if nextRoom.type == Room.RoomType.boss then
                        break
                    end

                    if #randomRoomTable == 0 then
                        table.insert(randomRoomTable,self.roomTable[mapLevel][Room.RoomType.boss][1])
                    end
                    break
                end
            end
        end
    end
    q = nil

    -- 实例化所有房间（和道路）
    self:InstantiateRooms()

    self.Items = {require("ThingsFactory"):GetThing(80002, UE.Vector3(-2, 3, 0)),
                  require("ThingsFactory"):GetThing(80001, UE.Vector3(0, 3, 0)),
                  require("ThingsFactory"):GetThing(80003, UE.Vector3(2, 3, 0)),
    }
    self.equipmnets = {require("ThingsFactory"):GetThing(70001, UE.Vector3(-4, 2, 0)),
                       require("ThingsFactory"):GetThing(70002, UE.Vector3(-3, 2, 0)),
                       require("ThingsFactory"):GetThing(70003, UE.Vector3(-2, 2, 0)),
                       require("ThingsFactory"):GetThing(70004, UE.Vector3(-1, 2, 0)),
                       require("ThingsFactory"):GetThing(70005, UE.Vector3(0, 2, 0)),
                       require("ThingsFactory"):GetThing(70006, UE.Vector3(1, 2, 0)),
                       require("ThingsFactory"):GetThing(70007, UE.Vector3(2, 2, 0)),
    }
    self.Weapons={require("ThingsFactory"):GetThing(60004, UE.Vector3(-2, 1, 0)),
                  require("ThingsFactory"):GetThing(60001, UE.Vector3(0, 1, 0)),
                  require("ThingsFactory"):GetThing(60002, UE.Vector3(2, 1, 0)),

    }
end

function RoomManager:InstantiateRooms()
    self.girdRoot = ResourceMgr:Instantiate(self.girdRoot)

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
        local currentRoomIns = ResourceMgr:Instantiate(currentRoom.tileMap,self.girdRoot.transform,currentRoomPos)
        --标记为已经访问
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
                self:replaceRoomsWall(currentRoom,currentRoomIns,DirectionX[i],DirectionY[i])

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



--房间1，房间2，房间1方向（x，y）
function RoomManager:InstantiateRoad(room1,room2,dx,dy)

    self.road = ResourceMgr:Instantiate(self.road, self.girdRoot.transform)
    local roadTileMap = self.road:GetComponent(typeof(UE.Tilemaps.Tilemap))
    --
    if dx == 0 then
        local px_1 = room1.positionX * self.roomDistance
        local py_1 = room1.positionY * self.roomDistance + (room1.width-1)/2 * dy + dy

        local px_2 = room2.positionX * self.roomDistance
        local py_2 = room2.positionY * self.roomDistance - (room2.width-1)/2 * dy - dy

        for i = px_1 - 2, px_1 + 2 do
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

        for i = px_1, px_2, dx do
            for j = py_1-2,py_1+2 do
                local p = UE.Vector3Int(i,j,0)
                roadTileMap:SetTile(p,self.tileBase)
            end
        end
    end
end

function RoomManager:replaceRoomsWall(room,roomIns,dx,dy)

    local roomTileMap = roomIns:GetComponent(typeof(UE.Tilemaps.Tilemap))


    local px = (room.length-1)/2 * dx
    local py = (room.width-1)/2 * dy

    if px == 0 then
        for i = px-2,px+2 do
            local p = UE.Vector3Int(i,py,0)
            roomTileMap:SetTile(p,self.tileBase)
        end
    else
        for i = py-2,py+2 do
            local p = UE.Vector3Int(px,i,0)
            roomTileMap:SetTile(p,self.tileBase)
        end
    end
end


-- 该函数用于将所有的场景先放入table中
-- 但应该会很占内存？
-- 暂时用来测试
function RoomManager:pushRoomsIntoTable()
    -- tileMapPath,doorTileBasePath,level,type,length,width
    -- 啊看着好难受
    table.insert(self.roomTable[1][Room.RoomType.start],Room:new(PathMgr.ResourcePath.Room01, PathMgr.NamePath.Room01, 1, Room.RoomType.start, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.boss],Room:new(PathMgr.ResourcePath.Room02, PathMgr.NamePath.Room02, 1, Room.RoomType.boss, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.monster],Room:new(PathMgr.ResourcePath.Room03, PathMgr.NamePath.Room03, 1, Room.RoomType.monster, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.monster],Room:new(PathMgr.ResourcePath.Room04, PathMgr.NamePath.Room04, 1, Room.RoomType.monster, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.monster],Room:new(PathMgr.ResourcePath.Room05, PathMgr.NamePath.Room05, 1, Room.RoomType.monster, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.monster],Room:new(PathMgr.ResourcePath.Room06, PathMgr.NamePath.Room06, 1, Room.RoomType.monster, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.shop],Room:new(PathMgr.ResourcePath.Room07, PathMgr.NamePath.Room07, 1, Room.RoomType.shop, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.treasure],Room:new(PathMgr.ResourcePath.Room08, PathMgr.NamePath.Room08, 1, Room.RoomType.treasure, 21, 21))
end

RoomManager:Init()

return RoomManager