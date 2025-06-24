
local INSTANCE_NAME = 'Ragdoll'
local RagdolledModels = {} :: {[Model]: true}

local function ActivateRagdoll(model: Model)
	RagdolledModels[model] = true
	
	local humanoid = model:FindFirstChildWhichIsA('Humanoid',true) :: Humanoid
	humanoid.BreakJointsOnDeath = false

	for _, value in ipairs(model:GetDescendants()) do
		if value.ClassName ~= 'Motor6D' then continue end
		local moter6D: Motor6D = value
		local moter6DPart0 = moter6D.Part0 :: Part
		local moter6DPart1 = moter6D.Part1 :: Part
		local jointName = moter6D.Name

		local attachment0: Attachment = Instance.new('Attachment',moter6DPart0)
		local attachment1: Attachment = Instance.new('Attachment',moter6DPart1)
		attachment0.CFrame = moter6D.C0
		attachment1.CFrame = moter6D.C1

		attachment0.Name = INSTANCE_NAME
		attachment1.Name = INSTANCE_NAME

		local ballSocketConstraint = Instance.new('BallSocketConstraint',moter6D.Parent)
		ballSocketConstraint.Attachment0 = attachment0
		ballSocketConstraint.Attachment1 = attachment1

		ballSocketConstraint.Name = INSTANCE_NAME
		moter6D.Enabled = false
	end
	
	humanoid.Sit = true
end


local function DeactivateRagdoll(model: Model)
	local humanoid = model:FindFirstChild('Humanoid') :: Humanoid
	
	for _, instance in ipairs(model:GetDescendants()) do
		if instance.Name == INSTANCE_NAME then instance:Destroy() continue end
		if instance.ClassName ~= 'Motor6D' then continue end
		local moter6D: Motor6D = instance
		moter6D.Enabled = true
	end
	
	humanoid.Sit = false
	RagdolledModels[model] = nil
end


local Ragdoll = {}

function Ragdoll.Enable(target: Model)
	-- task.defer(ActivateRagdoll,target)
	ActivateRagdoll(target)
end

-- Return of target is already ragdoll
function Ragdoll.GetState(target: Model): boolean
	return RagdolledModels[target] ~= nil
end

function Ragdoll.Disable(target: Model)
	task.defer(DeactivateRagdoll,target)
end

function Ragdoll.DisableOnTread(target: Model)
	DeactivateRagdoll(target)
end

return Ragdoll