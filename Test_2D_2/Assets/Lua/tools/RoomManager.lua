local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Room = require("Room")

local RoomManager = {}

function RoomManager:Init()
    self.girdRoot = ResourceMgr:Load(PathMgr.ResourcePath.GridRoot,PathMgr.NamePath.GridRoot)
    self.road = ResourceMgr:Load(PathMgr.ResourcePath.Road,PathMgr.NamePath.Road)

    -- 关卡数
    self.levelCount = 3

    -- 房间缓存池
    self.roomTable = {}
    for i = 1, self.levelCount do
        self.roomTable[i]={}
        -- 注意这里的SceneManager与SceneMgr不同
        for j = 1, Room.RoomTypeCnt do
            self.roomTable[i][j]= {}
        end
    end

    -- 房间地图
    self.roomMapSize = 20
    self.roomMap = {}
    for i = -self.roomMapSize,self.roomMapSize do
        self.roomMap[i]={}
        for j = -self.roomMapSize,self.roomMapSize do
            self.roomMap[i][j] = nil
        end
    end

    self.roomDistance = 40

    --这里的长宽度均指一个地图格子的个数
    --self.roadLength = 21
    --self.roadWidth = 5
    --self.roomLength = 17
    --self.roomWidth = 17

    -- 将房间放入缓存池
    self:pushRoomsIntoTable()
end

--生成地图，随机生成房间及连接通路
--关卡、怪物房数量、商店房数量、宝箱房数量
function RoomManager:CreateRooms(mapLevel,monsterRoomCnt,shopRoomCnt,treasureRoomCnt)

    --local startRoomCnt = 1
    --local bossRoomCnt = 1
    --local mRoomCnt = monsterRoomCnt
    --local sRoomCnt = shopRoomCnt
    --local tRoomCnt = treasureRoomCnt
    --local roomCnt = startRoomCnt+bossRoomCnt+monsterRoomCnt+shopRoomCnt+treasureRoomCnt

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

    -- 测试随机地图用
    --for i = -self.roomMapSize,self.roomMapSize do
    --    for j = -self.roomMapSize,self.roomMapSize do
    --        if self.roomMap[i][j] ~= nil then
    --            print(self.roomMap[i][j].positionX,self.roomMap[i][j].positionY,self.roomMap[i][j].type)
    --        end
    --    end
    --end

    -- 实例化所有房间（和道路）
    self:InstantiateRooms()
end

function RoomManager:InstantiateRooms()
    self.girdRoot = ResourceMgr:Instantiate(self.girdRoot)
    self.road = ResourceMgr:Instantiate(self.road, self.girdRoot.transform)

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

    -- 关于tilebase的加载方式到时得改
    local roadTileMap = self.road:GetComponent(typeof(UE.Tilemaps.Tilemap))
    local tileBase = ResourceMgr:Load(PathMgr.ResourcePath.Tile_Base, PathMgr.NamePath.Tile_Base)

    -- 这段代码重复有点多，到时得改善
    if (dx == 0 and dy == 1) then
        local p1X = room1.positionX * self.roomDistance
        local p1Y = room1.positionY * self.roomDistance + (room1.width-1)/2 + 1
        --local p1 = UE.Vector3Int(p1X,p1Y,0)

        local p2X = room2.positionX * self.roomDistance
        local p2Y = room2.positionY * self.roomDistance - (room1.width-1)/2 - 1
        --local p2 = UE.Vector3Int(p2X,p2Y,0)

        for i = p1X-2,p1X+2 do
            for j = p1Y,p2Y do
                local p = UE.Vector3Int(i,j,0)
                roadTileMap:SetTile(p,tileBase)
            end
        end
    elseif (dx == 0 and dy == -1) then
        local p1X = room1.positionX * self.roomDistance
        local p1Y = room1.positionY * self.roomDistance - (room1.width-1)/2 - 1

        local p2X = room2.positionX * self.roomDistance
        local p2Y = room2.positionY * self.roomDistance + (room1.width-1)/2 + 1

        for i = p1X-2,p1X+2 do
            for j = p2Y,p1Y do
                local p = UE.Vector3Int(i,j,0)
                roadTileMap:SetTile(p,tileBase)
            end
        end
    elseif (dx == -1 and dy == 0) then
        local p1X = room1.positionX * self.roomDistance - (room1.length-1)/2 - 1
        local p1Y = room1.positionY * self.roomDistance

        local p2X = room2.positionX * self.roomDistance + (room1.length-1)/2 + 1
        local p2Y = room2.positionY * self.roomDistance

        for i = p2X,p1X do
            for j = p1Y-2,p1Y+2 do
                local p = UE.Vector3Int(i,j,0)
                roadTileMap:SetTile(p,tileBase)
            end
        end
    elseif (dx == 1 and dy == 0) then
        local p1X = room1.positionX * self.roomDistance + (room1.length-1)/2 + 1
        local p1Y = room1.positionY * self.roomDistance

        local p2X = room2.positionX * self.roomDistance - (room1.length-1)/2 - 1
        local p2Y = room2.positionY * self.roomDistance
        for i = p1X,p2X do
            for j = p1Y-2,p1Y+2 do
                local p = UE.Vector3Int(i,j,0)
                roadTileMap:SetTile(p,tileBase)
            end
        end
    end


    -- p1-4对应room1上下左右中点
    -- 上边的点
    --local p1X = room1.positionX * self.roomDistance
    --local p1Y = room1.positionY * self.roomDistance + (room1.width-1)/2 + 1
    --local p1 = UE.Vector3Int(p1X,p1Y,0)

    -- 下边的点
    --local p2X = room1.positionX * self.roomDistance
    --local p2Y = room1.positionY * self.roomDistance - (room1.width-1)/2 - 1
    --local p2 = UE.Vector3Int(p2X,p2Y,0)

    -- 左边的点
    --local p3X = room1.positionX * self.roomDistance - (room1.length-1)/2 - 1
    --local p3Y = room1.positionY * self.roomDistance
    --local p3 = UE.Vector3Int(p3X,p3Y,0)

    -- 右边的点
    --local p4X = room1.positionX * self.roomDistance + (room1.length-1)/2 + 1
    --local p4Y = room1.positionY * self.roomDistance
    --local p4 = UE.Vector3Int(p4X,p4Y,0)
end

function RoomManager:replaceRoomsWall(room,roomIns,dx,dy)

    local roomTileMap = roomIns:GetComponent(typeof(UE.Tilemaps.Tilemap))
    local tileBase = ResourceMgr:Load(PathMgr.ResourcePath.Tile_Base, PathMgr.NamePath.Tile_Base)

    if (dx == 0 and dy == 1) then
        local pX = 0
        local pY = (room.width-1)/2

        for i = pX-2,pX+2 do
            local p = UE.Vector3Int(i,pY,0)
            roomTileMap:SetTile(p,tileBase)
        end
    elseif (dx == 0 and dy == -1) then
        local pX = 0
        local pY = -(room.width-1)/2

        for i = pX-2,pX+2 do
            local p = UE.Vector3Int(i,pY,0)
            roomTileMap:SetTile(p,tileBase)
        end
    elseif (dx == -1 and dy == 0) then
        local pX = -(room.length-1)/2
        local pY = 0

        for i = pY-2,pY+2 do
            local p = UE.Vector3Int(pX,i,0)
            roomTileMap:SetTile(p,tileBase)
        end
    elseif (dx == 1 and dy == 0) then
        local pX = (room.length-1)/2
        local pY = 0

        for i = pY-2,pY+2 do
            local p = UE.Vector3Int(pX,i,0)
            roomTileMap:SetTile(p,tileBase)
        end
    end
end

--function SceneManager:pushRoomIntoTable(Path,roomLevel,roomType,roomLength,roomWidth)
--
--end

-- 该函数用于将所有的场景先放入table中
-- 但应该会很占内存？
-- 暂时用来测试
function RoomManager:pushRoomsIntoTable()
    -- tileMapPath,doorTileBasePath,level,type,length,width
    -- 啊看着好难受
    table.insert(self.roomTable[1][Room.RoomType.start],Room:new(PathMgr.ResourcePath.Room01, PathMgr.ResourcePath.Tile_Base, 1, Room.RoomType.start, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.boss],Room:new(PathMgr.ResourcePath.Room02, PathMgr.ResourcePath.Tile_Base, 1, Room.RoomType.boss, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.monster],Room:new(PathMgr.ResourcePath.Room03, PathMgr.ResourcePath.Tile_Base, 1, Room.RoomType.monster, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.monster],Room:new(PathMgr.ResourcePath.Room04, PathMgr.ResourcePath.Tile_Base, 1, Room.RoomType.monster, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.monster],Room:new(PathMgr.ResourcePath.Room05, PathMgr.ResourcePath.Tile_Base, 1, Room.RoomType.monster, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.monster],Room:new(PathMgr.ResourcePath.Room06, PathMgr.ResourcePath.Tile_Base, 1, Room.RoomType.monster, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.shop],Room:new(PathMgr.ResourcePath.Room07, PathMgr.ResourcePath.Tile_Base, 1, Room.RoomType.shop, 21, 21))
    table.insert(self.roomTable[1][Room.RoomType.treasure],Room:new(PathMgr.ResourcePath.Room08, PathMgr.ResourcePath.Tile_Base, 1, Room.RoomType.treasure, 21, 21))
end

RoomManager:Init()

return RoomManager