local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")


local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local Tool = require(game.ServerScriptService.Components.Tool)
local FastCast = require(game.ServerScriptService.Modules.FastCastRedux).Init
local PartCache = require(game.ServerScriptService.Modules.PartCache)



type UnitRay = {
    Origin: Vector3,
    Direction: Vector3,
}

export type GunType = {
    new: (player: Player) -> GunType,
    Destroy: (self: GunType)-> ()
}



local Gun = {}
Gun.__index = Gun

Gun.RANGE = 1000
Gun.VELOCITY = 200
Gun.TOOL = nil
Gun.POINT_ATTACHMENT = nil
Gun.BULLET = game.ReplicatedStorage.Assets.Bullets.B1

Gun._MAID = nil
Gun._PLAYER = nil
Gun._CASTER = nil
Gun._CASTER_BEHAVIOUR = nil
Gun._PART_CASHE = nil

Gun.__RAYCAST_PERAMS = nil



function Gun.new(player: Player) 
    local self = setmetatable({}, Gun)
    self:__Constructor(player)
    return self
end



function Gun:Fire(player: Player, mousePosition: Vector3)
    local Origin = self.POINT_ATTACHMENT.WorldCFrame.Position
    local Direction = (mousePosition - Origin).Unit

    self._CASTER:Fire(Origin,Direction,self.VELOCITY,self._CASTER_BEHAVIOUR)
end

function Gun:CreateTool()
    local tool = Tool.Create('Gun1')
    tool.Parent = self._PLAYER.Backpack

    local attachment = tool:FindFirstChild('FirePoint',true) :: Attachment
    assert(attachment,`{self._PLAYER} {self.TOOL} FirePoint Attachment Not Found`)
    
    self.POINT_ATTACHMENT = attachment
    self.TOOL = tool
    self._MAID['Tool'] = tool
end



function Gun:__Constructor(player: Player)
    self._MAID = MaidModule.new()
    self._PLAYER = player
    
    self:CreateTool()
    self:__CreateRayCastPerms()
    self:_CreatCaster()
    self:_ConnectToEvents()
end


function Gun:_ConnectToEvents()
    local event = self.TOOL:FindFirstChild('Fire',true) :: RemoteEvent
    assert(event,`{self._PLAYER} {self.TOOL} Tool Fire Event Not Found`)

    self._MAID['Fire Connection'] = event.OnServerEvent:Connect(function(...)
        self:Fire(...)
    end)

    self._MAID['Caster LenghChanged'] = self._CASTER.LengthChanged:Connect(function(...)
        self:_OnLenthChanged(...)
    end)

    self._MAID['Caster Hit'] = self._CASTER.RayHit:Connect(function(...)
        self:_OnRayHit(...)
    end)

    self._MAID['Caster Terminating'] = self._CASTER.CastTerminating:Connect(function(...)
        self:_CastTeminated(...)
    end)
end

function Gun:_CreatCaster()
    local caster = FastCast.new()
    local castBehaviour = caster.newBehavior()
    local partCashe = PartCache.new(self.BULLET,100,workspace.Bullets)

    castBehaviour.RaycastParams = self.__RAYCAST_PERAMS
    castBehaviour.CosmeticBulletContainer = workspace.Bullets
    castBehaviour.CosmeticBulletProvider = partCashe

    self._CASTER = caster
    self._PART_CASHE = partCashe
    self._CASTER_BEHAVIOUR = castBehaviour
end


function Gun:__CreateRayCastPerms()
    local raycastParams = RaycastParams.new()
    raycastParams.RespectCanCollide = false
    raycastParams.CollisionGroup = 'Ray'
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    raycastParams.FilterDescendantsInstances = {
        self._PLAYER.Character,
        self.TOOL,
        workspace.Bullets,
        workspace.Balloons:FindFirstChild(self._PLAYER.Name)
    }

    self.__RAYCAST_PERAMS = raycastParams
end

function Gun:_OnLenthChanged(_, lastPoint, dircction, lenth, velocity, bullet)
    if not bullet then return end
    local bulletLength = bullet.Size.Z / 2
    local offset = CFrame.new(0,0,-(lenth - bulletLength))
    bullet.CFrame = CFrame.lookAt(lastPoint, lastPoint + dircction):ToWorldSpace(offset)
end

function Gun:_OnRayHit(_,result: RaycastResult,_,bullet: Instance)
    local hit = result.Instance
    
    if hit:GetAttribute('BalloonHitBox') then
        print('Pop',hit)
    end
end

function Gun:_CastTeminated(cast)
    local bullet = cast.RayInfo['CosmeticBulletObject']
    if bullet then
        task.wait(1)
        self._PART_CASHE:ReturnPart(bullet)
    end
end






function Gun:Destroy()
    self._MAID:Destroy()
    for index, _ in pairs(self) do
         self[index] = nil
     end
end

return Gun