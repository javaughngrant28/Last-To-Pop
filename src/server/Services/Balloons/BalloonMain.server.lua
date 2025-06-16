



local Balloon = require(script.Parent.Balloon)
local BalloonAPI = require(script.Parent.BalloonAPI)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Maid: MaidModule.Maid = MaidModule.new()

local CreateSignal = BalloonAPI.CreateSignal()



local function Create(player: Player)
    local equippedBalloon= player:FindFirstChild('Balloon',true) :: StringValue
    assert(player,`{player} Has No Character`)

    Maid[player.Name] = Balloon.new(player,equippedBalloon.Value)
end

CreateSignal:Connect(Create)


