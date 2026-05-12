-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local _testez = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "testez", "src")
local TestBootstrap = _testez.TestBootstrap
local Reporters = _testez.Reporters
if not RunService:IsRunning() then
	local results = TestBootstrap:run({ StarterPlayer:WaitForChild("StarterPlayerScripts"):WaitForChild("TS"):WaitForChild("__tests__"), StarterPlayer:WaitForChild("StarterPlayerScripts"):WaitForChild("common"):WaitForChild("__tests__"), ReplicatedStorage:WaitForChild("TS"):WaitForChild("__tests__"), ReplicatedStorage:WaitForChild("TS"):WaitForChild("__tests__") }, Reporters.TextReporter)
	if #results.errors > 0 or results.failureCount > 0 then
		error("Tests failed!")
	end
end
