
local MC = require("MessageCenter")
local Timer={}

function Timer:Init()

    self.deltaTime=0
    self.UpdateFucs={}

    MC:AddListener(Enum_NormalMessageType.ChangeScene, handler(self, self.ChangeSceneHandler))
end

function Timer:Update()
    self.deltaTime = CS.UnityEngine.Time.deltaTime

    for t, v in pairs(self.UpdateFucs) do
        if v then
            v(t)
        end
    end
end

--- 一个table只准有一个update
function Timer:AddUpdateFuc(table, func)
    if type(func) ~= "function" or type(table) ~= "table"then
        return
    end

    for t, v in pairs(self.UpdateFucs) do
        if t == table and v == func then
            return
        end
    end
    self.UpdateFucs[table]  = func
end

function Timer:RemoveUpdateFuc(fuc)
    if type(fuc) ~= "function" then
        return
    end
    for k, v in pairs(self.UpdateFucs) do
        if v == fuc then
            self.UpdateFucs[k] = nil
            return
        end
    end
end

function Timer:RemoveAll()
    self.UpdateFucs = {}
end

function Timer:InvokeCoroutine(func, time, repeatCount)
    StartCoroutine(function()
        if time then
            local tick = UE.WaitForSeconds(time)
            repeatCount = repeatCount or 1
            for count=1, repeatCount, 1 do
                coroutine.yield(tick)
                func()
            end
        else
            func()
        end
    end)
end

----------消息回调---------
function Timer:ChangeSceneHandler()
    --self:RemoveAll()
end

Timer:Init()
return Timer