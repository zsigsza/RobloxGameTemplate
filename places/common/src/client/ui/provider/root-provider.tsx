import { RemProviderProps, RemProvider } from "common/client/ui/provider/rem-provider";
/**
 * https://github.com/littensy/slither/blob/main/src/client/providers/root-provider.tsx
 */
import { ReflexProvider } from "@rbxts/react-reflex";
import { Producer } from "@rbxts/reflex";
import React from "@rbxts/react";

export interface RootProviderProps {
	store: Producer;
}

export function RootProvider({ remOverride, children, baseRem, store }: RootProviderProps & RemProviderProps) {
	return (
		<ReflexProvider producer={store}>
			<RemProvider remOverride={remOverride} baseRem={baseRem}>
				{children}
			</RemProvider>
		</ReflexProvider>
	);
}
