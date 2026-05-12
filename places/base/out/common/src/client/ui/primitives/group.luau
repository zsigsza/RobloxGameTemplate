-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local React = _react
local forwardRef = _react.forwardRef
--[[
	*
	 * Group.
	 *
	 * @example
	 *
	 * ```tsx
	 * <Group>
	 * 	<Button/>
	 * 	<Button/>
	 * 	<Button/>
	 * </Group>
	 * ```
	 *
	 * @param {GroupProps} - The properties of the Group component.
	 * @returns The rendered Group component.
	 * @component
	 *
	 
]]
local Group = forwardRef(function(props, ref)
	return React.createElement("frame", {
		Size = props.size or UDim2.fromScale(1, 1),
		ClipsDescendants = props.clipsDescendants,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		Position = props.position,
		Rotation = props.rotation,
		Visible = props.visible,
		ZIndex = props.zIndex,
		Change = props.change,
		Event = props.event,
		ref = ref,
	}, props.children)
end)
local default = Group
return {
	default = default,
}
