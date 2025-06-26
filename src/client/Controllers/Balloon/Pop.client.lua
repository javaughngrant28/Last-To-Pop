local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)
local CharacterEvents = require(game.ReplicatedStorage.Shared.Modules.CharacterEvents)
local ApplyImpulse = require(script.Parent.Parent.Parent.Modules.ApplyImpulse)

local CurrentCharacter: Model

local function onPop(position: Vector3,force: number)
    local humanoid = CurrentCharacter:FindFirstChild('Humanoid') :: Humanoid
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)

    local rootPart = CurrentCharacter:FindFirstChild('HumanoidRootPart') :: Part
    local direction = (position - rootPart.CFrame.Position).Unit

	humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
	humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)

    task.defer(ApplyImpulse.Fire,CurrentCharacter,direction,force,0.1)
end

local function onCharacterAdded(character: Model)
    CurrentCharacter = character
end


CharacterEvents.Spawn(onCharacterAdded)
RemoteUtil.OnClient('Pop',onPop)