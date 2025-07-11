
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local CreateSignal = Signal.new()
local DestroySignal = Signal.new()
local PopSignal = Signal.new()



local function GetCreateSignal(): Signal.SignalType
    return CreateSignal
end

local function GetDestroySignal(): Signal.SignalType
    return DestroySignal
end

local function GetPopSignal(): Signal.SignalType
    return PopSignal
end


local function Create(...:any?)
    CreateSignal:Fire(...)
end

local function Destroy(...:any?)
    DestroySignal:Fire(...)
end

local function Pop(...:any?)
    PopSignal:Fire(...)
end



return {
    Create = Create,
    Destroy = Destroy,
    Pop = Pop,

    _CreateSignal = GetCreateSignal,
    _DestroySignal = GetDestroySignal,
    _PopSignal = GetPopSignal,
}
