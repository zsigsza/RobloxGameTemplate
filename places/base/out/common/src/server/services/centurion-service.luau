-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local Centurion = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "centurion", "out").Centurion
local CenturionService
do
	CenturionService = setmetatable({}, {
		__tostring = function()
			return "CenturionService"
		end,
	})
	CenturionService.__index = CenturionService
	function CenturionService.new(...)
		local self = setmetatable({}, CenturionService)
		return self:constructor(...) or self
	end
	function CenturionService:constructor()
	end
	function CenturionService:onStart()
		local server = Centurion.server()
		-- Load all child ModuleScripts under each container
		local commandContainer = ServerScriptService.common.commands
		server.registry:load(commandContainer)
		local typeContainer = ReplicatedStorage.common.types
		server.registry:load(typeContainer)
		-- Any loaded commands and types will then be registered once Centurion is started
		server:start()
	end
	do
		-- (Flamework) CenturionService metadata
		Reflect.defineMetadata(CenturionService, "identifier", "common/src/server/services/centurion-service@CenturionService")
		Reflect.defineMetadata(CenturionService, "flamework:implements", { "$:flamework@OnStart" })
	end
end
-- (Flamework) CenturionService decorators
Reflect.decorate(CenturionService, "$:flamework@Service", Service, { {} })
return {
	CenturionService = CenturionService,
}
