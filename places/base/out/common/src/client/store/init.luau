-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local receiverMiddleware = TS.import(script, script, "middleware", "receiver").receiverMiddleware
local combineProducers = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").combineProducers
local sharedSlices = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store").sharedSlices
local function createStore()
	local _object = table.clone(sharedSlices)
	setmetatable(_object, nil)
	local store = combineProducers(_object)
	store:applyMiddleware(receiverMiddleware())
	return store
end
local store = createStore()
return {
	createStore = createStore,
	store = store,
}
