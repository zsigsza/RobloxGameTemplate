import { Modding } from "@flamework/core";

/** @metadata macro */
export class Lifecycle<T extends Record<never, (...args: unknown[]) => void>> {
	private readonly listeners = new Set<T>();

	constructor(public id?: Modding.Generic<T, "id">) {
		assert(id);
	}

	public register() {
		Modding.onListenerAdded(this.add, this.id);
		Modding.onListenerRemoved(this.delete, this.id);
	}

	public add(obj: object) {
		this.listeners.add(obj as T);
	}

	public delete(obj: object) {
		this.listeners.delete(obj as T);
	}

	public emit(callback: (listener: T) => void) {
		for (const listener of this.listeners) task.spawn(() => callback(listener));
	}

	public connect<A extends unknown[]>(
		signal: RBXScriptSignal<(...args: A) => void>,
		callback: (listener: T, ...args: A) => void,
	) {
		return signal.Connect((...args: A) => {
			this.emit((l) => callback(l, ...args));
		});
	}
}
