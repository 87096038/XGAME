--[[
    封装了一些路径相关
--]]
local PathManager={}

function PathManager:Init()

    ---自动切换路径
    if IS_RELEASE_MODE then
        self.ResourcePath={
            --Bullet_1="XXXX.ab",
            --Character_1="XXXX.ab",
        }
    else
        self.ResourcePath={
            Bullet_1="Prefabs/Bullet_1",
            Character_1="Prefabs/Character",
            Normal_Rifle="Prefabs/Normal_Rifle",
            Normal_Sniper_Rifle="Prefabs/Normal_Sniper_Rifle",
            Audio_Title_BGM="Audio/Audio_Title_BGM",
            UI_Begin_Imgs="Prefabs/UI/Begin/BeginImgs",
            UI_HotUpdate="Prefabs/UI/Begin/UI_HotUpdate",
            UI_Title = "Prefabs/UI/Title/UI_Title",
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
        }
    end

    ---自动切换名字
    if IS_RELEASE_MODE then
        self.NamePath={
            --Bullet_1="Bullet_1",
            --Character_1="Character_1",
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