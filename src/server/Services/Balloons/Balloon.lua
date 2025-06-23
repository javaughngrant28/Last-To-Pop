local Players = game:GetService("Players")


export type BalloonType = {
	MODEl: Model,

	new: (object: Model | Part, modelName: string)-> BalloonType,
	Pop: ()-> (),
	Destroy: ()->(),
}


local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local SoundUtil = require(game.ReplicatedStorage.Shared.Utils.SoundUtil)
local ParticleUtil = require(game.ReplicatedStorage.Shared.Utils.ParticleUtil)
local Ragdoll = require(game.ServerScriptService.Modules.Ragdoll)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local Ballons = game.ReplicatedStorage.Assets.Balloons
local Effect = game.ReplicatedStorage.Assets.Effects['Hit Effect'] :: Model



local Balloon = {}
Balloon.__index = Balloon

Balloon.MODEL = nil

Balloon._REFRENCE_MODEL = nil
Balloon._ROOT_PART = nil
Balloon._PARENT_INSTANCE = nil
Balloon._PLAYER = nil
Balloon._POP_FORCE = 8

Balloon._MAID = nil

function Balloon.new(object: Model | Part, modelName: string)
	local self = setmetatable({}, Balloon)
	
	self:__Constructor(object, modelName)
	return self
end


function Balloon:__Constructor(object: Model | Part, modelName: string)

	assert(object and object:IsA('BasePart') or object:IsA('Model'),`{object} Invalid`)
	
	if object:IsA('Model') then
		assert(object.PrimaryPart,`{object} Model Has No PrimaryPart`)
	end

	local BalloonModel = Ballons:FindFirstChild(modelName) :: Model
	assert(BalloonModel,`{object} {modelName} Balloon Model Not Found`)
	assert(
		BalloonModel:IsA('Model') and BalloonModel.PrimaryPart,
		`{BalloonModel} Has No PrimaryPart Or Is Not A Model`
	)

	self._MAID = MaidModule.new()
	self._PLAYER = Players:GetPlayerFromCharacter(object) or nil
	self._REFRENCE_MODEL = BalloonModel
	self._ROOT_PART = object:IsA('Model') and object:FindFirstChild('HumanoidRootPart')  or object:IsA('Model') and object.PrimaryPart or object
	self._PARENT_INSTANCE = object

	self:_AutoDestroy()
	self:_AttachToCharacter()
end


function Balloon:Pop()

	local model = self._MAID['Model'] :: Model
	local forceFeild = self._PARENT_INSTANCE:FindFirstChildWhichIsA('ForceField')
	local positionPopped = model.PrimaryPart.CFrame.Position
	local popSound = model:FindFirstChild('Pop',true) :: Sound?

	if forceFeild then return end
	
	if popSound then
		SoundUtil.PlayAtPosition(popSound,positionPopped)
	end

	ParticleUtil.EmitParticlesAtPosition(Effect,positionPopped)

	model.PrimaryPart:SetAttribute('Balloon',nil)

	for _, part:BasePart in model:GetChildren()do
		if part:IsA('BasePart') then
			part.Transparency = 1
			part.CanTouch = false
			part.CanCollide = false
		end
	end

	self._MAID['VectorForce'] = nil
	self._MAID['LinearVelocity'] = nil

	local humanoidRootPart = self._PARENT_INSTANCE:FindFirstChild('HumanoidRootPart') :: Part
	local humanoid = self._PARENT_INSTANCE:FindFirstChildWhichIsA('Humanoid',true) :: Humanoid?
	local player = self._PLAYER :: Player?

	-- if humanoidRootPart then
	-- 	Ragdoll.Enable(self._PARENT_INSTANCE)
	-- 	task.delay(1,Ragdoll.Disable,self._PARENT_INSTANCE)
	-- end

	if humanoid then
		humanoid.Health = 0
	end

	if player then
		RemoteUtil.FireClient('Pop',player,positionPopped,self._POP_FORCE)
	end
	
end


function Balloon:_AttachToCharacter()
	local model = self._REFRENCE_MODEL:Clone() :: Model
	self._MAID['Model'] = model
	self.MODEL = model
	
	local ropeConstraint = model:FindFirstChildWhichIsA('RopeConstraint',true) :: RopeConstraint
	local modelAttachment = model.PrimaryPart:FindFirstChildWhichIsA('Attachment',true	) :: Attachment
	local modelMass =  model.PrimaryPart:GetMass()
	
	local rootPart = self._ROOT_PART :: Part
	local rootAttachment = self._PARENT_INSTANCE:FindFirstChild('Head') and self._PARENT_INSTANCE.Head:FindFirstChild('HatAttachment') or rootPart:FindFirstChildWhichIsA('Attachment',true) :: Attachment
	
	local VectorForce = Instance.new('VectorForce')
	self._MAID['VectorForce'] = VectorForce
	VectorForce.Parent = model.PrimaryPart
	VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
	VectorForce.Attachment0 = modelAttachment
	VectorForce.Force = Vector3.new(0, workspace.Gravity * (modelMass * 8), 0)
	
	local linearVelocity = Instance.new('LinearVelocity')
	self._MAID['LinearVelocity'] = linearVelocity
	linearVelocity.Parent = model.PrimaryPart
	linearVelocity.Attachment0 = modelAttachment
	linearVelocity.VectorVelocity = Vector3.new(0,0,0)
	linearVelocity.MaxForce = 40
	
	local angularVelocity = Instance.new("BodyAngularVelocity")
	self._MAID['BodyAngularVelocity'] = angularVelocity
	angularVelocity.AngularVelocity = Vector3.new()
	angularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
	angularVelocity.Parent = model.PrimaryPart
	
	ropeConstraint.Attachment0 = rootAttachment
	ropeConstraint.Attachment1 = modelAttachment
	ropeConstraint.Length = 2.4
	ropeConstraint.Enabled = true
	
	model.Name = self._PARENT_INSTANCE.Name
	model.PrimaryPart:SetAttribute('Balloon',true)
	model.PrimaryPart.BrickColor =  BrickColor.random()
	task.wait()
	model.Parent = workspace:FindFirstChild('Balloons')
end

function Balloon:_AutoDestroy()
	local parnetInstance = self._PARENT_INSTANCE :: Model | Part
	self._MAID['Distroying'] = parnetInstance.AncestryChanged:Connect(function()
		if parnetInstance.Parent == nil then
			self:Destroy()
		end
	end)
end

function Balloon:Destroy()
	self._MAID:Destroy()
	for index, _ in pairs(self) do
		self[index] = nil
	end
end

return Balloon