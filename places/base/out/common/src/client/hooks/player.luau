-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Lifecycle = TS.import(script, game:GetService("ReplicatedStorage"), "common", "modding", "lifecycle").Lifecycle
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Players = game:GetService("Players")
local PlayerHookController
do
	PlayerHookController = setmetatable({}, {
		__tostring = function()
			return "PlayerHookController"
		end,
	})
	PlayerHookController.__index = PlayerHookController
	function PlayerHookController.new(...)
		local self = setmetatable({}, PlayerHookController)
		return self:constructor(...) or self
	end
	function PlayerHookController:constructor()
		self.joinListener = Lifecycle.new("common/src/client/hooks/init@OnPlayerJoin")
		self.leaveListener = Lifecycle.new("common/src/client/hooks/init@OnPlayerLeave")
	end
	function PlayerHookController:onStart()
		self.joinListener:register()
		self.leaveListener:register()
		self.joinListener:connect(Players.PlayerAdded, function(l, p)
			return l:onPlayerJoin(p)
		end)
		self.leaveListener:connect(Players.PlayerRemoving, function(l, p)
			return l:onPlayerLeave(p)
		end)
		for _, player in Players:GetPlayers() do
			self.joinListener:emit(function(l)
				return l:onPlayerJoin(player)
			end)
		end
	end
	do
		-- (Flamework) PlayerHookController metadata
		Reflect.defineMetadata(PlayerHookController, "identifier", "common/src/client/hooks/player@PlayerHookController")
		Reflect.defineMetadata(PlayerHookController, "flamework:implements", { "$:flamework@OnStart" })
	end
end
-- (Flamework) PlayerHookController decorators
Reflect.decorate(PlayerHookController, "$:flamework@Controller", Controller, { {} })
return {
	PlayerHookController = PlayerHookController,
}
