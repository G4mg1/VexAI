return function(UI, Perms)
    local T = {}
    local Players = game:GetService("Players")

    function T.playerCount()
        UI:addStatus("Performing game access")
        local n = #Players:GetPlayers()
        for _, p in ipairs(Players:GetPlayers()) do
            UI:addStatus("got player (" .. p.Name .. ")")
        end
        return n
    end

    function T.flagSelf()
        local me = Players.LocalPlayer
        UI:addStatus("flagging me as ( " .. me.Name .. " )")
        return me.Name
    end

    function T.gameInfo()
        UI:addStatus("Performing game access")
        return {
            PlaceId   = game.PlaceId,
            JobId     = game.JobId,
            Players   = #Players:GetPlayers(),
            Workspace = #workspace:GetChildren(),
        }
    end

    function T.writeScript(name, src)
        return Perms.guard("writefile", function()
            UI:addStatus("making an script !")
            local dir = getgenv().VEX.scripts
            if not isfolder(dir) then makefolder(dir) end
            local path = dir .. "/" .. name .. ".lua"
            writefile(path, src)
            if Perms.get("autorun") then
                UI:addStatus("running command")
                local fn = loadstring(src)
                if fn then pcall(fn) end
            end
            return path
        end, function()
            UI:addStatus("blocked: writefile permission denied")
        end)
    end

    function T.decompile(target)
        return Perms.guard("decompile_toread", function()
            UI:addStatus("Performing game access")
            if decompile then
                local ok, res = pcall(decompile, target)
                return ok and res or tostring(res)
            end
            return "-- decompile not available on this executor"
        end, function()
            UI:addStatus("blocked: decompile_toread permission denied")
        end)
    end

    return T
end