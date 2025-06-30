
local ScreenGuiUtil = require(game.ReplicatedStorage.Shared.Utils.ScreenGuiUtil)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local function Countdown(textLabel: TextLabel, startedTime: number, goalTime: number, text: string?)
    while textLabel and textLabel.Parent and (goalTime - os.time()) > 0 do
        textLabel.Text = text and `{text}{tostring(goalTime - os.time())}` or tostring(goalTime - os.time())
        task.wait(1)
    end
end

local function ActiveCountdown(screen: ScreenGui,startedTime: number, goalTime: number, text: string?)
    assert(
        startedTime and type(startedTime) == "number" and goalTime and type(goalTime) == "number",
        `Values: {startedTime} {goalTime}`
    )

    local textLable = screen:FindFirstChild('Countdown',true) or screen:FindFirstChildWhichIsA('TextLabel',true):: TextLabel
    assert(textLable and textLable:IsA('TextLabel'),`{screen}: Countdown Text leble not: {textLable}`)

    textLable.Visible = true
    Countdown(textLable,startedTime,goalTime,text)
end

RemoteUtil.OnClient('AnimateCountdownLable',ActiveCountdown)