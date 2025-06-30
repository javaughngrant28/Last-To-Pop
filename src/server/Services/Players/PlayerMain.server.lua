
local Players = game:GetService("Players")

local PlayerAPI = require(game.ServerScriptService.Services.Players.PlayerAPI)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local Loadouts = require(game.ServerScriptService.Modules.Loadouts.LoadoutManager)
local CharacterCleanup = require(script.Parent.CharacterCleanup)

local Maid: MaidModule.Maid = MaidModule.new()

local PLayerLoadedSignal = PlayerAPI.GetPlayerLoadedSignal()
local PLayerRemovingSignal = PlayerAPI.GetPlayerRemovingSignal()




local function onSpawnRequest(player: Player)
    local gameState = game.ReplicatedStorage.GameState
    local isPlaying = player:FindFirstChild('IsPlaying') :: BoolValue

    if gameState.Value == "Match" and isPlaying and isPlaying.Value then
        Loadouts.Create(player,'Combat')
        else
            Loadouts.Create(player,'LobbyCharacter')
    end
end


local function onCharacterDied(character: Model, player: Player)

    task.wait(3)
    CharacterCleanup.Fire(character,player)
    onSpawnRequest(player)
end

local function onCharacterAdded(_,player: Player)
    print(player,'Character Added')
end

local function onPlayerAdded(player: Player)
    local playerLoaded = player:WaitForChild('FinishedLoading',20):: BoolValue
    if not playerLoaded then return end

    playerLoaded.Value = true
    PLayerLoadedSignal:Fire(player)

    CharacterEvents.Spawn(onCharacterAdded,player)
    CharacterEvents.Died(onCharacterDied,player)

    task.wait(4)
    onSpawnRequest(player)
end

local function onPlayerRemoving(player: Player)
    PLayerRemovingSignal:Fire(player)
    local playerName = player.Name

    print(playerName..'Removing')
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
