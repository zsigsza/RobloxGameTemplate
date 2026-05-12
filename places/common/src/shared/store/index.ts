import { playerSlice } from "common/shared/store/player";
import { CombineStates } from "@rbxts/reflex";

export type SharedState = CombineStates<typeof sharedSlices>;

export const sharedSlices = {
	player: playerSlice,
};
