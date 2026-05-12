-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createProducer = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local initialState = {}
local statsSlice = createProducer(initialState, {
	addClick = function(state, player, amount)
		local stats = state[player]
		local _object = table.clone(state)
		setmetatable(_object, nil)
		local _left = player
		local _condition = stats
		if _condition then
			local _object_1 = table.clone(stats)
			setmetatable(_object_1, nil)
			_object_1.clicks = stats.clicks + amount
			_condition = _object_1
		end
		_object[_left] = _condition
		return _object
	end,
	click = function(state, player)
		local stats = state[player]
		local _object = table.clone(state)
		setmetatable(_object, nil)
		local _left = player
		local _condition = stats
		if _condition then
			local _object_1 = table.clone(stats)
			setmetatable(_object_1, nil)
			_object_1.clicks = stats.clicks + 1
			_condition = _object_1
		end
		_object[_left] = _condition
		return _object
	end,
	loadPlayerData = function(state, player, data)
		local _object = table.clone(state)
		setmetatable(_object, nil)
		_object[player] = data.stats
		return _object
	end,
	closePlayerData = function(state, player)
		local _object = table.clone(state)
		setmetatable(_object, nil)
		_object[player] = nil
		return _object
	end,
})
local selectPlayerClicks = function(playerName)
	return function(state)
		local _result = state.player.stats[playerName]
		if _result ~= nil then
			_result = _result.clicks
		end
		local _condition = _result
		if _condition == nil then
			_condition = 0
		end
		return _condition
	end
end
return {
	statsSlice = statsSlice,
	selectPlayerClicks = selectPlayerClicks,
}
