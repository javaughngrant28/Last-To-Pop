local Players = game:GetService("Players")

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)


local InteractionsFolder = workspace.Interactions
local Chest1 = InteractionsFolder:WaitForChild('Chest1',10) :: Model


local Player = Players.LocalPlayer

local Maid: MaidModule.Maid = MaidModule.new()


local function onPromtTriggered()
    
end


local function onDescendantAdded(instance: Instance)
    if not instance:IsA('ProximityPrompt') then return end
    local Prompt = instance :: ProximityPrompt

    Maid['Triggered'] = Prompt.Triggered:Connect(onPromtTriggered)
end


Chest1.DescendantAdded:Connect(onDescendantAdded)

