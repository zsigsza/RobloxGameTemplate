-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local CenturionUI = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "centurion-ui", "out").CenturionUI
local Centurion = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "centurion", "out").Centurion
local CenturionController
do
	CenturionController = setmetatable({}, {
		__tostring = function()
			return "CenturionController"
		end,
	})
	CenturionController.__index = CenturionController
	function CenturionController.new(...)
		local self = setmetatable({}, CenturionController)
		return self:constructor(...) or self
	end
	function CenturionController:constructor()
	end
	function CenturionController:onStart()
		Centurion.client():start():andThen(function()
			return CenturionUI.start(Centurion.client(), {})
		end):catch(function(err)
			return warn("Failed to start Centurion:", err)
		end)
	end
	do
		-- (Flamework) CenturionController metadata
		Reflect.defineMetadata(CenturionController, "identifier", "common/src/client/controllers/centurion-controller@CenturionController")
		Reflect.defineMetadata(CenturionController, "flamework:implements", { "$:flamework@OnStart" })
	end
end
-- (Flamework) CenturionController decorators
Reflect.decorate(CenturionController, "$:flamework@Controller", Controller, { {} })
return {
	CenturionController = CenturionController,
}
