
--[[
    负责Title场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local SceneMgr = require("SceneManager")

local Title = {}

function Title:InitScene()
    self.BuildIndex = SceneMgr.SceneBuildIndex.titleScene
    self.UI_Title = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Title, PathMgr.NamePath.UI_Title,Main.UIRoot.transform)
    self.Button_Start = self.UI_Title.transform:Find("Start")
    self.Button_Setting = self.UI_Title.transform:Find("Setting")
    self.Button_Exit = self.UI_Title.transform:Find("Exit")

    self.Button_Start:GetComponent(typeof(UE.UI.Button)).onClick:AddListener(self.StartOnClick)
    self.Button_Setting:GetComponent(typeof(UE.UI.Button)).onClick:AddListener(self.SettingOnClick)
    self.Button_Exit:GetComponent(typeof(UE.UI.Button)).onClick:AddListener(self.ExitOnClick)

end

function Title:StartOnClick()
    --ResourceMgr:DestroyObject(self.UI_Title, true)
    SceneMgr:LoadScene(SceneMgr.SceneBuildIndex.titleScene)
end

function Title:SettingOnClick()
    -- 功能待开发中
    print("Setting On Click")
end

function Title:ExitOnClick()
    -- 要打包后才能生效？
    UE.Application.Quit()
end

--function Title:test()
--    print("hello")
--end

return Title