local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local Room = Class("Room")

-- 这相当于static？
-- 因为存在"哈希表"内不能用#来计算个数所以多加了一个RoomTypeCnt
Room.RoomType = {start = 1, boss = 2, monster = 3,
                 shop = 4, treasure = 5, statue = 6, employ = 7}
Room.RoomTypeCnt = 7
Room.Direction = {up = 1, down = 2, left = 3, right = 4}

function Room:cotr(tileMapPath,tileMapName,level,type,length,width)

    -- 这几个属性在构造的时候必须要有
    self.level = level
    self.type = type
    self.length = length or 0
    self.width = width or 0

    --
    self.tileMap = ResourceMgr:Load(tileMapPath,tileMapName)

    -- 这几个属性在生成地图的时候才赋予，位置相对于tilemap
    --self.id = nil
    self.positionX = nil
    self.positionY = nil
    self.active = false

    -- 上下左右的房间
    --self.up = nil
    --self.down = nil
    --self.left = nil
    --self.right = nil
end

function Room:Instantiate()
    ResourceMgr:Instantiate(self.tileMap)
end

function Room:getPosition()
    return self.position;
end

function Room:transformWallToDoor(direction)
    if(direction == Room.Direction.up) then
        -- 统一路宽5
        for i = -2,2,1 do
            local pos = UE.Vector3Int(i,self.width/2,0)
            self.tileMap.setTile(pos,self.doorTileBase)
        end
    elseif(direction == Room.Direction.down) then
        for i = -2,2,1 do
            local pos = UE.Vector3Int(i,-self.width/2,0)
            self.tileMap.setTile(pos,self.doorTileBase)
        end
    elseif(direction == Room.Direction.left) then
        for i = -2,2,1 do
            local pos = UE.Vector3Int(-self.length,i,0)
            self.tileMap.setTile(pos,self.doorTileBase)
        end
    elseif(direction == Room.Direction.right) then
        for i = -2,2,1 do
            local pos = UE.Vector3Int(self.length,i,0)
            self.tileMap.setTile(pos,self.doorTileBase)
        end
    end
end

return Room