local Remakefromidk = Instance.new("BillboardGui")
local Frame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local Frame_3 = Instance.new("Frame")
local userprofilepic = Instance.new("ImageLabel")
local UICorner = Instance.new("UICorner")
local UIStroke_2 = Instance.new("UIStroke")
local Frame_4 = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local _3Health = Instance.new("Frame")
local _2Health = Instance.new("Frame")
local Frame_5 = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local _1Text = Instance.new("TextLabel")
local UIListLayout_2 = Instance.new("UIListLayout")
local _1Display = Instance.new("TextLabel")
local _2Name = Instance.new("TextLabel")
local UIStroke_3 = Instance.new("UIStroke")

local function generateRandomName()
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local length = math.random(10, 20)
    local name = ""
    for i = 1, length do
        local randNum = math.random(1, #chars)
        name = name .. string.sub(chars, randNum, randNum)
    end
    return name
end

Remakefromidk.Name = generateRandomName()
Remakefromidk.Active = true
Remakefromidk.AlwaysOnTop = true
Remakefromidk.LightInfluence = 0
Remakefromidk.MaxDistance = 200
Remakefromidk.Size = UDim2.new(0, 305, 0, 149)
Remakefromidk.StudsOffset = Vector3.new(0, 4, 0)
Remakefromidk.SizeOffset = Vector2.new(0, 0)
Remakefromidk.ExtentsOffset = Vector3.new(0, 1, 0)
Remakefromidk.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Remakefromidk.ResetOnSpawn = false
Remakefromidk.ClipsDescendants = true
Remakefromidk.Adornee = nil

Frame.Parent = Remakefromidk
Frame.AnchorPoint = Vector2.new(0, 0)
Frame.BackgroundColor3 = Color3.fromRGB(34, 33, 37)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.Size = UDim2.new(1, 0, 1, 0)

UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(69, 123, 180)
UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
UIStroke.Parent = Frame

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(34, 33, 37)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0.879, 0, 0.201, 0)

TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.0298507456, 0, 0, 0)
TextLabel.Size = UDim2.new(1.10820901, 0, 1, 0)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.Text = "Target GUI"
TextLabel.TextColor3 = Color3.fromRGB(195, 195, 195)
TextLabel.TextSize = 14.000
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextScaled = false
TextLabel.TextSize = 14

Frame_3.Parent = Frame
Frame_3.AnchorPoint = Vector2.new(0.5, 0.5)
Frame_3.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0.5, 0, 0.567114115, 0)
Frame_3.Size = UDim2.new(0.97, 0, 0.738, 0)

userprofilepic.Name = "userprofilepic"
userprofilepic.Parent = Frame_3
userprofilepic.BackgroundColor3 = Color3.fromRGB(32, 31, 36)
userprofilepic.BorderColor3 = Color3.fromRGB(0, 0, 0)
userprofilepic.BorderSizePixel = 0
userprofilepic.Position = UDim2.new(0.0262295082, 0, 0.1, 0)
userprofilepic.Size = UDim2.new(0.304, 0, 0.818, 0)

UICorner.CornerRadius = UDim.new(0, 1)
UICorner.Parent = userprofilepic

UIStroke_2.Color = Color3.fromRGB(50, 50, 50)
UIStroke_2.Parent = userprofilepic

Frame_4.Parent = Frame_3
Frame_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_4.BackgroundTransparency = 1.000
Frame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_4.BorderSizePixel = 0
Frame_4.Position = UDim2.new(0.406, 0, 0.05, 0)
Frame_4.Size = UDim2.new(0.584, 0, 0.909, 0)

UIListLayout.Parent = Frame_4
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

_3Health.Name = "3Health"
_3Health.Parent = Frame_4
_3Health.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_3Health.BackgroundTransparency = 1.000
_3Health.BorderColor3 = Color3.fromRGB(0, 0, 0)
_3Health.BorderSizePixel = 0
_3Health.Size = UDim2.new(1, 0, 0.3, 0)
_3Health.Position = UDim2.new(0, 0, 0.44, 0)

_2Health.Name = "2Health"
_2Health.Parent = _3Health
_2Health.BackgroundColor3 = Color3.fromRGB(5, 5, 9)
_2Health.BorderColor3 = Color3.fromRGB(0, 0, 0)
_2Health.BorderSizePixel = 0
_2Health.ClipsDescendants = true
_2Health.Position = UDim2.new(0, 0, 0.45, 0)
_2Health.Size = UDim2.new(1, 0, 0.3, 0)
_2Health.ZIndex = 0

Frame_5.Parent = _2Health
Frame_5.BackgroundColor3 = Color3.fromRGB(61, 131, 205)
Frame_5.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_5.BorderSizePixel = 0
Frame_5.Size = UDim2.new(0, 58, 0, 14)

UICorner_2.CornerRadius = UDim.new(0, 2)
UICorner_2.Parent = Frame_5

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(125, 156, 205)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 103, 205))}
UIGradient.Parent = Frame_5

_1Text.Name = "1Text"
_1Text.Parent = _3Health
_1Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_1Text.BackgroundTransparency = 1.000
_1Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
_1Text.BorderSizePixel = 0
_1Text.Size = UDim2.new(1, 0, 0.4, 0)
_1Text.Position = UDim2.new(0, 0, 0, 0)
_1Text.Font = Enum.Font.RobotoMono
_1Text.Text = "Health"
_1Text.TextColor3 = Color3.fromRGB(255, 255, 255)
_1Text.TextSize = 16
_1Text.TextXAlignment = Enum.TextXAlignment.Left
_1Text.TextScaled = false

UIListLayout_2.Parent = _3Health
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 2)

_1Display.Name = "1Display"
_1Display.Parent = Frame_4
_1Display.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_1Display.BackgroundTransparency = 1.000
_1Display.BorderColor3 = Color3.fromRGB(0, 0, 0)
_1Display.BorderSizePixel = 0
_1Display.Size = UDim2.new(1, 0, 0.2, 0)
_1Display.Font = Enum.Font.RobotoMono
_1Display.Text = "..."
_1Display.TextColor3 = Color3.fromRGB(255, 255, 255)
_1Display.TextSize = 16
_1Display.TextWrapped = true
_1Display.TextXAlignment = Enum.TextXAlignment.Left
_1Display.TextScaled = false
_1Display.Position = UDim2.new(0, 0, 0, 0)

_2Name.Name = "2Name"
_2Name.Parent = Frame_4
_2Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
_2Name.BackgroundTransparency = 1.000
_2Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
_2Name.BorderSizePixel = 0
_2Name.Size = UDim2.new(1, 0, 0.2, 0)
_2Name.Font = Enum.Font.RobotoMono
_2Name.Text = "..."
_2Name.TextColor3 = Color3.fromRGB(255, 255, 255)
_2Name.TextSize = 16
_2Name.TextWrapped = true
_2Name.TextXAlignment = Enum.TextXAlignment.Left
_2Name.TextScaled = false
_2Name.Position = UDim2.new(0, 0, 0.22, 0)

UIStroke_3.Color = Color3.fromRGB(75, 75, 75)
UIStroke_3.Parent = Frame_3

local targetInfo = {}
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local updateConnection

local mainAspect = Instance.new("UIAspectRatioConstraint")
mainAspect.Parent = Frame
mainAspect.AspectRatio = 305/149

local contentAspect = Instance.new("UIAspectRatioConstraint")
contentAspect.Parent = Frame_3
contentAspect.AspectRatio = 296/110

local profileAspect = Instance.new("UIAspectRatioConstraint")
profileAspect.Parent = userprofilepic
profileAspect.AspectRatio = 1

local healthAspect = Instance.new("UIAspectRatioConstraint")
healthAspect.Parent = _2Health
healthAspect.AspectRatio = 173/14

function targetInfo:Set(player)
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end
    
    if not player then
        Remakefromidk.Enabled = false
        Remakefromidk.Parent = nil
        return
    end
    
    -- Make sure we have a valid player
    if not player:IsA("Player") then
        local possiblePlayer = Players:GetPlayerFromCharacter(player)
        if not possiblePlayer then
            return
        end
        player = possiblePlayer
    end
    
    -- Wait for character if needed
    local character = player.Character
    if not character or not character:IsA("Model") then
        return
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end
    
    Remakefromidk.Enabled = true
    Remakefromidk.Adornee = humanoidRootPart
    Remakefromidk.Parent = humanoidRootPart
    
    local camera = workspace.CurrentCamera
    local baseSize = Vector2.new(305, 149)
    local lastScale = 1

    _1Display.Text = "..."
    _2Name.Text = "..."

    updateConnection = RunService.RenderStepped:Connect(function()
        if not player or not player.Character then return end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end

        local _, isOnScreen = camera:WorldToViewportPoint(root.Position)
        local distance = (camera.CFrame.Position - root.Position).Magnitude
        
        local minScale = 0.85
        local maxScale = 1.5
        local scaleStartDist = 30
        local targetScale = math.clamp(scaleStartDist / math.max(distance, 5), minScale, maxScale)
        
        if not isOnScreen then 
            targetScale = targetScale * 0.8 
        end
        
        lastScale = lastScale + (targetScale - lastScale) * 0.15
        
        Remakefromidk.Size = UDim2.new(0, baseSize.X * lastScale, 0, baseSize.Y * lastScale)
        
        local baseTextSize = 16
        local scaledTextSize = math.floor(baseTextSize * lastScale)
        local textSize = math.clamp(scaledTextSize, 14, 24)
        
        TextLabel.TextSize = textSize
        _1Text.TextSize = textSize
        _1Display.TextSize = textSize
        _2Name.TextSize = textSize

        local health = humanoid.Health
        local maxHealth = humanoid.MaxHealth
        local healthPercent = (health / maxHealth)
        
        if healthPercent ~= lastHealth then
            local tween = TweenService:Create(Frame_5, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(healthPercent, 0, 1, 0)
            })
            tween:Play()
            lastHealth = healthPercent
        end
    end)
    
    _1Display.Text = "@" .. player.DisplayName
    
    if player.Name == player.DisplayName then
        _2Name.Visible = false
        _3Health.Position = UDim2.new(0, 0, 0.22, 0)
    else
        _2Name.Visible = true
        _2Name.Text = player.Name
        _3Health.Position = UDim2.new(0, 0, 0.44, 0)
    end
    
    userprofilepic.Image = game:GetService("Players"):GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
    
    local lastHealth = 1
    updateConnection = RunService.Heartbeat:Connect(function()
        if not player or not player.Character or not player.Character:FindFirstChild("Humanoid") then
            if Frame_5.Size.X.Scale ~= 0 then
                local tween = TweenService:Create(Frame_5, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 0, 0, 14)
                })
                tween:Play()
            end
            lastHealth = 0
            return
        end
        
        local health = player.Character.Humanoid.Health
        local maxHealth = player.Character.Humanoid.MaxHealth
        local healthPercent = (health / maxHealth)
        
        if healthPercent ~= lastHealth then
            local tween = TweenService:Create(Frame_5, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(healthPercent, 0, 0, 14)
            })
            tween:Play()
            lastHealth = healthPercent
        end
    end)
end

function targetInfo:Visible(state)
    Remakefromidk.Enabled = state
end
targetInfo:Set(game.Players.LocalPlayer)
return targetInfo
