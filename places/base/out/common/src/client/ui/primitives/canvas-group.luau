-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local React = _react
local forwardRef = _react.forwardRef
local Corner = TS.import(script, script.Parent, "corner").Corner
--[[
	*
	 * A wrapper around the `CanvasGroup` component, a GuiObject that renders
	 * descendants as a group with color and transparency applied to the render
	 * result.
	 *
	 * @example
	 *
	 * ```tsx
	 * <CanvasGroup native={{ Size: new UDim2(0, 100, 0, 100) }}>
	 * ```
	 *
	 * @component
	 *
	 * @see https://developer.roblox.com/en-us/api-reference/class/CanvasGroup
	 
]]
local CanvasGroup = forwardRef(function(_param, ref)
	local Visible = _param.Visible
	if Visible == nil then
		Visible = true
	end
	local CornerRadius = _param.CornerRadius
	local children = _param.children
	return React.createElement("canvasgroup", {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = Visible,
		ref = ref,
	}, if CornerRadius ~= 0 and CornerRadius == CornerRadius and CornerRadius then React.createElement(Corner, {
		radius = CornerRadius,
	}) else nil, children)
end)
local default = CanvasGroup
return {
	default = default,
}
