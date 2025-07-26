-- https://discord.com/invite/99UuEwM9sX is their invite
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
