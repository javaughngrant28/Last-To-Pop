

-- local GuiCountdown = require(game.ServerScriptService.Components.GuiCountdown)
-- local MatchAPI = require(script.Parent.MatchAPI)
-- local Match = require(script.Parent.Match)


-- local CharacterDiedSignalInMatch = MatchAPI._CharacterDiedSignal()


-- local GameState : StringValue = game.ReplicatedStorage.GameState

-- local INTERMISSION_TIME = 240
-- local MATCH_TIME = 240



-- local function Intermission()
--     GameState.Value = 'Intermission'
--     GuiCountdown.Create('Timer',INTERMISSION_TIME,'Intermission ',true)
-- end

-- local function StartMatch()
--     GameState.Value = 'Match'
--     Match.Start()

--     GuiCountdown.Create('Timer',MATCH_TIME,'Round ',true)
--     GameState.Value = ''
--     Match.End()

--     Start()
-- end



-- CharacterDiedSignalInMatch:Connect(Match.CharacterDied)



-- function Start()
--     task.wait(4)
--     Intermission()
--     StartMatch()
-- end

-- -- Start()


