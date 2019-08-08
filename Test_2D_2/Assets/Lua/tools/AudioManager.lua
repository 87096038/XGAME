--[[
    管理所有audio
--]]

local AudioManager = {}

function AudioManager:Init()
    self.backgroundMusicSource = Main.gameObject:AddComponent(typeof(UE.AudioSource))
    self.effectMusicSource = Main.gameObject:AddComponent(typeof(UE.AudioSource))
    self.currentBGM = nil
    self.currentEffectMusic = nil
    self.BGMVolume = 100
    self.EffectMusicVolume = 100
end

--- 统一加载常用(或当前场景)audio
function AudioManager:LoadAll()

end

--[[
    为了1.函数更小 2.方便拓展
    因此就不将背景和音效的播放合起来了
--]]
function AudioManager:PlayBackgroundMusic(audioClip, delay)
    if not self.backgroundMusicSource then
        return
    end
    if audioClip then
        if audioClip == self.currentBGM then
            if self.currentBGM.isPlaying then
                return
            end
        else
            self.backgroundMusicSource.clip = audioClip
        end
    else
        if not self.currentBGM then
            return
        end
    end
    if delay then
        self.backgroundMusicSource:PlayDelayed(delay)
    else
        self.backgroundMusicSource:Play()
    end
end

function AudioManager:ReplayBGM()
    if not self.backgroundMusic then
        return
    end
    if self.currentBGM then
        self.backgroundMusic:Play()
    end
end

function AudioManager:PlayEffectMusic(audioClip, delay)
    if not self.effectMusicSource then
        return
    end
    if audioClip then
        if audioClip == self.currentEffectMusic then
            if self.currentEffectMusic.isPlaying then
                return
            end
        else
            self.effectMusicSource.clip = audioClip
        end
    else
        if not self.currentEffectMusic then
            return
        end
    end
    if delay then
        self.effectMusicSource:PlayDelayed(delay)
    else
        self.effectMusicSource:Play()
    end
end

AudioManager:Init()

return AudioManager