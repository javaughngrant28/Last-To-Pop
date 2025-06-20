local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Balloons = workspace:WaitForChild('Balloons',10)
local TRANSPARENCY = 0.4


local function BalloonFound(balloon: Model)
    for _, instance: Instance in balloon:GetDescendants() do
        
        if not instance:IsA('BasePart') then continue end
        instance.CanCollide = false
        instance.CanTouch = false
        instance.CanQuery = false

        if instance.Transparency >= TRANSPARENCY then continue end
        instance.Transparency = TRANSPARENCY
    end
end


local function BallonAdded(Balloon: Model)
    if Balloon:IsA('Model') and Balloon.Name == player.Name then
        BalloonFound(Balloon)
    end
end


Balloons.ChildAdded:Connect(BallonAdded)

for _, balloon: Model in Balloons:GetChildren() do
    BallonAdded(balloon)    
end



