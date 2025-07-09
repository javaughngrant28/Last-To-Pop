

local GunAPI = require(script.Parent.GunAPI)
local Gun = require(script.Parent.Gun)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)


local Maid: MaidModule.Maid = MaidModule.new()

local CreateSignal = GunAPI._CreateSignal()
local DestroySignal = GunAPI._DestroySignal()



local function CreateGun(player: Player)
    Maid[player.Name] = Gun.new(player)
end

local function Destroy(playerName: string)
    Maid[playerName] = nil
end


CreateSignal:Connect(CreateGun)
DestroySignal:Connect(Destroy)
