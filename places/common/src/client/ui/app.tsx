import { selectPlayerClicks } from "common/shared/store/player/stat";
import { localPlayer } from "common/client/constants/local-player";
import remotes, { RemoteId } from "common/shared/remotes";
import { useRem } from "common/client/ui/hooks/use-rem";
import Layer from "common/client/ui/primitives/layer";
import { useSelector } from "@rbxts/react-reflex";
import React, { useMemo } from "@rbxts/react";

export default function App() {
	const rem = useRem();

	// A stable selector keeps useSelector from resubscribing on every render.
	const selectClicks = useMemo(() => selectPlayerClicks(localPlayer.Name), []);
	const count = useSelector(selectClicks);

	return (
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
	);
}
