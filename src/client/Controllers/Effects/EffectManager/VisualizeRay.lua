local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local lifeTime = 0.8

local function CreatePart()
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
    part.Transparency = 0.2
    part.CastShadow = false
    part.BrickColor = BrickColor.Yellow()
    return part
end

local function VisualizeRay(origin: Vector3, lookVector: Vector3, range: number)
    local part = CreatePart()

    local halfRange = range / 2
    part.Size = Vector3.new(0.2, 0.2, range)
    part.CFrame = CFrame.new(origin + lookVector * halfRange, origin + lookVector)

    local tween = TweenService:Create(part, TweenInfo.new(lifeTime, Enum.EasingStyle.Bounce), {
        Transparency = 1,
        Size = Vector3.new(0.01, 0.01, range),
    })
    tween:Play()

    part.Parent = workspace
    Debris:AddItem(part, lifeTime)
end


return {
    Fire = VisualizeRay
}