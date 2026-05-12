import { RECENT_PURCHASES_LIMIT, PLAYER_DATA_SAVING } from "common/shared/constants/flags";
import { selectPlayerRecentPurchases } from "common/shared/store/player/purchases";
import { defaultPlayerData } from "common/server/constants/default-player-data";
import { MarketplaceService, DataStoreService, Players } from "@rbxts/services";
import { selectPlayerData } from "common/shared/store/player/player-selectors";
import { OpenResult, Document } from "@rbxts/document-service/out/Document";
import { JunkService } from "common/server/services/junk-service";
import { OnPlayerLeave, OnPlayerJoin } from "common/server/hooks";
import { Flamework, OnStart, Service } from "@flamework/core";
import { developerProducts } from "common/server/devproducts";
import { IS_STUDIO } from "common/shared/constants/game";
import { DocumentStore } from "@rbxts/document-service";
import { store } from "common/server/store";

const { closePlayerData, loadPlayerData } = store;

export type InStudioSaveError = "InStudioSaveError";
export type NotPublishedSaveError = "NotPublishedSaveError";
export type DisabledSaveError = "DisabledSaveError";
export type CanSaveResult = NotPublishedSaveError | InStudioSaveError | DisabledSaveError | undefined;

@Service({ loadOrder: 1 })
export class PlayerSaveService implements OnPlayerLeave, OnPlayerJoin, OnStart {
	private readonly store: DocumentStore<PlayerSave> | undefined;
	public documents = new Map<number, Document<PlayerSave>>();

	/**
	 *
	 * @returns undefined when there are no errors.
	 */
	public canSave(): LuaTuple<[error: CanSaveResult]> {
		if (!PLAYER_DATA_SAVING) {
			return $tuple("DisabledSaveError");
		}

		if (game.PlaceId === 0) {
			return $tuple("NotPublishedSaveError");
		}
		if (IS_STUDIO) {
			return $tuple("InStudioSaveError");
		}

		return $tuple(undefined);
	}

	private loadDefaultData(player: Player) {
		loadPlayerData(player.Name, defaultPlayerData);
	}

	private processReceipt(receiptInfo: ReceiptInfo) {
		const player = Players.GetPlayerByUserId(receiptInfo.PlayerId);
		if (!player) {
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		while (!this.documents.get(player.UserId) && !player.Parent) {
			task.wait();
		}

		const document = this.documents.get(player.UserId);
		if (!document) {
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		const recentPurchases = store.getState(selectPlayerRecentPurchases(player.Name));

		if (recentPurchases.includes(receiptInfo.PurchaseId)) {
			const { success } = document.Save();
			return success
				? Enum.ProductPurchaseDecision.PurchaseGranted
				: Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		try {
			const purchaseEvent = developerProducts[receiptInfo.ProductId];
			if (!purchaseEvent) return Enum.ProductPurchaseDecision.NotProcessedYet;
			purchaseEvent(receiptInfo, player);
		} catch {
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		const { player: newPlayerData } = store.addRecentPurchase(player.Name, receiptInfo.PurchaseId);
		const { purchases } = newPlayerData;

		const playerPurchases = purchases[player.Name];
		if (!playerPurchases) return Enum.ProductPurchaseDecision.NotProcessedYet;

		const newRecentPurchases = playerPurchases.recentPurchases;
		if (newRecentPurchases.size() > RECENT_PURCHASES_LIMIT) {
			store.limitRecentPurchases(player.Name);
		}

		const result = document.Save();
		if (!result.success) {
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		return Enum.ProductPurchaseDecision.PurchaseGranted;
	}

	constructor(private junkService: JunkService) {
		const [saveError] = this.canSave();
		if (saveError === "DisabledSaveError") {
			warn("Player data saving is disabled!");
		} else if (saveError === "NotPublishedSaveError") {
			warn("Place is not published, player data won't save.");
		} else if (saveError === "InStudioSaveError") {
			warn("Player saving is disabled in studio.");
		}
		if (saveError) return;

		this.store = new DocumentStore({
			check: (data) => Flamework.createGuard<PlayerSave>()(data),
			dataStore: DataStoreService.GetDataStore("PlayerData"),
			default: defaultPlayerData,

			/**
			 * //TODO: Don't forget to use migrations when updating.
			 */
			migrations: undefined,
			lockSessions: true,
			bindToClose: true,
		});
	}

	onStart(): void {
		MarketplaceService.ProcessReceipt = this.processReceipt;
	}

	onPlayerJoin(player: Player): void {
		print(`${player.Name} joined`);
		const userId = player.UserId;
		const [saveError] = this.canSave();

		if (saveError) {
			this.loadDefaultData(player);
			return;
		}

		if (saveError || !this.store) return;

		const [document] = this.store.GetDocument(`PLAYER_${userId}`);

		if (!player.IsDescendantOf(Players)) {
			return;
		}

		let result: OpenResult<PlayerSave> = document.Open();

		// DocumentService retries 5 times over 16 seconds, so it is safe to steal
		// after a failed `:Open`!
		if (!result.success && result.reason === "SessionLockedError") {
			document.Steal();
			result = document.Open();
		}

		if (!result.success) {
			if (result.reason === "BackwardsCompatibilityError") {
				player.Kick(
					"You joined an old server which does not support your saved data.\nPlease try joining another server. If this persists, contact a developer.",
				);
			}

			if (result.reason === "RobloxAPIError") {
				player.Kick("Failed to load data due to a Roblox service issue. Try again later.");
			}

			player.Kick(
				`Failed to load data: ${result.reason}. Please screenshot this message and report it to a developer.`,
			);

			return;
		}
		loadPlayerData(player.Name, table.clone(document.GetCache()));

		this.junkService.addJunk(
			player,
			store.subscribe(selectPlayerData(player.Name), (data) => {
				if (data) document.SetCache(data);
			}),
		);

		this.documents.set(player.UserId, document);
	}

	onPlayerLeave(player: Player): void {
		const userId = player.UserId;
		const document = this.documents.get(userId);
		if (!document) return;

		document.Close();
		closePlayerData(player.Name);
	}
}
