
local BalloonConstuction = require(script.Parent.BalloonConstructer)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)


export type BalloonType = {
    HITBOX: Part,
    
    new: (part: Part, player: Player?) -> BalloonType,
    Pop: () -> nil,
    Destroy: (self: BalloonType) -> nil,
}

local Balloon = {}
Balloon.__index = Balloon

Balloon.HITBOX = nil

Balloon._MAID = nil
Balloon._PLAYER = nil
Balloon._PART = nil



function Balloon.new(part: Part, player: Player?) : BalloonType
    local self = setmetatable({}, Balloon)
    self:__Constructor(part,player)
    return self
end

function Balloon:Pop()
    if not self.HITBOX:GetAttribute('BalloonHitBox') then return end
    self.HITBOX:SetAttribute('BalloonHitBox', nil)

    local player = self._PLAYER
    local humanoid = player and player.Character and player.Character:FindFirstChild('Humanoid') or nil :: Humanoid?

    if humanoid then
        humanoid.Health = 0
    end

    self:Destroy()
end



function Balloon:__Constructor(part: Part, player: Player?)
    self._MAID = MaidModule.new()
    self._PLAYER = player
    self._PART = part
    
    self:_CreateBalloon()
end


function Balloon:_CreateBalloon()
    local data = {
         Size = Vector3.new(3,3,3),
         CosmeticName = 'Ahh',
         HitboxScale = 1.6,
         Part = self._PART,
        }

    local BalloonModel, CosmeticModel = BalloonConstuction.Fire(data)
    local Hitbox = BalloonModel:FindFirstChild('HitBox') :: Part

    BalloonModel.PrimaryPart.CFrame = self._PART.CFrame + Vector3.new(0,4,0)
    
    if self._PLAYER then
        BalloonModel.Parent = workspace
        CosmeticModel.Parent = workspace

        BalloonModel.PrimaryPart.Anchored = false

        BalloonModel.PrimaryPart:SetNetworkOwner(self._PLAYER)
        CosmeticModel.PrimaryPart:SetNetworkOwner(self._PLAYER)

        BalloonModel.Name = self._PLAYER.Name
        CosmeticModel.Name = self._PLAYER.Name

        RemoteUtil.FireClient(self._PLAYER,'Balloon',BalloonModel)
    end

    BalloonModel.Parent = workspace.Balloons
    CosmeticModel.Parent = workspace.CosmeticBalloons

    self.HITBOX = Hitbox
    self._MAID['BalloonModel'] = BalloonModel
    self._MAID['CosmeticModel'] = CosmeticModel
end


function Balloon:Destroy()
    if self._MAID then
        self._MAID:Destroy()
    end

    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return Balloon