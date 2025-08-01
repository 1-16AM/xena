--// Created by depso!
-- This is a simple Http request spy with a UI interface
-- This is designed to work on very basic level exploits such as Xeno and Solara
-- JOIN THE DISCORD SERVER: https://discord.gg/s9ngmUDWgb


local DEBUG = false
local SHOW_RESPONSES = falses

--// Libraries
local Hook = {}
local Http = {}

--// ReGui
local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
local PrefabsId = `rbxassetid://{ReGui.PrefabsId}`
ReGui:Init({
    Prefabs = game:GetObjects(PrefabsId)[1]
})

local HttpService = game:GetService("HttpService")

--// Globals
local GlobalENV = getgenv()
local Typeof = typeof

--// Config
local UrlIntercepts = {
    ["http://127.0.0.1:6463/rpc?v=1"] = {
        Callback = function()
            warn("Blocked discord inivite!")
            return ""
        end,
    },
}

local function AddHooks()
    Hook:AddRefernce(game, {
        Globals = {"game", "Game"},
        Hooks = {
            ["HttpGet"] = "HTTP_HOOK",
            ["HttpGetAsync"] = "HTTP_HOOK",
            ["HttpPost"] = "HTTP_HOOK",
            ["HttpPostAsync"] = "HTTP_HOOK"
        }
    })

    Hook:AddRefernce(GlobalENV, {
        Hooks = {
            ["http_request"] = "HTTP_HOOK",
            ["request"] = "HTTP_HOOK",
        }
    })

    Hook:AddRefernce(http, {
        Hooks = {
            ["request"] = "HTTP_HOOK",
        }
    })

    Hook:AddRefernce(syn, {
        Hooks = {
            ["request"] = "HTTP_HOOK",
        }
    })
end

----// Main script
type table = {
    [any]: any
}

--// Create window
local Console = nil
local Paused = false

local function Log(...)
    return Console:AppendText(...)
end

local Window = ReGui:Window({
    Title = "Http Spy | By: Depso",
    Theme = "ImGui",
    Size = UDim2.new(0, 350, 0, 370),
    NoScroll = true
}):Center()

--// Buttons
local ButtonsRow = Window:Row()
ButtonsRow:Button({
    Text = "Clear",
    Callback = function()
        Console:Clear()
    end
})
ButtonsRow:Button({
    Text = "Copy",
    Callback = function()
        local Content = Console:GetValue()
        toclipboard(Content)
    end
})
ButtonsRow:Button({
    Text = "Pause",
    Callback = function(self)
        Paused = not Paused

        local Text = Paused and "Paused" or "Pause"
        self.Text = Text

        --// Update console
        Console.Enabled = not Paused
    end,
})

ButtonsRow:Button({
    Text = "Show Responses",
    Callback = function(self)
        SHOW_RESPONSES = not SHOW_RESPONSES

        local Text = SHOW_RESPONSES and "Hide Responses" or "Show Responses"
        self.Text = Text
    end,
})
ButtonsRow:Expand()

--// Create console
Console = Window:Console({
    Text = "-- Created by depso",
    ReadOnly = true,
    Border = false,
    Fill = true,
    Enabled = true,
    AutoScroll = true,
    RichText = true,
    MaxLines = 50
})

--// HTTP detection functions
type ScanRequest = {
    Url: string,
    Body: (string|nil),
    IsPost: boolean?,
    IsTable: boolean?,
}
function Http:ScanHTTPRequest(Args: {}): ScanRequest
    local Request = {}

    --// Search string/table for string content
    for Index: number, Arg in next, Args do
        --// Log each parameter for debugging
        if DEBUG then
            warn(`{Index}: {Arg}`)
        end

        --// :HttpGet
        if Typeof(Arg) == "string" then
            Request.Url = Arg
            if not DEBUG then break end
            --// request
        elseif Typeof(Arg) == "table" then
            local Url = Arg.Url or Arg.url
            if not Url then continue end

            --// Unpack content
            local Body = Arg.Body or Arg.body
            Request.Url = Url
            Request.Body = Body
            Request.IsPost = Body and true or false
            Request.IsTable = true
            Request.Headers = Arg.Headers

            if not DEBUG then break end
            warn(`Found! {Index}: {Arg.Url}, {Arg.url}`)
        end
    end

    return Request
end
function Http:FindIntercept(Url: string): table?
    for UrlMatch, Data in next, UrlIntercepts do
        if Url:match(UrlMatch) then
            warn(`Matched {UrlMatch} with {Url}`)
            return Data
        end
    end
    return
end

local function HttpCallback(OldFunc, ...)
    local Args = {...}

    --// Scan arguments for HTTP request infomation
    local Request = Http:ScanHTTPRequest(Args)
    if not Request then return end

    --// Unpack arguments
    local IsPost = Request.IsPost
    local IsTable = Request.IsTable
    local Url = Request.Url
    local Body = Request.Body
    local Headers = Request.Headers

    if not Url then
        return OldFunc(...)
    end

    --// Log HTTP request infomation
    Log("HTTP", `[{IsPost and "POST" or "GET"}]:`, Url)

    --// Post request
    if Body then
        Log("> [Body] ", Body)
        Log("> [Headers] ", HttpService:JSONEncode(Headers))
    end

    local Responce = nil

    --// Check for URL intercepts
    local Intercept = Http:FindIntercept(Url)

    --// Fetch HTTP request responce
    if not Intercept or Intercept.PassResponce then
        Responce = OldFunc(...)
    end

    --// Log the response if SHOW_RESPONSES is true
    if SHOW_RESPONSES and Responce ~= nil then
        local FormattedResponse = tostring(Responce)

        --// Check if the response is a table and format it with JSONEncode
        if type(Responce) == "table" then
            -- The 'pcall' is a good practice to prevent errors if the table can't be encoded
            local Success, Result = pcall(HttpService.JSONEncode, HttpService, Responce)
            if Success then
                FormattedResponse = Result
            else
                FormattedResponse = "Error: Could not encode table to JSON."
            end
        end

        Log("> [Response] ", FormattedResponse)
    end

    --// Return responce if there is no intercept
    if not Intercept then return Responce end

    --// Check if spoof is a function
    local Spoofed = Intercept.Callback

    if Typeof(Spoofed) == "function" then
        if Intercept.PassResponce then
            Spoofed = Spoofed(Responce, Request)
        else
            Spoofed = Spoofed(Request)
        end
    end

    --// Hook table reponse type
    if IsTable then
        local Base = Responce or {}
        return Hook:Hook(Base, {
            ["Body"] = Spoofed
        })
    end

    return Spoofed
end

--// Hook service
type Hook = {
    Hooks: {[string]: any},
    Globals: {[number]: string}?,
}
type Hooks = {
    [Instance]: Hook
}
Hook.Hooks = {}
Hook.Cache = setmetatable({}, {__mode = "k"})
Hook.Alliases = {
    ["HTTP_HOOK"] = HttpCallback
}

function Hook:GetHooks(): Hooks
    return self.Hooks
end
function Hook:IsObject(Object: Instance?)
    local Type = Typeof(Object)
    --local Accepted = {"userdata", "Instance"}
    --return table.find(Accepted, Type)
    return Type == "Instance"
end
function Hook:GetHooksForObject(Instance): Hook
    return self.Hooks[Instance]
end
function Hook:AddRefernce(Instance, Hooks: Hook)
    if not Instance then return end
    self.Hooks[Instance] = Hooks
end
function Hook:GetCached(Instance)
    return self.Cache[Instance]
end
function Hook:AddCached(Instance, Proxy)
    self.Cache[Instance] = Proxy
end
function Hook:Hook(Object: Instance, Hooks: table)
    --// Cache check
    local Cached = self:GetCached(Object)
    if Cached then return Cached end

    local Proxy = newproxy(true)
    local Meta = getmetatable(Proxy)

    Meta.__index = function(self, Key: string)
        local Hook = Hooks[Key]

        -- __index hook
        if Hook then
            if DEBUG then
                Log("> Spoofed", Key)
            end
            return Hook
        end

        local Value = Object[Key]

        -- __namecall patch
        if type(Value) == "function" then
            return function(self, ...)
                return Value(Object, ...)
            end
        end

        return Value
    end
    Meta.__newindex = function(self, Key: string, New)
        Object[Key] = New
    end
    Meta.__tostring = function()
        return tostring(Object)
    end
    Meta.__metatable = getmetatable(Object)

    --// Cache proxy
    self:AddCached(Object, Proxy)

    return Proxy
end
function Hook:ApplyHooks()
    local AllHooks = self:GetHooks()
    local Alliases = self.Alliases

    for Object, Data in next, AllHooks do
        local IsObject = self:IsObject(Object)
        local Hooks = Data.Hooks
        local Globals = Data.Globals

        --// Check table for read-only
        local IsReadOnly = false
        if typeof(Object) == "table" then
            IsReadOnly = table.isfrozen(Object)
        end

        --// Set writable
        if IsReadOnly then
            setreadonly(Object, false)
        end

        --// Add hooks to object or enviroment
        for Key: string, Value in next, Hooks do
            local Success, OldValue = xpcall(function()
                return Object[Key]
            end, warn)

            if not Success then continue end

            if Typeof(OldValue) == "function" then
                --// Patch namecall methods
                if IsObject then
                    local OldFunc = OldValue
                    OldValue = function(self, ...)
                        return OldFunc(Object, ...)
                    end
                end

                --// Closure type patch
                if iscclosure(OldValue) then
                    OldValue = newcclosure(OldValue)
                end
            end

            --// Find Allias
            if typeof(Value) == "string" then
                local Callback = Alliases[Value]

                --// Patch allias function
                if Callback then
                    Value = function(...)
                        return Callback(OldValue, ...)
                    end
                end
            end

            --// Apply new value
            Hooks[Key] = Value

            --// For others such as tables
            if not IsObject then
                Object[Key] = Value
            end
        end

        -- Hook functions of a instance
        if IsObject then
            local Proxy = self:Hook(Object, Hooks)
            if not Globals then continue end

            --// Add global references to environment
            for _, Global: string in next, Globals do
                GlobalENV[Global] = Proxy
            end

            continue
        end

        --// Set read only
        if IsReadOnly then
            setreadonly(Object, true)
        end
    end
end

--// Init
AddHooks()
Hook:ApplyHooks()

Log("Loaded successfully!")
