
local BalloonModels = game.ReplicatedStorage.Assets.Models.Balloons
local ModelUtil = require(game.ReplicatedStorage.Shared.Utils.ModelUtil)
local AttachModel = require(game.ServerScriptService.Components.AttachModel)



 type BalloonData = {
    Size: Vector3,
    CosmeticName: string,
    HitboxScale: number,
    Part: number,
}



local function CreatPart(): Part
    local part = Instance.new('Part')
    part.Transparency = 0.8
    part.CanTouch = false
    part.CanCollide = false
    part.CanQuery = false
    part.CastShadow = false
    part.Anchored = false
    return part
end

local function CreatHitbox(size: Vector3, scale: number)
    local part = CreatPart()
    part.Name = 'HitBox'
    part.Size = size * scale
    part.CanQuery = true
    part.CanCollide = true
    part.CollisionGroup = 'HitBox'
    part:SetAttribute('BalloonHitBox',true)
    return part
end

local function CreateInnerPart(size: Vector3): (Part, Attachment)
    local part = CreatPart()
    part.Anchored = true
    part.BrickColor = BrickColor.new('Really red')
    part.Size = size
    return part
end

local function CreateBeam(part0: Part, part1: Part): Beam
    local Attachment0 = Instance.new('Attachment',part0)
    Attachment0.CFrame = CFrame.new(0,-(part0.Size.Y / 2),0)

    local Attachment1 = Instance.new('Attachment',part1)
    Attachment1.CFrame = CFrame.new(0,part1.Size.Y / 2,0)

    local beam = Instance.new('Beam')
    beam.LightInfluence = 0
    beam.Transparency = NumberSequence.new(0)
    beam.Segments = 1
    beam.FaceCamera = true
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.Attachment0 = Attachment0
    beam.Attachment1 = Attachment1

    return beam
end




local function CreateBalloon(data: BalloonData) : (Model,Model)
    local CosmeticModel = BalloonModels:FindFirstChild(data.CosmeticName) :: Model
    assert(CosmeticModel,`{data.CosmeticName} Not In Balloon Models`)

    local cosmeticClone = CosmeticModel:Clone() :: Model
    local newModel = Instance.new('Model')

    local innerPart = CreateInnerPart(data.Size)
    innerPart.Parent = newModel
    newModel.PrimaryPart = innerPart

    local hitBox = CreatHitbox(data.Size,data.HitboxScale)
    hitBox.Parent = newModel

    local beam = CreateBeam(innerPart,data.Part)
    beam.Parent = innerPart

    ModelUtil.ScaleToPartSize(cosmeticClone,innerPart)
    AttachModel.ToPart(innerPart,cosmeticClone)
   AttachModel.Rig(innerPart,newModel)

   return newModel, cosmeticClone
end



return {
    Fire = CreateBalloon
}
