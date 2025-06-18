
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")



local function Fire(position: Vector3, lookVector: Vector3, range: number)
	local duration = 1
	local part = Instance.new("Part")
	local tween = TweenService:Create(part, TweenInfo.new(duration), { Transparency = 1 })

	part.Shape = Enum.PartType.Block
	part.Size = Vector3.new(0.2, 0.2, range)
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 255, 0)
	part.CFrame = CFrame.new(position + lookVector * (range / 2), position + lookVector * range)
	part.Parent = workspace
	
	tween:Play()
	Debris:AddItem(part, duration)
end

return {
	Fire = Fire
}
