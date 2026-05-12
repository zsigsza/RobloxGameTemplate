-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
--[[
	*
	 * https://github.com/littensy/slither/blob/main/src/client/providers/rem-provider.tsx
	 
]]
local _pretty_react_hooks = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useDebounceState = _pretty_react_hooks.useDebounceState
local useEventListener = _pretty_react_hooks.useEventListener
local useCamera = _pretty_react_hooks.useCamera
local map = _pretty_react_hooks.map
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local React = _react
local createContext = _react.createContext
local useEffect = _react.useEffect
local DEFAULT_REM = 16
local MIN_REM = 8
local BASE_RESOLUTION = Vector2.new(1920, 1020)
local MAX_ASPECT_RATIO = 19 / 9
local RemContext = createContext(DEFAULT_REM)
local function RemProvider(_param)
	local maximumRem = _param.maximumRem
	if maximumRem == nil then
		maximumRem = math.huge
	end
	local baseRem = _param.baseRem
	if baseRem == nil then
		baseRem = DEFAULT_REM
	end
	local minimumRem = _param.minimumRem
	if minimumRem == nil then
		minimumRem = MIN_REM
	end
	local remOverride = _param.remOverride
	local children = _param.children
	local camera = useCamera()
	local rem, setRem = useDebounceState(baseRem, {
		leading = true,
		wait = 0.2,
	})
	local update = function()
		local viewport = camera.ViewportSize
		if remOverride ~= nil then
			return remOverride
		end
		-- wide screens should not scale beyond iPhone aspect ratio
		local resolution = Vector2.new(math.min(viewport.X, viewport.Y * MAX_ASPECT_RATIO), viewport.Y)
		local scale = resolution.Magnitude / BASE_RESOLUTION.Magnitude
		local desktop = resolution.X > resolution.Y or scale >= 1
		-- portrait mode should downscale slower than landscape
		local factor = if desktop then scale else map(scale, 0, 1, 0.25, 1)
		setRem(math.clamp(math.round(baseRem * factor), minimumRem, maximumRem))
	end
	useEventListener(camera:GetPropertyChangedSignal("ViewportSize"), update)
	useEffect(function()
		update()
	end, { baseRem, minimumRem, maximumRem, remOverride })
	return React.createElement(RemContext.Provider, {
		value = rem,
	}, children)
end
return {
	RemProvider = RemProvider,
	DEFAULT_REM = DEFAULT_REM,
	MIN_REM = MIN_REM,
	RemContext = RemContext,
}
