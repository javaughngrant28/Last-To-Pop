

local GuiCountdown = require(game.ServerScriptService.Components.GuiCountdown)


local GameState : StringValue = game.ReplicatedStorage.GameState
local INTERMISSION_TIME = 60


local function Intermission()
    GameState.Value = 'Intermission'
    GuiCountdown.Create('Intermission',INTERMISSION_TIME,'Intermission ')
end

Intermission()
