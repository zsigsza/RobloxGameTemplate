-- Compiled with roblox-ts v3.0.0
local function getHumanoid(playerOrModel)
	local character
	if playerOrModel:IsA("Model") then
		character = playerOrModel
	else
		character = playerOrModel.Character or (playerOrModel.CharacterAdded:Wait())
	end
	if not character then
		return nil, nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return nil, nil
	end
	return humanoid, character
end
return {
	getHumanoid = getHumanoid,
}
