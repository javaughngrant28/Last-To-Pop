
local NameSpaceEvent = require(game.ReplicatedStorage.Shared.Modules.NameSpaceEvent)
local Rarity = require(game.ServerScriptService.Modules.Rarity)
local BalloonData = require(game.ReplicatedStorage.Shared.Data.Balloons)

local ChestEvent: NameSpaceEvent.Server = NameSpaceEvent.new('Chests',{'Open','Show'})

local ChancesTable = {
    Chest1 = require(script.Parent.Chest1),
} :: {[string]: {[string]: number}}





function OpenChest(player: Player, chestName: string)
    local Chance = ChancesTable[chestName]
    if not Chance then warn(`{chestName} No In ChanceTable`) return end

    local rarityTable = Rarity.GetResults(Chance,1)
    local rarity = rarityTable[1]
    local balloonsFromRarity = BalloonData[rarity]

    local randomIndex = math.random(1,#balloonsFromRarity)

    ChestEvent:FireClient('Show',player,rarity,randomIndex)
end

ChestEvent:OnServer('Open',OpenChest)

