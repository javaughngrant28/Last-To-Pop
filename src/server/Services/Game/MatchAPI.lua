

local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local CharacterDiedSignal = Signal.new()
local DestroySignal = Signal.new()

local function GetCharacterDiedSignal(): Signal.SignalType
    return CharacterDiedSignal
end

local function GetDestroySignal(): Signal.SignalType
    return DestroySignal
end

local function CharacterDied(player: Player)
    CharacterDiedSignal:Fire(player)
end

local function Destroy()
    DestroySignal:Fire()
end

return {
    CharacterDied = CharacterDied,
    Destroy = Destroy,

    _CharacterDiedSignal = GetCharacterDiedSignal,
    _DestroySignal = GetDestroySignal,
}