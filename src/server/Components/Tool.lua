
local Tools = game.ReplicatedStorage.Assets.Tools

local function CreateTool(toolName: string): Tool
    local tool = Tools:FindFirstChild(toolName) :: Tool
    assert(tool,`{toolName} Tool Not Found`)

    local toolClone = tool:Clone()
    local event = Instance.new('RemoteEvent',toolClone)
    event.Name = 'Shoot'

    return toolClone
end



return {
    Create = CreateTool
}