import { UserInputService } from "@rbxts/services";

/** A fake player used for testing */
export function MockPlayer(userId = -1): Player {
	return {
		GetMouse() {
			const mouseLocation = UserInputService.GetMouseLocation();
			return { X: mouseLocation.X, Y: mouseLocation.Y };
		},
		Character: {
			Humanoid: {
				MaxHealth: 100,
				Health: 50,
			},
		} as { Humanoid: Humanoid } | Model,
		DisplayName: "Test Player",
		ClassName: "Player",
		Name: "testPlayer",
		UserId: userId,
	} as Player;
}
