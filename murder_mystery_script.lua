-- Roblox Murder Mystery Script - Hybrid Solara/Rayfield UI
print("[jassy's mm2] boot")

local function _showInjectedPing()
    pcall(function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        if not lp then return end

        local pg = lp:WaitForChild("PlayerGui")
        local sg = pg:FindFirstChild("JassyMM2_Ping")
        if not sg then
            sg = Instance.new("ScreenGui")
            sg.Name = "JassyMM2_Ping"
            sg.ResetOnSpawn = false
            sg.Parent = pg
        end

        if sg:FindFirstChild("Label") then
            return
        end

        local lbl = Instance.new("TextLabel")
        lbl.Name = "Label"
        lbl.BackgroundTransparency = 0.35
        lbl.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        lbl.BorderSizePixel = 0
        lbl.Size = UDim2.new(0, 220, 0, 26)
        lbl.Position = UDim2.new(0, 12, 0, 12)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Text = "♡ jassy's mm2 injected ♡"
        lbl.Parent = sg

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = lbl
    end)
end

_showInjectedPing()

local function _showError(title, msg)
    pcall(function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        local parent = game:GetService("CoreGui")
        if lp then
            local pg = lp:FindFirstChild("PlayerGui")
            if pg then
                parent = pg
            end
        end

        local sg = Instance.new("ScreenGui")
        sg.Name = "JassyMM2_Error"
        sg.ResetOnSpawn = false
        sg.Parent = parent

        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 420, 0, 140)
        f.Position = UDim2.new(0.5, -210, 0.2, 0)
        f.BackgroundColor3 = Color3.fromRGB(30, 10, 20)
        f.BorderSizePixel = 0
        f.Parent = sg

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 12)
        c.Parent = f

        local s = Instance.new("UIStroke")
        s.Thickness = 1
        s.Transparency = 0.4
        s.Color = Color3.fromRGB(255, 105, 180)
        s.Parent = f

        local t = Instance.new("TextLabel")
        t.BackgroundTransparency = 1
        t.Size = UDim2.new(1, -20, 0, 28)
        t.Position = UDim2.new(0, 10, 0, 8)
        t.Font = Enum.Font.GothamBold
        t.TextSize = 18
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.Text = tostring(title or "Error")
        t.Parent = f

        local b = Instance.new("TextLabel")
        b.BackgroundTransparency = 1
        b.Size = UDim2.new(1, -20, 1, -46)
        b.Position = UDim2.new(0, 10, 0, 40)
        b.Font = Enum.Font.Gotham
        b.TextSize = 14
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.TextYAlignment = Enum.TextYAlignment.Top
        b.TextWrapped = true
        b.TextColor3 = Color3.fromRGB(255, 220, 235)
        b.Text = tostring(msg or "")
        b.Parent = f
    end)
end

local function setToggleVisual(track, knob, enabled)
    if enabled then
        track.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        knob.Position = UDim2.new(0, 38, 0.5, -7)
    else
        track.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        knob.Position = UDim2.new(0, 2, 0.5, -7)
    end
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function uiCorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = inst
    return c
end

local function uiStroke(inst, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness
    s.Transparency = transparency
    s.Color = Color3.fromRGB(255, 255, 255)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end

-- Play opening sound effect
local SoundService = game:GetService("SoundService")
local OpeningSound = Instance.new("Sound")
OpeningSound.SoundId = "rbxassetid://132529299748496"
OpeningSound.Volume = 0.5
OpeningSound.Parent = SoundService
pcall(function()
    OpeningSound:Play()
end)

-- Custom UI System - Hybrid Solara/Rayfield Style
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HybridGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window (Compact like Rayfield)
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 360, 0, 260)
MainWindow.Position = UDim2.new(0.5, -180, 0.5, -130)
MainWindow.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
MainWindow.BorderSizePixel = 0
MainWindow.Parent = ScreenGui

uiCorner(MainWindow, 12)
local mwStroke = uiStroke(MainWindow, 1, 0.82)
mwStroke.Color = Color3.fromRGB(255, 255, 255)

-- Background Image
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.Position = UDim2.new(0, 0, 0, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://75487938851287" -- Your custom background image
BackgroundImage.ImageTransparency = 0.86
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = MainWindow

uiCorner(BackgroundImage, 12)

-- Dark Overlay
local DarkOverlay = Instance.new("Frame")
DarkOverlay.Name = "DarkOverlay"
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
DarkOverlay.Position = UDim2.new(0, 0, 0, 0)
DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.BackgroundTransparency = 0.55
DarkOverlay.BorderSizePixel = 0
DarkOverlay.Parent = MainWindow

uiCorner(DarkOverlay, 12)

local OverlayGradient = Instance.new("UIGradient")
OverlayGradient.Rotation = 90
OverlayGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
})
OverlayGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.25),
    NumberSequenceKeypoint.new(1, 0.05)
})
OverlayGradient.Parent = DarkOverlay

-- Title Bar (Solara style)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainWindow

uiCorner(TitleBar, 12)
local TitleGrad = Instance.new("UIGradient")
TitleGrad.Rotation = 90
TitleGrad.Color = ColorSequence.new(Color3.fromRGB(26, 26, 34), Color3.fromRGB(18, 18, 24))
TitleGrad.Parent = TitleBar

-- Logo (Solara style)
local Logo = Instance.new("TextLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 70, 1, 0)
Logo.Position = UDim2.new(0, 8, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "solara"
Logo.TextColor3 = Color3.fromRGB(100, 200, 255)
Logo.TextScaled = true
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = TitleBar

-- Window Title
local WindowTitle = Instance.new("TextLabel")
WindowTitle.Name = "WindowTitle"
WindowTitle.Size = UDim2.new(1, -110, 1, 0)
WindowTitle.Position = UDim2.new(0, 78, 0, 0)
WindowTitle.BackgroundTransparency = 1
WindowTitle.Text = "Murder Mystery"
WindowTitle.TextColor3 = Color3.fromRGB(225, 225, 235)
WindowTitle.TextScaled = true
WindowTitle.Font = Enum.Font.Gotham
WindowTitle.TextXAlignment = Enum.TextXAlignment.Center
WindowTitle.Parent = TitleBar

-- Control Buttons (Solara style)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Size = UDim2.new(0, 64, 1, 0)
ControlsFrame.Position = UDim2.new(1, -68, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = TitleBar

-- Settings Button
local SettingsButton = Instance.new("TextButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Size = UDim2.new(0, 16, 0, 16)
SettingsButton.Position = UDim2.new(0, 4, 0, 7)
SettingsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
SettingsButton.BorderSizePixel = 0
SettingsButton.Text = "⚙"
SettingsButton.TextColor3 = Color3.fromRGB(180, 180, 180)
SettingsButton.TextScaled = true
SettingsButton.Font = Enum.Font.Gotham
SettingsButton.Parent = ControlsFrame

uiCorner(SettingsButton, 6)
local sbStroke = uiStroke(SettingsButton, 1, 0.85)
sbStroke.Color = Color3.fromRGB(255, 255, 255)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 16, 0, 16)
MinimizeButton.Position = UDim2.new(0, 24, 0, 7)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(180, 180, 180)
MinimizeButton.TextScaled = true
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.Parent = ControlsFrame

uiCorner(MinimizeButton, 6)
local mbStroke = uiStroke(MinimizeButton, 1, 0.85)
mbStroke.Color = Color3.fromRGB(255, 255, 255)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 16, 0, 16)
CloseButton.Position = UDim2.new(0, 44, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.Gotham
CloseButton.Parent = ControlsFrame

uiCorner(CloseButton, 6)

-- Tab Container (Rayfield style)
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainWindow

uiCorner(TabContainer, 10)

-- Tabs
local Tabs = {}
local TabContents = {}

-- Create Tab Function (Hybrid style)
local function CreateTab(name, icon)
    local Tab = Instance.new("TextButton")
    Tab.Name = name .. "Tab"
    Tab.Size = UDim2.new(0, 65, 1, 0)
    Tab.Position = UDim2.new(0, #Tabs * 66, 0, 0)
    Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Tab.BorderSizePixel = 0
    Tab.Text = icon .. " " .. name
    Tab.TextColor3 = Color3.fromRGB(160, 160, 160)
    Tab.TextScaled = true
    Tab.Font = Enum.Font.Gotham
    Tab.Parent = TabContainer
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, -8, 1, -8)
    TabContent.Position = UDim2.new(0, 4, 0, 4)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 6
    TabContent.Visible = false
    TabContent.Parent = TabContainer
    
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
            tab.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            tab.TextColor3 = Color3.fromRGB(160, 160, 160)
        end
        -- Show selected tab content
        TabContent.Visible = true
        Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return TabContent
end

-- Content Area (Rayfield style)
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -60)
ContentArea.Position = UDim2.new(0, 0, 0, 60)
ContentArea.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainWindow

uiCorner(ContentArea, 12)

local contentStroke = uiStroke(ContentArea, 1, 0.9)
contentStroke.Color = Color3.fromRGB(255, 255, 255)

-- Create Main Tab
local MainTab = CreateTab("Main", "🎯")
MainTab.Parent = ContentArea

-- ESP Toggle (Rayfield style)
local ESPToggle = Instance.new("Frame")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(1, -16, 0, 30)
ESPToggle.Position = UDim2.new(0, 10, 0, 10)
ESPToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ESPToggle.BorderSizePixel = 0
ESPToggle.Parent = MainTab

uiCorner(ESPToggle, 10)
local espPanelStroke = uiStroke(ESPToggle, 1, 0.9)
espPanelStroke.Color = Color3.fromRGB(255, 255, 255)

local ESPToggleButton = Instance.new("TextButton")
ESPToggleButton.Name = "Toggle"
ESPToggleButton.Size = UDim2.new(0, 54, 0, 18)
ESPToggleButton.Position = UDim2.new(0, 8, 0, 6)
ESPToggleButton.BackgroundTransparency = 1
ESPToggleButton.BorderSizePixel = 0
ESPToggleButton.Text = ""
ESPToggleButton.Parent = ESPToggle

local ESPTrack = Instance.new("Frame")
ESPTrack.Name = "Track"
ESPTrack.Size = UDim2.new(1, 0, 1, 0)
ESPTrack.Position = UDim2.new(0, 0, 0, 0)
ESPTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
ESPTrack.BorderSizePixel = 0
ESPTrack.Parent = ESPToggleButton
uiCorner(ESPTrack, 999)
local espTrackStroke = uiStroke(ESPTrack, 1, 0.85)
espTrackStroke.Color = Color3.fromRGB(255, 255, 255)

local ESPKnob = Instance.new("Frame")
ESPKnob.Name = "Knob"
ESPKnob.Size = UDim2.new(0, 14, 0, 14)
ESPKnob.Position = UDim2.new(0, 2, 0.5, -7)
ESPKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
ESPKnob.BorderSizePixel = 0
ESPKnob.Parent = ESPTrack
uiCorner(ESPKnob, 999)
local espKnobStroke = uiStroke(ESPKnob, 1, 0.85)
espKnobStroke.Color = Color3.fromRGB(0, 0, 0)

local ESPToggleLabel = Instance.new("TextLabel")
ESPToggleLabel.Name = "Label"
ESPToggleLabel.Size = UDim2.new(1, -62, 1, 0)
ESPToggleLabel.Position = UDim2.new(0, 62, 0, 0)
ESPToggleLabel.BackgroundTransparency = 1
ESPToggleLabel.Text = "👁️ ESP"
ESPToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ESPToggleLabel.TextScaled = true
ESPToggleLabel.Font = Enum.Font.Gotham
ESPToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ESPToggleLabel.Parent = ESPToggle

-- Lock-On Toggle (Rayfield style)
local LockOnToggle = Instance.new("Frame")
LockOnToggle.Name = "LockOnToggle"
LockOnToggle.Size = UDim2.new(1, -16, 0, 30)
LockOnToggle.Position = UDim2.new(0, 10, 0, 48)
LockOnToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
LockOnToggle.BorderSizePixel = 0
LockOnToggle.Parent = MainTab

uiCorner(LockOnToggle, 10)
local lockPanelStroke = uiStroke(LockOnToggle, 1, 0.9)
lockPanelStroke.Color = Color3.fromRGB(255, 255, 255)

local LockOnToggleButton = Instance.new("TextButton")
LockOnToggleButton.Name = "Toggle"
LockOnToggleButton.Size = UDim2.new(0, 54, 0, 18)
LockOnToggleButton.Position = UDim2.new(0, 8, 0, 6)
LockOnToggleButton.BackgroundTransparency = 1
LockOnToggleButton.BorderSizePixel = 0
LockOnToggleButton.Text = ""
LockOnToggleButton.Parent = LockOnToggle

local LockTrack = Instance.new("Frame")
LockTrack.Name = "Track"
LockTrack.Size = UDim2.new(1, 0, 1, 0)
LockTrack.Position = UDim2.new(0, 0, 0, 0)
LockTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
LockTrack.BorderSizePixel = 0
LockTrack.Parent = LockOnToggleButton
uiCorner(LockTrack, 999)
local lockTrackStroke = uiStroke(LockTrack, 1, 0.85)
lockTrackStroke.Color = Color3.fromRGB(255, 255, 255)

local LockKnob = Instance.new("Frame")
LockKnob.Name = "Knob"
LockKnob.Size = UDim2.new(0, 14, 0, 14)
LockKnob.Position = UDim2.new(0, 2, 0.5, -7)
LockKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
LockKnob.BorderSizePixel = 0
LockKnob.Parent = LockTrack
uiCorner(LockKnob, 999)
local lockKnobStroke = uiStroke(LockKnob, 1, 0.85)
lockKnobStroke.Color = Color3.fromRGB(0, 0, 0)

local LockOnToggleLabel = Instance.new("TextLabel")
LockOnToggleLabel.Name = "Label"
LockOnToggleLabel.Size = UDim2.new(1, -62, 1, 0)
LockOnToggleLabel.Position = UDim2.new(0, 62, 0, 0)
LockOnToggleLabel.BackgroundTransparency = 1
LockOnToggleLabel.Text = "🎯 Lock-On"
LockOnToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LockOnToggleLabel.TextScaled = true
LockOnToggleLabel.Font = Enum.Font.Gotham
LockOnToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
LockOnToggleLabel.Parent = LockOnToggle

-- Create Settings Tab
local SettingsTab = CreateTab("Settings", "⚙️")
SettingsTab.Parent = ContentArea

-- Keybind Settings
local KeybindFrame = Instance.new("Frame")
KeybindFrame.Name = "KeybindFrame"
KeybindFrame.Size = UDim2.new(1, -16, 0, 72)
KeybindFrame.Position = UDim2.new(0, 10, 0, 10)
KeybindFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
KeybindFrame.BorderSizePixel = 0
KeybindFrame.Parent = SettingsTab

uiCorner(KeybindFrame, 10)
local keybindStroke = uiStroke(KeybindFrame, 1, 0.9)
keybindStroke.Color = Color3.fromRGB(255, 255, 255)

local MenuKeyLabel = Instance.new("TextLabel")
MenuKeyLabel.Name = "Label"
MenuKeyLabel.Size = UDim2.new(1, -90, 0, 30)
MenuKeyLabel.Position = UDim2.new(0, 10, 0, 5)
MenuKeyLabel.BackgroundTransparency = 1
MenuKeyLabel.Text = "🔑 Menu Keybind"
MenuKeyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
MenuKeyLabel.TextScaled = true
MenuKeyLabel.Font = Enum.Font.Gotham
MenuKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
MenuKeyLabel.Parent = KeybindFrame

local MenuKeyInput = Instance.new("TextBox")
MenuKeyInput.Name = "Input"
MenuKeyInput.Size = UDim2.new(0, 54, 0, 18)
MenuKeyInput.Position = UDim2.new(1, -64, 0, 10)
MenuKeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MenuKeyInput.BorderSizePixel = 1
MenuKeyInput.BorderColor3 = Color3.fromRGB(60, 60, 70)
MenuKeyInput.Text = "K"
MenuKeyInput.PlaceholderText = "K"
MenuKeyInput.ClearTextOnFocus = true
MenuKeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuKeyInput.TextScaled = true
MenuKeyInput.Font = Enum.Font.Gotham
MenuKeyInput.Parent = KeybindFrame

uiCorner(MenuKeyInput, 6)
local mkStroke = uiStroke(MenuKeyInput, 1, 0.85)
mkStroke.Color = Color3.fromRGB(255, 255, 255)

local LockOnKeyLabel = Instance.new("TextLabel")
LockOnKeyLabel.Name = "Label"
LockOnKeyLabel.Size = UDim2.new(1, -90, 0, 30)
LockOnKeyLabel.Position = UDim2.new(0, 10, 0, 38)
LockOnKeyLabel.BackgroundTransparency = 1
LockOnKeyLabel.Text = "🔑 Lock-On Keybind"
LockOnKeyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LockOnKeyLabel.TextScaled = true
LockOnKeyLabel.Font = Enum.Font.Gotham
LockOnKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
LockOnKeyLabel.Parent = KeybindFrame

local LockOnKeyInput = Instance.new("TextBox")
LockOnKeyInput.Name = "Input"
LockOnKeyInput.Size = UDim2.new(0, 54, 0, 18)
LockOnKeyInput.Position = UDim2.new(1, -64, 0, 43)
LockOnKeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
LockOnKeyInput.BorderSizePixel = 1
LockOnKeyInput.BorderColor3 = Color3.fromRGB(60, 60, 70)
LockOnKeyInput.Text = "Q"
LockOnKeyInput.PlaceholderText = "Q"
LockOnKeyInput.ClearTextOnFocus = true
LockOnKeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
LockOnKeyInput.TextScaled = true
LockOnKeyInput.Font = Enum.Font.Gotham
LockOnKeyInput.Parent = KeybindFrame

uiCorner(LockOnKeyInput, 6)
local lkStroke = uiStroke(LockOnKeyInput, 1, 0.85)
lkStroke.Color = Color3.fromRGB(255, 255, 255)

-- Create Info Tab
local InfoTab = CreateTab("Info", "📋")
InfoTab.Parent = ContentArea

-- Info Content
local InfoContent = Instance.new("TextLabel")
InfoContent.Name = "InfoContent"
InfoContent.Size = UDim2.new(1, -20, 1, 0)
InfoContent.Position = UDim2.new(0, 10, 0, 10)
InfoContent.BackgroundTransparency = 1
InfoContent.Text = [[🌸 Hybrid MM2 Script 🌸

🎮 Controls:
• Menu Key: Toggle this UI
• Lock-On Key: Aim at players

🔧 Features:
• ESP - See players through walls
• Lock-On - Auto aim system
• Custom keybinds
• Hybrid UI design

🎨 UI Style:
• Solara + Rayfield hybrid
• Compact design
• Your custom background
• Smooth animations

━━━━━━━━━━━━━━━━━━━━━━
Created by: warechloe6-rgb
GitHub: warechloe6-rgb/murder-mystery]]
InfoContent.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoContent.TextScaled = false
InfoContent.Font = Enum.Font.Gotham
InfoContent.TextSize = 12
InfoContent.TextXAlignment = Enum.TextXAlignment.Left
InfoContent.TextYAlignment = Enum.TextYAlignment.Top
InfoContent.Parent = InfoTab

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
local IsDragging = false
local DragStart = nil
local StartPos = nil
local IsMinimized = false

-- ESP Folder
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MM2_ESP_Highlights"
ESPFolder.Parent = game.CoreGui

-- Initialize toggle visuals
setToggleVisual(ESPTrack, ESPKnob, getgenv().ESPEnabled)
setToggleVisual(LockTrack, LockKnob, getgenv().LockOnEnabled)

-- Opening Animation
MainWindow.Size = UDim2.new(0, 0, 0, 0)
MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)

local OpenTween = TweenService:Create(MainWindow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 360, 0, 260),
    Position = UDim2.new(0.5, -180, 0.5, -130)
})
OpenTween:Play()

-- Select first tab by default
TabContents["Main"].Visible = true
Tabs["Main"].BackgroundColor3 = Color3.fromRGB(45, 45, 55)
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
    NameLabel.Font = Enum.Font.GothamBold
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
    DistanceLabel.Font = Enum.Font.Gotham
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
    HealthLabel.Font = Enum.Font.Gotham
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
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    local MinimizeTween = TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = IsMinimized and UDim2.new(0, 360, 0, 30) or UDim2.new(0, 360, 0, 260)
    })
    MinimizeTween:Play()
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
    setToggleVisual(ESPTrack, ESPKnob, getgenv().ESPEnabled)
    
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
    setToggleVisual(LockTrack, LockKnob, getgenv().LockOnEnabled)
    
    if not getgenv().LockOnEnabled then
        Unlock()
    end
end)

-- Keybind Input Handlers
local function sanitizeKeyName(s)
    s = tostring(s or "")
    s = s:gsub("%s+", "")
    s = s:upper()
    return s
end

local function setKeyFromInput(inputBox, envName)
    local prev = getgenv()[envName]
    local v = sanitizeKeyName(inputBox.Text)
    if v == "" then
        inputBox.Text = prev
        return
    end
    if Enum.KeyCode[v] == nil then
        inputBox.Text = prev
        return
    end
    getgenv()[envName] = v
    inputBox.Text = v
end

MenuKeyInput.FocusLost:Connect(function()
    setKeyFromInput(MenuKeyInput, "MenuKey")
end)

LockOnKeyInput.FocusLost:Connect(function()
    setKeyFromInput(LockOnKeyInput, "LockOnKey")
end)

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

print("🌸 Hybrid MM2 Script Loaded!")
print("Menu Key: " .. getgenv().MenuKey .. " | Lock-On Key: " .. getgenv().LockOnKey)

return
