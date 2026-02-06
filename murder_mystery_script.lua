-- Roblox Murder Mystery Script - Custom UI Version
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Play opening sound effect
local OpeningSound = Instance.new("Sound")
OpeningSound.SoundId = "rbxassetid://132529299748496" -- Your opening sound effect
OpeningSound.Volume = 0.5
OpeningSound.Parent = SoundService
OpeningSound:Play()

-- Custom UI System
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MurderMysteryGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 600, 0, 400)
MainWindow.Position = UDim2.new(0.5, -300, 0.5, -200)
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainWindow.BorderSizePixel = 0
MainWindow.Parent = ScreenGui

-- Background Image
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://75487938851287" -- Your custom background image
BackgroundImage.ImageTransparency = 0.3
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = MainWindow

-- Dark Overlay
local DarkOverlay = Instance.new("Frame")
DarkOverlay.Name = "DarkOverlay"
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
DarkOverlay.Position = UDim2.new(0, 0, 0, 0)
DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.BackgroundTransparency = 0.4
DarkOverlay.BorderSizePixel = 0
DarkOverlay.Parent = MainWindow

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Hot pink
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🌸 Sakura MM2 Script 🌸"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundTransparency = 0.2
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = TitleBar

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 50)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainWindow

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -90)
ContentArea.Position = UDim2.new(0, 0, 0, 90)
ContentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainWindow

-- Tabs
local Tabs = {}
local TabContents = {}

-- Create Tab Function
local function CreateTab(name, icon)
    local Tab = Instance.new("TextButton")
    Tab.Name = name .. "Tab"
    Tab.Size = UDim2.new(0, 100, 1, 0)
    Tab.Position = UDim2.new(0, #Tabs * 100, 0, 0)
    Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Tab.BorderSizePixel = 0
    Tab.Text = icon .. " " .. name
    Tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    Tab.TextScaled = true
    Tab.Font = Enum.Font.SourceSans
    Tab.Parent = TabContainer
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -20, 1, 0)
    TabContent.Position = UDim2.new(0, 10, 0, 10)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 8
    TabContent.Visible = false
    TabContent.Parent = ContentArea
    
    Tabs[name] = Tab
    TabContents[name] = TabContent
    
    -- Tab click handler
    Tab.MouseButton1Click:Connect(function()
        -- Hide all tab contents
        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        -- Reset all tab colors
        for _, tab in pairs(Tabs) do
            tab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            tab.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        -- Show selected tab content
        TabContent.Visible = true
        Tab.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return TabContent
end

-- Create Main Tab
local MainTab = CreateTab("Main", "🎯")

-- ESP Toggle
local ESPToggle = Instance.new("Frame")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(1, 0, 0, 40)
ESPToggle.Position = UDim2.new(0, 0, 0, 10)
ESPToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ESPToggle.BorderSizePixel = 0
ESPToggle.Parent = MainTab

local ESPToggleButton = Instance.new("TextButton")
ESPToggleButton.Name = "Toggle"
ESPToggleButton.Size = UDim2.new(0, 60, 0, 25)
ESPToggleButton.Position = UDim2.new(0, 10, 0, 7.5)
ESPToggleButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
ESPToggleButton.BorderSizePixel = 0
ESPToggleButton.Text = "ON"
ESPToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggleButton.TextScaled = true
ESPToggleButton.Font = Enum.Font.SourceSansBold
ESPToggleButton.Parent = ESPToggle

local ESPToggleLabel = Instance.new("TextLabel")
ESPToggleLabel.Name = "Label"
ESPToggleLabel.Size = UDim2.new(1, -80, 1, 0)
ESPToggleLabel.Position = UDim2.new(0, 80, 0, 0)
ESPToggleLabel.BackgroundTransparency = 1
ESPToggleLabel.Text = "👁️ ESP - See players through walls"
ESPToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggleLabel.TextScaled = true
ESPToggleLabel.Font = Enum.Font.SourceSans
ESPToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ESPToggleLabel.Parent = ESPToggle

-- Lock-On Toggle
local LockOnToggle = Instance.new("Frame")
LockOnToggle.Name = "LockOnToggle"
LockOnToggle.Size = UDim2.new(1, 0, 0, 40)
LockOnToggle.Position = UDim2.new(0, 0, 0, 60)
LockOnToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LockOnToggle.BorderSizePixel = 0
LockOnToggle.Parent = MainTab

local LockOnToggleButton = Instance.new("TextButton")
LockOnToggleButton.Name = "Toggle"
LockOnToggleButton.Size = UDim2.new(0, 60, 0, 25)
LockOnToggleButton.Position = UDim2.new(0, 10, 0, 7.5)
LockOnToggleButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
LockOnToggleButton.BorderSizePixel = 0
LockOnToggleButton.Text = "ON"
LockOnToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockOnToggleButton.TextScaled = true
LockOnToggleButton.Font = Enum.Font.SourceSansBold
LockOnToggleButton.Parent = LockOnToggle

local LockOnToggleLabel = Instance.new("TextLabel")
LockOnToggleLabel.Name = "Label"
LockOnToggleLabel.Size = UDim2.new(1, -80, 1, 0)
LockOnToggleLabel.Position = UDim2.new(0, 80, 0, 0)
LockOnToggleLabel.BackgroundTransparency = 1
LockOnToggleLabel.Text = "🎯 Lock-On - Auto aim at nearest player"
LockOnToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LockOnToggleLabel.TextScaled = true
LockOnToggleLabel.Font = Enum.Font.SourceSans
LockOnToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
LockOnToggleLabel.Parent = LockOnToggle

-- Create Settings Tab
local SettingsTab = CreateTab("Settings", "⚙️")

-- ESP Color Picker
local ColorPickerFrame = Instance.new("Frame")
ColorPickerFrame.Name = "ColorPickerFrame"
ColorPickerFrame.Size = UDim2.new(1, 0, 0, 60)
ColorPickerFrame.Position = UDim2.new(0, 0, 0, 10)
ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ColorPickerFrame.BorderSizePixel = 0
ColorPickerFrame.Parent = SettingsTab

local ColorPickerLabel = Instance.new("TextLabel")
ColorPickerLabel.Name = "Label"
ColorPickerLabel.Size = UDim2.new(1, -120, 1, 0)
ColorPickerLabel.Position = UDim2.new(0, 10, 0, 0)
ColorPickerLabel.BackgroundTransparency = 1
ColorPickerLabel.Text = "🎨 ESP Color"
ColorPickerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPickerLabel.TextScaled = true
ColorPickerLabel.Font = Enum.Font.SourceSans
ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorPickerLabel.Parent = ColorPickerFrame

local ColorPickerButton = Instance.new("TextButton")
ColorPickerButton.Name = "ColorButton"
ColorPickerButton.Size = UDim2.new(0, 80, 0, 30)
ColorPickerButton.Position = UDim2.new(1, -90, 0, 15)
ColorPickerButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
ColorPickerButton.BorderSizePixel = 0
ColorPickerButton.Text = ""
ColorPickerButton.Parent = ColorPickerFrame

-- Initialize global variables
getgenv().ESPEnabled = true
getgenv().LockOnEnabled = true
getgenv().ESPColor = Color3.fromRGB(255, 105, 180)
getgenv().LockOnSmoothness = 0.1
getgenv().LockOnFOV = 30
getgenv().UIVisible = true

-- Variables
local LockedTarget = nil
local ESP_Objects = {}
local IsLocked = false
local IsDragging = false
local DragStart = nil
local StartPos = nil

-- ESP Folder
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MM2_ESP_Highlights"
ESPFolder.Parent = game.CoreGui

-- Opening Animation
MainWindow.Size = UDim2.new(0, 0, 0, 0)
MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)

local OpenTween = TweenService:Create(MainWindow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200)
})
OpenTween:Play()

-- Select first tab by default
TabContents["Main"].Visible = true
Tabs["Main"].BackgroundColor3 = Color3.fromRGB(255, 105, 180)
Tabs["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Utility Functions
local function GetDistance(Position)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return math.huge end
    return (LocalPlayer.Character.HumanoidRootPart.Position - Position).Magnitude
end

local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ClosestDistance = getgenv().LockOnFOV
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.Humanoid.Health > 0 then
            local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            if OnScreen then
                local Distance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if Distance < ClosestDistance then
                    ClosestDistance = Distance
                    ClosestPlayer = Player
                end
            end
        end
    end
    
    return ClosestPlayer
end

-- ESP Functions
local function CreateESP(Player)
    if ESP_Objects[Player] then return end
    
    local Character = Player.Character
    if not Character then return end
    
    local ESP = {}
    
    -- Highlight
    local Highlight = Instance.new("Highlight")
    Highlight.Name = Player.Name .. "_ESP"
    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0
    Highlight.FillColor = getgenv().ESPColor
    Highlight.Parent = ESPFolder
    
    -- Billboard for info
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESP_Billboard"
    Billboard.Size = UDim2.new(0, 200, 0, 100)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = Character:FindFirstChild("Head") or Character:FindFirstChild("HumanoidRootPart")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.Parent = Billboard
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Size = UDim2.new(1, 0, 0, 20)
    NameLabel.Position = UDim2.new(0, 0, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = Player.Name
    NameLabel.TextColor3 = getgenv().ESPColor
    NameLabel.TextStrokeTransparency = 0.5
    NameLabel.TextScaled = true
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.Parent = Frame
    
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Name = "DistanceLabel"
    DistanceLabel.Size = UDim2.new(1, 0, 0, 15)
    DistanceLabel.Position = UDim2.new(0, 0, 0, 20)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Text = ""
    DistanceLabel.TextColor3 = getgenv().ESPColor
    DistanceLabel.TextStrokeTransparency = 0.5
    DistanceLabel.TextScaled = true
    DistanceLabel.Font = Enum.Font.SourceSans
    DistanceLabel.Parent = Frame
    
    local HealthLabel = Instance.new("TextLabel")
    HealthLabel.Name = "HealthLabel"
    HealthLabel.Size = UDim2.new(1, 0, 0, 15)
    HealthLabel.Position = UDim2.new(0, 0, 0, 35)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.Text = ""
    HealthLabel.TextColor3 = getgenv().ESPColor
    HealthLabel.TextStrokeTransparency = 0.5
    HealthLabel.TextScaled = true
    HealthLabel.Font = Enum.Font.SourceSans
    HealthLabel.Parent = Frame
    
    ESP.Highlight = Highlight
    ESP.Billboard = Billboard
    ESP.NameLabel = NameLabel
    ESP.DistanceLabel = DistanceLabel
    ESP.HealthLabel = HealthLabel
    
    ESP_Objects[Player] = ESP
end

local function UpdateESP(Player)
    local ESP = ESP_Objects[Player]
    if not ESP then return end
    
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        RemoveESP(Player)
        return
    end
    
    -- Update highlight
    if ESP.Highlight then
        ESP.Highlight.Adornee = Character
        ESP.Highlight.FillColor = getgenv().ESPColor
        ESP.Highlight.Enabled = getgenv().ESPEnabled
    end
    
    -- Update name
    if ESP.NameLabel then
        ESP.NameLabel.Text = Player.Name
        ESP.NameLabel.TextColor3 = getgenv().ESPColor
        ESP.NameLabel.Visible = getgenv().ESPEnabled
    end
    
    -- Update distance
    if ESP.DistanceLabel then
        local Distance = GetDistance(Character.HumanoidRootPart.Position)
        ESP.DistanceLabel.Text = string.format("Distance: %.0f", Distance)
        ESP.DistanceLabel.TextColor3 = getgenv().ESPColor
        ESP.DistanceLabel.Visible = getgenv().ESPEnabled
    end
    
    -- Update health
    if ESP.HealthLabel and Character:FindFirstChild("Humanoid") then
        local Health = Character.Humanoid.Health
        local MaxHealth = Character.Humanoid.MaxHealth
        ESP.HealthLabel.Text = string.format("Health: %.0f/%.0f", Health, MaxHealth)
        ESP.HealthLabel.TextColor3 = getgenv().ESPColor
        ESP.HealthLabel.Visible = getgenv().ESPEnabled
    end
    
    -- Update billboard
    if ESP.Billboard then
        ESP.Billboard.Enabled = getgenv().ESPEnabled
    end
end

local function RemoveESP(Player)
    local ESP = ESP_Objects[Player]
    if ESP then
        if ESP.Highlight then ESP.Highlight:Destroy() end
        if ESP.Billboard then ESP.Billboard:Destroy() end
        ESP_Objects[Player] = nil
    end
end

-- Lock-On Functions
local function LockOn(Player)
    if not Player or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
    LockedTarget = Player
    IsLocked = true
end

local function Unlock()
    LockedTarget = nil
    IsLocked = false
end

local function UpdateLockOn()
    if not getgenv().LockOnEnabled then
        Unlock()
        return
    end
    
    if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("HumanoidRootPart") then
        if LockedTarget.Character:FindFirstChild("Humanoid").Health <= 0 then
            Unlock()
            return
        end
        
        local TargetPosition = LockedTarget.Character.HumanoidRootPart.Position
        local CurrentCFrame = Camera.CFrame
        local LookAt = CFrame.new(CurrentCFrame.Position, TargetPosition)
        Camera.CFrame = CurrentCFrame:Lerp(LookAt, getgenv().LockOnSmoothness)
    else
        Unlock()
    end
end

-- UI Event Handlers
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    getgenv().UIVisible = false
end)

-- Dragging functionality
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsDragging = true
        DragStart = input.Position
        StartPos = MainWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - DragStart
        MainWindow.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsDragging = false
    end
end)

-- Toggle Handlers
ESPToggleButton.MouseButton1Click:Connect(function()
    getgenv().ESPEnabled = not getgenv().ESPEnabled
    ESPToggleButton.Text = getgenv().ESPEnabled and "ON" or "OFF"
    ESPToggleButton.BackgroundColor3 = getgenv().ESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    
    if getgenv().ESPEnabled then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                CreateESP(Player)
            end
        end
    else
        for Player in pairs(ESP_Objects) do
            RemoveESP(Player)
        end
    end
end)

LockOnToggleButton.MouseButton1Click:Connect(function()
    getgenv().LockOnEnabled = not getgenv().LockOnEnabled
    LockOnToggleButton.Text = getgenv().LockOnEnabled and "ON" or "OFF"
    LockOnToggleButton.BackgroundColor3 = getgenv().LockOnEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    
    if not getgenv().LockOnEnabled then
        Unlock()
    end
end)

-- Color Picker
ColorPickerButton.MouseButton1Click:Connect(function()
    -- Simple color cycling
    local colors = {
        Color3.fromRGB(255, 105, 180), -- Hot pink
        Color3.fromRGB(255, 0, 0),       -- Red
        Color3.fromRGB(0, 255, 0),       -- Green
        Color3.fromRGB(0, 0, 255),        -- Blue
        Color3.fromRGB(255, 255, 0),     -- Yellow
        Color3.fromRGB(255, 0, 255),      -- Magenta
        Color3.fromRGB(0, 255, 255),      -- Cyan
        Color3.fromRGB(255, 255, 255)     -- White
    }
    
    local currentIndex = 1
    for i, color in pairs(colors) do
        if color == getgenv().ESPColor then
            currentIndex = i % #colors + 1
            break
        end
    end
    
    getgenv().ESPColor = colors[currentIndex]
    ColorPickerButton.BackgroundColor3 = getgenv().ESPColor
end)

-- Input Handling
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    
    if Input.KeyCode == Enum.KeyCode.Q and getgenv().LockOnEnabled then
        if IsLocked then
            Unlock()
        else
            local Target = GetClosestPlayer()
            if Target then
                LockOn(Target)
            end
        end
    end
    
    -- K key to toggle GUI
    if Input.KeyCode == Enum.KeyCode.K then
        getgenv().UIVisible = not getgenv().UIVisible
        ScreenGui.Enabled = getgenv().UIVisible
    end
end)

-- Player Management
Players.PlayerAdded:Connect(function(Player)
    if Player ~= LocalPlayer then
        Player.CharacterAdded:Connect(function(Character)
            if getgenv().ESPEnabled then
                CreateESP(Player)
            end
        end)
        
        if getgenv().ESPEnabled then
            CreateESP(Player)
        end
    end
end)

Players.PlayerRemoving:Connect(function(Player)
    RemoveESP(Player)
    if LockedTarget == Player then
        Unlock()
    end
end)

-- Initialize ESP for existing players
for _, Player in pairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        Player.CharacterAdded:Connect(function(Character)
            if getgenv().ESPEnabled then
                CreateESP(Player)
            end
        end)
        
        if getgenv().ESPEnabled then
            CreateESP(Player)
        end
    end
end

-- Main Update Loop
RunService.Heartbeat:Connect(function()
    -- Update ESP for all players
    for Player, ESP in pairs(ESP_Objects) do
        UpdateESP(Player)
    end
    
    -- Update lock-on
    UpdateLockOn()
end)

print("🌸 Sakura MM2 Script Loaded!")
print("Press Q to lock onto nearest player, K to toggle GUI")
