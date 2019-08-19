
--[[
    负责Rest场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local SceneMgr = require("SceneManager")
local Battle = require("Battle")

local RestScene = {}

function RestScene:InitScene()
    local character = require("Character"):new()
    require("CameraFollowing"):BeginFollow(character.gameobject.transform)
    ---地图Init
    self:InitUI()
    self:InitNPC()
    self:InitSpecialThing()
    Battle:new(character)
    character:Start()
end

function RestScene:InitUI()
    local SkinSelectDlg = require("SkinSelectDlg"):new()
    local Skin_btn = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Skin_btn, PathMgr.NamePath.UI_Skin_btn, Main.UIRoot.transform):GetComponent(typeof(UE.UI.Button))
    if Skin_btn then
        Skin_btn.onClick:AddListener(function ()
            if SkinSelectDlg.isActive then
                SkinSelectDlg:Hide()
            else
                SkinSelectDlg:Show()
            end
            end)
    end
    local currencyInfoDlg = require("CurrencyInfoDlg"):new()
end

function RestScene:InitNPC()
    local NPC_DrawSkin = require("NPC_DrawSkin")
    NPC_DrawSkin:Generate()
end

local function OnPortalCollision()
    SceneMgr:LoadScene(Enum_Scenes.Battle)
end

function RestScene:InitSpecialThing()
    local isNew
    local portal, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Portal, PathMgr.NamePath.Portal, nil, UE.Vector3(10, 0, 0))
    -------绑定碰撞------
    local collsion = portal:AddComponent(typeof(CS.Collision))
    if isNew then
        if collsion.CollisionHandle then
            collsion.CollisionHandle = collsion.CollisionHandle + OnPortalCollision
        else
            collsion.CollisionHandle = OnPortalCollision
        end
    end
end



return RestScene