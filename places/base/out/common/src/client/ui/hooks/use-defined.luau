-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useLatest = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useLatest
local function isEqualOrUndefined(previousValue, value)
	return previousValue == value or value == nil
end
--[[
	*
	 * Returns the latest defined value.
	 *
	 * @param value - The value to use.
	 * @param initialValue - The initial value to use if `value` is `undefined`.
	 * @returns A non-nullable value.
	 
]]
local function useDefined(value, initialValue)
	local _condition = useLatest(value, isEqualOrUndefined).current
	if _condition == nil then
		_condition = initialValue
	end
	return _condition
end
return {
	useDefined = useDefined,
}
