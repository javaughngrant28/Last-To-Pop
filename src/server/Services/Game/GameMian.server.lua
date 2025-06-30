

local GuiCountdown = require(game.ServerScriptService.Components.GuiCountdown)
local Match = require(script.Parent.Match)


local GameState : StringValue = game.ReplicatedStorage.GameState

local INTERMISSION_TIME = 20
local MATCH_TIME = 30



local function Intermission()
    GameState.Value = 'Intermission'
    GuiCountdown.Create('Intermission',INTERMISSION_TIME,'Intermission ',true)
end

local function StartMatch()
    GameState.Value = 'Match'
    Match.Start()
    GuiCountdown.Create('Intermission',MATCH_TIME,nil,true)
end


local function Start()
    Intermission()
    StartMatch()
end

Start()

