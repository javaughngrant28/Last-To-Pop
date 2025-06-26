
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local CreateSignal = Signal.new()
local PopSignal = Signal.new()
local DestroySignal = Signal.new()



local function GetCreateSignal(): Signal.SignalType
    return CreateSignal
end

local function GetPopSignal(): Signal.SignalType
    return PopSignal
end

local function GetDestroySignal(): Signal.SignalType
    return DestroySignal
end



local function Create(owner: Part)
    CreateSignal:Fire(owner)
end

local function Destroy(owner: Part)
    DestroySignal:Fire(owner)
end

local function Pop(balloon: Part)
    PopSignal:Fire(balloon)
end



return {
    Create = Create,
    Pop = Pop,
    Destroy = Destroy,

    _CreateSignal = GetCreateSignal,
    _PopSignal = GetPopSignal,
    _DestroySignal = GetDestroySignal,
}

