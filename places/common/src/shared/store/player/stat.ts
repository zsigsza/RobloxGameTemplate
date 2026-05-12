import { SharedState } from "common/shared/store";
import { createProducer } from "@rbxts/reflex";

export interface StatState {
	readonly [player: string]: PlayerStats | undefined;
}

const initialState: StatState = {};

export const statsSlice = createProducer(initialState, {
	addClick: (state, player: string, amount: number) => {
		const stats = state[player];
		return {
			...state,
			[player]: stats && {
				...stats,
				clicks: stats.clicks + amount,
			},
		};
	},
	click: (state, player: string) => {
		const stats = state[player];
		return {
			...state,
			[player]: stats && {
				...stats,
				clicks: stats.clicks + 1,
			},
		};
	},

	loadPlayerData: (state, player: string, data: PlayerSave) => ({
		...state,
		[player]: data.stats,
	}),

	closePlayerData: (state, player: string) => ({
		...state,
		[player]: undefined,
	}),
});

export const selectPlayerClicks = (playerName: string) => {
	return (state: SharedState) => {
		return state.player.stats[playerName]?.clicks ?? 0;
	};
};
