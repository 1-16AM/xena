local HttpService = game:GetService("HttpService")
local bypass = loadstring(game:HttpGet("https://raw.githubusercontent.com/1-16AM/xena/refs/heads/main/functions/hooking.lua"))()

bypass(nil, "GET", function(currentBody, request)
	local success, decoded = pcall(HttpService.JSONDecode, HttpService, currentBody)
	if success and decoded and decoded.valid == false then
		local appendedBody = {
			valid = true,
			deleted = false,
			info = {
				token = "",
				createdAt = tick(),
				byIp = "127.0.0.1",
				linkId = 777453,
				expiresAfter = tick() + 9999999999999,
				stepsDone = {},
				isPremiumUser = true,
			},
		}
		return HttpService:JSONEncode(appendedBody)
	end
	return currentBody
end) -- 8 bit rivals

writefile("8bit.txt", "https://discord.gg/VSKCM7rXVY")

loadstring(game:HttpGet("https://raw.githubusercontent.com/8bits4ya/rivals-v3/refs/heads/main/main.lua"))()
-- CRACKED BY SHAQ
