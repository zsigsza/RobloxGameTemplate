import { ServerScriptService, ReplicatedStorage } from "@rbxts/services";
import { Service, OnStart } from "@flamework/core";
import { Centurion } from "@rbxts/centurion";

@Service({})
export class CenturionService implements OnStart {
	onStart() {
		const server = Centurion.server();

		// Load all child ModuleScripts under each container. The containers
		// don't exist until at least one command/type has been written.
		const commandContainer = ServerScriptService.common.FindFirstChild("commands");
		if (commandContainer) server.registry.load(commandContainer);

		const typeContainer = ReplicatedStorage.common.FindFirstChild("types");
		if (typeContainer) server.registry.load(typeContainer);

		// Any loaded commands and types will then be registered once Centurion is started
		server.start();
	}
}
