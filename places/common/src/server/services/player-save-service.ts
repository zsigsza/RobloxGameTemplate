import { selectPlayerRecentPurchases } from "common/shared/store/player/purchases";
import { MarketplaceService, DataStoreService, Players } from "@rbxts/services";
import { defaultPlayerData } from "common/server/constants/default-player-data";
import { selectPlayerData } from "common/shared/store/player/player-selectors";
import { OpenResult, Document } from "@rbxts/document-service/out/Document";
import { PLAYER_DATA_SAVING } from "common/shared/constants/flags";
import { JunkService } from "common/server/services/junk-service";
import { OnPlayerLeave, OnPlayerJoin } from "common/server/hooks";
import { Flamework, OnStart, Service } from "@flamework/core";
import { developerProducts } from "common/server/devproducts";
import { IS_STUDIO } from "common/shared/constants/game";
import { DocumentStore } from "@rbxts/document-service";
import { store } from "common/server/store";

const PLAYER_DATA_STORE_NAME = "PlayerData1";

const isPlayerSave = Flamework.createGuard<PlayerSave>();

export type InStudioSaveError = "InStudioSaveError";
export type NotPublishedSaveError = "NotPublishedSaveError";
export type DisabledSaveError = "DisabledSaveError";
export type CanSaveResult = NotPublishedSaveError | InStudioSaveError | DisabledSaveError | undefined;

@Service({ loadOrder: 1 })
export class PlayerSaveService implements OnPlayerLeave, OnPlayerJoin, OnStart {
	/** `undefined` when saving is unavailable, in which case players get default data. */
	private readonly documentStore: DocumentStore<PlayerSave> | undefined;
	private readonly documents = new Map<number, Document<PlayerSave>>();

	constructor(private readonly junkService: JunkService) {
		const [saveError] = this.canSave();
		if (saveError === "DisabledSaveError") {
			warn("Player data saving is disabled!");
		} else if (saveError === "NotPublishedSaveError") {
			warn("Place is not published, player data won't save.");
		} else if (saveError === "InStudioSaveError") {
			warn("Player saving is disabled in studio.");
		}
		if (saveError) return;

		this.documentStore = new DocumentStore({
			dataStore: DataStoreService.GetDataStore(PLAYER_DATA_STORE_NAME),
			default: defaultPlayerData,
			/**
			 * //TODO: Don't forget to use migrations when updating.
			 */
			migrations: undefined,

			check: isPlayerSave,
			lockSessions: true,
			bindToClose: true,
		});
	}

	/**
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

	onStart(): void {
		MarketplaceService.ProcessReceipt = (receiptInfo: ReceiptInfo) => this.processReceipt(receiptInfo);
	}

	onPlayerJoin(player: Player): void {
		if (!this.documentStore) {
			store.loadPlayerData(player.Name, defaultPlayerData);
			return;
		}

		const [document] = this.documentStore.GetDocument(`PLAYER_${player.UserId}`);
		if (!player.IsDescendantOf(Players)) return;

		if (!this.openDocument(player, document)) return;

		// Opening yields, so the player might have left in the meantime. Release
		// the session lock instead of leaking it until it expires.
		if (!player.IsDescendantOf(Players)) {
			document.Close();
			return;
		}

		this.documents.set(player.UserId, document);
		store.loadPlayerData(player.Name, table.clone(document.GetCache()));

		this.junkService.addJunk(
			player,
			store.subscribe(selectPlayerData(player.Name), (data) => {
				if (data) document.SetCache(data);
			}),
		);
	}

	onPlayerLeave(player: Player): void {
		const document = this.documents.get(player.UserId);
		this.documents.delete(player.UserId);

		// Stop syncing, then flush the latest state ourselves: store updates are
		// batched, so the most recent changes may not have reached the document yet.
		this.junkService.clean(player);
		const data = store.getState(selectPlayerData(player.Name));
		store.closePlayerData(player.Name);

		if (!document) return;
		if (data) document.SetCache(data);
		document.Close();
	}

	/**
	 * Opens the document, kicking the player if that is not possible.
	 *
	 * @returns Whether the document is open.
	 */
	private openDocument(player: Player, document: Document<PlayerSave>): boolean {
		let result: OpenResult<PlayerSave>;
		try {
			result = document.Open();

			// DocumentService retries 5 times over 16 seconds, so it is safe to steal
			// after a failed `:Open`!
			if (!result.success && result.reason === "SessionLockedError") {
				document.Steal();
				result = document.Open();
			}
		} catch (error) {
			player.Kick(`Failed to load data: ${error}. Please rejoin`);
			return false;
		}

		if (result.success) return true;

		if (result.reason === "BackwardsCompatibilityError") {
			player.Kick(
				"You joined an old server which does not support your saved data.\nPlease try joining another server. If this persists, contact a developer.",
			);
		} else if (result.reason === "RobloxAPIError") {
			player.Kick("Failed to load data due to a Roblox service issue. Try again later.");
		} else {
			player.Kick(
				`Failed to load data: ${result.reason}. Please screenshot this message and report it to a developer.`,
			);
		}

		return false;
	}

	/** Waits until the player's data is loaded, or until they leave. */
	private waitForDocument(player: Player): Document<PlayerSave> | undefined {
		while (!this.documents.has(player.UserId) && player.IsDescendantOf(Players)) {
			task.wait();
		}

		return this.documents.get(player.UserId);
	}

	/** Saves the document (if there is one) so that a granted purchase can't be lost. */
	private saveReceipt(document: Document<PlayerSave> | undefined): Enum.ProductPurchaseDecision {
		if (!document) return Enum.ProductPurchaseDecision.PurchaseGranted;

		return document.Save().success
			? Enum.ProductPurchaseDecision.PurchaseGranted
			: Enum.ProductPurchaseDecision.NotProcessedYet;
	}

	private processReceipt(receiptInfo: ReceiptInfo): Enum.ProductPurchaseDecision {
		const player = Players.GetPlayerByUserId(receiptInfo.PlayerId);
		if (!player) {
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		// Without a document store (studio/disabled saving) purchases are only kept in memory.
		let document: Document<PlayerSave> | undefined;
		if (this.documentStore) {
			document = this.waitForDocument(player);
			if (!document) return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		if (!store.getState(selectPlayerData(player.Name))) {
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		// Roblox can retry a receipt, so make sure it is only granted once.
		const recentPurchases = store.getState(selectPlayerRecentPurchases(player.Name));
		if (recentPurchases.includes(receiptInfo.PurchaseId)) {
			return this.saveReceipt(document);
		}

		const purchaseEvent = developerProducts[receiptInfo.ProductId];
		if (!purchaseEvent) {
			warn(`No handler registered for developer product ${receiptInfo.ProductId}`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		try {
			purchaseEvent(receiptInfo, player);
		} catch (err) {
			warn(`Developer product ${receiptInfo.ProductId} handler failed: ${err}`);
			return Enum.ProductPurchaseDecision.NotProcessedYet;
		}

		store.addRecentPurchase(player.Name, receiptInfo.PurchaseId);
		return this.saveReceipt(document);
	}
}
