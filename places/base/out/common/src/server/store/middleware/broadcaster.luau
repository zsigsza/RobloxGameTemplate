-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createBroadcaster = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createBroadcaster
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "common", "remotes").default
local IS_EDIT = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "game").IS_EDIT
local sharedSlices = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store").sharedSlices
local function broadcasterMiddleware()
	if IS_EDIT then
		return function()
			return function(dispatch)
				return dispatch
			end
		end
	end
	local broadcaster = createBroadcaster({
		dispatch = function(player, actions)
			remotes.Server:GetNamespace("store"):Get("Dispatch"):SendToPlayer(player, actions)
		end,
		producers = sharedSlices,
	})
	remotes.Server:GetNamespace("store"):Get("Start"):Connect(function(player)
		broadcaster:start(player)
	end)
	return broadcaster.middleware
end
return {
	broadcasterMiddleware = broadcasterMiddleware,
}
