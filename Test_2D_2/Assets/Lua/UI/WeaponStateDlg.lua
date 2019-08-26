
--[[
    武器状态的Dlg
--]]

local BulletData = require("BulletData")

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local WeaponStateDlg = Class("WeaponStateDlg", require("Base"))

function WeaponStateDlg:cotr()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_WeaponState, PathMgr.NamePath.UI_WeaponState, Main.UIRoot.transform)
    self.currentWeaponImg =  self.gameobject.transform:Find("CurrentWeapon"):GetComponent(typeof(UE.UI.Image))
    self.nextWeaponImg =  self.gameobject.transform:Find("NextWeapon"):GetComponent(typeof(UE.UI.Image))
    self.bulletsContainer = self.gameobject.transform:Find("Bullet"):GetComponentInChildren(typeof(UE.UI.GridLayoutGroup)).transform
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

return WeaponStateDlg