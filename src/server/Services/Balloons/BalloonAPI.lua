
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local CreateSignal = Signal.new()
local DestroySignal = Signal.new()

local function GetCreateSignal(): Signal.SignalType
    return CreateSignal
end

local function GetDestroySignal(): Signal.SignalType
    return DestroySignal
end

local function Create(...:any?)
    CreateSignal:Fire(...)
end

local function Destroy(...:any?)
    DestroySignal:Fire(...)
end

return {
    Create = Create,
    Destroy = Destroy,

    _CreateSignal = GetCreateSignal,
    _DestroySignal = GetDestroySignal,
}
