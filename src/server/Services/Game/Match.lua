local Players = game:GetService("Players")

local Loadouts = require(game.ServerScriptService.Modules.Loadouts.LoadoutManager)

local participatingPlayers = {} :: {Player}



local function UpdatePlayerLoadout(player: Player,loadoutName: string)
    Loadouts.Remove(player.Name)
    Loadouts.Create(player,loadoutName)
end

local function AddLobbyCharactersToMatch()
    for _, player: Player in Players:GetChildren() do
        local isPlaying  = player:FindFirstChild('IsPlaying') :: BoolValue
        if not isPlaying then continue end
        
        isPlaying.Value = true
        table.insert(participatingPlayers,player)

        if not player.Character then continue end
        UpdatePlayerLoadout(player,'Combat')
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

local function EndMatch()
    for _, player: Player in Players:GetChildren() do
         local isPlaying  = player:FindFirstChild('IsPlaying') :: BoolValue
         local hearts = player:FindFirstChild('Hearts') :: NumberValue
         
         if not isPlaying then continue end
         if isPlaying.Value and player.Character then
            UpdatePlayerLoadout(player,'LobbyCharacter')
        end
        
        hearts.Value = 2
    end
end


function StarMatch()
    AddLobbyCharactersToMatch()
end

return {
    Start = StarMatch,
    CharacterDied = CharacterDied,
    End = EndMatch,
}