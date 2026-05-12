import { IS_STUDIO } from "common/shared/constants/game";
import { Flamework } from "@flamework/core";

const old = os.clock();

Flamework.addPaths("../common/src/server/services");
Flamework.addPaths("../common/src/server/components");
Flamework.addPaths("../common/src/server/hooks");
Flamework.addPaths("../common/src/server/deps");

Flamework.addPaths("../common/src/shared/components");
Flamework.addPaths("../common/src/shared/deps");

Flamework.addPaths("src/shared/deps");

Flamework.addPaths("src/server/services");
Flamework.addPaths("src/server/components");
Flamework.addPaths("src/server/hooks");
Flamework.addPaths("src/server/deps");

Flamework.ignite();

if (IS_STUDIO) {
	print(`Initialized flamework server in ${os.clock() - old}`);
}
