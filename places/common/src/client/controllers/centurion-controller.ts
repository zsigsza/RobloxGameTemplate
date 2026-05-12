import { Controller, OnStart } from "@flamework/core";
import { CenturionUI } from "@rbxts/centurion-ui";
import { Centurion } from "@rbxts/centurion";

@Controller({})
export class CenturionController implements OnStart {
	onStart() {
		Centurion.client()
			.start()
			.then(() => CenturionUI.start(Centurion.client(), {}))
			.catch((err) => warn("Failed to start Centurion:", err));
	}
}
