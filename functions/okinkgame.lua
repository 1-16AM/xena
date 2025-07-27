if not hookfunction then
	local regui =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"))()

	for i=1, 16 do
		local prompt = regui
		:Window({
			Title = "Sorry..",
			Size = UDim2.fromOffset(300, 125),
			NoCollapse = true,
			NoResize = true,
			NoScroll = true,
		})
		:Center()
	do
		prompt:Label({
			Text = "YOUR EXECUTOR DOES NOT SUPPORT HOOKFUNCTION PLZ USE A DIFFERENT SHITSPLOIT",
			TextWrapped = true
		})
		prompt:Separator()
		prompt:Label({
			Text = "Kicking you to avoid you getting banned",
			TextWrapped = true
		})
		prompt:Label({
			Text = "discord.gg/VSKCM7rXVY"
		})
	end
    end
	task.wait(3)
	game.Players.LocalPlayer:Kick("Please change your executor; discord.gg/VSKCM7rXVY")
end

local anticheatok = game:GetService("ReplicatedStorage").Remotes.Miau
local blockanticheat
blockanticheat = hookfunction(anticheatok.FireServer, function(self, ...)
	if self == anticheatok then
		print(`Blocked the shit-anti-cheat`)
		task.wait(9e9)
		return nil
	end

	return blockanticheat(self, ...)
end)
