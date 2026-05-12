-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local React = _react
local forwardRef = _react.forwardRef
--[[
	*
	 * A component for displaying an image.
	 *
	 * @example
	 *
	 * ```tsx
	 * <ImageLabel
	 * 	Image="rbxassetid://1234567890"
	 * 	native={{
	 * 		Size={new UDim2(0, 100, 0, 100)}
	 * 	}}
	 * />;
	 * ```
	 *
	 * @component
	 *
	 * @see https://developer.roblox.com/en-us/api-reference/class/ImageLabel
	 
]]
local Image = forwardRef(function(props, ref)
	local _attributes = {
		BackgroundTransparency = 1,
		ResampleMode = "Pixelated",
		Image = props.Image,
		BorderSizePixel = 0,
		ScaleType = "Fit",
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	return React.createElement("imagelabel", _attributes, props.children)
end)
local default = Image
return {
	default = default,
}
