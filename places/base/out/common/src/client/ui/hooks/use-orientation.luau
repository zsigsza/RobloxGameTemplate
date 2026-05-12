-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useViewport = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useViewport
local useState = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useState
local function useOrientation()
	local setOrientation
	local viewportBinding = useViewport(function(viewport)
		setOrientation(if viewport.Y > viewport.X then "portrait" else "landscape")
	end)
	local _binding = { useState(viewportBinding:map(function(viewport)
		return if viewport.Y > viewport.X then "portrait" else "landscape"
	end):getValue()) }
	local orientation = _binding[1]
	setOrientation = _binding[2]
	return orientation
end
return {
	useOrientation = useOrientation,
}
