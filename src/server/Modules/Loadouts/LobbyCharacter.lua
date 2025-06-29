


local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local PlayerBalloon = require(script.Parent.PlayerBalloon)
local Position = require(game.ServerScriptService.Components.Position)


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

    self:_SpawnCharacter()

    local Balloon = PlayerBalloon.new(player)
    self._PLAYER_BALLOON = Balloon
    self._MAID['Balloon'] = Balloon

end


function LobbyCharacter:_SpawnCharacter()
    local player = self._PLAYER :: Player
    player:LoadCharacter()

    local character = player.Character or player.CharacterAdded:Wait()
    Position.AtRandomPartInFolder(character,lobbySpawnLoactions)
end

function LobbyCharacter:Destroy()
    self._MAID:Destroy()

    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return LobbyCharacter
