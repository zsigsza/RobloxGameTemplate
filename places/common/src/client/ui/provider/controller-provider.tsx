import { CameraController } from "common/client/controllers/camera-controller";
import React, { createContext, useMemo } from "@rbxts/react";
import { Dependency } from "@flamework/core";

interface ControllerContext {
	camera: CameraController;
}

export const ControllerContext = createContext<ControllerContext | undefined>(undefined);

export function ControllerProvider({ children }: React.PropsWithChildren) {
	const value = useMemo<ControllerContext>(() => ({ camera: Dependency<CameraController>() }), []);

	return <ControllerContext.Provider value={value}>{children}</ControllerContext.Provider>;
}
