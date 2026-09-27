local REPO   = "https://raw.githubusercontent.com/G4mg1/VexAI/main/"
local LOCAL  = "VexAI"
local LIB    = LOCAL .. "/lib"
local INTER  = LOCAL .. "/interaction"
local ASSETS = LOCAL .. "/Assets"
local DATA   = LOCAL .. "/data"
local SCRIPT = LOCAL .. "/scripts"

local function mkdir(path)
    pcall(function()
        if isfolder and not isfolder(path) and makefolder then
            makefolder(path)
        end
    end)
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

local http = game:GetService("HttpService")

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
    "data/settings.json",
    "data/history.json",
}

for _, rel in ipairs(FILES) do
    local path = LOCAL .. "/" .. rel
    local isUserData = rel:sub(1, 5) == "data/"
    if not (isUserData and isfile and isfile(path)) then
        local body = fetch(rel)
        if body and writefile then
            pcall(writefile, path, body)
        end
    end
end

if writefile and not (isfile and isfile(LOCAL .. "/logo.png")) then
    local logo = fetch("logo.png")
    if logo then pcall(writefile, LOCAL .. "/logo.png", logo) end
end

local function import(path)
    if not readfile then
        error("[VEX] executor has no readfile")
    end
    local src = readfile(path)
    if not src or src == "" then
        error("[VEX] empty or missing file: " .. path)
    end
    local fn, err = loadstring(src)
    if not fn then
        error("[VEX] failed to compile " .. path .. ": " .. tostring(err))
    end
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
