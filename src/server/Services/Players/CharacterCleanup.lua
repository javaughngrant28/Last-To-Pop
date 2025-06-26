
local BalloonAPI = require(script.Parent.Parent.Balloons.BalloonAPI)

local function CleanUpAndRemoveCharacter(character: Model, player: Player)
    BalloonAPI.Destroy(character:FindFirstChild('Head'))

    task.wait(1)

    player.Character = nil
    character:Destroy()

    task.wait(1)
end

return {
    Fire = CleanUpAndRemoveCharacter
}
