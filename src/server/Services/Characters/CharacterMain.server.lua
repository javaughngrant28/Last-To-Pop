

local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)
local FunctionUtil = require(game.ReplicatedStorage.Shared.Utils.FunctionUtil)
local PlayerAPI = require(game.ServerScriptService.Services.Players.PlayerAPI)
local GunAPI = require(game.ServerScriptService.Services.Guns.GunAPI)



local playerLoaded = PlayerAPI.GetPlayerLoadedSignal()

local function SetCollisionGroup(model: Model)
    FunctionUtil.SetCollisionGroup(model,'Char')
end

local function onCharacterAdded(character: Model, player: Player)

    GunAPI.Create(player)
    SetCollisionGroup(character)
end



local function onPlayerLoaded(player: Player)
    CharacterEvents.Spawn(onCharacterAdded,player)
    CharacterEvents.Loaded(SetCollisionGroup,player)

    task.wait(2)
    player:LoadCharacter()
end


playerLoaded:Connect(onPlayerLoaded)

