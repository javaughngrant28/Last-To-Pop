local Debris = game:GetService("Debris")

local BulletFolder = workspace:FindFirstChild('BulletFolder')
local BalloonCosmeticFolder = workspace:WaitForChild('BalloonCosmetic')
local EffectsFolder = game.ReplicatedStorage.Effects

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local Transform = require(game.ReplicatedStorage.Shared.Modules.Transform)


local Tools = game.ReplicatedStorage.Assets.Tools
local Balloons = workspace:WaitForChild('Balloons',5) :: Folder


local Gun = {}
Gun.__index = Gun

Gun._MAID = nil
Gun._PLAYER = nil
Gun._TOOL = nil
Gun._EVENT = nil
Gun._POINT_ATTACHMENT = nil
Gun._RAYCAST_PERAMS = nil

Gun.RAY_EFFECT = nil




function Gun.new(player: Player)
    local self = setmetatable({}, Gun)
    self:__Constructor(player)
    return self
end


function Gun:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player

    self:_CreateTool('Gun1')
    self:_ConnectToEvent()
    self:_ConstructRayEffect()
    self:_CreateRayCastPerams()
end


function Gun:_CreateTool(toolName: string)
    local tool = Tools:FindFirstChild(toolName)
    assert(tool,`{self._PLAYER} Tool {toolName} Not Found`)

    local toolClone = tool:Clone() :: Tool
    self._MAID['Tool'] = toolClone
    self._TOOL = toolClone

    local pointAttachment = toolClone:FindFirstChild('FirePoint',true)
    assert(pointAttachment,`{self._PLAYER} {tool} FirePoint Attachemt Not Found`)
    self._POINT_ATTACHMENT = pointAttachment

    local event = Instance.new('RemoteEvent')
    self._EVENT = event
    event.Name = 'Fire'
    event.Parent = toolClone

    toolClone.Parent = self._PLAYER.Backpack
end

function Gun:_Fire(_, mousePosition: Vector3)
    local Attachemt = self._POINT_ATTACHMENT :: Attachment
    local Origin = Attachemt.WorldCFrame.Position
    local Direction = (mousePosition - Origin).Unit

    local rayEffect = self.RAY_EFFECT:Clone()
    local targetPosition = rayEffect:FindFirstChild('TargetPosition') :: Vector3Value

    local Distance = Direction * 1000
    local Results = workspace:Raycast(Attachemt.WorldCFrame.Position, Distance, self._RAYCAST_PERAMS) :: RaycastResult
    local TargetInstance = Results and Results.Instance or nil

    if TargetInstance then
        print(Results.Instance)
    end

    targetPosition.Value = Results and Results.Position or mousePosition
    rayEffect.Parent = EffectsFolder
    Debris:AddItem(rayEffect,2)
end

function Gun:_CreateRayCastPerams()
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {
        self._PLAYER.Character,
        self._TOOL,
        Balloons:FindFirstChild(self._PLAYER.Name),
        BalloonCosmeticFolder,
    }

    self._RAYCAST_PERAMS = raycastParams
end

function Gun:_ConstructRayEffect()
    local effectTable = {
        Spawn = self._POINT_ATTACHMENT,
        TargetPosition = Vector3.zero,
    }

    local effectFolder = Transform.ToInstance('Ray',effectTable)
    self._MAID['EffectFolder'] = effectFolder

    self.RAY_EFFECT = effectFolder
end

function Gun:_ConnectToEvent()
    local event = self._EVENT :: RemoteEvent

    self._MAID['FireEventConnection'] = event.OnServerEvent:Connect(function(...)
        self:_Fire(...)
    end)
end



function Gun:Destroy()

    self._MAID:Destroy()
    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return Gun

