import { OnPlayerLeave } from "common/server/hooks";
import { Service } from "@flamework/core";
import { Trove } from "@rbxts/trove";

/** Tracks per-player objects (connections, instances, ...) and cleans them up when the player leaves. */
@Service({})
export class JunkService implements OnPlayerLeave {
	private readonly troves = new Map<number, Trove>();

	onPlayerLeave(player: Player) {
		this.clean(player);
	}

	addJunk(player: Player, junk: Trove.Trackable) {
		let trove = this.troves.get(player.UserId);
		if (!trove) {
			trove = new Trove();
			this.troves.set(player.UserId, trove);
		}

		trove.add(junk);
	}

	clean(player: Player) {
		this.troves.get(player.UserId)?.destroy();
		this.troves.delete(player.UserId);
	}
}
