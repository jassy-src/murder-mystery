-- Murder Mystery 2 Script with ESP and Aimbot
-- GitHub: https://github.com/warechloe6-rgb/murder-mystery
-- Version: 1.0

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "MM2 Script",
    LoadingTitle = "warechloe6-rgb",
    LoadingSubtitle = "https://github.com/warechloe6-rgb/murder-mystery",
    ConfigurationSaving = {
        Enabled = false,
    }
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)

-- Role ESP Toggle
ESPTab:CreateToggle({
    Name = "Role ESP",
    CurrentValue = false,
    Callback = function(value)
        getgenv().RoleESPEnabled = value
    end,
})

-- Name ESP Toggle
ESPTab:CreateToggle({
    Name = "Name ESP",
    CurrentValue = false,
    Callback = function(value)
        getgenv().NameESPEnabled = value
    end,
})

-- Distance ESP Toggle
ESPTab:CreateToggle({
    Name = "Distance ESP",
    CurrentValue = false,
    Callback = function(value)
        getgenv().DistanceESPEnabled = value
    end,
})

-- ESP Folder for Highlights
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MM2_RoleESP_Highlights"
ESPFolder.Parent = game.CoreGui

-- Name ESP Folder
local NameESPFolder = Instance.new("Folder")
NameESPFolder.Name = "MM2_NameESP"
NameESPFolder.Parent = game.CoreGui

-- Track Player Function
local function TrackPlayer(player)
    -- Role ESP Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_RoleESP"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = ESPFolder

    -- Name ESP Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = player.Name .. "_NameESP"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = NameESPFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = ""
    distanceLabel.TextColor3 = Color3.new(1, 1, 0)
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.Parent = billboard

    coroutine.wrap(function()
        while player and player.Parent do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    highlight.Adornee = char
                    billboard.Adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                    
                    -- Check for weapons to determine role
                    local knife = char:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
                    local gun = char:FindFirstChild("Gun") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun"))
                    
                    if knife then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Murderer (Red)
                        nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    elseif gun then
                        highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Sheriff (Blue)
                        nameLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
                    else
                        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Innocent (Green)
                        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    end
                    
                    -- Calculate distance
                    local localChar = game.Players.LocalPlayer.Character
                    if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                        local distance = (char:FindFirstChild("HumanoidRootPart").Position - localChar:FindFirstChild("HumanoidRootPart").Position).Magnitude
                        distanceLabel.Text = string.format("%.1f studs", distance)
                    end
                    
                    highlight.Enabled = getgenv().RoleESPEnabled
                    billboard.Enabled = getgenv().NameESPEnabled
                    distanceLabel.Visible = getgenv().DistanceESPEnabled
                else
                    highlight.Enabled = false
                    billboard.Enabled = false
                end
            end)
            task.wait(0.1)
        end
        highlight:Destroy()
        billboard:Destroy()
    end)()
end

-- Track existing players
for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        TrackPlayer(player)
    end
end

-- Track new players
game.Players.PlayerAdded:Connect(function(player)
    if player ~= game.Players.LocalPlayer then
        TrackPlayer(player)
    end
end)

-- Clean up when players leave
game.Players.PlayerRemoving:Connect(function(player)
    local oldHighlight = ESPFolder:FindFirstChild(player.Name .. "_RoleESP")
    if oldHighlight then
        oldHighlight:Destroy()
    end
    local oldBillboard = NameESPFolder:FindFirstChild(player.Name .. "_NameESP")
    if oldBillboard then
        oldBillboard:Destroy()
    end
end)

-- Aimbot Tab
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

-- Aimbot Toggle
AimbotTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(value)
        getgenv().AimbotEnabled = value
    end,
})

-- Aimbot Settings
AimbotTab:CreateSlider({
    Name = "Aimbot Smoothness",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(value)
        getgenv().AimbotSmoothness = value
    end,
})

AimbotTab:CreateToggle({
    Name = "Target Murderers Only",
    CurrentValue = true,
    Callback = function(value)
        getgenv().TargetMurderersOnly = value
    end,
})

-- Aimbot Function
local camera = game.Workspace.CurrentCamera
local target = nil

local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- Check if target is murderer (if setting is enabled)
                if getgenv().TargetMurderersOnly then
                    local knife = char:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
                    if not knife then
                        continue
                    end
                end
                
                local distance = (char:FindFirstChild("HumanoidRootPart").Position - camera.CFrame.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().AimbotEnabled then
        local closestPlayer = getClosestPlayer()
        if closestPlayer then
            local char = closestPlayer.Character
            if char and char:FindFirstChild("Head") then
                local targetPos = char:FindFirstChild("Head").Position
                local currentCFrame = camera.CFrame
                local lookAt = CFrame.lookAt(currentCFrame.Position, targetPos)
                
                local smoothness = getgenv().AimbotSmoothness or 5
                camera.CFrame = currentCFrame:Lerp(lookAt, 0.1 / smoothness)
            end
        end
    end
end)

-- Farm Tab
local FarmTab = Window:CreateTab("Farm", 4483362458)

local autofarm = false

FarmTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Callback = function(value)
        autofarm = value
        if value then
            coroutine.wrap(function()
                while autofarm do
                    pcall(function()
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- Teleport to farm location (adjust coordinates as needed)
                            char:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(99.9, 140.4, 60.7)
                        end
                    end)
                    task.wait(0.1)
                end
            end)()
        end
    end,
})

-- Auto Collect Coins
FarmTab:CreateToggle({
    Name = "Auto Collect Coins",
    CurrentValue = false,
    Callback = function(value)
        getgenv().AutoCollectCoins = value
        if value then
            coroutine.wrap(function()
                while getgenv().AutoCollectCoins do
                    pcall(function()
                        for _, coin in ipairs(game.Workspace:GetDescendants()) do
                            if coin:IsA("Part") and coin.Name:lower():find("coin") then
                                local char = game.Players.LocalPlayer.Character
                                if char and char:FindFirstChild("HumanoidRootPart") then
                                    char:FindFirstChild("HumanoidRootPart").CFrame = coin.CFrame
                                    task.wait(0.5)
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)()
        end
    end,
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- No Clip
MiscTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Callback = function(value)
        getgenv().NoClipEnabled = value
        if value then
            coroutine.wrap(function()
                while getgenv().NoClipEnabled do
                    pcall(function()
                        local char = game.Players.LocalPlayer.Character
                        if char then
                            for _, part in ipairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)()
        end
    end,
})

-- Infinite Jump
MiscTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(value)
        getgenv().InfiniteJump = value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfiniteJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Speed Boost
MiscTab:CreateSlider({
    Name = "Speed Boost",
    Range = {16, 100},
    Increment = 4,
    CurrentValue = 16,
    Callback = function(value)
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
            end
        end)
    end,
})

-- GitHub Tab
local GitHubTab = Window:CreateTab("GitHub", 4483362458)

GitHubTab:CreateButton({
    Name = "Copy GitHub to Clipboard",
    Callback = function()
        setclipboard("https://github.com/warechloe6-rgb/murder-mystery")
        Rayfield:Notify({
            Title = "GitHub",
            Content = "Copied GitHub link to clipboard!",
            Duration = 5
        })
    end,
})

GitHubTab:CreateButton({
    Name = "Get Latest Script",
    Callback = function()
        setclipboard("loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/warechloe6-rgb/murder-mystery/main/murder_mystery_script.lua'))()")
        Rayfield:Notify({
            Title = "Script Link",
            Content = "Copied latest script link to clipboard!",
            Duration = 5
        })
    end,
})

-- Credits
GitHubTab:CreateLabel("Script by warechloe6-rgb")
GitHubTab:CreateLabel("Version: 1.0")
GitHubTab:CreateLabel("Features: ESP, Aimbot, Farm, Misc")

-- Notification on load
Rayfield:Notify({
    Title = "MM2 Script Loaded",
    Content = "warechloe6-rgb MM2 Script with ESP and Aimbot",
    Duration = 5
})
