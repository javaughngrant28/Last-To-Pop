local Players = game:GetService("Players")


local UIDetector = require(script.Parent.Parent.Modules.UIDetector)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Maid: MaidModule.Maid = MaidModule.new()

local Player = Players.LocalPlayer




local function HeartsScreenAdded(screen: ScreenGui)
    local Hearts = Player:FindFirstChild('Hearts') :: NumberValue
    local textLable = screen:FindFirstChildWhichIsA('TextLabel',true) :: TextLabel

    textLable.Text = `{Hearts.Value}`

    Maid['ValueChanged'] = Hearts:GetPropertyChangedSignal('Value'):Connect(function()
        textLable.Text = `{Hearts.Value}`
    end)

    Maid:GiveTask(screen.AncestryChanged:Connect(function(_, Parent)
        if not Parent then
           Maid:DoCleaning() 
        end
    end))
end



UIDetector.new('Hearts',HeartsScreenAdded)


