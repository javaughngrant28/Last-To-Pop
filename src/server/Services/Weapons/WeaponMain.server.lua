

local WeaponAPI = require(script.Parent.WeaponAPI)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local SoundUtil = require(game.ReplicatedStorage.Shared.Utils.SoundUtil)

local VisualizeRay = require(script.Parent.VisualizeRay)
local Raycast = require(script.Parent.Raycast)


local Tools = game.ReplicatedStorage.Assets.Tools

local Maid: MaidModule.Maid = MaidModule.new()
local CreateSignal = WeaponAPI.CreateSignal()
local WeaponEvent: NameSpaceEvent.Server = NameSpaceEvent.new('Weapon',{'Shoot'})

local SHOOT_DISTANCE = 100


local function CreateWeapon(player: Player)
    local weaponName = player:FindFirstChild('Weapon',true) :: StringValue
    
    local tool = Tools:FindFirstChild(weaponName.Value)
    assert(tool,`{weaponName.Value} Tool Not Found`)
    
    local toolClone = tool:Clone()
    Maid[player.Name] = toolClone
    
    toolClone.Parent = player.Backpack
end


local function Shoot(player: Player,tool: Tool, origin: Vector3, dirction: Vector3)

    local sound = tool:FindFirstChild('Shoot',true) :: Sound

    local result = Raycast.Fire(origin,dirction,SHOOT_DISTANCE,{
        player.Character,
        tool
    })

    local target = result and result.Instance or false
    local targetDistance = target and result.Distance or SHOOT_DISTANCE

    VisualizeRay.Fire(origin,dirction,targetDistance)

    if target then
        print(target)
    end

    SoundUtil.PlayInInstance(sound,tool)
end


WeaponEvent:OnServer('Shoot',Shoot)
CreateSignal:Connect(CreateWeapon)

