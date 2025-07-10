



-- Helper function to get uniform scale factor
local function getScaleFactor(partSize: Vector3, modelSize: Vector3): number
	-- Calculate scale ratio for each axis
	local scaleX = partSize.X / modelSize.X
	local scaleY = partSize.Y / modelSize.Y
	local scaleZ = partSize.Z / modelSize.Z
	
	-- Return the *smallest* scale factor to ensure the model fits within the part
	return math.min(scaleX, scaleY, scaleZ)
end

local function ScaleToPartSize(model: Model, targetPart: BasePart): Model
	assert(model and model:IsA("Model"), "First argument must be a Model.")
	assert(targetPart and targetPart:IsA("BasePart"), "Second argument must be a BasePart.")
	
	-- Get model size
	local modelSize = model:GetExtentsSize()
	local partSize = targetPart.Size

	-- Compute scale factor
	local scaleFactor = getScaleFactor(partSize, modelSize)

	-- Scale
	model:ScaleTo(scaleFactor)
end

local function CreateWild(p1: BasePart?, p0: BasePart?) : Motor6D
    assert(p1 and p0)
    local moter6D = Instance.new('Motor6D')
    moter6D.Part0 = p0
    moter6D.Part1 = p1
    return moter6D
end

local function WeldToPart(part: Part, model: Model)
	local weld = CreateWild(model.PrimaryPart, part) :: Motor6D
     weld.Parent = model.PrimaryPart
end

return {
	ScaleToPartSize = ScaleToPartSize,
	WeldToPart = WeldToPart
}
