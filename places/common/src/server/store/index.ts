import { broadcasterMiddleware } from "common/server/store/middleware/broadcaster";
import { combineProducers, InferState } from "@rbxts/reflex";
import { sharedSlices } from "common/shared/store";

export type RootState = InferState<typeof store>;

export function createStore() {
	const store = combineProducers({
		...sharedSlices,
	});

	store.applyMiddleware(broadcasterMiddleware());

	return store;
}

export const store = createStore();
