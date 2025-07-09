local Players = game:GetService("Players")

local BalloonModelFolder = game.ReplicatedStorage.Assets.Models.Balloons :: Folder

local BalloonFolder = Instance.new('Folder')
BalloonFolder.Parent = workspace
BalloonFolder.Name = 'Balloons'

local BalloonCosmeticFolder = Instance.new('Folder')
BalloonCosmeticFolder.Parent = workspace
BalloonCosmeticFolder.Name = 'BalloonCosmetic'

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local Balloon = require(script.Parent.Balloon)
local BalloonAPI = require(script.Parent.BalloonAPI)

local Maid: MaidModule.Maid = MaidModule.new()

local CreateSignal = BalloonAPI._CreateSignal()
local PopSignal = BalloonAPI._PopSignal()
local DestroySignal = BalloonAPI._DestroySignal()
local UpdateCosmeticSignal = BalloonAPI._UpdateCosmetic()



local function Create(owner: Part,modelName: string?)
    local Balloon = Balloon.new(owner,modelName) :: Balloon.BalloonType
    local primaryPart = Balloon.MODEL.PrimaryPart :: Part

    local character = owner.Parent
    local player = Players:GetPlayerFromCharacter(character)

    if player then
        Balloon.MODEL.Name = player.Name
        primaryPart.Anchored = false
        primaryPart:SetNetworkOwner(player)
        RemoteUtil.FireClient(player,'Balloon',Balloon.MODEL)

        local BalloonEquipped = player:FindFirstChild('Balloon',true) :: StringValue
        if not BalloonEquipped then warn(`{player} Balloon Value`) return end

        Balloon:UpdateModel(BalloonEquipped.Value)

        Maid[player.Name..'Balloon Value Changed'] = BalloonEquipped:GetPropertyChangedSignal('Value'):Connect(function()
            Balloon:UpdateModel(BalloonEquipped.Value)
        end)
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

local function UpdateCosmetic(player: Player,balloonName: string)
    local Balloon = player:FindFirstChild('Balloon',true) :: StringValue
	local BalloonModel = BalloonModelFolder:FindFirstChild(balloonName)

	if not Balloon then warn(`{player} Balloon Value`) return end
	if not BalloonModel then warn(`{player} Balloon {balloonName} Model Not Found`) end

	Balloon.Value = balloonName
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
UpdateCosmeticSignal:Connect(UpdateCosmetic)


