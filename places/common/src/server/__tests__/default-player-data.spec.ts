/// <reference types="@rbxts/testez/globals" />

import { defaultPlayerData } from "common/server/constants/default-player-data";
import { Flamework } from "@flamework/core";

// The same guard DocumentStore uses to validate saved data.
const isPlayerSave = Flamework.createGuard<PlayerSave>();

export = () => {
	describe("defaultPlayerData", () => {
		it("is valid save data", () => {
			expect(isPlayerSave(defaultPlayerData)).to.equal(true);
		});

		it("rejects data that is missing fields", () => {
			expect(isPlayerSave({ stats: { clicks: 0 } })).to.equal(false);
			expect(isPlayerSave({ purchases: { recentPurchases: [] }, stats: { clicks: "many" } })).to.equal(false);
		});

		it("starts without clicks or purchases", () => {
			expect(defaultPlayerData.stats.clicks).to.equal(0);
			expect(defaultPlayerData.purchases.recentPurchases.size()).to.equal(0);
		});
	});
};
