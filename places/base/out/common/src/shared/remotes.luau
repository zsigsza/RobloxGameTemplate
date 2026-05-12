-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _net = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "net", "out")
local Net = _net
local Definitions = _net.Definitions
--[[
	*
	 * @uuid
	 
]]
local remotes = Net.CreateDefinitions({
	store = Definitions.Namespace({
		Dispatch = Definitions.ServerToClientEvent(),
		Start = Definitions.ClientToServerEvent(),
	}),
	Click = Definitions.ClientToServerEvent(),
})
local default = remotes
return {
	default = default,
}
