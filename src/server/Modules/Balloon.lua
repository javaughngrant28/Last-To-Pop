

export type BalloonType = {
	new: (player: Player, modelName: string)-> BalloonType,
	Destroy: ()->(),
}


local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local Ballons = game.ReplicatedStorage.Assets.Balloons



local Balloon = {}
Balloon.__index = Balloon

Balloon._CHARACTER = nil
Balloon._MODEL = nil

Balloon._MAID = nil

function Balloon.new(player: Player, modelName: string)
	local self = setmetatable({}, Balloon)
	
	self:__Constructor(player, modelName)
	return self
end


function Balloon:__Constructor(player: Player, modelName: string)
	local charaacter = player.Character
	assert(charaacter,`{player} Has No Character`)

	local BalloonModel = Ballons:FindFirstChild(modelName) :: Model
	assert(BalloonModel,`{player} {modelName} Balloon Model Not Found`)
	assert(
		BalloonModel:IsA('Model') and BalloonModel.PrimaryPart,
		`{BalloonModel} Has No PrimaryPart Or Is Not A Model`
	)

	self._CHARACTER = charaacter
	self._MODEL = BalloonModel
	self._MAID = MaidModule.new()
	
	self:_AttachToCharacter()
end


function Balloon:_AttachToCharacter()
	local model = self._MODEL:Clone() :: Model
	self._MAID['Model'] = model
	
	local ropeConstraint = model:FindFirstChildWhichIsA('RopeConstraint',true) :: RopeConstraint
	local modelAttachment = model.PrimaryPart:FindFirstChildWhichIsA('Attachment',true	) :: Attachment
	local modelMass =  model.PrimaryPart:GetMass()
	
	local character = self._CHARACTER :: Model
	local torso = character:WaitForChild('Torso',5)
	local backAttachment = torso:WaitForChild('BodyBackAttachment',5)
	
	
	local VectorForce = Instance.new('VectorForce')
	VectorForce.Parent = model.PrimaryPart
	VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
	VectorForce.Attachment0 = modelAttachment
	VectorForce.Force = Vector3.new(0, workspace.Gravity * (modelMass * 1.4), 0)
	
	local linearVelocity = Instance.new('LinearVelocity')
	linearVelocity.Parent = model.PrimaryPart
	linearVelocity.Attachment0 = modelAttachment
	linearVelocity.VectorVelocity = Vector3.new(0,0,0)
	linearVelocity.MaxForce = 4
	
	local angularVelocity = Instance.new("BodyAngularVelocity")
	angularVelocity.AngularVelocity = Vector3.new()
	angularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
	angularVelocity.Parent = model.PrimaryPart
	
	ropeConstraint.Attachment0 = backAttachment
	ropeConstraint.Attachment1 = modelAttachment
	ropeConstraint.Enabled = true
	
	model.Parent = workspace
end


function Balloon:Destroy()

	self._MAID:Destroy()
	for index, _ in pairs(self) do
		self[index] = nil
	end
end

return Balloon