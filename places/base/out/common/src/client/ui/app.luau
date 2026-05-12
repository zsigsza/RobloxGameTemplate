-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local selectPlayerClicks = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store", "player", "stat").selectPlayerClicks
local LocalPlayer = TS.import(script, script.Parent.Parent, "constants", "local-player").LocalPlayer
local useRem = TS.import(script, script.Parent, "hooks", "use-rem").useRem
local Layer = TS.import(script, script.Parent, "primitives", "layer").default
local useSelector = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-reflex").useSelector
local React = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local function App()
	local rem = useRem()
	local count = useSelector(selectPlayerClicks(LocalPlayer.Name))
	return React.createElement(React.Fragment, nil, React.createElement(Layer, {
		clampUltraWide = true,
	}, React.createElement("frame", {
		Size = UDim2.fromOffset(rem(0.5), rem(0.5)),
		Position = UDim2.fromScale(0.5, 0.5),
	})))
end
return {
	default = App,
}
