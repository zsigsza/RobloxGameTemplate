-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local LocalPlayer = TS.import(script, script.Parent.Parent, "constants", "local-player").LocalPlayer
local getHumanoid = TS.import(script, game:GetService("ReplicatedStorage"), "common", "utils", "player").getHumanoid
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local HRP = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "game").HRP
local CharacterController
do
	CharacterController = setmetatable({}, {
		__tostring = function()
			return "CharacterController"
		end,
	})
	CharacterController.__index = CharacterController
	function CharacterController.new(...)
		local self = setmetatable({}, CharacterController)
		return self:constructor(...) or self
	end
	function CharacterController:constructor()
	end
	function CharacterController:onStart()
		local humanoid, character = getHumanoid(LocalPlayer)
		self.humanoid = humanoid
		self.character = character
		local _result = character
		if _result ~= nil then
			_result = _result:WaitForChild(HRP)
		end
		self.rootPart = _result
		local _result_1 = character
		if _result_1 ~= nil then
			_result_1 = _result_1:WaitForChild("Head")
		end
		self.head = _result_1
		local _result_2 = self.rootPart
		if _result_2 ~= nil then
			_result_2 = _result_2:WaitForChild("RootJoint")
		end
		self.rootJoint = _result_2
	end
	function CharacterController:setAutoRotate(rotate)
		if self.humanoid then
			self.humanoid.AutoRotate = rotate
		end
	end
	function CharacterController:onLocalCharacterAdded(_character)
		self:onStart()
	end
	do
		-- (Flamework) CharacterController metadata
		Reflect.defineMetadata(CharacterController, "identifier", "common/src/client/controllers/character-controller@CharacterController")
		Reflect.defineMetadata(CharacterController, "flamework:implements", { "common/src/client/hooks/init@OnLocalCharacterAdded", "$:flamework@OnStart" })
	end
end
-- (Flamework) CharacterController decorators
Reflect.decorate(CharacterController, "$:flamework@Controller", Controller, { {} })
return {
	CharacterController = CharacterController,
}
