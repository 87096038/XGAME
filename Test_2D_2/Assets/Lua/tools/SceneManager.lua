--[[
    场景及UI管理
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local RoomMgr = require("RoomManager")
local Room = require("Room")
local MC = require("MessageCenter")

local SceneManager={}

SceneManager.loadAsyncLevel = {}

local SceneMgr=UE.SceneManagement.SceneManager

function SceneManager:Init()
    --self.previousScene = nil     -- 前一个场景
    --[[
        当前场景（实质上使当前活动的场景，由于在本项目中应该不会出现多个场景同时出现的情况,
        所以默认GetActiveScene()返回的是当前正在运行的的场景）
    ]]--
    --self.currentScene = SceneMgr.GetActiveScene()

    self.previousSceneBuildIndex = nil
    self.currentSceneBuildIndex = SceneMgr.GetActiveScene().buildIndex

    self.gold = 0
    self.item = {}
    self.weapon = {}
    self.treasure = {}

    self.loadingUI = nil

end

--加载新场景
function SceneManager:LoadScene(sceneBuildIndex)
    if sceneBuildIndex < 0 or sceneBuildIndex >= SceneMgr.sceneCountInBuildSettings then
        print("Scene does not exist.")
        return
    end

    self.previousSceneBuildIndex = self.currentSceneBuildIndex
    self.currentSceneBuildIndex = sceneBuildIndex

    MC:SendMessage(Enum_MessageType.ChangeScene, nil)

    --SceneMgr.LoadScene(self.SceneBuildIndex.middleScene)

    for i = Main.UIRoot.transform.childCount-1,0,-1 do
        --print("destroy",Main.UIRoot.transform:GetChild(i).gameObject)
        ResourceMgr:DestroyObject(Main.UIRoot.transform:GetChild(i).gameObject,true)
    end

    SceneMgr.LoadScene(sceneBuildIndex)
    require(Enum_SceneName[sceneBuildIndex+1]):InitScene()
end

--返回上一场景，不过这在元气骑士内不存在所以其实用不到？
function SceneManager:LoadPreviousScene()
    if self.previousSceneBuildIndex == nil then
        SceneMgr.LoadScene(self.previousSceneBuildIndex)
    else
        print("The previous scene does not exist.")
    end
end

function SceneManager:StartGame()
    require("Title"):InitScene()
end

-- 生成战斗场景
function SceneManager:GenerateBattleMap(mapLevel,monsterRoomCnt,shopRoomCnt,treasureRoomCnt)
    RoomMgr:CreateRooms(mapLevel,monsterRoomCnt,shopRoomCnt,treasureRoomCnt)
end

-- 战斗结算
function SceneManager:BattleFinish()

end

--加载UI
function SceneManager:LoadUI(ui)
end

--返回上级UI
function SceneManager:BackUI()

end

SceneManager:Init()

return SceneManager