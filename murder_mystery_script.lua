-- Roblox Murder Mystery Script - Solara Style UI
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

-- Custom UI System - Solara Style
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolaraGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(1, 0, 1, 0)
MainContainer.Position = UDim2.new(0, 0, 0, 0)
MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainContainer.BorderSizePixel = 0
MainContainer.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainContainer

-- Logo
local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 100, 1, 0)
Logo.Position = UDim2.new(0, 10, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "solara"
Logo.TextColor3 = Color3.fromRGB(100, 200, 255)
Logo.TextScaled = true
Logo.Font = Enum.Font.SourceSansBold
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = TopBar

-- Script Tabs Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -120, 1, 0)
TabContainer.Position = UDim2.new(0, 120, 0, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = TopBar

-- Script Tabs
local ScriptTabs = {}
local ActiveTab = nil

-- Create Script Tab Function
local function CreateScriptTab(scriptName)
    local Tab = Instance.new("TextButton")
    Tab.Name = scriptName .. "Tab"
    Tab.Size = UDim2.new(0, 80, 0, 30)
    Tab.Position = UDim2.new(0, #ScriptTabs * 85, 0, 10)
    Tab.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Tab.BorderSizePixel = 0
    Tab.Text = "Script #" .. (#ScriptTabs + 1)
    Tab.TextColor3 = Color3.fromRGB(180, 180, 180)
    Tab.TextScaled = true
    Tab.Font = Enum.Font.SourceSans
    Tab.Parent = TabContainer
    
    Tab.MouseButton1Click:Connect(function()
        -- Reset all tabs
        for _, tab in pairs(ScriptTabs) do
            tab.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            tab.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        -- Activate clicked tab
        Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActiveTab = scriptName
    end)
    
    ScriptTabs[scriptName] = Tab
    return Tab
end

-- Create main script tab
local MainScriptTab = CreateScriptTab("MurderMystery")
MainScriptTab.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MainScriptTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ActiveTab = "MurderMystery"

-- Control Buttons
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Size = UDim2.new(0, 100, 1, 0)
ControlsFrame.Position = UDim2.new(1, -100, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = TopBar

-- Settings Button
local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Size = UDim2.new(0, 20, 0, 20)
SettingsButton.Position = UDim2.new(0, 10, 0, 15)
SettingsButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SettingsButton.BorderSizePixel = 0
SettingsButton.Text = "⚙"
SettingsButton.TextColor3 = Color3.fromRGB(200, 200, 200)
SettingsButton.TextScaled = true
SettingsButton.Font = Enum.Font.SourceSans
SettingsButton.Parent = ControlsFrame

-- Execute Button
local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Size = UDim2.new(0, 20, 0, 20)
ExecuteButton.Position = UDim2.new(0, 40, 0, 15)
ExecuteButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
ExecuteButton.BorderSizePixel = 0
ExecuteButton.Text = "▶"
ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteButton.TextScaled = true
ExecuteButton.Font = Enum.Font.SourceSans
ExecuteButton.Parent = ControlsFrame

-- Clear Button
local ClearButton = Instance.new("TextButton")
ClearButton.Name = "ClearButton"
ClearButton.Size = UDim2.new(0, 20, 0, 20)
ClearButton.Position = UDim2.new(0, 70, 0, 15)
ClearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ClearButton.BorderSizePixel = 0
ClearButton.Text = "✕"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextScaled = true
ClearButton.Font = Enum.Font.SourceSans
ClearButton.Parent = ControlsFrame

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -50)
ContentArea.Position = UDim2.new(0, 0, 0, 50)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainContainer

-- Background Image
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://75487938851287" -- Your custom background image
BackgroundImage.ImageTransparency = 0.7
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = ContentArea

-- Dark Overlay
local DarkOverlay = Instance.new("Frame")
DarkOverlay.Name = "DarkOverlay"
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
DarkOverlay.Position = UDim2.new(0, 0, 0, 0)
DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.BackgroundTransparency = 0.6
DarkOverlay.BorderSizePixel = 0
DarkOverlay.Parent = ContentArea

-- Script Editor Area
local EditorArea = Instance.new("ScrollingFrame")
EditorArea.Name = "EditorArea"
EditorArea.Size = UDim2.new(1, -40, 1, -40)
EditorArea.Position = UDim2.new(0, 20, 0, 20)
EditorArea.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
EditorArea.BorderSizePixel = 1
EditorArea.BorderColor3 = Color3.fromRGB(40, 40, 50)
EditorArea.ScrollBarThickness = 8
EditorArea.Parent = ContentArea

-- Script Content Display
local ScriptContent = Instance.new("TextLabel")
ScriptContent.Name = "ScriptContent"
ScriptContent.Size = UDim2.new(1, 0, 1, 0)
ScriptContent.Position = UDim2.new(0, 0, 0, 0)
ScriptContent.BackgroundTransparency = 1
ScriptContent.Text = "-- Murder Mystery Script Loaded\n-- Press your lock-on key to aim at nearest player\n-- Press your menu key to toggle this interface\n\nFeatures:\n• ESP - See players through walls\n• Lock-On - Auto aim at players\n• Custom keybinds\n• Beautiful UI"
ScriptContent.TextColor3 = Color3.fromRGB(200, 200, 200)
ScriptContent.TextScaled = false
ScriptContent.Font = Enum.Font.Code
ScriptContent.TextSize = 14
ScriptContent.TextXAlignment = Enum.TextXAlignment.Left
ScriptContent.TextYAlignment = Enum.TextYAlignment.Top
ScriptContent.Parent = EditorArea

-- Settings Panel (Hidden by default)
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Size = UDim2.new(0, 300, 0, 400)
SettingsPanel.Position = UDim2.new(1, -320, 0, 60)
SettingsPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SettingsPanel.BorderSizePixel = 1
SettingsPanel.BorderColor3 = Color3.fromRGB(60, 60, 70)
SettingsPanel.Visible = false
SettingsPanel.Parent = MainContainer

-- Settings Title
local SettingsTitle = Instance.new("TextLabel")
SettingsTitle.Name = "SettingsTitle"
SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
SettingsTitle.Position = UDim2.new(0, 0, 0, 0)
SettingsTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SettingsTitle.BorderSizePixel = 0
SettingsTitle.Text = "⚙ Settings"
SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsTitle.TextScaled = true
SettingsTitle.Font = Enum.Font.SourceSansBold
SettingsTitle.Parent = SettingsPanel

-- Settings Content
local SettingsContent = Instance.new("ScrollingFrame")
SettingsContent.Name = "SettingsContent"
SettingsContent.Size = UDim2.new(1, -20, 1, -60)
SettingsContent.Position = UDim2.new(0, 10, 0, 50)
SettingsContent.BackgroundTransparency = 1
SettingsContent.BorderSizePixel = 0
SettingsContent.ScrollBarThickness = 6
SettingsContent.Parent = SettingsPanel

-- Initialize global variables
getgenv().ESPEnabled = true
getgenv().LockOnEnabled = true
getgenv().ESPColor = Color3.fromRGB(255, 105, 180)
getgenv().LockOnSmoothness = 0.1
getgenv().LockOnFOV = 30
getgenv().UIVisible = true
getgenv().MenuKey = "K"
getgenv().LockOnKey = "Q"

-- Variables
local LockedTarget = nil
local ESP_Objects = {}
local IsLocked = false

-- ESP Folder
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MM2_ESP_Highlights"
ESPFolder.Parent = game.CoreGui

-- Create Settings Options
local function CreateSettingOption(yPos, labelText, currentValue, callback)
    local OptionFrame = Instance.new("Frame")
    OptionFrame.Name = "Option_" .. labelText
    OptionFrame.Size = UDim2.new(1, 0, 0, 40)
    OptionFrame.Position = UDim2.new(0, 0, 0, yPos)
    OptionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    OptionFrame.BorderSizePixel = 0
    OptionFrame.Parent = SettingsContent
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextScaled = true
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = OptionFrame
    
    local Input = Instance.new("TextBox")
    Input.Name = "Input"
    Input.Size = UDim2.new(0, 80, 0, 25)
    Input.Position = UDim2.new(1, -90, 0, 7.5)
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Input.BorderSizePixel = 1
    Input.BorderColor3 = Color3.fromRGB(60, 60, 70)
    Input.Text = currentValue
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.TextScaled = true
    Input.Font = Enum.Font.SourceSans
    Input.Parent = OptionFrame
    
    Input.FocusLost:Connect(function()
        callback(Input.Text)
    end)
    
    return Input
end

-- Create settings options
local MenuKeyInput = CreateSettingOption(10, "Menu Keybind:", getgenv().MenuKey, function(value)
    getgenv().MenuKey = value:upper()
end)

local LockOnKeyInput = CreateSettingOption(60, "Lock-On Keybind:", getgenv().LockOnKey, function(value)
    getgenv().LockOnKey = value:upper()
end)

-- ESP Toggle Setting
local ESPToggleFrame = Instance.new("Frame")
ESPToggleFrame.Name = "ESPToggleFrame"
ESPToggleFrame.Size = UDim2.new(1, 0, 0, 40)
ESPToggleFrame.Position = UDim2.new(0, 0, 0, 110)
ESPToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ESPToggleFrame.BorderSizePixel = 0
ESPToggleFrame.Parent = SettingsContent

local ESPToggleLabel = Instance.new("TextLabel")
ESPToggleLabel.Name = "Label"
ESPToggleLabel.Size = UDim2.new(1, -100, 1, 0)
ESPToggleLabel.Position = UDim2.new(0, 10, 0, 0)
ESPToggleLabel.BackgroundTransparency = 1
ESPToggleLabel.Text = "ESP Enabled"
ESPToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ESPToggleLabel.TextScaled = true
ESPToggleLabel.Font = Enum.Font.SourceSans
ESPToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ESPToggleLabel.Parent = ESPToggleFrame

local ESPToggleButton = Instance.new("TextButton")
ESPToggleButton.Name = "Toggle"
ESPToggleButton.Size = UDim2.new(0, 60, 0, 25)
ESPToggleButton.Position = UDim2.new(1, -70, 0, 7.5)
ESPToggleButton.BackgroundColor3 = getgenv().ESPEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
ESPToggleButton.BorderSizePixel = 0
ESPToggleButton.Text = getgenv().ESPEnabled and "ON" or "OFF"
ESPToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggleButton.TextScaled = true
ESPToggleButton.Font = Enum.Font.SourceSansBold
ESPToggleButton.Parent = ESPToggleFrame

ESPToggleButton.MouseButton1Click:Connect(function()
    getgenv().ESPEnabled = not getgenv().ESPEnabled
    ESPToggleButton.Text = getgenv().ESPEnabled and "ON" or "OFF"
    ESPToggleButton.BackgroundColor3 = getgenv().ESPEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
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

-- Lock-On Toggle Setting
local LockOnToggleFrame = Instance.new("Frame")
LockOnToggleFrame.Name = "LockOnToggleFrame"
LockOnToggleFrame.Size = UDim2.new(1, 0, 0, 40)
LockOnToggleFrame.Position = UDim2.new(0, 0, 0, 160)
LockOnToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
LockOnToggleFrame.BorderSizePixel = 0
LockOnToggleFrame.Parent = SettingsContent

local LockOnToggleLabel = Instance.new("TextLabel")
LockOnToggleLabel.Name = "Label"
LockOnToggleLabel.Size = UDim2.new(1, -100, 1, 0)
LockOnToggleLabel.Position = UDim2.new(0, 10, 0, 0)
LockOnToggleLabel.BackgroundTransparency = 1
LockOnToggleLabel.Text = "Lock-On Enabled"
LockOnToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LockOnToggleLabel.TextScaled = true
LockOnToggleLabel.Font = Enum.Font.SourceSans
LockOnToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
LockOnToggleLabel.Parent = LockOnToggleFrame

local LockOnToggleButton = Instance.new("TextButton")
LockOnToggleButton.Name = "Toggle"
LockOnToggleButton.Size = UDim2.new(0, 60, 0, 25)
LockOnToggleButton.Position = UDim2.new(1, -70, 0, 7.5)
LockOnToggleButton.BackgroundColor3 = getgenv().LockOnEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
LockOnToggleButton.BorderSizePixel = 0
LockOnToggleButton.Text = getgenv().LockOnEnabled and "ON" or "OFF"
LockOnToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockOnToggleButton.TextScaled = true
LockOnToggleButton.Font = Enum.Font.SourceSansBold
LockOnToggleButton.Parent = LockOnToggleFrame

LockOnToggleButton.MouseButton1Click:Connect(function()
    getgenv().LockOnEnabled = not getgenv().LockOnEnabled
    LockOnToggleButton.Text = getgenv().LockOnEnabled and "ON" or "OFF"
    LockOnToggleButton.BackgroundColor3 = getgenv().LockOnEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
    if not getgenv().LockOnEnabled then
        Unlock()
    end
end)

-- Update SettingsContent canvas size
SettingsContent.CanvasSize = UDim2.new(0, 0, 0, 220)

-- Settings button handler
SettingsButton.MouseButton1Click:Connect(function()
    SettingsPanel.Visible = not SettingsPanel.Visible
end)

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

-- Input Handling
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    
    -- Lock-On key
    if Input.KeyCode == Enum.KeyCode[getgenv().LockOnKey] and getgenv().LockOnEnabled then
        if IsLocked then
            Unlock()
        else
            local Target = GetClosestPlayer()
            if Target then
                LockOn(Target)
            end
        end
    end
    
    -- Menu key
    if Input.KeyCode == Enum.KeyCode[getgenv().MenuKey] then
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

print("🌸 Solara MM2 Script Loaded!")
print("Menu Key: " .. getgenv().MenuKey .. " | Lock-On Key: " .. getgenv().LockOnKey)
