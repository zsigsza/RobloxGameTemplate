-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RECENT_PURCHASES_LIMIT = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "flags").RECENT_PURCHASES_LIMIT
local createProducer = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createProducer
local Sift = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "sift", "out")
local initialState = {}
local purchasesSlice = createProducer(initialState, {
	limitRecentPurchases = function(state, player)
		local purchases = state[player]
		local _object = table.clone(state)
		setmetatable(_object, nil)
		local _left = player
		local _condition = purchases
		if _condition then
			local _object_1 = table.clone(purchases)
			setmetatable(_object_1, nil)
			_object_1.recentPurchases = Sift.Array.shift(purchases.recentPurchases, #purchases.recentPurchases - RECENT_PURCHASES_LIMIT)
			_condition = _object_1
		end
		_object[_left] = _condition
		return _object
	end,
	addRecentPurchase = function(state, player, recentPurchase)
		local purchases = state[player]
		local _object = table.clone(state)
		setmetatable(_object, nil)
		local _left = player
		local _condition = purchases
		if _condition then
			local _object_1 = table.clone(purchases)
			setmetatable(_object_1, nil)
			local _left_1 = "recentPurchases"
			local _array = {}
			local _length = #_array
			local _array_1 = purchases.recentPurchases
			local _Length = #_array_1
			table.move(_array_1, 1, _Length, _length + 1, _array)
			_length += _Length
			_array[_length + 1] = recentPurchase
			_object_1[_left_1] = _array
			_condition = _object_1
		end
		_object[_left] = _condition
		return _object
	end,
	loadPlayerData = function(state, player, data)
		local _object = table.clone(state)
		setmetatable(_object, nil)
		_object[player] = data.purchases
		return _object
	end,
	closePlayerData = function(state, player)
		local _object = table.clone(state)
		setmetatable(_object, nil)
		_object[player] = nil
		return _object
	end,
})
local selectPlayerRecentPurchases = function(playerName)
	return function(state)
		local _result = state.player.purchases[playerName]
		if _result ~= nil then
			_result = _result.recentPurchases
		end
		local _condition = _result
		if _condition == nil then
			_condition = {}
		end
		return _condition
	end
end
return {
	purchasesSlice = purchasesSlice,
	selectPlayerRecentPurchases = selectPlayerRecentPurchases,
}
