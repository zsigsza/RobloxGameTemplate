import React, { forwardRef } from "@rbxts/react";

interface GroupProps extends React.PropsWithChildren {
	clipsDescendants?: React.Binding<boolean> | boolean;
	anchorPoint?: React.Binding<Vector2> | Vector2;
	layoutOrder?: React.Binding<number> | number;
	visible?: React.Binding<boolean> | boolean;
	change?: React.InstanceChangeEvent<Frame>;
	rotation?: React.Binding<number> | number;
	position?: React.Binding<UDim2> | UDim2;
	zIndex?: React.Binding<number> | number;
	size?: React.Binding<UDim2> | UDim2;
	event?: React.InstanceEvent<Frame>;
	ref?: React.Ref<Frame>;
}

/**
 * Group.
 *
 * @example
 *
 * ```tsx
 * <Group>
 * 	<Button/>
 * 	<Button/>
 * 	<Button/>
 * </Group>
 * ```
 *
 * @param {GroupProps} - The properties of the Group component.
 * @returns The rendered Group component.
 * @component
 *
 */
const Group = forwardRef((props: GroupProps, ref: React.Ref<Frame>) => {
	return (
		<frame
			Size={props.size || UDim2.fromScale(1, 1)}
			ClipsDescendants={props.clipsDescendants}
			AnchorPoint={props.anchorPoint}
			LayoutOrder={props.layoutOrder}
			BackgroundTransparency={1}
			Position={props.position}
			Rotation={props.rotation}
			Visible={props.visible}
			ZIndex={props.zIndex}
			Change={props.change}
			Event={props.event}
			ref={ref}
		>
			{props.children}
		</frame>
	);
});
export default Group;
