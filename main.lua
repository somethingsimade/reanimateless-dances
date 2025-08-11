--[[
  © 2025 MrY7zz. All rights reserved.
  This software is licensed under the MIT License. See the LICENSE file for full details.

  ─────────────────────────────────────────────────────────────────────────────
  LEGAL WARNING:
  This source code is protected under international copyright law.
  Unauthorized removal or modification of this header constitutes a violation 
  of the license agreement and may result in legal consequences.

  By using, copying, or distributing this software, you agree to retain this
  license header in its original, unaltered form. You are fully responsible
  for any misuse or breach of these terms.
  ─────────────────────────────────────────────────────────────────────────────
]]
--// By MrY7zz
--// REANIMATIONLESS DANCES
--// V1

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local twait = task.wait

local Players = game:GetService("Players")
local Plr = Players.LocalPlayer
if not Plr then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	Plr = Players.LocalPlayer
end

local Character = Plr.Character or Plr.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local Animator = Humanoid.Animator

local Animate = Character:FindFirstChild("Animate")
if Animate then
	Animate:Destroy()
end

for i, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
	v:Stop()
end

local currentAudio = nil
local function playAudio(id, looped)
	if currentAudio then currentAudio:Destroy() end
	local audio = Instance.new("Sound", game:GetService("Workspace"))
	audio.SoundId = "rbxassetid://" .. tostring(id)
	if looped == false then
		audio.Looped = false
	else
		audio.Looped = true
	end
	currentAudio = audio
	audio:Play()
	return audio
end

local function stopAudio()
	if currentAudio then
		currentAudio:Stop()
		currentAudio:Destroy()
		currentAudio = nil
	end
end

local currentTrack = nil
local on = false
local isidled = false
local walking = false

local function playanimationoverride(id)
	on = false
	isidled = true
	if currentTrack then
		currentTrack:Stop()
	end
	local Animation = Instance.new("Animation")
	Animation.AnimationId = "rbxassetid://" .. id
	local track = Animator:LoadAnimation(Animation)
	currentTrack = track
	track:Play()
end

local function playanimation(id, sound, looped)
	isidled = false
	if on == true then
		on = false
		currentTrack:Stop()
		currentTrack = nil
		playanimationoverride(92825042029363)
		stopAudio()
		return
	end
	on = true
	
	if currentTrack then
		currentTrack:Stop(0)
	end
	local Animation = Instance.new("Animation")
	Animation.AnimationId = "rbxassetid://" .. id
	local track = Animator:LoadAnimation(Animation)
	currentTrack = track
	track:Play()
	if not looped then
		playAudio(sound, looped)
	end
end

local mappingAnimations = {
	[Enum.KeyCode.E] = {ID = 120987339432938, Audio = 35930009}, --// later 127192795306509 (110068485026916 - curve anim )
	[Enum.KeyCode.F] = {ID = 137982048325793, Audio = 0},
	[Enum.KeyCode.G] = {ID = 82795681961462, Audio = 0},
	[Enum.KeyCode.H] = {ID = 91294374426630, Audio = 0},
	[Enum.KeyCode.N] = {ID = 126377740992659, Audio = 79348298352567, Looped = false},
	[Enum.KeyCode.Z] = {ID = 104682034891847, Audio = 79348298352567},
}

local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(handle, processed)
	if processed then return end
	local keycode = handle.KeyCode
	
	if mappingAnimations[keycode] then
		playanimation(mappingAnimations[keycode].ID, mappingAnimations[keycode].Audio, mappingAnimations[keycode].Looped)
	end
end)

Humanoid.Running:Connect(function(speed)
	if on then return end
	if speed > 0 then
		if not walking then
			walking = true
			if not on then
				playanimation(118883003052531)
			end
		end
	else
		if walking then
			walking = false
			playanimationoverride(92825042029363)
		end
	end
end)

playanimationoverride(92825042029363)
