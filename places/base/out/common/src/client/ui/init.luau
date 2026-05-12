-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RootProvider = TS.import(script, script, "provider", "root-provider").RootProvider
local _react_roblox = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox")
local createPortal = _react_roblox.createPortal
local createRoot = _react_roblox.createRoot
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local React = _react
local StrictMode = _react.StrictMode
local store = TS.import(script, script.Parent, "store").store
local Players = game:GetService("Players")
local App = TS.import(script, script, "app").default
local function mountMainUi()
	local root = createRoot(Instance.new("Folder"))
	local target = Players.LocalPlayer:WaitForChild("PlayerGui")
	root:render(createPortal(React.createElement(StrictMode, nil, React.createElement(RootProvider, {
		store = store,
	}, React.createElement(App))), target))
end
return {
	mountMainUi = mountMainUi,
}
