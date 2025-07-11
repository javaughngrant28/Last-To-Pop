
local ToolDetection = require(script.Parent.Parent.Parent.Modules.ToolDetection)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)



local function MeleeToolAdded(tool: Tool)
    
end

local function onCharacterAdded(character: Model)
    ToolDetection.new(MeleeToolAdded,'Melee')
end

local function onCharacterRemove()
    ToolDetection.destroy(MeleeToolAdded)
end

CharacterEvents.Spawn(onCharacterAdded)
CharacterEvents.Removing(onCharacterRemove)
CharacterEvents.Died(onCharacterRemove)
