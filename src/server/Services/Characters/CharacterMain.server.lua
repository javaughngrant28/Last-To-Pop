

local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)
local FunctionUtil = require(game.ReplicatedStorage.Shared.Utils.FunctionUtil)
local PlayerAPI = require(game.ServerScriptService.Services.Players.PlayerAPI)



local playerLoaded = PlayerAPI.GetPlayerLoadedSignal()

local function SetCollisionGroup(model: Model)
    FunctionUtil.SetCollisionGroup(model,'Char')
end

local function onCharacterAdded(character: Model, player: Player)
    SetCollisionGroup(character)
end



local function onPlayerLoaded(player: Player)
    CharacterEvents.Spawn(onCharacterAdded,player)
    CharacterEvents.Loaded(SetCollisionGroup,player)

    task.wait(2)
    player:LoadCharacter()
end


playerLoaded:Connect(onPlayerLoaded)

