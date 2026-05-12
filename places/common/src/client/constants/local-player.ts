import { MockPlayer } from "common/shared/mocks/player";
import { IS_EDIT } from "common/shared/constants/game";
import { Players } from "@rbxts/services";

export const LocalPlayer = IS_EDIT ? MockPlayer() : Players.LocalPlayer;
