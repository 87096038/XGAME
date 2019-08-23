﻿
local Timer = require("Timer")
local Camera = require("CameraFollowing")
local MC = require("MessageCenter")


local Battle=Class("Battle", require("Base"))

---
function Battle:cotr(character, initialWeapon)
    self.super:cotr()

    -----------------信息注册-------------
    self:AddMessageListener(Enum_NormalMessageType.PickUp, handler(self, self.PickUpHandler))
    self:AddMessageListener(Enum_NormalMessageType.ApproachItem, handler(self, self.ApproachItemHandler))
    self:AddMessageListener(Enum_NormalMessageType.LeaveItem, handler(self, self.LeaveItemHandler))
    self:AddMessageListener(Enum_NormalMessageType.GameOver, handler(self, self.GameOverHandler))
    self:AddMessageListener(Enum_NormalMessageType.ApproachNPC, handler(self, self.ApproachNPCHandler))
    self:AddMessageListener(Enum_NormalMessageType.LeaveNPC, handler(self, self.LeaveNPCHandler))
    self:AddMessageListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))

    ---实际的角色
    self.character = character
    ---实际的武器物体
    if initialWeapon then
        self.weaponObj = initialWeapon.gameobject
    end

    --------------------------武器-------------------------
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
    self.BulletsCount[Enum_BulletType.light] = 0
    self.BulletsCount[Enum_BulletType.heavy] = 0
    self.BulletsCount[Enum_BulletType.energy] = 0
    self.BulletsCount[Enum_BulletType.shell] = 0
    --------------------------物品-------------------------
    ---最大可持有物品数
    self.maxItemCount = 2
    ---当前选中的物品索引(为有主动技能的物品留拓展)
    self.currentItemIndex = 1
    ---当前选中的物品(为有主动技能的物品留拓展)
    self.currentItem = nil
    ---所拥有的物品
    self.Items={}
    if initialWeapon then
        self:AddWeapon(initialWeapon)
    end
    --------------------------UI------------------------

    --- 金币数目
    self.goldCount = 0
    ---目前聚焦的可使用物体(包括NPC)
    self.useableThing = nil
    ---用于计算射击CD
    self.CDTime = 0

    ---用于旋转武器
    self.mousePosition_screen = UE.Vector3()
    self.mousePosition_world = UE.Vector3()
    self.Left = UE.Vector3(-1, 1, 1)
    self.Right = UE.Vector3(1, 1, 1)

    self:SetUpdateFunc(Battle.UpdateBattle)

    --- 设置战场
    require("BattleData").currentBattle = self
end

--- 更换武器
function Battle:ChangeWeapon(index)
    if index == self.currentWeaponIndex or index > self.maxWeaponCount or #self.Weapons == 1 then
        return
    end
    index = index % self.maxWeaponCount
    if index == 0 then
        index = self.maxWeaponCount
    end
    self.currentWeapon = self.Weapons[index]
    self.currentWeaponIndex = index
    --weapon

end

--- 添加武器
function Battle:AddWeapon(weapon)
    if #self.Weapons >= self.maxWeaponCount then
        self:DropWeapon()
    end
    self.currentWeapon = weapon
    self.Weapons[self.currentWeaponIndex] = weapon
    self.weaponObj = weapon.gameobject
    self.weaponObj.transform:SetParent(self.character.transform.parent)
end

--- 扔掉武器
function Battle:DropWeapon()
    ---至少持有一个武器
    if #self.Weapons <= 1 then
        return
    end
    self.weaponObj.transform:SetParent(nil)
    self.currentWeapon:Drop()
    self:ChangeWeapon(self.currentWeaponIndex+1)
end

function Battle:UpdateBattle()

    if self.weaponObj then
        ---武器跟随玩家
        self.weaponObj.transform.position = self.character.gameobject.transform.position

        ---武器跟随鼠标旋转
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
    if UE.Input.GetMouseButtonDown(1) and self.currentWeapon then
        self:ChangeWeapon(self.currentWeaponIndex+1)
    elseif UE.Input.GetKeyDown(UE.KeyCode.E) and self.useableThing then
        if self.useableThing.Use then
            self.useableThing:Use()
        end
    else
        if self.currentWeapon then
            self.currentWeapon:UpdateShoot()
        end
    end
end
----------------------回调函数--------------------
function Battle:PickUpHandler(kv)
    if kv.Key == Enum_ItemType.weapon then
        self:AddWeapon(kv.Value)
    end
end

function Battle:ApproachItemHandler(kv)
    if kv.Key == Enum_ItemType.weapon then

        self.useableThing = kv.Value
    elseif kv.Key == Enum_ItemType.equipment then

    end
end

function Battle:ApproachNPCHandler(kv)
    self.useableThing = kv.Value
end

function Battle:LeaveNPCHandler(kv)
    self.useableThing = nil
end

function Battle:LeaveItemHandler(kv)
    self.useableThing = nil
end

function Battle:GameOverHandler(kv)
    --self:Destroy()
end
function Battle:OnChangeScene()
    self:Destroy()
    require("BattleData").currentBattle = nil
end
return Battle