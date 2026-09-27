local REPO   = "https://raw.githubusercontent.com/G4mg1/VexAI/main/"
local LOCAL  = "VexAI"
local LIB    = LOCAL .. "/lib"
local INTER  = LOCAL .. "/interaction"
local ASSETS = LOCAL .. "/Assets"
local DATA   = LOCAL .. "/data"
local SCRIPT = LOCAL .. "/scripts"

for _, f in ipairs({LOCAL, LIB, INTER, ASSETS, DATA, SCRIPT}) do
    if not isfolder(f) then makefolder(f) end
end

getgenv().VEX = {
    root        = LOCAL,
    lib         = LIB,
    interaction = INTER,
    assets      = ASSETS,
    data        = DATA,
    scripts     = SCRIPT,
    logo        = LOCAL .. "/logo.png",
    version     = "1.0.0",
}

local function getreq()
    return (syn and syn.request) or (http and http.request)
        or http_request or request
        or (fluxus and fluxus.request) or (krnl and krnl.request)
end

local http = game:GetService("HttpService")
local req  = getreq()

local FILES = {
    "lib/Theme.lua",
    "lib/Icons.lua",
    "lib/UI.lua",
    "interaction/AI.lua",
    "interaction/Settings.lua",
    "interaction/Permissions.lua",
    "interaction/Tools.lua",
    "interaction/Chat.lua",
    "data/settings.json",
    "data/history.json",
}

local function fetch(rel)
    if not req then return nil end
    local ok, res = pcall(function()
        return req({ Url = REPO .. rel, Method = "GET" })
    end)
    if ok and res and res.StatusCode == 200 then return res.Body end
    return nil
end

local function sync()
    for _, rel in ipairs(FILES) do
        local local_path = LOCAL .. "/" .. rel
        local isUserData = rel:sub(1, 5) == "data/"
        if not (isUserData and isfile(local_path)) then
            local body = fetch(rel)
            if body then
                pcall(function() writefile(local_path, body) end)
            end
        end
    end
end

sync()

if not isfile(LOCAL .. "/logo.png") then
    local logo = fetch("logo.png")
    if logo then pcall(function() writefile(LOCAL .. "/logo.png", logo) end) end
end

local function import(path)
    local src = readfile(path)
    local fn  = loadstring(src)
    assert(fn, "failed to compile " .. path)
    return fn()
end

local Theme    = import(LIB   .. "/Theme.lua")
local Icons    = import(LIB   .. "/Icons.lua")
local Settings = import(INTER .. "/Settings.lua")(Theme)
local Perms    = import(INTER .. "/Permissions.lua")(Settings)
local UI       = import(LIB   .. "/UI.lua")(Theme, Icons)
local Tools    = import(INTER .. "/Tools.lua")(UI, Perms)
local Chat     = import(INTER .. "/Chat.lua")(UI, Perms, Settings, Tools)

getgenv().userdata = getgenv().userdata or {}
function getgenv().userdata.gethfkey()          return Settings.get("apikey")  end
function getgenv().userdata.getpersona()        return Settings.get("persona") end
function getgenv().userdata.getperferredmodel() return Settings.get("model")   end

UI.onSend = function(text)
    if text == "" then return end
    Chat.send(text)
end

UI.onOpenSettings = function()
    UI.openSettings(Settings, Perms)
end

UI:toggle()
print("[VEX] loaded v" .. getgenv().VEX.version)