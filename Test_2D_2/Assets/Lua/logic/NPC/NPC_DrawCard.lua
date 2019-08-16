
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local MC= require("MessageCenter")

local NPC_DrawCard = {}

function NPC_DrawCard:Init()
    self.position = UE.Vector3(0, 10, 0)
    self.type = Enum_NPCType.draw_card
    self.gameobject = nil
    self.drawCardDlg = nil
end

function NPC_DrawCard:Generate()
    local isNew
    self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.NPC_DrawCard, PathMgr.NamePath.NPC_DrawCard, nil, self.position)
    self.drawCardDlg = require("DrawCardDlg"):new()
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
            MC:SendMessage(Enum_MessageType.ApproachNPC, require("KeyValue"):new(NPC_DrawCard.type, NPC_DrawCard))
        end
    end
    if type == Enum_CollisionType.TriggerExit2D then
        if other.gameObject.layer == 9 then
            if NPC_DrawCard.drawCardDlg then
                NPC_DrawCard.drawCardDlg:Hide()
            end
            MC:SendMessage(Enum_MessageType.LeaveNPC, require("KeyValue"):new(NPC_DrawCard.type, NPC_DrawCard))
        end
    end
end

--- 这个函数叫Use是为了在Battle统一使用
function NPC_DrawCard:Use()
    if self.drawCardDlg then
        self.drawCardDlg:Show()
    end
end

NPC_DrawCard:Init()
return NPC_DrawCard