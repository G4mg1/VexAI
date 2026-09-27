local ASSETS = getgenv().VEX.assets
local BASE   = "https://cdn.jsdelivr.net/npm/remixicon@4.5.0/icons/"

local NAMES = {
    "chat-3-line", "add-line", "settings-3-line", "home-5-line",
    "send-plane-2-fill", "robot-2-line", "user-line", "shield-check-line",
    "file-code-line", "folder-line", "brain-line", "sparkling-line",
    "close-line", "arrow-up-line", "menu-line", "tools-line",
}

local function getreq()
    return (syn and syn.request) or (http and http.request)
        or http_request or request
        or (fluxus and fluxus.request) or (krnl and krnl.request)
end

local req = getreq()
if req then
    for _, name in ipairs(NAMES) do
        local path = ASSETS .. "/" .. name .. ".svg"
        if not isfile(path) then
            pcall(function()
                local res = req({ Url = BASE .. name .. ".svg", Method = "GET" })
                if res and res.StatusCode == 200 then writefile(path, res.Body) end
            end)
        end
    end
end

local ASSET_IDS = {}

local GLYPHS = {
    ["chat-3-line"]        = "\u{1F4AC}",
    ["add-line"]           = "+",
    ["settings-3-line"]    = "\u{2699}",
    ["home-5-line"]        = "\u{2302}",
    ["send-plane-2-fill"]  = "\u{2191}",
    ["robot-2-line"]       = "\u{25C9}",
    ["user-line"]          = "\u{25CF}",
    ["shield-check-line"]  = "\u{2713}",
    ["file-code-line"]     = "\u{2261}",
    ["folder-line"]        = "\u{25A4}",
    ["brain-line"]         = "\u{25C8}",
    ["sparkling-line"]     = "\u{2726}",
    ["close-line"]         = "\u{2715}",
    ["arrow-up-line"]      = "\u{2191}",
    ["menu-line"]          = "\u{2630}",
    ["tools-line"]         = "\u{2692}",
}

return {
    get = function(name) return ASSET_IDS[name], GLYPHS[name] or "\u{2022}" end,
    names = NAMES,
}