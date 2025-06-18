

local function CreatRay(origin: Vector3, dirction: number, distance: number, excludeList: {Instance}): RaycastResult
    local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = excludeList
	
	return workspace:Raycast(origin, dirction * distance, raycastParams)
end

return {
    Fire = CreatRay
}