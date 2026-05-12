-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
--[[
	*
	 * https://github.com/littensy/slither/blob/main/src/client/hooks/use-input-device.ts
	 
]]
local useEventListener = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useEventListener
local UserInputService = game:GetService("UserInputService")
local useState = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useState
local getInputType = function(inputType)
	if inputType == nil then
		inputType = UserInputService:GetLastInputType()
	end
	if inputType == Enum.UserInputType.Keyboard or inputType == Enum.UserInputType.MouseMovement then
		return "keyboard"
	elseif inputType == Enum.UserInputType.Gamepad1 then
		return "gamepad"
	elseif inputType == Enum.UserInputType.Touch then
		return "touch"
	end
end
--[[
	*
	 * Returns the current input device being used by the player.
	 * @returns An InputDevice string.
	 
]]
local function useInputDevice()
	local device, setDevice = useState(function()
		return getInputType() or "keyboard"
	end)
	useEventListener(UserInputService.LastInputTypeChanged, function(inputType)
		local newDevice = getInputType(inputType)
		if newDevice ~= nil then
			setDevice(newDevice)
		end
	end)
	return device
end
return {
	useInputDevice = useInputDevice,
	getInputType = getInputType,
}
