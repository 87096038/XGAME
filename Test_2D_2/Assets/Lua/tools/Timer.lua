--[[local util = require 'xlua.util'
local co
local t_fun = util.cs_generator(function()
    print("StartCoroutine ")
    for i = 1, 10 do
        coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
        print('Wait for 1 seconds')

        if i == 3 then
            print("StopCoroutine")
            print(co)
            self:StopCoroutine(co)
        end
    end
end)
print(t_fun)
co = CS.XLua.Cast.IEnumerator(t_fun)
self:StartCoroutine(co)
--]]
local Timer={}

function Timer:Init()

    self.deltaTime=0
    self.UpdateFucs={}

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
function Timer:AddUpdateFuc(table, fuc)
    if type(fuc) ~= "function" or type(table) ~= "table"then
        return
    end

    for t, v in pairs(self.UpdateFucs) do
        if t == table and v == fuc then
            return
        end
    end
    self.UpdateFucs[table]  = fuc
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

Timer:Init()
return Timer