-- Made by Jassy ❤
-- Property of ScriptForge ❤
-- Upgraded v2.0 with xScript Integration

-- Cache Services (avoid repeated GetService calls)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = nil
pcall(function() VirtualUser = game:GetService("VirtualUser") end)
local LocalPlayer = Players.LocalPlayer

-- Load xScript Library
local xScript = nil
pcall(function()
    xScript = loadstring(game:HttpGet("https://scriptblox.com/raw/xScript"))()
end)
local useXScript = (xScript ~= nil)
if useXScript then
    print("[xScript loaded successfully]")
else
    warn("[xScript failed to load - using fallback methods]")
end

-- Helper Functions (reduce code duplication)
local function getLocalCharacter()
    if useXScript then return xScript.GetLocalCharacter() end
    return LocalPlayer.Character
end

local function getHRP()
    local char = getLocalCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getLocalCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function findMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local backpack = player:FindFirstChild("Backpack")
            if char then
                local knife = char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
                if knife then return player end
            end
        end
    end
    return nil
end

local function findSheriff()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local backpack = player:FindFirstChild("Backpack")
            if char then
                local gun = char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))
                if gun then return player end
            end
        end
    end
    return nil
end

local function getPlayerRole(player)
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if not char then return "Unknown" end
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then return "Murderer" end
    if char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

local function safeTP(position)
    if useXScript then
        xScript.SetLocalPlayerPosition(position)
    else
        local hrp = getHRP()
        if hrp then hrp.CFrame = CFrame.new(position) end
    end
end

local function safeTeleportTo(targetCFrame)
    local hrp = getHRP()
    if hrp then hrp.CFrame = targetCFrame end
end

local function findDroppedGun()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and (obj.Name == "Gun" or obj.Name == "Sheriff Gun" or obj:FindFirstChild("Gun")) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then return obj, handle end
        end
    end
    return nil, nil
end

-- Anti-Cheat Bypass
local function bypassAntiCheat()
    local char = getLocalCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        -- Bypass teleport detection with smooth position tracking
        local lastValidPos = hrp.Position
        RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            local delta = (hrp.Position - lastValidPos).Magnitude
            if delta > 0 and delta < 200 then
                lastValidPos = hrp.Position
            end
        end)
    end
    
    -- Bypass speed detection (clamp reported speed)
    RunService.Stepped:Connect(function()
        if not getgenv().AntiCheatBypass then return end
        local humanoid = getHumanoid()
        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
            -- Only clamp if not using speed bypass
            if not getgenv().SpeedBoostEnabled then
                humanoid.WalkSpeed = math.min(humanoid.WalkSpeed, 50)
            end
        end
    end)
end

-- Test Rayfield UI Library
local Rayfield = nil
local rayfieldSuccess, rayfieldError = pcall(function()
    Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not rayfieldSuccess then
    warn("[Rayfield load error: " .. tostring(rayfieldError) .. "]")
end
print(Rayfield and "[Rayfield loaded]" or "[Rayfield failed to load]")

if not Rayfield then
    LocalPlayer:Kick("[Rayfield UI library failed. Error: " .. tostring(rayfieldError) .. "]")
    return
end

-- Activate anti-cheat bypass
getgenv().AntiCheatBypass = true
bypassAntiCheat()

local Window = Rayfield:CreateWindow({
    Name = "MM2 Script",
    LoadingTitle = "MM2 Script",
    LoadingSubtitle = "Made by Jassy",
    KeySystem = false,
    ConfigurationSaving = {
        Enabled = false,
        FileName = "MM2ScriptConfig"
    }
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
ESPFolder.Parent = game:GetService("CoreGui")

-- Name ESP Folder
local NameESPFolder = Instance.new("Folder")
NameESPFolder.Name = "MM2_NameESP"
NameESPFolder.Parent = game:GetService("CoreGui")

-- Gun ESP Folder
local GunESPFolder = Instance.new("Folder")
GunESPFolder.Name = "MM2_GunESP"
GunESPFolder.Parent = game:GetService("CoreGui")

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
                    
                    -- Use helper to determine role
                    local role = getPlayerRole(player)
                    if role == "Murderer" then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        nameLabel.Text = player.Name .. " [M]"
                    elseif role == "Sheriff" then
                        highlight.FillColor = Color3.fromRGB(0, 0, 255)
                        nameLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
                        nameLabel.Text = player.Name .. " [S]"
                    else
                        highlight.FillColor = Color3.fromRGB(0, 255, 0)
                        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        nameLabel.Text = player.Name
                    end
                    
                    -- Calculate distance using cached refs
                    local myHRP = getHRP()
                    if myHRP then
                        local distance = (char:FindFirstChild("HumanoidRootPart").Position - myHRP.Position).Magnitude
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
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        TrackPlayer(player)
    end
end

-- Track new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        TrackPlayer(player)
    end
end)

-- Clean up when players leave
Players.PlayerRemoving:Connect(function(player)
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
                    
                    -- Calculate distance using cached refs
                    local myHRP = getHRP()
                    if myHRP then
                        local distance = (handle.Position - myHRP.Position).Magnitude
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
    CurrentValue = false,
    Callback = function(value)
        getgenv().TargetMurderersOnly = value
    end,
})

-- Aimbot Keybind (Q key)
getgenv().AimbotEnabled = false -- Initialize aimbot state
getgenv().AimbotSmoothness = 5 -- Initialize smoothness
getgenv().TargetMurderersOnly = false -- Target all players by default (toggle in UI)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
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
local function getClosestPlayer()
    -- Use xScript if available for optimized nearest player search
    if useXScript and not getgenv().TargetMurderersOnly then
        return xScript.GetNearestPlayer(600)
    end
    
    local cam = workspace.CurrentCamera
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- Use helper to check role (skip if targeting murderers only)
                local validTarget = true
                if getgenv().TargetMurderersOnly then
                    if getPlayerRole(player) ~= "Murderer" then
                        validTarget = false
                    end
                end
                
                if validTarget then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local distance = (head.Position - cam.CFrame.Position).Magnitude
                        if distance < closestDistance and distance < 600 then
                            -- Raycast wall check (optional, skip if it errors)
                            local blocked = false
                            pcall(function()
                                local rayParams = RaycastParams.new()
                                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                rayParams.FilterDescendantsInstances = {getLocalCharacter(), char}
                                local ray = workspace:Raycast(cam.CFrame.Position, (head.Position - cam.CFrame.Position), rayParams)
                                if ray then blocked = true end
                            end)
                            
                            if not blocked then
                                closestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if getgenv().AimbotEnabled then
        pcall(function()
            local cam = workspace.CurrentCamera
            local closestPlayer = getClosestPlayer()
            if closestPlayer then
                local char = closestPlayer.Character
                if char and char:FindFirstChild("Head") then
                    local targetPos = char.Head.Position
                    local smoothness = getgenv().AimbotSmoothness or 5
                    
                    -- Smoothness controls how fast aim snaps (1 = instant, 10 = slow)
                    local lerpAlpha = math.clamp(1 / smoothness, 0.1, 1)
                    
                    if smoothness <= 2 then
                        -- Instant snap
                        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetPos)
                    else
                        local lookAt = CFrame.lookAt(cam.CFrame.Position, targetPos)
                        cam.CFrame = cam.CFrame:Lerp(lookAt, lerpAlpha)
                    end
                end
            end
        end)
    end
end)

-- Teleport Tab 🌀
local TeleportTab = Window:CreateTab("🌀 Teleport", 4483362458)

local function getPlayerList()
    -- Use xScript.PlayerList if available
    if useXScript then
        local names = xScript.PlayerList()
        local filtered = {}
        for _, name in ipairs(names) do
            if name ~= LocalPlayer.Name then table.insert(filtered, name) end
        end
        return filtered
    end
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then table.insert(players, player.Name) end
    end
    return players
end

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "To player: ",
    Options = getPlayerList(),
    CurrentOption = {""},
    Callback = function(Option)
        local target = Players:FindFirstChild(Option[1])
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            safeTeleportTo(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
            Rayfield:Notify({ Title = "Teleport", Content = "Teleported to " .. target.Name, Duration = 2 })
        end
    end,
})

-- Auto-update list
local function updateDropdown() PlayerDropdown:Refresh(getPlayerList(), true) end
Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)

TeleportTab:CreateButton({
    Name = "🔫 Teleport to Sheriff",
    Callback = function()
        local sheriff = findSheriff()
        if sheriff and sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart") then
            safeTeleportTo(sheriff.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
            Rayfield:Notify({ Title = "Teleport", Content = "Teleported to Sheriff: " .. sheriff.Name, Duration = 2 })
        else
            Rayfield:Notify({ Title = "Teleport", Content = "Sheriff not found!", Duration = 2 })
        end
    end,
})

TeleportTab:CreateButton({
    Name = "🔪 Teleport to Murderer",
    Callback = function()
        local murderer = findMurderer()
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            safeTeleportTo(murderer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
            Rayfield:Notify({ Title = "Teleport", Content = "Teleported to Murderer: " .. murderer.Name, Duration = 2 })
        else
            Rayfield:Notify({ Title = "Teleport", Content = "Murderer not found!", Duration = 2 })
        end
    end,
})

TeleportTab:CreateButton({
    Name = "🎯 Teleport to Nearest Player",
    Callback = function()
        if useXScript then
            local success = xScript.TeleportToNearestPlayer()
            if success then
                Rayfield:Notify({ Title = "Teleport", Content = "Teleported to nearest player!", Duration = 2 })
            else
                Rayfield:Notify({ Title = "Teleport", Content = "No players nearby!", Duration = 2 })
            end
        else
            local closest, closestDist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local myHRP = getHRP()
                    if myHRP then
                        local dist = (p.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                        if dist < closestDist then closestDist = dist; closest = p end
                    end
                end
            end
            if closest then
                safeTeleportTo(closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                Rayfield:Notify({ Title = "Teleport", Content = "Teleported to " .. closest.Name, Duration = 2 })
            end
        end
    end,
})

TeleportTab:CreateButton({
    Name = "🔫 Teleport to Dropped Gun",
    Callback = function()
        local gunObj, handle = findDroppedGun()
        if handle then
            safeTP(handle.Position)
            Rayfield:Notify({ Title = "Teleport", Content = "Teleported to dropped gun!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Teleport", Content = "No dropped gun found!", Duration = 2 })
        end
    end,
})

-- Weapons Tab 
local WeaponsTab = Window:CreateTab("Weapons", 4483362458)

-- Murderer Powers Section
WeaponsTab:CreateLabel("=== MURDERER POWERS ===")

WeaponsTab:CreateButton({
    Name = "[TP to Gun]",
    Callback = function()
        local gunObj, handle = findDroppedGun()
        if handle then
            safeTP(handle.Position)
            Rayfield:Notify({ Title = "Teleport", Content = "Teleported to gun!", Duration = 2 })
        else
            Rayfield:Notify({ Title = "Teleport", Content = "No dropped gun found!", Duration = 2 })
        end
    end,
})

WeaponsTab:CreateButton({
    Name = "[Murderer Kill All]",
    Callback = function()
        local char = getLocalCharacter()
        if char and char:FindFirstChild("Knife") then
            local knife = char.Knife
            local hrp = getHRP()
            if not hrp then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    spawn(function()
                        local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetHrp then
                            hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 2)
                            task.wait(0.1)
                            knife:Activate()
                            task.wait(0.1)
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
        local murderer = findMurderer()
        local char = getLocalCharacter()
        
        if murderer and murderer.Character and char and char:FindFirstChild("Gun") then
            local gun = char.Gun
            local hrp = getHRP()
            if not hrp then return end
            
            spawn(function()
                for i = 1, 5 do
                    if murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                        hrp.CFrame = murderer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        task.wait(0.1)
                        gun:Activate()
                        task.wait(0.2)
                    end
                end
            end)
            
            Rayfield:Notify({ Title = "Sheriff Kill", Content = "Killing murderer!", Duration = 3 })
        else
            Rayfield:Notify({ Title = "Sheriff Kill", Content = "Murderer not found or you're not sheriff!", Duration = 3 })
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
        local char = getLocalCharacter()
        if char and char:FindFirstChild("Gun") then
            local gun = char.Gun
            local murderer = findMurderer()
            
            if murderer and murderer.Character then
                local hrp = getHRP()
                local targetHrp = murderer.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetHrp then
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 5)
                    task.wait(0.1)
                    gun:Activate()
                    Rayfield:Notify({ Title = "Sheriff Shoot", Content = "Shot at murderer!", Duration = 2 })
                end
            end
        else
            Rayfield:Notify({ Title = "Sheriff Shoot", Content = "You need a gun!", Duration = 2 })
        end
    end,
})

-- Sheriff Auto Aim Function
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.E and getgenv().SheriffAutoAimEnabled then
        local char = getLocalCharacter()
        if char and char:FindFirstChild("Gun") then
            local murderer = findMurderer()
            
            if murderer and murderer.Character then
                local hrp = getHRP()
                local targetHrp = murderer.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetHrp then
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
                    char.Gun:Activate()
                end
            end
        end
    end
end)

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
        local hrp = getHRP()
        if hrp then
            if useXScript then
                xScript.FreezeLocalCharacter(true)
                Rayfield:Notify({ Title = "Position Lock", Content = "Character frozen via xScript", Duration = 2 })
            else
                getgenv().LockedPosition = hrp.Position
                coroutine.wrap(function()
                    while getgenv().AntiCheatBypass and hrp and hrp.Parent do
                        pcall(function()
                            hrp.Position = getgenv().LockedPosition
                        end)
                        task.wait(0.1)
                    end
                end)()
            end
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
            getgenv().NoClipConnection = RunService.Stepped:Connect(function()
                pcall(function()
                    local char = getLocalCharacter()
                    if char then
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end)
        else
            if getgenv().NoClipConnection then
                getgenv().NoClipConnection:Disconnect()
                getgenv().NoClipConnection = nil
            end
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
            local char = getLocalCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
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
                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                moveDirection = moveDirection + cam.CFrame.LookVector
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                moveDirection = moveDirection - cam.CFrame.LookVector
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                moveDirection = moveDirection - cam.CFrame.RightVector
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                moveDirection = moveDirection + cam.CFrame.RightVector
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                                moveDirection = moveDirection + Vector3.new(0, 1, 0)
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
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
            getgenv().SpeedBoostValue = getgenv().SpeedBoostValue or 50
            if useXScript then
                xScript.SetWalkspeed(getgenv().SpeedBoostValue, true)
            else
                coroutine.wrap(function()
                    while getgenv().SpeedBoostEnabled do
                        pcall(function()
                            local humanoid = getHumanoid()
                            if humanoid then
                                humanoid.WalkSpeed = getgenv().SpeedBoostValue or 50
                            end
                        end)
                        task.wait(0.1)
                    end
                end)()
            end
        else
            if useXScript then
                xScript.SetWalkspeed(16, false)
            else
                pcall(function()
                    local humanoid = getHumanoid()
                    if humanoid then humanoid.WalkSpeed = 16 end
                end)
            end
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
            if useXScript then
                xScript.SetWalkspeed(value, true)
            else
                pcall(function()
                    local humanoid = getHumanoid()
                    if humanoid then humanoid.WalkSpeed = value end
                end)
            end
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
            getgenv().JumpPowerValue = getgenv().JumpPowerValue or 100
            if useXScript then
                xScript.SetJumpPower(getgenv().JumpPowerValue, true)
            else
                coroutine.wrap(function()
                    while getgenv().JumpPowerEnabled do
                        pcall(function()
                            local humanoid = getHumanoid()
                            if humanoid then
                                humanoid.JumpPower = getgenv().JumpPowerValue or 100
                            end
                        end)
                        task.wait(0.1)
                    end
                end)()
            end
        else
            if useXScript then
                xScript.SetJumpPower(50, false)
            else
                pcall(function()
                    local humanoid = getHumanoid()
                    if humanoid then humanoid.JumpPower = 50 end
                end)
            end
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
            if useXScript then
                xScript.SetJumpPower(value, true)
            else
                pcall(function()
                    local humanoid = getHumanoid()
                    if humanoid then humanoid.JumpPower = value end
                end)
            end
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
            if useXScript then
                xScript.InfiniteJump(true)
            else
                getgenv().InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                    local humanoid = getHumanoid()
                    if humanoid then
                        humanoid.Jump = true
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                
                getgenv().InfiniteJumpHeartbeat = RunService.Heartbeat:Connect(function()
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        local humanoid = getHumanoid()
                        if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            humanoid.Jump = true
                        end
                    end
                end)
            end
        else
            if useXScript then
                xScript.InfiniteJump(false)
            else
                if getgenv().InfiniteJumpConnection then
                    getgenv().InfiniteJumpConnection:Disconnect()
                    getgenv().InfiniteJumpConnection = nil
                end
                if getgenv().InfiniteJumpHeartbeat then
                    getgenv().InfiniteJumpHeartbeat:Disconnect()
                    getgenv().InfiniteJumpHeartbeat = nil
                end
            end
        end
    end,
})

-- Hitbox Expander (proximity-based damage system)
MiscTab:CreateToggle({
    Name = "[Hitbox Expander]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().HitboxExpanderEnabled = value
        getgenv().HitboxSize = getgenv().HitboxSize or 10
        if value then
            -- Create hitbox parts and damage detection
            coroutine.wrap(function()
                while getgenv().HitboxExpanderEnabled do
                    pcall(function()
                        -- Create/update hitbox parts
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local head = player.Character:FindFirstChild("Head")
                                if head and head:IsA("BasePart") then
                                    local size = getgenv().HitboxSize or 10
                                    local existing = head:FindFirstChild("HitboxPart")
                                    if not existing then
                                        -- Create hitbox part
                                        local hitbox = Instance.new("Part")
                                        hitbox.Name = "HitboxPart"
                                        hitbox.Size = Vector3.new(size, size, size)
                                        hitbox.Transparency = 0.3
                                        hitbox.BrickColor = BrickColor.new("Really red")
                                        hitbox.Material = Enum.Material.ForceField
                                        hitbox.CanCollide = false
                                        hitbox.Anchored = false
                                        hitbox.Massless = true
                                        hitbox.Parent = head
                                        
                                        -- Weld to head
                                        local weld = Instance.new("Weld")
                                        weld.Part0 = head
                                        weld.Part1 = hitbox
                                        weld.C0 = CFrame.new(0, 0, 0)
                                        weld.Parent = hitbox
                                    else
                                        existing.Size = Vector3.new(size, size, size)
                                    end
                                end
                            end
                        end
                        
                        -- Check for nearby players with tools and apply damage
                        local myChar = getLocalCharacter()
                        if myChar then
                            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                            if myHRP then
                                for _, player in ipairs(Players:GetPlayers()) do
                                    if player ~= LocalPlayer and player.Character then
                                        local targetHead = player.Character:FindFirstChild("Head")
                                        local targetHitbox = targetHead and targetHead:FindFirstChild("HitboxPart")
                                        local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                        
                                        if targetHitbox and targetHumanoid and targetHumanoid.Health > 0 then
                                            local distance = (myHRP.Position - targetHitbox.Position).Magnitude
                                            
                                            -- Check if player is within hitbox range
                                            if distance <= getgenv().HitboxSize then
                                                -- Check if local player has a tool equipped
                                                local equippedTool = myChar:FindFirstChildWhichIsA("Tool")
                                                if equippedTool then
                                                    -- Apply damage with a small delay to prevent spam
                                                    if not targetHitbox:GetAttribute("LastDamageTime") or 
                                                       tick() - targetHitbox:GetAttribute("LastDamageTime") > 0.5 then
                                                        targetHitbox:SetAttribute("LastDamageTime", tick())
                                                        targetHumanoid:TakeDamage(100) -- Instant kill
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1) -- Check frequently for responsiveness
                end
            end)()
        else
            -- Remove hitboxes when disabled
            pcall(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local head = player.Character:FindFirstChild("Head")
                        if head then
                            local hitbox = head:FindFirstChild("HitboxPart")
                            if hitbox then hitbox:Destroy() end
                        end
                    end
                end
            end)
        end
    end,
})

-- Hitbox Size Slider
MiscTab:CreateSlider({
    Name = "[Hitbox Size]",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        getgenv().HitboxSize = value
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
            getgenv().ShaderLighting = Lighting
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
            getgenv().ShaderHeartbeat = RunService.Heartbeat:Connect(function()
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
            if useXScript then
                xScript.ToggleFog(false)
            else
                getgenv().OriginalFogEnd = Lighting.FogEnd
                Lighting.FogEnd = 100000
            end
        else
            if useXScript then
                xScript.ToggleFog(true)
            else
                if getgenv().OriginalFogEnd then
                    Lighting.FogEnd = getgenv().OriginalFogEnd
                end
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
                        local humanoid = getHumanoid()
                        if humanoid and humanoid.Health <= 0 then
                            LocalPlayer:LoadCharacter()
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
            getgenv().AntiAFKConnection = LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
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
                        local hrp = getHRP()
                        if hrp then
                            hrp.Velocity = Vector3.new(0, 0, 0)
                        end
                    end)
                    task.wait(0.1)
                end
            end)()
        end
    end,
})

-- === EXTRA TOOLS (from IY) ===
MiscTab:CreateLabel("=== EXTRA TOOLS ===")

-- Reach (extends knife/gun tool handle for long-range hits)
getgenv().ReachEnabled = false
getgenv().OriginalToolSize = nil
getgenv().OriginalGripPos = nil

MiscTab:CreateToggle({
    Name = "[Reach]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().ReachEnabled = value
        local char = getLocalCharacter()
        if not char then return end
        if value then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("Tool") then
                    local handle = v:FindFirstChild("Handle")
                    if handle then
                        getgenv().OriginalToolSize = handle.Size
                        getgenv().OriginalGripPos = v.GripPos
                        handle.Massless = true
                        handle.Size = Vector3.new(0.5, 0.5, getgenv().ReachLength or 60)
                        v.GripPos = Vector3.new(0, 0, 0)
                        local sel = handle:FindFirstChild("ReachSelectionBox")
                        if not sel then
                            sel = Instance.new("SelectionBox")
                            sel.Name = "ReachSelectionBox"
                            sel.Parent = handle
                            sel.Adornee = handle
                        end
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:UnequipTools() end
                    end
                end
            end
            -- Also watch for tools being equipped while reach is on
            getgenv().ReachEquipConn = char.ChildAdded:Connect(function(child)
                if getgenv().ReachEnabled and child:IsA("Tool") then
                    task.wait(0.1)
                    local handle = child:FindFirstChild("Handle")
                    if handle then
                        getgenv().OriginalToolSize = getgenv().OriginalToolSize or handle.Size
                        getgenv().OriginalGripPos = getgenv().OriginalGripPos or child.GripPos
                        handle.Massless = true
                        handle.Size = Vector3.new(0.5, 0.5, getgenv().ReachLength or 60)
                        child.GripPos = Vector3.new(0, 0, 0)
                        local sel = handle:FindFirstChild("ReachSelectionBox")
                        if not sel then
                            sel = Instance.new("SelectionBox")
                            sel.Name = "ReachSelectionBox"
                            sel.Parent = handle
                            sel.Adornee = handle
                        end
                    end
                end
            end)
        else
            if getgenv().ReachEquipConn then
                pcall(function() getgenv().ReachEquipConn:Disconnect() end)
                getgenv().ReachEquipConn = nil
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("Tool") then
                    local handle = v:FindFirstChild("Handle")
                    if handle then
                        if getgenv().OriginalToolSize then handle.Size = getgenv().OriginalToolSize end
                        if getgenv().OriginalGripPos then v.GripPos = getgenv().OriginalGripPos end
                        local sel = handle:FindFirstChild("ReachSelectionBox")
                        if sel then sel:Destroy() end
                    end
                end
            end
            getgenv().OriginalToolSize = nil
            getgenv().OriginalGripPos = nil
        end
    end,
})

MiscTab:CreateSlider({
    Name = "[Reach Length]",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(value)
        getgenv().ReachLength = value
    end,
})

-- TPWalk (teleport-based movement, harder to detect than speed hacks)
getgenv().TPWalking = false

MiscTab:CreateToggle({
    Name = "[TP Walk]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().TPWalking = value
        if value then
            getgenv().TPWalkConn = RunService.Heartbeat:Connect(function(delta)
                if not getgenv().TPWalking then return end
                pcall(function()
                    local char = getLocalCharacter()
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.MoveDirection.Magnitude > 0 then
                        local speed = getgenv().TPWalkSpeed or 3
                        char:TranslateBy(hum.MoveDirection * speed * delta * 10)
                    end
                end)
            end)
        else
            if getgenv().TPWalkConn then
                pcall(function() getgenv().TPWalkConn:Disconnect() end)
                getgenv().TPWalkConn = nil
            end
        end
    end,
})

MiscTab:CreateSlider({
    Name = "[TP Walk Speed]",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 3,
    Callback = function(value)
        getgenv().TPWalkSpeed = value
    end,
})

-- Fullbright (see in dark MM2 maps)
MiscTab:CreateToggle({
    Name = "[Fullbright]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().FullbrightEnabled = value
        if value then
            getgenv().OrigFB_Brightness = Lighting.Brightness
            getgenv().OrigFB_Clock = Lighting.ClockTime
            getgenv().OrigFB_FogEnd = Lighting.FogEnd
            getgenv().OrigFB_GlobalShadows = Lighting.GlobalShadows
            getgenv().OrigFB_OutdoorAmbient = Lighting.OutdoorAmbient
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            -- Remove atmosphere effects that darken the map
            for _, v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then
                    v.Density = 0
                    v.Glare = 0
                    v.Haze = 0
                end
            end
        else
            if getgenv().OrigFB_Brightness then Lighting.Brightness = getgenv().OrigFB_Brightness end
            if getgenv().OrigFB_Clock then Lighting.ClockTime = getgenv().OrigFB_Clock end
            if getgenv().OrigFB_FogEnd then Lighting.FogEnd = getgenv().OrigFB_FogEnd end
            if getgenv().OrigFB_GlobalShadows ~= nil then Lighting.GlobalShadows = getgenv().OrigFB_GlobalShadows end
            if getgenv().OrigFB_OutdoorAmbient then Lighting.OutdoorAmbient = getgenv().OrigFB_OutdoorAmbient end
        end
    end,
})

-- Spin (spin your character - fun + defensive)
getgenv().Spinning = false

MiscTab:CreateToggle({
    Name = "[Spin]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().Spinning = value
        local hrp = getHRP()
        if not hrp then return end
        if value then
            -- Remove old spin
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "MM2Spin" then v:Destroy() end
            end
            local spin = Instance.new("BodyAngularVelocity")
            spin.Name = "MM2Spin"
            spin.Parent = hrp
            spin.MaxTorque = Vector3.new(0, math.huge, 0)
            spin.AngularVelocity = Vector3.new(0, getgenv().SpinSpeed or 20, 0)
        else
            for _, v in pairs(hrp:GetChildren()) do
                if v.Name == "MM2Spin" then v:Destroy() end
            end
        end
    end,
})

MiscTab:CreateSlider({
    Name = "[Spin Speed]",
    Range = {5, 200},
    Increment = 5,
    CurrentValue = 20,
    Callback = function(value)
        getgenv().SpinSpeed = value
        local hrp = getHRP()
        if hrp and getgenv().Spinning then
            local spin = hrp:FindFirstChild("MM2Spin")
            if spin then
                spin.AngularVelocity = Vector3.new(0, value, 0)
            end
        end
    end,
})

-- Auto Grab Gun Button
MiscTab:CreateButton({
    Name = "[Grab Gun (Innocent Only)]",
    Callback = function()
        -- Check if player is innocent (no knife or gun)
        local localChar = getLocalCharacter()
        if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Grab Gun",
                Content = "Character not found!",
                Duration = 3
            })
            return
        end
        
        local myRole = getPlayerRole(LocalPlayer)
        local hasKnife = (myRole == "Murderer")
        local hasGun = (myRole == "Sheriff")
        
        -- Only work if innocent (no knife and no gun)
        if hasKnife then
            Rayfield:Notify({
                Title = "Grab Gun",
                Content = "You are the murderer! Cannot grab gun.",
                Duration = 3
            })
            return
        end
        
        -- Find dropped gun using helper
        local gunObject, gunHandle = findDroppedGun()
        local gunPosition = gunHandle and gunHandle.Position
        
        -- Check if sheriff is dead
        local sheriffDead = false
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    local hadGun = (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
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
                            gunObject.Parent = LocalPlayer.Backpack
                        end
                        
                        task.wait(0.05)
                        
                        -- Check if gun is now in backpack or equipped
                        local backpackGun = LocalPlayer.Backpack:FindFirstChild("Gun")
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
                    local backpackGun = LocalPlayer.Backpack:FindFirstChild("Gun")
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
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
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
            
            getgenv().StatisticsOverlayConnection = RunService.Stepped:Connect(function()
                if getgenv().StatisticsOverlayEnabled and ScreenGui and ScreenGui.Parent then
                    -- Get actual FPS from Roblox
                    local fps = 0
                    pcall(function()
                        fps = math.floor(1 / RunService.RenderStepped:Wait())
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
            
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
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
        local murderer = findMurderer()
        local sheriff = findSheriff()
        local murdererName = murderer and murderer.Name or "Unknown"
        local sheriffName = sheriff and sheriff.Name or "Unknown"
        
        local leakMessage = murdererName .. " = murderer | " .. sheriffName .. " = sheriff"
        
        -- Send message to chat
        task.wait(0.1)
        
        local sent = false
        
        -- Method 1: TextChatService (modern Roblox chat)
        pcall(function()
            local TextChatService = game:GetService("TextChatService")
            local channels = TextChatService:FindFirstChild("TextChannels")
            if channels then
                local rbxGeneral = channels:FindFirstChild("RBXGeneral")
                if rbxGeneral then
                    rbxGeneral:SendAsync(leakMessage)
                    sent = true
                end
            end
        end)
        if sent then
            Rayfield:Notify({ Title = "Leak Roles", Content = "Sent to chat!", Duration = 2 })
            return
        end
        
        -- Method 2: Legacy Roblox chat (SayMessageRequest)
        pcall(function()
            local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatRemote and chatRemote:FindFirstChild("SayMessageRequest") then
                chatRemote.SayMessageRequest:FireServer(leakMessage, "All")
                sent = true
            end
        end)
        if sent then
            Rayfield:Notify({ Title = "Leak Roles", Content = "Sent to chat!", Duration = 2 })
            return
        end
        
        -- Method 3: Fallback - just notify with the info
        Rayfield:Notify({
            Title = "Roles Detected",
            Content = leakMessage,
            Duration = 8
        })
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
CreditsDiscordTab:CreateLabel("📈 Version: 2.0 (xScript)")
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
        getgenv().SilentAimbotEnabled = false
        
        -- Notify BEFORE destroying UI
        Rayfield:Notify({
            Title = "Script Uninjected",
            Content = "Script has been successfully uninjected!",
            Duration = 5
        })
        task.wait(0.5)
        
        -- Reset speed and jump to defaults
        pcall(function()
            if useXScript then
                xScript.SetWalkspeed(16, false)
                xScript.SetJumpPower(50, false)
                xScript.InfiniteJump(false)
                xScript.Fly(false)
            end
            local humanoid = getHumanoid()
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end)
        
        -- Disconnect all connections
        local connections = {
            "InfiniteJumpConnection", "InfiniteJumpHeartbeat",
            "NoClipConnection", "AntiAFKConnection",
            "ShaderHeartbeat", "StatisticsOverlayConnection",
            "TPWalkConn", "ReachEquipConn", "FlingNoclipConn", "FlingDiedConn"
        }
        for _, name in ipairs(connections) do
            if getgenv()[name] then
                pcall(function() getgenv()[name]:Disconnect() end)
                getgenv()[name] = nil
            end
        end
        
        -- Stop active toggles
        getgenv().TPWalking = false
        getgenv().ReachEnabled = false
        getgenv().Spinning = false
        getgenv().FlingActive = false
        getgenv().FullbrightEnabled = false
        
        -- Clean up fly body movers
        if getgenv().FlyBV then pcall(function() getgenv().FlyBV:Destroy() end); getgenv().FlyBV = nil end
        if getgenv().FlyBG then pcall(function() getgenv().FlyBG:Destroy() end); getgenv().FlyBG = nil end
        
        -- Clean up spin body mover
        pcall(function()
            local hrp = getHRP()
            if hrp then
                local spin = hrp:FindFirstChild("MM2Spin")
                if spin then spin:Destroy() end
            end
        end)
        
        -- Clean up fling body mover
        if getgenv().FlingBAV then pcall(function() getgenv().FlingBAV:Destroy() end); getgenv().FlingBAV = nil end
        
        -- Clean up reach on tools
        pcall(function()
            local char = getLocalCharacter()
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("Tool") then
                        local handle = v:FindFirstChild("Handle")
                        if handle then
                            local sel = handle:FindFirstChild("ReachSelectionBox")
                            if sel then sel:Destroy() end
                        end
                    end
                end
            end
        end)
        
        -- Restore fullbright lighting
        pcall(function()
            if getgenv().OrigFB_Brightness then Lighting.Brightness = getgenv().OrigFB_Brightness end
            if getgenv().OrigFB_Clock then Lighting.ClockTime = getgenv().OrigFB_Clock end
            if getgenv().OrigFB_FogEnd then Lighting.FogEnd = getgenv().OrigFB_FogEnd end
            if getgenv().OrigFB_GlobalShadows ~= nil then Lighting.GlobalShadows = getgenv().OrigFB_GlobalShadows end
            if getgenv().OrigFB_OutdoorAmbient then Lighting.OutdoorAmbient = getgenv().OrigFB_OutdoorAmbient end
        end)

                -- Reset character physics from fling
        pcall(function()
            local char = getLocalCharacter()
            if char then
                for _, child in pairs(char:GetDescendants()) do
                    if child:IsA("BasePart") then
                        child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                    end
                end
            end
        end)
        
        -- Clean up ESP (folders are in CoreGui, not workspace)
        pcall(function()
            local coreGui = game:GetService("CoreGui")
            if coreGui:FindFirstChild("MM2_RoleESP_Highlights") then
                coreGui:FindFirstChild("MM2_RoleESP_Highlights"):Destroy()
            end
            if coreGui:FindFirstChild("MM2_NameESP") then
                coreGui:FindFirstChild("MM2_NameESP"):Destroy()
            end
            if coreGui:FindFirstChild("MM2_GunESP") then
                coreGui:FindFirstChild("MM2_GunESP"):Destroy()
            end
        end)
        
        -- Clean up Statistics Overlay
        pcall(function()
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local overlay = playerGui:FindFirstChild("StatisticsOverlay")
                if overlay then overlay:Destroy() end
            end
        end)
        
        -- Clean up shader effects
        pcall(function()
            if getgenv().ShaderAtmosphere then getgenv().ShaderAtmosphere:Destroy() end
            if getgenv().ShaderBloom then getgenv().ShaderBloom:Destroy() end
            if getgenv().ShaderColorCorrection then getgenv().ShaderColorCorrection:Destroy() end
            if getgenv().ShaderSunRays then getgenv().ShaderSunRays:Destroy() end
            if getgenv().ShaderDepthOfField then getgenv().ShaderDepthOfField:Destroy() end
        end)
        
        -- Destroy UI last
        task.wait(0.5)
        if Rayfield then
            Rayfield:Destroy()
        end
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
