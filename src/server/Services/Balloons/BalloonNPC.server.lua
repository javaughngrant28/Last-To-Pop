
local BallonAPI = require(script.Parent.BalloonAPI)

local TestBallons = workspace.TestBallons:GetChildren() :: {Part}

task.wait(2)
for _, part in TestBallons do
    BallonAPI.Create(part,'Blue')
end

 







