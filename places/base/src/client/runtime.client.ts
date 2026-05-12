import { IS_STUDIO } from "common/shared/constants/game";
import { Flamework } from "@flamework/core";
const old = os.clock();

Flamework.addPaths("../common/src/client/controllers");
Flamework.addPaths("../common/src/client/components");
Flamework.addPaths("../common/src/client/hooks");
Flamework.addPaths("../common/src/client/deps");

Flamework.addPaths("../common/src/shared/components");
Flamework.addPaths("../common/src/shared/deps");

Flamework.addPaths("src/shared/deps");

Flamework.addPaths("src/client/controllers");
Flamework.addPaths("src/client/components");
Flamework.addPaths("src/client/hooks");
Flamework.addPaths("src/client/deps");

Flamework.ignite();

if (IS_STUDIO) {
	print(`Initialized flamework client in ${os.clock() - old}`);
}
