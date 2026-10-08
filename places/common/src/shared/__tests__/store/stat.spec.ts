/// <reference types="@rbxts/testez/globals" />

import { selectPlayerClicks, statsSlice } from "common/shared/store/player/stat";
import { SharedState } from "common/shared/store";

const PLAYER = "Alice";
const OTHER_PLAYER = "Bob";

const data: PlayerSave = { purchases: { recentPurchases: [] }, stats: { clicks: 5 } };

export = () => {
	beforeEach(() => statsSlice.resetState());
	afterEach(() => statsSlice.resetState());

	describe("statsSlice", () => {
		it("loads and closes player data", () => {
			statsSlice.loadPlayerData(PLAYER, data);
			expect(statsSlice.getState()[PLAYER]).to.equal(data.stats);

			statsSlice.closePlayerData(PLAYER);
			expect(statsSlice.getState()[PLAYER]).to.equal(undefined);
		});

		it("counts clicks", () => {
			statsSlice.loadPlayerData(PLAYER, data);

			statsSlice.click(PLAYER);
			statsSlice.click(PLAYER);

			expect(statsSlice.getState()[PLAYER]?.clicks).to.equal(7);
		});

		it("adds an amount of clicks", () => {
			statsSlice.loadPlayerData(PLAYER, data);

			statsSlice.addClick(PLAYER, 100);

			expect(statsSlice.getState()[PLAYER]?.clicks).to.equal(105);
		});

		it("ignores players whose data isn't loaded", () => {
			statsSlice.click(PLAYER);

			expect(statsSlice.getState()[PLAYER]).to.equal(undefined);
		});

		it("doesn't touch other players", () => {
			statsSlice.loadPlayerData(PLAYER, data);
			statsSlice.loadPlayerData(OTHER_PLAYER, data);

			statsSlice.click(PLAYER);

			expect(statsSlice.getState()[OTHER_PLAYER]?.clicks).to.equal(5);
		});

		it("never mutates the previous state", () => {
			statsSlice.loadPlayerData(PLAYER, data);
			const before = statsSlice.getState();

			statsSlice.click(PLAYER);

			expect(before[PLAYER]?.clicks).to.equal(5);
			expect(data.stats.clicks).to.equal(5);
		});
	});

	describe("selectPlayerClicks", () => {
		const selectFor = (name: string) =>
			selectPlayerClicks(name)({ player: { stats: statsSlice.getState(), purchases: {} } } as SharedState);

		it("defaults to zero without data", () => {
			expect(selectFor(PLAYER)).to.equal(0);
		});

		it("selects the clicks of a player", () => {
			statsSlice.loadPlayerData(PLAYER, data);

			expect(selectFor(PLAYER)).to.equal(5);
			expect(selectFor(OTHER_PLAYER)).to.equal(0);
		});
	});
};
