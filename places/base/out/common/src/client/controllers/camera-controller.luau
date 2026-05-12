-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Spring = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "spring")
local CameraController
do
	CameraController = setmetatable({}, {
		__tostring = function()
			return "CameraController"
		end,
	})
	CameraController.__index = CameraController
	function CameraController.new(...)
		local self = setmetatable({}, CameraController)
		return self:constructor(...) or self
	end
	function CameraController:constructor(characterController)
		self.characterController = characterController
		self.cameraOffset = Vector3.new(2, 1, 0)
		self.velocityBasedFOV = true
		self.velocityBasedCameraDelay = true
		self.movementTilt = true
		self.cameraLock = true
		self.baseFOV = 70
		self.maxSpeed = 100
		self.maxFOV = 90
		self.fieldOfView = self.baseFOV
		self.assemblyLinearVelocity = Vector3.zero
		self.movementTiltCFrame = CFrame.new()
	end
	function CameraController:onStart()
		self:setCameraLock(false)
	end
	function CameraController:setMouseLock(lock)
		UserInputService.MouseBehavior = if lock then Enum.MouseBehavior.LockCenter else Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = not lock
	end
	function CameraController:setCameraLock(lock)
		self:setMouseLock(lock)
		self.characterController:setAutoRotate(not lock)
		self.cameraLock = lock
		self.movementTilt = lock
	end
	function CameraController:setSubject(subject)
		local camera = Workspace.CurrentCamera
		if not camera then
			return nil
		end
		if camera.CameraSubject ~= subject then
			camera.CameraSubject = subject
		end
	end
	function CameraController:onRender(dt)
		if not self.characterController.character then
			return nil
		end
		if not self.characterController.humanoid then
			return nil
		end
		if not self.characterController.rootPart then
			return nil
		end
		if not self.characterController.rootJoint then
			return nil
		end
		if not self.characterController.head then
			return nil
		end
		self:setSubject(self.characterController.head)
		local rootPart = self.characterController.rootPart
		if self.velocityBasedCameraDelay then
			-- TODO: Avoid making new springs each time
			local spring = Spring.new(self.assemblyLinearVelocity, 8, rootPart.AssemblyLinearVelocity * 0.05, 0.25)
			self.assemblyLinearVelocity = spring:update(dt)
		end
		local camera = Workspace.CurrentCamera
		if not camera then
			return nil
		end
		if self.velocityBasedFOV then
			local speed = rootPart.AssemblyLinearVelocity.Magnitude
			self.fieldOfView = math.lerp(self.fieldOfView, self.baseFOV + (speed / self.maxSpeed) * (self.maxFOV - self.baseFOV), dt)
			camera.FieldOfView = self.fieldOfView
		end
		local humanoid = self.characterController.humanoid
		local walkSpeed = humanoid.WalkSpeed
		local walkSpeedModifier = (bit32.bxor(walkSpeed, 2)) / 8
		local lookVector = camera.CFrame.LookVector
		if self.movementTilt then
			local max = math.min(6 + walkSpeedModifier, 45)
			local moveDirection = rootPart.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
			self.movementTiltCFrame = self.movementTiltCFrame:Lerp(CFrame.Angles(math.clamp(-lookVector.Y, -0.35, 0.35) + math.rad(-moveDirection.Z) * max, math.rad(-moveDirection.X) * max, 0), dt * 12)
			local _exp = CFrame.Angles(math.rad(90), math.rad(180), 0)
			local _movementTiltCFrame = self.movementTiltCFrame
			self.characterController.rootJoint.C0 = _exp * _movementTiltCFrame
		end
		if self.cameraLock then
			local flatLookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
			rootPart.CFrame = rootPart.CFrame:Lerp(CFrame.new(rootPart.Position, rootPart.Position + flatLookVector), dt * 18)
			local _cFrame = camera.CFrame
			local _arg0 = camera.CFrame:VectorToWorldSpace(self.cameraOffset)
			local _assemblyLinearVelocity = self.assemblyLinearVelocity
			camera:PivotTo(_cFrame + _arg0 - _assemblyLinearVelocity)
		end
	end
	do
		-- (Flamework) CameraController metadata
		Reflect.defineMetadata(CameraController, "identifier", "common/src/client/controllers/camera-controller@CameraController")
		Reflect.defineMetadata(CameraController, "flamework:parameters", { "common/src/client/controllers/character-controller@CharacterController" })
		Reflect.defineMetadata(CameraController, "flamework:implements", { "$:flamework@OnRender", "$:flamework@OnStart" })
	end
end
-- (Flamework) CameraController decorators
Reflect.decorate(CameraController, "$:flamework@Controller", Controller, { {} })
return {
	CameraController = CameraController,
}
