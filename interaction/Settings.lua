return function(_Theme)
    local http = game:GetService("HttpService")
    local path = getgenv().VEX.data .. "/settings.json"

    local defaults = {
        apikey  = "",
        model   = "openai/gpt-oss-120b:fireworks-ai",
        persona = "You are VEX, a helpful Roblox AI agent. Be concise.",
        perms   = {
            isfile           = true,
            writefile        = false,
            createfolder     = false,
            read_device_file = false,
            decompile_toread = false,
            autorun          = false,
        },
    }

    local data = defaults
    if isfile(path) then
        pcall(function() data = http:JSONDecode(readfile(path)) end)
    end
    for k, v in pairs(defaults) do if data[k] == nil then data[k] = v end end
    for k, v in pairs(defaults.perms) do
        if data.perms[k] == nil then data.perms[k] = v end
    end

    local function save()
        pcall(function() writefile(path, http:JSONEncode(data)) end)
    end

    return {
        get = function(k) return data[k] end,
        set = function(k, v) data[k] = v; save() end,
        raw = function() return data end,
        save = save,
    }
end