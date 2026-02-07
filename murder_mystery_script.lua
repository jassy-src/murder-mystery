-- Made by Jassy ❤
-- Property of ScriptForge ❤

-- Anti-Cheat Bypass
local function bypassAntiCheat()
    -- Bypass "Invalid position" kick
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
        
        -- Prevent position validation
        hrp.Changed:Connect(function(property)
            if property == "Position" then
                hrp.Position = hrp.Position
            end
        end)
        
        -- Bypass teleport detection
        local oldTeleport = hrp.Position
        game:GetService("RunService").Heartbeat:Connect(function()
            if (hrp.Position - oldTeleport).Magnitude > 50 then
                oldTeleport = hrp.Position
            end
        end)
    end
    
    -- Bypass speed detection
    game:GetService("RunService").Stepped:Connect(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid.MoveDirection.Magnitude > 0 then
                humanoid.WalkSpeed = math.min(humanoid.WalkSpeed, 50)
            end
        end
    end)
end

-- Test Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
print(Rayfield and "[Rayfield loaded]" or "[Rayfield failed to load]")

if not Rayfield then
    game.Players.LocalPlayer:Kick("[Rayfield UI library is currently down. Please try again later.]")
    return
end

-- Activate anti-cheat bypass
bypassAntiCheat()

local Window = Rayfield:CreateWindow({
    Name = "🔫 MM2 Script 🔫",
    LoadingTitle = "⚡ MM2 Script ⚡",
    LoadingSubtitle = "❤ Made by Jassy ❤",
    ConfigurationSaving = {
        Enabled = false,
    },
    BackgroundImage = "https://i.imgur.com/f6P9Vci.jpeg"
})

-- ESP Tab 🎯
local ESPTab = Window:CreateTab("🎯 ESP", 4483362458)

-- Role ESP Toggle 🔴
ESPTab:CreateToggle({
    Name = "🔴 Role ESP",
    CurrentValue = false,
    Callback = function(value)
        getgenv().RoleESPEnabled = value
    end,
})

-- Name ESP Toggle 📝
ESPTab:CreateToggle({
    Name = "📝 Name ESP",
    CurrentValue = false,
    Callback = function(value)
        getgenv().NameESPEnabled = value
    end,
})

-- Distance ESP Toggle 📏
ESPTab:CreateToggle({
    Name = "📏 Distance ESP",
    CurrentValue = false,
    Callback = function(value)
        getgenv().DistanceESPEnabled = value
    end,
})

-- Gun ESP Toggle 🔫
ESPTab:CreateToggle({
    Name = "🔫 Gun ESP",
    CurrentValue = false,
    Callback = function(value)
        getgenv().GunESPEnabled = value
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

-- Gun ESP Folder
local GunESPFolder = Instance.new("Folder")
GunESPFolder.Name = "MM2_GunESP"
GunESPFolder.Parent = game.CoreGui

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
                    local gun = char:FindFirstChild("Sheriff Gun") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Sheriff Gun"))
                    
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

-- Gun ESP Function
local function TrackGun(gun)
    -- Check if we're already tracking this gun
    local existingBillboard = GunESPFolder:FindFirstChild(gun:GetFullName() .. "_GunESP")
    if existingBillboard then
        return
    end
    
    -- Gun ESP Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = gun:GetFullName() .. "_GunESP"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = GunESPFolder

    local gunLabel = Instance.new("TextLabel")
    gunLabel.Size = UDim2.new(1, 0, 1, 0)
    gunLabel.BackgroundTransparency = 1
    gunLabel.Text = "🔫 GUN"
    gunLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow
    gunLabel.TextStrokeTransparency = 0
    gunLabel.TextScaled = true
    gunLabel.Font = Enum.Font.SourceSansBold
    gunLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = ""
    distanceLabel.TextColor3 = Color3.fromRGB(255, 165, 0) -- Orange
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.Parent = billboard

    coroutine.wrap(function()
        while gun and gun.Parent and billboard.Parent do
            pcall(function()
                local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart")
                if handle then
                    billboard.Adornee = handle
                    
                    -- Calculate distance
                    local localChar = game.Players.LocalPlayer.Character
                    if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                        local distance = (handle.Position - localChar:FindFirstChild("HumanoidRootPart").Position).Magnitude
                        distanceLabel.Text = string.format("%.1f studs", distance)
                    end
                    
                    billboard.Enabled = getgenv().GunESPEnabled
                else
                    billboard.Enabled = false
                end
            end)
            task.wait(0.1)
        end
        if billboard then
            billboard:Destroy()
        end
    end)()
end

-- Track existing guns in workspace and all subfolders
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Tool") and (obj.Name == "Sheriff Gun" or obj:FindFirstChild("Gun")) and obj:FindFirstChild("Handle") then
        TrackGun(obj)
    end
end

-- Watch for new guns being added anywhere
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Tool") and (obj.Name == "Sheriff Gun" or obj:FindFirstChild("Gun")) and obj:FindFirstChild("Handle") then
        TrackGun(obj)
    end
end)

-- Clean up gun ESP when guns are removed
workspace.DescendantRemoving:Connect(function(obj)
    if obj:IsA("Tool") and obj.Name == "Sheriff Gun" then
        local oldBillboard = GunESPFolder:FindFirstChild(obj.Name .. "_GunESP")
        if oldBillboard then
            oldBillboard:Destroy()
        end
    end
end)

-- Aimbot Tab 🎯
local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

-- Aimbot Keybind Info
AimbotTab:CreateLabel("🎖 Aimbot (Keybind: Q)")
AimbotTab:CreateLabel("Press Q to toggle aimbot on/off")

-- Aimbot Settings ⚙️
AimbotTab:CreateSlider({
    Name = "⚙️ Aimbot Smoothness",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(value)
        getgenv().AimbotSmoothness = value
    end,
})

AimbotTab:CreateToggle({
    Name = "🎯 Target Murderers Only",
    CurrentValue = true,
    Callback = function(value)
        getgenv().TargetMurderersOnly = value
    end,
})

-- Aimbot Keybind (Q key)
getgenv().AimbotEnabled = false -- Initialize aimbot state
getgenv().AimbotSmoothness = 5 -- Initialize smoothness

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        getgenv().AimbotEnabled = not getgenv().AimbotEnabled
        
        -- Show notification when toggled
        Rayfield:Notify({
            Title = "Aimbot",
            Content = "Aimbot " .. (getgenv().AimbotEnabled and "Enabled" or "Disabled"),
            Duration = 2
        })
    end
end)

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
                
                -- Check if player is visible (not behind walls)
                local head = char:FindFirstChild("Head")
                if head then
                    local distance = (head.Position - camera.CFrame.Position).Magnitude
                    if distance < closestDistance and distance < 600 then -- Max aimbot range
                        closestDistance = distance
                        closestPlayer = player
                    end
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

-- Teleport Tab 🌀
local TeleportTab = Window:CreateTab("🌀 Teleport", 4483362458)

local function getPlayerList()
    local players = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then table.insert(players, player.Name) end
    end
    return players
end

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "To player: ",
    Options = getPlayerList(),
    CurrentOption = {""},
    Callback = function(Option)
        local target = game.Players:FindFirstChild(Option[1])
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            Rayfield:Notify({ Title = "Teleport", Content = "Teleported to " .. target.Name, Duration = 2 })
        end
    end,
})

-- Auto-update list
local function updateDropdown() PlayerDropdown:Refresh(getPlayerList(), true) end
game.Players.PlayerAdded:Connect(updateDropdown)
game.Players.PlayerRemoving:Connect(updateDropdown)

TeleportTab:CreateButton({
    Name = "🔫 Teleport to Sheriff",
    Callback = function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and (p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                return
            end
        end
    end,
})

TeleportTab:CreateButton({
    Name = "🔪 Teleport to Murderer",
    Callback = function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                return
            end
        end
    end,
})

-- Credits/Discord Tab 💬
-- Misc Tab 🛠️
local MiscTab = Window:CreateTab("🛠️ Misc", 4483362458)

-- Movement Section
MiscTab:CreateLabel("=== MOVEMENT ===")

-- Anti-Cheat Bypass Toggle
MiscTab:CreateToggle({
    Name = "[Anti-Cheat Bypass]",
    CurrentValue = true,
    Callback = function(value)
        getgenv().AntiCheatBypass = value
    end,
})

-- Position Lock (Bypass Invalid Position)
MiscTab:CreateButton({
    Name = "[Lock Position (Bypass Kick)]",
    Callback = function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            getgenv().LockedPosition = hrp.Position
            
            -- Create position lock loop
            coroutine.wrap(function()
                while getgenv().AntiCheatBypass and hrp and hrp.Parent do
                    pcall(function()
                        hrp.Position = getgenv().LockedPosition
                    end)
                    task.wait(0.1)
                end
            end)()
        end
    end,
})

-- No Clip
MiscTab:CreateToggle({
    Name = "[No Clip]",
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

-- Fly
MiscTab:CreateToggle({
    Name = "[Fly]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().FlyEnabled = value
        local flySpeed = 50
        local flyDirection = Vector3.new(0, 0, 0)
        
        if value then
            local char = game.Players.LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = rootPart
                getgenv().FlyBV = bv
                
                local bg = Instance.new("BodyGyro")
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                bg.P = 10000
                bg.Parent = rootPart
                getgenv().FlyBG = bg
                
                coroutine.wrap(function()
                    while getgenv().FlyEnabled do
                        pcall(function()
                            local cam = workspace.CurrentCamera
                            local moveDirection = Vector3.new(0, 0, 0)
                            
                            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                                moveDirection = moveDirection + cam.CFrame.LookVector
                            end
                            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                                moveDirection = moveDirection - cam.CFrame.LookVector
                            end
                            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                                moveDirection = moveDirection - cam.CFrame.RightVector
                            end
                            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                                moveDirection = moveDirection + cam.CFrame.RightVector
                            end
                            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                                moveDirection = moveDirection + Vector3.new(0, 1, 0)
                            end
                            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                                moveDirection = moveDirection - Vector3.new(0, 1, 0)
                            end
                            
                            if moveDirection.Magnitude > 0 then
                                moveDirection = moveDirection.Unit * flySpeed
                                getgenv().FlyBV.Velocity = moveDirection
                            else
                                getgenv().FlyBV.Velocity = Vector3.new(0, 0, 0)
                            end
                            
                            getgenv().FlyBG.CFrame = cam.CFrame
                        end)
                        task.wait()
                    end
                end)()
            end
        else
            if getgenv().FlyBV then
                getgenv().FlyBV:Destroy()
                getgenv().FlyBV = nil
            end
            if getgenv().FlyBG then
                getgenv().FlyBG:Destroy()
                getgenv().FlyBG = nil
            end
        end
    end,
})

-- Speed Boost Toggle
MiscTab:CreateToggle({
    Name = "[Speed Boost]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().SpeedBoostEnabled = value
        if value then
            getgenv().SpeedBoostValue = 50 -- Default speed value
            coroutine.wrap(function()
                while getgenv().SpeedBoostEnabled do
                    pcall(function()
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChildOfClass("Humanoid") then
                            char:FindFirstChildOfClass("Humanoid").WalkSpeed = getgenv().SpeedBoostValue or 50
                        end
                    end)
                    task.wait(0.1)
                end
            end)()
        else
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 -- Reset to default
                end
            end)
        end
    end,
})

-- Speed Boost Value Slider
MiscTab:CreateSlider({
    Name = "[Speed Value]",
    Range = {16, 200},
    Increment = 4,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().SpeedBoostValue = value
        if getgenv().SpeedBoostEnabled then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
                end
            end)
        end
    end,
})

-- Jump Power Toggle
MiscTab:CreateToggle({
    Name = "[Jump Power]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().JumpPowerEnabled = value
        if value then
            getgenv().JumpPowerValue = 100 -- Default jump value
            coroutine.wrap(function()
                while getgenv().JumpPowerEnabled do
                    pcall(function()
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChildOfClass("Humanoid") then
                            char:FindFirstChildOfClass("Humanoid").JumpPower = getgenv().JumpPowerValue or 100
                        end
                    end)
                    task.wait(0.1)
                end
            end)()
        else
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").JumpPower = 50 -- Reset to default
                end
            end)
        end
    end,
})

-- Jump Power Value Slider
MiscTab:CreateSlider({
    Name = "[Jump Value]",
    Range = {50, 200},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(value)
        getgenv().JumpPowerValue = value
        if getgenv().JumpPowerEnabled then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").JumpPower = value
                end
            end)
        end
    end,
})

-- Infinite Jump
MiscTab:CreateToggle({
    Name = "[Infinite Jump]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().InfiniteJump = value
        if value then
            getgenv().InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    -- Force jump regardless of state
                    humanoid.Jump = true
                    -- Also change state to jumping for better reliability
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            
            -- Also connect to heartbeat for continuous jumping while space is held
            getgenv().InfiniteJumpHeartbeat = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                            -- Allow jumping while in air
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            humanoid.Jump = true
                        end
                    end
                end
            end)
        else
            if getgenv().InfiniteJumpConnection then
                getgenv().InfiniteJumpConnection:Disconnect()
                getgenv().InfiniteJumpConnection = nil
            end
            if getgenv().InfiniteJumpHeartbeat then
                getgenv().InfiniteJumpHeartbeat:Disconnect()
                getgenv().InfiniteJumpHeartbeat = nil
            end
            if getgenv().StatisticsOverlayConnection then
                getgenv().StatisticsOverlayConnection:Disconnect()
                getgenv().StatisticsOverlayConnection = nil
            end
        end
    end,
})

-- Visual Section
MiscTab:CreateLabel("=== VISUAL ===")

-- Full Bright
MiscTab:CreateToggle({
    Name = "[Full Bright]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().FullBrightEnabled = value
        if value then
            getgenv().FullBrightLighting = game:GetService("Lighting")
            getgenv().OriginalBrightness = getgenv().FullBrightLighting.Brightness
            getgenv().OriginalTimeOfDay = getgenv().FullBrightLighting.TimeOfDay
            getgenv().OriginalFogEnd = getgenv().FullBrightLighting.FogEnd
            
            getgenv().FullBrightLighting.Brightness = 2
            getgenv().FullBrightLighting.TimeOfDay = "14:00:00"
            getgenv().FullBrightLighting.FogEnd = 100000
        else
            if getgenv().FullBrightLighting then
                getgenv().FullBrightLighting.Brightness = getgenv().OriginalBrightness or 1
                getgenv().FullBrightLighting.TimeOfDay = getgenv().OriginalTimeOfDay or "14:00:00"
                getgenv().FullBrightLighting.FogEnd = getgenv().OriginalFogEnd or 1000
            end
        end
    end,
})

-- No Fog
MiscTab:CreateToggle({
    Name = "[No Fog]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().NoFogEnabled = value
        if value then
            getgenv().OriginalFogEnd = game:GetService("Lighting").FogEnd
            game:GetService("Lighting").FogEnd = 100000
        else
            if getgenv().OriginalFogEnd then
                game:GetService("Lighting").FogEnd = getgenv().OriginalFogEnd
            end
        end
    end,
})

-- Remove Grass
MiscTab:CreateToggle({
    Name = "[Remove Grass]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().RemoveGrassEnabled = value
        if value then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Terrain") then
                    obj:Clear()
                end
            end
        end
    end,
})

-- Utility Section
MiscTab:CreateLabel("=== UTILITY ===")

-- Auto Respawn
MiscTab:CreateToggle({
    Name = "[Auto Respawn]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().AutoRespawnEnabled = value
        if value then
            coroutine.wrap(function()
                while getgenv().AutoRespawnEnabled do
                    pcall(function()
                        local char = game.Players.LocalPlayer.Character
                        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health <= 0 then
                            game.Players.LocalPlayer:LoadCharacter()
                        end
                    end)
                    task.wait(1)
                end
            end)()
        end
    end,
})

-- Anti AFK
MiscTab:CreateToggle({
    Name = "[Anti AFK]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().AntiAFKEnabled = value
        if value then
            getgenv().AntiAFKConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if getgenv().AntiAFKConnection then
                getgenv().AntiAFKConnection:Disconnect()
                getgenv().AntiAFKConnection = nil
            end
        end
    end,
})

-- Anti Knockback
MiscTab:CreateToggle({
    Name = "[Anti Knockback]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().AntiKnockbackEnabled = value
        if value then
            coroutine.wrap(function()
                while getgenv().AntiKnockbackEnabled do
                    pcall(function()
                        local char = game.Players.LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, 0, 0)
                        end
                    end)
                    task.wait(0.1)
                end
            end)()
        end
    end,
})

-- Auto Grab Gun Button
MiscTab:CreateButton({
    Name = "[Grab Gun (Innocent Only)]",
    Callback = function()
        -- Check if player is innocent (no knife or gun)
        local localPlayer = game.Players.LocalPlayer
        local localChar = localPlayer.Character
        if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Grab Gun",
                Content = "Character not found!",
                Duration = 3
            })
            return
        end
        
        local hasKnife = localChar:FindFirstChild("Knife") or (localPlayer:FindFirstChild("Backpack") and localPlayer.Backpack:FindFirstChild("Knife"))
        local hasGun = localChar:FindFirstChild("Gun") or (localPlayer.Backpack and localPlayer.Backpack:FindFirstChild("Gun"))
        
        -- Only work if innocent (no knife and no gun)
        if hasKnife then
            Rayfield:Notify({
                Title = "Grab Gun",
                Content = "You are the murderer! Cannot grab gun.",
                Duration = 3
            })
            return
        end
        
        if hasGun then
            Rayfield:Notify({
                Title = "Grab Gun", 
                Content = "You already have the gun!",
                Duration = 3
            })
            return
        end
        
        -- Find dropped gun in workspace and all subfolders
        local gunObject = nil
        local gunPosition = nil
        
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and (obj.Name == "Sheriff Gun" or obj:FindFirstChild("Gun") or obj:FindFirstChildWhichIsA("Gun")) then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    gunObject = obj
                    gunPosition = handle.Position
                    break
                end
            end
        end
        
        -- Check if sheriff is dead
        local sheriffDead = false
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer then
                local char = player.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    local hadGun = player.Backpack:FindFirstChild("Sheriff Gun") ~= nil or char:FindFirstChild("Sheriff Gun") ~= nil
                    local isDead = humanoid.Health <= 0
                    
                    if hadGun and isDead then
                        sheriffDead = true
                        break
                    end
                end
            end
        end
        
        if not gunObject or not gunPosition then
            Rayfield:Notify({
                Title = "Grab Gun",
                Content = "No dropped gun found!",
                Duration = 3
            })
            return
        end
        
        if not sheriffDead then
            Rayfield:Notify({
                Title = "Grab Gun",
                Content = "Sheriff is not dead yet!",
                Duration = 3
            })
            return
        end
        
        -- Teleport to gun and grab it
        local hrp = localChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Teleport to gun
            hrp.CFrame = CFrame.new(gunPosition + Vector3.new(0, 2, 0))
            task.wait(0.1)
            
            -- Try to pick up gun multiple times
            local pickedUp = false
            for i = 1, 10 do
                if gunObject and gunObject.Parent then
                    local handle = gunObject:FindFirstChild("Handle") or gunObject:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        -- Move to gun position
                        hrp.CFrame = CFrame.new(handle.Position)
                        task.wait(0.1)
                        
                        -- Check if gun is now in backpack or equipped
                        local backpackGun = localPlayer.Backpack:FindFirstChild("Gun")
                        local equippedGun = localChar:FindFirstChild("Gun")
                        
                        if backpackGun or equippedGun then
                            pickedUp = true
                            -- Equip the gun if it's in backpack
                            if backpackGun then
                                backpackGun.Parent = localChar
                            end
                            break
                        end
                    end
                end
                task.wait(0.1)
            end
            
            -- Notify result
            if pickedUp then
                Rayfield:Notify({
                    Title = "Grab Gun",
                    Content = "Successfully grabbed the gun!",
                    Duration = 3
                })
            else
                Rayfield:Notify({
                    Title = "Grab Gun",
                    Content = "Failed to grab gun",
                    Duration = 3
                })
            end
        end
    end,
})

-- Statistics Overlay
MiscTab:CreateToggle({
    Name = "[Statistics Overlay]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().StatisticsOverlayEnabled = value
        if value then
            -- Create a simple visible overlay for testing
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "StatisticsOverlay"
            ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            
            local OverlayFrame = Instance.new("Frame")
            OverlayFrame.Name = "StatsFrame"
            OverlayFrame.Size = UDim2.new(0, 100, 0, 50)
            OverlayFrame.Position = UDim2.new(0.5, 100, 0, -40)
            OverlayFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            OverlayFrame.BackgroundTransparency = 1 -- Completely transparent
            OverlayFrame.BorderSizePixel = 0 -- No border
            OverlayFrame.Parent = ScreenGui

            local FPSLabel = Instance.new("TextLabel")
            FPSLabel.Name = "FPSLabel"
            FPSLabel.Size = UDim2.new(1, 0, 1, 0)
            FPSLabel.Position = UDim2.new(0, 0, 0, 0)
            FPSLabel.BackgroundTransparency = 1
            FPSLabel.TextColor3 = Color3.fromRGB(255, 192, 203) -- Pink for FPS
            FPSLabel.Font = Enum.Font.SourceSansBold
            FPSLabel.TextSize = 18
            FPSLabel.TextXAlignment = Enum.TextXAlignment.Center
            FPSLabel.TextYAlignment = Enum.TextYAlignment.Center
            FPSLabel.Text = "FPS: Auto-detecting..."
            FPSLabel.Parent = OverlayFrame
            
            getgenv().StatisticsOverlayConnection = game:GetService("RunService").Stepped:Connect(function()
                if getgenv().StatisticsOverlayEnabled and ScreenGui and ScreenGui.Parent then
                    -- Get actual FPS from Roblox
                    local fps = 0
                    pcall(function()
                        fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
                    end)
                    
                    -- Update FPS label only
                    FPSLabel.Text = "FPS: " .. fps
                else
                    -- Clean up if overlay was destroyed
                    if getgenv().StatisticsOverlayConnection then
                        getgenv().StatisticsOverlayConnection:Disconnect()
                        getgenv().StatisticsOverlayConnection = nil
                    end
                end
            end)
            
            -- Show notification that overlay was created
            Rayfield:Notify({
                Title = "Statistics Overlay",
                Content = "Overlay enabled - should be visible now!",
                Duration = 3
            })
            
            print("Statistics Overlay created with visible background")
        else
            -- Clean up overlay
            if getgenv().StatisticsOverlayConnection then
                getgenv().StatisticsOverlayConnection:Disconnect()
                getgenv().StatisticsOverlayConnection = nil
            end
            
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local overlay = playerGui:FindFirstChild("StatisticsOverlay")
                if overlay then
                    overlay:Destroy()
                end
            end
        end
    end,
})

-- Credits/Discord Tab 💬
local CreditsDiscordTab = Window:CreateTab("💬 Credits/Discord", 4483362458)

-- Jassy Section ✨
CreditsDiscordTab:CreateLabel("=== ❤ JASSY ❤ ===")

CreditsDiscordTab:CreateButton({
    Name = "💬 Copy Discord invite to clipboard",
    Callback = function()
        setclipboard("https://discord.gg/RhjnE4tEQ8")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Copied Discord invite to clipboard!",
            Duration = 5
        })
    end,
})

CreditsDiscordTab:CreateButton({
    Name = "⌨️ GUI KEYBIND: K",
    Callback = function()
        Rayfield:Notify({
            Title = "Keybind",
            Content = "GUI Keybind is K",
            Duration = 5
        })
    end,
})

-- Credits 📜
CreditsDiscordTab:CreateLabel("📜 Script made by: Jassy ❤")
CreditsDiscordTab:CreateLabel("📈 Version: 1.0")
CreditsDiscordTab:CreateLabel("🔥 Property Of ScriptForge")

-- Uninject Button
CreditsDiscordTab:CreateButton({
    Name = "[Uninject Script]",
    Callback = function()
        -- Stop all features
        getgenv().RoleESPEnabled = false
        getgenv().NameESPEnabled = false
        getgenv().DistanceESPEnabled = false
        getgenv().GunESPEnabled = false
        getgenv().AimbotEnabled = false
        getgenv().NoClipEnabled = false
        getgenv().FlyEnabled = false
        getgenv().AutoRespawnEnabled = false
        getgenv().AntiAFKEnabled = false
        getgenv().InvisibleEnabled = false
        getgenv().AntiKnockbackEnabled = false
        getgenv().AntiCheatBypass = false
        getgenv().AutoGrabGunEnabled = false
        getgenv().SpeedBoostEnabled = false
        getgenv().JumpPowerEnabled = false
        getgenv().InfiniteJump = false
        getgenv().IsGrabbingGun = false
        getgenv().StatisticsOverlayEnabled = false
        
        -- Reset speed and jump to defaults
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end)
        
        -- Disconnect infinite jump
        if getgenv().InfiniteJumpConnection then
            getgenv().InfiniteJumpConnection:Disconnect()
            getgenv().InfiniteJumpConnection = nil
        end
        if getgenv().InfiniteJumpHeartbeat then
            getgenv().InfiniteJumpHeartbeat:Disconnect()
            getgenv().InfiniteJumpHeartbeat = nil
        end
        
        -- Clean up ESP
        pcall(function()
            if workspace:FindFirstChild("MM2_RoleESP_Highlights") then
                workspace:FindFirstChild("MM2_RoleESP_Highlights"):Destroy()
            end
            if workspace:FindFirstChild("MM2_NameESP") then
                workspace:FindFirstChild("MM2_NameESP"):Destroy()
            end
            if workspace:FindFirstChild("MM2_GunESP") then
                workspace:FindFirstChild("MM2_GunESP"):Destroy()
            end
        end)
        
        -- Clean up Statistics Overlay
        pcall(function()
            local overlay = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("StatisticsOverlay")
            if overlay then
                overlay:Destroy()
            end
        end)
        
        -- Destroy UI
        if Rayfield then
            Rayfield:Destroy()
        end
        
        Rayfield:Notify({
            Title = "Script Uninjected",
            Content = "Script has been successfully uninjected!",
            Duration = 5
        })
    end,
})

-- Status
CreditsDiscordTab:CreateLabel("Status: " .. (Rayfield and "Working" or "Error"))

-- Notification on load
Rayfield:Notify({
    Title = "Jassy's ❤ MM2 Script",
    Content = "Script loaded successfully!",
    Duration = 5
})

print("Jassy's ❤ MM2 Script loaded - Rayfield status: " .. (Rayfield and "Working" or "Error"))
