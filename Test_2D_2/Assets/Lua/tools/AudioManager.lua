--[[
    管理所有audio
--]]
local MC = require("MessageCenter")


local AudioManager = {}

function AudioManager:Init()
    self.backgroundMusicSource = Main.gameObject:AddComponent(typeof(UE.AudioSource))
    self.backgroundMusicSource.playOnAwake = false
    self.effectMusicSource = Main.gameObject:AddComponent(typeof(UE.AudioSource))
    self.effectMusicSource.playOnAwake = false
    self.currentBGM = nil
    self.currentEffectMusic = nil
    self.BGMVolume = 1
    self.EffectMusicVolume = 1
    self.EffectSources={ self.effectMusicSource }
    self.backgroundMusicSources={self.backgroundMusicSource}
end

--- 统一加载常用(或当前场景)audio
function AudioManager:LoadAll()

end

--[[
    为了1.函数更小 2.方便拓展
    因此就不将背景和音效的播放合起来了
--]]
function AudioManager:PlayBackgroundMusic(audioClip, delay, isLoop)
    self:PlayAudio(self.backgroundMusicSource, audioClip, delay, isLoop)
end

function AudioManager:ReplayBGM()
    if not self.backgroundMusic then
        return
    end
    if self.currentBGM then
        self.backgroundMusic:Play()
    end
end

function AudioManager:PlayEffectMusic(audioClip, delay, isLoop)
    self:PlayAudio(self.effectMusicSource, audioClip, delay, isLoop)
end

function AudioManager:EffectMusicVolumeChengeTo(value)
    if value < 0 or value > 1 then
        return
    end
    self.EffectMusicVolume = value
    self.effectMusicSource.volume = value
    MC:SendMessage(Enum_NormalMessageType.ChengeEffectMusicVolume, require("KeyValue"):new(nil, value))
end

function AudioManager:BGMVolumeChengeTo(value)
    if value < 0 or value > 1 then
        return
    end
    self.BGMVolume = value
    self.backgroundMusicSource.volume = value
    MC:SendMessage(Enum_NormalMessageType.ChangeBGMVolume, require("KeyValue"):new(nil, value))
end

function AudioManager:PlayAudio(source, audioClip, delay, isLoop)
    if not source then
        return
    end
    if audioClip then
        if audioClip == source.clip then
            if source.isPlaying then

            end
        else
            source.clip = audioClip
        end
    else
        if not source.clip then
            return
        end
    end
    if isLoop then
        source.loop = true
    else
        source.loop = false
    end
    if delay then
        source:PlayDelayed(delay)
    else
        source:Play()
    end
end

function AudioManager:StopBGM()
    if self.backgroundMusicSource then
        self.backgroundMusicSource:Stop()
    end
end

AudioManager:Init()

return AudioManager