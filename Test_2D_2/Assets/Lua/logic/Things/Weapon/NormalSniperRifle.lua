--[[
    狙击枪
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local Timer = require("Timer")
local MC = require("MessageCenter")
local AudioMgr = require("AudioManager")

local NormalSniperRifle=Class("NormalSniperRifle", require("Weaponbase"))

function NormalSniperRifle:cotr(ID, position)
    self.super:cotr()
    local weaponData = require("WeaponData").Weapons[ID]
    ---------初始化属性-----------
    self.name = weaponData.name
    self.info = weaponData.info
    ---获取初始数据
    self.weaponType = weaponData.weaponType
    self.bulletType = weaponData.bulletType
    self.shootType = weaponData.shootType
    ---基础伤害
    self.demage = weaponData.basicDamage
    ---子弹速度
    self.bulletSpeed = weaponData.basicSpeed
    --- 射击冷却时间
    self.shootCDTime = weaponData.basicCD
    --- 一弹夹子弹数量
    self.clipsAmmoCount = weaponData.basicClipsAmmoCount
    --- 当前子弹数量
    self.battle = require("BattleData").currentBattle
    if self.battle and self.battle.BulletsCount[self.bulletType] < self.clipsAmmoCount then
        self.currentAmmoACount = self.battle.BulletsCount[self.bulletType]
    else
        self.currentAmmoACount = self.clipsAmmoCount
    end
    --- 装弹时间
    self.reloadTime = weaponData.basicReloadTime
    --- 蓄力到最强的时间
    self.storeForceTime = weaponData.storeForceTime
    --- 最多能蓄力到多少倍
    self.maxTimesCount = weaponData.maxTimesCount

    self.isReloading = false
    --------------------------------------
    self.gameobject = ResourceMgr:GetGameObject(weaponData.PrefabPath, weaponData.PrefabName, nil, position)
    self.spriteRenderer = self.gameobject:GetComponentInChildren(typeof(UE.SpriteRenderer))
    self.collsion =  self.gameobject:GetComponentInChildren(typeof(UE.BoxCollider2D))
    self.audioSource = self.gameobject:AddComponent(typeof(UE.AudioSource))


    ---子弹出口位置距枪的位置的长度
    self.bulletStartDistance = 1.2
    ---初始枪口朝向
    self.dirction = UE.Vector3(0, 0, 1)

    ---是否在冷却时间
    self.isCD = false
    ---是否在蓄力
    self.storingForce = false
    ---当前蓄力倍数
    self.currentTimes = 1
    ---用于计算蓄力
    self.time = 0

    self:SetUpdateFunc(self.UpdateIdle)
    --------------添加监听---------------------
    self:AddMessageListener(Enum_NormalMessageType.ChengeEffectMusicVolume, handler(self, self.OnChengeEffectMusicVolume))
    self:AddMessageListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))
end

function NormalSniperRifle:UpdateIdle()

end

function NormalSniperRifle:UpdateShoot()
    if self.storingForce then
        --- 因为在update里，就不用Unity的mathf.lerp了，还是自己写好点
        self.time = self.time + Timer.deltaTime
        self.currentTimes = 1 + (self.maxTimesCount - 1)*(self.time/self.storeForceTime > 1 and 1 or self.time/self.storeForceTime)
    end
end

function NormalSniperRifle:UpdateShootBegin()
    if self.isCD or self.isReloading or self.storingForce then
        return
    end
    if self.currentAmmoACount <= 0 then
        self:Reload()
    else
        self.isCD = true
        Timer:InvokeCoroutine(function () self.isCD = false end, self.shootCDTime)
        self.storingForce = true
    end
end

function NormalSniperRifle:UpdateShootEnd()
    if self.storingForce then
        self.storingForce = false
        self.time = 0
        self:Shoot()
    end
end

function NormalSniperRifle:Shoot()
    if self.audioSource then
        AudioMgr:PlayAudio(self.audioSource, ResourceMgr:Load(PathMgr.ResourcePath.Audio_Shoot_ES, PathMgr.NamePath.Audio_Shoot_ES))
    end
    self.currentAmmoACount = self.currentAmmoACount-1
    self:GenerateBullet()
    self.currentTimes = 1
    MC:SendMessage(Enum_NormalMessageType.Shoot, require("KeyValue"):new(self.bulletType, self.weaponType))
    self.time = 0
end

function NormalSniperRifle:GenerateBullet()
    local dir = self.dirction.normalized
    if self.bulletType == Enum_BulletType.light then
        require("LightBullet"):new(dir, self.gameobject.transform.position+dir*self.bulletStartDistance,self.gameobject.transform.rotation,self.bulletSpeed, self.demage*self.currentTimes)
    elseif self.bulletType == Enum_BulletType.heavy then
        require("HeavyBullet"):new(dir, self.gameobject.transform.position+dir*self.bulletStartDistance,self.gameobject.transform.rotation,self.bulletSpeed, self.demage*self.currentTimes)
    elseif self.bulletType == Enum_BulletType.energy then
        require("EnergyBullet"):new(dir, self.gameobject.transform.position+dir*self.bulletStartDistance,self.gameobject.transform.rotation,self.bulletSpeed, self.demage*self.currentTimes)
    elseif self.bulletType == Enum_BulletType.shell then
        require("ShellBullet"):new(dir, self.gameobject.transform.position+dir*self.bulletStartDistance,self.gameobject.transform.rotation,self.bulletSpeed, self.demage*self.currentTimes)
    end
end

function NormalSniperRifle:Reload()
    if not self.battle or self.battle.BulletsCount[self.bulletType] <= 0 then
        return
    end
    if self.audioSource then
        AudioMgr:PlayAudio(self.audioSource, ResourceMgr:Load(PathMgr.ResourcePath.Audio_ReloadAmmo_Es, PathMgr.NamePath.Audio_ReloadAmmo_Es))
    end
    self.isReloading = true
    MC:SendMessage(Enum_NormalMessageType.ReloadBegin, require("KeyValue"):new(self.weaponType, self))
    Timer:InvokeCoroutine(function ()
        if self.battle.BulletsCount[self.bulletType] < self.clipsAmmoCount then
            self.currentAmmoACount = self.battle.BulletsCount[self.bulletType]
        else
            self.currentAmmoACount = self.clipsAmmoCount
        end
        MC:SendMessage(Enum_NormalMessageType.ReloadEnd, require("KeyValue"):new(self.weaponType, self))
        self.isReloading = false end, self.reloadTime)
    --- 播放动画
end

function NormalSniperRifle:Use()
    if self.isPacked then
        return
    end
    self.spriteRenderer.sortingLayerName = "PickedWeapon"
    self:RemoveUpdateFunc(self.UpdateIdle)
    self.collsion.enabled = false
    require("MessageCenter"):SendMessage(Enum_NormalMessageType.PickUp, require("KeyValue"):new(Enum_ItemType.weapon, self))
    self.isPacked = true

end

function NormalSniperRifle:Drop()
    self.isPacked = false
    self.collsion.enabled = true
    self.spriteRenderer.sortingLayerName = "Weapon"
    self:SetUpdateFunc(self.UpdateIdle)
end
---------------消息回调---------------
function NormalSniperRifle:OnChengeEffectMusicVolume(kv)
    if self.audioSource then
        self.audioSource.volume = kv.Value
    end
end

function NormalSniperRifle:OnChangeScene(kv)
    self:Destroy()
end

return NormalSniperRifle