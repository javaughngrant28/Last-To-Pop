

local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local Raycast = require(game.ReplicatedStorage.Shared.Modules.Raycast)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)
local BalloonAPI = require(game.ServerScriptService.Services.Balloons.BalloonAPI)

local GunEvent: NameSpaceEvent.Server = NameSpaceEvent.new('Gun',{'Shoot'})


type UnitRay = {
    Origin: Vector3,
    Direction: Vector3,
}

local RANGE = 500





local function Shoot(player: Player,tool: Tool, mousePosition: Vector3,localBalloon: Model)
   local firePoint = tool:FindFirstChild('Handle'):FindFirstChild('FirePoint') :: Attachment
   local Origin = firePoint.WorldCFrame.Position
   local Direction = (mousePosition - Origin).Unit

   local result = Raycast.Fire(Origin,Direction, RANGE,{
    player.Character,
    tool,
    localBalloon,
   })

   local distance = result and result.Distance or RANGE
   local insatnce = result and result.Instance

   if insatnce and insatnce:GetAttribute('Balloon') then
    BalloonAPI.Pop(insatnce)
   end

   RemoteUtil.FireAllClients('Effects','VisualizeRay',Origin,Direction,distance)
end



GunEvent:OnServer('Shoot',Shoot)


