return function(UI, _Perms, _Settings, Tools)
    local C = {}

    local AI = loadstring(readfile(getgenv().VEX.interaction .. "/AI.lua"))()
    local instance = AI({
        username       = game.Players.LocalPlayer.Name,
        chat           = nil,
        perm           = nil,
        currentpersona = getgenv().userdata.getpersona(),
    })

    function C.send(text)
        UI:addRecent(text:sub(1, 28))
        UI.addMessage("user", text)
        UI.showThinking()

        UI.addStatus("Performing game access")
        Tools.playerCount()

        task.spawn(function()
            local reply = instance.chat(text)
            UI.hideThinking()
            if reply then
                UI.addMessage("assistant", reply)
            else
                UI.addMessage("assistant", "Request failed. Check your API key in Settings.")
            end
        end)
    end

    return C
end