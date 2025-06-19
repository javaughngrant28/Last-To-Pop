local BalloonAPI = require(game.ServerScriptService.Services.Balloons.BalloonAPI)


local Comands = {}

function Comands.KillAll()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			player.Character.Humanoid.Health = 0
		end
	end
end

function Comands.Kill(player: Player)
	if player and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Health = 0
	end
end

function Comands.Pop(player: Player)
	local character = player.Character
	if not character then return end

	local ballonModel = workspace.Balloons:FindFirstChild(character.Name) :: Model

	BalloonAPI.Pop(ballonModel.PrimaryPart)
end



return Comands