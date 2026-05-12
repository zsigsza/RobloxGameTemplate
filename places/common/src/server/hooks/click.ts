import { Lifecycle } from "common/shared/modding/lifecycle";
import remotes, { RemoteId } from "common/shared/remotes";
import { OnPlayerClick } from "common/server/hooks";
import { Service, OnStart } from "@flamework/core";

@Service({})
export class ClickHookService implements OnStart {
	clickListener = new Lifecycle<OnPlayerClick>();

	onStart() {
		this.clickListener.register();

		remotes.Server.OnEvent(RemoteId.Click, (p) => this.clickListener.emit((l) => l.onPlayerClick(p)));
	}
}
