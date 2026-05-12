export interface OnPlayerJoin {
	onPlayerJoin(player: Player): void;
}

export interface OnPlayerLeave {
	onPlayerLeave(player: Player): void;
}

export interface OnLocalCharacterAdded {
	onLocalCharacterAdded(character: Model): void;
}

export interface OnLocalCharacterRemoving {
	onLocalCharacterRemoving(character: Model): void;
}
