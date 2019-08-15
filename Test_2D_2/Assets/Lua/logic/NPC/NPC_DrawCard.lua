
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local MC= require("MessageCenter")

local NPC_DrawCard = {}

function NPC_DrawCard:Init()
    self.position = CS.Vector3(0, 20, 0)
    self.type = Enum_NPCType.draw_card
    self.gameobject = nil
    self.drawCardPnl = nil
end

function NPC_DrawCard:Generate()
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.NPC_DrawCard, PathMgr.NamePath.NPC_DrawCard, nil, self.position)
    -------绑定碰撞------
    self.collsion = self.gameobject:AddComponent(typeof(CS.Collision))
    if isNew then
        if self.collsion.CollisionHandle then
            self.collsion.CollisionHandle = self.collsion.CollisionHandle + self.OnCollision
        else
            self.collsion.CollisionHandle = self.OnCollision
        end
    end
end

function NPC_DrawCard:OnCollision(type, other)
    if type == Enum_CollisionType.TriggerEnter2D then
        --- 主角的Layer
        if other.gameObject.layer == 9 then
            MC:SendMessage(Enum_MessageType.ApproachNPC, require("KeyValue"):new(self.type, self))
            print("可以交互了")
        end
    end
end

--- 这个函数叫Use是为了在Battle统一使用
function NPC_DrawCard:Use()
    if not self.drawCardPnl then
        ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_DrawCardPnl, PathMgr.NamePath.UI_DrawCardPnl, Main.UIRoot.transform)
    end
end

NPC_DrawCard:Init()
return NPC_DrawCard