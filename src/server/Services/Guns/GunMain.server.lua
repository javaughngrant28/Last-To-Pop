

local GunAPI = require(script.Parent.GunAPI)
local Gun = require(script.Parent.Gun)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)


local Maid: MaidModule.Maid = MaidModule.new()
local GunCreateSignal = GunAPI._CreateSignal()



local function CreateGun(player: Player)
    Maid[player.Name] = Gun.new(player)
end


GunCreateSignal:Connect(CreateGun)
