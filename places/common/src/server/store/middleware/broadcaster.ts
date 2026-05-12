import { ProducerMiddleware, createBroadcaster } from "@rbxts/reflex";
import remotes, { RemoteId } from "common/shared/remotes";
import { IS_EDIT } from "common/shared/constants/game";
import { sharedSlices } from "common/shared/store";

export function broadcasterMiddleware(): ProducerMiddleware {
	if (IS_EDIT) {
		return () => (dispatch) => dispatch;
	}

	const broadcaster = createBroadcaster({
		dispatch: (player, actions) => {
			remotes.Server.GetNamespace("store").Get(RemoteId.Dispatch).SendToPlayer(player, actions);
		},
		producers: sharedSlices,
	});

	remotes.Server.GetNamespace("store")
		.Get(RemoteId.Start)
		.Connect((player) => {
			broadcaster.start(player);
		});

	return broadcaster.middleware;
}
