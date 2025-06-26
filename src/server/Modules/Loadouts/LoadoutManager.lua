
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)



type LoadOutNameType = 'PlayerBalloon'

type LoadoutType = {
    LoadOutNameType: {
        new: (player: Player) -> (),
        Destroy: (LoadOutNameType)->()
    }
}



local Loadouts = {} :: LoadoutType


local Maid: MaidModule.Maid = MaidModule.new()



local function CreateLoadout(player: Player,LoadOutName: LoadOutNameType)
    local Loadout = Loadouts[LoadOutName]
    assert(Loadout,`{LoadOutName} Is Not Found`)

    Maid[player.Name] = Loadout.new(player)
end

local function DestroyLoadout(playerName: string)
    Maid[playerName] = nil
end



for _, module: ModuleScript in script.Parent:GetChildren() do
    if module == script then continue end
    Loadouts[module.Name] = require(module)
end



return {
    Create = CreateLoadout,
    Remove = DestroyLoadout
}



