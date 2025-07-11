
local BalloonAPI = require(script.Parent.BalloonAPI)
local Balloon = require(script.Parent.Balloon)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)


local CreateSignal = BalloonAPI._CreateSignal()
local DestroySignal = BalloonAPI._DestroySignal()
local PopSignal = BalloonAPI._PopSignal()

local Maid: MaidModule.Maid = MaidModule.new()


local function GetBalloon(identifier: string | Part) : Balloon.BalloonType?
    local existingBalloon = Maid[identifier] :: Balloon.BalloonType
    if not  existingBalloon then
        warn(`Balloon Not Found Using Identifier {typeof(identifier)} : {identifier}`)
        return
    end
    return existingBalloon
end


local function Create(part: Part, player: Player?)
    local Balloon = Balloon.new(part,player) :: Balloon.BalloonType

    Maid[part] = Balloon
    Maid[Balloon.HITBOX] = Balloon
    if player then
        Maid[player.Name] = Balloon
    end
end

local function Pop(identifier: string | Part)
    local Balloon = GetBalloon(identifier)
    if Balloon then
        Balloon:Pop()
    end
end

local function Destroy(identifier: string | Part)
    local Balloon = GetBalloon(identifier)
    if Balloon then
        Balloon:Destroy()
    end
end



CreateSignal:Connect(Create)
DestroySignal:Connect(Destroy)
PopSignal:Connect(Pop)
