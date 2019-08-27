
--[[
    战斗时的货币Dlg
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local GoldAndSoulShardDlg = Class("GoldAndSoulShardDlg", require("Base"))

function GoldAndSoulShardDlg:cotr(goldValue, soulShardValue)
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_GoldAndSoulShard, PathMgr.NamePath.UI_GoldAndSoulShard, Main.UIRoot.transform)
    self.goldText = self.gameobject.transform:Find("Gold"):Find("Count"):GetComponent(typeof(UE.UI.Text))
    self.soulShardText = self.gameobject.transform:Find("SoulShard"):Find("Count"):GetComponent(typeof(UE.UI.Text))

    self.goldText.text = tostring(goldValue) or 0
    self.soulShardText.text = tostring(soulShardValue) or 0
end

function GoldAndSoulShardDlg:ChangeGold(value)
    self.goldText.text = value
end

function GoldAndSoulShardDlg:ChangeSoulShard(value)
    self.soulShardText.text = value
end

return GoldAndSoulShardDlg