
--[[
    设置的dlg
--]]
local ResourceMgr = require("ResourceManager")
local PathMgr = require("PathManager")
local AudioMgr = require("AudioManager")

local SettingDlg = Class("SettingDlg", require("Base"))

function SettingDlg:cotr()
    local isNwe
    self.gameobject, isNwe = ResourceMgr:GetGameObject(PathMgr.ResourcePath.UI_Setting, PathMgr.NamePath.UI_Setting, Main.UIRoot.transform)
    self.settingPnlObj = self.gameobject.transform:Find("Panel").gameObject

    self.BGMVolumeSlider = self.settingPnlObj.transform:Find("BGMVolume"):GetComponentInChildren(typeof(UE.UI.Slider))
    self.BGMVolumeSlider.value = AudioMgr.BGMVolume
    self.EffectVolumeSlider = self.settingPnlObj.transform:Find("EffectMusicVolume"):GetComponentInChildren(typeof(UE.UI.Slider))
    self.EffectVolumeSlider.value = AudioMgr.BGMVolume
    if isNwe then
        ------------设置两个音量Slider------------
        local trigger_1 = self.BGMVolumeSlider.gameObject:AddComponent(typeof(UE.EventSystems.EventTrigger))
        local Entry = UE.EventSystems.EventTrigger.Entry()
        Entry.eventID = UE.EventSystems.EventTriggerType.PointerUp;
        Entry.callback:AddListener(function (eventData) AudioMgr:BGMVolumeChengeTo(self.BGMVolumeSlider.value)  end);
        trigger_1.triggers:Add(Entry)

        local trigger_2 = self.EffectVolumeSlider.gameObject:AddComponent(typeof(UE.EventSystems.EventTrigger))
        local Entry = UE.EventSystems.EventTrigger.Entry()
        Entry.eventID = UE.EventSystems.EventTriggerType.PointerUp;
        Entry.callback:AddListener(function (eventData) AudioMgr:BGMVolumeChengeTo(self.EffectVolumeSlider.value)  end);
        trigger_2.triggers:Add(Entry)
        ----------设置btn---------------
        self.gameobject.transform:Find("Setting_Btn"):GetComponent(typeof(UE.UI.Button)).onClick:AddListener(function()
            if self.settingPnlObj.activeSelf then
                self.settingPnlObj:SetActive(false)
            else
                self.settingPnlObj:SetActive(true)
            end
        end)
    end
end



return SettingDlg