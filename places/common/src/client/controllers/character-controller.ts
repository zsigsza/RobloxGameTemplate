import { localPlayer } from "common/client/constants/local-player";
import { OnLocalCharacterAdded } from "common/client/hooks";
import { getHumanoid } from "common/shared/utils/player";
import { Controller, OnStart } from "@flamework/core";
import { HRP } from "common/shared/constants/game";

@Controller({})
export class CharacterController implements OnLocalCharacterAdded, OnStart {
	humanoid: undefined | Humanoid;
	character: undefined | Model;
	rootPart: undefined | BasePart;
	head: undefined | BasePart;
	rootJoint: undefined | Motor6D;

	onStart() {
		const [humanoid, character] = getHumanoid(localPlayer);

		this.humanoid = humanoid;
		this.character = character;
		this.rootPart = character?.WaitForChild(HRP) as undefined | BasePart;
		this.head = character?.WaitForChild("Head") as undefined | BasePart;
		this.rootJoint = this.rootPart?.WaitForChild("RootJoint") as Motor6D;
	}

	setAutoRotate(rotate: boolean) {
		if (this.humanoid) {
			this.humanoid.AutoRotate = rotate;
		}
	}

	onLocalCharacterAdded(): void {
		this.onStart();
	}
}
