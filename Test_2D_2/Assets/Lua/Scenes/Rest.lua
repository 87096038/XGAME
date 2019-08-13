
--[[
    负责Title场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local SceneMgr = require("SceneManager")

local Rest = {}

function Rest:InitScene()
    self.LoadResourcesCount = 0
    self.AllFilesCount = 24

    print("switch to Rest Scene")
    self.girdRoot = ResourceMgr:GetGameObject(PathMgr.ResourcePath.GridRoot,PathMgr.NamePath.GridRoot)
    self.RestScene = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Room_Rest,PathMgr.NamePath.Room_Rest,self.girdRoot.transform)
    ResourceMgr:LoadResourceAsync("path", self.OnLoadComplate)
    ResourceMgr:LoadResourceAsync("2", self.OnLoadComplate)
    ResourceMgr:LoadResourceAsync("3", self.OnLoadComplate)
    ResourceMgr:LoadResourceAsync("4", self.OnLoadComplate)


end

function Rest.OnLoadComplate()
    self.LoadResourcesCount = self.LoadResourcesCount +1
    if self.LoadResourcesCount == self.AllFilesCount then

    end
end

return Rest