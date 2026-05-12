-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local store = TS.import(script, game:GetService("ServerScriptService"), "common", "store").store
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local ClickService
do
	ClickService = setmetatable({}, {
		__tostring = function()
			return "ClickService"
		end,
	})
	ClickService.__index = ClickService
	function ClickService.new(...)
		local self = setmetatable({}, ClickService)
		return self:constructor(...) or self
	end
	function ClickService:constructor()
	end
	function ClickService:onPlayerClick(player)
		store.click(player.Name)
	end
	do
		-- (Flamework) ClickService metadata
		Reflect.defineMetadata(ClickService, "identifier", "common/src/server/services/click-service@ClickService")
		Reflect.defineMetadata(ClickService, "flamework:implements", { "common/src/server/hooks/init@OnPlayerClick" })
	end
end
-- (Flamework) ClickService decorators
Reflect.decorate(ClickService, "$:flamework@Service", Service, { {} })
return {
	ClickService = ClickService,
}
