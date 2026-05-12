export interface OnPlayerJoin {
	onPlayerJoin(player: Player): void;
}

export interface OnPlayerLeave {
	onPlayerLeave(player: Player): void;
}

export interface OnPlayerClick {
	onPlayerClick(player: Player): void;
}
