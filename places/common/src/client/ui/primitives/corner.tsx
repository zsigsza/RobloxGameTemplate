import { getBindingValue, BindingOrValue } from "@rbxts/pretty-react-hooks";
import { useRem } from "common/client/ui/hooks/use-rem";
import React from "@rbxts/react";

interface CornerProps {
	radius: BindingOrValue<number>;
}

/**
 * A React component that renders a UI corner with a customizable radius.
 *
 * @remarks
 * This component is used to apply a corner radius to UI elements.
 *
 * @param props - The properties for the Corner component.
 * @param props.Radius - The radius of the corner in pixels.
 *
 * @returns - A React element representing a UI corner with the specified radius.
 *
 * @example
 * ```tsx
 * <Corner Radius={10} />
 * ```
 */
export function Corner({ radius }: CornerProps) {
	const rem = useRem();
	return <uicorner CornerRadius={new UDim(0, rem(getBindingValue(radius), "pixel"))} />;
}
