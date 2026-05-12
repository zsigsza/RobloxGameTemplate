-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RemProvider = TS.import(script, script.Parent, "rem-provider").RemProvider
--[[
	*
	 * https://github.com/littensy/slither/blob/main/src/client/providers/root-provider.tsx
	 
]]
local ReflexProvider = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-reflex").ReflexProvider
local React = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local function RootProvider(_param)
	local remOverride = _param.remOverride
	local children = _param.children
	local baseRem = _param.baseRem
	local store = _param.store
	return React.createElement(ReflexProvider, {
		producer = store,
	}, React.createElement(RemProvider, {
		remOverride = remOverride,
		baseRem = baseRem,
	}, children))
end
return {
	RootProvider = RootProvider,
}
