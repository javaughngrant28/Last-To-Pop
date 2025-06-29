


local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local PlayerBalloon = require(script.Parent.PlayerBalloon)
local SpawnCharacter = require(game.ServerScriptService.Components.SpawnCharacter)


local lobbyFolder = workspace.Lobby
local lobbySpawnLoactions = lobbyFolder:FindFirstChild('SpawnLoactions')



local LobbyCharacter = {}
LobbyCharacter.__index = LobbyCharacter

LobbyCharacter._MAID = nil
LobbyCharacter._PLAYER = nil
LobbyCharacter._PLAYER_BALLOON = nil



function LobbyCharacter.new(player: Player)
    local self = setmetatable({}, LobbyCharacter)
    self:__Constructor(player)
    return self
end


function LobbyCharacter:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player
    
    SpawnCharacter.Spawn(self._PLAYER,lobbySpawnLoactions)

    local Balloon = PlayerBalloon.new(player)
    self._PLAYER_BALLOON = Balloon
    self._MAID['Balloon'] = Balloon
end



function LobbyCharacter:Destroy()
    self._MAID:Destroy()

    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return LobbyCharacter
