-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Lifecycle = TS.import(script, game:GetService("ReplicatedStorage"), "common", "modding", "lifecycle").Lifecycle
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "common", "remotes").default
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local ClickHookService
do
	ClickHookService = setmetatable({}, {
		__tostring = function()
			return "ClickHookService"
		end,
	})
	ClickHookService.__index = ClickHookService
	function ClickHookService.new(...)
		local self = setmetatable({}, ClickHookService)
		return self:constructor(...) or self
	end
	function ClickHookService:constructor()
		self.clickListener = Lifecycle.new("common/src/server/hooks/init@OnPlayerClick")
	end
	function ClickHookService:onStart()
		self.clickListener:register()
		remotes.Server:OnEvent("Click", function(p)
			return self.clickListener:emit(function(l)
				return l:onPlayerClick(p)
			end)
		end)
	end
	do
		-- (Flamework) ClickHookService metadata
		Reflect.defineMetadata(ClickHookService, "identifier", "common/src/server/hooks/click@ClickHookService")
		Reflect.defineMetadata(ClickHookService, "flamework:implements", { "$:flamework@OnStart" })
	end
end
-- (Flamework) ClickHookService decorators
Reflect.decorate(ClickHookService, "$:flamework@Service", Service, { {} })
return {
	ClickHookService = ClickHookService,
}
