local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Clipboard = setclipboard or toclipboard or function() end

local CORRECT_KEY = "LunxKey-9k41vb8xzwq62mjr7" 
local DISCORD_LINK = "discord.gg/AKFUwcbQT"

local Themes = {
["Scout"] = {Bg = Color3.fromRGB(35, 55, 95), Accent = Color3.fromRGB(60, 120, 240), Text = Color3.fromRGB(255, 255, 255)},
["PovHuso"] = {Bg = Color3.fromRGB(55, 30, 30), Accent = Color3.fromRGB(230, 45, 65), Text = Color3.fromRGB(255, 255, 255)},
["ApexTurka"] = {Bg = Color3.fromRGB(65, 65, 65), Accent = Color3.fromRGB(160, 160, 160), Text = Color3.fromRGB(255, 255, 255)},
["Mimi Typh"] = {Bg = Color3.fromRGB(45, 35, 25), Accent = Color3.fromRGB(188, 188, 188), Text = Color3.fromRGB(140, 90, 60)},
["g3oxq22kc"] = {Bg = Color3.fromRGB(45, 45, 45), Accent = Color3.fromRGB(188, 188, 188), Text = Color3.fromRGB(140, 140, 140)},
["CSG"] = {Bg = Color3.fromRGB(55, 30, 30), Accent = Color3.fromRGB(230, 45, 65), Text = Color3.fromRGB(255, 255, 255)}
}

_G.SelectedTheme = "CSG"

---------------------------------------------------------
local function UnlockMouse()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
end
UnlockMouse()

-- Fareyi ekranda tutmak için döngü (UI aç1kken kilitlenmesini önler)
local mouseLoop = task.spawn(function()
    while task.wait(0.2) do
        UnlockMouse()
    end
end)

---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunxKeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 280)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(111, 0, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "LUNX SYSTEMS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Parent = MainFrame

local KeyPage = Instance.new("Frame")
KeyPage.Size = UDim2.new(1, 0, 1, -45)
KeyPage.Position = UDim2.new(0, 0, 0, 45)
KeyPage.BackgroundTransparency = 1
KeyPage.Parent = MainFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 280, 0, 40)
KeyInput.Position = UDim2.new(0.5, -140, 0.2, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.PlaceholderText = "Enter Security Key Here..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
KeyInput.Parent = KeyPage

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 6)
KeyCorner.Parent = KeyInput

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0.45, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusLabel.TextSize = 13
StatusLabel.Parent = KeyPage

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0, 130, 0, 35)
SubmitBtn.Position = UDim2.new(0.5, -145, 0.6, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
SubmitBtn.Text = "Check Key"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 14
SubmitBtn.Parent = KeyPage

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitBtn

local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(0, 130, 0, 35)
DiscordBtn.Position = UDim2.new(0.5, 15, 0.6, 0)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DiscordBtn.Text = "Copy Discord"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 14
DiscordBtn.Parent = KeyPage

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 6)
DiscordCorner.Parent = DiscordBtn

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 0.82, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "You can only find the key in our Discord server."
InfoLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
InfoLabel.TextSize = 12
InfoLabel.Parent = KeyPage

local ThemePage = Instance.new("Frame")
ThemePage.Size = UDim2.new(1, 0, 1, -45)
ThemePage.Position = UDim2.new(1, 0, 0, 45)
ThemePage.BackgroundTransparency = 1
ThemePage.Parent = MainFrame

local ThemeGrid = Instance.new("UIGridLayout")
ThemeGrid.FillDirection = Enum.FillDirection.Horizontal
ThemeGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
ThemeGrid.VerticalAlignment = Enum.VerticalAlignment.Center
ThemeGrid.CellPadding = UDim2.new(0, 8, 0, 0)
ThemeGrid.CellSize = UDim2.new(0, 90, 0, 35)
ThemeGrid.Parent = ThemePage

local LoadingPage = Instance.new("Frame")
LoadingPage.Size = UDim2.new(1, 0, 1, -45)
LoadingPage.Position = UDim2.new(1, 0, 0, 45)
LoadingPage.BackgroundTransparency = 1
LoadingPage.Parent = MainFrame

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(1, 0, 1, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Loading Theme Config..."
LoadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingLabel.TextSize = 16
LoadingLabel.Parent = LoadingPage


DiscordBtn.MouseButton1Click:Connect(function()
    Clipboard("discord.gg/e2x77rVbmZ")
    DiscordBtn.Text = "Copied Link!"
    task.wait(1.5)
    DiscordBtn.Text = "Copy Discord"
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        StatusLabel.Text = "Access Granted! Loading themes..."
        task.wait(1)
        
        KeyPage:Destroy()
        
        local resizeTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 505, 0, 120),
            Position = UDim2.new(0.5, -252, 0.5, -60)
        })
        resizeTween:Play()
        
        ThemePage.Position = UDim2.new(0, 0, 0, 45)
        Title.Text = "SELECT A PRESET THEME"

        for themeName, colorData in pairs(Themes) do
            local TBtn = Instance.new("TextButton")
            TBtn.Name = themeName
            TBtn.BackgroundColor3 = colorData.Bg
            TBtn.Text = themeName
            TBtn.TextColor3 = colorData.Accent
            TBtn.TextSize = 12
            TBtn.Parent = ThemePage
            
            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 6)
            TCorner.Parent = TBtn
            
            local TStroke = Instance.new("UIStroke")
            TStroke.Thickness = 1
            TStroke.Color = colorData.Accent
            TStroke.Parent = TBtn
            
            TBtn.MouseButton1Click:Connect(function()
                _G.SelectedTheme = themeName
                ThemePage:Destroy()

                local normalizeTween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 300, 0, 150),
                    Position = UDim2.new(0.5, -150, 0.5, -75)
                })
                normalizeTween:Play()
                
                MainFrame.BackgroundColor3 = colorData.Bg
                UIStroke.Color = colorData.Accent
                Title.TextColor3 = colorData.Text
                LoadingLabel.TextColor3 = colorData.Text
                Title.Text = "INITIALIZING"
                
                LoadingPage.Position = UDim2.new(0, 0, 0, 45)
                
                for i = 3, 1, -1 do
                    LoadingLabel.Text = "Loading..."
                    task.wait(1)
                end
                
                task.cancel(mouseLoop)
                ScreenGui:Destroy()
                
                _G.KeySystemVerified = true
            end)
        end
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        StatusLabel.Text = "Invalid Key! Try again."
    end
end)

repeat task.wait(0.1) until _G.KeySystemVerified == true

print("Key verified successfully! Loaded Theme: " .. tostring(_G.SelectedTheme))

--[[
	HUB UI LIBRARY (v2)
	--------------------
	Minecraft "silent client" tarz1: ekran1n sa üstünden sola doru
	s1ralanan ba1ms1z kategori panelleri. Her panel kendi içeriine göre
	otomatik büyür/küçülür. Dropdown/ToggleDropdown/ColorPicker aç1ld11nda
	her _eyin üstünde (global overlay) render edilir, hiçbir elementin
	arkas1nda kalmaz.

	K tu_u = tüm panelleri aç/kapat (watermark her zaman görünür kal1r)

	Bile_enler: Window, Toggle, Checkbox, Button, Slider, Dropdown,
	ToggleDropdown, ColorPicker, Keybind, Textbox, Label, Notification,
	Watermark, KeybindList, Flags, Example, CloseGui
]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local Stats             = game:GetService("Stats")
print("1")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("Player
middle output omitted
         local attacker = Players:FindFirstChild(partOwner.Value)
                            if attacker and attacker.Character then
                                Struggle:FireServer()
                                SetNetworkOwner:FireServer(attacker.Character.Head or attacker.Character.Torso, attacker.Character.HumanoidRootPart.FirePlayerPart.CFrame)
                                task.wait(0.1)
                                local target = attacker.Character:FindFirstChild("Torso")
                                if target then
                                    local velocity = target:FindFirstChild("l") or Instance.new("BodyVelocity")
                                    velocity.Name = "l"
                                    velocity.Parent = target
                                    velocity.Velocity = Vector3.new(0, 50, 0)
                                    velocity.MaxForce = Vector3.new(0, math.huge, 0)
                                    Debris:AddItem(velocity, 100)
                                end
                            end
                        end
                    end
                end
            end)
            coroutine.resume(autoDefendCoroutine)
        else
            if autoDefendCoroutine then
                coroutine.close(autoDefendCoroutine)
                autoDefendCoroutine = nil
            end
        end
    end
})

DefanseTab:CreateToggle({
    Name = "Kick Silent Defense",
    Default = false,
    Flag = "KickSilentFlag", 
    Callback = function(enabled)

    end
})


-- ==========================================
-- TROLL TAB
-- ==========================================
FunTab:CreateTextbox({
    Name = "Coins Amount",
    Default = "",
    Placeholder = "Enter value",
    Flag = "Coin",
    Callback = function(Text)
        skolko = Text 
    end,
})

FunTab:CreateButton({
    Name = "Get Coins",
    Callback = function()
        local coinAmount = tonumber(skolko) or 0 
        game.Players.LocalPlayer.PlayerGui.MenuGui.TopRight.CoinsFrame.CoinsDisplay.Coins.Text = tostring(coinAmount)
    end,
})

FunTab:CreateLabel("Decoy Settings")

FunTab:CreateSlider({
    Name = "Offset",
    Min = 1,
    Max = 10,
    Default = 10,
    Flag = "OffsetFlag",
    Callback = function(Value)
        decoyOffset = Value
    end
})

FunTab:CreateTextbox({
    Name = "Circle Radius",
    Default = "",
    Placeholder = "Enter radius",
    Flag = "RadiusFlag",
    Callback = function(Value)
        circleRadius = tonumber(Value) or 10
    end,
})

FunTab:CreateButton({
    Name = "Decoy Follow",
    Callback = function()
        local decoys = {}
        for _, descendant in pairs(workspace:GetDescendants()) do
            if descendant:IsA("Model") and descendant.Name == "YouDecoy" then
                table.insert(decoys, descendant)
            end
        end
        local numDecoys = #decoys
        local midPoint = math.ceil(numDecoys / 2)

        local function updateDecoyPositions()
            for index, decoy in pairs(decoys) do
                local torso = decoy:FindFirstChild("Torso")
                if torso then
                    local bodyPosition = torso:FindFirstChild("BodyPosition")
                    local bodyGyro = torso:FindFirstChild("BodyGyro")
                    if bodyPosition and bodyGyro then
                        local targetPosition
                        if followMode then
                            if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                                targetPosition = playerCharacter.HumanoidRootPart.Position
                                local offset = (index - midPoint) * decoyOffset
                                local forward = playerCharacter.HumanoidRootPart.CFrame.LookVector
                                local right = playerCharacter.HumanoidRootPart.CFrame.RightVector
                                targetPosition = targetPosition - forward * decoyOffset + right * offset
                            end
                        else
                            local nearestPlayer = getNearestPlayer()
                            if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local angle = math.rad((index - 1) * (360 / numDecoys))
                                targetPosition = nearestPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.cos(angle) * circleRadius, 0, math.sin(angle) * circleRadius)
                                bodyGyro.CFrame = CFrame.new(torso.Position, nearestPlayer.Character.HumanoidRootPart.Position)
                            end
                        end

                        if targetPosition then
                            local distance = (targetPosition - torso.Position).Magnitude
                            if distance > stopDistance then
                                bodyPosition.Position = targetPosition
                                if followMode then
                                    bodyGyro.CFrame = CFrame.new(torso.Position, targetPosition)
                                end
                            else
                                bodyPosition.Position = torso.Position
                                bodyGyro.CFrame = torso.CFrame
                            end
                        end
                    end
                end
            end
        end

        local function setupDecoy(decoy)
            local torso = decoy:FindFirstChild("Torso")
            if torso then
                local bodyPosition = Instance.new("BodyPosition")
                local bodyGyro = Instance.new("BodyGyro")
                bodyPosition.Parent = torso
                bodyGyro.Parent = torso
                bodyPosition.MaxForce = Vector3.new(40000, 40000, 40000)
                bodyPosition.D = 100
                bodyPosition.P = 100
                bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
                bodyGyro.D = 100
                bodyGyro.P = 20000
                local connection = RunService.Heartbeat:Connect(function()
                    updateDecoyPositions()
                end)
                table.insert(connections, connection)
                SetNetworkOwner:FireServer(torso, playerCharacter.Head.CFrame)
            end
        end

        for _, decoy in pairs(decoys) do
            setupDecoy(decoy)
        end
        Hub:Notify({Title = "Notification",Content = "Got "..numDecoys.." units. Manually click each unit if they do not move", Duration = 6.5,})
    end
})

FunTab:CreateButton({
    Name = "Toggle Follow Mode",
    Callback = function()
        followMode = not followMode
    end,
})

FunTab:CreateButton({
    Name = "Disconnect Clones",
    Callback = cleanupConnections(connections)
})


-- ==========================================================
-- REQUIRED VARIABLES & SERVICES
-- ==========================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not getgenv().Settings then
    getgenv().Settings = {}
end

if not getgenv().Settings.Misc then
    getgenv().Settings.Misc = {
        packetAmount = 50, -- A_1r1 yüksek olmamal1, ideal aral1k: 30 - 150
        packetLag = false
    }
end

local Settings = getgenv().Settings
local State = getgenv().State

if not State then
    getgenv().State = {
        packetLagConn = nil
    }
    State = getgenv().State
end

-- ==========================================
-- PACKET LAG SECTION (ADD UNDER TROLL TAB)
-- ==========================================
FunTab:CreateLabel("Packet Lag Settings")

FunTab:CreateSlider({
    Name = "Packet Amount",
    Min = 5,
    Max = 200, -- Kendi internetini çökertmemek için s1n1r1 dü_ürdük
    Default = 50,
    Flag = "PacketAmount",
    Callback = function(Value)
        Settings.Misc.packetAmount = Value
    end
})

FunTab:CreateToggle({
    Name = "Packet Lag",
    Default = false,
    Flag = "PacketLag",
    Callback = function(Value)
        Settings.Misc.packetLag = Value
        
        if Value then
            if State.packetLagConn then
                task.cancel(State.packetLagConn)
                State.packetLagConn = nil
            end
            
            State.packetLagConn = task.spawn(function()
                local GrabEvent = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("ExtendGrabLine")
                
                while Settings.Misc.packetLag do
                    -- E_zamanl1 (Asynchronous) paket dalgas1 göndererek 
                    -- senin yükleme (upload) kanal1n1 kilitlemeden sunucuya ula_t1r1r1z.
                    local amount = Settings.Misc.packetAmount or 50
                    
                    pcall(function()
                        for i = 1, amount do
                            if not Settings.Misc.packetLag then break end
                            -- Çok büyük string yerine orta boyutlu ama yorucu argümanlar gönderiyoruz
                            GrabEvent:FireServer("Balls_Lag_Active_Vector")
                        end
                    end)
                    
                    -- Kendi pinginin f1rlamamas1 için her dalga aras1nda çok k1sa bir bekleme (0.05 saniye) koyuyoruz.
                    -- Bu sayede senin giden paket kuyruun temizlenir ama sunucu sürekli yeni dalga al1r.
                    task.wait(0.05)
                end
            end)
        else
            if State.packetLagConn then
                task.cancel(State.packetLagConn)
                State.packetLagConn = nil
            end
        end
    end
})

-- ==========================================
-- SCRIPT LOAD COMPLETION
-- ==========================================
print("Lunx > Script completed")
print("Lunx:information > Press K to toggle the menu")

Hub:Notify({ Title = "Information", Content = "Press K to toggle the menu" })
return Hub
