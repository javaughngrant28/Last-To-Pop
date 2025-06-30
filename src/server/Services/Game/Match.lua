local Players = game:GetService("Players")

local Loadouts = require(game.ServerScriptService.Modules.Loadouts.LoadoutManager)

local participatingPlayers = {} :: {Player}



local function UpdatePlayerLoadout(player: Player)
    Loadouts.Remove(player.Name)
    Loadouts.Create(player,'Combat')
end

local function AddLobbyCharactersToMatch()
    for _, player: Player in Players:GetChildren() do
        local isPlaying  = player:FindFirstChild('IsPlaying') :: BoolValue
        if not isPlaying then continue end
        
        isPlaying.Value = true
        table.insert(participatingPlayers,player)

        if not player.Character then continue end
        UpdatePlayerLoadout(player)
    end
end

local function CharacterDied(player: Player)
    local isPlaying  = player:FindFirstChild('IsPlaying') :: BoolValue
    local hearts = player:FindFirstChild('Hearts') :: NumberValue

    hearts.Value -= 1

    if hearts.Value <= 0 then
        isPlaying.Value = false
    end
end


function StarMatch()
    AddLobbyCharactersToMatch()
end

return {
    Start = StarMatch,
    CharacterDied = CharacterDied,
}