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
