
--[[
    数据层，房间信息
--]]

local PathMgr = require("PathManager")

local RoomData={}

function RoomData:Init()

    self.levelCnt = 3

    self.Rooms = {}
    for level = 1, self.levelCnt do
        self.Rooms[level] = {}
        for k,v in pairs(Enum_RoomType) do
            self.Rooms[level][v] = {}
        end
    end

    -- 第一关
    -- 出生房间
    self.Rooms[1][Enum_RoomType.born][1] = {path=PathMgr.ResourcePath.Room01, name = PathMgr.NamePath.Room01, length=21, width = 21}
    -- 普通（怪物）房间
    self.Rooms[1][Enum_RoomType.normal][1] = {path=PathMgr.ResourcePath.Room02, name = PathMgr.NamePath.Room02, length=21, width = 21}
    self.Rooms[1][Enum_RoomType.normal][2] = {path=PathMgr.ResourcePath.Room03, name = PathMgr.NamePath.Room03, length=21, width = 21}
    self.Rooms[1][Enum_RoomType.normal][3] = {path=PathMgr.ResourcePath.Room04, name = PathMgr.NamePath.Room04, length=21, width = 21}
    self.Rooms[1][Enum_RoomType.normal][4] = {path=PathMgr.ResourcePath.Room05, name = PathMgr.NamePath.Room05, length=21, width = 21}
    -- 宝箱房间
    self.Rooms[1][Enum_RoomType.treasure][1] = {path=PathMgr.ResourcePath.Room06, name = PathMgr.NamePath.Room06, length=21, width = 21}
    -- 商店房间
    self.Rooms[1][Enum_RoomType.shop][1] = {path=PathMgr.ResourcePath.Room07, name = PathMgr.NamePath.Room07, length=21, width = 21}
    -- boss房间
    self.Rooms[1][Enum_RoomType.boss][1] = {path=PathMgr.ResourcePath.Room08, name = PathMgr.NamePath.Room08, length=21, width = 21}

    -- 第二关
end

RoomData:Init()
return RoomData