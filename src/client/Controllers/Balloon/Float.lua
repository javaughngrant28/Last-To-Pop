local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Maids = {} :: {
	[Part]: MaidModule.Maid
}


local function MakeObjectFloat(hoverPart: Part, object: Part, maxDistance: number)
	if Maids[object] then return end

	local Maid = MaidModule.new()
	Maids[object] = Maid

	local attachment0 = Instance.new("Attachment")
	Maid['a0'] = attachment0
	attachment0.Name = "Att0"
	attachment0.Parent = hoverPart
	attachment0.CFrame = CFrame.new(0,maxDistance,0)

	local attachment1 = Instance.new("Attachment")
	Maid['a1'] = attachment1
	attachment1.Name = "Att1"
	attachment1.Parent = object

	local alignPosition = Instance.new("AlignPosition")
	Maid['AlignPosition'] = alignPosition
	alignPosition.Attachment0 = attachment1
	alignPosition.Attachment1 = attachment0
	alignPosition.MaxForce = math.huge
	alignPosition.Responsiveness = 2
	alignPosition.ApplyAtCenterOfMass = true
	alignPosition.Parent = object

	Maid:GiveTask(object.AncestryChanged:Connect(function(_, parent)
		if not parent then
			Maid[object]:Destroy()
		end
	end))

	Maid:GiveTask(hoverPart.AncestryChanged:Connect(function(_, parent)
		if not parent then
			Maid[object]:Destroy()
		end
	end))
end


return {
	Fire = MakeObjectFloat
}
