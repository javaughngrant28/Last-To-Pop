local Players = game:GetService("Players")


local WeaponAPI = require(script.Parent.WeaponAPI)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local SoundUtil = require(game.ReplicatedStorage.Shared.Utils.SoundUtil)
local BalloonAPI = require(game.ServerScriptService.Services.Balloons.BalloonAPI)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)


local Tools = game.ReplicatedStorage.Assets.Tools

local Maid: MaidModule.Maid = MaidModule.new()
local CreateSignal = WeaponAPI.CreateSignal()
local WeaponEvent: NameSpaceEvent.Server = NameSpaceEvent.new('Weapon',{'Shoot'})


local function CreateWeapon(player: Player)
    local weaponName = player:FindFirstChild('Weapon',true) :: StringValue
    
    local tool = Tools:FindFirstChild(weaponName.Value)
    assert(tool,`{weaponName.Value} Tool Not Found`)
    
    local toolClone = tool:Clone()
    Maid[player.Name] = toolClone
    
    toolClone.Parent = player.Backpack
end


local function Shoot(player: Player,target: Instance?,tool: Tool,origin: Vector3,lookVector: Vector3,targetDistance: number)

    if target and target:GetAttribute('Balloon') then
        BalloonAPI.Pop(target)
    end

    local sound = tool:FindFirstChild('Shoot',true) :: Sound
    SoundUtil.PlayInInstance(sound,tool)

    RemoteUtil.FireAllClients('Effects','VisualizeRay',origin,lookVector,targetDistance)
end


WeaponEvent:OnServer('Shoot',Shoot)
CreateSignal:Connect(CreateWeapon)

