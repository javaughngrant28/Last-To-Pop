local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer


local function enableCustomHumanoidStates(character: Model)
	local humanoid = character:WaitForChild('Humanoid', 30)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
end

local function onCharacterDied()
	local character = LocalPlayer.Character
	local humanoid = character:FindFirstChild('Humanoid') :: Humanoid
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)

	task.wait()

	humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
	humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
end

local function onCharacterAdded(character: Model)
	if not character then return end

	local humanoid = character:WaitForChild('Humanoid') :: Humanoid

	humanoid.Died:Once(onCharacterDied)
	enableCustomHumanoidStates(character)
end




onCharacterAdded(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)