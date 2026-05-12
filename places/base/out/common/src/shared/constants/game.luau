-- Compiled with roblox-ts v3.0.0
local RunService = game:GetService("RunService")
local GAME_NAME = "TESTING PLACE"
local IS_EDIT = RunService:IsStudio() and not RunService:IsRunning()
local IS_SERVER = RunService:IsServer()
local IS_STUDIO = RunService:IsStudio()
local HRP = "HumanoidRootPart"
return {
	GAME_NAME = GAME_NAME,
	IS_EDIT = IS_EDIT,
	IS_SERVER = IS_SERVER,
	IS_STUDIO = IS_STUDIO,
	HRP = HRP,
}
