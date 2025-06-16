
local Players = game:GetService("Players")
local player = Players.LocalPlayer

type CallbackFunctionType = (Tool) -> ()
type CallbackTableType = { [CallbackFunctionType]: string }
type ConnectedTableType = {[CallbackFunctionType]: {Tool}}

local CallbackTable = {} :: CallbackTableType
local ConnectedTable = {} :: ConnectedTableType

local function AttemptCallback(tool: Instance)
	if not tool:IsA('Tool') then return end

	for func, className in pairs(CallbackTable) do
		local attributes = tool:GetAttributes()
		ConnectedTable[func] = ConnectedTable[func] or {}

		if table.find(ConnectedTable[func], tool) then return end

		if attributes['Class'] and attributes['Class'] == className then
			func(tool)
		else
			func(tool)
		end

		table.insert(ConnectedTable[func], tool)
	end
end

local function backPackConnection(backPack: Instance)
	if not backPack:IsA('Backpack') then return end
	backPack.ChildAdded:Connect(function(tool: Instance)
		AttemptCallback(tool)
	end)
end


local function FindExistingTool(func: CallbackFunctionType, className: string?)
	local backpack = player:WaitForChild('Backpack',10)
	
	for _, tool in backpack:GetChildren() do
		AttemptCallback(tool)
	end
	
	if not player.Character then return end
	
	for _, tool in player.Character:GetChildren() do
		AttemptCallback(tool)
	end
end

local function AddToConnectionTable(func: CallbackFunctionType,className: string?)
	local className = className or ''
	CallbackTable[func] = className
end

local function NewConnection(func: CallbackFunctionType,className: string?)
	AddToConnectionTable(func,className)
	FindExistingTool(func,className)
end

local function DestroyConnections(func: CallbackFunctionType)
	CallbackTable[func] = nil
	ConnectedTable[func] = nil
end

if player:FindFirstChild('Backpack') then
	backPackConnection(player.Backpack)
end

local con
con = player.ChildAdded:Connect(function(child: Instance)
	backPackConnection(child)
end)


return {
	new = NewConnection,
	destroy = DestroyConnections
}



