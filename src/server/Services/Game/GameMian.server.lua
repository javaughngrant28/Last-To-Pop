

local GuiCountdown = require(game.ServerScriptService.Components.GuiCountdown)
local MatchAPI = require(script.Parent.MatchAPI)
local Match = require(script.Parent.Match)


local CharacterDiedSignalInMatch = MatchAPI._CharacterDiedSignal()


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



CharacterDiedSignalInMatch:Connect(Match.CharacterDied)



local function Start()
    task.wait(4)
    Intermission()
    StartMatch()
end

Start()


