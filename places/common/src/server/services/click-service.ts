import { OnPlayerClick } from "common/server/hooks";
import { store } from "common/server/store";
import { Service } from "@flamework/core";

@Service({})
export class ClickService implements OnPlayerClick {
	onPlayerClick(player: Player): void {
		store.click(player.Name);
	}
}
