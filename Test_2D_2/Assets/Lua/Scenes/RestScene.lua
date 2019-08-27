
--[[
    负责Rest场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local SceneMgr = require("SceneManager")
local Battle = require("Battle")
local Camera =  require("CameraFollowing")
local MC = require("MessageCenter")


local RestScene = {}

function RestScene:InitScene()
    local character = require("Character"):new()
    Camera:BeginFollow(character.gameobject.transform)
    Battle:new(character)

    ---地图Init

    --- 初始化UI
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
    local CharacterStateDlg = require("CharacterStateDlg"):new(character)
    local SettingDlg = require("SettingDlg"):new()

    self:InitNPC()
    self:InitSpecialThing()
    character:Start()
end

---初始化NPC
function RestScene:InitNPC()
    local NPC_DrawSkin = require("NPC_DrawSkin")
    NPC_DrawSkin:Generate()

    local NPC_SellPassiveSkill = require("NPC_SellPassiveSkill")
    NPC_SellPassiveSkill:Generate()

    local NPC_SellEquipment = require("NPC_SellEquipment")
    NPC_SellEquipment:Generate()
end

function RestScene:OnPortalCollision(type, other)
    if type == Enum_CollisionType.TriggerEnter2D then
        --- 角色的layer
        if other.gameObject.layer ==  9 then
            SceneMgr:LoadScene(Enum_Scenes.Battle)
        end
    end
end

---初始化特殊物品
function RestScene:InitSpecialThing()
    -------------下一关的门------------
    local portal = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Portal, PathMgr.NamePath.Portal, nil, UE.Vector3(10, 0, -1))
    -------绑定碰撞------
    local collsion = portal:GetComponent(typeof(CS.Collision))
    if not collsion then
        collsion = portal:AddComponent(typeof(CS.Collision))
    end
    collsion.CollisionHandle = self.OnPortalCollision

    -----------毒区--------------
    require("PoisonArea"):Generate()
end

function RestScene:OverScene()
    Camera:EndFollow()
end

return RestScene