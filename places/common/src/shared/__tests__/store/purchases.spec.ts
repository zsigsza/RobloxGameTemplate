/// <reference types="@rbxts/testez/globals" />

import { selectPlayerRecentPurchases, purchasesSlice } from "common/shared/store/player/purchases";
import { RECENT_PURCHASES_LIMIT } from "common/shared/constants/flags";
import { SharedState } from "common/shared/store";

const PLAYER = "Alice";

const data: PlayerSave = { purchases: { recentPurchases: ["a", "b"] }, stats: { clicks: 0 } };

export = () => {
	beforeEach(() => purchasesSlice.resetState());
	afterEach(() => purchasesSlice.resetState());

	describe("purchasesSlice", () => {
		it("loads and closes player data", () => {
			purchasesSlice.loadPlayerData(PLAYER, data);
			expect(purchasesSlice.getState()[PLAYER]).to.equal(data.purchases);

			purchasesSlice.closePlayerData(PLAYER);
			expect(purchasesSlice.getState()[PLAYER]).to.equal(undefined);
		});

		it("records purchases in order", () => {
			purchasesSlice.loadPlayerData(PLAYER, data);

			purchasesSlice.addRecentPurchase(PLAYER, "c");

			const recent = purchasesSlice.getState()[PLAYER]?.recentPurchases;
			expect(recent?.size()).to.equal(3);
			expect(recent?.[2]).to.equal("c");
		});

		it("ignores players whose data isn't loaded", () => {
			purchasesSlice.addRecentPurchase(PLAYER, "c");

			expect(purchasesSlice.getState()[PLAYER]).to.equal(undefined);
		});

		it("only keeps the newest purchases", () => {
			purchasesSlice.loadPlayerData(PLAYER, { ...data, purchases: { recentPurchases: [] } });

			for (const index of $range(1, RECENT_PURCHASES_LIMIT + 5)) {
				purchasesSlice.addRecentPurchase(PLAYER, `purchase-${index}`);
			}

			const recent = purchasesSlice.getState()[PLAYER]!.recentPurchases;
			expect(recent.size()).to.equal(RECENT_PURCHASES_LIMIT);
			expect(recent[0]).to.equal("purchase-6");
			expect(recent[RECENT_PURCHASES_LIMIT - 1]).to.equal(`purchase-${RECENT_PURCHASES_LIMIT + 5}`);
		});
	});

	describe("selectPlayerRecentPurchases", () => {
		const selectFor = (name: string) =>
			selectPlayerRecentPurchases(name)({
				player: { purchases: purchasesSlice.getState(), stats: {} },
			} as SharedState);

		it("defaults to an empty list", () => {
			expect(selectFor(PLAYER).size()).to.equal(0);
		});

		it("selects the purchases of a player", () => {
			purchasesSlice.loadPlayerData(PLAYER, data);

			expect(selectFor(PLAYER).size()).to.equal(2);
		});
	});
};
