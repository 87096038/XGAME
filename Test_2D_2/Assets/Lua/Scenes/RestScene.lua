
--[[
    负责Rest场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local SceneMgr = require("SceneManager")
local Battle = require("Battle")
local Camera =  require("CameraFollowing")
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
end

function RestScene:OnPortalCollision(type, other)
    if type == Enum_CollisionType.TriggerEnter2D then
        --- 角色的layer
        if other.gameObject.layer ==  9 then
            Camera:EndFollow()
            SceneMgr:LoadScene(Enum_Scenes.Battle)
        end
    end
end

---初始化特殊物品
function RestScene:InitSpecialThing()
    local isNew
    local portal, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Portal, PathMgr.NamePath.Portal, nil, UE.Vector3(10, 0, 0))
    -------绑定碰撞------
    local collsion = portal:AddComponent(typeof(CS.Collision))
    if isNew then
        if collsion.CollisionHandle then
            collsion.CollisionHandle = collsion.CollisionHandle + self.OnPortalCollision
        else
            collsion.CollisionHandle = self.OnPortalCollision
        end
    end
end



return RestScene