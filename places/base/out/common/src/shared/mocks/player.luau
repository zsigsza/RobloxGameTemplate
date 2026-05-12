-- Compiled with roblox-ts v3.0.0
local UserInputService = game:GetService("UserInputService")
--* A fake player used for testing 
local function MockPlayer(userId)
	if userId == nil then
		userId = -1
	end
	return {
		GetMouse = function(self)
			local mouseLocation = UserInputService:GetMouseLocation()
			return {
				X = mouseLocation.X,
				Y = mouseLocation.Y,
			}
		end,
		Character = {
			Humanoid = {
				MaxHealth = 100,
				Health = 50,
			},
		},
		DisplayName = "Test Player",
		ClassName = "Player",
		Name = "testPlayer",
		UserId = userId,
	}
end
return {
	MockPlayer = MockPlayer,
}
