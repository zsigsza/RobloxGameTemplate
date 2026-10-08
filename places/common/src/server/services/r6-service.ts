import { InsertService, StarterPlayer } from "@rbxts/services";
import { Service } from "@flamework/core";

const BASE_R6_AVATAR_ASSET_ID = 124766567754864;

@Service({})
export class R6Service {
	getBaseR6Avatar(): undefined | Model {
		try {
			const asset = InsertService.LoadAsset(BASE_R6_AVATAR_ASSET_ID);
			const model = asset.FindFirstChildOfClass("Model");
			if (model) model.Parent = undefined;
			asset.Destroy();
			return model;
		} catch (err) {
			warn(`Failed to load the base R6 avatar: ${err}`);
			return undefined;
		}
	}

	/** Replaces the default character with an R6 `StarterCharacter`. Yields. */
	setR6DefaultCharacter(): boolean {
		const model = this.getBaseR6Avatar();
		if (!model) return false;

		StarterPlayer.FindFirstChild("StarterCharacter")?.Destroy();
		model.Name = "StarterCharacter";
		model.Parent = StarterPlayer;
		return true;
	}
}
