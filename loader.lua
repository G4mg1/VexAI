local REPO  = "https://raw.githubusercontent.com/G4mg1/VexAI/main/"
local LOCAL = "VexAI"

local FILES = {
    "lib/Theme.lua",
    "lib/Icons.lua",
    "lib/UI.lua",
    "interaction/AI.lua",
    "interaction/Settings.lua",
    "interaction/Permissions.lua",
    "interaction/Tools.lua",
    "interaction/Chat.lua",
}

local FOLDERS = {
    LOCAL,
    LOCAL .. "/lib",
    LOCAL .. "/interaction",
    LOCAL .. "/data",
    LOCAL .. "/Assets",
    LOCAL .. "/scripts",
}

local function getreq()
    return (syn and syn.request)
        or (http and http.request)
        or http_request
        or request
        or (fluxus and fluxus.request)
        or (krnl and krnl.request)
end

local function fetch(url)
    local req = getreq()
    if req then
        local ok, res = pcall(function()
            return req({ Url = url, Method = "GET" })
        end)
        if ok and res and res.StatusCode == 200 and res.Body and res.Body ~= "" then
            return res.Body
        end
    end
    local ok, body = pcall(function()
        return game:HttpGet(url, true)
    end)
    if ok and body and body ~= "" then return body end
    return nil
end

for _, dir in ipairs(FOLDERS) do
    if isfolder and makefolder and not isfolder(dir) then
        pcall(makefolder, dir)
    end
end

for _, rel in ipairs(FILES) do
    local body = fetch(REPO .. rel)
    if body then
        pcall(writefile, LOCAL .. "/" .. rel, body)
    else
        warn("[VEX loader] failed to fetch " .. rel)
    end
end

if isfile and writefile and not isfile(LOCAL .. "/data/settings.json") then
    local s = fetch(REPO .. "data/settings.json")
    if s then pcall(writefile, LOCAL .. "/data/settings.json", s) end
end

if isfile and writefile and not isfile(LOCAL .. "/data/history.json") then
    local h = fetch(REPO .. "data/history.json")
    if h then pcall(writefile, LOCAL .. "/data/history.json", h) end
end

if isfile and writefile and not isfile(LOCAL .. "/logo.png") then
    local l = fetch(REPO .. "logo.png")
    if l then pcall(writefile, LOCAL .. "/logo.png", l) end
end

local main = fetch(REPO .. "main.lua")
if not main then
    return warn("[VEX loader] could not fetch main.lua")
end

local fn, err = loadstring(main)
if not fn then
    return warn("[VEX loader] compile failed: " .. tostring(err))
end

fn()
