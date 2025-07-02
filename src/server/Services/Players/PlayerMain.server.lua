
local Players = game:GetService("Players")

local PlayerAPI = require(game.ServerScriptService.Services.Players.PlayerAPI)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)


local Maid: MaidModule.Maid = MaidModule.new()

local PLayerLoadedSignal = PlayerAPI.GetPlayerLoadedSignal()
local PLayerRemovingSignal = PlayerAPI.GetPlayerRemovingSignal()



local function onPlayerAdded(player: Player)
    local playerLoaded = player:WaitForChild('FinishedLoading',20):: BoolValue
    if not playerLoaded then return end

    playerLoaded.Value = true
    PLayerLoadedSignal:Fire(player)
end

local function onPlayerRemoving(player: Player)
    PLayerRemovingSignal:Fire(player)
    local playerName = player.Name

    print(playerName..'Removing')
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
