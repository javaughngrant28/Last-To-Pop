
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Balloons = workspace:WaitForChild('Balloons',10) :: Folder


local ToolDetection = require(script.Parent.Parent.Parent.Modules.ToolDetection)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)

local WeaponEvent: NameSpaceEvent.Client = NameSpaceEvent.new('Weapon',{'Shoot'})
local Maid: MaidModule.Maid = MaidModule.new()

local debounce = false
local debounceTime = 1

local CurrentCharacter: Model


local function toolActivated(tool: Tool, muzzle: Part)
    if debounce then return end

    local humanoid = CurrentCharacter:FindFirstChild('Humanoid') :: Humanoid
    if not humanoid or humanoid.Health <= 0 then return end
    
    debounce = true

    local rootPart = CurrentCharacter:FindFirstChild('HumanoidRootPart') :: Part
    local origin = muzzle.CFrame.Position
    local direction = (Mouse.Hit.Position - muzzle.CFrame.Position).Unit
    local Balloon = Balloons:FindFirstChild(CurrentCharacter.Name)
    
    WeaponEvent:FireServer('Shoot',tool,origin,direction,Balloon)

    task.wait(debounceTime)
    debounce = false
end

local function onToolAdded(tool: Tool)
    repeat
        task.wait(0.4)
    until tool:FindFirstChild('Muzzle',true)

    local muzzle = tool:FindFirstChild('Muzzle',true)
    assert(muzzle,`{tool} has no muzzle`)

    Maid[tool.Name..'Activated'] = tool.Activated:Connect(function()
        toolActivated(tool,muzzle)
    end)
end

local function onCharacterAdded(character: Model)
    ToolDetection.new(onToolAdded)
    CurrentCharacter = character
end

local function onCharacterRemove()
    ToolDetection.destroy(onToolAdded)
end

CharacterEvents.Spawn(onCharacterAdded)
CharacterEvents.Removing(onCharacterRemove)
CharacterEvents.Died(onCharacterRemove)
