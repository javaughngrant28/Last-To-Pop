
local FunctionUtil = require(game.ReplicatedStorage.Shared.Utils.FunctionUtil)

local function SetupCharacter(character: Model)
    FunctionUtil.SetCollisionGroup(character,'Char')
end

return {
    Fire = SetupCharacter
}