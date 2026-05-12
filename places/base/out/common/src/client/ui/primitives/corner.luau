-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getBindingValue = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").getBindingValue
local useRem = TS.import(script, script.Parent.Parent, "hooks", "use-rem").useRem
local React = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
--[[
	*
	 * A React component that renders a UI corner with a customizable radius.
	 *
	 * @remarks
	 * This component is used to apply a corner radius to UI elements.
	 *
	 * @param props - The properties for the Corner component.
	 * @param props.Radius - The radius of the corner in pixels.
	 *
	 * @returns - A React element representing a UI corner with the specified radius.
	 *
	 * @example
	 * ```tsx
	 * <Corner Radius={10} />
	 * ```
	 
]]
local function Corner(_param)
	local radius = _param.radius
	local rem = useRem()
	return React.createElement("uicorner", {
		CornerRadius = UDim.new(0, rem(getBindingValue(radius), "pixel")),
	})
end
return {
	Corner = Corner,
}
