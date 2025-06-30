

local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local function FormatTime(seconds: number): string
	if seconds < 60 then
		return tostring(seconds)
	else
		local minutes = math.floor(seconds / 60)
		local remainingSeconds = seconds % 60
		return string.format("%d:%02d", minutes, remainingSeconds)
	end
end

local function Countdown(textLabel: TextLabel, goalTime: number, text: string?)
	while textLabel and textLabel.Parent and (goalTime - os.time()) > 0 do
		local timeLeft = goalTime - os.time()
		local display = FormatTime(timeLeft)
		textLabel.Text = text and (text .. display) or display
		task.wait(1)
	end
end
local function ActiveCountdown(screen: ScreenGui, goalTime: number, text: string?)
    assert(goalTime and type(goalTime) == "number",`Values: {goalTime}`)

    local textLable = screen:FindFirstChild('Countdown',true) or screen:FindFirstChildWhichIsA('TextLabel',true):: TextLabel
    assert(textLable and textLable:IsA('TextLabel'),`{screen}: Countdown Text leble not: {textLable}`)

    textLable.Visible = true
    Countdown(textLable,goalTime,text)
end

RemoteUtil.OnClient('AnimateCountdownLable',ActiveCountdown)