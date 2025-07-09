
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local CreateSignal = Signal.new()
local PopSignal = Signal.new()
local DestroySignal = Signal.new()
local UpdateCosmeticSignal = Signal.new()



local function GetCreateSignal(): Signal.SignalType
    return CreateSignal
end

local function GetPopSignal(): Signal.SignalType
    return PopSignal
end

local function GetDestroySignal(): Signal.SignalType
    return DestroySignal
end

local function GetUpdateCosmeticSignal(): Signal.SignalType
    return UpdateCosmeticSignal
end



local function Create(...: any?)
    CreateSignal:Fire(...)
end

local function UpdateCosmetic(player: Player, modelName: string)
    UpdateCosmeticSignal:Fire(player,modelName)
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
    UpdateCosmetic = UpdateCosmetic, 

    _CreateSignal = GetCreateSignal,
    _PopSignal = GetPopSignal,
    _DestroySignal = GetDestroySignal,
    _UpdateCosmetic = GetUpdateCosmeticSignal,
}

