import React, { PropsWithChildren, InstanceProps, forwardRef, Ref } from "@rbxts/react";
import { Corner } from "common/client/ui/primitives/corner";
import { BindingOrValue } from "@rbxts/pretty-react-hooks";

export interface ImageProps extends InstanceProps<ImageLabel>, PropsWithChildren {
	/** Optional corner radius, in pixels (scaled by rem). */
	CornerRadius?: BindingOrValue<number>;
}

/**
 * A component for displaying an image.
 *
 * @example
 *
 * ```tsx
 * <Image Image="rbxassetid://1234567890" Size={new UDim2(0, 100, 0, 100)} CornerRadius={8} />;
 * ```
 *
 * @component
 *
 * @see https://developer.roblox.com/en-us/api-reference/class/ImageLabel
 */
const Image = forwardRef((props: Readonly<ImageProps>, ref: Ref<ImageLabel>) => {
	// `CornerRadius` isn't an ImageLabel property, so don't forward it.
	const imageProps = { ...props, CornerRadius: undefined, children: undefined };

	return (
		<imagelabel
			BackgroundTransparency={1}
			ResampleMode={"Pixelated"}
			BorderSizePixel={0}
			ScaleType={"Fit"}
			ref={ref}
			{...imageProps}
		>
			{props.CornerRadius !== undefined ? <Corner radius={props.CornerRadius} /> : undefined}
			{props.children}
		</imagelabel>
	);
});
export default Image;
