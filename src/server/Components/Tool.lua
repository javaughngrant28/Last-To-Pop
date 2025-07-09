
local Tools = game.ReplicatedStorage.Assets.Tools

local function CreateTool(toolName: string): Tool
    local tool = Tools:FindFirstChild(toolName) :: Tool
    assert(tool,`{toolName} Tool Not Found`)

    local toolClone = tool:Clone()

    local event = Instance.new('RemoteEvent',toolClone)
    event.Name = 'Fire'

    local Debounce = Instance.new('BoolValue',toolClone)
    Debounce.Name = 'Debounce'
    Debounce.Value = false

    local DebounceTime = Instance.new('NumberValue',toolClone)
    DebounceTime.Name = 'DebounceTime'
    DebounceTime.Value = 0.4

    return toolClone
end



return {
    Create = CreateTool
}