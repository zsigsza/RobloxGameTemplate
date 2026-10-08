import { useViewport } from "@rbxts/pretty-react-hooks";
import { Workspace } from "@rbxts/services";
import { useState } from "@rbxts/react";

type Orientation = "landscape" | "portrait";

function getOrientation(viewport: Vector2): Orientation {
	return viewport.Y > viewport.X ? "portrait" : "landscape";
}

export function useOrientation(): Orientation {
	const [orientation, setOrientation] = useState<Orientation>(() => {
		const camera = Workspace.CurrentCamera;
		return camera ? getOrientation(camera.ViewportSize) : "landscape";
	});

	useViewport((viewport) => {
		setOrientation(getOrientation(viewport));
	});

	return orientation;
}
