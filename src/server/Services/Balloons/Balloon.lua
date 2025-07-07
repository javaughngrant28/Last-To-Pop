local Players = game:GetService("Players")

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local SoundUtil = require(game.ReplicatedStorage.Shared.Utils.SoundUtil)
local ParticleUtil = require(game.ReplicatedStorage.Shared.Utils.ParticleUtil)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)
local AttachModel = require(game.ServerScriptService.Components.AttachModel)
local ModelUtil = require(game.ReplicatedStorage.Shared.Utils.ModelUtil)

local PopSound = game.ReplicatedStorage.Assets.Sounds.Balloon.Pop1
local Effect = game.ReplicatedStorage.Assets.Effects['Hit Effect'] :: Model
local BalloonModelFolder = game.ReplicatedStorage.Assets.Models.Balloons :: Folder



export type BalloonType = {
	MODEL: Model,
	HITBOX: Part,

	new: (part: Part, modelName: string?)-> BalloonType,
	UpdateModel: (self: BalloonType, modelName: string)-> nil,
	Pop: ()-> (),
	Destroy: (self: BalloonType, BalloonType)->(),
}



local Balloon = {}
Balloon.__index = Balloon


Balloon._PLAYER = nil
Balloon._MAID = nil

Balloon._POP_FORCE = 8


Balloon.SIZE = Vector3.new(3.8,3.8,3.8)
Balloon.HITBOX_SCALE = 1.6
Balloon.HIGHT_OFFSET = 5
Balloon.BEAM_WDITH = 0.1

Balloon.MODEL = nil
Balloon.HITBOX = nil
Balloon.PART = nil



function Balloon.new(part: Part,modelName: string?): BalloonType
	local self = setmetatable({}, Balloon)
	self:__Constructor(part)

	return self
end


function Balloon:__Constructor(part: Part, modelName: string?)
	assert(part and part:IsA('BasePart'),`{part} Invalid BasePart`)
	
	self.PART = part
	self._MAID = MaidModule.new()
	self._PLAYER = Players:GetPlayerFromCharacter(part.Parent)

	local model = Instance.new('Model')
	model.Name = 'Balloon'
	model.Parent = workspace
	self.MODEL = model
	self._MAID['Model'] = model

	local attachment = Instance.new('Attachment')
	attachment.Name = 'BalloonAttachment'
	attachment.Parent = part
	attachment.CFrame = CFrame.new(0,part.Size.Y / 2,0)

	local sphere = self:_CreateBall()
	sphere.Position = attachment.WorldCFrame.Position + Vector3.new(0,self.HIGHT_OFFSET + self.SIZE.Y / 2,0)
	sphere.Parent = model
	model.PrimaryPart = sphere
	self._MAID['Sphere'] = sphere

	local beam = self:_CreateBeam(sphere:FindFirstChildWhichIsA('Attachment',true),attachment)
	beam.Parent = sphere
	self._MAID['Beam'] = beam

	local hitbox = self:_CreateHitbox(sphere,self.HITBOX_SCALE)
	hitbox.Parent = model
	self.HITBOX = hitbox
	self._MAID['Hitbox'] = hitbox

	self:_AutoCleanup()

	if modelName then
		self:UpdateModel(modelName)
	end
end


function Balloon:Pop()
	local model = self.MODEL:: Model
	local positionPopped = model.PrimaryPart.CFrame.Position

	SoundUtil.PlayAtPosition(PopSound,positionPopped)
	ParticleUtil.EmitParticlesAtPosition(Effect,positionPopped)

	model:Destroy()

	if self._PLAYER then
		local character = self._PLAYER.Character
		local humanoid = character:FindFirstChild('Humanoid') :: Humanoid

		humanoid.Health = 0
		RemoteUtil.FireClient(self._PLAYER,'Pop',positionPopped,self._POP_FORCE)
	end
end

function Balloon:UpdateModel(modelName: string)
	local model = BalloonModelFolder:FindFirstChild(modelName) :: Model
	assert(model,`{modelName} Balloon Model Not Found`)

	local modelClone = model:Clone() :: Model
	self._MAID['Cosmetic Model'] = modelClone
	modelClone.Parent = workspace

	ModelUtil.ScaleToPartSize(modelClone,self.MODEL.PrimaryPart)
	AttachModel.ToPart(self.MODEL.PrimaryPart,modelClone)

	if self._PLAYER then
		modelClone.PrimaryPart:SetNetworkOwner(self._PLAYER)
	end
end


function Balloon:_AutoCleanup()
	local Part = self.PART :: Part

	Part.AncestryChanged:Connect(function(_, parent)
		if parent == nil then
			self:Destroy()
		end
	end)
end

function Balloon:_CreateBall(): Part
	local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = self.SIZE
	sphere.CanCollide = false
	sphere.CanTouch = false
	sphere.CanQuery = false
	sphere.CastShadow = false
    sphere.Anchored = true
	sphere.Massless = true
	sphere.Transparency = 1
    sphere.Color = Color3.fromRGB(255, 0, 0)
    
    local attachment = Instance.new("Attachment")
    attachment.Name = "Attachment1"
    attachment.Position = Vector3.new(0, -self.SIZE.Y / 2, 0)
    attachment.Parent = sphere
    
    return sphere
end

function Balloon:_CreateBeam(a1: Attachment, a0: Attachment): Beam
	local beam = Instance.new('Beam')
	beam.Color = ColorSequence.new(Color3.new(1, 1, 1))
	beam.LightInfluence = 0
	beam.LightEmission = 1
	beam.Segments = 1
	beam.Transparency = NumberSequence.new(0)
	beam.Attachment0 = a0
	beam.Attachment1 = a1
	beam.FaceCamera = true
	beam.Width0 = self.BEAM_WDITH
	beam.Width1 = self.BEAM_WDITH
	return beam
end

function Balloon:_CreateHitbox(part: Part, scale: number?): Part
	local scale = scale or 1

	local hitbox = Instance.new("Part")
    hitbox.Name = "Hitbox"
    hitbox.Anchored = false
    hitbox.CanCollide = false
	hitbox.CastShadow = false
    hitbox.Massless = true
    hitbox.Size = part.Size * scale
	hitbox.Transparency = 1
	hitbox:SetAttribute('Balloon',true)

	hitbox.CFrame = part.CFrame

	local constraint = Instance.new("WeldConstraint")
    constraint.Part0 = part
    constraint.Part1 = hitbox
    constraint.Parent = hitbox

	return hitbox
end



function Balloon:Destroy()
	if self['_MAID'] then
		self._MAID:Destroy()
	end

	for index, _ in pairs(self) do
		self[index] = nil
	end
end

return Balloon