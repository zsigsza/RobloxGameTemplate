/// <reference types="@rbxts/testez/globals" />

import { selectPlayerData } from "common/shared/store/player/player-selectors";
import { playerSlice } from "common/shared/store/player";
import { SharedState } from "common/shared/store";

const PLAYER = "Alice";

const data: PlayerSave = { purchases: { recentPurchases: ["a"] }, stats: { clicks: 3 } };

export = () => {
	const state = () => ({ player: playerSlice.getState() }) as SharedState;

	beforeEach(() => playerSlice.resetState());
	afterEach(() => playerSlice.resetState());

	describe("selectPlayerData", () => {
		it("is undefined until the player's data is loaded", () => {
			expect(selectPlayerData(PLAYER)(state())).to.equal(undefined);
		});

		it("round trips the loaded data", () => {
			playerSlice.loadPlayerData(PLAYER, data);

			const saved = selectPlayerData(PLAYER)(state());
			expect(saved).to.be.ok();
			expect(saved?.stats.clicks).to.equal(3);
			expect(saved?.purchases.recentPurchases[0]).to.equal("a");
		});

		it("reflects changes made through actions", () => {
			playerSlice.loadPlayerData(PLAYER, data);
			playerSlice.click(PLAYER);
			playerSlice.addRecentPurchase(PLAYER, "b");

			const saved = selectPlayerData(PLAYER)(state());
			expect(saved?.stats.clicks).to.equal(4);
			expect(saved?.purchases.recentPurchases.size()).to.equal(2);
		});

		it("is undefined again once the data is closed", () => {
			playerSlice.loadPlayerData(PLAYER, data);
			playerSlice.closePlayerData(PLAYER);

			expect(selectPlayerData(PLAYER)(state())).to.equal(undefined);
		});
	});
};
