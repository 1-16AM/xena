local UiLib = {}
UiLib.__index = UiLib

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local FADE_DURATION = 0.5
local FADE_STYLE = Enum.EasingStyle.Sine
local FADE_DIRECTION = Enum.EasingDirection.InOut

local BLUR_STRENGTH = 15
local SNOWFLAKE_COUNT = 40
local SNOWFLAKE_SPEED = 0.5
local SNOWFLAKE_SIZE_MIN = 8
local SNOWFLAKE_SIZE_MAX = 16

local NOTIFICATION_DURATION = 3
local NOTIFICATION_PADDING = 10
local NOTIFICATION_WIDTH = 250
local NOTIFICATION_HEIGHT = 40

local originalHitboxSizes = {}
local originalHitboxColors = {}
local originalHitboxTransparencies = {}
local originalHitboxCanCollides = {}

local IS_MOBILE = game:GetService("UserInputService").TouchEnabled
local MOBILE_BUTTON_SIZE = UDim2.new(0, 70, 0, 70)  -- Made larger
local MOBILE_BUTTON_POSITION = UDim2.new(0.9, -25, 0.8, -25)

local MOBILE_TOP_BAR_HEIGHT = 45
local MOBILE_TOP_BAR_PADDING = 10

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

local function parentUI(gui)
    local success, failure = pcall(function()
        if get_hidden_gui or gethui then
            local hiddenUI = get_hidden_gui or gethui
            gui.Parent = hiddenUI()
        elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
            syn.protect_gui(gui)
            gui.Parent = game:GetService("CoreGui")
        elseif game:GetService("CoreGui") then
            gui.Parent = game:GetService("CoreGui")
        end
    end)

    if not success and failure then
        gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

local function enableDragging(frame, titleFrame)
    local isDragging = false
    local dragStart
    local initialPos

    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            initialPos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPosition = UDim2.new(
                initialPos.X.Scale,
                initialPos.X.Offset + delta.X,
                initialPos.Y.Scale,
                initialPos.Y.Offset + delta.Y
            )
            frame.Position = newPosition
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
end

function UiLib:createMobileToggleButton()
    local toggleButton = Instance.new("ImageButton")
    toggleButton.Size = MOBILE_BUTTON_SIZE
    toggleButton.Position = MOBILE_BUTTON_POSITION
    toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(47, 74, 131)
    toggleButton.BackgroundTransparency = 0.3
    toggleButton.Image = "rbxassetid://7059346373"
    toggleButton.Parent = self.gui

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    uiGradient.Parent = toggleButton

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = game:GetService("TweenService"):Create(toggleButton, tweenInfo, {
        BackgroundTransparency = 0.6
    })
    tween:Play()

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggleButton

    local isDragging = false
    local dragStart
    local startPos

    toggleButton.TouchLongPress:Connect(function(_, state)
        if state == Enum.UserInputState.Begin then
            isDragging = true
            dragStart = toggleButton.Position
            startPos = game:GetService("UserInputService"):GetMouseLocation()
        end
    end)

    game:GetService("UserInputService").TouchMoved:Connect(function(touch, gameProcessed)
        if isDragging then
            local delta = game:GetService("UserInputService"):GetMouseLocation() - startPos
            local newPosition = UDim2.new(
                dragStart.X.Scale,
                dragStart.X.Offset + delta.X,
                dragStart.Y.Scale,
                dragStart.Y.Offset + delta.Y
            )
            toggleButton.Position = newPosition
        end
    end)

    game:GetService("UserInputService").TouchEnded:Connect(function()
        isDragging = false
    end)

    toggleButton.TouchTap:Connect(function()
        if not isDragging then
            self:toggle()
        end
    end)

    return toggleButton
end

function UiLib:createMobileTopBar()
    local topBar = Instance.new("Frame")
    topBar.Name = generateRandomName()
    topBar.Size = UDim2.new(1, 0, 0, MOBILE_TOP_BAR_HEIGHT)
    topBar.Position = UDim2.new(0, 0, 0, -MOBILE_TOP_BAR_HEIGHT)
    topBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    topBar.BackgroundTransparency = 0.2
    topBar.Parent = self.gui
    
    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = game:GetService("Lighting")
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(47, 74, 131)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 22))
    })
    gradient.Rotation = 90
    gradient.Parent = topBar
    
    local watermark = Instance.new("TextLabel")
    watermark.Name = generateRandomName()
    watermark.Size = UDim2.new(1, -120, 1, 0) 
    watermark.Position = UDim2.new(0, MOBILE_TOP_BAR_PADDING, 0, 0)
    watermark.BackgroundTransparency = 1
    watermark.Font = Enum.Font.GothamBold
    watermark.Text = "xena hub"
    watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
    watermark.TextSize = 18
    watermark.TextXAlignment = Enum.TextXAlignment.Left
    watermark.Parent = topBar
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = generateRandomName()
    toggleButton.Size = UDim2.new(0, 100, 0, MOBILE_TOP_BAR_HEIGHT - MOBILE_TOP_BAR_PADDING * 2)
    toggleButton.Position = UDim2.new(1, -110, 0, MOBILE_TOP_BAR_PADDING)
    toggleButton.BackgroundColor3 = Color3.fromRGB(47, 74, 131)
    toggleButton.BackgroundTransparency = 0.3
    toggleButton.Text = "Toggle GUI"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 14
    toggleButton.Parent = topBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggleButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = toggleButton
    
    toggleButton.MouseButton1Down:Connect(function()
        game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.1
        }):Play()
    end)
    
    toggleButton.MouseButton1Up:Connect(function()
        game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.3
        }):Play()
    end)
    
    toggleButton.TouchTap:Connect(function()
        self:toggle()
    end)
    
    topBar:TweenPosition(
        UDim2.new(0, 0, 0, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        0.5,
        true
    )
    
    return topBar
end

function UiLib.new(config)
    local self = setmetatable({}, UiLib)
    self.elements = {}
    config = config or {}

    self.gui = Instance.new("ScreenGui")
    self.gui.Name = generateRandomName()
    parentUI(self.gui)

    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = generateRandomName()
    self.mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.mainFrame.Position = config.position or UDim2.new(0.5, 0, 0.5, 0)
    self.mainFrame.Size = config.size or UDim2.new(0, 400, 0, 300)
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Parent = self.gui

    self.hitboxFrame = Instance.new("Frame")
    self.hitboxFrame.Name = generateRandomName()
    self.hitboxFrame.Size = UDim2.new(1, 100, 1, 100)
    self.hitboxFrame.Position = UDim2.new(0, -50, 0, -50)
    self.hitboxFrame.BackgroundTransparency = 1
    self.hitboxFrame.Parent = self.mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(47, 74, 131)
    stroke.Parent = self.mainFrame

    self.titleFrame = Instance.new("Frame")
    self.titleFrame.Name = generateRandomName()
    self.titleFrame.Size = UDim2.new(1, 0, 0, 33)
    self.titleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    self.titleFrame.BorderSizePixel = 0
    self.titleFrame.Parent = self.mainFrame

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(47, 74, 131)
    titleStroke.Parent = self.titleFrame

    self.contentFrame = Instance.new("Frame")
    self.contentFrame.Name = generateRandomName()
    self.contentFrame.BackgroundTransparency = 1
    self.contentFrame.Position = UDim2.new(0, 0, 0, 63)
    self.contentFrame.Size = UDim2.new(1, 0, 1, -63)
    self.contentFrame.ClipsDescendants = true
    self.contentFrame.Parent = self.mainFrame

    self.realContentFrame = Instance.new("ScrollingFrame")
    self.realContentFrame.Name = generateRandomName()
    self.realContentFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.realContentFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.realContentFrame.Size = UDim2.new(0.95, 0, 0.95, 0)
    self.realContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.realContentFrame.BorderSizePixel = 0
    self.realContentFrame.ClipsDescendants = true
    self.realContentFrame.ScrollBarThickness = 0
    self.realContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    self.realContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.realContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.realContentFrame.Parent = self.contentFrame

    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.fromRGB(110, 110, 110)
    contentStroke.Parent = self.realContentFrame

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 6) 
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = self.realContentFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Parent = self.realContentFrame

    local function smoothScroll()
        local scrollSpeed = 0.1
        local overscrollAmount = 30 
        local targetPosition = Vector2.new(0, 0)
        local isScrolling = false
        local scrollTimer = 0

        self.realContentFrame.MouseWheelForward:Connect(function()
            isScrolling = true
            scrollTimer = 0.5 
            targetPosition = Vector2.new(0, math.max(-overscrollAmount, targetPosition.Y - 40))
        end)

        self.realContentFrame.MouseWheelBackward:Connect(function()
            isScrolling = true
            scrollTimer = 0.5 
            local maxScroll = self.realContentFrame.AbsoluteCanvasSize.Y - self.realContentFrame.AbsoluteSize.Y
            targetPosition = Vector2.new(0, math.min(maxScroll + overscrollAmount, targetPosition.Y + 40))
        end)

        game:GetService("RunService").RenderStepped:Connect(function(delta)
            if scrollTimer > 0 then
                scrollTimer = scrollTimer - delta
            else
                isScrolling = false
            end

            if self.realContentFrame.CanvasPosition ~= targetPosition then
                local maxScroll = self.realContentFrame.AbsoluteCanvasSize.Y - self.realContentFrame.AbsoluteSize.Y
                local newPosition = self.realContentFrame.CanvasPosition:Lerp(targetPosition, scrollSpeed)

                if not isScrolling then
                    if newPosition.Y < 0 then
                        targetPosition = Vector2.new(0, 0)
                    elseif newPosition.Y > maxScroll and maxScroll > 0 then
                        targetPosition = Vector2.new(0, maxScroll)
                    end
                end

                self.realContentFrame.CanvasPosition = newPosition
            end
        end)
    end

    smoothScroll()

    enableDragging(self.mainFrame, self.titleFrame)

    self:setTitle(config.title or "Xena Hub")

    self.tabContainer = Instance.new("Frame")
    self.tabContainer.Name = generateRandomName()
    self.tabContainer.Size = UDim2.new(1, 0, 0, 30)
    self.tabContainer.Position = UDim2.new(0, 0, 0, 33)
    self.tabContainer.BackgroundTransparency = 1
    self.tabContainer.ClipsDescendants = true
    self.tabContainer.Parent = self.mainFrame

    self.blur = Instance.new("BlurEffect")
    self.blur.Size = BLUR_STRENGTH
    self.blur.Parent = Lighting

    self:createSnowflakeEffect()
    self:startSnowflakeAnimation()

    function self:toggle()
        if self.gui.Enabled then
            local startPos = self.mainFrame.Position
            local endPos = UDim2.new(0.5, 0, 1.5, 0)

            local frameTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

            local frameTween = TweenService:Create(self.mainFrame, frameTweenInfo, {
                Position = endPos
            })

            local blurTweenInfo = TweenInfo.new(0.3,
            Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0.1 
            )

            local blurTween = TweenService:Create(self.blur, blurTweenInfo, {
                Size = 0
            })

            frameTween:Play()
            blurTween:Play()

            frameTween.Completed:Connect(function()
                self.gui.Enabled = false
                self.mainFrame.Position = startPos
            end)
        else
            local endPos = UDim2.new(0.5, 0, 0.5, 0)
            self.mainFrame.Position = UDim2.new(0.5, 0, -0.5, 0)
            self.gui.Enabled = true

            local frameTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

            local frameTween = TweenService:Create(self.mainFrame, frameTweenInfo, {
                Position = endPos
            })

            local blurTweenInfo = TweenInfo.new(0.3, 
            Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)

            local blurTween = TweenService:Create(self.blur, blurTweenInfo, {
                Size = BLUR_STRENGTH
            })

            blurTween:Play() 
            task.wait(0.1) 
            frameTween:Play() 
        end
    end

    if IS_MOBILE then
        self.mobileToggleButton = self:createMobileToggleButton()
        
        self.mainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)  
        self.mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        for _, button in pairs(self.mainFrame:GetDescendants()) do
            if button:IsA("TextButton") then
                button.Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset, 0, 45) 
                button.TextSize = 18 
            end
        end
        
        self.realContentFrame.ScrollBarThickness = 12
        self.realContentFrame.ScrollingEnabled = true
        
        local scrollVelocity = 0
        local lastY = 0
        local isDragging = false
        
        self.realContentFrame.TouchLongPress:Connect(function(position, state)
            isDragging = state == Enum.UserInputState.Begin
            if isDragging then
                lastY = position.Y
                scrollVelocity = 0
            end
        end)
        
        self.realContentFrame.TouchMoved:Connect(function(touch, gameProcessed)
            if isDragging then
                local delta = touch.Position.Y - lastY
                scrollVelocity = delta
                self.realContentFrame.CanvasPosition = Vector2.new(
                    0,
                    self.realContentFrame.CanvasPosition.Y - delta
                )
                lastY = touch.Position.Y
            end
        end)
        
        self.realContentFrame.TouchEnded:Connect(function()
            isDragging = false
            local momentum = scrollVelocity
            game:GetService("RunService").RenderStepped:Connect(function(delta)
                if math.abs(momentum) > 0.1 then
                    self.realContentFrame.CanvasPosition = Vector2.new(
                        0,
                        self.realContentFrame.CanvasPosition.Y - momentum
                    )
                    momentum = momentum * 0.9
                end
            end)
        end)
        
        for _, padding in pairs(self.realContentFrame:GetDescendants()) do
            if padding:IsA("UIPadding") then
                padding.PaddingTop = UDim.new(0, 15)
                padding.PaddingBottom = UDim.new(0, 20)
                padding.PaddingLeft = UDim.new(0, 15)
                padding.PaddingRight = UDim.new(0, 15)
            end
        end
    end

    if IS_MOBILE then
        self.mobileTopBar = self:createMobileTopBar()
        
        self.mainFrame.Position = UDim2.new(0.5, 0, 0.5, MOBILE_TOP_BAR_HEIGHT/2)
        
    end

    return self
end

function UiLib:addLabel(text, id)
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(0.95, 0, 0, 37)

    local label = Instance.new("TextLabel")
    label.Text = text
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.RobotoMono
    label.TextColor3 = Color3.fromRGB(225, 225, 225)
    label.TextSize = 15
    label.Parent = frame

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    if id then
        self.elements[id] = {
            type = "label",
            instance = label,
            setText = function(newText)
                label.Text = newText
            end,
            getText = function()
                return label.Text
            end
        }
    end

    return self.elements[id]
end

function UiLib:addButton(config)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 30)
    frame.ClipsDescendants = true

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(75, 75, 75)
    stroke.Parent = frame

    local button = Instance.new("TextButton")
    button.Text = config.Name or "Button" 
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(0.95, 0, 0.95, 0)
    button.Position = UDim2.new(0.5, 0, 0.5, 0)
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.Font = Enum.Font.SourceSans
    button.TextColor3 = Color3.fromRGB(225, 225, 225)
    button.TextSize = 14
    button.Parent = frame

    local function createRipple(x, y)
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.6
        ripple.BorderSizePixel = 0
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.new(0, x, 0, y)
        ripple.Size = UDim2.new(0, 0, 0, 0)

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple

        ripple.Parent = frame

        local maxSize = math.max(frame.AbsoluteSize.X, frame.AbsoluteSize.Y) * 1.5

        local animationTime = 0.5
        TweenService:Create(ripple, TweenInfo.new(animationTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }):Play()

        game:GetService("Debris"):AddItem(ripple, animationTime)
    end

    button.MouseButton1Down:Connect(function(x, y)
        local relativeX = x - frame.AbsolutePosition.X
        local relativeY = y - frame.AbsolutePosition.Y
        createRipple(relativeX, relativeY)

        if config.Callback then
            config.Callback()
        end
    end)

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    if config.Name then
        self.elements[config.Name] = {
            type = "button",
            instance = button,
            setText = function(newText)
                button.Text = newText
            end,
            getText = function()
                return button.Text
            end
        }
    end

    return self.elements[config.Name]
end

function UiLib:addTextBox(placeholderText, callback, id)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 30)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(75, 75, 75)
    stroke.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.PlaceholderText = placeholderText
    textBox.Text = ""
    textBox.BackgroundTransparency = 1
    textBox.Size = UDim2.new(0.95, 0, 0.95, 0)
    textBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    textBox.AnchorPoint = Vector2.new(0.5, 0.5)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextColor3 = Color3.fromRGB(225, 225, 225)
    textBox.TextSize = 14
    textBox.Parent = frame

    if callback then
        textBox.FocusLost:Connect(function()
            callback(textBox.Text)
        end)
    end

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    if id then
        self.elements[id] = {
            type = "textbox",
            instance = textBox,
            setText = function(newText)
                textBox.Text = newText
            end,
            getText = function()
                return textBox.Text
            end
        }
    end

    return self.elements[id]
end

function UiLib:addDropdown(options, callback, id, multiSelect)
    local optionsList = type(options) == "table" and (options.Options or options) or {}
    local defaultOption = type(options) == "table" and options.Default or optionsList[1]
    local callbackFn = type(options) == "table" and options.Callback or callback

    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 35)
    frame.ClipsDescendants = true

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(75, 75, 75)
    stroke.Parent = frame

    local button = Instance.new("TextButton")
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 0, 35)
    button.Text = defaultOption or "Select..."
    button.TextColor3 = Color3.fromRGB(225, 225, 225)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 15
    button.Parent = frame

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 8, 0, 8)
    indicator.Position = UDim2.new(0.95, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0.5, 0.5)
    indicator.Rotation = 0
    indicator.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
    indicator.BorderSizePixel = 0
    indicator.Parent = button

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 0)
    uiCorner.Parent = indicator

    local uiGradient = Instance.new("UIGradient")
    uiGradient.Rotation = 45
    uiGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.5001, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    uiGradient.Parent = indicator

    local optionsFrame = Instance.new("Frame")
    optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Position = UDim2.new(0, 0, 0, 35)
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.ClipsDescendants = true
    optionsFrame.Parent = frame

    local optionsStroke = Instance.new("UIStroke")
    optionsStroke.Color = Color3.fromRGB(75, 75, 75)
    optionsStroke.Parent = optionsFrame

    local optionsListLayout = Instance.new("UIListLayout")
    optionsListLayout.Padding = UDim.new(0, 0)
    optionsListLayout.Parent = optionsFrame

    local optionHeight = 30
    local maxVisibleOptions = 5
    local totalOptionsHeight = math.min(#optionsList * optionHeight, maxVisibleOptions * optionHeight)

    local selected = multiSelect and {} or defaultOption or "Select..."
    local selectedItems = {}
    local isOpen = false

    local function updateDropdownState(newState)
        isOpen = newState

        if isOpen then
            TweenService:Create(frame, TweenInfo.new(0.2), {
                Size = UDim2.new(0.95, 0, 0, 35 + totalOptionsHeight)
            }):Play()

            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, totalOptionsHeight)
            }):Play()

            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(frame, TweenInfo.new(0.2), {
                Size = UDim2.new(0.95, 0, 0, 35)
            }):Play()

            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()

            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
        end
    end

    for _, option in ipairs(optionsList) do
        local optionButton = Instance.new("TextButton")
        optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        optionButton.BorderSizePixel = 0
        optionButton.Size = UDim2.new(1, 0, 0, optionHeight)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(225, 225, 225)
        optionButton.Font = Enum.Font.SourceSans
        optionButton.TextSize = 15
        optionButton.BackgroundTransparency = 1
        optionButton.AutoButtonColor = false
        optionButton.Parent = optionsFrame

        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0,
                BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            }):Play()
        end)

        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 1,
                BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            }):Play()
        end)

        optionButton.MouseButton1Click:Connect(function()
            if multiSelect then
                if selectedItems[option] then
                    selectedItems[option] = nil
                else
                    selectedItems[option] = true
                end

                local selectedList = {}
                for opt, _ in pairs(selectedItems) do
                    table.insert(selectedList, opt)
                end

                button.Text = #selectedList > 0 and table.concat(selectedList, ", ") or "Select..."

                if callbackFn then 
                    callbackFn(selectedList)
                end
            else
                selected = option
                button.Text = selected
                if self.elements[id] then
                    self.elements[id].CurrentValue = selected
                end
                updateDropdownState(false)
                if callbackFn then  
                    callbackFn(option)
                end
            end
        end)
    end

    button.MouseButton1Click:Connect(function()
        updateDropdownState(not isOpen)
    end)

    if id then
        self.elements[id] = {
            type = "dropdown",
            instance = frame,
            CurrentValue = defaultOption,
            setValue = function(value)
                if table.find(optionsList, value) then
                    selected = value
                    button.Text = value
                    self.elements[id].CurrentValue = value
                    if callbackFn then  
                        callbackFn(value)
                    end
                end
            end,
            getValue = function()
                return self.elements[id].CurrentValue
            end
        }
    end

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    return self.elements[id]
end

function UiLib:addSlider(config)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(50, 50, 50)
    frameStroke.Thickness = 1
    frameStroke.Parent = frame

    local min = config.Range[1] or 0
    local max = config.Range[2] or 100
    local default = config.CurrentValue or min
    local increment = config.Increment or 0.1
    local callback = config.Callback
    local id = config.Name

    if id then
        self.elements[id] = {
            type = "slider",
            instance = frame,
            CurrentValue = default,
            setValue = function(value)
                local pos = (value - min) / (max - min)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                currentValueLabel.Text = tostring(value)
            end,
            getValue = function()
                return tonumber(currentValueLabel.Text)
            end
        }
    end

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = config.Name or "Slider"
    nameLabel.Size = UDim2.new(1, -20, 0, 20)
    nameLabel.Position = UDim2.new(0, 10, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame

    local sliderHitbox = Instance.new("TextButton")
    sliderHitbox.BackgroundTransparency = 1
    sliderHitbox.Size = UDim2.new(0.85, 0, 0, 30)
    sliderHitbox.Position = UDim2.new(0.075, 0, 0.5, 0)
    sliderHitbox.Text = ""
    sliderHitbox.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    sliderBar.BorderSizePixel = 0
    sliderBar.Size = UDim2.new(1, 0, 0, 4)
    sliderBar.Position = UDim2.new(0, 0, 0.5, 0)
    sliderBar.AnchorPoint = Vector2.new(0, 0.5)
    sliderBar.Parent = sliderHitbox

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = sliderBar

    local sliderFill = Instance.new("Frame")
    sliderFill.BackgroundColor3 = Color3.fromRGB(47, 74, 131)
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Parent = sliderBar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(1, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = sliderFill

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local minLabel = Instance.new("TextBox")
    minLabel.Text = tostring(min)
    minLabel.Size = UDim2.new(0, 50, 0, 20)
    minLabel.Position = UDim2.new(0, 0, 1, -2)
    minLabel.BackgroundTransparency = 1
    minLabel.Font = Enum.Font.SourceSans
    minLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
    minLabel.TextSize = 14
    minLabel.TextXAlignment = Enum.TextXAlignment.Left
    minLabel.Parent = sliderHitbox
    minLabel.ClearTextOnFocus = false
    minLabel.PlaceholderText = "Min"

    local currentValueLabel = Instance.new("TextBox")
    currentValueLabel.Text = tostring(default)
    currentValueLabel.Size = UDim2.new(0, 50, 0, 20)
    currentValueLabel.Position = UDim2.new(0.5, -25, 1, -2)
    currentValueLabel.BackgroundTransparency = 1
    currentValueLabel.Font = Enum.Font.SourceSansBold
    currentValueLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
    currentValueLabel.TextSize = 14
    currentValueLabel.TextXAlignment = Enum.TextXAlignment.Center
    currentValueLabel.Parent = sliderHitbox
    currentValueLabel.ClearTextOnFocus = false
    currentValueLabel.PlaceholderText = "Current"

    local maxLabel = Instance.new("TextBox")
    maxLabel.Text = tostring(max)
    maxLabel.Size = UDim2.new(0, 50, 0, 20)
    maxLabel.Position = UDim2.new(1, -50, 1, -2)
    maxLabel.BackgroundTransparency = 1
    maxLabel.Font = Enum.Font.SourceSans
    maxLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
    maxLabel.TextSize = 14
    maxLabel.TextXAlignment = Enum.TextXAlignment.Right
    maxLabel.Parent = sliderHitbox
    maxLabel.ClearTextOnFocus = false
    maxLabel.PlaceholderText = "Max"

    local function updateValue(value)
        value = math.clamp(value, min, max)
        local roundedValue = math.floor(value / increment + 0.5) * increment
        
        local displayValue
        if increment >= 1 then
            displayValue = tostring(math.floor(roundedValue))
        else
            local decimals = math.max(0, -math.floor(math.log10(increment)))
            displayValue = string.format("%." .. decimals .. "f", roundedValue)
        end

        local pos = (roundedValue - min) / (max - min)
        TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(pos, 0, 1, 0)
        }):Play()

        nameLabel.Text = string.format("%s: %s", config.Name or "Slider", displayValue)
        currentValueLabel.Text = displayValue
        minLabel.Text = tostring(min)
        maxLabel.Text = tostring(max)

        if callback then
            callback(roundedValue)
        end
        if id and self.elements[id] then
            self.elements[id].CurrentValue = roundedValue
        end
    end

    local isDragging = false

    local function updateFromMousePosition(input)
        local relativeX = input.Position.X - sliderHitbox.AbsolutePosition.X
        local pos = math.clamp(relativeX / sliderHitbox.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * pos
        updateValue(value)
    end

    sliderHitbox.MouseButton1Down:Connect(function(x)
        isDragging = true
        updateFromMousePosition({
            Position = Vector2.new(x, 0)
        })
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromMousePosition(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    updateValue(default)

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    return self.elements[id]
end

function UiLib:setTitle(text)
    if not self.titleLabel then
        self.titleLabel = Instance.new("TextLabel")
        self.titleLabel.BackgroundTransparency = 1
        self.titleLabel.Size = UDim2.new(1, 0, 1, 0)
        self.titleLabel.Font = Enum.Font.RobotoMono
        self.titleLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
        self.titleLabel.TextSize = 20
        self.titleLabel.Parent = self.titleFrame
    end
    self.titleLabel.Text = text
end

function UiLib:createSnowflake()
    local snowflake = Instance.new("Frame")
    snowflake.BackgroundTransparency = 1
    snowflake.Size = UDim2.fromOffset(20, 20)

    local center = Instance.new("Frame")
    center.Size = UDim2.fromScale(0.3, 0.3)
    center.Position = UDim2.fromScale(0.35, 0.35)
    center.BackgroundColor3 = Color3.new(1, 1, 1)
    center.BackgroundTransparency = 0.2
    center.BorderSizePixel = 0
    center.Parent = snowflake

    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(1, 0)
    centerCorner.Parent = center
    center.Parent = snowflake

    for i = 1, 6 do
        local angle = math.rad(i * 60)

        local arm = Instance.new("Frame")
        arm.Size = UDim2.new(0.8, 0, 0.1, 0)
        arm.Position = UDim2.fromScale(0.1, 0.45)
        arm.BackgroundColor3 = Color3.new(1, 1, 1)
        arm.BackgroundTransparency = 0.2 
        arm.BorderSizePixel = 0
        arm.Rotation = i * 60

        for j = 1, 2 do
            local branch = Instance.new("Frame")
            branch.Size = UDim2.new(0.4, 0, 0.05, 0)
            branch.Position = UDim2.new(0.3 + (j * 0.2), 0, 0, 0)
            branch.BackgroundColor3 = Color3.new(1, 1, 1)
            branch.BackgroundTransparency = 0.2
            branch.BorderSizePixel = 0
            branch.Rotation = j == 1 and 30 or -30
            branch.Parent = arm
        end

        arm.Parent = snowflake
    end

    return snowflake
end

function UiLib:createSnowflakeEffect()
    if not self.snowflakeContainer then
        self.snowflakeContainer = Instance.new("Frame")
        self.snowflakeContainer.Name = generateRandomName()
        self.snowflakeContainer.BackgroundTransparency = 1
        self.snowflakeContainer.Size = UDim2.fromScale(1.5, 1.5)
        self.snowflakeContainer.Position = UDim2.fromScale(-0.25, -0.25)
        self.snowflakeContainer.ZIndex = -1
        self.snowflakeContainer.Parent = self.gui

        self.snowflakes = {}
        for i = 1, SNOWFLAKE_COUNT do
            local snowflake = self:createSnowflake()
            local size = math.random(SNOWFLAKE_SIZE_MIN, SNOWFLAKE_SIZE_MAX)
            snowflake.Size = UDim2.fromOffset(size, size)
            snowflake.BackgroundTransparency = 1
            snowflake.Rotation = math.random(0, 360)
            snowflake.ZIndex = -1 

            for _, child in pairs(snowflake:GetDescendants()) do
                if child:IsA("GuiObject") then
                    child.ZIndex = -1
                end
            end

            snowflake.Position = UDim2.new(math.random(), 0, math.random(-0.5, 1.5), 0)
            snowflake.Parent = self.snowflakeContainer

            self.snowflakes[snowflake] = {
                velocity = Vector2.new(math.random(-30, 30) / 100, math.random(50, 100) / 100) * SNOWFLAKE_SPEED,
                rotationSpeed = math.random(-50, 50) / 100
            }
        end
    end
end

function UiLib:updateSnowflakes(deltaTime)
    if not self.snowflakes then
        return
    end

    for snowflake, data in pairs(self.snowflakes) do
        local newPosition = snowflake.Position +
                                UDim2.fromScale(data.velocity.X * deltaTime, data.velocity.Y * deltaTime)

        if newPosition.Y.Scale > 1.7 then
            newPosition = UDim2.new(math.random(), 0, -0.2, 
            0)
            data.velocity = Vector2.new(math.random(-30, 30) / 100, math.random(50, 100) / 100) * SNOWFLAKE_SPEED
        end

        snowflake.Position = newPosition
        snowflake.Rotation = snowflake.Rotation + (data.rotationSpeed * deltaTime * 60)
    end
end

function UiLib:startSnowflakeAnimation()
    if self.snowflakeConnection then
        self.snowflakeConnection:Disconnect()
    end

    self.snowflakeConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if self.snowflakes then
            self:updateSnowflakes(deltaTime)
        end
    end)
end

function UiLib:toggle()
    if self.gui.Enabled then
        local startPos = self.mainFrame.Position
        local endPos = UDim2.new(0.5, 0, 1.5, 0)

        local frameTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

        local frameTween = TweenService:Create(self.mainFrame, frameTweenInfo, {
            Position = endPos
        })

        local blurTweenInfo = TweenInfo.new(0.3,
        Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, false, 0.1
        )

        local blurTween = TweenService:Create(self.blur, blurTweenInfo, {
            Size = 0
        })

        frameTween:Play()
        blurTween:Play()

        frameTween.Completed:Connect(function()
            self.gui.Enabled = false
            self.mainFrame.Position = startPos
        end)
    else
        local endPos = UDim2.new(0.5, 0, 0.5, 0)
        self.mainFrame.Position = UDim2.new(0.5, 0, -0.5, 0)
        self.gui.Enabled = true

        local frameTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)

        local frameTween = TweenService:Create(self.mainFrame, frameTweenInfo, {
            Position = endPos
        })

        local blurTweenInfo = TweenInfo.new(0.3, 
        Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)

        local blurTween = TweenService:Create(self.blur, blurTweenInfo, {
            Size = BLUR_STRENGTH
        })

        blurTween:Play() 
        task.wait(0.1) 
        frameTween:Play() 
    end
end

function UiLib:destroy()
    self.gui:Destroy()
end

function UiLib:addTab(name)
    if not self.tabButtons then
        self.tabButtons = Instance.new("Frame")
        self.tabButtons.Name = generateRandomName()
        self.tabButtons.Size = UDim2.new(1, 0, 0, 30)
        self.tabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        self.tabButtons.BorderSizePixel = 0
        self.tabButtons.Parent = self.tabContainer

        local tabContainerStroke = Instance.new("UIStroke")
        tabContainerStroke.Color = Color3.fromRGB(47, 74, 131)
        tabContainerStroke.Thickness = 1
        tabContainerStroke.Parent = self.tabButtons

        local listLayout = Instance.new("UIListLayout")
        listLayout.FillDirection = Enum.FillDirection.Horizontal
        listLayout.Padding = UDim.new(0, 0)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = self.tabButtons

        self.tabContents = Instance.new("Frame")
        self.tabContents.Name = generateRandomName()
        self.tabContents.Size = UDim2.new(1, 0, 1, 0)
        self.tabContents.BackgroundTransparency = 1
        self.tabContents.Parent = self.realContentFrame

        self.tabs = {}
        self.activeTab = nil
        self.tabCount = 0
    end

    self.tabCount = self.tabCount + 1

    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1 / self.tabCount, 0, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Font = Enum.Font.SourceSans
    tabButton.TextSize = 14
    tabButton.Parent = self.tabButtons

    for _, tab in pairs(self.tabs) do
        tab.button.Size = UDim2.new(1 / self.tabCount, 0, 1, 0)
    end

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Visible = false
    tabContent.ScrollBarThickness = 0
    tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Parent = self.tabContents

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = tabContent

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 0) 
    contentPadding.PaddingBottom = UDim.new(0, 15)
    contentPadding.Parent = tabContent

    local tab = {
        button = tabButton,
        content = tabContent,
        elements = {},

        addLabel = function(_, text, id)
            self.activeTab = name
            return self:addLabel(text, id)
        end,

        addButton = function(_, text, callback, id)
            self.activeTab = name
            return self:addButton(text, callback, id)
        end,

        addTextBox = function(_, placeholderText, callback, id)
            self.activeTab = name
            return self:addTextBox(placeholderText, callback, id)
        end,

        addDropdown = function(_, options, callback, id)
            self.activeTab = name
            return self:addDropdown(options, callback, id)
        end,

        addSlider = function(_, config)
            self.activeTab = name
            return self:addSlider(config)
        end,

        addGroupbox = function(_, titleOrConfig)
            self.activeTab = name
            return self:addGroupbox(titleOrConfig)
        end,

        addToggle = function(_, config)
            self.activeTab = name
            return self:addToggle(config)
        end,

        addKeybind = function(_, config)
            self.activeTab = name
            return self:addKeybind(config)
        end,
        
        addColorPicker = function(_, config)
            self.activeTab = name
            return self:addColorPicker(config)
        end
    }

    tabButton.MouseButton1Click:Connect(function()
        self:selectTab(name)
    end)

    self.tabs[name] = tab

    if not self.activeTab then
        self:selectTab(name)
    end

    return tab
end

function UiLib:selectTab(name)
    for tabName, tab in pairs(self.tabs) do
        tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tab.content.Visible = false
    end

    self.activeTab = name
    self.tabs[name].button.BackgroundColor3 = Color3.fromRGB(47, 74, 131)
    self.tabs[name].content.Visible = true
end

function UiLib:getElement(id)
    return self.elements[id]
end

function UiLib:getAllElements()
    local elements = {}
    for id, element in pairs(self.elements) do
        elements[id] = {
            type = element.type,
            value = element.getValue and element.getValue() or nil
        }
    end
    return elements
end

function UiLib:getTabs()
    local tabNames = {}
    for name, _ in pairs(self.tabs or {}) do
        table.insert(tabNames, name)
    end
    return tabNames
end

function UiLib:getCurrentTab()
    return self.activeTab
end

function UiLib:addGroupbox(titleOrConfig)
    local title = type(titleOrConfig) == "table" and titleOrConfig.Title or titleOrConfig

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Color = Color3.fromRGB(50, 50, 50)
    frameStroke.Thickness = 1
    frameStroke.Parent = frame

    local headerButton = Instance.new("TextButton")
    headerButton.Size = UDim2.new(1, 0, 0, 30)
    headerButton.Position = UDim2.new(0, 0, 0, 0)
    headerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    headerButton.BorderSizePixel = 0
    headerButton.Text = ""
    headerButton.AutoButtonColor = false
    headerButton.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerButton

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -25, 0.5, 0)
    arrow.AnchorPoint = Vector2.new(0, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(225, 225, 225)
    arrow.TextSize = 12
    arrow.Font = Enum.Font.SourceSansBold
    arrow.Parent = headerButton

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Position = UDim2.new(0, 0, 0, 30)
    contentFrame.Size = UDim2.new(1, -10, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = contentFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = contentFrame

    local isExpanded = true
    local function updateState()
        local contentSize = layout.AbsoluteContentSize.Y + padding.PaddingTop.Offset + padding.PaddingBottom.Offset
        local targetSize = isExpanded and UDim2.new(0.95, 0, 0, contentSize + 35) or UDim2.new(0.95, 0, 0, 30)

        frame.Size = targetSize
        contentFrame.Size = UDim2.new(1, -10, 0, isExpanded and contentSize or 0)
        arrow.Rotation = isExpanded and 0 or -90
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isExpanded then
            local contentSize = layout.AbsoluteContentSize.Y + padding.PaddingTop.Offset + padding.PaddingBottom.Offset
            frame.Size = UDim2.new(0.95, 0, 0, contentSize + 35)
            contentFrame.Size = UDim2.new(1, -10, 0, contentSize)
        end
    end)

    task.delay(0.1, function()
        updateState()
    end)

    headerButton.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded

        local contentSize = layout.AbsoluteContentSize.Y + padding.PaddingTop.Offset + padding.PaddingBottom.Offset
        local targetSize = isExpanded and UDim2.new(0.95, 0, 0, contentSize + 35) or UDim2.new(0.95, 0, 0, 30)

        TweenService:Create(frame, TweenInfo.new(0.3), {
            Size = targetSize
        }):Play()
        TweenService:Create(contentFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(1, -10, 0, isExpanded and contentSize or 0)
        }):Play()
        TweenService:Create(arrow, TweenInfo.new(0.3), {
            Rotation = isExpanded and 0 or -90
        }):Play()
    end)

    local groupboxMethods = {
        _container = contentFrame,

        addToggle = function(_, config)
            print("Creating toggle in groupbox:", config.Name)
            local element = self:addToggle(config)
            if element and element.instance then
                print("Toggle created, setting parent") 
                element.instance.Parent = contentFrame
            else
                print("Failed to create toggle")
            end
            return element
        end,

        addButton = function(_, config)
            local element = self:addButton(config)
            if element and element.instance then
                element.instance.Parent = contentFrame
            end
            return element
        end,

        addSlider = function(_, config)
            print("Creating slider in groupbox:", config.Name)
            local element = self:addSlider(config)
            if element and element.instance then
                print("Slider created, setting parent")
                element.instance.Parent = contentFrame
            else
                print("Failed to create slider") 
            end
            return element
        end,

        addLabel = function(_, text, id)
            local element = self:addLabel(text, id)
            if element and element.instance then
                element.instance.Parent = contentFrame
            end
            return element
        end,

        addTextBox = function(_, placeholderText, callback, id)
            local element = self:addTextBox(placeholderText, callback, id)
            if element and element.instance then
                element.instance.Parent = contentFrame
            end
            return element
        end,

        addDropdown = function(_, options, callback, id, multiSelect)
            local element = self:addDropdown(options, callback, id, multiSelect)
            if element and element.instance then
                element.instance.Parent = contentFrame
            end
            return element
        end,

        addKeybind = function(_, config)
            local element = self:addKeybind(config)
            if element and element.instance then
                element.instance.Parent = contentFrame
            end
            return element
        end,

        addColorPicker = function(_, config)
            return self:addColorPicker(config)
        end
    }

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    return groupboxMethods
end

function UiLib:addToggle(config)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 30)

    local toggled = config.CurrentValue or false
    local callback = config.Callback
    local id = config.Name

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = config.Name or "Toggle"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 0)
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame

    local button = Instance.new("TextButton")
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Size = UDim2.new(0, 40, 0, 20)
    button.Position = config.CurrentKeybind and UDim2.new(1, -80, 0.5, 0) or UDim2.new(1, -10, 0.5, 0)
    button.AnchorPoint = Vector2.new(1, 0.5)
    button.Text = ""
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0.5, 0)
    circle.AnchorPoint = Vector2.new(0, 0.5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.Parent = button

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local function updateToggle()
        if toggled then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(47, 74, 131)
            }):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 22, 0.5, 0)
            }):Play()
        else
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            }):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, 0)
            }):Play()
        end
    end

    if id then
        self.elements[id] = {
            type = "toggle",
            instance = frame,
            CurrentValue = toggled,
            setValue = function(value)
                toggled = value
                updateToggle()
                if callback then
                    callback(toggled)
                end
            end,
            getValue = function()
                return toggled
            end
        }
    end

    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
        if id and self.elements[id] then
            self.elements[id].CurrentValue = toggled
        end
        if callback then
            task.spawn(function()
                callback(toggled)
            end)
        end
    end)

    if config.CurrentKeybind then
        local keybindButton = Instance.new("TextButton")
        keybindButton.Size = UDim2.new(0, 60, 0, 20)
        keybindButton.Position = UDim2.new(1, -10, 0.5, 0)
        keybindButton.AnchorPoint = Vector2.new(1, 0.5)
        keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        keybindButton.BorderSizePixel = 0
        keybindButton.Font = Enum.Font.SourceSans
        keybindButton.TextColor3 = Color3.fromRGB(225, 225, 225)
        keybindButton.TextSize = 14
        keybindButton.Parent = frame

        local keybindCorner = Instance.new("UICorner")
        keybindCorner.CornerRadius = UDim.new(0, 4)
        keybindCorner.Parent = keybindButton

        local currentKey = config.CurrentKeybind
        local isBinding = false

        local function updateKeybindText()
            keybindButton.Text = isBinding and "..." or currentKey
        end

        updateKeybindText()

        keybindButton.MouseButton1Click:Connect(function()
            isBinding = true
            updateKeybindText()
        end)

        local keybindConnection
        local function setupKeybindConnection()
            if keybindConnection then
                keybindConnection:Disconnect()
            end

            keybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if isBinding then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        currentKey = "NONE"
                        isBinding = false
                        updateKeybindText()
                    elseif input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode.Name
                        isBinding = false
                        updateKeybindText()
                    end
                elseif not gameProcessed and currentKey ~= "NONE" and 
                    ((input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey) or
                    (input.UserInputType == Enum.UserInputType.MouseButton1 and currentKey == "MB1") or
                    (input.UserInputType == Enum.UserInputType.MouseButton2 and currentKey == "MB2")) then
                    toggled = not toggled
                    updateToggle()
                    if id and self.elements[id] then
                        self.elements[id].CurrentValue = toggled
                    end
                    if callback then
                        task.spawn(function()
                            callback(toggled)
                        end)
                    end
                end
            end)
        end

        setupKeybindConnection()

        if id and self.elements[id] then
            self.elements[id].setKeybind = function(newKey)
                currentKey = newKey
                updateKeybindText()
                setupKeybindConnection()
            end
            self.elements[id].getKeybind = function()
                return currentKey
            end
        end
    end

    updateToggle()

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    return self.elements[id]
end

function UiLib:addKeybind(config)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0.95, 0, 0, 30)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(75, 75, 75)
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Text = config.Name or "Keybind"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = Color3.fromRGB(225, 225, 225)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 20)
    button.Position = UDim2.new(1, -90, 0.5, 0)
    button.AnchorPoint = Vector2.new(0, 0.5)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.SourceSans
    button.TextColor3 = Color3.fromRGB(225, 225, 225)
    button.TextSize = 14
    button.Text = config.CurrentKeybind or "NONE" 
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button

    local currentKey = config.CurrentKeybind
    local isBinding = false
    local holdToInteract = config.HoldToInteract or false

    local function updateText()
        button.Text = isBinding and "..." or currentKey or "NONE"
    end

    button.MouseButton1Click:Connect(function()
        isBinding = true
        updateText()
    end)

    UserInputService.InputBegan:Connect(function(input)
        if isBinding then
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                currentKey = "NONE"
                isBinding = false
                updateText()
            elseif input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode.Name
                isBinding = false
                updateText()

                if config.Name == "toggle UI" then
                    if self.toggleConnection then
                        self.toggleConnection:Disconnect()
                    end
                    self.toggleConnection = UserInputService.InputBegan:Connect(function(keyInput)
                        if keyInput.KeyCode.Name == currentKey then
                            self:toggle()
                        end
                    end)
                end
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey and currentKey ~=
            "NONE" then
            if holdToInteract then
                if callback then
                    callback(true)
                end
            else
                if callback then
                    callback()
                end
            end
        end
    end)

    if config.Name == "toggle UI" then
        if self.toggleConnection then
            self.toggleConnection:Disconnect()
        end
        self.toggleConnection = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode.Name == currentKey then
                self:toggle()
            end
        end)
    end

    if holdToInteract then
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey and currentKey ~=
                "NONE" then
                if callback then
                    callback(false)
                end
            end
        end)
    end

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    if id then
        self.elements[id] = {
            type = "keybind",
            instance = frame,
            setValue = function(keyCode)
                currentKey = keyCode
                updateText()
            end,
            getValue = function()
                return currentKey
            end
        }
    end

    return self.elements[id]
end

function UiLib:createNotificationContainer()
    self.notificationContainer = Instance.new("Frame")
    self.notificationContainer.Name = generateRandomName()
    self.notificationContainer.Size = UDim2.new(0, NOTIFICATION_WIDTH, 1, 0)
    self.notificationContainer.Position = UDim2.new(0, NOTIFICATION_PADDING, 0, NOTIFICATION_PADDING)
    self.notificationContainer.BackgroundTransparency = 1
    self.notificationContainer.Parent = self.gui

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.Parent = self.notificationContainer
end

function UiLib:createSuccessIcon(parent)
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Text = "✓"
    icon.TextColor3 = Color3.fromRGB(46, 204, 113)
    icon.TextSize = 16
    icon.Font = Enum.Font.GothamBold
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center
    icon.Parent = parent
    return icon
end

function UiLib:createWarningIcon(parent)
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Text = "⚠" 
    icon.TextColor3 = Color3.fromRGB(241, 196, 15)
    icon.TextSize = 24
    icon.Position = UDim2.new(0, 0, 0, -2)
    icon.Font = Enum.Font.GothamBold
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center
    icon.Parent = parent
    return icon
end

function UiLib:createDangerIcon(parent)
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.BackgroundTransparency = 1
    icon.Text = "X" 
    icon.TextColor3 = Color3.fromRGB(231, 76, 60)
    icon.TextSize = 24
    icon.Font = Enum.Font.GothamBold
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.TextYAlignment = Enum.TextYAlignment.Center
    icon.Parent = parent
    return icon
end

function UiLib:notify(text, notificationType)
    if not self.notificationContainer then
        self:createNotificationContainer()
    end

    local colors = {
        success = Color3.fromRGB(46, 204, 113),
        warning = Color3.fromRGB(241, 196, 15),
        danger = Color3.fromRGB(231, 76, 60)
    }
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, NOTIFICATION_WIDTH, 0, NOTIFICATION_HEIGHT)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notification.BorderSizePixel = 0
    notification.ClipsDescendants = true
    notification.BackgroundTransparency = 1
    notification.Position = UDim2.new(0, -NOTIFICATION_WIDTH - 20, 0, 0)
    notification.Parent = self.notificationContainer
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 45)
    stroke.Thickness = 1
    stroke.Transparency = 1
    stroke.Parent = notification

    local icon
    if notificationType == "success" then
        icon = self:createSuccessIcon(notification)
    elseif notificationType == "warning" then
        icon = self:createWarningIcon(notification)
    elseif notificationType == "danger" then
        icon = self:createDangerIcon(notification)
    end

    if icon then
        icon.Position = UDim2.new(0, 10, 0.5, 0)
        icon.AnchorPoint = Vector2.new(0, 0.5)
        icon.TextTransparency = 1
    end

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextColor3 = colors[notificationType] or colors.success
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTransparency = 1
    label.Parent = notification

    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://297774371"
    shadow.ImageColor3 = Color3.fromRGB(15, 15, 15)
    shadow.ImageTransparency = 1
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.ZIndex = -1
    shadow.Parent = notification

    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
    local fadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local positionTween = TweenService:Create(notification, tweenInfo, {
        Position = UDim2.new(0, 0, 0, 0)
    })

    local fadeTweens = {TweenService:Create(notification, fadeInfo, {
        BackgroundTransparency = 0
    }), TweenService:Create(stroke, fadeInfo, {
        Transparency = 0
    }), TweenService:Create(label, fadeInfo, {
        TextTransparency = 0
    }), TweenService:Create(shadow, fadeInfo, {
        ImageTransparency = 0.6
    })}

    if icon then
        table.insert(fadeTweens, TweenService:Create(icon, fadeInfo, {
            TextTransparency = 0
        }))
    end

    positionTween:Play()
    for _, tween in ipairs(fadeTweens) do
        tween:Play()
    end

    task.delay(NOTIFICATION_DURATION, function()
        local exitTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        local exitPositionTween = TweenService:Create(notification, exitTweenInfo, {
            Position = UDim2.new(0, -NOTIFICATION_WIDTH - 20, 0, 0)
        })

        local exitFadeTweens = {TweenService:Create(notification, exitTweenInfo, {
            BackgroundTransparency = 1
        }), TweenService:Create(stroke, exitTweenInfo, {
            Transparency = 1
        }), TweenService:Create(label, exitTweenInfo, {
            TextTransparency = 1
        }), TweenService:Create(shadow, exitTweenInfo, {
            ImageTransparency = 1
        })}

        if icon then
            table.insert(exitFadeTweens, TweenService:Create(icon, exitTweenInfo, {
                TextTransparency = 1
            }))
        end

        exitPositionTween:Play()
        for _, tween in ipairs(exitFadeTweens) do
            tween:Play()
        end

        exitPositionTween.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

local function createHitMarker(position)
    local marker = Instance.new("Part")
    marker.Anchored = true
    marker.CanCollide = false
    marker.Size = Vector3.new(0.5, 0.5, 0.5)
    marker.Position = position
    marker.Color = Color3.fromRGB(0, 255, 0)
    marker.Parent = workspace
    
    game:GetService("Debris"):AddItem(marker, 1)
end

function UiLib:addColorPicker(config)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95, 0, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = config.Name or "Color Picker"
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 0)
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame

    local preview = Instance.new("TextButton")
    preview.Size = UDim2.new(0, 30, 0, 20)
    preview.Position = UDim2.new(1, -40, 0.5, 0)
    preview.AnchorPoint = Vector2.new(0.5, 0.5)
    preview.BackgroundColor3 = config.CurrentColor or Color3.fromRGB(255, 0, 0)
    preview.Text = ""
    preview.Parent = frame

    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, 200, 0, 240)
    popup.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    popup.BorderSizePixel = 0
    popup.Visible = false
    popup.ZIndex = 100
    popup.Parent = self.gui

    local colorBox = Instance.new("Frame")
    colorBox.Size = UDim2.new(1, -20, 0, 180)
    colorBox.Position = UDim2.new(0, 10, 0, 10)
    colorBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    colorBox.BorderSizePixel = 0
    colorBox.ZIndex = 101
    colorBox.Parent = popup

    local hueSlider = Instance.new("Frame")
    hueSlider.Size = UDim2.new(1, -20, 0, 20)
    hueSlider.Position = UDim2.new(0, 10, 0, 200) 
    hueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueSlider.BorderSizePixel = 0
    hueSlider.ZIndex = 101
    hueSlider.Parent = popup

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
    })
    hueGradient.Parent = hueSlider

    local hueCursor = Instance.new("Frame")
    hueCursor.Size = UDim2.new(0, 2, 1, 0)
    hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    hueCursor.BorderSizePixel = 0
    hueCursor.ZIndex = 102
    hueCursor.Parent = hueSlider
    local colorCursor = Instance.new("Frame")
    colorCursor.Size = UDim2.new(0, 10, 0, 10)
    colorCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    colorCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    colorCursor.BorderSizePixel = 0
    colorCursor.ZIndex = 104
    colorCursor.Parent = colorBox

    local colorCursorCorner = Instance.new("UICorner")
    colorCursorCorner.CornerRadius = UDim.new(1, 0)
    colorCursorCorner.Parent = colorCursor

    local whiteGradient = Instance.new("Frame")
    whiteGradient.Size = UDim2.new(1, 0, 1, 0)
    whiteGradient.BackgroundColor3 = Color3.new(1, 1, 1)
    whiteGradient.BorderSizePixel = 0
    whiteGradient.ZIndex = 102
    whiteGradient.Parent = colorBox

    local whiteToColorGradient = Instance.new("UIGradient")
    whiteToColorGradient.Transparency = NumberSequence.new(0)
    whiteToColorGradient.Parent = whiteGradient

    local blackGradient = Instance.new("Frame")
    blackGradient.Size = UDim2.new(1, 0, 1, 0)
    blackGradient.BackgroundColor3 = Color3.new(0, 0, 0)
    blackGradient.BorderSizePixel = 0
    blackGradient.ZIndex = 103
    blackGradient.Parent = colorBox

    local blackToTransGradient = Instance.new("UIGradient")
    blackToTransGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    blackToTransGradient.Rotation = 90
    blackToTransGradient.Parent = blackGradient

    local hue, sat, val = 0, 1, 1
    if config.CurrentColor then
        hue, sat, val = Color3.toHSV(config.CurrentColor)
    end
    local dragging = false
    local hueDragging = false

    local function updateColor()
        local baseColor = Color3.fromHSV(hue, 1, 1)
        whiteToColorGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, baseColor)
        })

        local finalColor = Color3.fromHSV(hue, sat, val)
        preview.BackgroundColor3 = finalColor
        
        if config.Callback then
            config.Callback(finalColor)
        end
    end

    colorCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
    hueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
    updateColor()

    colorBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    colorBox.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
        end
    end)

    hueSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local boxPosition = colorBox.AbsolutePosition
                local boxSize = colorBox.AbsoluteSize
                local relativeX = math.clamp(input.Position.X - boxPosition.X, 0, boxSize.X)
                local relativeY = math.clamp(input.Position.Y - boxPosition.Y, 0, boxSize.Y)
                
                sat = relativeX / boxSize.X
                val = 1 - (relativeY / boxSize.Y)
                
                colorCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
                updateColor()
            elseif hueDragging then
                local sliderPosition = hueSlider.AbsolutePosition
                local sliderSize = hueSlider.AbsoluteSize
                local relativeX = math.clamp(input.Position.X - sliderPosition.X, 0, sliderSize.X)
                
                hue = relativeX / sliderSize.X
                hueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
                updateColor()
            end
        end
    end)

    preview.MouseButton1Click:Connect(function()
        popup.Visible = not popup.Visible
        if popup.Visible then
            local previewPos = preview.AbsolutePosition
            local previewSize = preview.AbsoluteSize
            popup.Position = UDim2.new(
                0, previewPos.X - popup.AbsoluteSize.X + previewSize.X,
                0, previewPos.Y + previewSize.Y + 5
            )
        end
    end)

    if self.activeTab and self.tabs[self.activeTab] then
        frame.Parent = self.tabs[self.activeTab].content
    else
        frame.Parent = self.realContentFrame
    end

    return {
        instance = frame,
        setValue = function(color)
            local h, s, v = Color3.toHSV(color)
            hue, sat, val = h, s, v
            colorCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
            hueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
            updateColor()
        end,
        getValue = function()
            return preview.BackgroundColor3
        end
    }
end

return UiLib
