
local Position = require(game.ServerScriptService.Components.Position)

function SpawnCharacter(player: Player, spawnFolder: Folder)
    if not player.Character then
        player:LoadCharacter()
    end

    local character = player.Character or player.CharacterAdded:Wait()
    Position.AtRandomPartInFolder(character,spawnFolder)
end

return {
    Spawn = SpawnCharacter
}
