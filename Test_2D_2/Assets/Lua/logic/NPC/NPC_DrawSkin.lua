
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local MC= require("MessageCenter")

local NPC_DrawSkin = {}

function NPC_DrawSkin:Init()
    self.position = UE.Vector3(0, 5, -2)
    self.type = Enum_NPCType.draw_skin
    self.gameobject = nil
    self.drawSkinDlg = nil
end

function NPC_DrawSkin:Generate()
    if not CS.Util.IsNull(self.gameobject) then
        return
    end
    local isNew
    self.gameobject, isNew = ResourceMgr:GetGameObject(PathMgr.ResourcePath.NPC_DrawSkin, PathMgr.NamePath.NPC_DrawSkin, nil, self.position)
    self.drawSkinDlg = require("DrawSkinDlg"):new()
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

function NPC_DrawSkin:OnCollision(type, other)
    if type == Enum_CollisionType.TriggerEnter2D then
        --- 主角的Layer
        if other.gameObject.layer == 9 then
            MC:SendMessage(Enum_NormalMessageType.ApproachNPC, require("KeyValue"):new(NPC_DrawSkin.type, NPC_DrawSkin))
        end
    end
    if type == Enum_CollisionType.TriggerExit2D then
        if other.gameObject.layer == 9 then
            if NPC_DrawSkin.drawSkinDlg then
                NPC_DrawSkin.drawSkinDlg:Hide()
            end
            MC:SendMessage(Enum_NormalMessageType.LeaveNPC, require("KeyValue"):new(NPC_DrawSkin.type, NPC_DrawSkin))
        end
    end
end

--- 这个函数叫Use是为了在Battle统一使用
function NPC_DrawSkin:Use()
    if self.drawSkinDlg then
        self.drawSkinDlg:Show()
    end
end

NPC_DrawSkin:Init()
return NPC_DrawSkin