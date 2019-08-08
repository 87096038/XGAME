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

---step: 0~1之间，每次变化的透明度多少，推荐0.02
---keepTime: 每张图的展示时间(s)
---imgsIntervalTime: 每张图的间隔时间
local function BeginImgFade(parentTransform, step, keepTime, imgsIntervalTime)
    print(parentTransform)
    if parentTransform then
        local stepTmp = step or 0.02
        local currentImg
        local color = UE.Color()
        local child
        local keep = UE.WaitForSeconds(keepTime or 2)
        local interval =  UE.WaitForSeconds(0.01)
        local imgsInterval = UE.WaitForSeconds(imgsIntervalTime or 0.5)

        for i=0, parentTransform.childCount-1, 1 do
            stepTmp = step or 2
            child =  parentTransform:GetChild(i).gameObject
            child:SetActive(true)
            currentImg = child:GetComponent(typeof(UE.UI.Image))
            color = currentImg.color
            color.a = 0.005

            while color.a>0 do
                color.a = color.a + stepTmp
                currentImg.color = color
                print(currentImg.color.a.." : "..color.a)
                coroutine.yield(interval)
                if (color.a >= 1) then
                    coroutine.yield(keep)
                    stepTmp = -stepTmp;
                end
            end
            child:SetActive(false);
            coroutine.yield(imgsInterval)
        end
    end
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
local AudioMgr = require("AudioManager")
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

    --ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_HotUpdate, PathMgr.NamePath.UI_HotUpdate, Main.UIRoot.transform)
    --local beginImgs = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Begin_Imgs, PathMgr.NamePath.UI_Begin_Imgs, Main.UIRoot.transform)

    --Timer:InvokeCoroutine(function () print("123") end, 2, 5)
    --IS_ONLINE_MODE = true
    --net:Start()
    --local login = {userName="1", password="5", response=false}
    --net:TCPSendMessage(1, login)

    --StartCoroutine(BeginImgFade, beginImgs.transform)

    --AudioMgr:PlayBackgroundMusic(ResourceMgr:Load(PathMgr.ResourcePath.Audio_Title_BGM, PathMgr.NamePath.Audio_Title_BGM), 5)

    --CS.System.IO.Directory.CreateDirectory([[Users/xiejiahong/Library/Application Support/DefaultCompany/Test_2D_2/resources/123]])
    --net:StartUpdate(function ()
        --local character = require("Character"):new()
        --Camera:BeginFollow(character.gameobject:GetComponent("Transform"))
        --Battle:new(character, require("Normal_pistol"):new())
    --end)
end

