export function getHumanoid(
	playerOrModel: Player | Model,
): LuaTuple<[humanoid: undefined | Humanoid, character: undefined | Model]> {
	let character: undefined | Model;
	if (playerOrModel.IsA("Model")) {
		character = playerOrModel;
	} else {
		character = playerOrModel.Character || playerOrModel.CharacterAdded.Wait()[0];
	}

	if (!character) return $tuple(undefined, undefined);

	const humanoid = character.FindFirstChildOfClass("Humanoid");
	if (!humanoid) return $tuple(undefined, undefined);

	return $tuple(humanoid, character);
}
