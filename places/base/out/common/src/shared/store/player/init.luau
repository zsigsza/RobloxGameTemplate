-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local purchasesSlice = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store", "player", "purchases").purchasesSlice
local statsSlice = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store", "player", "stat").statsSlice
local combineProducers = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").combineProducers
local playerSlice = combineProducers({
	purchases = purchasesSlice,
	stats = statsSlice,
})
return {
	playerSlice = playerSlice,
}
