import { createBroadcastReceiver, ProducerMiddleware } from "@rbxts/reflex";
import remotes, { RemoteId } from "common/shared/remotes";
import { IS_EDIT } from "common/shared/constants/game";

export function receiverMiddleware(): ProducerMiddleware {
	if (IS_EDIT) {
		return () => (dispatch) => dispatch;
	}

	const receiver = createBroadcastReceiver({
		start: () => {
			remotes.Client.GetNamespace("store").Get(RemoteId.Start).SendToServer();
		},
	});

	remotes.Client.GetNamespace("store")
		.Get(RemoteId.Dispatch)
		.Connect((actions) => {
			receiver.dispatch(actions);
		});

	return receiver.middleware;
}
