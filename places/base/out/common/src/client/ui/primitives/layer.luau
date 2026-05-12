-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local UltraWideContainer = TS.import(script, script.Parent.Parent, "utils", "ultra-wide-container").default
local IS_EDIT = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "game").IS_EDIT
local Group = TS.import(script, script.Parent, "group").default
local React = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
--[[
	*
	 * Renders a collection of components under a screengui.
	 *
	 * If the game is running, the components are rendered under a `screengui`
	 * object, otherwise they are rendered under a `Group` object while in edit mode
	 * for storybook support.
	 *
	 * @example
	 *
	 * ```tsx
	 * <Layer displayOrder={1}>
	 * 	<TextButton Text="Button 1" />
	 * 	<TextButton Text="Button 2" />
	 * </Layer>;
	 * ```
	 *
	 * @param props - The component props.
	 * @returns The rendered Layer component.
	 * @note By default, the `clampUltraWide` property is set to `true`. This means
	 * that the layer will be constrained to a 16:9 aspect ratio on ultra wide
	 * monitors. If you want to disable this behavior, set `LayerProps#clampUltraWide` to `false`.
	 *
	 * @component
	 *
	 * @see https://developer.roblox.com/en-us/api-reference/class/ScreenGui
	 
]]
local function Layer(_param)
	local clampUltraWide = _param.clampUltraWide
	if clampUltraWide == nil then
		clampUltraWide = false
	end
	local ignoreGuiInset = _param.ignoreGuiInset
	if ignoreGuiInset == nil then
		ignoreGuiInset = true
	end
	local displayOrder = _param.displayOrder
	local children = _param.children
	local visible = _param.visible
	return if IS_EDIT then (React.createElement(Group, {
		visible = visible,
	}, if clampUltraWide then React.createElement(UltraWideContainer, nil, children) else children)) else (React.createElement("screengui", {
		IgnoreGuiInset = ignoreGuiInset,
		DisplayOrder = displayOrder,
		ZIndexBehavior = "Sibling",
		ResetOnSpawn = false,
		Enabled = visible,
	}, if clampUltraWide then React.createElement(UltraWideContainer, nil, children) else children))
end
return {
	default = Layer,
}
