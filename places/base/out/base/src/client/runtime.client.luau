-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local IS_STUDIO = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "game").IS_STUDIO
local Flamework = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local old = os.clock()
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "common", "controllers" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "common", "components" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "common", "hooks" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "common", "deps" } })
Flamework._addPaths({ { "ReplicatedStorage", "common", "components" } })
Flamework._addPaths({ { "ReplicatedStorage", "common", "deps" } })
Flamework._addPaths({ { "ReplicatedStorage", "TS", "deps" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "TS", "controllers" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "TS", "components" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "TS", "hooks" } })
Flamework._addPaths({ { "StarterPlayer", "StarterPlayerScripts", "TS", "deps" } })
Flamework.ignite()
if IS_STUDIO then
	print(`Initialized flamework client in {os.clock() - old}`)
end
