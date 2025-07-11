
local Tool = require(game.ServerScriptService.Components.Tool)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)



export type KatanaType = {
    new: ()-> KatanaType,
    Destroy: (self: KatanaType)-> nil,
}



local Katana = {}
Katana.__index = Katana

Katana._MAID = nil



function Katana.new(player: Player)
    local self = setmetatable({}, Katana)
    self:__Constructor(player)
    return self
end


function Katana:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player

    self:_CreateTool()
end


function Katana:_CreateTool()
    local tool = Tool.Create('Stick','Melee')
    tool.Parent = self._PLAYER.Backpack

    self._MAID['Tool'] = tool
end

function Katana:Destroy()

    if self._MAID then
        self._MAID:Destroy()
    end

    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return Katana