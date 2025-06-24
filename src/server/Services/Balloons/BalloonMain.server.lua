

local Balloons = Instance.new('Folder')
Balloons.Parent = workspace
Balloons.Name = 'Balloons'

local Balloon = require(script.Parent.Balloon)
local BalloonAPI = require(script.Parent.BalloonAPI)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Maid: MaidModule.Maid = MaidModule.new()

local CreateSignal = BalloonAPI._CreateSignal()
local PopSignal = BalloonAPI._PopSignal()


-- Owner prop must be a 'Player' object or leave it nil
local function Create(attachment: Attachment, owner: Player?)
    local Balloon = Balloon.new(attachment) :: Balloon.BalloonType
    local primaryPart = Balloon.MODEL.PrimaryPart :: Part

    if owner then
        primaryPart.Anchored = false
        primaryPart:SetNetworkOwner(owner)
    end

    Maid[Balloon.HITBOX] = Balloon
end

local function Pop(object: Part)
    local balloon = Maid[object] :: Balloon.BalloonType?
    
    if balloon then
        balloon:Pop()
    end

end


PopSignal:Connect(Pop)
CreateSignal:Connect(Create)


