interface PlayerSave {
	readonly purchases: PlayerPurchases;
	readonly stats: PlayerStats;
}

interface PlayerStats {
	readonly clicks: number;
}

interface PlayerPurchases {
	readonly recentPurchases: Array<string>;
}
