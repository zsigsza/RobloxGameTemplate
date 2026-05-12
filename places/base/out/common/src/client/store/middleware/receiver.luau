-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createBroadcastReceiver = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").createBroadcastReceiver
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "common", "remotes").default
local IS_EDIT = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "game").IS_EDIT
local function receiverMiddleware()
	if IS_EDIT then
		return function()
			return function(dispatch)
				return dispatch
			end
		end
	end
	local receiver = createBroadcastReceiver({
		start = function()
			remotes.Client:GetNamespace("store"):Get("Start"):SendToServer()
		end,
	})
	remotes.Client:GetNamespace("store"):Get("Dispatch"):Connect(function(actions)
		receiver:dispatch(actions)
	end)
	return receiver.middleware
end
return {
	receiverMiddleware = receiverMiddleware,
}
