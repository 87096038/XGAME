--[[
    封装了一些路径相关
--]]
local PathManager={}

function PathManager:Init()

    ---自动切换路径
    if IS_RELEASE_MODE then
        self.ResourcePath={
            Bullet_1="assetbundles/prefabs/bullet_1.ab",
            Character_1="assetbundles/prefabs/character.ab",
            Normal_Rifle="assetbundles/prefabs/normal_rifle.ab",
            Normal_Sniper_Rifle="assetbundles/prefabs/normal_sniper_rifle.ab",
            Audio_Title_BGM="assetbundles/audio/audio_title_bgm.ab",
            -----UI-----
            UI_Begin_Imgs="assetbundles/prefabs/ui/begin/beginimgs.ab",
            UI_HotUpdate="assetbundles/prefabs/ui/begin/ui_hotupdate.ab",
            UI_Title = "assetbundles/prefabs/ui/title/ui_title.ab",
            --------Tiles----------
            Tile_Base = "assetbundles/sprite/tiles/floorbrickstograsscorner_0.ab",
            Room01 = "assetbundles/prefabs/rooms/room01.ab",
            Room02 = "assetbundles/prefabs/rooms/room02.ab",
            Room03 = "assetbundles/prefabs/rooms/room03.ab",
            Room04 = "assetbundles/prefabs/rooms/room04.ab",
            Room05 = "assetbundles/prefabs/rooms/room05.ab",
            Room06 = "assetbundles/prefabs/rooms/room06.ab",
            Room07 = "assetbundles/prefabs/rooms/room07.ab",
            Room08 = "assetbundles/prefabs/rooms/room08.ab",
            Road = "assetbundles/prefabs/rooms/road.ab",
            GridRoot = "assetbundles/prefabs/rooms/gridroot.ab",

            Camera_Main = "assetbundles/prefabs/maincamera.ab"
        }
    else
        self.ResourcePath={
            Bullet_1="Prefabs/Bullet_1",
            Character_1="Prefabs/Character",
            Normal_Rifle="Prefabs/Normal_Rifle",
            Normal_Sniper_Rifle="Prefabs/Normal_Sniper_Rifle",
            Audio_Title_BGM="Audio/Audio_Title_BGM",
            -----UI-----
            UI_Begin_Imgs="Prefabs/UI/Begin/BeginImgs",
            UI_HotUpdate="Prefabs/UI/Begin/UI_HotUpdate",
            UI_Title = "Prefabs/UI/Title/UI_Title",
            --------Tiles----------
            Tile_Base = "Sprite/Tiles/FloorBricksToGrassCorner_0",
            Room01 = "Prefabs/Rooms/Room01",
            Room02 = "Prefabs/Rooms/Room02",
            Room03 = "Prefabs/Rooms/Room03",
            Room04 = "Prefabs/Rooms/Room04",
            Room05 = "Prefabs/Rooms/Room05",
            Room06 = "Prefabs/Rooms/Room06",
            Room07 = "Prefabs/Rooms/Room07",
            Room08 = "Prefabs/Rooms/Room08",
            Road = "Prefabs/Rooms/Road",
            GridRoot = "Prefabs/Rooms/GridRoot",

            Camera_Main = "Prefabs/MainCamera"
        }
    end

    ---自动切换名字
    if IS_RELEASE_MODE then
        self.NamePath={
            Bullet_1="bullet_1",
            Character_1="character",
            Normal_Rifle="normal_rifle",
            Normal_Sniper_Rifle="normal_sniper_rifle",
            Audio_Title_BGM="audio_title_bgm",
            -----UI-----
            UI_Begin_Imgs="beginimgs",
            UI_HotUpdate="ui_hotupdate",
            UI_Title = "ui_title",
            --------Tiles----------
            Tile_Base = "floorbrickstograsscorner_0",
            Room01 = "room01",
            Room02 = "room02",
            Room03 = "room03",
            Room04 = "room04",
            Room05 = "room05",
            Room06 = "room06",
            Room07 = "room07",
            Room08 = "room08",
            Road = "road",
            GridRoot = "gridroot",

            Camera_Main = "maincamera"
        }
    else
        self.NamePath={
            --[[
            Bullet_1=nil,
            Character_1=nil,
            Normal_Rifle=nil,
            Normal_Sniper_Rifle=nil,
            Audio_Title_BGM=nil,
            UI_Begin_Imgs=nil,
            UI_HotUpdate=nil,
            -]]
        }
    end

end

---获取文件名
function PathManager:GetName(path)
    --匹配从 / 到 . 之间的字母、数字、下划线
    local reg = [[/([%w_]+)%.]]
    local name = string.match(path, reg)
    return name;
end

function PathManager:GetAssetName(go)

end

---返回值1: 去掉后缀名的字串
---返回值2: .后缀名
function PathManager:RemoveSuffix(path)
    if path then
        local index = string.find(path, [[%.]])
        if index then
            return string.sub(path, 1, index-1), string.sub(path, index)
        end
    end
end

PathManager:Init()

return PathManager