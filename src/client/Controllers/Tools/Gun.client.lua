local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Mouse = require(script.Parent.Parent.Parent.Modules.Mouse)
local ToolDetection = require(script.Parent.Parent.Parent.Modules.ToolDetection)
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)

local Maid: MaidModule.Maid = MaidModule.new()
local GunEvent: NameSpaceEvent.Client = NameSpaceEvent.new('Gun',{'Shoot'})

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.FilterDescendantsInstances = {}

local Balloons = workspace:WaitForChild('Balloons')

local Debounce = false
local DebounceTime = 0.4


local function toolActivated(event: RemoteEvent)
    local mousePositsion = Mouse.GetPosition(raycastParams)
    event:FireServer(mousePositsion)
end


local function onToolAdded(tool: Tool)
    Maid['Character'] = Player.Character or Player.CharacterAdded:Wait()
    local character = Maid['Character']
    
    local humanoid = character:WaitForChild('Humanoid',10) :: Humanoid
    local balloonFound = Balloons:WaitForChild(character.Name,20)
    
    table.insert(raycastParams.FilterDescendantsInstances,character)
    table.insert(raycastParams.FilterDescendantsInstances,balloonFound)
    table.insert(raycastParams.FilterDescendantsInstances,tool)

    local FireEvent = tool:FindFirstChild('Fire',true) :: RemoteEvent
    
    Maid[tool.Name..' Activate'] =  tool.Activated:Connect(function()
        if humanoid.Health <= 0 then return end
        if Debounce then return end
        Debounce = true

        toolActivated(FireEvent)
        
        task.wait(DebounceTime)
        Debounce = false
    end)
end

local function onCharacterAdded()
    ToolDetection.new(onToolAdded)
end

local function onCharacterRemove()
    ToolDetection.destroy(onToolAdded)
    raycastParams.FilterDescendantsInstances = {}
end

CharacterEvents.Spawn(onCharacterAdded)
CharacterEvents.Removing(onCharacterRemove)
CharacterEvents.Died(onCharacterRemove)