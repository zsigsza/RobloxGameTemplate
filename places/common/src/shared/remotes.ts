import { BroadcastAction } from "@rbxts/reflex";
import Net, { Definitions } from "@rbxts/net";

/**
 * @uuid
 */
export const enum RemoteId {
	// Store
	Dispatch = "Dispatch",
	Start = "Start",

	Click = "Click",
}

const remotes = Net.CreateDefinitions({
	store: Definitions.Namespace({
		[RemoteId.Dispatch]: Definitions.ServerToClientEvent<[actions: BroadcastAction[]]>(),
		[RemoteId.Start]: Definitions.ClientToServerEvent(),
	}),
	[RemoteId.Click]: Definitions.ClientToServerEvent(),
});

export default remotes;
