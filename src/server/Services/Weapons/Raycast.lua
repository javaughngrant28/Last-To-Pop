

local function CreatRay(origin: Vector3, dirction: Vector3, distance: number, excludeList: {Instance | Model?}): RaycastResult
    local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = excludeList
	
	return workspace:Raycast(origin, dirction * distance, raycastParams)
end

return {
    Fire = CreatRay
}