local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local lifeTime = 0.6

local function CreatePart()
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
    part.Transparency = 0.2
    part.CastShadow = false
    part.BrickColor = BrickColor.White()
    return part
end

local function VisualizeRay(rayData: any)
    local part = CreatePart()

    local Spawn = rayData['Spawn']['Value'] :: Attachment
    local TargetPosition = rayData['TargetPosition'] :: Vector3Value

    local origin = Spawn.WorldCFrame.Position
    local goal = TargetPosition.Value

    local direction = (goal - origin)
    local distance = direction.Magnitude
    local lookVector = direction.Unit

    part.Size = Vector3.new(0.6, 0.6, distance)
    part.CFrame = CFrame.new(origin + lookVector * (distance / 2), goal)

    part.Parent = workspace

    local tween = TweenService:Create(part, TweenInfo.new(lifeTime, Enum.EasingStyle.Sine), {
        Transparency = 1,
        Size = Vector3.new(0.01, 0.01, distance),
    })
    tween:Play()

    Debris:AddItem(part, lifeTime)
end

return {
    new = VisualizeRay
}
