import { RootProvider } from "common/client/ui/provider/root-provider";
import { CreateReactStory } from "@rbxts/ui-labs";
import ReactRoblox from "@rbxts/react-roblox";
import { store } from "common/client/store";
import React from "@rbxts/react";

export = CreateReactStory({ reactRoblox: ReactRoblox, react: React }, () => {
	return (
		<RootProvider store={store}>
			<textbutton
				Position={UDim2.fromScale(0.5, 0.5)}
				AnchorPoint={new Vector2(0.5, 0.5)}
				Size={UDim2.fromScale(0.2, 0.05)}
				Text={"Label"}
			/>
		</RootProvider>
	);
});
