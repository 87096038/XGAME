--[[
    场景及UI管理
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local RoomMgr = require("RoomManager")
local MC = require("MessageCenter")
local Timer = require("Timer")

local SceneManager={}

SceneManager.loadAsyncLevel = {}

local SceneMgr=UE.SceneManagement.SceneManager

function SceneManager:Init()
    --[[
        当前场景（实质上使当前活动的场景，由于在本项目中应该不会出现多个场景同时出现的情况,
        所以默认GetActiveScene()返回的是当前正在运行的的场景）
    ]]--
    -- 场景BuildIndex记录
    self.previousSceneBuildIndex = nil
    self.currentSceneBuildIndex = SceneMgr.GetActiveScene().buildIndex

    -- 场景跳转UI组件
    self.UI_Loading = nil
    self.Slider = nil
    self.Text_Loading = nil

    -- 消息框UI组件
    self.UI_MessageBox = nil
    self.Text_Message = nil
    self.Button_Yes = nil
    self.Button_No = nil

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

    for i = Main.UIRoot.transform.childCount-1,0,-1 do
        print("destroy",Main.UIRoot.transform:GetChild(i).gameObject)
        ResourceMgr:DestroyObject(Main.UIRoot.transform:GetChild(i).gameObject,true)
    end

     --异步加载
    local util = require 'xlua.util'
    local LoadSceneAsync_Fun = util.cs_generator(function()
        self.UI_Loading = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Loading, PathMgr.NamePath.UI_Loading, Main.UIRoot.transform)
        self.Slider = self.UI_Loading.transform:Find("Slider"):GetComponent(typeof(UE.UI.Slider))
        self.Text_Loading = self.UI_Loading.transform:Find("Text_Loading"):GetComponent(typeof(UE.UI.Text))
        self.Text_Loading.text = "Loading: 0%"

        -- 预加载场景资源,90%的进度条用于显示资源加载，剩余10%为场景加载
        -- 待写

        local async = SceneMgr.LoadSceneAsync(sceneBuildIndex)
        while not async.isDone do
            print(async.progress)
            if async.progress <= 0.85 then
                self.Slider.value = async.progress
            else
                self.Slider.value = 1
            end
            self.Text_Loading.text = "Loading: ".. math.ceil(self.Slider.value * 100) .."%"

            coroutine.yield(UE.WaitForEndOfFrame)
        end
        -- 执行初始Scenes脚本的初始化，删除loading UI
        require(Enum_SceneName[sceneBuildIndex+1]):InitScene()

        -- 由于加载过快再这里加了个等待0.7s，以后根据具体情况可修改
        coroutine.yield(UE.WaitForSeconds(0.7))
        ResourceMgr:DestroyObject(self.UI_Loading,true)
    end)

    local LoadSceneAsync = CS.XLua.Cast.IEnumerator(LoadSceneAsync_Fun)
    Main:StartCoroutine(LoadSceneAsync)

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

-- 获取消息框
function SceneManager:GetMessageBox(message,callback)
    self.UI_MessageBox = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_MessageBox, PathMgr.NamePath.UI_MessageBox, Main.UIRoot.transform)
    self.Button_Yes = self.UI_MessageBox.transform:Find("Button_Yes"):GetComponent(typeof(UE.UI.Button))
    self.Button_No = self.UI_MessageBox.transform:Find("Button_No"):GetComponent(typeof(UE.UI.Button))
    self.Text_Message = self.UI_MessageBox.transform:Find("Text_Message"):GetComponent(typeof(UE.UI.Text))
    self.Text_Message.text = message

    self.Button_Yes.onClick:AddListener(function ()
        callback()
        ResourceMgr:DestroyObject(self.UI_MessageBox)
    end)

    self.Button_No.onClick:AddListener(function()
        ResourceMgr:DestroyObject(self.UI_MessageBox)
    end)
end

SceneManager:Init()

return SceneManager