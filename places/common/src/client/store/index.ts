import { receiverMiddleware } from "common/client/store/middleware/receiver";
import { combineProducers, InferState } from "@rbxts/reflex";
import { sharedSlices } from "common/shared/store";

export type RootStore = typeof store;

export type RootState = InferState<RootStore>;

export function createStore() {
	const store = combineProducers({
		...sharedSlices,
	});

	store.applyMiddleware(receiverMiddleware());
	return store;
}

export const store = createStore();
