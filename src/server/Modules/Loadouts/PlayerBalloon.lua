
local BalloonAPI = require(game.ServerScriptService.Services.Balloons.BalloonAPI)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)



local PlayerBalloon = {}
PlayerBalloon.__index = PlayerBalloon

PlayerBalloon._MAID = nil
PlayerBalloon._PLAYER = nil
PlayerBalloon._CHARACTER = nil



function PlayerBalloon.new(player: Player)
    local self = setmetatable({}, PlayerBalloon)
    self:__Constructor(player)
    return self
end


function PlayerBalloon:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player
    self._CHARACTER = player.Character

    assert(player.Character,`{player} Has No Character`)

    local humanoid = self._CHARACTER:FindFirstChildWhichIsA('Humanoid',true) :: Humanoid
	humanoid.RequiresNeck = false
    
    self:CreateBalloon()
end


function PlayerBalloon:CreateBalloon()
    local ballonEquipped = self._PLAYER:FindFirstChild('Balloon',true):: StringValue
    assert(ballonEquipped,`{self._PLAYER} Balloon Equipped Value False`)

    BalloonAPI.Create(self._CHARACTER.Head)
end

function PlayerBalloon:DestroyBalloon()
    BalloonAPI.Destroy(self._CHARACTER.Head)
end



function PlayerBalloon:Destroy()
    self:DestroyBalloon()
    self._MAID:Destroy()

    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return PlayerBalloon
