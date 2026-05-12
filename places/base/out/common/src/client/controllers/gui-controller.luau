-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local RootProvider = TS.import(script, script.Parent.Parent, "ui", "provider", "root-provider").RootProvider
local _react_roblox = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox")
local createPortal = _react_roblox.createPortal
local createRoot = _react_roblox.createRoot
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local React = _react
local StrictMode = _react.StrictMode
local store = TS.import(script, script.Parent.Parent, "store").store
local Players = game:GetService("Players")
local App = TS.import(script, script.Parent.Parent, "ui", "app").default
local GuiController
do
	GuiController = setmetatable({}, {
		__tostring = function()
			return "GuiController"
		end,
	})
	GuiController.__index = GuiController
	function GuiController.new(...)
		local self = setmetatable({}, GuiController)
		return self:constructor(...) or self
	end
	function GuiController:constructor()
	end
	function GuiController:onStart()
		local root = createRoot(Instance.new("Folder"))
		local target = Players.LocalPlayer:WaitForChild("PlayerGui")
		root:render(createPortal(React.createElement(StrictMode, nil, React.createElement(RootProvider, {
			store = store,
		}, React.createElement(App))), target))
	end
	do
		-- (Flamework) GuiController metadata
		Reflect.defineMetadata(GuiController, "identifier", "common/src/client/controllers/gui-controller@GuiController")
		Reflect.defineMetadata(GuiController, "flamework:implements", { "$:flamework@OnStart" })
	end
end
-- (Flamework) GuiController decorators
Reflect.decorate(GuiController, "$:flamework@Controller", Controller, { {} })
return {
	GuiController = GuiController,
}
