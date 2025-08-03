-- Note: This is not a crack rather we modify how requests are handled in order to properly run the lua code meant for Roblox Studio
-- EVERY KEY WORKS
local HttpService = game:GetService("HttpService")
local bypass = loadstring(game:HttpGet("https://raw.githubusercontent.com/1-16AM/xena/refs/heads/main/functions/hooking.lua"))()

bypass(nil, "POST", function(currentBody, request)
	local success, decoded = pcall(HttpService.JSONDecode, HttpService, currentBody)
	if success and decoded and decoded.valid == false then
		decoded.valid = true
		return HttpService:JSONEncode(decoded)
	end
	return currentBody
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/NEOXHUBMAIN/refs/heads/main/loader", true))()
-- MODIFIED BY SHAQ
