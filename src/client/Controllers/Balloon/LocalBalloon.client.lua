local Players = game:GetService("Players")

local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)
local Float = require(script.Parent.Float)

local Maid: MaidModule.Maid = MaidModule.new()
local player = Players.LocalPlayer
local TRANSPARENCY = 0.8


local function balloonInstance(instance: Instance)

    if instance:IsA('Beam') then
        local beam = instance :: Beam
        beam.Transparency = NumberSequence.new(TRANSPARENCY)
    end

    if not instance:IsA('BasePart') then return end
    local part = instance :: BasePart
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false

    if part.Transparency >= TRANSPARENCY then return end
    part.Transparency = TRANSPARENCY
end

local function BalloonGiven(balloon: Model)
    Maid['ChildAdded'] = balloon.DescendantAdded:Connect(balloonInstance)
    for _, instance: Instance in balloon:GetDescendants() do
        balloonInstance(instance)
    end

    local head = player.Character:WaitForChild('Head',10)
    Float.Fire(head,balloon.PrimaryPart,4)
end


RemoteUtil.OnClient('Balloon',BalloonGiven)



