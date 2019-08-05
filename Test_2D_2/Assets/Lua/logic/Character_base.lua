local ResourceMgr = require("ResourceManager")
local Character_base=Class("character_base", require("Base"))

function Character_base:cotr()
    self.super:cotr()
    self.state=Enum_CharacterBehaviorType.idle
end

---from,to: 类型为CharacterBehaviorType枚举
function Character_base:ChangeBehavior(from, to)

end

function Character_base:Move()
    print("move")
end

function Character_base:Dead()
    self.state = Enum_CharacterBehaviorType.dead
    ResourceMgr:DestroyObject(self.gameobject)
end

return Character_base