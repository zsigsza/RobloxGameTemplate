import { CharacterController } from "common/client/controllers/character-controller";
import { Controller, OnRender, OnStart } from "@flamework/core";
import { UserInputService, Workspace } from "@rbxts/services";
import Spring from "@rbxts/spring";

const BASE_FOV = 70;
const MAX_FOV = 90;
const MAX_SPEED = 100;

@Controller({})
export class CameraController implements OnRender, OnStart {
	cameraOffset = new Vector3(2, 1, 0);

	private velocityBasedFOV = true;
	private velocityBasedCameraDelay = true;
	private movementTilt = true;
	private cameraLock = true;

	private fieldOfView = BASE_FOV;
	private movementTiltCFrame = new CFrame();
	private assemblyLinearVelocity = Vector3.zero;
	private readonly velocitySpring = new Spring<Vector3>(Vector3.zero, 8, Vector3.zero, 0.25);

	constructor(private readonly characterController: CharacterController) {}

	onStart() {
		this.setCameraLock(false);
	}

	setMouseLock(lock: boolean) {
		UserInputService.MouseBehavior = lock ? Enum.MouseBehavior.LockCenter : Enum.MouseBehavior.Default;
		UserInputService.MouseIconEnabled = !lock;
	}

	setCameraLock(lock: boolean) {
		this.setMouseLock(lock);
		this.characterController.setAutoRotate(!lock);
		this.cameraLock = lock;
		this.movementTilt = lock;
	}

	setSubject(subject: BasePart) {
		const camera = Workspace.CurrentCamera;
		if (!camera) return;

		if (camera.CameraSubject !== subject) {
			camera.CameraSubject = subject;
		}
	}

	onRender(dt: number): void {
		const { rootJoint, humanoid, rootPart, head } = this.characterController;
		if (!humanoid || !rootPart || !rootJoint || !head) return;

		const camera = Workspace.CurrentCamera;
		if (!camera) return;

		this.setSubject(head);

		const velocity = rootPart.AssemblyLinearVelocity;

		if (this.velocityBasedCameraDelay) {
			this.velocitySpring.goal = velocity.mul(0.05);
			this.assemblyLinearVelocity = this.velocitySpring.update(dt);
		}

		if (this.velocityBasedFOV) {
			const speedAlpha = math.clamp(velocity.Magnitude / MAX_SPEED, 0, 1);

			this.fieldOfView = math.lerp(this.fieldOfView, BASE_FOV + speedAlpha * (MAX_FOV - BASE_FOV), dt);
			camera.FieldOfView = this.fieldOfView;
		}

		const lookVector = camera.CFrame.LookVector;

		if (this.movementTilt) {
			const max = math.min(6 + (humanoid.WalkSpeed ^ 2) / 8, 45);
			const moveDirection = rootPart.CFrame.VectorToObjectSpace(humanoid.MoveDirection);

			this.movementTiltCFrame = this.movementTiltCFrame.Lerp(
				CFrame.Angles(
					math.clamp(-lookVector.Y, -0.35, 0.35) + math.rad(-moveDirection.Z) * max,
					math.rad(-moveDirection.X) * max,
					0,
				),
				math.min(dt * 12, 1),
			);

			rootJoint.C0 = CFrame.Angles(math.rad(90), math.rad(180), 0).mul(this.movementTiltCFrame);
		}

		if (this.cameraLock) {
			// Looking straight up or down leaves no horizontal direction to face.
			const flatLookVector = new Vector3(lookVector.X, 0, lookVector.Z);
			if (flatLookVector.Magnitude > 0.001) {
				rootPart.CFrame = rootPart.CFrame.Lerp(
					new CFrame(rootPart.Position, rootPart.Position.add(flatLookVector.Unit)),
					math.min(dt * 18, 1),
				);
			}

			camera.PivotTo(
				camera.CFrame.add(camera.CFrame.VectorToWorldSpace(this.cameraOffset)).sub(this.assemblyLinearVelocity),
			);
		}
	}
}
