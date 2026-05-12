import { CharacterController } from "common/client/controllers/character-controller";
import { Controller, OnRender, OnStart } from "@flamework/core";
import { UserInputService, Workspace } from "@rbxts/services";
import Spring from "@rbxts/spring";

@Controller({})
export class CameraController implements OnRender, OnStart {
	cameraOffset = new Vector3(2, 1, 0);

	constructor(private characterController: CharacterController) {}

	private velocityBasedFOV = true;
	private velocityBasedCameraDelay = true;
	private movementTilt = true;
	private cameraLock = true;

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

	private baseFOV = 70;
	private maxSpeed = 100;
	private maxFOV = 90;
	private fieldOfView = this.baseFOV;

	private assemblyLinearVelocity = Vector3.zero;
	private movementTiltCFrame = new CFrame();

	setSubject(subject: BasePart) {
		const camera = Workspace.CurrentCamera;
		if (!camera) return;

		if (camera.CameraSubject !== subject) {
			camera.CameraSubject = subject;
		}
	}

	onRender(dt: number): void {
		if (!this.characterController.character) return;
		if (!this.characterController.humanoid) return;
		if (!this.characterController.rootPart) return;
		if (!this.characterController.rootJoint) return;
		if (!this.characterController.head) return;

		this.setSubject(this.characterController.head);

		const rootPart = this.characterController.rootPart;

		if (this.velocityBasedCameraDelay) {
			// TODO: Avoid making new springs each time
			const spring = new Spring<Vector3>(
				this.assemblyLinearVelocity,
				8,
				rootPart.AssemblyLinearVelocity.mul(0.05),
				0.25,
			);

			this.assemblyLinearVelocity = spring.update(dt);
		}

		const camera = Workspace.CurrentCamera;
		if (!camera) return;

		if (this.velocityBasedFOV) {
			const speed = rootPart.AssemblyLinearVelocity.Magnitude;

			this.fieldOfView = math.lerp(
				this.fieldOfView,
				this.baseFOV + (speed / this.maxSpeed) * (this.maxFOV - this.baseFOV),
				dt,
			);
			camera.FieldOfView = this.fieldOfView;
		}

		const humanoid = this.characterController.humanoid;
		const walkSpeed = humanoid.WalkSpeed;
		const walkSpeedModifier = (walkSpeed ^ 2) / 8;

		const lookVector = camera.CFrame.LookVector;
		if (this.movementTilt) {
			const max = math.min(6 + walkSpeedModifier, 45);

			const moveDirection = rootPart.CFrame.VectorToObjectSpace(humanoid.MoveDirection);

			this.movementTiltCFrame = this.movementTiltCFrame.Lerp(
				CFrame.Angles(
					math.clamp(-lookVector.Y, -0.35, 0.35) + math.rad(-moveDirection.Z) * max,
					math.rad(-moveDirection.X) * max,
					0,
				),
				dt * 12,
			);

			this.characterController.rootJoint.C0 = CFrame.Angles(math.rad(90), math.rad(180), 0).mul(
				this.movementTiltCFrame,
			);
		}

		if (this.cameraLock) {
			const flatLookVector = new Vector3(lookVector.X, 0, lookVector.Z).Unit;
			rootPart.CFrame = rootPart.CFrame.Lerp(
				new CFrame(rootPart.Position, rootPart.Position.add(flatLookVector)),
				dt * 18,
			);

			camera.PivotTo(
				camera.CFrame.add(camera.CFrame.VectorToWorldSpace(this.cameraOffset)).sub(this.assemblyLinearVelocity),
			);
		}
	}
}
