
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local CreateSignal = Signal.new()
local PopSignal = Signal.new()



local function GetCreateSignal(): Signal.SignalType
    return CreateSignal
end

local function GetPopSignal(): Signal.SignalType
    return PopSignal
end


local function Create(attachment: Attachment, owner: Player?)
    CreateSignal:Fire(attachment,owner)
end

local function Pop(balloon: Part)
    PopSignal:Fire(balloon)
end



return {
    Create = Create,
    Pop = Pop,

    _CreateSignal = GetCreateSignal,
    _PopSignal = GetPopSignal,
}

