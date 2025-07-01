local Debris = game:GetService("Debris")
local Players = game:GetService("Players")

local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local BalloonData = require(game.ReplicatedStorage.Shared.Data.Balloons)
local SoundUtil = require(game.ReplicatedStorage.Shared.Utils.SoundUtil)
local ViewportManager = require(script.Parent.Parent.Components.ViewportManager)

local ChestEvent: NameSpaceEvent.Client = NameSpaceEvent.new('Chests',{'Open','Show'})


local Player = Players.LocalPlayer
local PlayerBackPack = Player:WaitForChild('PlayerGui',10)
local Screen = PlayerBackPack:WaitForChild('ShowBalloon',20)
local Sound = game.ReplicatedStorage.Assets.Sounds.GUI.Ding
local BalloonModels = game.ReplicatedStorage.Assets.Models.Balloons



local function onShowBalloon(rarity: string, index: number)
    local balloonData = BalloonData[rarity][index] :: BalloonData.DataType
    assert(balloonData,`{rarity} {index} Not Found BalloonData Table`)
    
    local Model = BalloonModels:FindFirstChild(balloonData.Name)
    assert(Model,`{balloonData.Name} Not In Balloon Models`)
    
    local Template = Screen:FindFirstChild('Template',true) :: Frame
    local TemplateClone = Template:Clone() :: Frame
    local RarityLable = TemplateClone:FindFirstChild('Rarity',true) :: TextLabel
    local ModelClone = Model:Clone()
    local viewport = TemplateClone:FindFirstChildWhichIsA('ViewportFrame',true) :: ViewportFrame

    ViewportManager.AddModel(viewport,ModelClone)
    TemplateClone.Parent = Template.Parent
    TemplateClone.Visible = true

    RarityLable.Text = rarity
    SoundUtil.PlaySoundInElement(Sound,TemplateClone)

    Debris:AddItem(TemplateClone,4)
end

ChestEvent:OnClient('Show',onShowBalloon)
