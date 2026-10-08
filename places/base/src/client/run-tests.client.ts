import { ReplicatedStorage, StarterPlayer, RunService } from "@rbxts/services";
import { TestBootstrap, Reporters } from "@rbxts/testez";

/** Folders that don't exist yet (no tests written) are skipped. */
function findTestRoots(containers: Instance[]): Instance[] {
	const roots = new Array<Instance>();
	for (const container of containers) {
		const root = container.FindFirstChild("__tests__");
		if (root) roots.push(root);
	}

	return roots;
}

if (!RunService.IsRunning()) {
	const playerScripts = StarterPlayer.WaitForChild("StarterPlayerScripts");
	const results = TestBootstrap.run(
		findTestRoots([
			playerScripts.WaitForChild("TS"),
			playerScripts.WaitForChild("common"),
			ReplicatedStorage.WaitForChild("TS"),
			ReplicatedStorage.WaitForChild("common"),
		]),
		Reporters.TextReporter,
	);
	if (results.errors.size() > 0 || results.failureCount > 0) {
		error("Tests failed!");
	}
}
