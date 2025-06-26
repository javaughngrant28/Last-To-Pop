local Players = game:GetService("Players")


local BalloonFolder = Instance.new('Folder')
BalloonFolder.Parent = workspace
BalloonFolder.Name = 'Balloons'

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local Balloon = require(script.Parent.Balloon)
local BalloonAPI = require(script.Parent.BalloonAPI)

local Maid: MaidModule.Maid = MaidModule.new()

local CreateSignal = BalloonAPI._CreateSignal()
local PopSignal = BalloonAPI._PopSignal()
local DestroySignal = BalloonAPI._DestroySignal()



local function Create(owner: Part)
    local Balloon = Balloon.new(owner) :: Balloon.BalloonType
    local primaryPart = Balloon.MODEL.PrimaryPart :: Part

    local character = owner.Parent
    local player = Players:GetPlayerFromCharacter(character)

    if player then
        primaryPart.Anchored = false
        primaryPart:SetNetworkOwner(player)
        RemoteUtil.FireClient(player,'Balloon',Balloon.MODEL)
    end

    Maid[owner] = Balloon
    Maid[Balloon.HITBOX] = Balloon
    Balloon.MODEL.Parent = BalloonFolder
end

local function Pop(hitBox: Part)
    local balloon = Maid[hitBox] :: Balloon.BalloonType?
    
    if balloon then
        balloon:Pop()
    end
end

local function Destroy(owner: Part)
    local Balloon = Maid[owner] :: Balloon.BalloonType
    if Balloon then
        Balloon:Destroy()
    end
end



PopSignal:Connect(Pop)
DestroySignal:Connect(Destroy)
CreateSignal:Connect(Create)


