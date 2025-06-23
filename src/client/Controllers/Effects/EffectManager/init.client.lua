local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local EffectAPI = require(script.Parent.EffectsAPI)

local FireSignal = EffectAPI._FireSignal()

local Effects = {} :: {
    [string]: {
        Fire: (...any)->()
    }
}

for _, child: ModuleScript in script:GetChildren() do
    if not child:IsA('ModuleScript') then continue end
    local effectModuel = require(child)

    if not effectModuel['Fire'] then
        warn(`{child.Name} Effect Module Does Not Have 'Fire' Founction`)
        continue 
    end

    Effects[child.Name] = effectModuel
end



local function onFire(effectName: string,...)
    local effectModule = Effects[effectName]
    assert(effectModule,`{effectName} Effect Module Not Found`)

    effectModule.Fire(...)
end


FireSignal:Connect(onFire)
RemoteUtil.OnClient('Effects',onFire)


