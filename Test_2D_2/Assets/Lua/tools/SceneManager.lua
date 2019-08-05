--[[
    场景及UI管理
--]]

MC = require("MessageCenter")

local SceneManager={}

SceneManagement=CS.UnityEngine.SceneManagement.SceneManager

function SceneManager:Init()
    --存储场景 由于存的是场景的Index, 所以会boxing和unboxing, 后面改
    self.sceneStack = CS.System.Collections.Stack()

    --存储UI
    self.UIStack = CS.System.Collections.Stack()

    ---存储地牢房间
    --self.roomStack = CS.System.Collections.Stack()

    ---当前所在房间
    self.currentRoom = 1
end

--加载场景
function SceneManager:LoadScene(sceneIndex)
    if  self.sceneStack then
        self.sceneStack:Push(sceneIndex)
        MC:SendMessage(MessageType.ChangeScene, nil)
        SceneManagement.LoadScene(sceneIndex)
    end
end

--返回上一场景
function SceneManager:BackScene()
    if  self.sceneStack and sceneStack.Count >= 2 then
        self.sceneStack:Pop()
        local scene = sceneStack:Peek()
        SceneManagement.LoadScene(scene)
    end
end

---高有几个，宽有几个，最少几个，最多几个，特殊房数组，入口到出口最短几步
function SceneManager:GenerateMap(height, width, minimumCount, maximumCount, spacialRooms, minimumLenghtFromEnterToExit)


end

--加载UI
function SceneManager:LoadUI(ui)
    if  self.UIStack then
        self.UIStack:Push(ui)
        --加载ui
    end
end

--返回上级UI
function SceneManager:BackUI()
    if  self.UIStack and UIStack.Count >= 1 then
        self.UIStack:Pop()
        local ui =  self.UIStack:Peek()
        --销毁 ui
    end
end

SceneManager:Init()

return SceneManager