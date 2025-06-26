

local Loadouts = require(game.ServerScriptService.Modules.Loadouts.LoadoutManager)



local function CleanUpAndRemoveCharacter(character: Model, player: Player)
   Loadouts.Remove(player.Name)

    task.wait(1)

    player.Character = nil
    character:Destroy()

    task.wait(1)
end

return {
    Fire = CleanUpAndRemoveCharacter
}
