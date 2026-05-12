-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Modding = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Modding
--* @metadata macro 
local Lifecycle
do
	Lifecycle = setmetatable({}, {
		__tostring = function()
			return "Lifecycle"
		end,
	})
	Lifecycle.__index = Lifecycle
	function Lifecycle.new(...)
		local self = setmetatable({}, Lifecycle)
		return self:constructor(...) or self
	end
	function Lifecycle:constructor(id)
		self.id = id
		self.listeners = {}
		local _id = id
		assert(_id ~= "" and _id)
	end
	function Lifecycle:register()
		Modding.onListenerAdded((function(obj)
			return self:add(obj)
		end), self.id)
		Modding.onListenerRemoved((function(obj)
			return self:delete(obj)
		end), self.id)
	end
	function Lifecycle:add(obj)
		local _listeners = self.listeners
		local _obj = obj
		_listeners[_obj] = true
	end
	function Lifecycle:delete(obj)
		local _listeners = self.listeners
		local _obj = obj
		_listeners[_obj] = nil
	end
	function Lifecycle:emit(callback)
		for listener in self.listeners do
			task.spawn(function()
				return callback(listener)
			end)
		end
	end
	function Lifecycle:connect(signal, callback)
		return signal:Connect(function(...)
			local args = { ... }
			self:emit(function(l)
				return callback(l, unpack(args))
			end)
		end)
	end
end
return {
	Lifecycle = Lifecycle,
}
