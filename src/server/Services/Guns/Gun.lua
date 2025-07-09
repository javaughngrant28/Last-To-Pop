

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local Tool = require(game.ServerScriptService.Components.Tool)



export type GunType = {
    new: (player: Player) -> GunType,
    Destroy: (self: GunType)-> ()
}



local Gun = {}
Gun.__index = Gun

Gun._MAID = nil
Gun._PLAYER = nil

Gun.TOOL = nil



function Gun.new(player: Player) 
    local self = setmetatable({}, Gun)
    self:__Constructor(player)
    return self
end

function Gun:CreateTool()
    local tool = Tool.Create('Gun1')
    tool.Parent = self._PLAYER.Backpack
    self._MAID['Tool'] = tool
end



function Gun:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player
    
    self:CreateTool()
end







function Gun:Destroy()
    self._MAID:Destroy()
    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return Gun