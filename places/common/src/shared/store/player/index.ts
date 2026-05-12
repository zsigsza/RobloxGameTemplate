import { purchasesSlice } from "common/shared/store/player/purchases";
import { statsSlice } from "common/shared/store/player/stat";
import { combineProducers } from "@rbxts/reflex";

export const playerSlice = combineProducers({
	purchases: purchasesSlice,
	stats: statsSlice,
});
