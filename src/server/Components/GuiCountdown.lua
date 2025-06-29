
local ScreenGuiUtil = require(game.ReplicatedStorage.Shared.Utils.ScreenGuiUtil)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local GUICountdown = {}

function GUICountdown.Create(screen: ScreenGui | string, duration: number, text: string?, yeiled: boolean?)
    local connection: RBXScriptConnection
    local startedTime = os.time()
    local goalTime = startedTime + duration

    connection = ScreenGuiUtil.AddToAllPlayersWithConnection(screen,function(player: Player, screen: ScreenGui)
        RemoteUtil.FireClient(player,'AnimateCountdownLable',screen,startedTime,goalTime,text)
    end)

    local function Destroy()
        connection:Disconnect()
        ScreenGuiUtil.RemoveFromAllPlayers(screen)
    end

    local function RunTime()
        while goalTime - os.time() > 0 do
            task.wait(1)
        end
        Destroy()
    end

    if yeiled then
        RunTime()
        else
            task.spawn(RunTime)
    end
end


return GUICountdown