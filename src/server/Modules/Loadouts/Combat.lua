
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local PlayerBalloon = require(script.Parent.PlayerBalloon)
local SpawnCharacter = require(game.ServerScriptService.Components.SpawnCharacter)

local Tools = game.ReplicatedStorage.Assets.Tools



local Combat = {}
Combat.__index = Combat

Combat._MAID = nil
Combat._PLAYER = nil
Combat._PLAYER_BALLOON = nil



function Combat.new(player: Player)
    local self = setmetatable({}, Combat)
    self:__Constructor(player)
    return self
end


function Combat:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player

    local mapFolder = workspace:FindFirstChild('Map')
    SpawnCharacter.Spawn(self._PLAYER,mapFolder:FindFirstChild('SpawnLoactions'))

    local Balloon = PlayerBalloon.new(player)
    self._PLAYER_BALLOON = Balloon
    self._MAID['Balloon'] = Balloon

    self:CreateGun()
end


function Combat:CreateGun()
    local toolName = 'Gun1'
    local tool = Tools:FindFirstChild(toolName)
    
    local toolClone = tool:Clone()
    self._MAID['Tool'] = toolClone

    toolClone.Parent = self._PLAYER.Backpack
end

function Combat:Destroy()
    self._MAID:Destroy()

    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return Combat
