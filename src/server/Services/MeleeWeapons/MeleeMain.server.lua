

local MeeleeAPI = require(script.Parent.MeleeAPI)
local Katana = require(script.Parent.Katana)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)


local CreateSignal = MeeleeAPI._CreateSignal()
local DestroySignal = MeeleeAPI._DestroySignal()

local Maid: MaidModule.Maid = MaidModule.new()



local function Create(player: Player)
    Maid[player.Name] = Katana.new(player)
end

local function Destroy(playerName: string)
    Maid[playerName] = nil
end



DestroySignal:Connect(Destroy)
CreateSignal:Connect(Create)

