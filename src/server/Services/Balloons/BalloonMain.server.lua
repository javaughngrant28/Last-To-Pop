
local BalloonAPI = require(script.Parent.BalloonAPI)
local Balloon = require(script.Parent.Balloon)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)


local CreateSignal = BalloonAPI._CreateSignal()

local Maid: MaidModule.Maid = MaidModule.new()



local function Create(part: Part, player: Player?)
    Maid[player.Name] = Balloon.new(part,player)
end



CreateSignal:Connect(Create)

