local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Mouse = require(script.Parent.Parent.Parent.Modules.Mouse)
local ToolDetection = require(script.Parent.Parent.Parent.Modules.ToolDetection)
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)

local Maid: MaidModule.Maid = MaidModule.new()
local GunEvent: NameSpaceEvent.Client = NameSpaceEvent.new('Gun',{'Shoot'})

local Balloons = workspace:WaitForChild('Balloons')

local Debounce = false
local DebounceTime = 0.6



local function toolActivated(tool: Tool, balloonFound: Model)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {
        tool,
        Player.Character,
    }

    local mousePositsion = Mouse.GetPosition(raycastParams)

    GunEvent:FireServer('Shoot',tool,mousePositsion,balloonFound)
end


local function onToolAdded(tool: Tool)
    local character = Player.Character :: Model
    local humanoid = character:FindFirstChild('Humanoid') :: Humanoid
    local balloonFound = Balloons:WaitForChild(character.Name,20)

    Maid[tool.Name..' Activate'] =  tool.Activated:Connect(function()
        if humanoid.Health <= 0 then return end
        if Debounce then return end
        Debounce = true

        toolActivated(tool,balloonFound)
        
        task.wait(DebounceTime)
        Debounce = false
    end)
end

local function onCharacterAdded()
    ToolDetection.new(onToolAdded)
end

local function onCharacterRemove()
    ToolDetection.destroy(onToolAdded)
end

CharacterEvents.Spawn(onCharacterAdded)
CharacterEvents.Removing(onCharacterRemove)
CharacterEvents.Died(onCharacterRemove)