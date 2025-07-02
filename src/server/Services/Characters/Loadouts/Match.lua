
local GunAPI = require(game.ServerScriptService.Services.Gun.GunAPI)
local BalloonAPI = require(game.ServerScriptService.Services.Balloons.BalloonAPI)

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local MatchLoadout = {}
MatchLoadout.__index = MatchLoadout

MatchLoadout._MAID = nil
MatchLoadout._PLAYER = nil



function MatchLoadout.new(player: Player)
    local self = setmetatable({}, MatchLoadout)
    self:__Constructor(player)
    return self
end


function MatchLoadout:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player

    self:_CreatBalloon()
    self:_CreatGun()
end



function MatchLoadout:_CreatGun()
    GunAPI.Create(self._PLAYER)
end

function MatchLoadout:_CreatBalloon()
    local character = self._PLAYER.Character :: Model
    assert(character,`{self._PLAYER} Has No Charaacter Model`)

    local Head = character:FindFirstChild('Head') :: Part
    assert(Head, `{character} Has No Head`)

    BalloonAPI.Create(Head)
end



function MatchLoadout:Destroy()

    self._MAID:Destroy()
    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return MatchLoadout