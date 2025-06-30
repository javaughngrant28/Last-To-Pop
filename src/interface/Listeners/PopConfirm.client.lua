local Debris = game:GetService("Debris")
local Players = game:GetService("Players")


local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)

local GunEvent: NameSpaceEvent.Client = NameSpaceEvent.new('Gun',{'PopConfirm'})
local Maid: MaidModule.Maid = MaidModule.new()

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui',10) :: PlayerGui
local Screen = PlayerGui:WaitForChild('PopConfirm',20) :: ScreenGui
local Template = Screen:FindFirstChild('Template',true) :: Frame

local LIFETIME = 4


local function onEvent(targetName: string)
    local frame = Template:Clone() :: Frame
    local textLable = frame:FindFirstChild('Name',true) :: TextLabel
    
    textLable.Text = `{targetName}`

    frame.Parent =  Template.Parent
    frame.Visible = true
    Debris:AddItem(frame,LIFETIME)
end


GunEvent:OnClient('PopConfirm',onEvent)






