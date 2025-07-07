

-- ModelUtil.lua

local ModelUtil = {}

-- Helper function to get uniform scale factor
local function getScaleFactor(partSize: Vector3, modelSize: Vector3): number
	-- Calculate scale ratio for each axis
	local scaleX = partSize.X / modelSize.X
	local scaleY = partSize.Y / modelSize.Y
	local scaleZ = partSize.Z / modelSize.Z
	
	-- Return the *smallest* scale factor to ensure the model fits within the part
	return math.min(scaleX, scaleY, scaleZ)
end

function ModelUtil.ScaleToPartSize(model: Model, targetPart: BasePart): Model
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

return ModelUtil
