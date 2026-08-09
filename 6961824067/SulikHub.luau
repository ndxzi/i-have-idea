local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabsContainer = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

ScreenGui.Name = "SulikHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 15, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -260)
MainFrame.Size = UDim2.new(0, 700, 0, 520)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 10, 35)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Font = Enum.Font.GothamBold
Title.Text = "СУЛИКХАБ"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 32

TabsContainer.Name = "TabsContainer"
TabsContainer.Parent = MainFrame
TabsContainer.BackgroundColor3 = Color3.fromRGB(42, 12, 35)
TabsContainer.BorderSizePixel = 0
TabsContainer.Position = UDim2.new(0, 0, 0, 50)
TabsContainer.Size = UDim2.new(0, 175, 1, -50)

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(55, 18, 45)
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 175, 0, 50)
ContentFrame.Size = UDim2.new(1, -175, 1, -50)

local tabs = {"KICK", "DEFENCE", "FUN", "PLAYER", "LAG"}
local tabContents = {}
local currentTab = nil

for i, tabName in ipairs(tabs) do
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = tabName .. "Content"
    TabContent.Parent = ContentFrame
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.Visible = false
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 6
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 150)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 600)
    tabContents[tabName] = TabContent

    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Parent = TabsContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
    TabButton.BorderSizePixel = 0
    TabButton.Position = UDim2.new(0, 8, 0, 8 + (i - 1) * 60)
    TabButton.Size = UDim2.new(1, -16, 0, 52)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 200, 220)
    TabButton.TextSize = 22

    TabButton.MouseButton1Click:Connect(function()
        for _, content in pairs(tabContents) do
            content.Visible = false
        end
        tabContents[tabName].Visible = true
        currentTab = tabName
    end)
end

local lps = 100
local lines = false
local packetLag = false
local packetStrength = 6250
local antiGrabEnabled = false
local antiGrabConnection = nil
local selectedTarget = nil
local deffKickEnabled = false
local autoResetEnabled = false
local autoResetConnection = nil

local hugeForce = Vector3.new(math.huge, math.huge, math.huge)
local upOffset = Vector3.new(0, 8, 0)
local frontOffset = CFrame.new(0, 0, 5)

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Parent = tabContents["KICK"]
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
PlayerListFrame.Position = UDim2.new(0, 15, 0, 15)
PlayerListFrame.Size = UDim2.new(1, -30, 0, 250)

local PlayerListLabel = Instance.new("TextLabel")
PlayerListLabel.Parent = PlayerListFrame
PlayerListLabel.BackgroundTransparency = 1
PlayerListLabel.Size = UDim2.new(1, 0, 0, 30)
PlayerListLabel.Font = Enum.Font.GothamSemibold
PlayerListLabel.Text = "Select Player"
PlayerListLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
PlayerListLabel.TextSize = 16

local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Parent = PlayerListFrame
PlayerScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 10, 35)
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 35)
PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -40)
PlayerScrollFrame.ScrollBarThickness = 6
PlayerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 150)
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local function updatePlayerList()
    for _, child in pairs(PlayerScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yOffset = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Parent = PlayerScrollFrame
            PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 18, 50)
            PlayerButton.Position = UDim2.new(0, 5, 0, yOffset)
            PlayerButton.Size = UDim2.new(1, -10, 0, 35)
            PlayerButton.Font = Enum.Font.Gotham
            PlayerButton.Text = player.Name .. " (" .. player.DisplayName .. ")"
            PlayerButton.TextColor3 = Color3.fromRGB(255, 200, 220)
            PlayerButton.TextSize = 14
            PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
            
            PlayerButton.MouseButton1Click:Connect(function()
                selectedTarget = player
                for _, btn in pairs(PlayerScrollFrame:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = Color3.fromRGB(60, 18, 50)
                    end
                end
                PlayerButton.BackgroundColor3 = Color3.fromRGB(100, 40, 80)
            end)
            
            yOffset = yOffset + 40
        end
    end
    
    PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

local DeffKickToggle = Instance.new("TextButton")
DeffKickToggle.Parent = tabContents["KICK"]
DeffKickToggle.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
DeffKickToggle.Position = UDim2.new(0, 15, 0, 280)
DeffKickToggle.Size = UDim2.new(1, -30, 0, 40)
DeffKickToggle.Font = Enum.Font.GothamSemibold
DeffKickToggle.Text = "Deff Kick: OFF"
DeffKickToggle.TextColor3 = Color3.fromRGB(255, 200, 220)
DeffKickToggle.TextSize = 18

DeffKickToggle.MouseButton1Click:Connect(function()
    if not selectedTarget then return end
    
    deffKickEnabled = not deffKickEnabled
    DeffKickToggle.Text = "Deff Kick: " .. (deffKickEnabled and "ON" or "OFF")
    DeffKickToggle.BackgroundColor3 = deffKickEnabled and Color3.fromRGB(100, 40, 80) or Color3.fromRGB(70, 20, 55)
    
    if not deffKickEnabled then
        if selectedTarget and selectedTarget.Character then
            local tHRP = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                if tHRP:FindFirstChild("KickBP") then tHRP.KickBP:Destroy() end
                if tHRP:FindFirstChild("KickBG") then tHRP.KickBG:Destroy() end
            end
        end
        return
    end
    
    if deffKickEnabled and selectedTarget then
        task.spawn(function()
            local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
            local destroyGrabLineEvent = GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine")
            local setOwner = GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner")
            
            while deffKickEnabled and selectedTarget do
                local target = selectedTarget
                local tChar = target.Character
                if not tChar then task.wait() continue end
                
                local tHRP = tChar:FindFirstChild("HumanoidRootPart")
                local myChar = Players.LocalPlayer.Character
                if not myChar then task.wait() continue end
                
                local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                local myHead = myChar:FindFirstChild("Head")
                
                if tHRP and myHRP and myHead then
                    local headPos = myHead.Position
                    local tPos = tHRP.Position
                    
                    local bp = tHRP:FindFirstChild("KickBP")
                    if not bp then
                        bp = Instance.new("BodyPosition")
                        bp.Name = "KickBP"
                        bp.MaxForce = hugeForce
                        bp.D = 200
                        bp.P = 20000
                        bp.Parent = tHRP
                    end
                    bp.Position = headPos + Vector3.new(0, 10, 0)
                    
                    local bg = tHRP:FindFirstChild("KickBG")
                    if not bg then
                        bg = Instance.new("BodyGyro")
                        bg.Name = "KickBG"
                        bg.MaxTorque = hugeForce
                        bg.Parent = tHRP
                    end
                    bg.CFrame = myHRP.CFrame
                    
                    if tPos.Y < 2000 and destroyGrabLineEvent then
                        local tCF = tHRP.CFrame
                        if setOwner then
                            setOwner:FireServer(tHRP, tCF)
                        end
                        destroyGrabLineEvent:FireServer(tHRP)
                    end
                    
                    local spawned = workspace:FindFirstChild(target.Name .. "SpawnedInToys")
                    if spawned then
                        local function yeetPart(part)
                            if part then
                                if setOwner then
                                    setOwner:FireServer(part, part.CFrame)
                                end
                                local owner = part:FindFirstChild("PartOwner")
                                if owner and owner.Value == Players.LocalPlayer.Name then
                                    part.CFrame = CFrame.new(0, 10000, 0)
                                end
                            end
                        end
                        
                        local kunai = spawned:FindFirstChild("NinjaKunai")
                        if kunai then
                            yeetPart(kunai:FindFirstChild("SoundPart"))
                        end
                        local shuriken = spawned:FindFirstChild("NinjaShuriken")
                        if shuriken then
                            yeetPart(shuriken:FindFirstChild("SoundPart"))
                        end
                    end
                    
                    local dist = (myHRP.Position - tPos).Magnitude
                    if tPos.Y < 2000 and dist > 25 then
                        local oldCF = myHRP.CFrame
                        myHRP.CFrame = tHRP.CFrame * frontOffset
                        task.wait(0.15)
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                            myHRP.CFrame = oldCF
                        end
                    end
                end
                task.wait()
            end
            
            if selectedTarget and selectedTarget.Character then
                local tHRP = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    if tHRP:FindFirstChild("KickBP") then tHRP.KickBP:Destroy() end
                    if tHRP:FindFirstChild("KickBG") then tHRP.KickBG:Destroy() end
                end
            end
        end)
    end
end)

local AntiLagToggle = Instance.new("TextButton")
AntiLagToggle.Parent = tabContents["DEFENCE"]
AntiLagToggle.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
AntiLagToggle.Position = UDim2.new(0, 15, 0, 15)
AntiLagToggle.Size = UDim2.new(1, -30, 0, 40)
AntiLagToggle.Font = Enum.Font.GothamSemibold
AntiLagToggle.Text = "Anti Lag: OFF"
AntiLagToggle.TextColor3 = Color3.fromRGB(255, 200, 220)
AntiLagToggle.TextSize = 18

local antiLagEnabled = false

AntiLagToggle.MouseButton1Click:Connect(function()
    antiLagEnabled = not antiLagEnabled
    AntiLagToggle.Text = "Anti Lag: " .. (antiLagEnabled and "ON" or "OFF")
    AntiLagToggle.BackgroundColor3 = antiLagEnabled and Color3.fromRGB(100, 40, 80) or Color3.fromRGB(70, 20, 55)
    
    local LocalPlayer = Players.LocalPlayer
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts") then
        local scripts = LocalPlayer.PlayerScripts
        if scripts:FindFirstChild("CharacterAndBeamMove") then
            scripts.CharacterAndBeamMove.Enabled = not antiLagEnabled
        end
        if scripts:FindFirstChild("StickyPartsTouchDetection") then
            scripts.StickyPartsTouchDetection.Enabled = not antiLagEnabled
        end
    end
end)

local AntiGrabToggle = Instance.new("TextButton")
AntiGrabToggle.Parent = tabContents["DEFENCE"]
AntiGrabToggle.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
AntiGrabToggle.Position = UDim2.new(0, 15, 0, 70)
AntiGrabToggle.Size = UDim2.new(1, -30, 0, 40)
AntiGrabToggle.Font = Enum.Font.GothamSemibold
AntiGrabToggle.Text = "Anti Grab: OFF"
AntiGrabToggle.TextColor3 = Color3.fromRGB(255, 200, 220)
AntiGrabToggle.TextSize = 18

AntiGrabToggle.MouseButton1Click:Connect(function()
    antiGrabEnabled = not antiGrabEnabled
    AntiGrabToggle.Text = "Anti Grab: " .. (antiGrabEnabled and "ON" or "OFF")
    AntiGrabToggle.BackgroundColor3 = antiGrabEnabled and Color3.fromRGB(100, 40, 80) or Color3.fromRGB(70, 20, 55)
    
    if antiGrabEnabled then
        local LocalPlayer = Players.LocalPlayer
        local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
        local StruggleEvent = CharacterEvents:WaitForChild("Struggle")
        local IsHeld = LocalPlayer:WaitForChild("IsHeld")
        
        antiGrabConnection = IsHeld.Changed:Connect(function(v)
            if v and antiGrabEnabled then
                task.spawn(function()
                    local character = LocalPlayer.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Anchored = true
                        end
                    end
                    
                    while IsHeld.Value and antiGrabEnabled do
                        StruggleEvent:FireServer(LocalPlayer)
                        task.wait()
                    end
                    
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Anchored = false
                        end
                    end
                end)
            end
        end)
    else
        if antiGrabConnection then
            antiGrabConnection:Disconnect()
            antiGrabConnection = nil
        end
        
        local LocalPlayer = Players.LocalPlayer
        if LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = false
            end
        end
    end
end)

local AutoResetToggle = Instance.new("TextButton")
AutoResetToggle.Parent = tabContents["DEFENCE"]
AutoResetToggle.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
AutoResetToggle.Position = UDim2.new(0, 15, 0, 125)
AutoResetToggle.Size = UDim2.new(1, -30, 0, 40)
AutoResetToggle.Font = Enum.Font.GothamSemibold
AutoResetToggle.Text = "Auto Reset: OFF"
AutoResetToggle.TextColor3 = Color3.fromRGB(255, 200, 220)
AutoResetToggle.TextSize = 18

AutoResetToggle.MouseButton1Click:Connect(function()
    autoResetEnabled = not autoResetEnabled
    AutoResetToggle.Text = "Auto Reset: " .. (autoResetEnabled and "ON" or "OFF")
    AutoResetToggle.BackgroundColor3 = autoResetEnabled and Color3.fromRGB(100, 40, 80) or Color3.fromRGB(70, 20, 55)
    
    if autoResetEnabled then
        local GameCorrectionEvents = ReplicatedStorage:WaitForChild("GameCorrectionEvents")
        local notifyEvent = GameCorrectionEvents:WaitForChild("GameCorrectionsNotify")
        
        autoResetConnection = notifyEvent.OnClientEvent:Connect(function(reason)
            if reason == "Flying" then
                local char = Players.LocalPlayer.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Dead)
                    hum.Health = 0
                end
            end
        end)
    else
        if autoResetConnection then
            autoResetConnection:Disconnect()
            autoResetConnection = nil
        end
    end
end)

local LagSlider = Instance.new("Frame")
LagSlider.Parent = tabContents["LAG"]
LagSlider.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
LagSlider.Position = UDim2.new(0, 15, 0, 15)
LagSlider.Size = UDim2.new(1, -30, 0, 50)

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Parent = LagSlider
SliderLabel.BackgroundTransparency = 1
SliderLabel.Size = UDim2.new(1, 0, 0, 25)
SliderLabel.Font = Enum.Font.GothamSemibold
SliderLabel.Text = "Lines: " .. lps
SliderLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
SliderLabel.TextSize = 16

local SliderBar = Instance.new("Frame")
SliderBar.Parent = LagSlider
SliderBar.BackgroundColor3 = Color3.fromRGB(40, 10, 35)
SliderBar.Position = UDim2.new(0, 10, 0, 30)
SliderBar.Size = UDim2.new(1, -20, 0, 15)

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBar
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
SliderFill.Size = UDim2.new(lps / 5000, 0, 1, 0)

local SliderButton = Instance.new("TextButton")
SliderButton.Parent = SliderBar
SliderButton.BackgroundTransparency = 1
SliderButton.Size = UDim2.new(1, 0, 1, 0)
SliderButton.Text = ""

SliderButton.MouseButton1Down:Connect(function()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            connection:Disconnect()
            return
        end
        local mouse = UserInputService:GetMouseLocation()
        local relativeX = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        lps = math.floor(relativeX * 5000)
        SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        SliderLabel.Text = "Lines: " .. lps
    end)
end)

local LagToggle = Instance.new("TextButton")
LagToggle.Parent = tabContents["LAG"]
LagToggle.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
LagToggle.Position = UDim2.new(0, 15, 0, 80)
LagToggle.Size = UDim2.new(1, -30, 0, 40)
LagToggle.Font = Enum.Font.GothamSemibold
LagToggle.Text = "Lag Lines: OFF"
LagToggle.TextColor3 = Color3.fromRGB(255, 200, 220)
LagToggle.TextSize = 18

LagToggle.MouseButton1Click:Connect(function()
    lines = not lines
    LagToggle.Text = "Lag Lines: " .. (lines and "ON" or "OFF")
    LagToggle.BackgroundColor3 = lines and Color3.fromRGB(100, 40, 80) or Color3.fromRGB(70, 20, 55)
    
    if lines then
        task.spawn(function()
            local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
            if GrabEvents then
                while lines do
                    for i = 1, lps do
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= Players.LocalPlayer and player.Character then
                                GrabEvents.CreateGrabLine:FireServer(player.Character:FindFirstChild("HumanoidRootPart"), CFrame.new(0, 9e9, 0))
                            end
                        end
                    end
                    task.wait(1)
                end
            end
        end)
    end
end)

local PacketSlider = Instance.new("Frame")
PacketSlider.Parent = tabContents["LAG"]
PacketSlider.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
PacketSlider.Position = UDim2.new(0, 15, 0, 135)
PacketSlider.Size = UDim2.new(1, -30, 0, 50)

local PacketSliderLabel = Instance.new("TextLabel")
PacketSliderLabel.Parent = PacketSlider
PacketSliderLabel.BackgroundTransparency = 1
PacketSliderLabel.Size = UDim2.new(1, 0, 0, 25)
PacketSliderLabel.Font = Enum.Font.GothamSemibold
PacketSliderLabel.Text = "Packet Strength: " .. packetStrength
PacketSliderLabel.TextColor3 = Color3.fromRGB(255, 200, 220)
PacketSliderLabel.TextSize = 16

local PacketSliderBar = Instance.new("Frame")
PacketSliderBar.Parent = PacketSlider
PacketSliderBar.BackgroundColor3 = Color3.fromRGB(40, 10, 35)
PacketSliderBar.Position = UDim2.new(0, 10, 0, 30)
PacketSliderBar.Size = UDim2.new(1, -20, 0, 15)

local PacketSliderFill = Instance.new("Frame")
PacketSliderFill.Parent = PacketSliderBar
PacketSliderFill.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
PacketSliderFill.Size = UDim2.new(packetStrength / 10000, 0, 1, 0)

local PacketSliderButton = Instance.new("TextButton")
PacketSliderButton.Parent = PacketSliderBar
PacketSliderButton.BackgroundTransparency = 1
PacketSliderButton.Size = UDim2.new(1, 0, 1, 0)
PacketSliderButton.Text = ""

PacketSliderButton.MouseButton1Down:Connect(function()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            connection:Disconnect()
            return
        end
        local mouse = UserInputService:GetMouseLocation()
        local relativeX = math.clamp((mouse.X - PacketSliderBar.AbsolutePosition.X) / PacketSliderBar.AbsoluteSize.X, 0, 1)
        packetStrength = math.floor(relativeX * 10000)
        PacketSliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        PacketSliderLabel.Text = "Packet Strength: " .. packetStrength
    end)
end)

local PacketToggle = Instance.new("TextButton")
PacketToggle.Parent = tabContents["LAG"]
PacketToggle.BackgroundColor3 = Color3.fromRGB(70, 20, 55)
PacketToggle.Position = UDim2.new(0, 15, 0, 200)
PacketToggle.Size = UDim2.new(1, -30, 0, 40)
PacketToggle.Font = Enum.Font.GothamSemibold
PacketToggle.Text = "Packet Lag: OFF"
PacketToggle.TextColor3 = Color3.fromRGB(255, 200, 220)
PacketToggle.TextSize = 18

PacketToggle.MouseButton1Click:Connect(function()
    packetLag = not packetLag
    PacketToggle.Text = "Packet Lag: " .. (packetLag and "ON" or "OFF")
    PacketToggle.BackgroundColor3 = packetLag and Color3.fromRGB(100, 40, 80) or Color3.fromRGB(70, 20, 55)
    
    if packetLag then
        local LocalPlayer = Players.LocalPlayer
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts") then
            local scripts = LocalPlayer.PlayerScripts
            if scripts:FindFirstChild("CharacterAndBeamMove") then
                scripts.CharacterAndBeamMove.Enabled = false
            end
            if scripts:FindFirstChild("StickyPartsTouchDetection") then
                scripts.StickyPartsTouchDetection.Enabled = false
            end
        end
        
        task.spawn(function()
            local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
            if GrabEvents and GrabEvents:FindFirstChild("ExtendGrabLine") then
                while packetLag do
                    GrabEvents.ExtendGrabLine:FireServer(string.rep("😂😂😂😂🤣🤣🤣🤣", 100 * packetStrength))
                    task.wait(0.5)
                end
            end
        end)
    else
        local LocalPlayer = Players.LocalPlayer
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts") then
            local scripts = LocalPlayer.PlayerScripts
            if scripts:FindFirstChild("CharacterAndBeamMove") then
                scripts.CharacterAndBeamMove.Enabled = true
            end
            if scripts:FindFirstChild("StickyPartsTouchDetection") then
                scripts.StickyPartsTouchDetection.Enabled = true
            end
        end
    end
end)

tabContents["LAG"].Visible = true
currentTab = "LAG"

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        MainFrame.Visible = not MainFrame.Visible
    end
end)