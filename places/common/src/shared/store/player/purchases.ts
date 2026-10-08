import { RECENT_PURCHASES_LIMIT } from "common/shared/constants/flags";
import { SharedState } from "common/shared/store";
import { createProducer } from "@rbxts/reflex";

export interface PurchaseState {
	readonly [player: string]: PlayerPurchases | undefined;
}

const initialState: PurchaseState = {};

function trimRecentPurchases(recentPurchases: ReadonlyArray<string>): ReadonlyArray<string> {
	const overflow = recentPurchases.size() - RECENT_PURCHASES_LIMIT;
	if (overflow <= 0) return recentPurchases;

	const trimmed = new Array<string>();
	for (const index of $range(overflow, recentPurchases.size() - 1)) {
		trimmed.push(recentPurchases[index]);
	}

	return trimmed;
}

export const purchasesSlice = createProducer(initialState, {
	addRecentPurchase: (state, player: string, recentPurchase: string) => {
		const purchases = state[player];
		return {
			...state,
			[player]: purchases && {
				...purchases,
				// Only keep the newest purchases so the saved data can't grow forever.
				recentPurchases: trimRecentPurchases([...purchases.recentPurchases, recentPurchase]),
			},
		};
	},

	loadPlayerData: (state, player: string, data: PlayerSave) => ({
		...state,
		[player]: data.purchases,
	}),

	closePlayerData: (state, player: string) => ({
		...state,
		[player]: undefined,
	}),
});

export const selectPlayerRecentPurchases = (playerName: string) => {
	return (state: SharedState) => {
		return state.player.purchases[playerName]?.recentPurchases ?? [];
	};
};
