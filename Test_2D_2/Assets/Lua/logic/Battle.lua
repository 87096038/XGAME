local Timer = require("Timer")
local Camera = require("CameraFollowing")
local MC = require("MessageCenter")


local Battle=Class("Battle", require("Base"))

--- 一定要有个初始武器
function Battle:cotr(character,  initialWeapon)
    self.super:cotr()
    ---实际的角色
    self.character = character
    ---实际的武器物体
    self.weaponObj = initialWeapon.gameobject

    initialWeapon.isPacked = true
    self.weaponObj.transform:SetParent(self.character.transform.parent)
--------------------------武器-------------------------
    --- 最大可持有武器数
    self.maxWeaponCount = 2
    --- 当前的武器索引
    self.currentWeaponIndex = 1
    ---当前的武器
    self.currentWeapon = initialWeapon
    --- 所拥有的所有武器
    self.Weapons={initialWeapon}
--------------------------物品-------------------------
    ---最大可持有物品数
    self.maxItemCount = 2
    ---当前选中的物品索引(为有主动技能的物品留拓展)
    self.currentItemIndex = 1
    ---当前选中的物品(为有主动技能的物品留拓展)
    self.currentItem = nil
    ---所拥有的物品
    self.Items={}


    ---目前聚焦的可使用物体
    self.useableThing = nil
    ---生命值
    self.heath =  self.character.heath
    ---用于计算射击CD
    self.CDTime = 0

    ---用于旋转武器
    self.mousePosition_screen = UE.Vector3()
    self.mousePosition_world = UE.Vector3()
    self.Left = UE.Vector3(-1, 1, 1)
    self.Right = UE.Vector3(1, 1, 1)

    Timer:AddUpdateFuc(self, Battle.UpdateBattle)

    -----------------信息注册-------------
    self:AddMessageListener(Enum_MessageType.PickUp, self.PickUpHandler)
    self:AddMessageListener(Enum_MessageType.GameOver, self.GameOverHandler)

end

function Battle:ChangeWeapon(index)
    if index == self.currentWeaponIndex then
        return
    end
    index = index % self.maxWeaponCount
    if index == 0 then
        index = self.maxWeaponCount
    end
    self.currentWeapon = self.Weapons[index]
    --weapon

end

function Battle:AddWeapon(weapon)
    if #self.Weapons >= self.maxWeaponCount then
        self:DropWeapon()
    end

end

function Battle:DropWeapon()
    ---至少持有一个武器
    if #self.Weapons <= 1 then
        return
    end
end

function Battle:UpdateBattle()

    ---武器跟随玩家
    self.weaponObj.transform.position = self.character.gameobject.transform.position

    ---武器跟随鼠标旋转
    self.mousePosition_screen = UE.Input.mousePosition
    self.mousePosition_screen.z = -Camera.gameobject.transform.position.z
    self.mousePosition_world = Camera.camera:ScreenToWorldPoint(self.mousePosition_screen)
    local vector = self.mousePosition_world-self.weaponObj.transform.position
    local angle =  UE.Vector3.Angle(vector, UE.Vector3.right)

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

    ---响应事件
    if UE.Input.GetMouseButtonDown(1) then
        self:ChangeWeapon(self.currentWeaponIndex+1)
    elseif UE.Input.GetKey(UE.KeyCode.E) and self.useableThing then
        self.useableThing:Use()
    else
        self.currentWeapon:Shoot()
    end
end

----------------------回调函数--------------------

function Battle:PickUpHandler(kv)
    if kv.Key == "weapon" then
        self:AddWeapon(kv.Value)
    end
end

function Battle:GameOverHandler(kv)
    self:Destroy()
end

return Battle