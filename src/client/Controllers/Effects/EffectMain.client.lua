local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)
local EffectAPI = require(script.Parent.EffectsAPI)

local EffectsFolder = game.ReplicatedStorage.Effects


local FireSignal = EffectAPI._FireSignal()



local EffectModules = {} :: {
    [string]: {
        new: (...any)->()
    }
}



local function onEffectFound(effect: Folder | {[string]: any})
    if not typeof(effect) == "table" and not effect:IsA('Folder') then
        warn(`{effect} Is Not A Folder Or A Table`)
    end

    local effectName = effect['Name']
    local effectModule = EffectModules[effectName]
    assert(effectModule,`{effectName} Effect Module Not Found`)

    effectModule.new(effect)
end



for _, child: ModuleScript in script.Parent:GetChildren() do
    if not child:IsA('ModuleScript') then continue end
    if child.Name == 'EffectsAPI' then continue end
    
    local effectModuel = require(child)

    if not effectModuel['new'] then
        warn(`{child.Name} Effect Module Does Not Have 'Fire' Founction`)
        continue
    end

    EffectModules[child.Name] = effectModuel
end

for _, folder: Folder in EffectsFolder:GetChildren() do
    if not folder:IsA('Folder') then
        warn(`{folder} Is Not A Folder`)
        else
            onEffectFound(folder)
    end
end



EffectsFolder.ChildAdded:Connect(onEffectFound)

