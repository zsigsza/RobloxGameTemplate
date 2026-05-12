import { OnPlayerLeave, OnPlayerJoin } from "common/client/hooks";
import { Lifecycle } from "common/shared/modding/lifecycle";
import { Controller, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";

@Controller({})
export class PlayerHookController implements OnStart {
	joinListener = new Lifecycle<OnPlayerJoin>();
	leaveListener = new Lifecycle<OnPlayerLeave>();
	onStart() {
		this.joinListener.register();
		this.leaveListener.register();

		this.joinListener.connect(Players.PlayerAdded, (l, p) => l.onPlayerJoin(p));
		this.leaveListener.connect(Players.PlayerRemoving, (l, p) => l.onPlayerLeave(p));

		for (const player of Players.GetPlayers()) this.joinListener.emit((l) => l.onPlayerJoin(player));
	}
}
