import { RootProvider } from "common/client/ui/provider/root-provider";
import { createPortal, createRoot } from "@rbxts/react-roblox";
import { Controller, OnStart } from "@flamework/core";
import React, { StrictMode } from "@rbxts/react";
import { store } from "common/client/store";
import { Players } from "@rbxts/services";
import App from "common/client/ui/app";

@Controller({})
export class GuiController implements OnStart {
	onStart() {
		const root = createRoot(new Instance("Folder"));
		const target = Players.LocalPlayer.WaitForChild("PlayerGui");

		root.render(
			createPortal(
				<StrictMode>
					<RootProvider store={store}>
						<App />
					</RootProvider>
				</StrictMode>,
				target,
			),
		);
	}
}
