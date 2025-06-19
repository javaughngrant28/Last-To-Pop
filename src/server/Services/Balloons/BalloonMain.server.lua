

local Balloons = Instance.new('Folder')
Balloons.Parent = workspace
Balloons.Name = 'Balloons'

local Balloon = require(script.Parent.Balloon)
local BalloonAPI = require(script.Parent.BalloonAPI)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Maid: MaidModule.Maid = MaidModule.new()

local CreateSignal = BalloonAPI._CreateSignal()
local PopSignal = BalloonAPI._PopSignal()



local function Create(object: Model | Part, balloonName: string)
    local Ballon = Balloon.new(object,balloonName)
    Maid[Ballon.MODEL.PrimaryPart] = Ballon 
end

local function Pop(object: Part)
    local balloon = Maid[object] :: Balloon.BalloonType?
    
    if balloon then
        balloon:Pop()
    end

end


PopSignal:Connect(Pop)
CreateSignal:Connect(Create)


