
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local FireSignal = Signal.new()



local function GetFireSignal(): Signal.SignalType
    return FireSignal
end



local function Fire(effectName: string,...)
    FireSignal:Fire(effectName,...)
end


return {
    Fire = Fire,
    _FireSignal = GetFireSignal,
}

