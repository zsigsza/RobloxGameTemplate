-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local _flags = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "flags")
local RECENT_PURCHASES_LIMIT = _flags.RECENT_PURCHASES_LIMIT
local PLAYER_DATA_SAVING = _flags.PLAYER_DATA_SAVING
local selectPlayerRecentPurchases = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store", "player", "purchases").selectPlayerRecentPurchases
local defaultPlayerData = TS.import(script, game:GetService("ServerScriptService"), "common", "constants", "default-player-data").defaultPlayerData
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local selectPlayerData = TS.import(script, game:GetService("ReplicatedStorage"), "common", "store", "player", "player-selectors").selectPlayerData
local _core = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out")
local Flamework = _core.Flamework
local Service = _core.Service
local developerProducts = TS.import(script, game:GetService("ServerScriptService"), "common", "devproducts").developerProducts
local IS_STUDIO = TS.import(script, game:GetService("ReplicatedStorage"), "common", "constants", "game").IS_STUDIO
local DocumentStore = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "document-service", "out").DocumentStore
local store = TS.import(script, game:GetService("ServerScriptService"), "common", "store").store
local _binding = store
local closePlayerData = _binding.closePlayerData
local loadPlayerData = _binding.loadPlayerData
local PlayerSaveService
do
	PlayerSaveService = setmetatable({}, {
		__tostring = function()
			return "PlayerSaveService"
		end,
	})
	PlayerSaveService.__index = PlayerSaveService
	function PlayerSaveService.new(...)
		local self = setmetatable({}, PlayerSaveService)
		return self:constructor(...) or self
	end
	function PlayerSaveService:constructor(junkService)
		self.junkService = junkService
		self.documents = {}
		local saveError = self:canSave()
		if saveError == "DisabledSaveError" then
			warn("Player data saving is disabled!")
		elseif saveError == "NotPublishedSaveError" then
			warn("Place is not published, player data won't save.")
		elseif saveError == "InStudioSaveError" then
			warn("Player saving is disabled in studio.")
		end
		if saveError then
			return nil
		end
		self.store = DocumentStore.new({
			check = function(data)
				return Flamework.createGuard(t.interface({
					purchases = t.interface({
						recentPurchases = t.array(t.string),
					}),
					stats = t.interface({
						clicks = t.number,
					}),
				}))(data)
			end,
			dataStore = DataStoreService:GetDataStore("PlayerData1"),
			default = defaultPlayerData,
			migrations = nil,
			lockSessions = true,
			bindToClose = true,
		})
	end
	function PlayerSaveService:canSave()
		if not PLAYER_DATA_SAVING then
			return "DisabledSaveError"
		end
		if game.PlaceId == 0 then
			return "NotPublishedSaveError"
		end
		if IS_STUDIO then
			return "InStudioSaveError"
		end
		return nil
	end
	function PlayerSaveService:loadDefaultData(player)
		loadPlayerData(player.Name, defaultPlayerData)
	end
	function PlayerSaveService:processReceipt(receiptInfo)
		local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
		if not player then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		while true do
			local _documents = self.documents
			local _userId = player.UserId
			local _condition = not _documents[_userId]
			if _condition then
				_condition = not player.Parent
			end
			if not _condition then
				break
			end
			task.wait()
		end
		local _documents = self.documents
		local _userId = player.UserId
		local document = _documents[_userId]
		if not IS_STUDIO and not document then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		local recentPurchases = store:getState(selectPlayerRecentPurchases(player.Name))
		local _purchaseId = receiptInfo.PurchaseId
		if table.find(recentPurchases, _purchaseId) ~= nil then
			if IS_STUDIO then
				return Enum.ProductPurchaseDecision.PurchaseGranted
			end
			local _binding_1 = document:Save()
			local success = _binding_1.success
			return if success then Enum.ProductPurchaseDecision.PurchaseGranted else Enum.ProductPurchaseDecision.NotProcessedYet
		end
		local _exitType, _returns = TS.try(function()
			local purchaseEvent = developerProducts[receiptInfo.ProductId]
			if not purchaseEvent then
				return TS.TRY_RETURN, { Enum.ProductPurchaseDecision.NotProcessedYet }
			end
			purchaseEvent(receiptInfo, player)
		end, function()
			return TS.TRY_RETURN, { Enum.ProductPurchaseDecision.NotProcessedYet }
		end)
		if _exitType then
			return unpack(_returns)
		end
		local _binding_1 = store.addRecentPurchase(player.Name, receiptInfo.PurchaseId)
		local newPlayerData = _binding_1.player
		local _binding_2 = newPlayerData
		local purchases = _binding_2.purchases
		local playerPurchases = purchases[player.Name]
		if not playerPurchases then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		local newRecentPurchases = playerPurchases.recentPurchases
		if #newRecentPurchases > RECENT_PURCHASES_LIMIT then
			store.limitRecentPurchases(player.Name)
		end
		if IS_STUDIO then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
		local result = document:Save()
		if not result.success then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	function PlayerSaveService:onStart()
		MarketplaceService.ProcessReceipt = function(receiptInfo)
			return self:processReceipt(receiptInfo)
		end
	end
	function PlayerSaveService:onPlayerJoin(player)
		print(`{player.Name} joined`)
		local userId = player.UserId
		local saveError = self:canSave()
		if saveError then
			self:loadDefaultData(player)
			return nil
		end
		if saveError or not self.store then
			return nil
		end
		local document = self.store:GetDocument(`PLAYER_{userId}`)
		if not player:IsDescendantOf(Players) then
			return nil
		end
		local result
		local _exitType, _returns = TS.try(function()
			result = document:Open()
		end, function(error)
			player:Kick(`Failed to load data: {error}. Please rejoin`)
			return TS.TRY_RETURN, {}
		end)
		if _exitType then
			return unpack(_returns)
		end
		-- DocumentService retries 5 times over 16 seconds, so it is safe to steal
		-- after a failed `:Open`!
		if not result.success and result.reason == "SessionLockedError" then
			document:Steal()
			result = document:Open()
		end
		if not result.success then
			if result.reason == "BackwardsCompatibilityError" then
				player:Kick("You joined an old server which does not support your saved data.\nPlease try joining another server. If this persists, contact a developer.")
			end
			if result.reason == "RobloxAPIError" then
				player:Kick("Failed to load data due to a Roblox service issue. Try again later.")
			end
			player:Kick(`Failed to load data: {result.reason}. Please screenshot this message and report it to a developer.`)
			return nil
		end
		loadPlayerData(player.Name, table.clone(document:GetCache()))
		self.junkService:addJunk(player, store:subscribe(selectPlayerData(player.Name), function(data)
			if data then
				document:SetCache(data)
			end
		end))
		local _documents = self.documents
		local _userId = player.UserId
		_documents[_userId] = document
	end
	function PlayerSaveService:onPlayerLeave(player)
		local userId = player.UserId
		local document = self.documents[userId]
		if not document then
			return nil
		end
		document:Close()
		closePlayerData(player.Name)
	end
	do
		-- (Flamework) PlayerSaveService metadata
		Reflect.defineMetadata(PlayerSaveService, "identifier", "common/src/server/services/player-save-service@PlayerSaveService")
		Reflect.defineMetadata(PlayerSaveService, "flamework:parameters", { "common/src/server/services/junk-service@JunkService" })
		Reflect.defineMetadata(PlayerSaveService, "flamework:implements", { "common/src/server/hooks/init@OnPlayerLeave", "common/src/server/hooks/init@OnPlayerJoin", "$:flamework@OnStart" })
	end
end
-- (Flamework) PlayerSaveService decorators
Reflect.decorate(PlayerSaveService, "$:flamework@Service", Service, { {
	loadOrder = 1,
} })
return {
	PlayerSaveService = PlayerSaveService,
}
