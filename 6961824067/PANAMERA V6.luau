local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local fovEnabled = false
local tpEnabled = false
local espEnabled = false
local thirdPersonEnabled = false
local antiGrabEnabled = false
local autoResetEnabled = false

local normalFOV = 70
local boostedFOV = 120
local guiVisible = true
local currentPage = 1

local antiGrabConn = nil
local savedCFrame = nil
local antiKickResetConnection = nil
local thirdPersonConnection = nil

local espFolder = Instance.new("Folder")
espFolder.Name = "PANAMERA_ESP"
espFolder.Parent = game.CoreGui

local espElements = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PANAMERA_GUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(106, 13, 173)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Active = true
mainFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "PANAMERA"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18

local tabsFrame = Instance.new("Frame")
tabsFrame.Parent = mainFrame
tabsFrame.BackgroundTransparency = 1
tabsFrame.Position = UDim2.new(0, 0, 0, 30)
tabsFrame.Size = UDim2.new(1, 0, 0, 30)

local tab1Button = Instance.new("TextButton")
tab1Button.Parent = tabsFrame
tab1Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
tab1Button.Position = UDim2.new(0, 5, 0, 5)
tab1Button.Size = UDim2.new(0.5, -7.5, 0, 25)
tab1Button.Font = Enum.Font.GothamBold
tab1Button.Text = "MAIN"
tab1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
tab1Button.TextSize = 12

local tab2Button = Instance.new("TextButton")
tab2Button.Parent = tabsFrame
tab2Button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
tab2Button.Position = UDim2.new(0.5, 2.5, 0, 5)
tab2Button.Size = UDim2.new(0.5, -7.5, 0, 25)
tab2Button.Font = Enum.Font.GothamBold
tab2Button.Text = "DEFENSE"
tab2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
tab2Button.TextSize = 12

local page1 = Instance.new("Frame")
page1.Name = "Page1"
page1.Parent = mainFrame
page1.BackgroundTransparency = 1
page1.Position = UDim2.new(0, 0, 0, 65)
page1.Size = UDim2.new(1, 0, 1, -65)
page1.Visible = true

local page2 = Instance.new("Frame")
page2.Name = "Page2"
page2.Parent = mainFrame
page2.BackgroundTransparency = 1
page2.Position = UDim2.new(0, 0, 0, 65)
page2.Size = UDim2.new(1, 0, 1, -65)
page2.Visible = false

local function switchTab(tabNum)
    currentPage = tabNum
    if tabNum == 1 then
        page1.Visible = true
        page2.Visible = false
        tab1Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        tab2Button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    else
        page1.Visible = false
        page2.Visible = true
        tab1Button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        tab2Button.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end

tab1Button.MouseButton1Click:Connect(function() switchTab(1) end)
tab2Button.MouseButton1Click:Connect(function() switchTab(2) end)

local function createMenuItem(parent, name, yPos)
    local indicator = Instance.new("Frame")
    indicator.Parent = parent
    indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    indicator.Position = UDim2.new(0, 20, 0, yPos)
    indicator.Size = UDim2.new(0, 20, 0, 20)
    
    local status = Instance.new("TextLabel")
    status.Parent = parent
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0, 50, 0, yPos)
    status.Size = UDim2.new(0, 100, 0, 20)
    status.Font = Enum.Font.Gotham
    status.Text = name .. ": OFF"
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextSize = 12
    
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    button.Position = UDim2.new(0, 160, 0, yPos - 5)
    button.Size = UDim2.new(0, 110, 0, 30)
    button.Font = Enum.Font.Gotham
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    return indicator, status, button
end

local fovIndicator, fovStatus, fovButton = createMenuItem(page1, "FOV", 10)
local tpIndicator, tpStatus, tpButton = createMenuItem(page1, "TP", 50)
local espIndicator, espStatus, espButton = createMenuItem(page1, "ESP", 90)
local ragdollIndicator, ragdollStatus, ragdollButton = createMenuItem(page1, "Ragdoll", 130)
local thirdPersonIndicator, thirdPersonStatus, thirdPersonButton = createMenuItem(page1, "3rd Person", 170)

local hintLabel1 = Instance.new("TextLabel")
hintLabel1.Parent = page1
hintLabel1.BackgroundTransparency = 1
hintLabel1.Position = UDim2.new(0, 20, 0, 210)
hintLabel1.Size = UDim2.new(0, 260, 0, 80)
hintLabel1.Font = Enum.Font.Gotham
hintLabel1.Text = "[R] FOV | [Z] TP | [C] Ragdoll\n[V] 3rd Person | [L] Hide GUI\n[Tab] Switch Page"
hintLabel1.TextColor3 = Color3.fromRGB(200, 200, 200)
hintLabel1.TextSize = 11
hintLabel1.TextWrapped = true

local antiGrabIndicator, antiGrabStatus, antiGrabButton = createMenuItem(page2, "Anti Grab", 10)
local autoResetIndicator, autoResetStatus, autoResetButton = createMenuItem(page2, "Auto Reset", 50)

local hintLabel2 = Instance.new("TextLabel")
hintLabel2.Parent = page2
hintLabel2.BackgroundTransparency = 1
hintLabel2.Position = UDim2.new(0, 20, 0, 100)
hintLabel2.Size = UDim2.new(0, 260, 0, 100)
hintLabel2.Font = Enum.Font.Gotham
hintLabel2.Text = "Anti Grab - prevents players from grabbing you\n\nAuto Reset - auto respawn when kicked for flying"
hintLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
hintLabel2.TextSize = 11
hintLabel2.TextWrapped = true

local function toggleAntiGrab()
    antiGrabEnabled = not antiGrabEnabled
    
    if antiGrabEnabled then
        local isHeld = player:WaitForChild("IsHeld", 5)
        local struggleEvent = ReplicatedStorage:WaitForChild("CharacterEvents", 5)
        if struggleEvent then
            struggleEvent = struggleEvent:WaitForChild("Struggle", 5)
        end
        
        if not isHeld or not struggleEvent then
            antiGrabEnabled = false
            antiGrabIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            antiGrabStatus.Text = "Anti Grab: Error"
            return
        end
        
        local function onHeldChanged(heldState)
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if heldState then
                if hrp then 
                    savedCFrame = hrp.CFrame
                    hrp.Anchored = true 
                end
                
                task.spawn(function()
                    while isHeld.Value and antiGrabEnabled do 
                        struggleEvent:FireServer(player)
                        task.wait() 
                    end
                    if hrp then 
                        hrp.Anchored = false 
                        if savedCFrame then hrp.CFrame = savedCFrame end
                    end
                end)
            else
                if hrp then 
                    hrp.Anchored = false 
                    if savedCFrame then hrp.CFrame = savedCFrame end
                end
            end
        end
        
        if antiGrabConn then
            antiGrabConn:Disconnect()
        end
        
        antiGrabConn = isHeld.Changed:Connect(onHeldChanged)
        
        if isHeld.Value then
            onHeldChanged(true)
        end
        
        antiGrabIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        antiGrabStatus.Text = "Anti Grab: ON"
        antiGrabButton.Text = "Disable"
    else
        if antiGrabConn then
            antiGrabConn:Disconnect()
            antiGrabConn = nil
        end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = false
        end
        
        antiGrabIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        antiGrabStatus.Text = "Anti Grab: OFF"
        antiGrabButton.Text = "Anti Grab"
    end
end

local function toggleAutoReset()
    autoResetEnabled = not autoResetEnabled
    
    if autoResetEnabled then
        local notifyEvent = ReplicatedStorage:WaitForChild("GameCorrectionEvents", 5)
        if notifyEvent then
            notifyEvent = notifyEvent:WaitForChild("GameCorrectionsNotify", 5)
        end
        
        if not notifyEvent then
            autoResetEnabled = false
            autoResetIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            autoResetStatus.Text = "Auto Reset: Error"
            return
        end
        
        antiKickResetConnection = notifyEvent.OnClientEvent:Connect(function(reason)
            if reason == "Flying" then
                local char = player.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Dead)
                    hum.Health = 0
                end
            end
        end)
        
        autoResetIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        autoResetStatus.Text = "Auto Reset: ON"
        autoResetButton.Text = "Disable"
    else
        if antiKickResetConnection then
            antiKickResetConnection:Disconnect()
            antiKickResetConnection = nil
        end
        
        autoResetIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        autoResetStatus.Text = "Auto Reset: OFF"
        autoResetButton.Text = "Auto Reset"
    end
end

local function toggleThirdPerson()
    thirdPersonEnabled = not thirdPersonEnabled
    
    if thirdPersonEnabled then
        player.CameraMode = Enum.CameraMode.Classic
        player.CameraMaxZoomDistance = 100
        
        thirdPersonConnection = RunService.RenderStepped:Connect(function()
            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMaxZoomDistance = 100
        end)
        
        thirdPersonIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        thirdPersonStatus.Text = "3rd Person: ON"
        thirdPersonButton.Text = "Disable"
    else
        if thirdPersonConnection then
            thirdPersonConnection:Disconnect()
            thirdPersonConnection = nil
        end
        
        player.CameraMode = Enum.CameraMode.LockFirstPerson
        player.CameraMaxZoomDistance = 0.5
        
        thirdPersonIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        thirdPersonStatus.Text = "3rd Person: OFF"
        thirdPersonButton.Text = "3rd Person"
    end
end

local function activateRagdoll()
    ragdollIndicator.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    ragdollStatus.Text = "Ragdoll: Working..."
    
    local char = player.Character
    local HRP = char and char:FindFirstChild("HumanoidRootPart")
    local Ragdoll = ReplicatedStorage:FindFirstChild("CharacterEvents")
    if Ragdoll then
        Ragdoll = Ragdoll:FindFirstChild("RagdollRemote")
    end
    
    if char and HRP and char:FindFirstChild("Left Leg") and char:FindFirstChild("Right Leg") and char:FindFirstChild("Torso") then
        local ll = char["Left Leg"]
        local rl = char["Right Leg"]
        local torso = char.Torso
        local void = workspace.FallenPartsDestroyHeight
        local pos = torso.CFrame
        
        workspace.FallenPartsDestroyHeight = -100
        
        if Ragdoll then
            Ragdoll:FireServer(HRP, 2)
        end
        
        task.wait(0.5)
        
        rl.CFrame = CFrame.new(0, -10000, 0)
        ll.CFrame = CFrame.new(0, -10000, 0)
        task.wait(0.3)
        
        torso.CFrame = CFrame.new(0, -9970, 0)
        task.wait(0.5)
        
        torso.CFrame = pos
        task.wait(0.5)
        
        workspace.FallenPartsDestroyHeight = void
        
        task.spawn(function()
            while char and char.Parent do
                if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        local controls = player.PlayerGui:FindFirstChild("ControlsGui")
                        if controls and controls:FindFirstChild("PCFrame") and controls.PCFrame:FindFirstChild("Stand") then
                            if controls.PCFrame.Stand.Visible == false then
                                hum.HipHeight = 2
                            else
                                hum.HipHeight = 0
                            end
                        end
                    end
                else
                    break
                end
                task.wait()
            end
        end)
        
        ragdollIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        ragdollStatus.Text = "Ragdoll: Done"
        task.wait(2)
        ragdollIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ragdollStatus.Text = "Ragdoll: OFF"
    else
        ragdollIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ragdollStatus.Text = "Ragdoll: Error"
        task.wait(2)
        ragdollStatus.Text = "Ragdoll: OFF"
    end
end

local function getCameraTargetPosition()
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local raycastResult = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * 500, raycastParams)
    
    if raycastResult then
        return raycastResult.Position
    else
        return camera.CFrame.Position + camera.CFrame.LookVector * 500
    end
end

local function teleportToCenter()
    if not tpEnabled then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    
    if rootPart then
        rootPart.CFrame = CFrame.new(getCameraTargetPosition())
    end
end

local function createESPForPlayer(plr)
    if espElements[plr] or plr == player then return end
    
    local function updateESP()
        local character = plr.Character
        if not character then return end
        
        local head = character:FindFirstChild("Head")
        if not head then return end
        
        if espElements[plr] then
            espElements[plr]:Destroy()
            espElements[plr] = nil
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_"..plr.Name
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = espFolder
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboard
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Text = plr.DisplayName or plr.Name
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.TextStrokeTransparency = 0.3
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 16
        textLabel.TextScaled = true
        
        espElements[plr] = billboard
    end
    
    if plr.Character then
        updateESP()
    end
    
    plr.CharacterAdded:Connect(updateESP)
    plr.CharacterRemoving:Connect(function()
        if espElements[plr] then
            espElements[plr]:Destroy()
            espElements[plr] = nil
        end
    end)
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then
                createESPForPlayer(plr)
            end
        end
        
        game.Players.PlayerAdded:Connect(function(plr)
            if plr ~= player then
                createESPForPlayer(plr)
            end
        end)
        
        game.Players.PlayerRemoving:Connect(function(plr)
            if espElements[plr] then
                espElements[plr]:Destroy()
                espElements[plr] = nil
            end
        end)
        
        espIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        espStatus.Text = "ESP: ON"
        espButton.Text = "Disable"
    else
        for _, element in pairs(espElements) do
            element:Destroy()
        end
        espElements = {}
        
        espIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        espStatus.Text = "ESP: OFF"
        espButton.Text = "ESP"
    end
end

local function toggleFOV()
    fovEnabled = not fovEnabled
    camera.FieldOfView = fovEnabled and boostedFOV or normalFOV
    
    if fovEnabled then
        fovIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        fovStatus.Text = "FOV: ON ("..boostedFOV..")"
        fovButton.Text = "Disable"
    else
        fovIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        fovStatus.Text = "FOV: OFF"
        fovButton.Text = "FOV"
    end
end

local function toggleTP()
    tpEnabled = not tpEnabled
    
    if tpEnabled then
        tpIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        tpStatus.Text = "TP: ON"
        tpButton.Text = "Disable"
    else
        tpIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        tpStatus.Text = "TP: OFF"
        tpButton.Text = "TP"
    end
end

local function toggleGUI()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
end

fovButton.MouseButton1Click:Connect(toggleFOV)
tpButton.MouseButton1Click:Connect(toggleTP)
espButton.MouseButton1Click:Connect(toggleESP)
ragdollButton.MouseButton1Click:Connect(activateRagdoll)
thirdPersonButton.MouseButton1Click:Connect(toggleThirdPerson)
antiGrabButton.MouseButton1Click:Connect(toggleAntiGrab)
autoResetButton.MouseButton1Click:Connect(toggleAutoReset)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        toggleFOV()
    elseif input.KeyCode == Enum.KeyCode.Z then
        teleportToCenter()
    elseif input.KeyCode == Enum.KeyCode.C then
        activateRagdoll()
    elseif input.KeyCode == Enum.KeyCode.V then
        toggleThirdPerson()
    elseif input.KeyCode == Enum.KeyCode.L then
        toggleGUI()
    elseif input.KeyCode == Enum.KeyCode.Tab then
        switchTab(currentPage == 1 and 2 or 1)
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if fovEnabled then
        camera.FieldOfView = boostedFOV
    end
    if thirdPersonEnabled then
        player.CameraMode = Enum.CameraMode.Classic
        player.CameraMaxZoomDistance = 100
    end
end)

print("PANAMERA v6.0 Loaded!")
print("[R] FOV | [Z] TP | [C] Ragdoll | [V] 3rd Person")
print("[L] Hide GUI | [Tab] Switch Page")