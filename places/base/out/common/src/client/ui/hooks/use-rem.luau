-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _rem_provider = TS.import(script, script.Parent.Parent, "provider", "rem-provider")
local DEFAULT_REM = _rem_provider.DEFAULT_REM
local RemContext = _rem_provider.RemContext
--[[
	*
	 * https://github.com/littensy/slither/blob/main/src/client/hooks/use-rem.ts
	 
]]
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useCallback = _react.useCallback
local useContext = _react.useContext
local scaleFunctions = {
	UDim2 = function(value, rem)
		return UDim2.new(value.X.Scale, value.X.Offset * rem, value.Y.Scale, value.Y.Offset * rem)
	end,
	Vector2 = function(value, rem)
		return Vector2.new(value.X * rem, value.Y * rem)
	end,
	UDim = function(value, rem)
		return UDim.new(value.Scale, value.Offset * rem)
	end,
	number = function(value, rem)
		return value * rem
	end,
}
local function useRemContext(_param)
	if _param == nil then
		_param = {}
	end
	local maximum = _param.maximum
	if maximum == nil then
		maximum = math.huge
	end
	local minimum = _param.minimum
	if minimum == nil then
		minimum = 0
	end
	local rem = useContext(RemContext)
	return math.clamp(rem, minimum, maximum)
end
local function useRem(options)
	local rem = useRemContext(options)
	local remFunction = function(value, mode)
		if mode == nil then
			mode = "unit"
		end
		local _exp = scaleFunctions
		local _value = value
		local scale = _exp[typeof(_value)]
		if scale then
			return if mode == "unit" then scale(value, rem) else scale(value, rem / DEFAULT_REM)
		else
			return value
		end
	end
	return useCallback(remFunction, { rem })
end
return {
	useRem = useRem,
}
