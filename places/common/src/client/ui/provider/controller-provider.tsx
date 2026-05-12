import { CameraController } from "common/client/controllers/camera-controller";
import React, { createContext, Element } from "@rbxts/react";
import { Dependency } from "@flamework/core";

interface ControllerContext {
	camera: CameraController;
}

export const ControllerContext = createContext<ControllerContext | undefined>(undefined);

export function ControllerProvider({ children }: { children: Element }) {
	const camera = Dependency<CameraController>();

	return <ControllerContext.Provider value={{ camera }}>{children}</ControllerContext.Provider>;
}
