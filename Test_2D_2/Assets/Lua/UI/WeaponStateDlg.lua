
--[[
    武器状态的Dlg
--]]

local BulletData = require("BulletData")

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local WeaponStateDlg = Class("WeaponStateDlg", require("Base"))

function WeaponStateDlg:cotr()
    self.super:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_WeaponState, PathMgr.NamePath.UI_WeaponState, Main.UIRoot.transform)
    self.currentWeaponImg =  self.gameobject.transform:Find("CurrentWeapon"):GetComponent(typeof(UE.UI.Image))
    self.nextWeaponImg =  self.gameobject.transform:Find("NextWeapon"):GetComponent(typeof(UE.UI.Image))
    self.bulletsContainer = self.gameobject.transform:Find("Bullet"):GetComponentInChildren(typeof(UE.UI.GridLayoutGroup)).transform
    self.CDImg = self.currentWeaponImg.transform:Find("CDImage"):GetComponent(typeof(UE.UI.Image))

    ---------------添加监听---------------
    self:AddMessageListener(Enum_NormalMessageType.ReloadBegin, handler(self, self.OnReloadBegin))
    self:AddMessageListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))
end

function WeaponStateDlg:ChangeToNext(newNextSprite)
    if self.nextWeaponImg.sprite then
        self.currentWeaponImg.sprite = self.nextWeaponImg.sprite
    end
    if newNextSprite then
        self.nextWeaponImg.sprite = newNextSprite
    else
        self.nextWeaponImg.sprite = nil
    end
end

function WeaponStateDlg:ChangeCurrent(newNextSprite)
    if newNextSprite then
        self.currentWeaponImg.sprite = newNextSprite
    end
end

function WeaponStateDlg:ChangeNext(newNextSprite)
    if newNextSprite then
        self.nextWeaponImg.sprite = newNextSprite
    end
end

--- 一般用于切换枪和换子弹的时候
function WeaponStateDlg:ReSetBullet(bulletType, count)
    for i=1, self.bulletsContainer.childCount do
        ResourceMgr:DestroyObject(self.bulletsContainer:GetChild(0).gameObject)
    end
    for i=1, count do
        ResourceMgr:GetGameObject(BulletData.Bullets[bulletType].IconResourcePath, BulletData.Bullets[bulletType].IconResourceName, self.bulletsContainer)
    end
end

--- 减bullet
function WeaponStateDlg:ReduceBullet(reduceValue)
    local value = reduceValue
    if self.bulletsContainer.childCount < value then
        value = self.bulletsContainer.childCount
    end
    for i=1, value do
        ResourceMgr:DestroyObject(self.bulletsContainer:GetChild(0).gameObject)
    end
end

--- 主武器开始CD
function WeaponStateDlg:BeginCD(time)
    StartCoroutine(function ()
        self.CDImg.fillAmount = 1
        local loopCount = 20
        local step = 1/loopCount
        local wait = UE.WaitForSeconds(time/loopCount)
        for i=1, loopCount do
            self.CDImg.fillAmount = self.CDImg.fillAmount - step
            coroutine.yield(wait)
        end
    end)
end


----------------消息回调----------------
function WeaponStateDlg:OnReloadBegin(kv)
    if kv.Value.owner == require("BattleData").currentBattle.character then
        self:BeginCD(kv.Key)
    end
end

function WeaponStateDlg:OnChangeScene(kv)
    self:Destroy()
end

return WeaponStateDlg