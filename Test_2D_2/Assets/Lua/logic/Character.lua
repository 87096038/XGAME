local Timer = require("Timer")
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")

local character_base = require("character_base")
local Character=Class("Character", character_base)

function Character:cotr()
    ---gameobject---
    self.super:cotr()
    local isNew
    self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.Character_1, PathMgr.NamePath.Character_1).transform:Find("Role")
    self.collsion = self.gameobject:GetComponent(typeof(CS.Collision))
    if isNew then
        if self.collsion.CollisionHandle then
            self.collsion.CollisionHandle = self.collsion.CollisionHandle + self.OnCollision
        else
            self.collsion.CollisionHandle = self.OnCollision
        end
    end
    self.rigidbody2d = self.gameobject:GetComponent("Rigidbody2D")
    self.transform = self.gameobject:GetComponent("Transform")
    self.speed = 5
    self.animatior = self.gameobject:GetComponent("Animator")

    self.Left = UE.Vector3(-1, 1, 1)
    self.Right = UE.Vector3(1, 1, 1)

    ---state---
    self.heath = 100

end

function Character:Start()
    Timer:AddUpdateFuc(self, self.update)
end

function Character:update()

    local horizontal = UE.Input.GetAxisRaw("Horizontal")
    local vertical = UE.Input.GetAxisRaw("Vertical")

    if horizontal ~= 0 or vertical ~= 0 then
        self.animatior:SetFloat("Speed", 0.2)
        if horizontal > 0 then
            self.transform.localScale = self.Right
        elseif horizontal < 0 then
            self.transform.localScale = self.Left
        end
        local position = self.rigidbody2d.position
        position.x = position.x + self.speed * horizontal * Timer.deltaTime
        position.y = position.y + self.speed * vertical * Timer.deltaTime

        self.rigidbody2d:MovePosition(position)
    else
        self.animatior:SetFloat("Speed", 0)
    end
end

function Character:OnCollision(type, other)

end

return Character