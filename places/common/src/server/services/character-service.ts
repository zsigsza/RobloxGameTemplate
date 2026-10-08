import { OnPlayerLeave, OnPlayerJoin } from "common/server/hooks";
import { R6Service } from "common/server/services/r6-service";
import { FORCE_R6 } from "common/shared/constants/flags";
import { Service, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";

/**
 * Spawns characters manually when `FORCE_R6` is enabled, so the
 * R6 `StarterCharacter` gets the player's avatar applied to it.
 *
 * When `FORCE_R6` is disabled Roblox's default character loading is used.
 */
@Service({})
export class CharacterService implements OnPlayerLeave, OnPlayerJoin, OnInit {
	/** Descriptions are cached so spawning again doesn't hit the web API every time. */
	private readonly descriptions = new Map<number, HumanoidDescription>();

	constructor(private readonly r6Service: R6Service) {}

	onInit() {
		if (!FORCE_R6) return;

		// Must happen before any player joins, otherwise they'd spawn as R15.
		Players.CharacterAutoLoads = false;

		return Promise.try(() => {
			if (!this.r6Service.setR6DefaultCharacter()) {
				warn("FORCE_R6 is enabled, but the R6 character could not be loaded.");
			}
		});
	}

	onPlayerJoin(player: Player) {
		if (!FORCE_R6) return;

		player.CharacterAdded.Connect((character) => this.respawnOnDeath(player, character));
		this.spawnCharacter(player);
	}

	onPlayerLeave(player: Player) {
		this.descriptions.get(player.UserId)?.Destroy();
		this.descriptions.delete(player.UserId);
	}

	getHumanoidDescription(player: Player): HumanoidDescription | undefined {
		const cached = this.descriptions.get(player.UserId);
		if (cached) return cached;

		try {
			const description = Players.GetHumanoidDescriptionFromUserIdAsync(player.UserId);
			this.descriptions.set(player.UserId, description);
			return description;
		} catch (err) {
			warn(`Failed to get the humanoid description of ${player.Name}: ${err}`);
			return undefined;
		}
	}

	/** Loads the player's character with their avatar applied. Yields. */
	spawnCharacter(player: Player) {
		if (!player.IsDescendantOf(Players)) return;

		const description = this.getHumanoidDescription(player);
		if (!player.IsDescendantOf(Players)) return;

		try {
			if (description) {
				player.LoadCharacterWithHumanoidDescriptionAsync(description);
			} else {
				player.LoadCharacterAsync();
			}
		} catch (err) {
			warn(`Failed to load the character of ${player.Name}: ${err}`);
		}
	}

	private respawnOnDeath(player: Player, character: Model) {
		const humanoid = character.WaitForChild("Humanoid", 10);
		if (!humanoid?.IsA("Humanoid")) return;

		humanoid.Died.Once(() => {
			task.delay(Players.RespawnTime, () => {
				// Don't respawn if the character was already replaced in the meantime.
				if (player.Character === character) this.spawnCharacter(player);
			});
		});
	}
}
