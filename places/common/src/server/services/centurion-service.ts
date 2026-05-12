import { ServerScriptService, ReplicatedStorage } from "@rbxts/services";
import { Service, OnStart } from "@flamework/core";
import { Centurion } from "@rbxts/centurion";

@Service({})
export class CenturionService implements OnStart {
	onStart() {
		const server = Centurion.server();

		// Load all child ModuleScripts under each container
		const commandContainer = ServerScriptService.common.commands;
		server.registry.load(commandContainer);

		const typeContainer = ReplicatedStorage.common.types;
		server.registry.load(typeContainer);

		// Any loaded commands and types will then be registered once Centurion is started
		server.start();
	}
}
