-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local React = _react
local createContext = _react.createContext
local ControllerContext = createContext(nil)
local function ControllerProvider(_param)
	local children = _param.children
	local camera = Flamework.resolveDependency("common/src/client/controllers/camera-controller@CameraController")
	return React.createElement(ControllerContext.Provider, {
		value = {
			camera = camera,
		},
	}, children)
end
return {
	ControllerProvider = ControllerProvider,
	ControllerContext = ControllerContext,
}
