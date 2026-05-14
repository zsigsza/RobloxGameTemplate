import { OnLocalCharacterRemoving, OnLocalCharacterAdded } from "common/client/hooks";
import { localPlayer } from "common/client/constants/local-player";
import { Lifecycle } from "common/shared/modding/lifecycle";
import { Controller, OnStart } from "@flamework/core";

@Controller({})
export class LocalCharacterHookController implements OnStart {
	characterAdded = new Lifecycle<OnLocalCharacterAdded>();
	characterRemoving = new Lifecycle<OnLocalCharacterRemoving>();
	onStart() {
		this.characterAdded.register();
		this.characterRemoving.register();

		this.characterAdded.connect(localPlayer.CharacterAdded, (l, m) => l.onLocalCharacterAdded(m));
		this.characterRemoving.connect(localPlayer.CharacterRemoving, (l, m) => l.onLocalCharacterRemoving(m));

		task.spawn(() => {
			const character = localPlayer.Character;
			if (!character) {
				return;
			}

			this.characterAdded.emit((l) => l.onLocalCharacterAdded(character));
		});
	}
}
