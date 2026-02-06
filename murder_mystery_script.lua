-- Made by Jassy ❤
-- Property of ScriptForge

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
    Name = "MM2 Script",
    LoadingTitle = "MM2 Script",
    LoadingSubtitle = "❤ Made by Jassy ❤",
    ConfigurationSaving = {
        Enabled = false,
    },
    BackgroundImage = "https://i.imgur.com/f6P9Vci.jpeg"
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)

-- Role ESP Toggle
ESPTab:CreateToggle({
    Name = "[Role ESP]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().RoleESPEnabled = value
    end,
})

-- Name ESP Toggle
ESPTab:CreateToggle({
    Name = "[Name ESP]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().NameESPEnabled = value
    end,
})

-- Distance ESP Toggle
ESPTab:CreateToggle({
    Name = "[Distance ESP]",
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
    Name = "[Aimbot]",
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
    Name = "[Target Murderers Only]",
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

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Credits/Discord Tab
local CreditsDiscordTab = Window:CreateTab("Credits/Discord", 4483362458)

-- Jassy Section ❤
CreditsDiscordTab:CreateLabel("=== ❤ JASSY ❤ ===")

CreditsDiscordTab:CreateButton({
    Name = "Copy Discord invite to clipboard",
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
    Name = "[GUI KEYBIND: K]",
    Callback = function()
        Rayfield:Notify({
            Title = "Keybind",
            Content = "GUI Keybind is K",
            Duration = 5
        })
    end,
})

-- Credits
CreditsDiscordTab:CreateLabel("❤ Script made by: Jassy")
CreditsDiscordTab:CreateLabel("Version: 1.0")
CreditsDiscordTab:CreateLabel("Property Of ScriptForge")

-- Uninject Button
CreditsDiscordTab:CreateButton({
    Name = "[Uninject Script]",
    Callback = function()
        -- Stop all features
        getgenv().RoleESPEnabled = false
        getgenv().NameESPEnabled = false
        getgenv().DistanceESPEnabled = false
        getgenv().AimbotEnabled = false
        getgenv().NoClipEnabled = false
        getgenv().FlyEnabled = false
        getgenv().AutoRespawnEnabled = false
        getgenv().AntiAFKEnabled = false
        getgenv().AntiKnockbackEnabled = false
        getgenv().AntiCheatBypass = false
        getgenv().FreeEmotesEnabled = false
        
        -- Stop animation system
        if animationAPI then
            animationAPI.reanimate(false)
        end
        
        -- Clean up ESP
        pcall(function()
            if workspace:FindFirstChild("MM2_RoleESP_Highlights") then
                workspace:FindFirstChild("MM2_RoleESP_Highlights"):Destroy()
            end
            if workspace:FindFirstChild("MM2_NameESP") then
                workspace:FindFirstChild("MM2_NameESP"):Destroy()
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

-- Speed Boost
MiscTab:CreateSlider({
    Name = "[Speed Boost]",
    Range = {16, 200},
    Increment = 4,
    CurrentValue = 16,
    Callback = function(value)
        getgenv().WalkSpeed = value
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
            end
        end)
    end,
})

-- Jump Power
MiscTab:CreateSlider({
    Name = "[Jump Power]",
    Range = {50, 200},
    Increment = 10,
    CurrentValue = 50,
    Callback = function(value)
        getgenv().JumpPower = value
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").JumpPower = value
            end
        end)
    end,
})

-- Infinite Jump
MiscTab:CreateToggle({
    Name = "[Infinite Jump]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().InfiniteJump = value
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

-- Character Section
MiscTab:CreateLabel("=== CHARACTER ===")

-- Animation System
local animationAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animation_module.lua"))()

-- Free Emotes Toggle
MiscTab:CreateToggle({
    Name = "[Free Emotes]",
    CurrentValue = false,
    Callback = function(value)
        getgenv().FreeEmotesEnabled = value
        if value then
            if animationAPI then
                animationAPI.reanimate(true)
            end
        else
            if animationAPI then
                animationAPI.reanimate(false)
            end
        end
    end,
})

-- Emote Wheel Button
MiscTab:CreateButton({
    Name = "[Open Emote Wheel]",
    Callback = function()
        if not getgenv().FreeEmotesEnabled or not animationAPI then
            Rayfield:Notify({
                Title = "Error",
                Content = "Enable Free Emotes first!",
                Duration = 3
            })
            return
        end
        
        -- Create emote wheel GUI
        local emoteGui = Instance.new("ScreenGui")
        emoteGui.Name = "EmoteWheel"
        emoteGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 300)
        frame.Position = UDim2.new(0.5, -150, 0.5, -150)
        frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.new(0, 1, 0)
        frame.BackgroundTransparency = 0.2
        frame.Parent = emoteGui
        
        -- Emote buttons
        local emotes = {
            {name = "Dance", url = "https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animations/dance.lua"},
            {name = "Wave", url = "https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animations/wave.lua"},
            {name = "Laugh", url = "https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animations/laugh.lua"},
            {name = "Cheer", url = "https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animations/cheer.lua"},
            {name = "Point", url = "https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animations/point.lua"},
            {name = "Sit", url = "https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animations/sit.lua"},
            {name = "Sleep", url = "https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animations/sleep.lua"},
            {name = "Flip", url = "https://raw.githubusercontent.com/jassy-src/murder-mystery/main/animations/flip.lua"}
        }
        
        for i, emote in ipairs(emotes) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 80, 0, 30)
            btn.Position = UDim2.new(0, (i-1)%3 * 100 + 10, 0, math.floor((i-1)/3) * 40 + 10)
            btn.Text = emote.name
            btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Parent = frame
            
            btn.MouseButton1Click:Connect(function()
                if animationAPI and animationAPI.is_reanimated() then
                    animationAPI.play_animation(emote.url, 1.0)
                    Rayfield:Notify({
                        Title = "Emote Played",
                        Content = "Playing: " .. emote.name,
                        Duration = 2
                    })
                end
            end)
        end
        
        -- Close button
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 60, 0, 25)
        closeBtn.Position = UDim2.new(1, -70, 0, 5)
        closeBtn.Text = "Close"
        closeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.Parent = frame
        
        closeBtn.MouseButton1Click:Connect(function()
            emoteGui:Destroy()
        end)
        
        -- Auto close after 10 seconds
        game:GetService("Debris"):AddItem(emoteGui, 10)
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

-- Jassy Section ❤
CreditsDiscordTab:CreateLabel("=== ❤ JASSY ❤ ===")

CreditsDiscordTab:CreateButton({
    Name = "Copy Discord invite to clipboard",
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
    Name = "[GUI KEYBIND: K]",
    Callback = function()
        Rayfield:Notify({
            Title = "Keybind",
            Content = "GUI Keybind is K",
            Duration = 5
        })
    end,
})

-- Credits
CreditsDiscordTab:CreateLabel("❤ Script made by: Jassy")
CreditsDiscordTab:CreateLabel("Version: 1.0")
CreditsDiscordTab:CreateLabel("Property Of ScriptForge")

-- Uninject Button
CreditsDiscordTab:CreateButton({
    Name = "[Uninject Script]",
    Callback = function()
        -- Stop all features
        getgenv().RoleESPEnabled = false
        getgenv().NameESPEnabled = false
        getgenv().DistanceESPEnabled = false
        getgenv().AimbotEnabled = false
        getgenv().NoClipEnabled = false
        getgenv().FlyEnabled = false
        getgenv().AutoRespawnEnabled = false
        getgenv().AntiAFKEnabled = false
        getgenv().AntiKnockbackEnabled = false
        getgenv().AntiCheatBypass = false
        getgenv().FreeEmotesEnabled = false
        
        -- Stop animation system
        if animationAPI then
            animationAPI.reanimate(false)
        end
        
        -- Clean up ESP
        pcall(function()
            if workspace:FindFirstChild("MM2_RoleESP_Highlights") then
                workspace:FindFirstChild("MM2_RoleESP_Highlights"):Destroy()
            end
            if workspace:FindFirstChild("MM2_NameESP") then
                workspace:FindFirstChild("MM2_NameESP"):Destroy()
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
    Title = "❤ Jassy's MM2 Script",
    Content = "Script loaded successfully!",
    Duration = 5
})

print("❤ Jassy's MM2 Script loaded - Rayfield status: " .. (Rayfield and "Working" or "Error"))
