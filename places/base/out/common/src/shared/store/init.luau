-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local playerSlice = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store", "player").playerSlice
local sharedSlices = {
	player = playerSlice,
}
return {
	sharedSlices = sharedSlices,
}
