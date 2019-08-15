--[[
    程序入口
--]]

--package.path = package.path .. ';../protobuf/?.lua.txt'
--package.cpath = package.cpath .. ';../protobuf/?.so'

UE = CS.UnityEngine

Main=UE.GameObject.Find("Main"):GetComponent("Main")

--[[
    因为Lua本身的协程是基于多线程，所以我以为这里也是，就写了这个函数调用Unity的协程
    谁料xlua的协程是在当前线程运行的？？？？
    要用可以直接coroutine.wrap或者coroutine.start
--]]
---开始协程
---func : 想装成协程的function
---... : 该func的参数(如果有self, 第一个参数为self)
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
    local proxy={}
    local mate={
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


IS_RELEASE_MODE = false
IS_ONLINE_MODE = true

---需要先初始化的module
require("Enum")
local MC = require("MessageCenter")
local PathMgr = require("PathManager")
---
--local net=require("NetManager")
local Timer = require("Timer")

--local Battle = require("Battle")
--local ResourceMgr = require("ResourceManager")
--local SceneMgr = require("SceneManager")
local Camera = require("CameraFollowing")
--local AudioMgr = require("AudioManager")
local BeginScene = require("BeginScene")
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

    --Timer:InvokeCoroutine(function () print("123") end, 2, 5)
    BeginScene:InitScene()
    --AudioMgr:PlayBackgroundMusic(ResourceMgr:Load(PathMgr.ResourcePath.Audio_Title_BGM, PathMgr.NamePath.Audio_Title_BGM), 5)
    --SceneMgr:GenerateBattleMap(1,3,1,1)

end

