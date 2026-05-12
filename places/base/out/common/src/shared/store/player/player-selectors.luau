-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createSelector = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createSelector
local selectPlayerStats = function(playerName)
	return function(state)
		return state.player.stats[playerName]
	end
end
local selectPlayerPurchases = function(playerName)
	return function(state)
		return state.player.purchases[playerName]
	end
end
local selectPlayerData = function(playerName)
	return createSelector(selectPlayerPurchases(playerName), selectPlayerStats(playerName), function(purchases, stats)
		if not stats or not purchases then
			return nil
		end
		return {
			purchases = purchases,
			stats = stats,
		}
	end)
end
return {
	selectPlayerStats = selectPlayerStats,
	selectPlayerPurchases = selectPlayerPurchases,
	selectPlayerData = selectPlayerData,
}
