local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

if game:GetService("CoreGui"):FindFirstChild("TargetInfo") then
    game:GetService("CoreGui").TargetInfo:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TargetInfo"
local MainFrame = Instance.new("Frame")
local ProfileImage = Instance.new("ImageLabel")
local HealthBarBG = Instance.new("Frame")
local HealthBarFill = Instance.new("Frame")
local NameLabel = Instance.new("TextLabel")

ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Parent = ScreenGui

MainFrame.Size = UDim2.new(0, 300, 0, 85)
MainFrame.Position = UDim2.new(0.5, -150, -0.2, 0) 
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 1

Instance.new("UIGradient", MainFrame).Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
})

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

ProfileImage.Size = UDim2.new(0, 65, 0, 65)
ProfileImage.Position = UDim2.new(0, 12, 0.5, -32)
ProfileImage.BackgroundTransparency = 1
ProfileImage.ImageTransparency = 1
ProfileImage.Parent = MainFrame
Instance.new("UICorner", ProfileImage).CornerRadius = UDim.new(0, 6)

NameLabel.Size = UDim2.new(0, 190, 0, 20)
NameLabel.Position = UDim2.new(0, 85, 0, 17)
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 17
NameLabel.TextTransparency = 1
NameLabel.Parent = MainFrame

HealthBarBG.Size = UDim2.new(0, 140, 0, 5)
HealthBarBG.Position = UDim2.new(0, 125, 0, 54)
HealthBarBG.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
HealthBarBG.BorderSizePixel = 0
HealthBarBG.BackgroundTransparency = 1
HealthBarBG.Parent = MainFrame
Instance.new("UICorner", HealthBarBG).CornerRadius = UDim.new(0, 3)

HealthBarFill.Size = UDim2.new(1, 0, 1, 0)
HealthBarFill.BackgroundColor3 = Color3.fromRGB(110, 160, 255)
HealthBarFill.BorderSizePixel = 0
HealthBarFill.BackgroundTransparency = 1
HealthBarFill.Parent = HealthBarBG
Instance.new("UICorner", HealthBarFill).CornerRadius = UDim.new(0, 3)

local LevelLabel = Instance.new("TextLabel")
LevelLabel.Size = UDim2.new(0, 35, 0, 18)
LevelLabel.Position = UDim2.new(0, 85, 0, 47)
LevelLabel.BackgroundTransparency = 1
LevelLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
LevelLabel.Font = Enum.Font.GothamBold
LevelLabel.TextSize = 13
LevelLabel.TextTransparency = 1
LevelLabel.Parent = MainFrame

local currentTarget = nil
local isVisible = false

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local visiblePosition = UDim2.new(0.5, -150, 0.1, 0)
local hiddenPosition = UDim2.new(0.5, -150, -0.2, 0)

local function animateVisibility(visible)
    local transparencyGoal = visible and 0 or 1
    local positionGoal = visible and visiblePosition or hiddenPosition
    
    TweenService:Create(MainFrame, tweenInfo, {
        Position = positionGoal,
        BackgroundTransparency = transparencyGoal
    }):Play()
    
    TweenService:Create(ProfileImage, tweenInfo, {ImageTransparency = transparencyGoal}):Play()
    TweenService:Create(HealthBarBG, tweenInfo, {BackgroundTransparency = transparencyGoal}):Play()
    TweenService:Create(HealthBarFill, tweenInfo, {BackgroundTransparency = transparencyGoal}):Play()
    TweenService:Create(NameLabel, tweenInfo, {TextTransparency = transparencyGoal}):Play()
    TweenService:Create(LevelLabel, tweenInfo, {TextTransparency = transparencyGoal}):Play()
end

local TargetInfo = {}

-- Add a call handler for the module
setmetatable(TargetInfo, {
    __call = function()
        return TargetInfo
    end
})

function TargetInfo.SetTarget(player)
    if not player or not player:IsA("Player") then return end
    currentTarget = player
    UpdateTargetInfo()
    if not isVisible then
        isVisible = true
        animateVisibility(true)
    end
end

function TargetInfo.ClearTarget()
    currentTarget = nil
    isVisible = false
    animateVisibility(false)
end

function TargetInfo.IsVisible()
    return isVisible
end

local function UpdateTargetInfo()
    local target = currentTarget or LocalPlayer
    if target and target.Character then
        ProfileImage.Image = Players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        NameLabel.Text = target.DisplayName ~= "" and target.DisplayName or target.Name
        
        local humanoid = target.Character:FindFirstChild("Humanoid")
        if humanoid then
            local healthScale = humanoid.Health / humanoid.MaxHealth
            LevelLabel.Text = math.floor(humanoid.Health)
            
            local r = math.min(255, (1 - healthScale) * 255 * 2)
            local g = math.min(255, healthScale * 255 * 2)
            HealthBarFill.Size = UDim2.new(healthScale, 0, 1, 0)
            HealthBarFill.BackgroundColor3 = Color3.fromRGB(r, g, 70)
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    UpdateTargetInfo()
end)

local lastUpdate = 0
game:GetService("RunService").RenderStepped:Connect(function()
    local now = tick()
    if now - lastUpdate >= 0.01 then 
        lastUpdate = now
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            UpdateTargetInfo()
        end
    end
end)

if LocalPlayer.Character then
    UpdateTargetInfo()
end

MainFrame.ZIndex = 1
ProfileImage.ZIndex = 2
HealthBarBG.ZIndex = 2
NameLabel.ZIndex = 2
LevelLabel.ZIndex = 2

return function()
    return TargetInfo
end
