-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RootProvider = TS.import(script, script.Parent.Parent.Parent, "provider", "root-provider").RootProvider
local CreateReactStory = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "ui-labs", "src").CreateReactStory
local ReactRoblox = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox")
local store = TS.import(script, script.Parent.Parent.Parent.Parent, "store").store
local React = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
return CreateReactStory({
	reactRoblox = ReactRoblox,
	react = React,
}, function()
	return React.createElement(RootProvider, {
		store = store,
	}, React.createElement("textbutton", {
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromScale(0.2, 0.05),
		Text = "Label",
	}))
end)
