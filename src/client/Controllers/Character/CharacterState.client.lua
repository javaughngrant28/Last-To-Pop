local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer


local function enableCustomHumanoidStates(character: Model, humanoid: Humanoid)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
end

local function onCharacterAdded(character: Model)
	if not character then return end
	local humanoid = character:WaitForChild('Humanoid') :: Humanoid
	enableCustomHumanoidStates(character,humanoid)
end




onCharacterAdded(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)