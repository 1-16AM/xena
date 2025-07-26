-- thx despo love u

local DEBUG = false

local Http = {}

local HttpService = game:GetService("HttpService")

local GlobalENV = getgenv()
local Typeof = typeof

local UrlIntercepts = {}

local function addBypass(url, method, callback)
	url = url or "ALL"
	if not UrlIntercepts[url] then
		UrlIntercepts[url] = {}
	end
	UrlIntercepts[url][method:upper()] = callback
end

type table = {
	[any]: any,
}

type ScanRequest = {
	Url: string,
	Body: string | nil,
	IsPost: boolean?,
	IsTable: boolean?,
	Headers: table?,
	Method: string,
}
function Http:ScanHTTPRequest(Args: {}): ScanRequest
	local Request = {}

	for Index: number, Arg in next, Args do
		if DEBUG then
			warn(string.format("%d: %s", Index, tostring(Arg)))
		end

		if Typeof(Arg) == "string" then
			Request.Url = Arg
			Request.Method = "GET"
			if not DEBUG then
				break
			end
		elseif Typeof(Arg) == "table" then
			local Url = Arg.Url or Arg.url
			if not Url then
				continue
			end

			local Body = Arg.Body or Arg.body
			local Method = Arg.Method or Arg.method or (Body and "POST" or "GET")

			Request.Url = Url
			Request.Body = Body
			Request.IsPost = Body and true or false
			Request.IsTable = true
			Request.Headers = Arg.Headers
			Request.Method = Method:upper()

			if not DEBUG then
				break
			end
			warn(string.format("Found! %d: %s, %s", Index, tostring(Arg.Url), tostring(Arg.url)))
		end
	end

	return Request
end

local function HttpCallback(OldFunc, ...)
	local Args = { ... }

	local Request = Http:ScanHTTPRequest(Args)
	if not Request or not Request.Url then
		return OldFunc(...)
	end

	local Url = Request.Url
	local Method = Request.Method

	local OriginalResponce = OldFunc(...)

	local IsOriginalResponceTable = Typeof(OriginalResponce) == "table"
	local CurrentResponceBody = IsOriginalResponceTable and OriginalResponce.Body or OriginalResponce
	local FinalResponceBody = CurrentResponceBody

	local matchedBypass = nil

	for UrlMatch, Methods in next, UrlIntercepts do
		if Url:match(UrlMatch) or string.lower(Url):find(string.lower(UrlMatch)) or UrlMatch == "ALL" then
			if Methods[Method] then
				matchedBypass = Methods[Method]
				break
			end
		end
	end

	if matchedBypass then
		if Typeof(matchedBypass) == "function" then
			FinalResponceBody = matchedBypass(FinalResponceBody, Request)
		end
	end

	if IsOriginalResponceTable then
		local FinalResponceTable = {}
		for k, v in pairs(OriginalResponce) do
			FinalResponceTable[k] = v
		end
		FinalResponceTable.Body = FinalResponceBody
		return FinalResponceTable
	else
		return FinalResponceBody
	end
end

local Hook = {}
type Hook = {
	Hooks: { [string]: any },
	Globals: { [number]: string }?,
}
type Hooks = {
	[Instance]: Hook,
}
Hook.Hooks = {}
Hook.Cache = setmetatable({}, { __mode = "k" })
Hook.Alliases = {
	["HTTP_HOOK"] = HttpCallback,
}

function Hook:GetHooks(): Hooks
	return self.Hooks
end
function Hook:IsObject(Object: Instance?)
	local Type = Typeof(Object)
	return Type == "Instance"
end
function Hook:GetHooksForObject(Instance): Hook
	return self.Hooks[Instance]
end
function Hook:AddRefernce(Instance, Hooks: Hook)
	if not Instance then
		return
	end
	self.Hooks[Instance] = Hooks
end
function Hook:GetCached(Instance)
	return self.Cache[Instance]
end
function Hook:AddCached(Instance, Proxy)
	self.Cache[Instance] = Proxy
end
function Hook:Hook(Object: Instance, Hooks: table)
	local Cached = self:GetCached(Object)
	if Cached then
		return Cached
	end

	local Proxy = newproxy(true)
	local Meta = getmetatable(Proxy)

	Meta.__index = function(self, Key: string)
		local Hook = Hooks[Key]

		if Hook then
			if DEBUG then
				warn("> Spoofed", Key)
			end
			return Hook
		end

		local Value = Object[Key]

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

		local IsReadOnly = false
		if typeof(Object) == "table" then
			IsReadOnly = table.isfrozen(Object)
		end

		if IsReadOnly then
			setreadonly(Object, false)
		end

		for Key: string, Value in next, Hooks do
			local Success, OldValue = xpcall(function()
				return Object[Key]
			end, warn)

			if not Success then
				continue
			end

			if Typeof(OldValue) == "function" then
				if IsObject then
					local OldFunc = OldValue
					OldValue = function(self, ...)
						return OldFunc(Object, ...)
					end
				end

				if iscclosure(OldValue) then
					OldValue = newcclosure(OldValue)
				end
			end

			if typeof(Value) == "string" then
				local Callback = Alliases[Value]

				if Callback then
					Value = function(...)
						return Callback(OldValue, ...)
					end
				end
			end

			Hooks[Key] = Value

			if not IsObject then
				Object[Key] = Value
			end
		end

		if IsObject then
			local Proxy = self:Hook(Object, Hooks)
			if not Globals then
				continue
			end

			for _, Global: string in next, Globals do
				GlobalENV[Global] = Proxy
			end

			continue
		end

		if IsReadOnly then
			setreadonly(Object, true)
		end
	end
end

local function AddHooks()
	Hook:AddRefernce(game, {
		Globals = { "game", "Game" },
		Hooks = {
			["HttpGet"] = "HTTP_HOOK",
			["HttpGetAsync"] = "HTTP_HOOK",
			["HttpPost"] = "HTTP_HOOK",
			["HttpPostAsync"] = "HTTP_HOOK",
		},
	})

	Hook:AddRefernce(GlobalENV, {
		Hooks = {
			["http_request"] = "HTTP_HOOK",
			["request"] = "HTTP_HOOK",
		},
	})

	Hook:AddRefernce(http, {
		Hooks = {
			["request"] = "HTTP_HOOK",
		},
	})

	Hook:AddRefernce(syn, {
		Hooks = {
			["request"] = "HTTP_HOOK",
		},
	})
end

AddHooks()
Hook:ApplyHooks()

return addBypass
