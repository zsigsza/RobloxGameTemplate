import { Trove } from "@rbxts/trove";

export abstract class Hook {
	constructor() {}

	trove = new Trove();
	connected = false;
	registered = false;

	protected abstract registerHook(): void;
	protected abstract connectHook(): void;
	protected disconnectHook(): void {}

	/**
	 * Consumer function, **DON'T OVERRIDE**.
	 */
	public readonly disconnect: () => void = () => {
		this.trove.clean();
		this.disconnectHook();
		this.connected = false;
	};

	/**
	 * Consumer function, **DON'T OVERRIDE**.
	 */
	public readonly connect: () => void = () => {
		this.connectHook();
		this.connected = true;
	};

	/**
	 * Consumer function, **DON'T OVERRIDE**.
	 */
	public readonly register: () => void = () => {
		this.registerHook();
		this.registered = true;
	};
}
