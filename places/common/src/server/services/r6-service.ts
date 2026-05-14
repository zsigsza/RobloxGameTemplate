import { InsertService, StarterPlayer, Players } from "@rbxts/services";
import { getHumanoid } from "common/shared/utils/player";
import { FORCE_R6 } from "common/shared/constants/flags";
import { Service, OnStart } from "@flamework/core";
import { OnPlayerJoin } from "common/server/hooks";

@Service({})
export class R6Service implements OnPlayerJoin, OnStart {
	getBaseR6Avatar() {
		try {
			const asset = InsertService.LoadAsset(124766567754864);
			const model = asset.FindFirstChildOfClass("Model")?.Clone();
			asset.Destroy();
			return model;
		} catch {
			return;
		}
	}

	getHumanoidDescription(player: Player) {
		try {
			return Players.GetHumanoidDescriptionFromUserIdAsync(player.UserId);
		} catch {
			return;
		}
	}

	onStart() {
		if (!FORCE_R6) return;
		const model = this.getBaseR6Avatar();
		if (!model) return;
		model.Name = "StarterCharacter";
		model.Parent = StarterPlayer;
	}

	onPlayerJoin(player: Player): void {
		if (!FORCE_R6) return;
		player.CharacterAdded.Connect((character) => {
			const [humanoid] = getHumanoid(character);
			if (!humanoid) return;
			const description = this.getHumanoidDescription(player);
			if (!description) return;
			humanoid.ApplyDescriptionAsync(description);
		});
	}
}
