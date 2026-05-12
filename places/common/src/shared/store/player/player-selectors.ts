import { SharedState } from "common/shared/store";
import { createSelector } from "@rbxts/reflex";

export const selectPlayerStats = (playerName: string) => {
	return (state: SharedState) => {
		return state.player.stats[playerName];
	};
};

export const selectPlayerPurchases = (playerName: string) => {
	return (state: SharedState) => {
		return state.player.purchases[playerName];
	};
};

export const selectPlayerData = (playerName: string) => {
	return createSelector(
		selectPlayerPurchases(playerName),
		selectPlayerStats(playerName),

		(purchases, stats): PlayerSave | undefined => {
			if (!stats || !purchases) {
				return;
			}

			return { purchases, stats };
		},
	);
};
