
local ToolDetection = require(script.Parent.Parent.Parent.Modules.ToolDetection)
local Mouse = require(script.Parent.Parent.Parent.Modules.Mouse)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)

local Maid: MaidModule.Maid = MaidModule.new()

local raycastParams = RaycastParams.new()
raycastParams.RespectCanCollide = false
raycastParams.CollisionGroup = 'Ray'
raycastParams.FilterType = Enum.RaycastFilterType.Exclude



local function Activated(shootEvent: RemoteEvent,Debounce: BoolValue, DebounceTime: NumberValue)
    if Debounce.Value then return end
    Debounce.Value = true

    local unitRay = Mouse.GetUnitRay()
    local mousePosition = Mouse.GetPosition(raycastParams)

    shootEvent:FireServer(mousePosition)

    task.wait(DebounceTime.Value)
    Debounce.Value = false
end


local function ToolAdded(tool: Tool)
    table.insert(raycastParams.FilterDescendantsInstances,tool)

    local shootEvent = tool:WaitForChild('Fire') :: RemoteEvent
    local Debounce = tool:WaitForChild('Debounce') :: BoolValue
    local DebounceTime = tool:WaitForChild('DebounceTime') :: NumberValue

    Maid[tool.Name..'Activaed'] = tool.Activated:Connect(function()
        Activated(shootEvent,Debounce,DebounceTime)
    end)    
end

local function onCharacterAdded(character: Model)
    ToolDetection.new(ToolAdded,'Gun')
    raycastParams.FilterDescendantsInstances = {
        character
    }
end

local function onCharacterRemove()
    ToolDetection.destroy(ToolAdded)
    raycastParams.FilterDescendantsInstances = {}
end

CharacterEvents.Spawn(onCharacterAdded)
CharacterEvents.Removing(onCharacterRemove)
CharacterEvents.Died(onCharacterRemove)

