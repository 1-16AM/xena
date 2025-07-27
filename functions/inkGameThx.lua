local regui =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"))()

local sadconfirmation = false
local supportedornot = hookfunction or nil

if not supportedornot then
	local sadprompt = regui
		:Window({
			Title = "Sorry..",
			Size = UDim2.fromOffset(300, 100),
			NoCollapse = true,
			NoResize = true,
			NoScroll = true,
		})
		:Center()
	do
		sadprompt:Label({
			Text = "Your executor does not support the Anti-cheat bypass, you WILL get detected probably.",
			TextWrapped = true
		})
		sadprompt:Button({
			Text = "Understood.",
			Callback = function()
				sadprompt:Close()
				sadconfirmation = true
			end,
		})
	end
else
    sadconfirmation = true
	local Event = game:GetService("ReplicatedStorage").Remotes.Miau
	local OldFireServer
	OldFireServer = hookfunction(Event.FireServer, function(self, ...)
		if self == Event then
			local Result = table.pack(OldFireServer(self, ...))

			print(`Blocked the shit-anti-cheat`)
			task.wait(9e9)
			return nil
		end

		return OldFireServer(self, ...)
	end)
end

return sadconfirmation
