
local Tools = game.ReplicatedStorage.Assets.Tools

type ToolType = 'Gun' | 'Melee'

local ToolTypes: {[ToolType]: (tool: Tool)-> nil} = {}

function ToolTypes.Gun(tool: Tool)
    local event = Instance.new('RemoteEvent',tool)
    event.Name = 'Fire'

    local Debounce = Instance.new('BoolValue',tool)
    Debounce.Name = 'Debounce'
    Debounce.Value = false

    local DebounceTime = Instance.new('NumberValue',tool)
    DebounceTime.Name = 'DebounceTime'
    DebounceTime.Value = 0.4
end

function ToolTypes.Melee(tool: Tool)
     local event = Instance.new('RemoteEvent',tool)
    event.Name = 'Fire'
    tool:SetAttribute('Class','Melee')
end

local function CreateTool(toolName: string, toolType: ToolType): Tool
    local tool = Tools:FindFirstChild(toolName) :: Tool
    assert(tool,`{toolName} Tool Not Found`)

    local toolClone = tool:Clone()
    ToolTypes[toolType](toolClone)

    return toolClone
end



return {
    Create = CreateTool
}