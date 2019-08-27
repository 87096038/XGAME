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
            Enemy_1="assetbundles/prefabs/enemy_1.ab",
            PoisonArea="assetbundles/prefabs/poisonarea.ab",

            Trivial_Thing_Bullet_Box="assetbundles/prefabs/trivialthings/bulletbox.ab",
            Trivial_Thing_Gold="assetbundles/prefabs/trivialthings/gold.ab",
            -------Guns-----------------
            Gun_Normal_Rifle="assetbundles/prefabs/gun/normal_rifle.ab",
            Gun_Normal_Sniper_Rifle="assetbundles/prefabs/gun/normal_sniper_rifle.ab",
            Gun_Normal_Pistol="assetbundles/prefabs/gun/normal_pistol.ab",

            Portal = "assetbundles/prefabs/portal.ab",


            Icon_LightBullet = "assetbundles/prefabs/bullets/icon_lightbullet.ab",

            ---------------Item-------------------
            Item_AmysBow ="assetbundles/prefabs/items/amysbow.ab",
            Item_Van ="assetbundles/prefabs/items/van.ab",
            Item_PangsSkateboardShoes ="assetbundles/prefabs/items/pangsskateboardshoes.ab",

            -------------Equipments----------------
            Equipments_NormalClothes = "assetbundles/prefabs/equipments/normalclothes.ab",
            Equipments_LightArmour = "assetbundles/prefabs/equipments/lightarmour.ab",
            Equipments_MiddleArmour = "assetbundles/prefabs/equipments/middlearmour.ab",
            Equipments_HeavyArmour = "assetbundles/prefabs/equipments/heavyarmour.ab",
            Equipments_CXKVest = "assetbundles/prefabs/equipments/cxkvest.ab",
            Equipments_PRClothes = "assetbundles/prefabs/equipments/prclothes.ab",
            Equipments_GrandmasVest = "assetbundles/prefabs/equipments/grandmasvest.ab",
            Equipments_MomsLongJohns = "assetbundles/prefabs/equipments/momslongjohns.ab",

            -----UI-----
            UI_MessageBox="assetbundles/prefabs/ui/ui_messagebox.ab",
            UI_Setting="assetbundles/prefabs/ui/ui_setting.ab",

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
            UI_IconItem = "assetbundles/prefabs/ui/rest/ui_iconitem.ab",
            UI_PassiveSkillInfo = "assetbundles/prefabs/ui/rest/ui_passiveskillinfo.ab",

            UI_CharacterStateInBattle = "assetbundles/prefabs/ui/battle/ui_characterstate.ab",
            UI_WeaponState = "assetbundles/prefabs/ui/battle/ui_weaponstate.ab",
            UI_BulletState = "assetbundles/prefabs/ui/battle/ui_bulletstate.ab",
            UI_ItemInfo = "assetbundles/prefabs/ui/battle/ui_iteminfo.ab",
            UI_WeaponInfo = "assetbundles/prefabs/ui/battle/ui_weaponinfo.ab",
            UI_EquipmentInfo = "assetbundles/prefabs/ui/battle/ui_equipmentinfo.ab",
            UI_ItemsContainer = "assetbundles/prefabs/ui/battle/ui_itemscontainer.ab",
            UI_GoldAndSoulShard = "assetbundles/prefabs/ui/battle/ui_goldandsoulshard.ab",
            UI_Equipments = "assetbundles/prefabs/ui/battle/ui_equipments.ab",

            UI_Loading = "assetbundles/prefabs/ui/loading/ui_loading.ab",
            --------Tiles----------
            Tile_Base = "assetbundles/sprite/tiles/floorbrickstograsscorner_0.ab",
            Tile_Wall = "assetbundles/sprite/tiles/floorbrickstograsscorner_2.ab",
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
            NPC_DrawSkin="assetbundles/prefabs/npc/skinseller.ab",
            NPC_SellPassiveSkill="assetbundles/prefabs/npc/passiveskillseller.ab",
            NPC_SellEquipment="assetbundles/prefabs/npc/equipmentseller.ab",
            NPC_SellItem="assetbundles/prefabs/npc/itemseller.ab",

            Camera_Main = "assetbundles/prefabs/maincamera.ab",
            -------------------------------Assets---------------------------------------
            -----------Animation---------
            Animation_Role_1_Skin_1="assetbundles/animations/charactor/ruby/ruby.ab",
            Animation_Role_1_Skin_2="assetbundles/animations/charactor/mrclock/mrclock.ab",
            ----------Sprite-------------
            Sprite_Role_1_Skin_1="assetbundles/sprite/characters/ruby.ab",
            Sprite_Role_1_Skin_2="assetbundles/sprite/characters/mrclock.ab",
            Sprite_Cursor_1 = "assetbundles/sprite/cursor_1.ab",
            Sprite_Equipment_LightArmour = "assetbundles/sprite/equipment/lightarmour.ab",
            Sprite_Equipment_MiddleArmour = "assetbundles/sprite/equipment/middlearmour.ab",
            Sprite_Equipment_HeavyArmour = "assetbundles/sprite/equipment/heavyarmour.ab",
            Sprite_Equipment_CXKVest = "assetbundles/sprite/equipment/cxkvest.ab",
            Sprite_Equipment_PRClothes = "assetbundles/sprite/equipment/prclothes.ab",
            Sprite_Equipment_GrandmasVest = "assetbundles/sprite/equipment/grandmasvest.ab",
            Sprite_Equipment_MomsLongJohns = "assetbundles/sprite/equipment/momslongjohns.ab",
            ---------SpriteAtlas----------
            SpriteAtlas_Icons = "assetbundles/sprite/atlas/common.ab",

            ----------Audio--------------
            Audio_Title_BGM="assetbundles/audio/audio_title_bgm.ab",

            Audio_Shoot_ES="assetbundles/audio/shoot.ab",
            Audio_ReloadAmmo_Es="assetbundles/audio/reloadammo.ab",
        }
    else
        self.ResourcePath={
            ---------------------------Prefabs-------------------------------------
            Bullet_1="Prefabs/Bullet_1",
            Character_1="Prefabs/Character",
            Enemy_1 = "Prefabs/Enemy_1",
            PoisonArea="Prefabs/PoisonArea",

            Trivial_Thing_Bullet_Box="Prefabs/TrivialThings/BulletBox",
            Trivial_Thing_Gold="Prefabs/TrivialThings/Gold",

            -------Guns-----------------
            Gun_Normal_Pistol="Prefabs/Gun/Normal_Pistol",
            Gun_Normal_Rifle="Prefabs/Gun/Normal_Rifle",
            Gun_Normal_Sniper_Rifle="Prefabs/Gun/Normal_Sniper_Rifle",

            Portal = "Prefabs/Portal",



            Icon_LightBullet = "Prefabs/Bullets/Icon_LightBullet",

            ---------------Item-------------------
           Item_AmysBow ="Prefabs/Items/AmysBow",
           Item_Van ="Prefabs/Items/Van",
           Item_PangsSkateboardShoes ="Prefabs/Items/PangsSkateboardShoes",

            -------------Equipments----------------
            Equipments_NormalClothes = "Prefabs/Equipments/NormalClothes",
            Equipments_LightArmour = "Prefabs/Equipments/LightArmour",
            Equipments_MiddleArmour = "Prefabs/Equipments/MiddleArmour",
            Equipments_HeavyArmour = "Prefabs/Equipments/HeavyArmour",
            Equipments_CXKVest = "Prefabs/Equipments/CXKVest",
            Equipments_PRClothes = "Prefabs/Equipments/PRClothes",
            Equipments_GrandmasVest = "Prefabs/Equipments/GrandmasVest",
            Equipments_MomsLongJohns = "Prefabs/Equipments/MomsLongJohns",
            -----UI-----
            UI_MessageBox="Prefabs/UI/UI_MessageBox",
            UI_Setting="Prefabs/UI/UI_Setting",

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
            UI_IconItem = "Prefabs/UI/Rest/UI_IconItem",
            UI_PassiveSkillInfo = "Prefabs/UI/Rest/UI_PassiveSkillInfo",

            UI_CharacterStateInBattle = "Prefabs/UI/Battle/UI_CharacterState",
            UI_WeaponState = "Prefabs/UI/Battle/UI_WeaponState",
            UI_BulletState = "Prefabs/UI/Battle/UI_BulletState",
            UI_ItemInfo = "Prefabs/UI/Battle/UI_ItemInfo",
            UI_WeaponInfo = "Prefabs/UI/Battle/UI_WeaponInfo",
            UI_EquipmentInfo = "Prefabs/UI/Battle/UI_EquipmentInfo",
            UI_ItemsContainer = "Prefabs/UI/Battle/UI_ItemsContainer",
            UI_GoldAndSoulShard = "Prefabs/UI/Battle/UI_GoldAndSoulShard",
            UI_Equipments = "Prefabs/UI/Battle/UI_Equipments",

            UI_Loading = "Prefabs/UI/Loading/UI_Loading",
            --------Tiles----------
            Tile_Base = "Sprite/Tiles/FloorBricksToGrassCorner_0",
            Tile_Wall = "Sprite/Tiles/FloorBricksToGrassCorner_2",
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
            NPC_DrawSkin="Prefabs/NPC/SkinSeller",
            NPC_SellPassiveSkill="Prefabs/NPC/PassiveSkillSeller",
            NPC_SellEquipment="Prefabs/NPC/EquipmentSeller",
            NPC_SellItem="Prefabs/NPC/ItemSeller",

            Camera_Main = "Prefabs/MainCamera",
            -------------------------------Assets---------------------------------------
            -----------Animation---------
            Animation_Role_1_Skin_1="Animations/Charactor/Ruby/Ruby",
            Animation_Role_1_Skin_2="Animations/Charactor/MrClock/MrClock",
            ----------Sprite-------------
            Sprite_Role_1_Skin_1="Sprite/Characters/Ruby",
            Sprite_Role_1_Skin_2="Sprite/Characters/MrClock",

            Sprite_Cursor_1 = "Sprite/Cursor_1",
            Sprite_Equipment_LightArmour = "Sprite/Equipment/LightArmour",
            Sprite_Equipment_MiddleArmour = "Sprite/Equipment/MiddleArmour",
            Sprite_Equipment_HeavyArmour = "Sprite/Equipment/HeavyArmour",
            Sprite_Equipment_CXKVest = "Sprite/Equipment/CXKVest",
            Sprite_Equipment_PRClothes = "Sprite/Equipment/PRClothes",
            Sprite_Equipment_GrandmasVest = "Sprite/Equipment/GrandmasVest",
            Sprite_Equipment_MomsLongJohns = "Sprite/Equipment/MomsLongJohns",
            ---------SpriteAtlas----------
            SpriteAtlas_Icons = "Sprite/Atlas/Common",

            ----------Audio--------------
            Audio_Title_BGM="Audio/Audio_Title_BGM",

            Audio_Shoot_ES="Audio/Shoot",
            Audio_ReloadAmmo_Es="Audio/ReloadAmmo",

        }
    end

    ---自动切换名字
    if IS_RELEASE_MODE then
        self.NamePath={
            ---------------------------Prefabs-------------------------------------
            Bullet_1="bullet_1",
            Character_1="character",
            Enemy_1 = "enemy_1",
            PoisonArea="poisonarea",

            Trivial_Thing_Bullet_Box="bulletbox",
            Trivial_Thing_Gold="gold",
            -------Guns-----------------
            Gun_Normal_Rifle="normal_rifle",
            Gun_Normal_Sniper_Rifle="normal_sniper_rifle",
            Gun_Normal_Pistol="normal_pistol",

            Portal = "portal",



            Icon_LightBullet = "icon_lightbullet",

            ---------------Item-------------------
            Item_AmysBow ="amysbow",
            Item_Van ="van",
            Item_PangsSkateboardShoes ="pangsskateboardshoes",

            -------------Equipments----------------
            Equipments_NormalClothes = "normalclothes",
            Equipments_LightArmour = "lightarmour",
            Equipments_MiddleArmour = "middlearmour",
            Equipments_HeavyArmour = "heavyarmour",
            Equipments_CXKVest = "cxkvest",
            Equipments_PRClothes = "prclothes",
            Equipments_GrandmasVest = "grandmasvest",
            Equipments_MomsLongJohns = "momslongjohns",

            -----UI-----
            UI_MessageBox="ui_messagebox",
            UI_Setting="ui_setting",

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
            UI_IconItem = "ui_iconitem",
            UI_PassiveSkillInfo = "ui_passiveskillinfo",

            UI_CharacterStateInBattle = "ui_characterstate",
            UI_WeaponState = "ui_weaponstate",
            UI_BulletState = "ui_bulletstate",
            UI_ItemInfo = "ui_iteminfo",
            UI_WeaponInfo = "ui_weaponinfo",
            UI_EquipmentInfo = "ui_equipmentinfo",
            UI_ItemsContainer = "ui_itemscontainer",
            UI_GoldAndSoulShard = "ui_goldandsoulshard",
            UI_Equipments = "ui_equipments",

            UI_Loading = "ui_loading",
            --------Tiles----------
            Tile_Base = "floorbrickstograsscorner_0",
            Tile_Wall = "floorbrickstograsscorner_2",
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
            NPC_DrawSkin="skinseller",
            NPC_SellPassiveSkill="passiveskillseller",
            NPC_SellEquipment="equipmentseller",
            NPC_SellItem="itemseller",

            Camera_Main = "maincamera",
            -------------------------------Assets---------------------------------------
            -----------Animation---------
            Animation_Role_1_Skin_1="ruby",
            Animation_Role_1_Skin_2="mrclock",
            ----------Sprite-------------
            Sprite_Role_1_Skin_1="ruby",
            Sprite_Role_1_Skin_2="mrclock",
            Sprite_Cursor_1 = "cursor_1",
            Sprite_Equipment_LightArmour = "lightarmour",
            Sprite_Equipment_MiddleArmour = "middlearmour",
            Sprite_Equipment_HeavyArmour = "heavyarmour",
            Sprite_Equipment_CXKVest = "cxkvest",
            Sprite_Equipment_PRClothes = "prclothes",
            Sprite_Equipment_GrandmasVest = "grandmasvest",
            Sprite_Equipment_MomsLongJohns = "momslongjohns",
            ---------SpriteAtlas----------
            SpriteAtlas_Icons = "common",

            ----------Audio--------------
            Audio_Title_BGM="audio_title_bgm",

            Audio_Shoot_ES="shoot",
            Audio_ReloadAmmo_Es="reloadammo",
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