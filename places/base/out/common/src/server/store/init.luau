-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local broadcasterMiddleware = TS.import(script, game:GetService("ServerScriptService"), "common", "store", "middleware", "broadcaster").broadcasterMiddleware
local combineProducers = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").combineProducers
local sharedSlices = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store").sharedSlices
local function createStore()
	local _object = table.clone(sharedSlices)
	setmetatable(_object, nil)
	local store = combineProducers(_object)
	store:applyMiddleware(broadcasterMiddleware())
	return store
end
local store = createStore()
return {
	createStore = createStore,
	store = store,
}
