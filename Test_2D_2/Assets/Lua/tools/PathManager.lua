--[[
    封装了一些路径相关
--]]
local PathManager={}

function PathManager:Init()

    ---自动切换路径
    if IS_RELEASE_MODE then
        self.ResourcePath={
            ---------------------------Prefabs-------------------------------------
            Bullet_1="assetbundles/prefabs/bullet_1.ab",
            Character_1="assetbundles/prefabs/character.ab",
            Normal_Rifle="assetbundles/prefabs/gun/normal_rifle.ab",
            Normal_Sniper_Rifle="assetbundles/gun/prefabs/normal_sniper_rifle.ab",
            Audio_Title_BGM="assetbundles/audio/audio_title_bgm.ab",
            Portal = "assetbundles/prefabs/portal.ab",
            -----UI-----
            UI_MessageBox="assetbundles/prefabs/ui/ui_messagebox.ab",

            UI_Begin_Imgs="assetbundles/prefabs/ui/begin/beginimgs.ab",
            UI_HotUpdate="assetbundles/prefabs/ui/begin/ui_hotupdate.ab",
            UI_LoginPnl="assetbundles/prefabs/ui/begin/ui_loginpnl.ab";

            UI_Title = "assetbundles/prefabs/ui/title/ui_title.ab",
            UI_Decoration = "assetbundles/prefabs/ui/title/ui_decoration.ab",

            UI_SkinSelectPnl = "assetbundles/prefabs/ui/rest/ui_skinselectpnl.ab",
            UI_CurrencyInfo = "assetbundles/prefabs/ui/rest/ui_currencyinfo.ab",
            UI_DrawCardPnl = "assetbundles/prefabs/ui/rest/ui_drawcardpnl.ab",
            UI_Skin_btn  = "assetbundles/prefabs/ui/rest/ui_skin_btn.ab",
            UI_SkinItem = "assetbundles/prefabs/ui/rest/ui_skinitem.ab",

            UI_CharacterStateInBattle = "assetbundles/prefabs/ui/battle/ui_characterstate.ab",
            UI_WeaponState = "assetbundles/prefabs/ui/battle/ui_weaponstate.ab",
            UI_BulletState = "assetbundles/prefabs/ui/battle/ui_bulletstate.ab",
            UI_Loading = "assetbundles/prefabs/ui/loading/ui_loading.ab",
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
            ----------NPCs----------
            NPC_DrawCard="assetbundles/prefabs/npc/npc_1.ab",

            Camera_Main = "assetbundles/prefabs/maincamera.ab",
            -------------------------------Assets---------------------------------------
            Animation_Role_1_Skin_1="assetbundles/animations/charactor/ruby/ruby.ab",
            Animation_Role_1_Skin_2="assetbundles/animations/charactor/mrclock/mrclock.ab",
        }
    else
        self.ResourcePath={
            ---------------------------Prefabs-------------------------------------
            Bullet_1="Prefabs/Bullet_1",
            Character_1="Prefabs/Character",
            Normal_Rifle="Prefabs/Gun/Normal_Rifle",
            Normal_Sniper_Rifle="Prefabs/Gun/Normal_Sniper_Rifle",
            Audio_Title_BGM="Audio/Audio_Title_BGM",
            Portal = "Prefabs/Portal",
            -----UI-----
            UI_MessageBox="Prefabs/UI/UI_MessageBox",

            UI_Begin_Imgs="Prefabs/UI/Begin/BeginImgs",
            UI_HotUpdate="Prefabs/UI/Begin/UI_HotUpdate",
            UI_LoginPnl="Prefabs/UI/Begin/UI_LoginPnl";

            UI_Title = "Prefabs/UI/Title/UI_Title",
            UI_Decoration = "Prefabs/UI/Title/UI_Decoration",

            UI_SkinSelectPnl = "Prefabs/UI/Rest/UI_SkinSelectPnl",
            UI_CurrencyInfo = "Prefabs/UI/Rest/UI_CurrencyInfo",
            UI_DrawCardPnl = "Prefabs/UI/Rest/UI_DrawCardPnl",
            UI_Skin_btn  = "Prefabs/UI/Rest/UI_Skin_btn",
            UI_SkinItem = "Prefabs/UI/Rest/UI_SkinItem",

            UI_CharacterStateInBattle = "Prefabs/UI/Battle/UI_CharacterState",
            UI_WeaponState = "Prefabs/UI/Battle/UI_WeaponState",
            UI_BulletState = "Prefabs/UI/Battle/UI_BulletState",

            UI_Loading = "Prefabs/UI/Loading/UI_Loading",
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
            ----------NPCs----------
            NPC_DrawCard="Prefabs/NPC/NPC_1",

            Camera_Main = "Prefabs/MainCamera",
            -------------------------------Assets---------------------------------------
            Animation_Role_1_Skin_1="Animations/Charactor/Ruby/Ruby",
            Animation_Role_1_Skin_2="Animations/Charactor/MrClock/MrClock",
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
            Portal = "portal",

            -----UI-----
            UI_MessageBox="ui_messagebox",

            UI_Begin_Imgs="beginimgs",
            UI_HotUpdate="ui_hotupdate",
            UI_LoginPnl="ui_loginpnl";

            UI_Title = "ui_title",
            UI_Decoration="ui_decoration",

            UI_SkinSelectPnl = "ui_skinselectpnl",
            UI_CurrencyInfo = "ui_currencyinfo",
            UI_DrawCardPnl = "ui_drawcardpnl",
            UI_Skin_btn  = "ui_skin_btn",
            UI_SkinItem = "ui_skinitem",

            UI_CharacterStateInBattle = "ui_characterstate",
            UI_WeaponState = "ui_weaponstate",
            UI_BulletState = "ui_bulletstate",

            UI_Loading = "ui_loading",
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
            ----------NPCs----------
            NPC_DrawCard="npc_1",

            Camera_Main = "maincamera",
            -------------------------------Assets---------------------------------------
            Animation_Role_1_Skin_1="ruby",
            Animation_Role_1_Skin_2="mrclock",
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