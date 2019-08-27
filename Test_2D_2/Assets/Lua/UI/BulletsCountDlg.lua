
--[[
    显示子弹总数的Dlg
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local BulletsCountDlg = Class("BulletsCountDlg", require("Base"))

function BulletsCountDlg:cotr(lightCount, heavyCount, energyCount, shellCount)
    self.super:cotr()
    self.numberToStringCache = {}
    --for i = 1, 999 do
    --    table.insert(self.numberToStringCache, tostring(i))
    --end

    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_BulletState, PathMgr.NamePath.UI_BulletState, Main.UIRoot.transform)
    --- 获取物体
    self.bulletTexts = {}
    self.bulletTexts[Enum_BulletType.light] = self.gameobject.transform:Find("Light"):Find("Count"):GetComponent(typeof(UE.UI.Text))
    self.bulletTexts[Enum_BulletType.heavy] = self.gameobject.transform:Find("Heavy"):Find("Count"):GetComponent(typeof(UE.UI.Text))
    self.bulletTexts[Enum_BulletType.energy] = self.gameobject.transform:Find("Energy"):Find("Count"):GetComponent(typeof(UE.UI.Text))
    self.bulletTexts[Enum_BulletType.shell] = self.gameobject.transform:Find("Shell"):Find("Count"):GetComponent(typeof(UE.UI.Text))
    --- 初始化
    self:BulletCountChangeTo(Enum_BulletType.light, lightCount or 0)
    self:BulletCountChangeTo(Enum_BulletType.heavy, heavyCount or 0)
    self:BulletCountChangeTo(Enum_BulletType.energy, energyCount or 0)
    self:BulletCountChangeTo(Enum_BulletType.shell, shellCount or 0)

end

function BulletsCountDlg:BulletCountChangeTo(bulletType, value)
    --if value == 0 then
    --    self.bulletTexts[bulletType].text = 0
    --else
        self.bulletTexts[bulletType].text = value--self.numberToStringCache[value]
    --end
end

return BulletsCountDlg