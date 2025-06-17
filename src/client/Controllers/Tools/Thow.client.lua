

local ToolAdded = require(script.Parent.Parent.Parent.Modules.ToolAdded)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Maid: MaidModule.Maid = MaidModule.new()



local function toolActivated(tool: Tool)
    print(tool)
end

local function onToolAdded(tool: Tool)
    Maid[tool.Name..'Activated'] = tool.Activated:Connect(function()
        toolActivated(tool)
    end)
end


ToolAdded.new(onToolAdded)