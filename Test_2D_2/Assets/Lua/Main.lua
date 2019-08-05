--[[
    程序入口
--]]

--package.path = package.path .. ';../protobuf/?.lua.txt'
--package.cpath = package.cpath .. ';../protobuf/?.so'

UE = CS.UnityEngine

Main=UE.GameObject.Find("Main"):GetComponent("Main")

---开始协程
---func : 想装成协程的function
---... : 该func的参数(第一个为所属table)
function StartCoroutine(func, ...)
    local util = require 'xlua.util'
    local func = util.cs_generator(func, ...)
    return Main:StartCoroutine(func)
end
---关闭协程
function StopCoroutine(coroutine)
    Main:StopCoroutine(coroutine)
end

---拓展string
function string:split(sep)
    local sep, fields = sep or "\t", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function string:findLast(sep)
    local sr = string.reverse(self)
    local _, i = string.find(sr, sep)
    if i then
        return string.len(self) - i + 1
    else
        return nil
    end

end

function GetProxy(sourceTable, path)
    proxy={}
    mate={
        __newindex=function(t, key, newValue)
            local oldValue=sourceTable[key]
            if not oldValue then
                --send Add
            elseif not newValue then
                --send Remove
            else
                --send Change
            end
            sourceTable[key]=newValue
        end,

        __len=function()
            return #sourceTable
        end
    }

    setmetatable(proxy, mate)
    return proxy
end

---class封装
---实例化时会自动先后调用(如果有)父类和自己的cotr函数
function Class(className, super)

    local TheClass = {name = className, super = super}

    if super then
        local type = type(super)
        if type ~= "table" and type ~= "function" then
            print("wrong super type!")
            return nil;
        else
            setmetatable(TheClass, {__index = super})
        end
    end

    function TheClass:new(...)

        --使用以下代码能够实现内存意义上的实例化，但浪费空间
        --local instance = {}
        --for k, v in pairs(TheClass) do
        --    instance[k] = v
        --end

        --使用以下代码能够实现表面上的实例化，不浪费空间，但是在传self时要注意
        local instance = setmetatable( {}, {__index=TheClass})

        if instance["cotr"] then
            instance.cotr(instance, ...)
        end
        return instance
    end

    return TheClass
end


---需要先运行的module
require("Enum")
---
local net=require("NetManager")
local Timer = require("Timer")

local Battle = require("Battle")
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local SceneMgr = require("SceneManager")
local MC = require("MessageCenter")
local Camera = require("CameraFollowing")
-------------------------------
--初始化
function Init()
    InitTitle()
end

--主循环
function MainLoop()
    Timer:Update()
    --print("from loop"..asset)
end

--退出游戏处理
function Quit()
    print("Quit")
end
------------------------------
function InitTitle()

    --local title = ResourceMgr:GetGameObject("Prefabs/UI_Title", nil, Main.UIRoot.transform)
    --net:CheckUpdate()
    --SceneMgr:LoadScene(1)
    --local go = UE.GameObject()

    --CS.System.IO.Directory.CreateDirectory([[Users/xiejiahong/Library/Application Support/DefaultCompany/Test_2D_2/resources/123]])
    --net:StartUpdate(function ()
        local character = require("Character"):new()
        Camera:BeginFollow(character.gameobject:GetComponent("Transform"))
        Battle:new(character, require("Normal_pistol"):new())
    --end)

    --local go = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Bullet_1, PathMgr.NamePath.Bullet_1)
    --go.transform.rotation =  UE.Quaternion.Euler(20, 20, 20)
    --local go1 = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Bullet_1, PathMgr.NamePath.Bullet_1)
    --go1.transform.rotation =  go.transform.rotation

    --net:Connect("127.0.0.1", 10000)
    --net:SendMessage("hello")
    --local go = ResourceMgr:GetGameObject("assetbundle/prefabs/ui/title/bg.ab", "bg", Main.UIRoot.transform)
    --ResourceMgr:DestroyObject(go)
    --

    --local newGo =  ResourceMgr:GetGameObject("assetbundle/prefabs/ui/title/bg.ab", "bg")
    --IS_RELEASE_MODE = true
    --StartCoroutine(ResourceMgr.GetGameObjectAsync, ResourceMgr, PathMgr.ResourcePath.Character_1, PathMgr.NamePath.Character_1)
    --ResourceMgr:GetGameObject("assetbundle/prefabs/ui/title/bg.ab", "bg",  Main.UIRoot.transform)
    --ResourceMgr:Instantiate(go)
    --go=CS.Main.LoadPrefabs("Prefabs/UI/Title/BG",Main.UIRoot.transform)
    --ResourceMgr:Instantiate(go, Main.UIRoot.transform)
    --print(PathMgr:GetName(Engine.Application.streamingAssetsPath.."/assetbundle/prefabs/ui/title/bg.ab"))

    --local role = require("Character"):new()
    --role:Move()

    --local kv = require("KeyValue"):new("hello")
    --print(kv.Key)
    --local kv2 = require("KeyValue"):new("world")
    --print(kv2.Key)


    --MC:AddListener("hello", HandleHello)
    --kv = require("KeyValue"):new("nice to meet you")
    --MC:SendMessage("hello", kv)
    --MC:RemoveMessageType("hello")
    --MC:SendMessage("hello", kv)
end
