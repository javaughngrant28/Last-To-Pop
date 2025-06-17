

local WeaponAPI = require(script.Parent.WeaponAPI)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Tools = game.ReplicatedStorage.Assets.Tools

local Maid: MaidModule.Maid = MaidModule.new()
local CreateSignal = WeaponAPI.CreateSignal()



local function CreateWeapon(player: Player)
    local weaponName = player:FindFirstChild('Weapon',true) :: StringValue
    
    local tool = Tools:FindFirstChild(weaponName.Value)
    assert(tool,`{weaponName.Value} Tool Not Found`)
    
    local toolClone = tool:Clone()
    Maid[player.Name] = toolClone
    
    toolClone.Parent = player.Backpack
end


CreateSignal:Connect(CreateWeapon)

