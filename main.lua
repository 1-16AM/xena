local function fetchGames()
    local success, response = pcall(function()
        return game:GetService('HttpService'):JSONDecode(
            game:HttpGet('https://api.github.com/repos/1-16AM/xena/contents/games')
        )
    end)

    if not success then
        warn("Failed to fetch game scripts:", response)
        return {}
    end

    local scripts = {}
    for _, file in ipairs(response) do
        if file.type == "file" then
            local gameId = tonumber(file.name:match("(%d+)%.lua"))
            if gameId then
                scripts[gameId] = file.download_url
            end
        end
    end
    
    return scripts
end

local function loadGame()
    local gameScripts = fetchGames()
    local scriptUrl = gameScripts[game.GameId]
    
    if not scriptUrl then
        warn("xena does not support this game yet (universal coming soon)")
        return
    end

    local success, error = pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1-16AM/xena/refs/heads/main/functions/analytics.lua"))()
    end)

    if not success then
        warn("Failed to load script:", error)
    end
end

loadGame()
