import { selectPlayerClicks } from "common/shared/store/player/stat";
import { localPlayer } from "common/client/constants/local-player";
import remotes, { RemoteId } from "common/shared/remotes";
import { useRem } from "common/client/ui/hooks/use-rem";
import Layer from "common/client/ui/primitives/layer";
import { useSelector } from "@rbxts/react-reflex";
import React from "@rbxts/react";

export default function App() {
	const rem = useRem();

	const count = useSelector(selectPlayerClicks(localPlayer.Name));

	return (
		<>
			<Layer clampUltraWide={true}>
				<frame Size={UDim2.fromOffset(rem(0.5), rem(0.5))} Position={UDim2.fromScale(0.5, 0.5)} />
				<textbutton
					Event={{
						Activated: () => {
							remotes.Client.Get(RemoteId.Click).SendToServer();
						},
					}}
					Size={UDim2.fromOffset(rem(4), rem(2))}
					Position={UDim2.fromScale(0.5, 0.5)}
					AnchorPoint={new Vector2(0.5, 0.5)}
					Text={`Clicks: ${count}`}
				/>
			</Layer>
		</>
	);
}
