local REPO   = "https://raw.githubusercontent.com/G4mg1/VexAI/main/"
local LOCAL  = "VexAI"
local LIB    = LOCAL .. "/lib"
local INTER  = LOCAL .. "/interaction"
local ASSETS = LOCAL .. "/Assets"
local DATA   = LOCAL .. "/data"
local SCRIPT = LOCAL .. "/scripts"

local function mkdir(path)
    if isfolder and makefolder then
        pcall(function()
            if not isfolder(path) then
                makefolder(path)
            end
        end)
    end
end

mkdir(LOCAL)
mkdir(LIB)
mkdir(INTER)
mkdir(ASSETS)
mkdir(DATA)
mkdir(SCRIPT)

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
    return (syn and syn.request)
        or (http and http.request)
        or http_request
        or request
        or (fluxus and fluxus.request)
        or (krnl and krnl.request)
end

local function fetch(rel)
    local url = REPO .. rel
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

for _, rel in ipairs(FILES) do
    local path = LOCAL .. "/" .. rel
    local body = fetch(rel)
    if body and writefile then
        pcall(writefile, path, body)
    end
end

if writefile and isfile and not isfile(LOCAL .. "/data/settings.json") then
    local s = fetch("data/settings.json")
    if s then pcall(writefile, LOCAL .. "/data/settings.json", s) end
end

if writefile and isfile and not isfile(LOCAL .. "/data/history.json") then
    local h = fetch("data/history.json")
    if h then pcall(writefile, LOCAL .. "/data/history.json", h) end
end

if writefile and isfile and not isfile(LOCAL .. "/logo.png") then
    local l = fetch("logo.png")
    if l then pcall(writefile, LOCAL .. "/logo.png", l) end
end

local function import(path)
    if not readfile then error("[VEX] executor has no readfile") end
    local src = readfile(path)
    if not src or src == "" then error("[VEX] empty file: " .. path) end
    local fn, err = loadstring(src)
    if not fn then error("[VEX] compile failed " .. path .. ": " .. tostring(err)) end
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
