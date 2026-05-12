import { RunService } from "@rbxts/services";

export const GAME_NAME = "TESTING PLACE";

export const IS_EDIT = RunService.IsStudio() && !RunService.IsRunning();
export const IS_SERVER = RunService.IsServer();
export const IS_STUDIO = RunService.IsStudio();

export const HRP = "HumanoidRootPart";
