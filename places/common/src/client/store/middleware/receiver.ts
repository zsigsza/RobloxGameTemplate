import { createBroadcastReceiver, ProducerMiddleware } from "@rbxts/reflex";
import remotes, { RemoteId } from "common/shared/remotes";
import { IS_EDIT } from "common/shared/constants/game";

// eslint-disable-next-line @typescript-eslint/naming-convention
export function receiverMiddleware(): ProducerMiddleware {
	if (IS_EDIT) {
		return () => (dispatch) => dispatch;
	}

	const storeRemotes = remotes.Client.GetNamespace("store");

	const receiver = createBroadcastReceiver({
		start: () => {
			storeRemotes.Get(RemoteId.Start).SendToServer();
		},
	});

	storeRemotes.Get(RemoteId.Dispatch).Connect((actions) => {
		receiver.dispatch(actions);
	});

	return receiver.middleware;
}
