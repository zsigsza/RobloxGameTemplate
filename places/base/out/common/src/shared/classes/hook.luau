-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Trove = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "trove", "out").Trove
local Hook
do
	Hook = {}
	function Hook:constructor()
		self.trove = Trove.new()
		self.connected = false
		self.registered = false
		self.disconnect = function()
			self.trove:clean()
			self:disconnectHook()
			self.connected = false
		end
		self.connect = function()
			self:connectHook()
			self.connected = true
		end
		self.register = function()
			self:registerHook()
			self.registered = true
		end
	end
	function Hook:disconnectHook()
	end
end
return {
	Hook = Hook,
}
