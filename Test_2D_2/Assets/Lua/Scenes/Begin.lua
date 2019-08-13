
--[[
    负责Begin场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local Timer = require("Timer")
local Net=require("NetManager")

local Begin = {}

function Begin:InitScene()

    self.hotUpdatePnl = ResourceMgr:Load(PathMgr.ResourcePath.UI_HotUpdate, PathMgr.NamePath.UI_HotUpdate)
    local beginImgs = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Begin_Imgs, PathMgr.NamePath.UI_Begin_Imgs, Main.UIRoot.transform)
    StartCoroutine(self.BeginImgFade, self, beginImgs.transform, nil, nil, nil, handler(self, self.HotUpdateStart) )
end

function Begin:HotUpdateStart()
    self.hotUpdatePnl = ResourceMgr:Instantiate(self.hotUpdatePnl, Main.UIRoot.transform)
    self.hotUpdateStateText = self.hotUpdatePnl.transform:Find("State"):GetComponentInChildren(typeof(UE.UI.Text))
    self.hotUpdateStateText.text = "正在拉取更新..."

    Net:StartUpdate(function (increaseCount, totalCount)
        if totalCount then
            local Process = self.hotUpdatePnl.transform:Find("Process")
            Process.gameObject:SetActive(true)
            self.hotUpdateProcessSlider = Process:GetComponent(typeof(UE.UI.Slider))
            self.hotUpdateProcessSlider.maxValue = totalCount
            self.hotUpdateStateText.text = "更新中...(0/"..totalCount..")"
        end
        if increaseCount then
            self.hotUpdateProcessSlider.value = self.hotUpdateProcessSlider.value + increaseCount
            self.hotUpdateStateText.text = "更新中...("..self.hotUpdateProcessSlider.value.."/"..totalCount..")"
        end
    end ,function (isSuccess)
        if isSuccess then
            self.hotUpdateStateText.text = "点击进入游戏"
            Timer:AddUpdateFuc(self, self.WaitForClickUpdate)
        else
            self.hotUpdateStateText.text = "更新失败，请重新打开游戏"
        end
    end)
end

function Begin:WaitForClickUpdate()
    if UE.Input.GetMouseButtonUp(0) then
        require("Title"):InitScene()
    end
end

---step: 0~1之间，每次变化的透明度多少，推荐0.02
---keepTime: 每张图的展示时间(s)
---imgsIntervalTime: 每张图的间隔时间
function Begin:BeginImgFade(parentTransform, step, keepTime, imgsIntervalTime, completeAction)
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
            stepTmp = step or 0.02
            child =  parentTransform:GetChild(i).gameObject
            child:SetActive(true)
            currentImg = child:GetComponent(typeof(UE.UI.Image))
            color = currentImg.color
            color.a = 0.005
            while color.a>0 do
                color.a = color.a + stepTmp
                currentImg.color = color
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
    if completeAction then
        completeAction()
    end
end

return Begin