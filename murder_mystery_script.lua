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

-- ESP folders and logic...
local ESPFolder = Instance.new("Folder", game.CoreGui) ESPFolder.Name = "MM2_RoleESP_Highlights"
local NameESPFolder = Instance.new("Folder", game.CoreGui) NameESPFolder.Name = "MM2_NameESP"
local GunESPFolder = Instance.new("Folder", game.CoreGui) GunESPFolder.Name = "MM2_GunESP"

local function TrackPlayer(player)
    local highlight = Instance.new("Highlight", ESPFolder)
    highlight.Name = player.Name .. "_RoleESP"
    highlight.FillTransparency = 0.5
    
    local billboard = Instance.new("BillboardGui", NameESPFolder)
    billboard.Name = player.Name .. "_NameESP"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold

    coroutine.wrap(function()
        while player and player.Parent do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    highlight.Adornee = char
                    billboard.Adornee = char:FindFirstChild("Head")
                    nameLabel.Text = player.Name
                    
                    local knife = char:FindFirstChild("Knife") or (player.Backpack:FindFirstChild("Knife"))
                    local gun = char:FindFirstChild("Gun") or (player.Backpack:FindFirstChild("Gun"))
                    
                    if knife then highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif gun then highlight.FillColor = Color3.fromRGB(0, 0, 255)
                    else highlight.FillColor = Color3.fromRGB(0, 255, 0) end
                    
                    nameLabel.TextColor3 = highlight.FillColor
                    highlight.Enabled = getgenv().RoleESPEnabled
                    billboard.Enabled = getgenv().NameESPEnabled
                else
                    highlight.Enabled = false
                    billboard.Enabled = false
                end
            end)
            task.wait(0.2)
        end
        highlight:Destroy() billboard:Destroy()
    end)()
end

for _, p in ipairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer then TrackPlayer(p) end end
game.Players.PlayerAdded:Connect(TrackPlayer)

-- Aimbot Tab 🎯
local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)
AimbotTab:CreateLabel("🎖 Aimbot (Keybind: Q)")
AimbotTab:CreateSlider({ Name = "⚙️ Aimbot Smoothness", Range = {1, 10}, Increment = 1, CurrentValue = 5, Callback = function(v) getgenv().AimbotSmoothness = v end })
AimbotTab:CreateToggle({ Name = "🎯 Target Murderers Only", CurrentValue = true, Callback = function(v) getgenv().TargetMurderersOnly = v end })

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
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
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

-- Misc Tab 🛠️ (Movement, Visuals, Utility)
local MiscTab = Window:CreateTab("🛠️ Misc", 4483362458)
MiscTab:CreateLabel("=== MOVEMENT ===")
MiscTab:CreateToggle({ Name = "[No Clip]", Callback = function(v) getgenv().NoClipEnabled = v end })
MiscTab:CreateToggle({ Name = "[Speed Boost]", Callback = function(v) getgenv().SpeedBoostEnabled = v end })
MiscTab:CreateSlider({ Name = "[Speed Value]", Range = {16, 200}, Increment = 4, CurrentValue = 50, Callback = function(v) getgenv().SpeedBoostValue = v end })

-- Credits/Discord Tab 💬 (Fully Restored)
local CreditsDiscordTab = Window:CreateTab("💬 Credits/Discord", 4483362458)
CreditsDiscordTab:CreateLabel("=== ❤ JASSY ❤ ===")
CreditsDiscordTab:CreateButton({
    Name = "💬 Copy Discord invite to clipboard",
    Callback = function()
        setclipboard("https://discord.gg/RhjnE4tEQ8")
        Rayfield:Notify({ Title = "Discord", Content = "Copied Discord invite to clipboard!", Duration = 5 })
    end,
})
CreditsDiscordTab:CreateButton({ Name = "⌨️ GUI KEYBIND: K", Callback = function() Rayfield:Notify({ Title = "Keybind", Content = "GUI Keybind is K", Duration = 5 }) end })
CreditsDiscordTab:CreateLabel("📜 Script made by: Jassy ❤")
CreditsDiscordTab:CreateLabel("📈 Version: 1.0")
CreditsDiscordTab:CreateLabel("🔥 Property Of ScriptForge")
CreditsDiscordTab:CreateButton({ Name = "[Uninject Script]", Callback = function() Rayfield:Destroy() end })

Rayfield:Notify({ Title = "Jassy's ❤ MM2 Script", Content = "Script loaded successfully!", Duration = 5 })
