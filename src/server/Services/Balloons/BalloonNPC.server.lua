
local BallonAPI = require(script.Parent.BalloonAPI)

local TestBallons = workspace.TestBallons:GetChildren() :: {Part}

task.wait(4)

for _, part in TestBallons do
    BallonAPI.Create(part)
end

 







