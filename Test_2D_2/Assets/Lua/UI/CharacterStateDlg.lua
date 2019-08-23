
--[[
    左上角状态的Dlg管理
--]]

local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local BattleData = require("BattleData")

local CharacterStateDlg = Class("CharacterStateDlg", require("Base"))

function CharacterStateDlg:cotr(character)
    self.gameobject = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_CharacterStateInBattle, PathMgr.NamePath.UI_CharacterStateInBattle, Main.UIRoot.transform)
    self.character = nil
    self.heath = {icon = self.gameobject.transform:Find("Heath"):Find("Icon"), slider = self.gameobject.transform:Find("Heath"):GetComponentInChildren(typeof(UE.UI.Slider)), text = self.gameobject.transform:Find("Heath"):Find("Slider"):GetComponentInChildren(typeof(UE.UI.Text)) }
    self.armor = {icon = self.gameobject.transform:Find("Armor"):Find("Icon"), slider = self.gameobject.transform:Find("Armor"):GetComponentInChildren(typeof(UE.UI.Slider)), text = self.gameobject.transform:Find("Armor"):Find("Slider"):GetComponentInChildren(typeof(UE.UI.Text)) }
    self.buffTrans = self.gameobject.transform:Find("Buff")
    if character then
        self:SetCharacter(character)
    end
    ----------------添加监听----------------
    self:AddMessageListener(Enum_NormalMessageType.ChangeScene, handler(self, self.OnChangeScene))
    self:AddMessageListener(Enum_NormalMessageType.ChangeHeath, handler(self, self.OnChangeHeath))
    self:AddMessageListener(Enum_NormalMessageType.ChangeArmor, handler(self, self.OnChangeArmor))
    self:AddMessageListener(Enum_NormalMessageType.ChangeHeathCeiling, handler(self, self.OnChangeHeathCeiling))
    self:AddMessageListener(Enum_NormalMessageType.ChangeArmorCeiling, handler(self, self.OnChangeArmorCeiling))
end


function CharacterStateDlg:SetCharacter(character)
    self.character = character
    self:Refresh()
end

function CharacterStateDlg:Refresh()
    self.heath.slider.maxValue = self.character.maxHeath
    self.armor.slider.maxValue = self.character.maxArmor
    self.heath.slider.value = self.character.currentHeath
    self.armor.slider.value = self.character.currentArmor
    self.heath.text.text = self.character.currentHeath.."/"..math.ceil(self.character.maxHeath)
    self.armor.text.text = self.character.currentArmor.."/"..math.ceil(self.character.maxArmor)
end

function CharacterStateDlg:ChangeTo(heath, armor)
    if heath and self.heath.slider.value ~= heath then
        if heath < 0 then
            heath = 0
        end
        StartCoroutine(function ()
            local wait = UE.WaitForSeconds(0.01)
            local diff = heath - self.heath.slider.value
            local stepCount = 20
            local step = diff/stepCount
            local current = self.heath.slider.value
            for i=1, stepCount do
                current = current + step
                self.heath.slider.value = math.ceil(current)
                self.heath.text.text = self.heath.slider.value.."/"..math.ceil(self.heath.slider.maxValue)
                coroutine.yield(wait)
            end
            self.heath.slider.value = heath
            self.heath.text.text = heath.."/"..math.ceil(self.heath.slider.maxValue)
        end)
    end
    if armor and self.armor.slider.value ~= armor then
        if armor < 0 then
            armor = 0
        end
        StartCoroutine(function ()
            local wait = UE.WaitForSeconds(0.01)
            local diff = armor - self.armor.slider.value
            local stepCount = 20
            local step = diff/stepCount
            local current = self.armor.slider.value
            for i=1, stepCount do
                current = current + step
                self.armor.slider.value = math.ceil(current)
                self.armor.text.text = self.armor.slider.value.."/"..math.ceil(self.armor.slider.maxValue)
                coroutine.yield(wait)
            end
            self.armor.slider.value = armor
            self.armor.text.text = armor.."/"..math.ceil(self.armor.slider.maxValue)
        end)
    end
end

function CharacterStateDlg:AddBuffIcon(buffType)

end

-------------------消息回调--------------------

function CharacterStateDlg:OnChangeHeath(kv)
    self:ChangeTo(kv.Value, nil)
end

function CharacterStateDlg:OnChangeArmor(kv)
    self:ChangeTo(nil, kv.Value)
end

function CharacterStateDlg:OnChangeScene(kv)
    self:Destroy()
end

function CharacterStateDlg:OnChangeHeathCeiling(kv)
    self:Refresh()
end

function CharacterStateDlg:OnChangeArmorCeiling(kv)
    self:Refresh()
end

return CharacterStateDlg