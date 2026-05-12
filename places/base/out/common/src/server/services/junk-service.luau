-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local Trove = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "trove", "out").Trove
local JunkService
do
	JunkService = setmetatable({}, {
		__tostring = function()
			return "JunkService"
		end,
	})
	JunkService.__index = JunkService
	function JunkService.new(...)
		local self = setmetatable({}, JunkService)
		return self:constructor(...) or self
	end
	function JunkService:constructor()
		self.troveObjects = {}
	end
	function JunkService:onPlayerJoin(player)
		local _troveObjects = self.troveObjects
		local _userId = player.UserId
		local _trove = Trove.new()
		_troveObjects[_userId] = _trove
	end
	function JunkService:onPlayerLeave(player)
		local _troveObjects = self.troveObjects
		local _userId = player.UserId
		local _result = _troveObjects[_userId]
		if _result ~= nil then
			_result:clean()
		end
		local _troveObjects_1 = self.troveObjects
		local _userId_1 = player.UserId
		_troveObjects_1[_userId_1] = nil
	end
	function JunkService:addJunk(player, junk)
		local _troveObjects = self.troveObjects
		local _userId = player.UserId
		local _result = _troveObjects[_userId]
		if _result ~= nil then
			_result:add(junk)
		end
	end
	function JunkService:clean(player)
		local _troveObjects = self.troveObjects
		local _userId = player.UserId
		local _result = _troveObjects[_userId]
		if _result ~= nil then
			_result:clean()
		end
	end
	do
		-- (Flamework) JunkService metadata
		Reflect.defineMetadata(JunkService, "identifier", "common/src/server/services/junk-service@JunkService")
		Reflect.defineMetadata(JunkService, "flamework:implements", { "common/src/server/hooks/init@OnPlayerLeave", "common/src/server/hooks/init@OnPlayerJoin" })
	end
end
-- (Flamework) JunkService decorators
Reflect.decorate(JunkService, "$:flamework@Service", Service, {})
return {
	JunkService = JunkService,
}
