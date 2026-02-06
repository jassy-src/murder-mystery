-- Roblox Murder Mystery Script - Remote Version
-- This is the content that will be hosted on the remote URL
local Players,RunService,UserInputService,Workspace,Camera,LocalPlayer=game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("Workspace"),Workspace.CurrentCamera,Players.LocalPlayer
local Settings={ESP_Enabled=true,ESP_Color=Color3.new(1,0,0),ESP_Transparency=0.7,LockOn_Enabled=true,LockOn_Key=Enum.KeyCode.Q,LockOn_Smoothness=0.1,LockOn_FOV=30,Show_Distance=true,Show_Names=true,Show_Health=true,GUI_Key=Enum.KeyCode.RightShift,GUI_Visible=true}
local LockedTarget,ESP_Objects,IsLoaded,IsLocked=nil,{},false,false
local function GetDistance(Position)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then return math.huge end
    return (LocalPlayer.Character.HumanoidRootPart.Position-Position).Magnitude
end
local function IsPlayerVisible(Player)
    if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart")then return false end
    local Origin,CFrame=Camera.CFrame.Position,Player.Character.HumanoidRootPart.Position
    local Ray=Ray.new(Origin,CFrame-Origin)
    local Part,Position=Workspace:FindPartOnRayWithIgnoreList(Ray,{LocalPlayer.Character,Camera})
    return Part and Part:IsDescendantOf(Player.Character)
end
local function GetClosestPlayer()
    local ClosestPlayer,ClosestDistance=nil,Settings.LockOn_FOV
    for _,Player in pairs(Players:GetPlayers())do
        if Player~=LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid")and Player.Character:FindFirstChild("HumanoidRootPart")and Player.Character.Humanoid.Health>0 then
            local ScreenPosition,OnScreen=Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            if OnScreen then
                local Distance=(Vector2.new(ScreenPosition.X,ScreenPosition.Y)-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                if Distance<ClosestDistance then ClosestDistance,ClosestPlayer=Distance,Player end
            end
        end
    end
    return ClosestPlayer
end
local function CreateESP(Player)
    if ESP_Objects[Player]then return end
    local Character=Player.Character
    if not Character then return end
    local ESP={}
    local Billboard=Instance.new("BillboardGui")
    Billboard.Name,Billboard.Size,Billboard.StudsOffset,Billboard.AlwaysOnTop="ESP_Billboard",UDim2.new(0,200,0,100),Vector3.new(0,3,0),true
    Billboard.Parent=Character:FindFirstChild("Head")or Character:FindFirstChild("HumanoidRootPart")
    local Frame=Instance.new("Frame")
    Frame.Size,Frame.BackgroundTransparency=UDim2.new(1,0,1,0),1
    Frame.Parent=Billboard
    local NameLabel=Instance.new("TextLabel")
    NameLabel.Name,NameLabel.Size,NameLabel.Position,NameLabel.BackgroundTransparency="NameLabel",UDim2.new(1,0,0,20),UDim2.new(0,0,0,0),1
    NameLabel.Text,NameLabel.TextColor3,NameLabel.TextStrokeTransparency,NameLabel.TextScaled,NameLabel.Font=Player.Name,Settings.ESP_Color,0.5,true,Enum.Font.SourceSansBold
    NameLabel.Parent=Frame
    local DistanceLabel=Instance.new("TextLabel")
    DistanceLabel.Name,DistanceLabel.Size,DistanceLabel.Position,DistanceLabel.BackgroundTransparency="DistanceLabel",UDim2.new(1,0,0,15),UDim2.new(0,0,0,20),1
    DistanceLabel.Text,DistanceLabel.TextColor3,DistanceLabel.TextStrokeTransparency,DistanceLabel.TextScaled,DistanceLabel.Font="",Settings.ESP_Color,0.5,true,Enum.Font.SourceSans
    DistanceLabel.Parent=Frame
    local HealthLabel=Instance.new("TextLabel")
    HealthLabel.Name,HealthLabel.Size,HealthLabel.Position,HealthLabel.BackgroundTransparency="HealthLabel",UDim2.new(1,0,0,15),UDim2.new(0,0,0,35),1
    HealthLabel.Text,HealthLabel.TextColor3,HealthLabel.TextStrokeTransparency,HealthLabel.TextScaled,HealthLabel.Font="",Settings.ESP_Color,0.5,true,Enum.Font.SourceSans
    HealthLabel.Parent=Frame
    local Box=Instance.new("BoxHandleAdornment")
    Box.Name,Box.Size,Box.CFrame,Box.Color3,Box.Transparency,Box.AlwaysOnTop,Box.Visible,Box.ZIndex="ESP_Box",Character:GetExtentsSize(),Character.PrimaryPart.CFrame,Settings.ESP_Color,Settings.ESP_Transparency,true,false,10
    Box.Parent=Workspace
    ESP.Billboard,ESP.Box,ESP.NameLabel,ESP.DistanceLabel,ESP.HealthLabel=Billboard,Box,NameLabel,DistanceLabel,HealthLabel
    ESP_Objects[Player]=ESP
end
local function UpdateESP(Player)
    local ESP=ESP_Objects[Player]
    if not ESP then return end
    local Character=Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart")then RemoveESP(Player)return end
    if Settings.Show_Names then ESP.NameLabel.Text,ESP.NameLabel.Visible=Player.Name,true else ESP.NameLabel.Visible=false end
    if Settings.Show_Distance then
        local Distance=GetDistance(Character.HumanoidRootPart.Position)
        ESP.DistanceLabel.Text,ESP.DistanceLabel.Visible=string.format("Distance: %.0f",Distance),true
    else ESP.DistanceLabel.Visible=false end
    if Settings.Show_Health and Character:FindFirstChild("Humanoid")then
        local Health,MaxHealth=Character.Humanoid.Health,Character.Humanoid.MaxHealth
        ESP.HealthLabel.Text,ESP.HealthLabel.Visible=string.format("Health: %.0f/%.0f",Health,MaxHealth),true
    else ESP.HealthLabel.Visible=false end
    if Character.PrimaryPart then ESP.Box.Size,ESP.Box.CFrame,ESP.Box.Visible=Character:GetExtentsSize(),Character.PrimaryPart.CFrame,Settings.ESP_Enabled end
    ESP.Billboard.Enabled=Settings.ESP_Enabled
end
local function RemoveESP(Player)
    local ESP=ESP_Objects[Player]
    if ESP then
        if ESP.Billboard then ESP.Billboard:Destroy()end
        if ESP.Box then ESP.Box:Destroy()end
        ESP_Objects[Player]=nil
    end
end
local function LockOn(Player)
    if not Player or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart")then return end
    LockedTarget,IsLocked=Player,true
end
local function Unlock()LockedTarget,IsLocked=nil,false end
local function UpdateLockOn()
    if not Settings.LockOn_Enabled then Unlock()return end
    if LockedTarget and LockedTarget.Character and LockedTarget.Character:FindFirstChild("HumanoidRootPart")then
        if LockedTarget.Character:FindFirstChild("Humanoid").Health<=0 then Unlock()return end
        local TargetPosition=LockedTarget.Character.HumanoidRootPart.Position
        local CurrentCFrame=Camera.CFrame
        local LookAt=CFrame.new(CurrentCFrame.Position,TargetPosition)
        Camera.CFrame=CurrentCFrame:Lerp(LookAt,Settings.LockOn_Smoothness)
    else Unlock()end
end
UserInputService.InputBegan:Connect(function(Input,GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode==Settings.LockOn_Key and Settings.LockOn_Enabled then
        if IsLocked then Unlock()else
            local Target=GetClosestPlayer()
            if Target then LockOn(Target)end
        end
    end
    if Input.KeyCode==Settings.GUI_Key then
        Settings.GUI_Visible=not Settings.GUI_Visible
        if _G.MurderMysteryGUI then
            _G.MurderMysteryGUI.Enabled=Settings.GUI_Visible
        end
    end
end)
Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)if Settings.ESP_Enabled then CreateESP(Player)end end)
    if Settings.ESP_Enabled then CreateESP(Player)end
end)
Players.PlayerRemoving:Connect(function(Player)RemoveESP(Player)if LockedTarget==Player then Unlock()end end)
for _,Player in pairs(Players:GetPlayers())do
    if Player~=LocalPlayer then
        Player.CharacterAdded:Connect(function(Character)if Settings.ESP_Enabled then CreateESP(Player)end end)
        if Settings.ESP_Enabled then CreateESP(Player)end
    end
end
RunService.Heartbeat:Connect(function()
    for Player,ESP in pairs(ESP_Objects)do UpdateESP(Player)end
    UpdateLockOn()
end)
local function CreateGUI()
    if IsLoaded then return end
    local ScreenGui=Instance.new("ScreenGui")
    ScreenGui.Name,ScreenGui.Parent,ScreenGui.ResetOnSpawn="MurderMysteryGUI",LocalPlayer:WaitForChild("PlayerGui"),false
    ScreenGui.Enabled=Settings.GUI_Visible
    local MainFrame=Instance.new("Frame")
    MainFrame.Name,MainFrame.Size,MainFrame.Position,MainFrame.BackgroundColor3,MainFrame.BackgroundTransparency,MainFrame.BorderSizePixel="MainFrame",UDim2.new(0,200,0,320),UDim2.new(0,10,0,10),Color3.new(1,0.8,0.9),0.2,0
    MainFrame.Parent=ScreenGui
    local Title=Instance.new("TextLabel")
    Title.Name,Title.Size,Title.Position,Title.BackgroundTransparency,Title.Text,Title.TextColor3,Title.TextScaled,Title.Font="Title",UDim2.new(1,0,0,30),UDim2.new(0,0,0,0),1,"Murder Mystery Script",Color3.new(1,1,1),true,Enum.Font.SourceSansBold
    Title.Parent=MainFrame
    local Watermark=Instance.new("TextLabel")
    Watermark.Name,Watermark.Size,Watermark.Position,Watermark.BackgroundTransparency,Watermark.Text,Watermark.TextColor3,Watermark.TextScaled,Watermark.Font,Watermark.TextStrokeTransparency="Watermark",UDim2.new(1,0,0,20),UDim2.new(0,0,0,300),1,".nojasmine.",Color3.new(1,1,1),true,Enum.Font.SourceSansItalic,0.8
    Watermark.Parent=MainFrame
    local ESPToggle=Instance.new("TextButton")
    ESPToggle.Name,ESPToggle.Size,ESPToggle.Position,ESPToggle.BackgroundColor3,ESPToggle.BorderSizePixel,ESPToggle.Text,ESPToggle.TextColor3,ESPToggle.Font="ESPToggle",UDim2.new(0,180,0,30),UDim2.new(0,10,0,40),Settings.ESP_Enabled and Color3.new(1,0.5,0.8)or Color3.new(1,0.8,0.9),0,"ESP: "..(Settings.ESP_Enabled and"ON"or"OFF"),Color3.new(1,1,1),Enum.Font.SourceSans
    ESPToggle.Parent=MainFrame
    ESPToggle.MouseButton1Click:Connect(function()
        Settings.ESP_Enabled=not Settings.ESP_Enabled
        ESPToggle.BackgroundColor3,ESPToggle.Text=Settings.ESP_Enabled and Color3.new(1,0.5,0.8)or Color3.new(1,0.8,0.9),"ESP: "..(Settings.ESP_Enabled and"ON"or"OFF")
        if Settings.ESP_Enabled then
            for _,Player in pairs(Players:GetPlayers())do if Player~=LocalPlayer then CreateESP(Player)end end
        else for Player in pairs(ESP_Objects)do RemoveESP(Player)end end
    end)
    local LockOnToggle=Instance.new("TextButton")
    LockOnToggle.Name,LockOnToggle.Size,LockOnToggle.Position,LockOnToggle.BackgroundColor3,LockOnToggle.BorderSizePixel,LockOnToggle.Text,LockOnToggle.TextColor3,LockOnToggle.Font="LockOnToggle",UDim2.new(0,180,0,30),UDim2.new(0,10,0,80),Settings.LockOn_Enabled and Color3.new(1,0.5,0.8)or Color3.new(1,0.8,0.9),0,"Lock-On: "..(Settings.LockOn_Enabled and"ON"or"OFF"),Color3.new(1,1,1),Enum.Font.SourceSans
    LockOnToggle.Parent=MainFrame
    LockOnToggle.MouseButton1Click:Connect(function()
        Settings.LockOn_Enabled=not Settings.LockOn_Enabled
        LockOnToggle.BackgroundColor3,LockOnToggle.Text=Settings.LockOn_Enabled and Color3.new(1,0.5,0.8)or Color3.new(1,0.8,0.9),"Lock-On: "..(Settings.LockOn_Enabled and"ON"or"OFF")
        if not Settings.LockOn_Enabled then Unlock()end
    end)
    local Instructions=Instance.new("TextLabel")
    Instructions.Name,Instructions.Size,Instructions.Position,Instructions.BackgroundTransparency,Instructions.Text,Instructions.TextColor3,Instructions.TextScaled,Instructions.Font,Instructions.TextWrapped="Instructions",UDim2.new(1,0,0,100),UDim2.new(0,0,0,120),1,"Press Q to lock onto nearest player\nPress Right Shift to toggle GUI\nESP shows player info\nToggle features with buttons",Color3.new(1,1,1),true,Enum.Font.SourceSans,true
    Instructions.Parent=MainFrame
    local dragging,dragStart,startPos=false,nil,nil
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging,dragStart,startPos=true,input.Position,MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=input.Position-dragStart
            MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    _G.MurderMysteryGUI=ScreenGui
    IsLoaded=true
end
if LocalPlayer.Character then
    CreateGUI()
else
    LocalPlayer.CharacterAdded:Connect(function()
        CreateGUI()
    end)
end
print("Murder Mystery Script Loaded! Press Q to lock onto nearest player, Right Shift to toggle GUI")
