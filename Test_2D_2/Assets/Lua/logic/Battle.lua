
--[[
    战场类，处理角色的交互
--]]
local Timer = require("Timer")
local Camera = require("CameraFollowing")
local MC = require("MessageCenter")
local NetHelper = require("NetHelper")

local Battle=Class("Battle", require("Base"))

---
function Battle:cotr(character, initialWeapon)
    self.super:cotr()

    -----------------信息注册-------------
    self:AddMessageListener(Enum_NormalMessageType.PickUp, handler(self, self.PickUpHandler))
    self:AddMessageListener(Enum_NormalMessageType.ApproachItem, handler(self, self.ApproachItemHandler))
    self:AddMessageListener(Enum_NormalMessageType.LeaveItem, handler(self, self.LeaveItemHandler))
    self:AddMessageListener(Enum_NormalMessageType.ApproachNPC, handler(self, self.ApproachNPCHandler))
    self:AddMessageListener(Enum_NormalMessageType.LeaveNPC, handler(self, self.LeaveNPCHandler))
    self:AddMessageListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))
    self:AddMessageListener(Enum_NormalMessageType.OutOfAmmo, handler(self, self.OnOutOfAmmo))
    self:AddMessageListener(Enum_NormalMessageType.SelectItem, handler(self, self.OnSelectItem))

    ---实际的角色
    self.character = character
    ---实际的武器物体
    if initialWeapon then
        self.weaponObj = initialWeapon.gameobject
    end

    --------------------------武器-------------------------
    --- 武器存放的位置
    self.weaponStoreTrans = character.gameobject.transform.parent:Find("Weapons")
    --- 最大可持有武器数
    self.maxWeaponCount = 2
    --- 当前的武器索引
    self.currentWeaponIndex = 1
    ---当前的武器
    self.currentWeapon = nil
    --- 所拥有的所有武器
    self.Weapons={}
    --------------------------子弹-------------------------
    self.BulletsCount={}
    self.BulletsCount[Enum_BulletType.light] = 100
    self.BulletsCount[Enum_BulletType.heavy] = 20
    self.BulletsCount[Enum_BulletType.energy] = 0
    self.BulletsCount[Enum_BulletType.shell] = 0

    --------------------------装备-------------------------
    --- 装备存放的位置
    self.EquipmentStoreTrans = character.gameobject.transform.parent:Find("Equipments")
    --- 设定只能装一个装备
    self.currentEquipment = nil
    --------------------------物品-------------------------
    --- 物品存放的位置
    self.ItemStoreTrans = character.gameobject.transform.parent:Find("Items")
    ---最大可持有物品数
    self.maxItemCount = 2
    ---当前选中的物品索引(为有主动技能的物品留拓展)
    self.currentItemIndex = 1
    ---当前选中的物品(为有主动技能的物品留拓展)
    self.currentItem = nil
    ---所拥有的物品
    self.Items={}
    ----物品弹出UI--
    self.itemInfoDlg = require("BattleItemInfoDlg"):new()

    -------------------------货币------------------------
    --- 金币
    self.goldCount = 0
    --- 灵魂碎片
    self.soulShardCount = 0


    if initialWeapon then
        self:AddWeapon(initialWeapon)
    end
    ---目前聚焦的可使用物体(包括NPC)
    self.useableThing = nil
    ---用于计算射击CD
    self.CDTime = 0

    ---用于旋转武器
    self.mousePosition_screen = UE.Vector3()
    self.mousePosition_world = UE.Vector3()
    self.Left = UE.Vector3(-1, 1, 1)
    self.Right = UE.Vector3(1, 1, 1)

    self:SetUpdateFunc(self.UpdateBattle)

    --- 设置战场
    require("BattleData").currentBattle = self
end

--- 开始战斗
function Battle:BeginFight()
    -----------------信息注册-------------
    self:AddMessageListener(Enum_NormalMessageType.Shoot, handler(self, self.OnShoot))
    self:AddMessageListener(Enum_NormalMessageType.ReloadEnd, handler(self, self.OnReloadEnd))
    self:AddMessageListener(Enum_NormalMessageType.GameOver, handler(self, self.GameOverHandler))
    --- 子弹UI
    self.bulletsCountPnl = require("BulletsCountDlg"):new(self.BulletsCount[Enum_BulletType.light],  self.BulletsCount[Enum_BulletType.heavy], self.BulletsCount[Enum_BulletType.energy],  self.BulletsCount[Enum_BulletType.shell])
    --- 武器UI
    self.weaponStateDlg = require("WeaponStateDlg"):new()
    --- 物品UI
    self.itemsContainerPnl = require("ItemsContainerDlg"):new()
    --- 装备UI
    self.equipmentsPnl = require("EquipmentsDlg"):new()
    --- 战斗里货币UI
    self.goldAndSoulShardPnl = require("GoldAndSoulShardDlg"):new(self.goldCount, self.soulShardCount)
end

-----------------------------武器交互--------------------------------
--- 更换武器
--- 只有拥有两个及以上武器才能调用此函数
function Battle:ChangeWeapon(index)
    index = index % #self.Weapons
    if index == 0 then
        index = #self.Weapons
    end
    if index == self.currentWeaponIndex or #self.Weapons == 1 then
        return
    end
    if self.weaponObj then
        self.weaponObj:SetActive(false)
    end
    self.currentWeapon = self.Weapons[index]
    self.currentWeaponIndex = index
    self.weaponObj = self.currentWeapon.gameobject
    self.weaponObj:SetActive(true)
    if self.weaponStateDlg then
        local nextIndex = index + 1
        nextIndex = nextIndex % #self.Weapons
        if nextIndex == 0 then
            nextIndex = #self.Weapons
        end
        self.weaponStateDlg:ChangeToNext(self.Weapons[nextIndex].icon)
        self.weaponStateDlg:ReSetBullet(self.currentWeapon.bulletType, self.currentWeapon.currentAmmoACount)
    end
    --weapon

end

--- 添加武器
function Battle:AddWeapon(weapon)
    while #self.Weapons >= self.maxWeaponCount do
        self:DropWeapon()
    end
    self.currentWeapon = weapon
    table.insert(self.Weapons, self.currentWeaponIndex, weapon)
    weapon:SetOwner(self.character)
    if self.weaponObj then
        self.weaponObj:SetActive(false)
        if self.weaponStateDlg then
            self.weaponStateDlg:ChangeNext(self.currentWeapon.icon)
        end
    end
    self.weaponObj = weapon.gameobject
    self.weaponObj.transform:SetParent(self.weaponStoreTrans)
    if self.weaponStateDlg then
        self.weaponStateDlg:ChangeCurrent(self.currentWeapon.icon)
        self.weaponStateDlg:ReSetBullet(self.currentWeapon.bulletType, self.currentWeapon.currentAmmoACount)
    end
end

--- 扔掉武器
--- 只有拥有两个及以上武器才能调用此函数
function Battle:DropWeapon()
    ---至少持有一个武器
    if #self.Weapons <= 1 then
        return
    end
    self.weaponObj.transform:SetParent(nil)
    self.currentWeapon:Drop()
    table.remove(self.Weapons, self.currentWeaponIndex)
    self.currentWeaponIndex = self.currentWeaponIndex % #self.Weapons
    if self.currentWeaponIndex == 0 then
        self.currentWeaponIndex = #self.Weapons
    end
    self.currentWeapon = self.Weapons[self.currentWeaponIndex]
    self.weaponObj = self.currentWeapon.gameobject
    self.weaponObj:SetActive(true)
    if self.weaponStateDlg then
        self.weaponStateDlg:ReSetBullet(self.currentWeapon.bulletType, self.currentWeapon.currentAmmoACount)
        if #self.Weapons > 1 then
            local nextIndex = self.currentWeaponIndex + 1
            nextIndex = nextIndex % #self.Weapons
            if nextIndex == 0 then
                nextIndex = #self.Weapons
            end
            self.weaponStateDlg:ChangeToNext(self.Weapons[nextIndex].icon)
        else
            self.weaponStateDlg:ChangeToNext()
        end
    end
end
-----------------------------装备交互-------------------------
--- 添加装备
function Battle:AddEquipment(equipment)
    if self.currentEquipment then
        self:DropEquipment()
    end
    self.currentEquipment = equipment
    self.character:AddBuff(equipment.buff)
    equipment.gameobject.transform:SetParent(self.EquipmentStoreTrans)
    self.equipmentsPnl:ChangeSprite(equipment.icon)
end
--- 丢掉装备
function Battle:DropEquipment()
    if self.currentEquipment then
        self.character:RemoveBuff(self.currentEquipment.buff)
        self.equipmentsPnl:RemoveSprite()
        self.currentEquipment:Drop()
        self.currentEquipment = nil
    end
end

-----------------------------物品交互--------------------------
--- 添加物品
function Battle:AddItem(Item)
    while #self.Items >= self.maxItemCount do
        self:DropItem()
    end
    self.character:AddBuff(Item.buff)
    self.itemsContainerPnl:AddItem(Item)
    table.insert(self.Items, Item)
    Item.gameobject.transform:SetParent(self.ItemStoreTrans)
    if #self.Items == 1 then
        self.currentItem = Item
    end
end

---丢掉物品
function Battle:DropItem()
    if #self.Items <= 0 then
        return
    end
    self.character:RemoveBuff(self.currentItem.buff)
    self.itemsContainerPnl:RemoveItem(self.currentItem)
    table.remove(self.Items, self.currentItemIndex)
    self.currentItem.gameobject.transform:SetParent(nil)
    self.currentItem:Drop()
    if #self.Items > 0 then
        self.currentItemIndex = self.currentItemIndex % #self.Items
        if self.currentItemIndex == 0 then
            self.currentItemIndex = #self.Items
        end
        self.currentItem = self.Items[self.currentItemIndex]
    else
        self.currentItem = nil
        self.currentItemIndex = 1
    end
end

--- 选择物体
function Battle:SelectItem(Item)
    for k, v in ipairs(self.Items) do
        if v == Item then
            self.currentItem = v
            self.currentItemIndex = k
        end
    end
end
------------------------Update---------------------
function Battle:UpdateBattle()

    ---所有东西都跟随玩家
    for _, v in pairs(self.Weapons) do
        v.gameobject.transform.position = self.character.gameobject.transform.position
    end
    for _, v in pairs(self.Items) do
        v.gameobject.transform.position = self.character.gameobject.transform.position
    end
    if self.currentEquipment then
        self.currentEquipment.gameobject.transform.position = self.character.gameobject.transform.position
    end

    ---武器跟随鼠标旋转
    if self.weaponObj then
        self.mousePosition_screen = UE.Input.mousePosition
        self.mousePosition_screen.z = -Camera.gameobject.transform.position.z
        self.mousePosition_world = Camera.camera:ScreenToWorldPoint(self.mousePosition_screen)
        local vector = self.mousePosition_world-self.weaponObj.transform.position
        local angle =  UE.Vector3.Angle(vector, UE.Vector3.right)
        self.currentWeapon.dirction = vector
        if vector.x > 0 then
            self.weaponObj.transform.localScale = self.Right
            if vector.y > 0 then
                self.weaponObj.transform.rotation = UE.Quaternion.Euler(0, 0, angle)
            else
                self.weaponObj.transform.rotation = UE.Quaternion.Euler(0, 0, -angle)
            end
        else
            self.weaponObj.transform.localScale = self.Left
            if vector.y > 0 then
                self.weaponObj.transform.rotation = UE.Quaternion.Euler(0, 0, angle-180)
            else
                self.weaponObj.transform.rotation = UE.Quaternion.Euler(0, 0, -angle-180)
            end
        end
    end

    ---响应事件
    if  self.currentWeapon and not self.currentWeapon.isReloading then
        if (not UE.EventSystems.EventSystem.current:IsPointerOverGameObject()) then
            if UE.Input.GetMouseButtonDown(1) then
                self:ChangeWeapon(self.currentWeaponIndex+1)
            elseif UE.Input.GetMouseButtonDown(0) then
                self.currentWeapon:UpdateShootBegin()
            elseif UE.Input.GetMouseButton(0) then
                self.currentWeapon:UpdateShoot()
            elseif UE.Input.GetMouseButtonUp(0) then
                self.currentWeapon:UpdateShootEnd()
            end
        end
        if UE.Input.GetKeyDown(UE.KeyCode.R) then
            self.currentWeapon:Reload(self.BulletsCount[ self.currentWeapon.bulletType])
        elseif UE.Input.GetKeyDown(UE.KeyCode.G) then
            self:DropWeapon()
        end
    end
    if UE.Input.GetKeyDown(UE.KeyCode.E) and self.useableThing then
        if  self.currentWeapon and self.currentWeapon.isReloading then

        elseif self.useableThing.Use then
            self.useableThing:Use()
        end
    elseif UE.Input.GetKeyDown(UE.KeyCode.C) then
        self:DropItem()
    elseif UE.Input.GetKeyDown(UE.KeyCode.X) then
        self:DropEquipment()
    end
end

----------------------回调函数--------------------
function Battle:PickUpHandler(kv)
    if kv.Key == Enum_ItemType.weapon then
        self:AddWeapon(kv.Value)
    elseif kv.Key == Enum_ItemType.equipment then
        self:AddEquipment(kv.Value)
    elseif kv.Key == Enum_ItemType.item then
        self:AddItem(kv.Value)
    end
end

function Battle:ApproachItemHandler(kv)
    if kv.Key == Enum_ItemType.weapon then
        self.useableThing = kv.Value
        self.itemInfoDlg:Show(Enum_ItemType.weapon, kv.Value.name, kv.Value, kv.Value.info)
    elseif kv.Key == Enum_ItemType.equipment then
        self.useableThing = kv.Value
        self.itemInfoDlg:Show(Enum_ItemType.equipment, kv.Value.name, kv.Value.info, kv.Value.extraInfo)
    elseif kv.Key == Enum_ItemType.item then
        self.useableThing = kv.Value
        self.itemInfoDlg:Show(Enum_ItemType.item, kv.Value.name, kv.Value.info, kv.Value.extraInfo)
    end

end

function Battle:ApproachNPCHandler(kv)
    self.useableThing = kv.Value
end

function Battle:LeaveItemHandler(kv)
    self.useableThing = nil
    if kv.Key == Enum_ItemType.weapon then
        self.itemInfoDlg:Hide(kv.Key)
    elseif kv.Key == Enum_ItemType.equipment then
        self.itemInfoDlg:Hide(kv.Key)
    elseif kv.Key == Enum_ItemType.item then
        self.itemInfoDlg:Hide(kv.Key)
    end
end

function Battle:LeaveNPCHandler(kv)
    self.useableThing = nil
end

function Battle:OnOutOfAmmo(kv)
    if kv.Key == self.character then
        self.currentWeapon:Reload(self.BulletsCount[ self.currentWeapon.bulletType])
    end
end

function Battle:OnShoot(kv)
    if self.BulletsCount[kv.Key] > 0 then
        self.BulletsCount[kv.Key] = self.BulletsCount[kv.Key] -1
        self.bulletsCountPnl:BulletCountChangeTo(kv.Key, self.BulletsCount[kv.Key])
        self.weaponStateDlg:ReduceBullet(1)
    end
end

function Battle:OnSelectItem(kv)
    self:SelectItem(kv.Value)
end

function Battle:OnReloadEnd(kv)
    self.weaponStateDlg:ReSetBullet(self.currentWeapon.bulletType, self.currentWeapon.currentAmmoACount)
end

function Battle:GameOverHandler(kv)
    require("BattleResultDlg"):new(self.soulShardCount)
    if self.soulShardCount > 0 then
        NetHelper:SendGameOver(self.soulShardCount)
    end

    Timer:AddUpdateFuc(self, function ()
        if UE.Input.GetMouseButtonDown(0) then
            Timer:RemoveUpdateFuc(self, self.WaitForClickUpdate)
            require("SceneManager"):LoadScene(Enum_Scenes.Rest)
        end
    end)
end
function Battle:OnChangeScene(kv)
    self:Destroy()
    require("BattleData").currentBattle = nil
end
return Battle