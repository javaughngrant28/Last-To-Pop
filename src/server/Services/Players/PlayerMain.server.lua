
local Players = game:GetService("Players")

local PlayerAPI = require(game.ServerScriptService.Services.Players.PlayerAPI)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)
local BalloonAPI = require(game.ServerScriptService.Services.Balloons.BalloonAPI)
local WeaponAPI = require(game.ServerScriptService.Services.Weapons.WeaponAPI)
local CharacterSetup = require(script.Parent.CharacterSetup)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Maid: MaidModule.Maid = MaidModule.new()

local PLayerLoadedSignal = PlayerAPI.GetPlayerLoadedSignal()
local PLayerRemovingSignal = PlayerAPI.GetPlayerRemovingSignal()


local function onCharacterAdded(character: Model, player: Player)
    local ballonEquipped = player:FindFirstChild('Balloon',true):: StringValue

    BalloonAPI.Create(character,ballonEquipped.Value)
    WeaponAPI.Create(player)
    CharacterSetup.Fire(character)
end

local function onPlayerAdded(player: Player)
    local playerLoaded = player:WaitForChild('FinishedLoading',20):: BoolValue
    if not playerLoaded then return end

    playerLoaded.Value = true
    PLayerLoadedSignal:Fire(player)

    CharacterEvents.Spawn(onCharacterAdded,player)
end

local function onPlayerRemoving(player: Player)
    PLayerRemovingSignal:Fire(player)
    local playerName = player.Name

    print(playerName)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
