

local function CreateTool(toolName: string): Tool
    local tool = Instance.new('Tool')
    tool.RequiresHandle = true
    return tool
end



return {
    Create = CreateTool
}