-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local LocalPlayer = TS.import(script, script.Parent.Parent, "constants", "local-player").LocalPlayer
local Lifecycle = TS.import(script, game:GetService("ReplicatedStorage"), "common", "modding", "lifecycle").Lifecycle
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local LocalCharacterHookController
do
	LocalCharacterHookController = setmetatable({}, {
		__tostring = function()
			return "LocalCharacterHookController"
		end,
	})
	LocalCharacterHookController.__index = LocalCharacterHookController
	function LocalCharacterHookController.new(...)
		local self = setmetatable({}, LocalCharacterHookController)
		return self:constructor(...) or self
	end
	function LocalCharacterHookController:constructor()
		self.characterAdded = Lifecycle.new("common/src/client/hooks/init@OnLocalCharacterAdded")
		self.characterRemoving = Lifecycle.new("common/src/client/hooks/init@OnLocalCharacterRemoving")
	end
	function LocalCharacterHookController:onStart()
		self.characterAdded:register()
		self.characterRemoving:register()
		self.characterAdded:connect(LocalPlayer.CharacterAdded, function(l, m)
			return l:onLocalCharacterAdded(m)
		end)
		self.characterRemoving:connect(LocalPlayer.CharacterRemoving, function(l, m)
			return l:onLocalCharacterRemoving(m)
		end)
		task.spawn(function()
			local character = LocalPlayer.Character
			if not character then
				return nil
			end
			self.characterAdded:emit(function(l)
				return l:onLocalCharacterAdded(character)
			end)
		end)
	end
	do
		-- (Flamework) LocalCharacterHookController metadata
		Reflect.defineMetadata(LocalCharacterHookController, "identifier", "common/src/client/hooks/local-character@LocalCharacterHookController")
		Reflect.defineMetadata(LocalCharacterHookController, "flamework:implements", { "$:flamework@OnStart" })
	end
end
-- (Flamework) LocalCharacterHookController decorators
Reflect.decorate(LocalCharacterHookController, "$:flamework@Controller", Controller, { {} })
return {
	LocalCharacterHookController = LocalCharacterHookController,
}
