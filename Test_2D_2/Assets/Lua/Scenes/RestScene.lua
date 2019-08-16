
--[[
    负责Rest场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local SceneMgr = require("SceneManager")
local Battle = require("Battle")

local RestScene = {}

function RestScene:InitScene()
    print("switch to Rest Scene")
    local character = require("Character"):new()
    require("CameraFollowing"):BeginFollow(character.gameobject.transform)
    ---地图Init
    self:InitUI()
    ---NPCInit
    ---特殊物体Init
    Battle:new(character)
    character:Start()
end

function RestScene:InitUI()
    local Skin_btn = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Skin_btn, PathMgr.NamePath.UI_Skin_btn, Main.UIRoot.transform):GetComponent(typeof(UE.UI.Button))
    local SkinSelectDlg = require("SkinSelectDlg"):new()
    local CurrencyInfo = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_CurrencyInfo, PathMgr.NamePath.UI_CurrencyInfo, Main.UIRoot.transform)
    if Skin_btn then
        Skin_btn.onClick:AddListener(function ()
            if SkinSelectDlg.isActive then
                SkinSelectDlg:Hide()
            else
                SkinSelectDlg:Show()
            end
            end)
    end
end

return RestScene