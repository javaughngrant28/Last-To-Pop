
local function CreatValueInstance(name: string, dataType: any): ValueBase
    local valueInstance: ValueBase

    if typeof(dataType) == 'Instance' then
        valueInstance = Instance.new('ObjectValue')
    end

    if typeof(dataType) == "number" then
        valueInstance = Instance.new('NumberValue')
    end

    if typeof(dataType) == 'string' then
        valueInstance = Instance.new('StringValue')
    end

    if typeof(dataType) == 'boolean' then
        valueInstance = Instance.new('BoolValue')
    end

    if typeof(dataType) == 'CFrame' then
        valueInstance = Instance.new('CFrameValue')
    end

    if typeof(dataType) == 'Vector3' then
        valueInstance = Instance.new('Vector3Value')
    end

    if typeof(dataType) == 'BrickColor' then
        valueInstance = Instance.new('BrickColorValue')
    end

    if typeof(dataType) == 'Color3' then
        valueInstance = Instance.new('Color3Value')
    end

    if typeof(dataType) == 'Ray' then
        valueInstance = Instance.new('RayValue')
    end

    assert(dataType,`{dataType} Does Not Have A ValueBase`)
    
    valueInstance.Name = name
    valueInstance.Value = dataType
    
    return valueInstance
end

local function DataToInsatnce(folderName: string, data: {[string]: any}): Folder
    local parentFolder = Instance.new('Folder')
    parentFolder.Name = folderName

    for index: string, value: any  in pairs(data) do
        if typeof(value) == 'table' then
            local folder = DataToInsatnce(index,value)
            folder.Parent = parentFolder
            else
                local valueInstance = CreatValueInstance(index,value)
                valueInstance.Parent = parentFolder
        end
    end 

    return parentFolder
end


return {
    ToInstance = DataToInsatnce
}
