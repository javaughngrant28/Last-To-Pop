
local balloonAPI = require(script.Parent.BalloonAPI)

local folder = workspace:FindFirstChild('TestBallons')

task.wait(2)

for _, part in folder:GetChildren() do
    balloonAPI.Create(part)
end

