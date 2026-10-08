import { ProducerMiddleware, createBroadcaster } from "@rbxts/reflex";
import remotes, { RemoteId } from "common/shared/remotes";
import { IS_EDIT } from "common/shared/constants/game";
import { sharedSlices } from "common/shared/store";

/**
 * Replicates the store to clients, but only shares each player's own data with
 * them. Other players' data (e.g. purchase history) never leaves the server.
 *
 * To expose data to everyone (e.g. for a leaderboard), loosen
 * `beforeDispatch` and `beforeHydrate` accordingly.
 */
// eslint-disable-next-line @typescript-eslint/naming-convention
export function broadcasterMiddleware(): ProducerMiddleware {
	if (IS_EDIT) {
		return () => (dispatch) => dispatch;
	}

	const storeRemotes = remotes.Server.GetNamespace("store");

	const broadcaster = createBroadcaster({
		beforeHydrate: (player, state) => ({
			player: {
				purchases: { [player.Name]: state.player.purchases[player.Name] },
				stats: { [player.Name]: state.player.stats[player.Name] },
			},
		}),

		// Every player-scoped action receives the player's name as its first argument.
		beforeDispatch: (player, action) => {
			return action.arguments[0] === player.Name ? action : undefined;
		},

		dispatch: (player, actions) => {
			storeRemotes.Get(RemoteId.Dispatch).SendToPlayer(player, actions);
		},

		producers: sharedSlices,
	});

	storeRemotes.Get(RemoteId.Start).Connect((player) => {
		broadcaster.start(player);
	});

	return broadcaster.middleware;
}
