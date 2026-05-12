import { RECENT_PURCHASES_LIMIT } from "common/shared/constants/flags";
import { SharedState } from "common/shared/store";
import { createProducer } from "@rbxts/reflex";
import Sift from "@rbxts/sift";

export interface PurchaseState {
	readonly [player: string]: PlayerPurchases | undefined;
}

const initialState: PurchaseState = {};

export const purchasesSlice = createProducer(initialState, {
	limitRecentPurchases: (state, player: string) => {
		const purchases = state[player];
		return {
			...state,
			[player]: purchases && {
				...purchases,
				recentPurchases: Sift.Array.shift(
					purchases.recentPurchases,
					purchases.recentPurchases.size() - RECENT_PURCHASES_LIMIT,
				),
			},
		};
	},

	addRecentPurchase: (state, player: string, recentPurchase: string) => {
		const purchases = state[player];
		return {
			...state,
			[player]: purchases && {
				...purchases,
				recentPurchases: [...purchases.recentPurchases, recentPurchase],
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
