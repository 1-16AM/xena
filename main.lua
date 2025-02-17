local supportedGames = {
    [2955322961] = true, -- shrimp game
    [6942875911] = true, -- squid project
}

local function loadGame()
    if not supportedGames[game.GameId] then
        warn("xena does not support this game yet (universal coming soon)")
        return
    end

    local success, error = pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/1-16AM/xena/refs/heads/main/games/'.. game.GameId ..'.lua'))()
        print(game.GameId)
    end)

    if not success then
        warn("failed to load script:", error)
    end
end

loadGame()
