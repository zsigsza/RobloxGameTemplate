import React, { PropsWithChildren, InstanceProps, forwardRef, Ref } from "@rbxts/react";
import { BindingOrValue } from "@rbxts/pretty-react-hooks";

export interface ImageProps extends PropsWithChildren {
	/** Optional corner radius */
	CornerRadius?: BindingOrValue<UDim>;
	/** The image to display. */
	Image: BindingOrValue<string>;
}

/**
 * A component for displaying an image.
 *
 * @example
 *
 * ```tsx
 * <ImageLabel
 * 	Image="rbxassetid://1234567890"
 * 	native={{
 * 		Size={new UDim2(0, 100, 0, 100)}
 * 	}}
 * />;
 * ```
 *
 * @component
 *
 * @see https://developer.roblox.com/en-us/api-reference/class/ImageLabel
 */
const Image = forwardRef((props: Readonly<InstanceProps<ImageLabel>>, ref: Ref<ImageLabel>) => {
	return (
		<imagelabel
			BackgroundTransparency={1}
			ResampleMode={"Pixelated"}
			Image={props.Image}
			BorderSizePixel={0}
			ScaleType={"Fit"}
			ref={ref}
			{...props}
		>
			{props.children}
		</imagelabel>
	);
});
export default Image;
