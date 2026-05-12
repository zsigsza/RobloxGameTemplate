-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Lifecycle = TS.import(script, game:GetService("ReplicatedStorage"), "common", "modding", "lifecycle").Lifecycle
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local Players = game:GetService("Players")
local PlayerHookService
do
	PlayerHookService = setmetatable({}, {
		__tostring = function()
			return "PlayerHookService"
		end,
	})
	PlayerHookService.__index = PlayerHookService
	function PlayerHookService.new(...)
		local self = setmetatable({}, PlayerHookService)
		return self:constructor(...) or self
	end
	function PlayerHookService:constructor()
		self.joinListener = Lifecycle.new("common/src/server/hooks/init@OnPlayerJoin")
		self.leaveListener = Lifecycle.new("common/src/server/hooks/init@OnPlayerLeave")
	end
	function PlayerHookService:onStart()
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
		-- (Flamework) PlayerHookService metadata
		Reflect.defineMetadata(PlayerHookService, "identifier", "common/src/server/hooks/player@PlayerHookService")
		Reflect.defineMetadata(PlayerHookService, "flamework:implements", { "$:flamework@OnStart" })
	end
end
-- (Flamework) PlayerHookService decorators
Reflect.decorate(PlayerHookService, "$:flamework@Service", Service, { {} })
return {
	PlayerHookService = PlayerHookService,
}
