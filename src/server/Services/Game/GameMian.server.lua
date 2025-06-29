

local GuiCountdown = require(game.ServerScriptService.Components.GuiCountdown)
local Match = require(script.Parent.Match)


local GameState : StringValue = game.ReplicatedStorage.GameState
local INTERMISSION_TIME = 30



local function Intermission()
    GameState.Value = 'Intermission'
    GuiCountdown.Create('Intermission',INTERMISSION_TIME,'Intermission ',true)

    GameState.Value = 'Match'
    Match.Start()
end

Intermission()
