
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local CreateSignal = Signal.new()



local function GetCreateSignal(): Signal.SignalType
    return CreateSignal
end

local function Create(player: Player)
    CreateSignal:Fire(player)
end


return {
    CreateSignal = GetCreateSignal,
    Create = Create
}

