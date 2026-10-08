import { OnLocalCharacterRemoving, OnLocalCharacterAdded } from "common/client/hooks";
import { localPlayer } from "common/client/constants/local-player";
import { HRP } from "common/shared/constants/game";
import { Controller } from "@flamework/core";

const CHARACTER_LOAD_TIMEOUT = 10;

function waitForChildOfClass<T extends keyof Instances>(
	parent: Instance,
	name: string,
	className: T,
): Instances[T] | undefined {
	const child = parent.WaitForChild(name, CHARACTER_LOAD_TIMEOUT);
	return child?.IsA(className) ? (child as Instances[T]) : undefined;
}

/** Keeps references to the parts of the local character that other controllers need. */
@Controller({})
export class CharacterController implements OnLocalCharacterRemoving, OnLocalCharacterAdded {
	humanoid: undefined | Humanoid;
	character: undefined | Model;
	rootPart: undefined | BasePart;
	head: undefined | BasePart;
	rootJoint: undefined | Motor6D;

	private autoRotate = true;

	setAutoRotate(rotate: boolean) {
		this.autoRotate = rotate;
		if (this.humanoid) {
			this.humanoid.AutoRotate = rotate;
		}
	}

	onLocalCharacterAdded(character: Model): void {
		this.clear();

		const humanoid = waitForChildOfClass(character, "Humanoid", "Humanoid");
		const rootPart = waitForChildOfClass(character, HRP, "BasePart");
		const head = waitForChildOfClass(character, "Head", "BasePart");
		const rootJoint = rootPart && waitForChildOfClass(rootPart, "RootJoint", "Motor6D");

		// The character might have been replaced or removed while waiting.
		if (localPlayer.Character !== character) return;
		if (!humanoid || !rootPart || !head || !rootJoint) {
			warn(`Character ${character.GetFullName()} is missing parts, can't track it.`);
			return;
		}

		this.character = character;
		this.humanoid = humanoid;
		this.rootPart = rootPart;
		this.head = head;
		this.rootJoint = rootJoint;

		humanoid.AutoRotate = this.autoRotate;
	}

	onLocalCharacterRemoving(character: Model): void {
		if (this.character === character) {
			this.clear();
		}
	}

	private clear() {
		this.character = undefined;
		this.humanoid = undefined;
		this.rootPart = undefined;
		this.head = undefined;
		this.rootJoint = undefined;
	}
}
