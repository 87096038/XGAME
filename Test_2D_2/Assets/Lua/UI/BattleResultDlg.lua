
--[[
    testing function
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local BattleResultDlg = Class("BattleResultDlg", require("Base"))

function  BattleResultDlg:cotr(soulShardCount)
    self.super:cotr()

    self.gameobject =ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_ResultPnl, PathMgr.NamePath.UI_ResultPnl, Main.UIRoot.transform)

    self.soulShardText = self.gameobject.transform:Find("SoulShard"):Find("Count"):GetComponent(typeof(UE.UI.Text))
    self.soulShardText.text = soulShardCount or "0"
    self.exitBtn = self.gameobject.transform:Find("Exit_Btn"):GetComponent(typeof(UE.UI.Button))
    self.exitBtn.onClick:RemoveAllListeners()

end

function BattleResultDlg:SetExitBtnFuc(func)
    self.exitBtn.onClick:AddListener(func)
end

return BattleResultDlg