
--[[
    负责Begin场景的初始化
--]]
local PathMgr = require("PathManager")
local ResourceMgr = require("ResourceManager")
local Timer = require("Timer")
local SceneMgr = require("SceneManager")
local MC = require("MessageCenter")
local NetHelper = require("NetHelper")

local BeginScene = {}

function BeginScene:InitScene()

    ---设置光标样式
    local tex = ResourceMgr:Load(PathMgr.ResourcePath.Sprite_Cursor_1, PathMgr.NamePath.Sprite_Cursor_1)
    if tex then
        UE.Cursor.SetCursor(tex, UE.Vector2(tex.height/2, tex.width/2), UE.CursorMode.Auto)
    end
    ---加载数据模块
    self:LoadDatas()
    require("CharacterState"):new()
    ---添加登陆监听
    MC:AddListener(Enum_NormalMessageType.Login, handler(self, self.OnLogin))

    self.hotUpdatePnl = ResourceMgr:Load(PathMgr.ResourcePath.UI_HotUpdate, PathMgr.NamePath.UI_HotUpdate)
    if IS_ONLINE_MODE then
        --local beginImgs = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Begin_Imgs, PathMgr.NamePath.UI_Begin_Imgs, Main.UIRoot.transform)
        --StartCoroutine(self.BeginImgFade, self, beginImgs.transform, nil, nil, nil, handler(self, self.HotUpdateStart) )
        self:HotUpdateStart()
        --NetHelper:SetMD5(false)
        --NetHelper:TCPConnect()
        --Timer:AddUpdateFuc(self, self.WaitForClickUpdate)
    else
        self.hotUpdatePnl = ResourceMgr:Instantiate(self.hotUpdatePnl, Main.UIRoot.transform)
        self.hotUpdateStateText = self.hotUpdatePnl.transform:Find("State"):GetComponentInChildren(typeof(UE.UI.Text))
        self.hotUpdateStateText.text = "点击进入游戏"
        Timer:AddUpdateFuc(self, self.WaitForClickUpdate)
    end
end

function BeginScene:HotUpdateStart()
    NetHelper:SetMD5(false)
    self.hotUpdatePnl = ResourceMgr:Instantiate(self.hotUpdatePnl, Main.UIRoot.transform)
    self.hotUpdateStateText = self.hotUpdatePnl.transform:Find("State"):GetComponentInChildren(typeof(UE.UI.Text))
    self.hotUpdateStateText.text = "正在连接服务器"
    if not NetHelper:TCPConnect() then
        self.hotUpdateStateText.text = "连接服务器失败，请重新打开游戏"
        return
    end

    self.hotUpdateStateText.text = "正在拉取更新..."

    NetHelper:StartHotUpdate(function (increaseCount, totalCount)
        if totalCount then
            local Process = self.hotUpdatePnl.transform:Find("Process")
            Process.gameObject:SetActive(true)
            self.hotUpdateProcessSlider = Process:GetComponent(typeof(UE.UI.Slider))
            self.hotUpdateProcessSlider.maxValue = totalCount
            self.hotUpdateStateText.text = "更新中, 已完成(0/"..totalCount..")"
        end
        if increaseCount then
            self.hotUpdateProcessSlider.value = self.hotUpdateProcessSlider.value + increaseCount
            self.hotUpdateStateText.text = "更新中, 已完成("..math.ceil(self.hotUpdateProcessSlider.value).."/"..self.hotUpdateProcessSlider.maxValue..")"
        end
    end ,function (isSuccess)
        if isSuccess then
            self.hotUpdateStateText.text = "加载中...."
            self:ReLoadModule()
            self:Login()
        else
            self.hotUpdateStateText.text = "更新失败，请重新打开游戏"
        end
    end)
end

--- 热更后刷新模块
function BeginScene:ReLoadModule()

    --for k, v in pairs(package.loaded) do
    --    if v then
    --        package.loaded[k] = nil
    --        require(k)
    --    end
    --end
    --package.loaded["Enum"] = nil
    --require("Enum")
    --package.loaded["MessageCenter"] = nil
    --require("MessageCenter")
    --package.loaded["PathManager"] = nil
    --require("PathManager")
    --package.loaded["NetManager"] = nil
    --require("NetManager")
    --package.loaded["Timer"] = nil
    --require("Timer")
    --package.loaded["UserInfoData"] = nil
    --require("UserInfoData")
    --package.loaded["SkinData"] = nil
    --require("SkinData")
    --package.loaded["RoleData"] = nil
    --require("RoleData")
    --package.loaded["BattleData"] = nil
    --require("BattleData")
    --package.loaded["BulletData"] = nil
    --require("BulletData")
    --package.loaded["CameraFollowing"] = nil
    --require("CameraFollowing")

    ---加载数据模块
    --self:LoadDatas()
end

function BeginScene:Login()
    self.hotUpdateStateText.text = "登陆中...."
    if not self.login then
        self.login = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_LoginPnl, PathMgr.NamePath.UI_LoginPnl, Main.UIRoot.transform)
    else
        self.login:SetActive(true)
    end
    local loginBtn = self.login:GetComponentInChildren(typeof(UE.UI.Button))
    local userName = self.login.transform:Find("UserName"):GetComponentInChildren(typeof(UE.UI.InputField))
    local password = self.login.transform:Find("Password"):GetComponentInChildren(typeof(UE.UI.InputField))
    userName.text = ""
    password.text = ""
    loginBtn.onClick:AddListener(function ()
        if userName.text == "" then
            SceneMgr:GetMessageBox("请输入用户名")
            return
        end
        if password.text == "" then
            SceneMgr:GetMessageBox("请输入密码")
            return
        end
        self.login:SetActive(false)
        NetHelper:SendLogin(userName.text, userName.text)
    end);
end

function BeginScene:WaitForClickUpdate()
    if UE.Input.GetMouseButtonUp(0) then
        Timer:RemoveUpdateFuc(self, self.WaitForClickUpdate)
        require("SceneManager"):LoadScene(Enum_Scenes.Title)
    end
end

--- 加载数据模块
function BeginScene:LoadDatas()
    require("UserInfoData")
    require("WeaponData")
    require("RoleData")
    require("SkinData")
    require("PassiveSkillData")
    require("BattleData")
    require("BulletData")
    require("ItemData")
    require("EquipmentData")
end

---------消息响应函数---------
function BeginScene:OnLogin(kv)
    if kv.Value then
        if kv.Value.response then
            self.hotUpdateStateText.text = "点击进入游戏"
            MC:RemoveListener(Enum_NormalMessageType.Login, handler(self, self.OnLogin))
            Timer:AddUpdateFuc(self, self.WaitForClickUpdate)
        else
            SceneMgr:GetMessageBox("用户名或密码错误，请重新登陆。")
            self:Login()
        end
    end
end

function BeginScene:OverScene()

end

---step: 0~1之间，每次变化的透明度多少，推荐0.02
---keepTime: 每张图的展示时间(s)
---imgsIntervalTime: 每张图的间隔时间
function BeginScene:BeginImgFade(parentTransform, step, keepTime, imgsIntervalTime, completeAction)
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

return BeginScene