export type RandomChanceInput = { [string]: number }

--> Variables
local _L = _G._L

--> Constants
local RandomChance

RandomChance = {
    GetResults = function(data: RandomChanceInput, count: number): {string}
        -- Validate input table
        assert(typeof(data) == "table", "Input data must be a table with string keys and numeric values.")
        assert(typeof(count) == "number" and count > 0, "Count must be a positive number.")

        local results = {}
        local items = {}
        local totalWeight = 0

        -- Process input table into a list with cumulative weights
        for name, weight in pairs(data) do
            -- Validate weights
            assert(typeof(name) == "string", "Keys in the input table must be strings.")
            assert(typeof(weight) == "number" and weight > 0, "All weights must be positive numbers.")
            totalWeight += weight
            table.insert(items, {name = name, cumulativeWeight = totalWeight})
        end

        -- Handle edge case: No valid items
        if #items == 0 then
            warn("Input table contains no valid items with positive weights.")
            return {}
        end

        -- Helper function to get a single random item
        local function getRandomItem()
            local rand = Random.new():NextNumber(0, totalWeight)
            for _, item in ipairs(items) do
                if rand <= item.cumulativeWeight then
                    return item.name
                end
            end
        end

        -- Get the desired number of unique items
        while #results < count and #results < #items do
            local selected = getRandomItem()
            if not table.find(results, selected) then
                table.insert(results, selected)
            end
        end

        return results
    end,

    GetRandomElement = function(data: {any}, resultAmount: number?): {any} | any
        local resultAmount = resultAmount or 1
        local results = {}

        for i = 1, resultAmount do
            local randomIndex = math.random(1, #data)
            table.insert(results, data[randomIndex])
        end

        if resultAmount == 1 then
            return results[1]
        else
            return results
        end
    end
}

return RandomChance
