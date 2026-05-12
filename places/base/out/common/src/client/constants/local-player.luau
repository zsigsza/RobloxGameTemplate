-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local MockPlayer = TS.import(script, game:GetService("ReplicatedStorage"), "common", "mocks", "player").MockPlayer
local IS_EDIT = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "game").IS_EDIT
local Players = game:GetService("Players")
local LocalPlayer = if IS_EDIT then MockPlayer() else Players.LocalPlayer
return {
	LocalPlayer = LocalPlayer,
}
