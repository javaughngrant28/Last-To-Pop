
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Balloons = workspace:WaitForChild('Balloons',10) :: Folder


local ToolDetection = require(script.Parent.Parent.Parent.Modules.ToolDetection)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)
local Raycast = require(game.ReplicatedStorage.Shared.Modules.Raycast)
local EffectsAPI = require(script.Parent.Parent.Effects.EffectsAPI)

local WeaponEvent: NameSpaceEvent.Client = NameSpaceEvent.new('Weapon',{'Shoot'})
local Maid: MaidModule.Maid = MaidModule.new()

local debounce = false
local debounceTime = 0.6
local DISTANCE = 500

local CurrentCharacter: Model


local function toolActivated(tool: string, muzzle: Part)
    if debounce then return end

    local humanoid = CurrentCharacter:FindFirstChild('Humanoid') :: Humanoid
    if not humanoid or humanoid.Health <= 0 then return end
    
    debounce = true

    local origin = muzzle.CFrame.Position
    local mousePosition = Mouse.Hit.Position
    local lookVector = (mousePosition - origin).Unit
    local results = Raycast.Fire(origin,lookVector,DISTANCE,{CurrentCharacter, tool})
    local targetDistance = results and results.Distance or DISTANCE
    local target = results and results.Instance or nil
    
    WeaponEvent:FireServer('Shoot',target,tool,origin,lookVector,targetDistance)

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
