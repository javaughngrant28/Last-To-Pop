
local BulletFolder = workspace:FindFirstChild('BulletFolder')

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local FastCast = require(game.ReplicatedStorage.Libraries.FastCastRedux)


local Tools = game.ReplicatedStorage.Assets.Tools
local Balloons = workspace:WaitForChild('Balloons',5) :: Folder


local Gun = {}
Gun.__index = Gun

Gun.__CASTER = nil
Gun.__CAST_BEHAVIOR = nil

Gun._MAID = nil
Gun._PLAYER = nil
Gun._TOOL = nil
Gun._EVENT = nil
Gun._POINT_ATTACHMENT = nil
Gun._BULLET_TEMPLATE = game.ReplicatedStorage.Assets.Bullets.B1




function Gun.new(player: Player)
    local self = setmetatable({}, Gun)
    self:__Constructor(player)
    return self
end


function Gun:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player

    
    self:_CreateTool('Gun1')
    self:_CreatCaster()
    self:_ConnectToEvent()
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


    self.__CASTER:Fire(Origin,Direction,800,self.__CAST_BEHAVIOR)
end

function Gun:_CreatCaster()
    local playerBalloon = Balloons:FindFirstChild(self._PLAYER.Name)
    
    local Caster = FastCast.new()
    

    local castPerams = RaycastParams.new()
    castPerams.IgnoreWater = true
    castPerams.FilterType = Enum.RaycastFilterType.Exclude
    castPerams.FilterDescendantsInstances = {
        self._PLAYER.Character,
        self._TOOL,
        playerBalloon,
        BulletFolder,
    }

    local castBehavior = FastCast.newBehavior()
    castBehavior.RaycastParams = castPerams
    castBehavior.CosmeticBulletContainer = BulletFolder
    castBehavior.CosmeticBulletTemplate = self._BULLET_TEMPLATE

     self.__CASTER = Caster
     self.__CAST_BEHAVIOR = castBehavior

     Caster.LengthChanged:Connect(function(...)
        self:_OnLenthChanged(...)
    end)
end

function Gun:_OnLenthChanged(_,lastPoint: Vector3, direction: Vector3, length: number, velocity: Vector3, bullet: Instance)
    if not bullet then return end
    local bulletLength = bullet.Size.Z/2
	local offset = CFrame.new(0, 0, -(length - bulletLength))
	bullet.CFrame = CFrame.lookAt(lastPoint, lastPoint + direction):ToWorldSpace(offset)
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

