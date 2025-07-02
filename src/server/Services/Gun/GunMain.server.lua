
local bulletsFolder = workspace:FindFirstChild("BulletFolder") or Instance.new("Folder", workspace)
bulletsFolder.Name = "BulletFolder"

local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local Gun = require(script.Parent.Gun)

local BalloonAPI = require(game.ServerScriptService.Services.Balloons.BalloonAPI)
local GunAPI = require(script.Parent.GunAPI)


local Maid: MaidModule.Maid = MaidModule.new()



local CreateSignal = GunAPI._CreateSignal()
local GunEvent: NameSpaceEvent.Server = NameSpaceEvent.new('Gun',{'Shoot','PopConfirm'})



local function Create(player: Player)
    Maid[player.Name] = Gun.new(player)
end



CreateSignal:Connect(Create)
