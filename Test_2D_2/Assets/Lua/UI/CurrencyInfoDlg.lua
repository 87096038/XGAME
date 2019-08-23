
--[[
    货币(钻石和灵魂碎片)Dlg管理
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local UserInfoData = require("UserInfoData")

local CurrencyInfoDlg = Class("CurrencyInfoDlg", require("Base"))

function CurrencyInfoDlg:cotr()
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_CurrencyInfo, PathMgr.NamePath.UI_CurrencyInfo, Main.UIRoot.transform)

    self.diamondCount = UserInfoData.diamondCount
    self.soulShardCount = UserInfoData.soulShardCount
    self.diamondCountText = self.gameobject.transform:Find("Diamond"):Find("Data"):GetComponent(typeof(UE.UI.Text))
    self.soulShardText = self.gameobject.transform:Find("SoulShard"):Find("Data"):GetComponent(typeof(UE.UI.Text))

    self.diamondCountText.text =  self.diamondCount
    self.soulShardText.text =  self.soulShardCount
    -----------添加监听-----------
    self:AddMessageListener(Enum_NormalMessageType.RefreshCurrency, handler(self, self.OnRefreshCurrency))
end

function CurrencyInfoDlg:ChangeDiamond(value)
    self.diamondCount = self.diamondCount + value
    StartCoroutine(function ()
        local currentCount = self.diamondCount - value
        local count = 30
        local step = math.floor(value/count)
        local wait = UE.WaitForSeconds(1/step)
        for i=1, count do
            currentCount = currentCount + step
            self.diamondCountText.text = math.ceil(currentCount)
            coroutine.yield(wait)
        end
        self.diamondCountText.text = self.diamondCount
    end)
end

function CurrencyInfoDlg:ChangeSoulShard(value)
    self.soulShardCount = self.soulShardCount + value
    --StartCoroutine(function ()
    --    local currentCount = self.soulShardCount - value
    --    local count = 30
    --    local step = math.floor(value/count)
    --    local wait = UE.WaitForSeconds(1/step)
    --    for i=1, count do
    --        currentCount = currentCount + step
    --        self.soulShardText.text = math.ceil(currentCount)
    --        coroutine.yield(wait)
    --    end
        self.soulShardText.text = self.soulShardCount
    --end)

end

---消息回调
function CurrencyInfoDlg:OnRefreshCurrency(kv)
    if UserInfoData.diamondCount ~= self.diamondCount then
        self:ChangeDiamond((UserInfoData.diamondCount or 0) - self.diamondCount)
    end
    if UserInfoData.soulShardCount ~= self.soulShardCount then
        self:ChangeSoulShard((UserInfoData.soulShardCount or 0) - self.soulShardCount)
    end
end

return CurrencyInfoDlg