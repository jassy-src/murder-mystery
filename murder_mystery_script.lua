
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

-- Aimbot Tab 🎯 (Sheriff only)
local AimbotTab = Window:CreateTab("🎯 Aimbot (Sheriff only)", 4483362458)

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
getgenv().TargetMurderersOnly = true -- Force murderer targeting by default

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
                local smoothness = getgenv().AimbotSmoothness or 5
                
                -- Aggressive lock-on - directly set CFrame to target with minimal smoothing
                if smoothness <= 3 then
                    -- Very aggressive mode - almost instant lock
                    camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPos)
                else
                    -- Less aggressive but still strong lock
                    local lookAt = CFrame.lookAt(camera.CFrame.Position, targetPos)
                    camera.CFrame = camera.CFrame:Lerp(lookAt, 0.3 / smoothness)
                end
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
        if value then
            getgenv().FlySpeed = getgenv().FlySpeed or 50 -- Use stored speed or default
            local localPlayer = game.Players.LocalPlayer
            local char = localPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                getgenv().FlyBV = Instance.new("BodyVelocity")
                getgenv().FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                getgenv().FlyBV.P = 5000
                getgenv().FlyBV.Parent = hrp
                getgenv().FlyBG = Instance.new("BodyGyro")
                getgenv().FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                getgenv().FlyBG.P = 5000
                getgenv().FlyBG.Parent = hrp
                
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
                                moveDirection = moveDirection.Unit * getgenv().FlySpeed
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

-- Fly Speed Slider
MiscTab:CreateSlider({
    Name = "[Fly Speed]",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().FlySpeed = value
        -- Update fly speed if fly is currently active
        if getgenv().FlyEnabled then
            -- The speed will be applied on the next frame in the fly loop
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

-- Shaders
MiscTab:CreateToggle({
    Name = "[Shaders]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ShadersEnabled = value
        if value then
            -- Store original lighting settings
            getgenv().ShaderLighting = game:GetService("Lighting")
            getgenv().OriginalBrightness = getgenv().ShaderLighting.Brightness
            getgenv().OriginalTimeOfDay = getgenv().ShaderLighting.TimeOfDay
            getgenv().OriginalFogEnd = getgenv().ShaderLighting.FogEnd
            getgenv().OriginalColorShift_Top = getgenv().ShaderLighting.ColorShift_Top
            getgenv().OriginalColorShift_Bottom = getgenv().ShaderLighting.ColorShift_Bottom
            getgenv().OriginalOutdoorAmbient = getgenv().ShaderLighting.OutdoorAmbient
            
            -- Apply RTX-style shader effects
            getgenv().ShaderLighting.Brightness = 0.6 -- Further reduced to combat overexposure
            getgenv().ShaderLighting.TimeOfDay = "14:30:00"
            getgenv().ShaderLighting.FogEnd = 500
            getgenv().ShaderLighting.FogStart = 50
            getgenv().ShaderLighting.FogColor = Color3.fromRGB(135, 150, 180)
            getgenv().ShaderLighting.ColorShift_Top = Color3.fromRGB(50, 50, 60) -- Less intense color shift
            getgenv().ShaderLighting.ColorShift_Bottom = Color3.fromRGB(30, 30, 40) -- Less intense color shift
            getgenv().ShaderLighting.OutdoorAmbient = Color3.fromRGB(80, 80, 95) -- More balanced ambient
            getgenv().ShaderLighting.GlobalShadows = true
            getgenv().ShaderLighting.ShadowSoftness = 0.3
            getgenv().ShaderLighting.EnvironmentDiffuseScale = 0.8
            getgenv().ShaderLighting.EnvironmentSpecularScale = 2.0
            getgenv().ShaderLighting.GeographicLatitude = 30
            
            -- Create atmospheric effects
            local atmosphere = Instance.new("Atmosphere")
            atmosphere.Parent = getgenv().ShaderLighting
            atmosphere.Density = 0.3
            atmosphere.Offset = 0.25
            atmosphere.Color = Color3.fromRGB(180, 190, 200) -- Less saturated atmosphere
            atmosphere.Decay = Color3.fromRGB(240, 240, 240) -- Less intense decay
            atmosphere.Glare = 0.05 -- Reduced glare
            atmosphere.Haze = 0.4 -- Slightly reduced haze
            getgenv().ShaderAtmosphere = atmosphere
            
            -- Create post-processing effects
            local bloom = Instance.new("BloomEffect")
            bloom.Intensity = 0.05 -- Further reduced bloom intensity
            bloom.Size = 20 -- Smaller bloom size
            bloom.Threshold = 0.9 -- Higher threshold to only bloom brightest areas
            bloom.Parent = getgenv().ShaderLighting
            getgenv().ShaderBloom = bloom
            
            local colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Brightness = -0.1 -- Negative brightness to combat overexposure
            colorCorrection.Contrast = 0.4 -- Slightly increased contrast for definition
            colorCorrection.Saturation = 1.1 -- Much less saturated but still vibrant
            colorCorrection.TintColor = Color3.fromRGB(240, 240, 245) -- Warmer, less intense tint
            colorCorrection.Parent = getgenv().ShaderLighting
            getgenv().ShaderColorCorrection = colorCorrection
            
            local sunRays = Instance.new("SunRaysEffect")
            sunRays.Intensity = 0.3 -- Increased from 0.2 for more dramatic rays
            sunRays.Spread = 0.4 -- Increased from 0.3
            sunRays.Parent = getgenv().ShaderLighting
            getgenv().ShaderSunRays = sunRays
            
            local depthOfField = Instance.new("DepthOfFieldEffect")
            depthOfField.FarIntensity = 0 -- Remove far blur completely
            depthOfField.FocusDistance = 100000 -- Set focus to infinity
            depthOfField.InFocusRadius = 100000 -- Everything in focus
            depthOfField.NearIntensity = 0 -- Remove near blur completely
            depthOfField.Parent = getgenv().ShaderLighting
            getgenv().ShaderDepthOfField = depthOfField
            
            -- Enhance materials for reflective surfaces
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    -- Add highly reflective properties to ground/road-like surfaces
                    if obj.Name:lower():find("road") or obj.Name:lower():find("street") or obj.Name:lower():find("ground") or obj.Name:lower():find("floor") or obj.BrickColor == BrickColor.new("Dark stone grey") then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.Reflectance = 0.6 -- Increased from 0.4 for maximum gloss
                        obj.TopSurface = Enum.SurfaceType.Smooth
                        obj.BottomSurface = Enum.SurfaceType.Smooth
                    end
                    
                    -- Add metallic properties to vehicles
                    if obj.Name:lower():find("car") or obj.Parent and obj.Parent.Name:lower():find("car") then
                        obj.Material = Enum.Material.Metal
                        obj.Reflectance = 0.8 -- Increased from 0.6 for maximum metallic gloss
                    end
                    
                    -- Enhance glass materials
                    if obj.Material == Enum.Material.Glass then
                        obj.Reflectance = 0.9 -- Increased from 0.7 for maximum glass gloss
                        obj.Transparency = 0.5 -- Less transparent for more reflection
                    end
                    
                    -- Make all surfaces more glossy
                    if obj.Material == Enum.Material.Plastic then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.Reflectance = 0.4 -- Increased from 0.2
                    end
                    
                    if obj.Material == Enum.Material.Wood or obj.Material == Enum.Material.WoodPlank then
                        obj.Reflectance = 0.3 -- Increased from 0.15 for more wood gloss
                    end
                    
                    if obj.Material == Enum.Material.Concrete then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.Reflectance = 0.5 -- Increased from 0.25
                    end
                    
                    if obj.Material == Enum.Material.Brick then
                        obj.Reflectance = 0.2 -- Increased from 0.1 for more brick gloss
                    end
                    
                    -- Add gloss to all other materials
                    if obj.Material == Enum.Material.Slate then
                        obj.Reflectance = 0.35
                    end
                    
                    if obj.Material == Enum.Material.Marble then
                        obj.Reflectance = 0.7
                    end
                    
                    if obj.Material == Enum.Material.Granite then
                        obj.Reflectance = 0.4
                    end
                    
                    if obj.Material == Enum.Material.Pebble then
                        obj.Reflectance = 0.25
                    end
                end
            end
            
            -- Add dynamic lighting updates
            getgenv().ShaderHeartbeat = game:GetService("RunService").Heartbeat:Connect(function()
                local time = tick()
                getgenv().ShaderLighting.Brightness = 0.6 + math.sin(time * 0.1) * 0.05 -- Fixed base brightness to 0.6
            end)
            
            Rayfield:Notify({
                Title = "Shaders",
                Content = "RTX-style shaders activated!",
                Duration = 3
            })
        else
            -- Restore original lighting settings
            if getgenv().ShaderLighting then
                getgenv().ShaderLighting.Brightness = getgenv().OriginalBrightness or 1
                getgenv().ShaderLighting.TimeOfDay = getgenv().OriginalTimeOfDay or "14:00:00"
                getgenv().ShaderLighting.FogEnd = getgenv().OriginalFogEnd or 1000
                getgenv().ShaderLighting.FogStart = 0
                getgenv().ShaderLighting.ColorShift_Top = getgenv().OriginalColorShift_Top or Color3.new(0,0,0)
                getgenv().ShaderLighting.ColorShift_Bottom = getgenv().OriginalColorShift_Bottom or Color3.new(0,0,0)
                getgenv().ShaderLighting.OutdoorAmbient = getgenv().OriginalOutdoorAmbient or Color3.new(0.5,0.5,0.5)
            end
            
            -- Clean up shader effects
            if getgenv().ShaderAtmosphere then
                getgenv().ShaderAtmosphere:Destroy()
                getgenv().ShaderAtmosphere = nil
            end
            if getgenv().ShaderBloom then
                getgenv().ShaderBloom:Destroy()
                getgenv().ShaderBloom = nil
            end
            if getgenv().ShaderColorCorrection then
                getgenv().ShaderColorCorrection:Destroy()
                getgenv().ShaderColorCorrection = nil
            end
            if getgenv().ShaderSunRays then
                getgenv().ShaderSunRays:Destroy()
                getgenv().ShaderSunRays = nil
            end
            if getgenv().ShaderDepthOfField then
                getgenv().ShaderDepthOfField:Destroy()
                getgenv().ShaderDepthOfField = nil
            end
            if getgenv().ShaderHeartbeat then
                getgenv().ShaderHeartbeat:Disconnect()
                getgenv().ShaderHeartbeat = nil
            end
            
            Rayfield:Notify({
                Title = "Shaders",
                Content = "Shaders disabled!",
                Duration = 3
            })
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
            if obj:IsA("Tool") and (obj.Name == "Gun" or obj:FindFirstChild("Gun")) and obj:FindFirstChild("Handle") then
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
                    local hadGun = player.Backpack:FindFirstChild("Gun") ~= nil or char:FindFirstChild("Gun") ~= nil
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
            -- Store original position in case we need to go back
            local originalPosition = hrp.CFrame
            
            -- Teleport directly to gun position
            hrp.CFrame = CFrame.new(gunPosition)
            task.wait(0.05)
            
            -- Try to pick up gun with more aggressive approach
            local pickedUp = false
            local maxAttempts = 20
            
            for i = 1, maxAttempts do
                -- Check if gun still exists
                if gunObject and gunObject.Parent then
                    local handle = gunObject:FindFirstChild("Handle") or gunObject:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        -- Stay right on the gun
                        hrp.CFrame = CFrame.new(handle.Position)
                        
                        -- Try to manually grab the gun
                        if gunObject.Parent == workspace then
                            gunObject.Parent = localPlayer.Backpack
                        end
                        
                        task.wait(0.05)
                        
                        -- Check if gun is now in backpack or equipped
                        local backpackGun = localPlayer.Backpack:FindFirstChild("Gun")
                        local equippedGun = localChar:FindFirstChild("Gun")
                        
                        if backpackGun or equippedGun then
                            pickedUp = true
                            -- Equip the gun if it's in backpack
                            if backpackGun then
                                backpackGun.Parent = localChar
                                task.wait(0.1)
                            end
                            break
                        end
                    end
                else
                    -- Gun might have been picked up, check again
                    local backpackGun = localPlayer.Backpack:FindFirstChild("Gun")
                    local equippedGun = localChar:FindFirstChild("Gun")
                    if backpackGun or equippedGun then
                        pickedUp = true
                        if backpackGun then
                            backpackGun.Parent = localChar
                        end
                        break
                    end
                end
                task.wait(0.05)
            end
            
            -- Notify result
            if pickedUp then
                Rayfield:Notify({
                    Title = "Grab Gun",
                    Content = "Successfully grabbed the gun!",
                    Duration = 3
                })
            else
                -- Go back to original position if failed
                hrp.CFrame = originalPosition
                Rayfield:Notify({
                    Title = "Grab Gun",
                    Content = "Failed to grab gun - returned to original position",
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

-- Leak murder/sheriff roles
MiscTab:CreateButton({
    Name = "[Leak murder/sheriff]",
    Callback = function()
        local murdererFound = false
        local sheriffFound = false
        local murdererName = "Unknown"
        local sheriffName = "Unknown"
        
        -- Check all players to find murderer and sheriff
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local char = player.Character
                if char then
                    local knife = char:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))
                    local gun = char:FindFirstChild("Gun") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun"))
                    
                    if knife then
                        murdererFound = true
                        murdererName = player.Name
                    elseif gun then
                        sheriffFound = true
                        sheriffName = player.Name
                    end
                end
            end
        end
        
        -- Create message to leak in chat
        local leakMessage = ""
        if murdererFound and sheriffFound then
            leakMessage = murdererName .. " = murderer | " .. sheriffName .. " = sheriff"
        elseif murdererFound then
            leakMessage = murdererName .. " = murderer | Sheriff = Unknown"
        elseif sheriffFound then
            leakMessage = "Murderer = Unknown | " .. sheriffName .. " = sheriff"
        else
            leakMessage = "Murderer = Unknown | Sheriff = Unknown"
        end
        
        -- Send message to chat - MM2 specific method
        wait(0.1)
        
        -- Method 1: Standard Roblox chat
        local chatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chatRemote and chatRemote:FindFirstChild("SayMessageRequest") then
            chatRemote.SayMessageRequest:FireServer(leakMessage, "All")
            return
        end
        
        -- Method 2: Try game chat service
        pcall(function()
            game:GetService("Chat"):Chat(leakMessage)
        end)
        
        -- Method 3: Try player chat with proper formatting
        pcall(function()
            game.Players.LocalPlayer:Chat(leakMessage)
        end)
        
        -- Method 4: Try workspace chat event
        pcall(function()
            local chatEvent = workspace:FindFirstChild("ChatEvent")
            if chatEvent then
                chatEvent:FireServer(leakMessage)
            end
        end)
    end,
})

-- Weapons Tab 🔫
local WeaponsTab = Window:CreateTab("🔫 Weapons", 4483362458)

-- Murderer Powers Section
WeaponsTab:CreateLabel("=== MURDERER POWERS ===")

WeaponsTab:CreateButton({
    Name = "[TP to Gun]",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Find dropped gun in workspace
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Tool") and (obj.Name == "Gun" or obj:FindFirstChild("Gun")) and obj:FindFirstChild("Handle") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                    if handle then
                        -- Teleport to gun
                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(handle.Position)
                        Rayfield:Notify({
                            Title = "Teleport",
                            Content = "Teleported to gun!",
                            Duration = 2
                        })
                        return
                    end
                end
            end
        end
    end,
})

WeaponsTab:CreateButton({
    Name = "[Murderer Kill All]",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Knife") then
            local knife = localPlayer.Character.Knife
            local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            -- Kill all players except self
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    spawn(function()
                        -- Teleport to player and stab
                        local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetHrp then
                            hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2)
                            wait(0.1)
                            knife:Activate()
                            wait(0.1)
                        end
                    end)
                end
            end
            
            Rayfield:Notify({
                Title = "Kill All",
                Content = "Killing all players!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Kill All",
                Content = "You must be murderer!",
                Duration = 3
            })
        end
    end,
})

-- Sheriff Powers Section
WeaponsTab:CreateLabel("=== SHERIFF POWERS ===")

WeaponsTab:CreateButton({
    Name = "[Kill Murderer as Sheriff]",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        local murderer = nil
        
        -- Find murderer
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local knife = player.Character:FindFirstChild("Knife") or (player.Backpack and player.Backpack:FindFirstChild("Knife"))
                if knife then
                    murderer = player
                    break
                end
            end
        end
        
        if murderer and murderer.Character and localPlayer.Character and localPlayer.Character:FindFirstChild("Gun") then
            local gun = localPlayer.Character.Gun
            local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            -- Kill murderer with multiple shots
            spawn(function()
                for i = 1, 5 do
                    if murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = murderer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        wait(0.1)
                        gun:Activate()
                        wait(0.2)
                    end
                end
            end)
            
            Rayfield:Notify({
                Title = "Sheriff Kill",
                Content = "Killing murderer!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Sheriff Kill",
                Content = "Murderer not found or you're not sheriff!",
                Duration = 3
            })
        end
    end,
})

WeaponsTab:CreateButton({
    Name = "[Sheriff Auto Aim With Keybind (E)]",
    Callback = function()
        getgenv().SheriffAutoAimEnabled = not getgenv().SheriffAutoAimEnabled
        Rayfield:Notify({
            Title = "Sheriff Auto Aim",
            Content = getgenv().SheriffAutoAimEnabled and "Enabled" or "Disabled",
            Duration = 2
        })
    end,
})

WeaponsTab:CreateButton({
    Name = "[Sheriff Shoot]",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Gun") then
            local gun = localPlayer.Character.Gun
            local murderer = nil
            
            -- Find murderer
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local knife = player.Character:FindFirstChild("Knife") or (player.Backpack and player.Backpack:FindFirstChild("Knife"))
                    if knife then
                        murderer = player
                        break
                    end
                end
            end
            
            if murderer and murderer.Character then
                local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetHrp = murderer.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetHrp then
                    -- Teleport and shoot
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 5)
                    wait(0.1)
                    gun:Activate()
                    
                    Rayfield:Notify({
                        Title = "Sheriff Shoot",
                        Content = "Shot at murderer!",
                        Duration = 2
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "Sheriff Shoot",
                Content = "You need a gun!",
                Duration = 2
            })
        end
    end,
})

-- Sheriff Auto Aim Function
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E and getgenv().SheriffAutoAimEnabled then
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Gun") then
            local murderer = nil
            
            -- Find murderer
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local knife = player.Character:FindFirstChild("Knife") or (player.Backpack and player.Backpack:FindFirstChild("Knife"))
                    if knife then
                        murderer = player
                        break
                    end
                end
            end
            
            if murderer and murderer.Character then
                local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetHrp = murderer.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetHrp then
                    -- Auto aim at murderer
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
                    localPlayer.Character.Gun:Activate()
                end
            end
        end
    end
end)

-- Silent Aimbot Function
game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().SilentAimbotEnabled then
        local localPlayer = game.Players.LocalPlayer
        local mouse = localPlayer:GetMouse()
        local camera = workspace.CurrentCamera
        
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local vector, onScreen = camera:WorldToScreenPoint(head.Position)
                
                if onScreen then
                    local distance = (Vector2.new(vector.X, vector.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    local fovRadius = (getgenv().SilentAimbotFOV or 90) * (camera.ViewportSize.Y / 2) / 90
                    
                    if distance <= fovRadius then
                        -- Silent aim - modify mouse hit without moving camera
                        local originalTarget = mouse.Target
                        local originalHit = mouse.Hit
                        
                        -- Override mouse target to player head
                        mouse.Target = head
                        mouse.Hit = head.CFrame
                        
                        wait()
                        
                        -- Restore original
                        mouse.Target = originalTarget
                        mouse.Hit = originalHit
                    end
                end
            end
        end
    end
end)

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
