local ApplyImpulse = {}

function ApplyImpulse.Fire(targetModel: Model, diraction: Vector3, distance: number, duration: number?)
    print(targetModel,diraction,distance,duration)
    local rootPart = targetModel:FindFirstChild('HumanoidRootPart') or targetModel.PrimaryPart :: Part

    task.defer(function()
        local duration = duration or 0.4
        local force = (diraction * distance) / duration +  Vector3.new(0,workspace.Gravity * duration * 0.5,0)

        rootPart.Velocity = Vector3.zero
        rootPart.AssemblyLinearVelocity = Vector3.zero
      
        rootPart:ApplyImpulse(force * rootPart.AssemblyMass)
    end)
end

return ApplyImpulse