


local function CreateInViewport(viewport: ViewportFrame): Camera
    local camara = Instance.new('Camera')
    camara.Parent = viewport
    camara.CameraType = Enum.CameraType.Fixed
    viewport.CurrentCamera = camara
    camara.CFrame = CFrame.new(0,0,0)
    return camara
end

local function OffsetPositionBasedOnModelSize(camara: Camera, model: Model, offsetScale: number?)
    local offsetScale = offsetScale or 1
    local size = model:GetExtentsSize()
    local maxDimension = math.max(size.X, size.Y, size.Z)
    local distance = maxDimension * offsetScale
    camara.CFrame = model.PrimaryPart.CFrame
    camara.CFrame *= CFrame.new(0,0,distance)
    camara.CFrame = CFrame.new(camara.CFrame.Position,model.PrimaryPart.CFrame.Position)
end

local function ModelToViewport(viewportFrame: ViewportFrame, model: Model)
    local camera = CreateInViewport(viewportFrame)
    model.Parent =viewportFrame
    OffsetPositionBasedOnModelSize(camera,model)
end



return {
    AddModel = ModelToViewport
}