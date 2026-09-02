-- ver: 01.02.26
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/katnaa-debug/solarisobf/refs/heads/main/solarisui.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
local S = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    UserInputService = game:GetService("UserInputService"),
    Workspace = game:GetService("Workspace"),
    CoreGui = game:GetService("CoreGui"),
    TweenService = game:GetService("TweenService"),
    TextService = game:GetService("TextService")
}
local LocalPlayer = S.Players.LocalPlayer
local RAGDOLL_LIMBS = {"Left Leg", "Right Leg", "Left Arm", "Right Arm"}
local Features = {
    Selected = {
        kickPlayer = nil,
        players = {},
        multiSelect = false,
        currentPlayer = nil,
        currentButton = nil
    },
    Teleport = {
        loop = {
            enabled = false,
            target = CFrame.new(3, -7, -2),
            loopThread = nil
        },
        houses = {
            {"Pink House", CFrame.new(-491, -7, -166)},
            {"Green House", CFrame.new(-535, -7, 93)},
            {"Purple House", CFrame.new(250, -6, 463)},
            {"China House", CFrame.new(554, 123, -72)},
            {"Blue House", CFrame.new(510, 83, -339)},
            {"Spawn", CFrame.new(3, -7, -2)}
        }
    },
    Speed = {
        value = 16,
        min = 16,
        max = 10000,
        enabled = false,
        originalWalkSpeed = nil,
        connection = nil
    },
    ThirdPerson = {
        enabled = false
    },
    PCLD = {
        Enabled = false,
        Boxes = {},
        NameTags = {},
        Connections = {}
    },
    PacketLag = {
        enabled = false,
        loopThread = nil,
        packetSize = 100,
        minSize = 100,
        maxSize = 1000000
    },
    KickNotify = {
        enabled = false,
        connection = nil,
        notifications = {},
        notificationQueue = {},
        processedKicks = {}
    },
    Gucci = {
        active = false,
        blobman = nil,
        connection = nil,
        remotes = {}
    },
    GucciTractor = {
        enabled = false,
        busy = false,
        currentTractor = nil,
        seatMonitorConn = nil,
        loopThread = nil
    },
    AntiLag = {
        enabled = false
    },
    RemoveAntiKick = {
        enabled = false,
        targetPlayer = nil,
        loopThread = nil
    },
    AntiGrab = {
        enabled = false,
        antiGrabEnabled = false
    },
    SafePos = {
        enabled = false,
        target = nil,
        loopThread = nil
    },
    AutoSitBlob = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil
    },
    AntiKickReset = {
        enabled = false,
        connection = nil
    },
    AntiStick = {
        enabled = false,
        loopThread = nil
    },
    AntiKickStick = {
        enabled = false,
        loopThread = nil,
        selectedItem = "NinjaShuriken",
        items = {
            "NinjaShuriken",
            "NinjaKunai",
            "ToolPencil",
            "ToolPickaxe",
            "ToolDiggingForkRusty",
            "ToolCleaver",
            "NinjaKatana"
        }
    },
    LoopKick = {
        enabled = false,
        loopThread = nil
    },
    PermanentPallet = {
        enabled = false,
        loopThread = nil,
        currentPallet = nil,
        isReady = false
    },
    RagdollAura = {
        enabled = false,
        loopThread = nil,
        ragdolledPlayers = {},
        isTeleportingPallet = false
    },
    RagdollLoopKick = {
        enabled = false,
        loopThread = nil,
        savedPos = nil,
        dragging = false,
        grabStart = 0
    },
    SelfGrab = {
        enabled = false,
        loopThread = nil,
        MyBlob = nil,
        OriginalMassless = nil,
        OriginalPosition = nil,
        WasGrabbedByEnemy = false,
        ProcessingGrab = false,
        ProcessingRelease = false,
        GrabCooldown = 0,
        RegrabActive = false,
        SpawningBlob = false
    },
    BlobKill = {
        enabled = false,
        selectedPlayers = {},
        loopThread = nil,
        barrierThread = nil,
        currentBlob = nil
    },
    BlobKickDual = {
        enabled = false,
        loopThread = nil,
        bp = nil,
        lastTargetChar = nil
    },
    Fly = {
        Enabled = false,
        Speed = 100,
        BV = nil,
        BG = nil,
        Connections = {}
    },
    ServerLag = {
        enabled = false,
        loopThread = nil
    },
    AntiInputLag = {
        enabled = false,
        loopThread = nil,
        currentItem = nil,
        selectedItem = "FoodHamburger",
        items = {
            "FoodHamburger",
            "InstrumentDrumBongos",
            "InstrumentBrassTrumpet",
            "InstrumentBrassBugle",
            "InstrumentVoiceMicrophone",
            "InstrumentWoodwindOcarina",
            "InstrumentGuitarUkulele",
            "InstrumentGuitarLyre",
            "InstrumentGuitarBanjo",
            "InstrumentGuitarAcoustic",
            "CupMugBrown",
            "CupMugWhite",
            "FoodBanana",
            "FoodBread",
            "FoodBroccoli",
            "FoodCakePink",
            "FoodCoconut",
            "FoodDippyEgg",
            "FoodDonut",
            "FoodFrenchFries",
            "FoodHotdog",
            "FoodMayonnaise",
            "FoodMeatStick",
            "FoodMushroomPoison",
            "FoodPizzaCheese",
            "FoodPizzaPepperoni",
            "FoodSodaCan",
            "PoopPile",
            "PoopPileSparkle"
        }
    },
    AntiRagdoll = {
        enabled = false,
        connections = {},
        ragdolledSit = false
    },
    KillAura = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        spawningBlob = false,
        killCooldown = {},
        targetPlayers = {},
        lastKillTime = 0
    },
    AntiBlob = {
        enabled = false,
        loopThread = nil,
        processedPlayers = {}
    },
    WaterWalk = {
        enabled = false,
        waterParts = {},
        originalStates = {}
    },
    AntiBurn = {
        enabled = false,
        connection1 = nil,
        connection2 = nil,
        currentBarrier = nil
    },
    AntiVoid = {
        enabled = false,
        loopThread = nil,
        originalDestroyHeight = -100
    },
    AntiPaint = {
        enabled = false,
        connection = nil
    },
    AdvancedDuallock = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        targetPlayer = nil
    },
    LoopSnowball = {
        enabled = false,
        loopThread = nil,
        currentSnowball = nil,
        soundPart = nil,
        selectedPlayer = nil
    },
    DestroyKickAura = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        processedPlayers = {},
        spawnInterval = 0,
        isSpawning = false,
        lastSpawnTime = 0
    },
    DeleteLegs = {
        enabled = false,
        monitoringThread = nil,
        hipHeightAdjusted = false
    },
    AntiExplode = {
        enabled = false,
        connection = nil,
        bombEvent = nil
    },
    AutoGucci = {
        enabled = false,
        monitoringThread = nil,
        connection = nil,
        safePosition = nil,
        restoreFrames = 0
    },
    AntiBananaEat = {
        enabled = false,
        loopThread = nil,
        scanConnection = nil,
        processedBananas = {},
        processedFolders = {}
    },
    AntiAntiInput = {
        enabled = false,
        loopThread = nil,
        scanConnection = nil,
        processedItems = {},
        processedFolders = {}
    },
    AntiBarrier = {
        enabled = false,
        originalStates = {}
    },
    AntiInvisible = {
        enabled = false,
        loopThread = nil
    },
    SantaSleighGucci = {
        enabled = false
    },
    Noclip = {
        enabled = false,
        connection = nil,
        parts = {}
    },
    JumpKickAura = {
        enabled = false,
        loopThread = nil,
        processedPlayers = {}
    },
    KickAuraFixed = {
        enabled = false,
        loopThread = nil,
        fixedPlayers = {}
    }
}

local KickNotify = Features.KickNotify
local TeleportCfg = Features.Teleport
local SpeedCfg = Features.Speed
local AntiGrabCfg = Features.AntiGrab
local SafePosCfg = Features.SafePos
local AutoSitCfg = Features.AutoSitBlob
local AntiKickResetCfg = Features.AntiKickReset
local AntiKickStickCfg = Features.AntiKickStick
local LoopKickCfg = Features.LoopKick
local PermanentPalletCfg = Features.PermanentPallet
local RagdollAuraCfg = Features.RagdollAura
local RagdollLoopKickCfg = Features.RagdollLoopKick
local SelfGrabCfg = Features.SelfGrab
local BlobKillCfg = Features.BlobKill
local BlobKickDualCfg = Features.BlobKickDual
local ServerLagCfg = Features.ServerLag
local AntiInputLagCfg = Features.AntiInputLag
local AntiRagdollCfg = Features.AntiRagdoll
local KillAuraCfg = Features.KillAura
local AntiBlobCfg = Features.AntiBlob
local AntiBurnCfg = Features.AntiBurn
local AntiVoidCfg = Features.AntiVoid
local AntiPaintCfg = Features.AntiPaint
local AdvancedDuallockCfg = Features.AdvancedDuallock
local LoopSnowballCfg = Features.LoopSnowball
local DestroyKickAuraCfg = Features.DestroyKickAura
local DeleteLegsCfg = Features.DeleteLegs
local AutoGucciCfg = Features.AutoGucci
local AntiAntiInputCfg = Features.AntiAntiInput
local AntiBarrierCfg = Features.AntiBarrier
local AntiInvisibleCfg = Features.AntiInvisible
local NoclipCfg = Features.Noclip
local JumpKickAuraCfg = Features.JumpKickAura
local KickAuraFixedCfg = Features.KickAuraFixed
local findFirstChild = function(parent, name)
    if not parent then
        return nil
    end
    return parent:FindFirstChild(name)
end

local Window = UI:CreateWindow({
    Transparency = 0.15,
    Title = "Amethyst premium",
    ShowWatermark = true,
    Theme = "Void",
    ToggleKey = Enum.KeyCode.RightShift
})

local function Notify(title, content, duration)
    Window:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3
    })
end

local function PlaySound(soundId, delayTime)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        task.delay(delayTime, function()
            if sound and sound.IsPlaying then
                sound:Stop()
                sound:Destroy()
            end
        end)
    end)
end

local function PlayEnableSound()
    PlaySound("8745692251", 3)
end

local function PlayKickSound()
    PlaySound("5463227301", 4.7)
end

local function GetCharHumanoid()
    local character = LocalPlayer and LocalPlayer.Character
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

local function ApplySpeed(dt)
    if not SpeedCfg.enabled then
        return
    end
    local character = LocalPlayer.Character
    if not character then
        return
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then
        return
    end
    humanoid.WalkSpeed = SpeedCfg.value
    local move = humanoid.MoveDirection
    if move.Magnitude > 0 then
        local delta = move.Unit * SpeedCfg.value * dt * 0.1
        root.CFrame = root.CFrame + Vector3.new(delta.X, 0, delta.Z)
    end
end

task.spawn(function()
    print("[AMETHYST] Ожидание загрузки игры...")
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    if not game.Players.LocalPlayer then
        task.wait(.1)
        if game.Players.LocalPlayer then
            local lp = game.Players.LocalPlayer
            if not lp.Character then
                lp.CharacterAdded:Wait()
            end
            task.wait(3)
            print("[AMETHYST] ===== АКТИВАЦИЯ ВСЕХ ЗАЩИТНЫХ ФУНКЦИЙ =====")

            pcall(function()
                print("[AMETHYST] Запуск Kick Notify...")
                local ui = Instance.new("ScreenGui")
                ui.Name = "KickNotifyUI"
                ui.Parent = S.CoreGui

                local notifications = {}
                local notificationTimes = {}
                local retentionTime = 30

                local function canNotify(key)
                    if not notificationTimes[key] then
                        return true
                    end
                    if tick() - notificationTimes[key] > retentionTime then
                        notificationTimes[key] = nil
                        return true
                    end
                    return false
                end

                local function showKickNotify(ownerName, displayName)
                    if not canNotify(ownerName) then
                        return
                    end
                    notificationTimes[ownerName] = tick()
                    local frame = Instance.new("Frame")
                    frame.Name = "KickNotification_" .. ownerName .. "_" .. tick()
                    frame.Size = UDim2.new(0, 300, 0, 80)
                    for _, existing in ipairs(notifications) do
                        if existing then
                            existing.Parent = existing.Parent
                        end
                    end
                    frame.Position = UDim2.new(1, -320, 0, 80)
                    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    frame.BackgroundTransparency = .1
                    frame.BorderSizePixel = 0
                    frame.Parent = ui
                    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
                    local stroke = Instance.new("UIStroke", frame)
                    stroke.Color = Color3.fromRGB(180, 180, 180)
                    stroke.Thickness = 2
                    stroke.Transparency = .3
                    local title = Instance.new("TextLabel")
                    title.Size = UDim2.new(1, -20, 0, 20)
                    title.Position = UDim2.new(0, 10, 0, 8)
                    title.BackgroundTransparency = 1
                    title.Text = "KICK DETECTED"
                    title.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title.Font = Enum.Font.GothamBold
                    title.TextSize = 16
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.Parent = frame
                    local victim = Instance.new("TextLabel")
                    victim.Size = UDim2.new(1, -20, 0, 24)
                    victim.Position = UDim2.new(0, 10, 0, 30)
                    victim.BackgroundTransparency = 1
                    victim.Text = displayName .. " (" .. ownerName .. ")"
                    victim.TextColor3 = Color3.fromRGB(255, 255, 255)
                    victim.Font = Enum.Font.GothamSemibold
                    victim.TextSize = 14
                    victim.TextXAlignment = Enum.TextXAlignment.Left
                    victim.Parent = frame
                    local subtitle = Instance.new("TextLabel")
                    subtitle.Size = UDim2.new(1, -20, 0, 20)
                    subtitle.Position = UDim2.new(0, 10, 0, 54)
                    subtitle.BackgroundTransparency = 1
                    subtitle.Text = "went to heaven"
                    subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                    subtitle.Font = Enum.Font.Gotham
                    subtitle.TextSize = 12
                    subtitle.TextXAlignment = Enum.TextXAlignment.Left
                    subtitle.Parent = frame
                    table.insert(notifications, frame)
                    pcall(function()
                        local sound = Instance.new("Sound")
                        sound.SoundId = "rbxassetid://5463227301"
                        sound.Volume = 0.5
                        sound.Parent = game:GetService("SoundService")
                        sound:Play()
                        task.delay(4.7, function()
                            if sound and sound.IsPlaying then
                                sound:Stop()
                                sound:Destroy()
                            end
                        end)
                    end)
                    frame.BackgroundTransparency = .8
                    local tween = game:GetService("TweenService")
                    tween:Create(frame, TweenInfo.new(.3), { BackgroundTransparency = .1 }):Play()
                    task.delay(4.7, function()
                        if frame and frame.Parent then
                            tween:Create(frame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
                            task.wait(0.5)
                            frame:Destroy()
                            for i, v in ipairs(notifications) do
                                if v == frame then
                                    table.remove(notifications, i)
                                end
                            end
                        end
                    end)
                end

                local function cleanupNotifications()
                    local dead = {}
                    for i, v in ipairs(notifications) do
                        if not v or not v.Parent then
                            table.insert(dead, i)
                        end
                    end
                    for i = #dead, 1, -1 do
                        table.remove(notifications, dead[i])
                    end
                end

                S.Workspace.ChildAdded:Connect(function(child)
                    if child.Name == "BlackHoleKick" or child.Name == "BlackHole" then
                        child.Name = "BlackHole_Detected_" .. tick()
                        local snapshot = {}
                        for _, p in pairs(S.Players:GetPlayers()) do
                            if p ~= LocalPlayer then
                                snapshot[p.Name] = p.DisplayName
                            end
                        end
                        task.wait(3.25)
                        local present = {}
                        for _, p in pairs(S.Players:GetPlayers()) do
                            present[p.Name] = true
                        end
                        local left = {}
                        for name, display in pairs(snapshot) do
                            if not present[name] then
                                table.insert(left, { name = name, display = display })
                            end
                        end
                        if #left > 0 then
                            for _, info in ipairs(left) do
                                cleanupNotifications()
                                showKickNotify(info.name, info.display)
                                task.wait(.1)
                            end
                        end
                    end
                end)

                print("[AMETHYST] Packet Lag Notify активен")
                local packetLagCooldowns = {}
                local function setupPacketLagNotify()
                    local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                    local extendRemote = grabEvents:FindFirstChild("ExtendGrabLine")
                    if not extendRemote then
                        return
                    end
                    extendRemote.OnClientEvent:Connect(function(p, data)
                        if not p then
                            return
                        end
                        local force = 0
                        if type(data) == "table" then
                            for _, v in pairs(data) do
                                if type(v) == "number" then
                                    force = force + math.abs(v)
                                elseif type(v) == "string" then
                                    force = force + #v
                                end
                            end
                        elseif type(data) == "number" then
                            force = math.abs(data)
                        elseif type(data) == "string" then
                            force = #data
                        end
                        local key = p.Name
                        if force > 100 and force < 20000000 then
                            if not packetLagCooldowns[key] or tick() - packetLagCooldowns[key] > 30 then
                                packetLagCooldowns[key] = tick()
                                cleanupNotifications()
                                local frame = Instance.new("Frame")
                                frame.Name = "PacketLagNotification_" .. key .. "_" .. tick()
                                frame.Size = UDim2.new(0, 300, 0, 80)
                                for _, existing in ipairs(notifications) do
                                    if existing then
                                        existing.Parent = existing.Parent
                                    end
                                end
                                frame.Position = UDim2.new(1, -320, 0, 80)
                                frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                                frame.BackgroundTransparency = .1
                                frame.BorderSizePixel = 0
                                frame.Parent = ui
                                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
                                local stroke = Instance.new("UIStroke", frame)
                                stroke.Color = Color3.fromRGB(200, 200, 200)
                                stroke.Thickness = 2
                                stroke.Transparency = .3
                                local title = Instance.new("TextLabel")
                                title.Size = UDim2.new(1, -20, 0, 20)
                                title.Position = UDim2.new(0, 10, 0, 8)
                                title.BackgroundTransparency = 1
                                title.Text = "PACKET LAG DETECTED"
                                title.TextColor3 = Color3.fromRGB(255, 255, 255)
                                title.Font = Enum.Font.GothamBold
                                title.TextSize = 16
                                title.TextXAlignment = Enum.TextXAlignment.Left
                                title.Parent = frame
                                local victim = Instance.new("TextLabel")
                                victim.Size = UDim2.new(1, -20, 0, 24)
                                victim.Position = UDim2.new(0, 10, 0, 30)
                                victim.BackgroundTransparency = 1
                                victim.Text = p.DisplayName .. " (" .. key .. ")"
                                victim.TextColor3 = Color3.fromRGB(255, 255, 255)
                                victim.Font = Enum.Font.GothamSemibold
                                victim.TextSize = 14
                                victim.TextXAlignment = Enum.TextXAlignment.Left
                                victim.Parent = frame
                                local forceText = ""
                                if force > 1000000 then
                                    forceText = string.format("%.1fM", force / 1000000)
                                elseif force > 1000 then
                                    forceText = string.format("%.1fK", force / 1000)
                                else
                                    forceText = tostring(force)
                                end
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1, -20, 0, 20)
                                label.Position = UDim2.new(0, 10, 0, 54)
                                label.BackgroundTransparency = 1
                                label.Text = "Force: " .. forceText .. " packets"
                                label.TextColor3 = Color3.fromRGB(200, 200, 200)
                                label.Font = Enum.Font.Gotham
                                label.TextSize = 12
                                label.TextXAlignment = Enum.TextXAlignment.Left
                                label.Parent = frame
                                table.insert(notifications, frame)
                                pcall(function()
                                    local sound = Instance.new("Sound")
                                    sound.SoundId = "rbxassetid://8745692251"
                                    sound.Volume = 0.5
                                    sound.Parent = game:GetService("SoundService")
                                    sound:Play()
                                    task.delay(3, function()
                                        if sound and sound.IsPlaying then
                                            sound:Stop()
                                            sound:Destroy()
                                        end
                                    end)
                                end)
                                frame.BackgroundTransparency = .8
                                local tween = game:GetService("TweenService")
                                tween:Create(frame, TweenInfo.new(.3), { BackgroundTransparency = .1 }):Play()
                                task.delay(5, function()
                                    if frame and frame.Parent then
                                        tween:Create(frame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
                                        task.wait(0.5)
                                        frame:Destroy()
                                        for i, v in ipairs(notifications) do
                                            if v == frame then
                                                table.remove(notifications, i)
                                            end
                                        end
                                    end
                                end)
                                print("[PACKET LAG] Обнаружен: " .. key .. " | Сила: " .. forceText .. " | Сырое значение: " .. tostring(force))
                            end
                        end
                    end)
                end
                setupPacketLagNotify()
                S.ReplicatedStorage.ChildAdded:Connect(function(child)
                    if child.Name == "GrabEvents" then
                        task.wait(1)
                        print("[PACKET LAG] Переподключаю GrabEvents...")
                        setupPacketLagNotify()
                    end
                end)
                print("[AMETHYST] ✅ Kick Notify + Packet Lag активирован")
            end)

            task.wait()
            pcall(function()
                LocalPlayer.CameraMaxZoomDistance = 1250
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
                print("[AMETHYST] ✅ Third Person разблокирована")
            end)

            task.wait()
            pcall(function()
                Features.AntiLag.enabled = true
                if LocalPlayer and LocalPlayer.PlayerScripts then
                    local script = LocalPlayer.PlayerScripts:FindFirstChild("CharacterAndBeamMove")
                    if script then
                        script.Enabled = false
                    end
                end
                print("[AMETHYST] ✅ Anti Lag активен")
            end)

            task.wait()
            pcall(function()
                Features.AntiKickReset.enabled = true
                local corrections = S.ReplicatedStorage:FindFirstChild("GameCorrectionEvents")
                if corrections then
                    local notify = S.ReplicatedStorage:FindFirstChild("GameCorrectionsNotify")
                    if notify and notify:IsA("RemoteEvent") then
                        Features.AntiKickReset.connection = notify.OnClientEvent:Connect(function(msg)
                            if msg == "Flying" then
                                local char = LocalPlayer.Character
                                if char then
                                    local humanoid = char:FindFirstChild("Humanoid")
                                    if humanoid then
                                        humanoid.Health = 0
                                    end
                                end
                            end
                        end)
                    end
                end
                print("[AMETHYST] ✅ Anti Kick Reset активен")
            end)

            task.wait()
            pcall(function()
                Features.AntiBarrier.enabled = true
                Features.AntiBarrier.originalStates = {}
                task.spawn(function()
                    while true do
                        local plots = S.Workspace:FindFirstChild("Plots")
                        if plots then
                            for _, plot in ipairs(plots:GetChildren()) do
                                local barrier = plot:FindFirstChild("Barrier")
                                if barrier then
                                    for _, part in ipairs(barrier:GetChildren()) do
                                        if part:IsA("BasePart") and part.Name == "PlotBarrier" then
                                            Features.AntiBarrier.originalStates[part] = part.CanCollide
                                            part.CanCollide = false
                                        end
                                    end
                                end
                            end
                            task.wait(2)
                        end
                        task.wait(0.1)
                    end
                end)
                print("[AMETHYST] ✅ Anti Barrier активен")
            end)

            task.wait(0.5)
            pcall(function()
                Features.AntiBurn.enabled = true
                local function setup()
                    local char = LocalPlayer.Character
                    if not char then
                        return
                    end
                    local humanoid = char:FindFirstChild("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not humanoid or not root then
                        return
                    end
                    local plot1 = S.Workspace.Plots:FindFirstChild("Plot1")
                    local barrier = plot1 and plot1:FindFirstChild("Barrier")
                    local plotBarrier = barrier and barrier:FindFirstChild("PlotBarrier")
                    if not plotBarrier then
                        return
                    end
                    Features.AntiBurn.currentBarrier = plotBarrier
                    if Features.AntiBurn.connection1 then
                        Features.AntiBurn.connection1:Disconnect()
                    end
                    Features.AntiBurn.connection1 = humanoid.FireDebounce.Changed:Connect(function()
                        if humanoid.FireDebounce.Value == true then
                            task.spawn(function()
                                if not humanoid.FireDebounce.Value then
                                    task.wait()
                                    plotBarrier.CFrame = root.CFrame
                                    if not humanoid.FireDebounce.Value or not Features.AntiBurn.enabled then
                                        return
                                    end
                                end
                            end)
                            task.wait(1)
                            if Features.AntiBurn.enabled then
                                humanoid.FireDebounce.Value = false
                                task.wait()
                                plotBarrier.CFrame = plotBarrier.CFrame
                            end
                        end
                    end)
                end
                if LocalPlayer.Character then
                    setup()
                end
                LocalPlayer.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if Features.AntiBurn.enabled then
                        setup()
                    end
                end)
                print("[AMETHYST] ✅ Anti Burn активен")
            end)

            task.wait(0.5)
            pcall(function()
                Features.AntiVoid.enabled = true
                Features.AntiVoid.originalDestroyHeight = S.Workspace.FallenPartsDestroyHeight
                S.Workspace.FallenPartsDestroyHeight = -50000
                task.spawn(function()
                    while Features.AntiVoid.enabled do
                        if LocalPlayer.Character then
                            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if root and root.Position.Y < -400 then
                                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
                            end
                        end
                        task.wait(.1)
                    end
                end)
                print("[AMETHYST] ✅ Anti Void активен")
            end)

            task.wait(0.5)
            pcall(function()
                Features.AntiPaint.enabled = true
                for _, p in pairs(S.Players:GetPlayers()) do
                    local folder = S.Workspace:FindFirstChild(p.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            local name = toy.Name
                            if name == "BucketPaint" or name == "FoodHotSauce" or name == "ToiletGold" or name == "ToiletWhite" then
                                task.spawn(function()
                                    for _, child in pairs(toy:GetChildren()) do
                                        if child.Name == "PaintPlayerPart" or child.Name == "FirePlayerPart" then
                                            child:Destroy()
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
                Features.AntiPaint.connection = S.Workspace.DescendantAdded:Connect(function(desc)
                    if desc.Name == "PaintPlayerPart" or desc.Name == "FirePlayerPart" then
                        local parent = desc.Parent
                        if parent then
                            local name = parent.Name
                            if name == "BucketPaint" or name == "FoodHotSauce" or name == "ToiletGold" or name == "ToiletWhite" then
                                task.wait(.1)
                                if desc then
                                    desc:Destroy()
                                end
                            end
                        end
                    end
                end)
                print("[AMETHYST] ✅ Anti Paint активен")
            end)

            task.wait(0.5)
            pcall(function()
                Features.AntiExplode.enabled = true
                local function findBombEvent(folder)
                    for _, desc in ipairs(folder:GetChildren()) do
                        if desc:IsA("RemoteEvent") and string.find(string.lower(desc.Name), "bomb") then
                            return desc
                        end
                    end
                    for _, desc in ipairs(folder:GetChildren()) do
                        if #desc:GetChildren() > 0 then
                            local found = findBombEvent(desc)
                            if found then
                                return found
                            end
                        end
                    end
                    return nil
                end
                Features.AntiExplode.bombEvent = findBombEvent(S.ReplicatedStorage)
                if Features.AntiExplode.bombEvent then
                    Features.AntiExplode.connection = Features.AntiExplode.bombEvent.OnClientEvent:Connect(function(info, position)
                        if not Features.AntiExplode.enabled then
                            return
                        end
                        local char = LocalPlayer.Character
                        if not char then
                            return
                        end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not root or not humanoid then
                            return
                        end
                        task.spawn(function()
                            local radius = (info and info.Radius) or 20
                            if radius + 10 > (position - root.Position).Magnitude then
                                root.Anchored = true
                                task.wait(.05)
                                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                root.Anchored = false
                                for i = 1, 4 do
                                    local limb = char:FindFirstChild(RAGDOLL_LIMBS[i])
                                    if limb then
                                        local ragLimb = limb:FindFirstChild("RagdollLimbPart")
                                        if ragLimb then
                                            ragLimb.CanCollide = false
                                        end
                                    end
                                end
                                root.AssemblyLinearVelocity = Vector3.zero
                                root.AssemblyAngularVelocity = Vector3.zero
                                root.Velocity = Vector3.zero
                                root.RotVelocity = Vector3.zero
                                task.delay(1.5, function()
                                    if char and char.Parent then
                                        for i = 1, 4 do
                                            local limb = char:FindFirstChild(RAGDOLL_LIMBS[i])
                                            if limb then
                                                local ragLimb = limb:FindFirstChild("RagdollLimbPart")
                                                if ragLimb then
                                                    ragLimb.CanCollide = true
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end)
                    end)
                    print("[AMETHYST] ✅ Anti Explode активен")
                end
            end)

            task.wait(0.5)
            pcall(function()
                Features.AntiInvisible.enabled = true
                task.spawn(function()
                    while Features.AntiInvisible.enabled do
                        for _, p in ipairs(S.Players:GetPlayers()) do
                            local char = p.Character
                            if char and char:IsDescendantOf(S.Workspace) then
                                for _, part in ipairs(char:GetChildren()) do
                                    if part:IsA("BasePart") and part.Massless == true then
                                        part.Massless = false
                                    end
                                end
                                local folder = S.Workspace:FindFirstChild(p.Name .. "SpawnedInToys")
                                if folder then
                                    for _, model in ipairs(folder:GetChildren()) do
                                        if model:IsA("Model") then
                                            for _, part in ipairs(model:GetDescendants()) do
                                                if part:IsA("BasePart") and part.Massless == true then
                                                    part.Massless = false
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(3)
                    end
                end)
                print("[AMETHYST] ✅ Anti-Invisible активен")
            end)

            task.wait(0.5)
            pcall(function()
                if Features.AntiBananaEat then
                    Features.AntiBananaEat.enabled = true
                    Features.AntiBananaEat.processedBananas = Features.AntiBananaEat.processedBananas or {}
                    Features.AntiBananaEat.processedFolders = Features.AntiBananaEat.processedFolders or {}
                    print("[AMETHYST] ✅ Anti Banana Eat активен")
                end
            end)

            task.wait()
            pcall(function()
                if Features.AntiAntiInput then
                    Features.AntiAntiInput.enabled = true
                    Features.AntiAntiInput.processedItems = Features.AntiAntiInput.processedItems or {}
                    Features.AntiAntiInput.processedFolders = Features.AntiAntiInput.processedFolders or {}
                    print("[AMETHYST] ✅ Anti Anti Input активен")
                end
            end)
            task.wait(0)
        end
    end
end)

local function EnableSpeed()
    if SpeedCfg.enabled then
        return
    end
    local humanoid = GetCharHumanoid()
    if humanoid then
        SpeedCfg.originalWalkSpeed = humanoid.WalkSpeed
    end
    SpeedCfg.enabled = true
    if SpeedCfg.connection then
        SpeedCfg.connection:Disconnect()
        SpeedCfg.connection = nil
    end
    SpeedCfg.connection = S.RunService.Stepped:Connect(function(_, dt)
        ApplySpeed(dt)
    end)
    if SpeedCfg.charConnection then
        SpeedCfg.charConnection:Disconnect()
    end
    SpeedCfg.charConnection = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if SpeedCfg.enabled then
            EnableSpeed()
        end
    end)
end

local function DisableSpeed()
    SpeedCfg.enabled = false
    if SpeedCfg.connection then
        SpeedCfg.connection:Disconnect()
        SpeedCfg.connection = nil
    end
    if SpeedCfg.charConnection then
        SpeedCfg.charConnection:Disconnect()
        SpeedCfg.charConnection = nil
    end
    local humanoid = GetCharHumanoid()
    if humanoid then
        humanoid.WalkSpeed = SpeedCfg.originalWalkSpeed
    end
end

local PlayerTab = Window:CreateTab("Player")

PlayerTab:CreateSection("Player")

PlayerTab:CreateToggle({
    Name = "Loop Teleport",
    Default = false,
    Callback = function(state)
        if state then
            TeleportCfg.loop.enabled = true
            TeleportCfg.loop.loopThread = task.spawn(function()
                while TeleportCfg.loop.enabled do
                    if LocalPlayer.Character then
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and TeleportCfg.loop.target then
                            root.CFrame = TeleportCfg.loop.target
                        end
                        task.wait()
                    end
                end
            end)
            Notify("Loop TP", "Enabled - Looping to selected location")
            PlayEnableSound()
        else
            TeleportCfg.loop.enabled = false
            if TeleportCfg.loop.loopThread then
                task.cancel(TeleportCfg.loop.loopThread)
                TeleportCfg.loop.loopThread = nil
            end
            Notify("Loop TP", "Disabled")
        end
    end
})

local houseNames = {}
for _, house in ipairs(TeleportCfg.houses) do
    table.insert(houseNames, house[1])
end

PlayerTab:CreateDropdown({
    Name = "Teleport Location",
    Items = houseNames,
    Default = "Spawn",
    Callback = function(selected)
        for _, house in ipairs(TeleportCfg.houses) do
            if house[1] == selected then
                TeleportCfg.loop.target = house[2]
                break
            end
        end
    end
})

PlayerTab:CreateButton({
    Name = "Teleport Once",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and TeleportCfg.loop.target then
                root.CFrame = TeleportCfg.loop.target
                Notify("Teleport", "Teleported to selected location")
                PlayEnableSound()
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Teleport to Mouse (Z key)",
    Default = false,
    Callback = function(state)
        if state then
            if Features.TPToolConnection then
                Features.TPToolConnection:Disconnect()
            end
            Features.TPToolConnection = S.UserInputService.InputBegan:Connect(function(input, processed)
                if processed then
                    return
                end
                if input.KeyCode == Enum.KeyCode.Z then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local mouse = LocalPlayer:GetMouse()
                        if mouse.Target then
                            char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                        else
                            Notify("Teleport Error", "No target object to teleport to", 2)
                        end
                    end
                end
            end)
            Notify("Teleport Tool", "Enabled - Press Z to teleport to mouse target", 3)
            PlayEnableSound()
        else
            if Features.TPToolConnection then
                Features.TPToolConnection:Disconnect()
                Features.TPToolConnection = nil
            end
            Notify("Teleport Tool", "Disabled", 2)
        end
    end
})

PlayerTab:CreateSection("Speed player")

PlayerTab:CreateSlider({
    Name = "Speed Control",
    Min = 16,
    Max = 500,
    Default = 16,
    Callback = function(value)
        SpeedCfg.value = value
        if SpeedCfg.enabled then
            local humanoid = GetCharHumanoid()
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Enable Speed",
    Default = false,
    Callback = function(state)
        if state then
            EnableSpeed()
            Notify("Speed", "Enabled - WalkSpeed: " .. SpeedCfg.value)
            PlayEnableSound()
        else
            DisableSpeed()
            Notify("Speed", "Disabled")
        end
    end
})

PlayerTab:CreateSection("Visible player location")

PlayerTab:CreateToggle({
    Name = "PCLD ESP",
    Default = false,
    Callback = function()
        task.wait()
    end
})

PlayerTab:CreateSection("Other")

PlayerTab:CreateToggle({
    Name = "Hold Network Yourself",
    Default = false,
    Callback = function(state)
        if state then
            local networkData = {
                active = true,
                heartbeatConnection = nil,
                characterConnection = nil
            }
            local function startHeartbeat()
                networkData.heartbeatConnection = S.RunService.Heartbeat:Connect(function()
                    local char = game.Players.LocalPlayer.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            local remote = S.ReplicatedStorage.GrabEvents.SetNetworkOwner
                            remote:FireServer(remote, remote.CFrame)
                        end
                    end
                end)
            end
            startHeartbeat()
            networkData.characterConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function()
                if networkData.heartbeatConnection then
                    networkData.heartbeatConnection:Disconnect()
                end
                task.wait()
                if networkData.active then
                    startHeartbeat()
                end
            end)
            PlayerTab.NetworkData = networkData
            Notify("Hold Network Yourself", "Enabled", 2)
        else
            if PlayerTab.NetworkData then
                PlayerTab.NetworkData.active = false
                if PlayerTab.NetworkData.heartbeatConnection then
                    PlayerTab.NetworkData.heartbeatConnection:Disconnect()
                    PlayerTab.NetworkData.heartbeatConnection = nil
                end
                if PlayerTab.NetworkData.characterConnection then
                    PlayerTab.NetworkData.characterConnection:Disconnect()
                    PlayerTab.NetworkData.characterConnection = nil
                end
                PlayerTab.NetworkData = nil
            end
            Notify("Hold Network Yourself", "Disabled", 2)
        end
    end
})

local DefenseTab = Window:CreateTab("Defense")
DefenseTab:CreateSection("Break PCLD")

Features.AutoFaultLocation = {
    enabled = false,
    isFaulted = false
}
local AutoFaultCfg = Features.AutoFaultLocation

local function FaultLocation()
    local lp = LocalPlayer
    local char = lp.Character
    if char then
        local humanoid = char:WaitForChild("Humanoid")
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        local newChar = lp.CharacterAdded:Wait()
        local newHumanoid = newChar:WaitForChild("Humanoid")
        newHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
        AutoFaultCfg.isFaulted = true
        Notify("Fault Location", "PCLD faulted successfully", 3)
        PlayEnableSound()
        return true
    else
        lp.CharacterAdded:Wait()
    end
end

DefenseTab:CreateToggle({
    Name = "Auto Fault Location",
    Default = false,
    Callback = function(state)
        if state then
            AutoFaultCfg.enabled = true
            if not AutoFaultCfg.isFaulted then
                task.spawn(function()
                    FaultLocation()
                end)
            end
            local function setup(character)
                task.wait(0.5)
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(function()
                        if AutoFaultCfg.enabled then
                            AutoFaultCfg.isFaulted = false
                            task.wait(1)
                            if AutoFaultCfg.enabled then
                                FaultLocation()
                            end
                        end
                    end)
                end
            end
            local char = LocalPlayer.Character
            if char then
                setup(char)
            end
            LocalPlayer.CharacterAdded:Connect(function(character)
                if AutoFaultCfg.enabled then
                    setup(character)
                end
            end)
            Notify("Auto Fault Location", "Enabled - PCLD will auto-rebreak on death", 3)
            PlayEnableSound()
        else
            AutoFaultCfg.enabled = false
            AutoFaultCfg.isFaulted = false
            Notify("Auto Fault Location", "Disabled", 2)
        end
    end
})

DefenseTab:CreateButton({
    Name = "Fault My Location",
    Callback = function()
        local lp = LocalPlayer
        local char = lp.Character
        if char then
            local humanoid = char:WaitForChild("Humanoid")
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            local newChar = lp.CharacterAdded:Wait()
            local newHumanoid = newChar:WaitForChild("Humanoid")
            newHumanoid:ChangeState(Enum.HumanoidStateType.Dead)
            Notify("Fault Location", "Location faulted successfully", 3)
            PlayEnableSound()
        else
            lp.CharacterAdded:Wait()
        end
    end
})

DefenseTab:CreateSection("Gucci")

DefenseTab:CreateToggle({
    Name = "Auto Gucci Tractor",
    Default = false,
    Callback = function(state)
        if state then
            Features.AutoGucciTractor = Features.AutoGucciTractor or {}
            local agc = Features.AutoGucciTractor
            agc.enabled = true

            local function SpawnTractor()
                pcall(function()
                    S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
                        "TractorGreen",
                        CFrame.new(0, 500000, 0),
                        Vector3.new(0, 60, 0)
                    )
                end)
                local folder = S.Workspace:WaitForChild(LocalPlayer.Name .. "SpawnedInToys", 5)
                if folder and folder:FindFirstChild("TractorGreen") then
                    local tractor = folder.TractorGreen
                    if tractor:FindFirstChild("VehicleSeat") then
                        local seat = tractor.VehicleSeat
                        seat.CFrame = CFrame.new(0, 50000, 0) -- fedz gucci 💀 [[https://github.com/ndxzi/i-have-idea/blob/main/6961824067/Feds.luau]] 326
                        seat.Anchored = true
                    end
                    return tractor
                end
                return nil
            end

            local function ActivateGucci()
                local char = LocalPlayer.Character
                if not char then
                    char = LocalPlayer.CharacterAdded:Wait()
                end
                local humanoid = char:WaitForChild("Humanoid")
                local root = char:WaitForChild("HumanoidRootPart")
                agc.safePosition = root.Position
                local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                local tractor = folder and folder:FindFirstChild("TractorGreen")
                local seat = folder and folder:FindFirstChild("VehicleSeat")
                if not seat or not seat:IsA("VehicleSeat") then
                    return false
                end
                root.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
                seat:Sit(humanoid)
                humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
                    if humanoid.Jump and humanoid.Sit then
                        agc.restoreFrames = 15
                        agc.safePosition = root.Position
                    end
                end)
                if agc.connection then
                    agc.connection:Disconnect()
                end
                agc.connection = S.RunService.Heartbeat:Connect(function()
                    if not root or not humanoid then
                        return
                    end
                    S.ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(root, 0)
                    if agc.restoreFrames > 0 then
                        root.CFrame = CFrame.new(agc.safePosition)
                        agc.restoreFrames = agc.restoreFrames - 1
                    end
                end)
                task.spawn(function()
                    while humanoid.Sit do
                        task.wait()
                    end
                    task.wait(0.5)
                    if root then
                        root.CFrame = CFrame.new(agc.safePosition)
                    end
                end)
                return true
            end

            local function EnsureReady()
                local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                local tractor = folder and folder:FindFirstChild("TractorGreen")
                if tractor then
                    task.wait(.1)
                    local seat = tractor:FindFirstChild("VehicleSeat")
                    if seat and seat:IsA("VehicleSeat") then
                        if not agc.enabled then
                            return
                        end
                        if ActivateGucci() then
                            print("Auto Gucci Tractor: Tractor found, Gucci activated instantly")
                        end
                    end
                end
            end

            agc.monitoringThread = task.spawn(function()
                while agc.enabled do
                    local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                    local tractor = folder and folder:FindFirstChild("TractorGreen")
                    if not tractor then
                        if agc.connection then
                            agc.connection:Disconnect()
                            agc.connection = nil
                        end
                        SpawnTractor()
                        local tries = 0
                        while not folder and tries < 50 and agc.enabled do
                            folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                            if folder then
                                EnsureReady()
                            end
                            task.wait(.2)
                            tries = tries + 1
                        end
                        if folder then
                            folder:FindFirstChild("TractorGreen")
                        end
                    end
                    task.wait(0.5)
                end
            end)

            local function OnCharacterAdded(character)
                if not agc.enabled then
                    return
                end
                task.wait()
                local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                local tractor = folder and folder:FindFirstChild("TractorGreen")
                if tractor then
                    task.wait()
                    EnsureReady()
                else
                    SpawnTractor()
                    local tries = 0
                    while not folder and tries < 50 and agc.enabled do
                        folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                        if folder then
                            EnsureReady()
                            break
                        end
                        task.wait(.2)
                        tries = tries + 1
                    end
                    if folder then
                        folder:FindFirstChild("TractorGreen")
                    end
                end
            end

            if agc.characterAddedConnection then
                agc.characterAddedConnection:Disconnect()
            end
            agc.characterAddedConnection = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
            if LocalPlayer.Character then
                OnCharacterAdded(LocalPlayer.Character)
            end
            Notify("Auto Gucci Tractor", "Enabled - Tractor protection active")
            PlayEnableSound()
        else
            if Features.AutoGucciTractor then
                local agc = Features.AutoGucciTractor
                agc.enabled = false
                if agc.connection then
                    agc.connection:Disconnect()
                    agc.connection = nil
                end
                if agc.characterAddedConnection then
                    agc.characterAddedConnection:Disconnect()
                    agc.characterAddedConnection = nil
                end
                if agc.monitoringThread then
                    task.cancel(agc.monitoringThread)
                    agc.monitoringThread = nil
                end
                local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                if folder and folder:FindFirstChild("TractorGreen") then
                    folder.TractorGreen:Destroy()
                end
                agc.safePosition = nil
                agc.restoreFrames = 0
            end
            Notify("Auto Gucci Tractor", "Disabled")
        end
    end
})

DefenseTab:CreateButton({
    Name = "Gucci",
    Callback = function()
        pcall(function()
            local lp = LocalPlayer
            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then
                return false
            end
            local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
            if not folder then
                return false
            end
            local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
            local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
            if not lp.CanSpawnToy.Value then
                lp.CanSpawnToy.Changed:Wait()
            end
            task.spawn(function()
                spawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(5, 5, 20), Vector3.new(0, 0, 0))
            end)
            task.wait(.3)
            local blob = nil
            for _, toy in pairs(folder:GetChildren()) do
                if toy.Name == "CreatureBlobman" and toy.PrimaryPart and (toy.PrimaryPart.Position - root.Position).Magnitude < 30 then
                    blob = toy
                end
            end
            local plotSign = nil
            for i = 1, 5 do
                local plot = S.Workspace.Plots:FindFirstChild("Plot" .. i)
                if plot then
                    local owners = plot.PlotSign and plot.PlotSign:FindFirstChild("ThisPlotsOwners")
                    local value = owners and owners:FindFirstChild("Value")
                    if value and string.find(value.Value, lp.Name) then
                        plotSign = plot.PlotSign
                    end
                end
            end
            if blob then
                blob = S.Workspace.PlotItems[blob.Name]:FindFirstChild("CreatureBlobman") or S.Workspace.PlotItems[blob.Name]:WaitForChild("CreatureBlobman", 0.5)
            end
            if not blob then
                return false
            end
            local vehicleSeat = blob:WaitForChild("VehicleSeat", 3)
            if not vehicleSeat then
                return false
            end
            vehicleSeat:Sit(lp.Character.Humanoid)
            task.spawn(function()
                while tick() < tick() + 3 do
                    ragdollRemote:FireServer(root, 0)
                    task.wait()
                end
            end)
            task.wait()
            local tries = 0
            while vehicleSeat.Occupant ~= lp.Character.Humanoid do
                if tries > 10 then
                    return false
                end
                task.wait()
                tries = tries + 1
            end
            lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(.2)
            vehicleSeat.CFrame = CFrame.new(0, 1000000000, 0) --??😭
        end)
        Notify("Gucci", "Activated Gucci protection")
        PlayEnableSound()
    end
})

DefenseTab:CreateButton({
    Name = "Gucci Train",
    Callback = function()
        pcall(function()
            local lp = LocalPlayer
            local char = lp.Character
            if not char then
                char = lp.CharacterAdded:Wait()
            end
            local humanoid = char:WaitForChild("Humanoid")
            local root = char:WaitForChild("HumanoidRootPart")
            local tweened = S.Workspace.Map:FindFirstChild("AlwaysHereTweenedObjects")
            if not tweened then
                return false
            end
            local train = tweened:FindFirstChild("Train")
            if not train then
                return false
            end
            local seat = nil
            for _, desc in ipairs(train:GetDescendants()) do
                if desc:IsA("Seat") then
                    seat = desc
                end
            end
            if not seat then
                return false
            end
            root.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
            seat:Sit(humanoid)
            task.spawn(function()
                while tick() < tick() + 1 do
                    S.ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(root, 0)
                    task.wait()
                end
            end)
            task.wait(0.5)
            if char then
                if seat.Occupant == humanoid then
                    char:WaitForChild("Humanoid").Sit = false
                end
                root.CFrame = root.CFrame
                return true
            end
            return false
        end)
        Notify("Gucci Train", "Activated train protection")
        PlayEnableSound()
    end
})

DefenseTab:CreateButton({
    Name = "Gucci Tractor",
    Callback = function()
        task.spawn(function()
            local lp = LocalPlayer
            local char = lp.Character
            if not char then
                task.wait(0.5)
                char = lp.Character
                if not char then
                    return
                end
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            if not root or not humanoid then
                return
            end
            local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
            if not folder then
                return
            end

            local function FindOurPlot()
                for i = 1, 5 do
                    local plot = S.Workspace.Plots:FindFirstChild("Plot" .. i)
                    if plot then
                        local sign = plot:FindFirstChild("PlotSign")
                        if sign then
                            local owners = sign:FindFirstChild("ThisPlotsOwners")
                            local value = owners and owners:FindFirstChild("Value")
                            if value and string.find(value.Value, lp.Name) then
                                return value.Value
                            end
                        end
                    end
                end
                return nil
            end

            local tractor = folder:FindFirstChild("TractorGreen")
            if not tractor then
                if not lp.CanSpawnToy.Value then
                    lp.CanSpawnToy.Changed:Wait()
                end
                local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
                task.spawn(function()
                    spawnToy:InvokeServer("TractorGreen", root.CFrame * CFrame.new(5, 10, 20), Vector3.new(0, 0, 0))
                end)
                task.wait(.3)
                for _, toy in pairs(folder:GetChildren()) do
                    if toy.Name == "TractorGreen" and toy.PrimaryPart and (toy.PrimaryPart.Position - root.Position).Magnitude < 30 then
                        tractor = toy
                    end
                end
                if tractor then
                    local plotName = FindOurPlot()
                    if plotName then
                        local plotItems = S.Workspace.PlotItems[plotName]
                        tractor = plotItems:FindFirstChild("TractorGreen") or plotItems:WaitForChild("TractorGreen", 0.5)
                    end
                end
            end
            if not tractor then
                return
            end
            local vehicleSeat = tractor:WaitForChild("VehicleSeat", 3)
            if not vehicleSeat then
                return
            end
            vehicleSeat:Sit(humanoid)
            local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
            task.spawn(function()
                while tick() < tick() + 3 do
                    ragdollRemote:FireServer(root, 0)
                    task.wait()
                end
            end)
            task.wait(.1)
            local tries = 0
            while vehicleSeat.Occupant ~= humanoid do
                task.wait(.05)
                tries = tries + 1
                if tries > 300 then
                    return
                end
            end
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(.1)
            while vehicleSeat.Occupant == humanoid do
                task.wait(.05)
            end
            vehicleSeat.CFrame = CFrame.new(0, 1000000000, 0)
            task.wait(1)
        end)
        Notify("Gucci Tractor", "Activated tractor protection")
        PlayEnableSound()
    end
})

DefenseTab:CreateButton({
    Name = "Santa Sleigh Gucci",
    Callback = function()
        task.spawn(function()
            local lp = LocalPlayer
            local char = lp.Character
            if not char then
                task.wait(0.5)
                char = lp.Character
                if not char then
                    return
                end
            end
            local sleighAssetId = 22663328655673
            if not lp[sleighAssetId] then
                return
            end
            local humanoid = char:FindFirstChild("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root then
                return
            end
            local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
            if not folder then
                return
            end

            local function FindOurPlot()
                for i = 1, 5 do
                    local plot = S.Workspace.Plots:FindFirstChild("Plot" .. i)
                    if plot then
                        local sign = plot:FindFirstChild("PlotSign")
                        if sign then
                            local owners = sign:FindFirstChild("ThisPlotsOwners")
                            local value = owners and owners:FindFirstChild("Value")
                            if value and string.find(value.Value, lp.Name) then
                                return value.Value
                            end
                        end
                    end
                end
                return nil
            end

            local sleigh = folder:FindFirstChild("SantaSleigh")
            if not sleigh then
                if not lp.CanSpawnToy.Value then
                    lp.CanSpawnToy.Changed:Wait()
                end
                local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
                task.spawn(function()
                    spawnToy:InvokeServer("SantaSleigh", root.CFrame * CFrame.new(5, 10, 20), Vector3.new(0, 0, 0))
                end)
                task.wait(.3)
                for _, toy in pairs(folder:GetChildren()) do
                    if toy.Name == "SantaSleigh" and toy.PrimaryPart and (toy.PrimaryPart.Position - root.Position).Magnitude < 30 then
                        sleigh = toy
                    end
                end
                if sleigh then
                    local plotName = FindOurPlot()
                    if plotName then
                        local plotItems = S.Workspace.PlotItems[plotName]
                        sleigh = plotItems:FindFirstChild("SantaSleigh") or plotItems:WaitForChild("SantaSleigh", 0.5)
                    end
                end
            end
            if not sleigh then
                return
            end
            local vehicleSeat = sleigh:WaitForChild("VehicleSeat", 3)
            if not vehicleSeat then
                return
            end
            vehicleSeat:Sit(humanoid)
            local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
            task.spawn(function()
                while tick() < tick() + 3 do
                    ragdollRemote:FireServer(root, 0)
                    task.wait()
                end
            end)
            task.wait(.1)
            local tries = 0
            while vehicleSeat.Occupant ~= humanoid do
                task.wait(.05)
                tries = tries + 1
                if tries > 300 then
                    return
                end
            end
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(.1)
            while vehicleSeat.Occupant == humanoid do
                task.wait(.05)
            end
            vehicleSeat.CFrame = CFrame.new(0, 1000000000, 0)
            task.wait(1)
        end)
        Notify("Santa Sleigh", "Activated sleigh protection")
        PlayEnableSound()
    end
})

DefenseTab:CreateSection("Anti-Function")

DefenseTab:CreateToggle({
    Name = "Anti Grab",
    Default = false,
    Callback = function(state)
        if state then
            AntiGrabCfg.enabled = true
            AntiGrabCfg.antiGrabEnabled = true
            local antiGrab = {
                remotes = {},
                parts = {},
                conns = {}
            }

            local function getRemote(name)
                if antiGrab.remotes[name] then
                    return antiGrab.remotes[name]
                end
                for _, desc in ipairs(S.ReplicatedStorage:GetDescendants()) do
                    if desc.Name == name and desc:IsA("RemoteEvent") then
                        antiGrab.remotes[name] = desc
                        return desc
                    end
                end
            end

            local function OnHeartbeat()
                if not antiGrab.parts.IsHeld or not antiGrab.parts.IsHeld.Value then
                    return
                end
                if not antiGrab.parts.Root or not antiGrab.parts.Humanoid then
                    return
                end
                antiGrab.parts.Root.Anchored = true
                S.ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(antiGrab.parts.Root, antiGrab.parts.Root.CFrame)
                antiGrab.parts.Root.Massless = true
                antiGrab.parts.Root.CanCollide = false
                antiGrab.parts.Root.CanQuery = false
                antiGrab.parts.Root.AssemblyLinearVelocity = Vector3.zero
                antiGrab.parts.Root.AssemblyAngularVelocity = Vector3.zero
                antiGrab.parts.Root.Velocity = Vector3.zero
                antiGrab.parts.Root.RotVelocity = Vector3.zero
                local struggle = getRemote("Struggle")
                local ragdoll = getRemote("RagdollRemote")
                if struggle then
                    struggle:FireServer()
                end
                if ragdoll then
                    ragdoll:FireServer(antiGrab.parts.Root, 0)
                end
                if antiGrab.parts.originalGrabPosition then
                    antiGrab.parts.Root.CFrame = antiGrab.parts.originalGrabPosition
                end
                antiGrab.parts.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                antiGrab.parts.Humanoid.Sit = false
                antiGrab.parts.Humanoid.PlatformStand = false
                if antiGrab.parts.Humanoid.MoveDirection.Magnitude > 0 then
                    antiGrab.parts.Root.CFrame = antiGrab.parts.Root.CFrame + antiGrab.parts.Humanoid.MoveDirection * 2
                end
                if not antiGrab.parts.grabStartTime then
                    antiGrab.parts.grabStartTime = os.clock()
                end
                local elapsed = os.clock() - antiGrab.parts.grabStartTime
                if elapsed > 0.5 then
                    if antiGrab.parts.Humanoid.MoveDirection.Magnitude > 0 then
                        antiGrab.parts.Root.CFrame = antiGrab.parts.Root.CFrame + antiGrab.parts.Humanoid.MoveDirection * math.min(elapsed * 0.5, 3)
                    end
                end
            end

            local function OnHeldChanged()
                if not antiGrab.parts.IsHeld then
                    return
                end
                if antiGrab.parts.IsHeld.Value then
                    antiGrab.parts.grabStartTime = os.clock()
                    if antiGrab.parts.Root then
                        antiGrab.parts.originalGrabPosition = antiGrab.parts.Root.CFrame
                        antiGrab.parts.Root.Anchored = true
                    end
                    if not antiGrab.conns.heartbeat then
                        antiGrab.conns.heartbeat = S.RunService.Heartbeat:Connect(OnHeartbeat)
                    end
                else
                    if antiGrab.conns.heartbeat then
                        antiGrab.conns.heartbeat:Disconnect()
                        antiGrab.conns.heartbeat = nil
                    end
                    if antiGrab.parts.Root then
                        antiGrab.parts.Root.Anchored = false
                        antiGrab.parts.Root.Massless = false
                        antiGrab.parts.Root.CanCollide = true
                        antiGrab.parts.Root.CanQuery = true
                        antiGrab.parts.Root.AssemblyLinearVelocity = Vector3.zero
                        antiGrab.parts.Root.AssemblyAngularVelocity = Vector3.zero
                        antiGrab.parts.Root.Velocity = Vector3.zero
                        antiGrab.parts.Root.RotVelocity = Vector3.zero
                    end
                    if antiGrab.parts.Humanoid then
                        antiGrab.parts.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    antiGrab.parts.grabStartTime = nil
                    antiGrab.parts.originalGrabPosition = nil
                end
            end

            local function OnCharacterAdded(character)
                if not character then
                    return
                end
                antiGrab.parts.Character = character
                antiGrab.parts.Root = character:WaitForChild("HumanoidRootPart")
                antiGrab.parts.Humanoid = character:WaitForChild("Humanoid")
            end

            antiGrab.parts.IsHeld = LocalPlayer:WaitForChild("IsHeld")
            if LocalPlayer.Character then
                OnCharacterAdded(LocalPlayer.Character)
            end
            antiGrab.conns.charAdded = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
            antiGrab.conns.heldChanged = antiGrab.parts.IsHeld:GetPropertyChangedSignal("Value"):Connect(OnHeldChanged)
            OnHeldChanged()
            Notify("Anti Grab", "Enabled - Grab protection active")
            PlayEnableSound()
        else
            AntiGrabCfg.enabled = false
            AntiGrabCfg.antiGrabEnabled = false
            Notify("Anti Grab", "Disabled")
        end
    end
})

AntiKickStickCfg.selectedItem = "NinjaShuriken"
AntiKickStickCfg.items = {
    "NinjaShuriken",
    "NinjaKunai",
    "ToolCleaver",
    "ToolPencil",
    "ToolPickaxe",
    "ToolDiggingForkRusty",
    "NinjaKatana"
}

local function ApplyHighlight(model)
    if not model or not model.Parent then
        return
    end
    local existing = model:FindFirstChild("Amethyst_FullHighlight")
    if existing then
        existing:Destroy()
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "Amethyst_FullHighlight"
    highlight.FillColor = Color3.fromRGB(170, 100, 255)
    highlight.OutlineColor = Color3.fromRGB(140, 90, 220)
    highlight.OutlineTransparency = .1
    highlight.FillTransparency = .2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = model
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = .95
            if part:FindFirstChildOfClass("Texture") then
                part.Material = Enum.Material.ForceField
            end
        end
    end
    return highlight
end

local function GetStickRemotes()
    local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
    local destroyToy = S.ReplicatedStorage.MenuToys.DestroyToy
    local setOwner = S.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
    local stickyEvent = S.ReplicatedStorage.PlayerEvents:WaitForChild("StickyPartEvent")
    return spawnToy, destroyToy, setOwner, stickyEvent
end

local function PlayerInPlot(playerName)
    local folder = S.Workspace.PlotItems.PlayersInPlots
    if not folder:FindFirstChild(playerName) then
        return false
    end
    for _, plot in pairs(S.Workspace.Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local owners = sign:FindFirstChild("ThisPlotsOwners")
            if owners then
                for _, owner in pairs(sign:GetChildren()) do
                    if owner.Name == "Value" and owner.Value == playerName then
                        return true, S.Workspace.PlotItems:FindFirstChild(plot.Name)
                    end
                end
            end
        end
    end
    return false
end

local function GetRoot()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    local newChar = LocalPlayer.CharacterAdded:Wait()
    return newChar:WaitForChild("HumanoidRootPart")
end

local function SpawnSelectedItem()
    local item = AntiKickStickCfg.selectedItem
    while not LocalPlayer.CanSpawnToy.Value do
        if not AntiKickStickCfg.enabled or tick() - tick() > 5 then
            return nil
        end
        task.wait()
    end
    local root = GetRoot()
    if root then
        local cframe = root.CFrame * CFrame.new(0, 12, 20)
        task.spawn(function()
            local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
            spawnToy:InvokeServer(item, cframe, Vector3.new(0, 0, 0))
        end)
    end
    local inPlot, plotFolder = PlayerInPlot(LocalPlayer.Name)
    local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    if inPlot then
        return plotFolder:WaitForChild(item, 2)
    end
    return folder:WaitForChild(item, 2) or (S.Workspace.PlotItems.PlayersInPlots:FindFirstChild(LocalPlayer.Name) and folder and folder:WaitForChild(item, 2)) or nil
end

local function DestroyAllItems(player)
    local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
    if not folder then
        return
    end
    local destroyToy = S.ReplicatedStorage.MenuToys.DestroyToy
    for _, toy in pairs(folder:GetChildren()) do
        if toy.Name == AntiKickStickCfg.selectedItem then
            destroyToy:FireServer(toy)
        end
    end
end

local function GiveNetworkOwner(model, ownerName)
    if not model or not model:FindFirstChild("StickyPart") then
        return
    end
    if not GetRoot() then
        return
    end
    local setOwner = S.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
    if model:FindFirstChild("SoundPart") then
        local soundPart = model.SoundPart
        if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= ownerName then
            setOwner:FireServer(soundPart, soundPart.CFrame)
        end
    end
end

local function MakeAntiKick(model, player)
    local lp = player.Character
    if not lp or not lp:FindFirstChild("HumanoidRootPart") then
        return
    end
    if not model or not model:FindFirstChild("StickyPart") then
        return
    end
    local root = lp.HumanoidRootPart
    local firePart = root:FindFirstChild("FirePlayerPart")
    if not firePart then
        firePart = Instance.new("Part")
        firePart.Name = "FirePlayerPart"
        firePart.Size = Vector3.new(1, 1, 1)
        firePart.Transparency = 1
        firePart.CanCollide = false
        firePart.CanQuery = false
        firePart.Anchored = true
        firePart.Parent = root
        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = firePart
        weld.C0 = CFrame.new(0, 0, 0)
        weld.Parent = firePart
    end
    local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
    local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
    if model:FindFirstChild("SoundPart") then
        local soundPart = model.SoundPart
        if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= player.Name then
            pcall(function()
                setOwner:FireServer(soundPart, soundPart.CFrame)
            end)
        end
    end
    local playerEvents = S.ReplicatedStorage:WaitForChild("PlayerEvents")
    local stickyEvent = playerEvents:WaitForChild("StickyPartEvent")
    pcall(function()
        stickyEvent:FireServer(model.StickyPart, firePart, CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)))
    end)
    local sticky = model:FindFirstChild("StickyPart")
    if sticky then
        sticky.Transparency = 1
        sticky.CanCollide = false
        sticky.CanQuery = false
    end
    local soundPart = model:FindFirstChild("SoundPart")
    if soundPart then
        soundPart.Transparency = 1
        soundPart.CanCollide = false
        soundPart.CanQuery = false
    end
    ApplyHighlight(model)
    if not model:FindFirstChild("Amethyst_Atmosphere") then
        local atmosphere = Instance.new("Atmosphere", model)
        atmosphere.Name = "Amethyst_Atmosphere"
        atmosphere.Color = Color3.fromRGB(170, 100, 255)
        atmosphere.Decay = Color3.fromRGB(50, 30, 80)
        atmosphere.Glare = .2
        atmosphere.Haze = .1
        atmosphere.Density = .3
    end
    if not model:FindFirstChild("Amethyst_PointLight") then
        local light = Instance.new("PointLight", model)
        light.Name = "Amethyst_PointLight"
        light.Color = Color3.fromRGB(170, 100, 255)
        light.Range = 15
        light.Brightness = 0.5
        light.Shadows = true
    end
    if model.PrimaryPart then
        model:SetPrimaryPartCFrame(root.CFrame)
    end
    model.Name = "AntiKick"
    task.delay(.1, function()
        if model and model.Parent then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "StickyPart" and part.Name ~= "SoundPart" then
                    part.Transparency = 0.5
                end
            end
        end
    end)
end

local function StartAntiKickStickLoop()
    local lp = LocalPlayer
    local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
    local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
    local playerEvents = S.ReplicatedStorage:WaitForChild("PlayerEvents")
    local stickyEvent = playerEvents:WaitForChild("StickyPartEvent")
    local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
    local destroyToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
    local canSpawn = lp:WaitForChild("CanSpawnToy")

    local function GetPlayerRoot()
        local char = lp.Character
        if char then
            return char:FindFirstChild("HumanoidRootPart")
        end
        local newChar = lp.CharacterAdded:Wait()
        return newChar:WaitForChild("HumanoidRootPart")
    end

    local function IsInOwnPlot(plotName)
        local playersInPlots = S.Workspace.PlotItems.PlayersInPlots
        if not playersInPlots:FindFirstChild(lp.Name) then
            return false
        end
        for _, plot in pairs(S.Workspace.Plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local owners = sign:FindFirstChild("ThisPlotsOwners")
                if owners then
                    for _, ownerData in pairs(sign:GetChildren()) do
                        if ownerData.Name == "Value" and ownerData.Value == lp.Name then
                            return true, S.Workspace.PlotItems:FindFirstChild(plotName or plot.Name)
                        end
                    end
                end
            end
        end
        return false
    end

    local function ClaimSoundPart(model)
        if not model or not model:FindFirstChild("StickyPart") then
            return
        end
        if not GetPlayerRoot() then
            return
        end
        if model:FindFirstChild("SoundPart") then
            local soundPart = model.SoundPart
            if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= lp.Name then
                setOwner:FireServer(soundPart, soundPart.CFrame)
            end
        end
    end

    while AntiKickStickCfg.enabled do
        task.wait()
        local char = lp.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
            local current = folder and folder:FindFirstChild(AntiKickStickCfg.selectedItem)
            local inPlot = IsInOwnPlot()
            if inPlot then
                current = SpawnSelectedItem()
            end
            if current == nil then
                if IsInOwnPlot() then
                elseif S.Workspace.PlotItems.PlayersInPlots:FindFirstChild(lp.Name) then
                else
                    local item = SpawnSelectedItem()
                    if item then
                        ClaimSoundPart(item)
                        local char = lp.Character
                        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                        if rootPart and item.PrimaryPart then
                            item:SetPrimaryPartCFrame(rootPart.CFrame)
                        end
                        MakeAntiKick(item, lp)
                    end
                end
            elseif not current:FindFirstChild("Amethyst_FullHighlight") then
                ApplyHighlight(current)
            end
        end
    end
end

DefenseTab:CreateDropdown({
    Name = "Anti Kick (Stick) Item",
    Items = AntiKickStickCfg.items,
    Default = "NinjaShuriken",
    Callback = function(selected)
        AntiKickStickCfg.selectedItem = selected
        Notify("Anti Kick", "Selected: " .. selected, 2)
        if AntiKickStickCfg.enabled then
            if AntiKickStickCfg.loopThread then
                task.cancel(AntiKickStickCfg.loopThread)
                AntiKickStickCfg.loopThread = nil
            end
            local destroyToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
            local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if folder then
                for _, toy in pairs(folder:GetChildren()) do
                    if toy.Name == selected then
                        destroyToy:FireServer(toy)
                    end
                end
            end
            task.wait(.1)
            AntiKickStickCfg.loopThread = task.spawn(StartAntiKickStickLoop)
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti Kick (Stick)",
    Default = false,
    Callback = function(state)
        if state then
            AntiKickStickCfg.enabled = true
            Notify("Anti Kick", "Enabled with " .. AntiKickStickCfg.selectedItem)
            PlayEnableSound()
            AntiKickStickCfg.loopThread = task.spawn(StartAntiKickStickLoop)
        else
            AntiKickStickCfg.enabled = false
            if AntiKickStickCfg.loopThread then
                task.cancel(AntiKickStickCfg.loopThread)
                AntiKickStickCfg.loopThread = nil
            end
            local destroyToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
            local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if folder then
                for _, toy in pairs(folder:GetChildren()) do
                    if toy.Name == AntiKickStickCfg.selectedItem then
                        destroyToy:FireServer(toy)
                    end
                end
            end
            Notify("Anti Kick", "Disabled")
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti (Anti-Input)",
    Default = false,
    Callback = function(state)
        local cfg = Features.AntiAntiInput
        if state then
            cfg.enabled = true
            local okItems = {}
            for _, item in ipairs(AntiInputLagCfg.items or {}) do
                okItems[item] = true
            end
            local function HandleItem(model)
                if not cfg.enabled then
                    return
                end
                if not model then
                    return
                end
                if not model.Parent then
                    return
                end
                if not okItems[model.Name] then
                    return
                end
                local holdPart = model:FindFirstChild("HoldPart")
                if not holdPart then
                    for _ = 0, 36 do
                        if not cfg.enabled then
                            return
                        end
                        holdPart = model:FindFirstChild("HoldPart")
                        if holdPart then
                            break
                        end
                        task.wait()
                    end
                    if not holdPart then
                        return
                    end
                end
                local holdRemote = holdPart:FindFirstChild("HoldItemRemoteFunction")
                local dropRemote = holdPart:FindFirstChild("DropItemRemoteFunction")
                if not holdRemote then
                    for _ = 0, 36 do
                        if not cfg.enabled then
                            return
                        end
                        holdRemote = holdPart:FindFirstChild("HoldItemRemoteFunction")
                        dropRemote = holdPart:FindFirstChild("DropItemRemoteFunction")
                        if holdRemote then
                            break
                        end
                        task.wait()
                    end
                    if not holdPart:FindFirstChild("HoldItemRemoteFunction") or not dropRemote then
                        return
                    end
                end
                local char = LocalPlayer.Character
                if not char then
                    return
                end
                holdRemote:InvokeServer(model, char)
                task.spawn(function()
                    dropRemote:InvokeServer(model, CFrame.new(99999, -99999, 99999), Vector3.new(0, -20, 0))
                end)
            end
            for _, desc in ipairs(S.Workspace:GetDescendants()) do
                if cfg.enabled and desc:IsA("Model") and okItems[desc.Name] then
                    task.spawn(HandleItem, desc)
                end
            end
            cfg.connection = S.Workspace.DescendantAdded:Connect(function(desc)
                if cfg.enabled and desc:IsA("Model") and okItems[desc.Name] then
                    task.spawn(HandleItem, desc)
                end
            end)
            Notify("Anti Anti-Input", "Active")
            PlayEnableSound()
        else
            cfg.enabled = false
            if cfg.connection then
                cfg.connection:Disconnect()
                cfg.connection = nil
            end
            Notify("Anti Anti-Input", "Disabled")
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Anti Ragdoll (for blob)",
    Default = false,
    Callback = function(state)
        if state then
            AntiRagdollCfg.enabled = true
            AntiRagdollCfg.ragdolledSit = false
            local ragdollRemote = S.ReplicatedStorage:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote")
            local function Setup()
                local char = LocalPlayer.Character
                if not char then
                    return
                end
                local humanoid = char:FindFirstChild("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if not humanoid or not root then
                    return
                end
                local seatConn = humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
                    if humanoid.SeatPart and humanoid.SeatPart.Parent and humanoid.SeatPart.Parent.Name == "CreatureBlobman" and not AntiRagdollCfg.ragdolledSit then
                        AntiRagdollCfg.ragdolledSit = true
                        local seatPart = humanoid.SeatPart
                        while not humanoid:FindFirstChild("Ragdolled") do
                            ragdollRemote:FireServer(root, 3)
                            if not humanoid:FindFirstChild("Ragdolled") then
                                task.wait(.4)
                                if humanoid then
                                    humanoid.Sit = false
                                    if seatPart then
                                        seatPart:Sit(humanoid)
                                    end
                                    task.delay(0.25, function()
                                        while not humanoid.Sit and humanoid.SeatPart and AntiRagdollCfg.enabled do
                                            if humanoid then
                                                ragdollRemote:FireServer(humanoid.HumanoidRootPart, 1)
                                            end
                                            task.wait(.05)
                                        end
                                        AntiRagdollCfg.ragdolledSit = false
                                    end)
                                end
                            end
                        end
                    end
                end)
                AntiRagdollCfg.connections.ARSeat = seatConn
            end
            if LocalPlayer.Character then
                Setup()
            end
            AntiRagdollCfg.connections.ARChar = LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                if AntiRagdollCfg.enabled then
                    Setup()
                end
            end)
            Notify("Anti Ragdoll", "Enabled - Blob protection active")
            PlayEnableSound()
        else
            AntiRagdollCfg.enabled = false
            for _, conn in pairs(AntiRagdollCfg.connections) do
                if conn then
                    conn:Disconnect()
                end
            end
            AntiRagdollCfg.connections = {}
            AntiRagdollCfg.ragdolledSit = false
            Notify("Anti Ragdoll", "Disabled")
        end
    end
})

DefenseTab:CreateDropdown({
    Name = "Anti-Input Lag Item",
    Items = AntiInputLagCfg.items,
    Default = "FoodHamburger",
    Callback = function(selected)
        AntiInputLagCfg.selectedItem = selected
        Notify("Anti-Input Lag", "Selected: " .. selected, 2)
    end
})

DefenseTab:CreateToggle({
    Name = "Anti-Input Lag",
    Default = false,
    Callback = function(state)
        if state then
            AntiInputLagCfg.enabled = true
            AntiInputLagCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                while AntiInputLagCfg.enabled do
                    if not lp.Character or not lp.Character:FindFirstChild("Humanoid") or lp.Character.Humanoid.Health <= 0 then
                        task.wait(0.5)
                    else
                        local char = lp.Character
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not char or not root or not char:FindFirstChild("Humanoid") then
                            task.wait(0.5)
                        else
                            local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                            if not folder then
                                task.wait(0.5)
                            else
                                local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
                                local canSpawn = lp:FindFirstChild("CanSpawnToy")
                                local current = AntiInputLagCfg.currentItem
                                if not current or not current.Parent or not current:FindFirstChild("HoldPart") then
                                    current = folder:FindFirstChild(AntiInputLagCfg.selectedItem)
                                    if not current then
                                        while not canSpawn.Value do
                                            if not AntiInputLagCfg.enabled or tick() - tick() > 5 then
                                                task.wait()
                                            else
                                                task.wait()
                                            end
                                        end
                                        if root then
                                            task.spawn(function()
                                                spawnToy:InvokeServer(AntiInputLagCfg.selectedItem, root.CFrame * CFrame.new(0, 12, 20), Vector3.new(0, 0, 0))
                                            end)
                                        end
                                        for _ = 1, 20 do
                                            current = folder:FindFirstChild(AntiInputLagCfg.selectedItem)
                                            if current then
                                                break
                                            end
                                            task.wait(.007)
                                        end
                                        if not current then
                                            task.wait(.007)
                                        else
                                            AntiInputLagCfg.currentItem = current
                                            local holdPart = current:FindFirstChild("HoldPart")
                                            local holdRemote = holdPart and holdPart:FindFirstChild("HoldItemRemoteFunction")
                                            local dropRemote = holdPart and holdPart:FindFirstChild("DropItemRemoteFunction")
                                            if not holdPart or not holdRemote or not dropRemote then
                                                AntiInputLagCfg.currentItem = nil
                                                task.wait()
                                            else
                                                task.spawn(function()
                                                    pcall(function()
                                                        lp:InvokeServer(AntiInputLagCfg.selectedItem, lp)
                                                    end)
                                                end)
                                                task.wait(.05)
                                                task.spawn(function()
                                                    pcall(function()
                                                        dropRemote:InvokeServer(current, root.CFrame * CFrame.new(0, 199, 0), Vector3.zero)
                                                    end)
                                                end)
                                                task.wait(.035)
                                            end
                                        end
                                    else
                                        current = nil
                                    end
                                end
                                task.wait(0.2)
                            end
                        end
                    end
                end
                AntiInputLagCfg.currentItem = nil
            end)
            Notify("Anti-Input Lag", "Enabled with " .. AntiInputLagCfg.selectedItem)
            PlayEnableSound()
        else
            AntiInputLagCfg.enabled = false
            if AntiInputLagCfg.loopThread then
                task.cancel(AntiInputLagCfg.loopThread)
                AntiInputLagCfg.loopThread = nil
            end
            AntiInputLagCfg.currentItem = nil
            Notify("Anti-Input Lag", "Disabled")
        end
    end
})

DefenseTab:CreateSection("Other")

DefenseTab:CreateToggle({
    Name = "Safe Pos LP",
    Default = false,
    Callback = function(state)
        if state then
            SafePosCfg.enabled = true
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    SafePosCfg.target = root.CFrame
                end
            end
            if not SafePosCfg.target then
                Notify("Safe Pos", "Error: Could not save position!")
                return
            end
            SafePosCfg.loopThread = task.spawn(function()
                while SafePosCfg.enabled do
                    local char = LocalPlayer.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = SafePosCfg.target
                        end
                    end
                    task.wait()
                end
            end)
            Notify("Safe Pos", "Enabled - Position saved")
            PlayEnableSound()
        else
            SafePosCfg.enabled = false
            if SafePosCfg.loopThread then
                task.cancel(SafePosCfg.loopThread)
                SafePosCfg.loopThread = nil
            end
            Notify("Safe Pos", "Disabled")
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Auto Sit Blob",
    Default = false,
    Callback = function(state)
        if state then
            AutoSitCfg.enabled = true
            AutoSitCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local spawnToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
                S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
                local function FindBlob()
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function SpawnBlob()
                    local canSpawn = lp:FindFirstChild("CanSpawnToy")
                    if canSpawn then
                        local start = tick()
                        while canSpawn.Value do
                            if tick() - start < 3 then
                                task.wait()
                            end
                            if not lp:FindFirstChild("CanSpawnToy").Value then
                                return nil
                            end
                        end
                        local char = lp.Character
                        if not char then
                            return nil
                        end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then
                            return nil
                        end
                        spawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(0, 0, 5), Vector3.new(0, 0, 0))
                        task.wait(0.3)
                        for _ = 1, 10 do
                            local blob = FindBlob()
                            if blob then
                                return blob
                            end
                            task.wait()
                        end
                        return nil
                    end
                end
                local function SitOnBlob(blob)
                    if not blob then
                        return false
                    end
                    local char = lp.Character
                    if not char then
                        return false
                    end
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not humanoid then
                        return false
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return false
                    end
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if not seat then
                        return false
                    end
                    if humanoid.SeatPart == seat then
                        return true
                    end
                    root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                    task.wait()
                    seat:Sit(humanoid)
                    task.wait()
                    return humanoid.SeatPart == seat
                end
                while AutoSitCfg.enabled do
                    local blob = AutoSitCfg.currentBlob
                    if not blob or not blob.Parent then
                        blob = FindBlob()
                        if not blob then
                            blob = SpawnBlob()
                        end
                        if blob then
                            AutoSitCfg.currentBlob = blob
                            SitOnBlob(blob)
                        end
                    end
                    task.wait()
                end
                AutoSitCfg.currentBlob = nil
            end)
            Notify("Auto Sit Blob", "Enabled - Auto sitting on blob")
            PlayEnableSound()
        else
            AutoSitCfg.enabled = false
            if AutoSitCfg.loopThread then
                task.cancel(AutoSitCfg.loopThread)
                AutoSitCfg.loopThread = nil
            end
            AutoSitCfg.currentBlob = nil
            Notify("Auto Sit Blob", "Disabled")
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Self Grab (Blob)",
    Default = false,
    Callback = function(state)
        if state then
            SelfGrabCfg.enabled = true
            SelfGrabCfg.MyBlob = nil
            SelfGrabCfg.ProcessingGrab = false
            SelfGrabCfg.ProcessingRelease = false
            SelfGrabCfg.GrabCooldown = 0
            SelfGrabCfg.RegrabActive = false
            SelfGrabCfg.SpawningBlob = false
            SelfGrabCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                lp:WaitForChild("IsHeld")
                local spawnToy = S.ReplicatedStorage:FindFirstChild("MenuToys") and S.ReplicatedStorage:FindFirstChild("MenuToys"):FindFirstChild("SpawnToyRemoteFunction")
                local destroyToy = S.ReplicatedStorage:FindFirstChild("MenuToys") and S.ReplicatedStorage:FindFirstChild("MenuToys"):FindFirstChild("DestroyToy")
                local blob = nil
                local savedCFrame = nil
                local savedMassless = nil
                local wasGrabbed = false

                local function EnsureBlob()
                    if SelfGrabCfg.SpawningBlob then
                        return nil
                    end
                    if blob and blob.Parent then
                        return blob
                    end
                    local canSpawn = lp:FindFirstChild("CanSpawnToy")
                    if not canSpawn then
                        return nil
                    end
                    local start = tick()
                    while canSpawn.Value do
                        if tick() - start < 1 then
                            task.wait()
                        end
                        if not lp:FindFirstChild("CanSpawnToy").Value then
                            return nil
                        end
                    end
                    SelfGrabCfg.SpawningBlob = true
                    if spawnToy then
                        spawnToy:InvokeServer("CreatureBlobman", CFrame.new(0, 0, 0), Vector3.new(0, 0, 0))
                    end
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder and folder:FindFirstChild("CreatureBlobman") then
                        blob = folder:FindFirstChild("CreatureBlobman")
                        SelfGrabCfg.SpawningBlob = false
                        return blob
                    end
                    SelfGrabCfg.SpawningBlob = false
                    return nil
                end

                local function FindBlob()
                    if blob and blob.Parent then
                        return true
                    end
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                blob = toy
                                return true
                            end
                        end
                    end
                    return EnsureBlob() ~= nil
                end

                local function SaveBlobState(target)
                    if not target then
                        return
                    end
                    savedCFrame = target.CFrame
                    savedMassless = target.Massless
                    target.Massless = false
                end

                local function RestoreBlobState(target)
                    if not target then
                        return
                    end
                    if not savedCFrame then
                        return
                    end
                    if savedMassless ~= nil then
                        target.Massless = savedMassless
                    end
                    target.CFrame = savedCFrame
                    target.Velocity = Vector3.zero
                end

                local function GetBlobRemotes()
                    if not blob then
                        return nil
                    end
                    local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                    local rightDet = blob:FindFirstChild("RightDetector")
                    local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                    if not seatScript then
                        return nil
                    end
                    return {
                        grab = seatScript:FindFirstChild("CreatureGrab"),
                        release = seatScript:FindFirstChild("CreatureRelease"),
                        rightDet = rightDet,
                        rightWeld = rightWeld
                    }
                end

                local function DoGrab(targetRoot, targetHum)
                    if SelfGrabCfg.ProcessingGrab then
                        return false
                    end
                    if tick() - SelfGrabCfg.GrabCooldown < 0 then
                        return false
                    end
                    SelfGrabCfg.ProcessingGrab = true
                    SelfGrabCfg.GrabCooldown = tick()
                    if not FindBlob() then
                        SelfGrabCfg.ProcessingGrab = false
                        return false
                    end
                    if not blob then
                        SelfGrabCfg.ProcessingGrab = false
                        return false
                    end
                    if wasGrabbed then
                        SaveBlobState(targetRoot)
                    end
                    local remotes = GetBlobRemotes()
                    if not remotes or not remotes.grab then
                        SelfGrabCfg.ProcessingGrab = false
                        return false
                    end
                    remotes.grab:FireServer(nil, targetRoot, remotes.rightWeld)
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if seat then
                        task.wait()
                        if targetHum then
                            targetHum.Sit = false
                        end
                        seat:Sit(targetHum)
                    end
                    SelfGrabCfg.ProcessingGrab = false
                    return true
                end

                local function DoRelease(targetRoot, targetHum)
                    if SelfGrabCfg.ProcessingRelease then
                        return
                    end
                    if tick() - SelfGrabCfg.GrabCooldown < 0 then
                        return
                    end
                    SelfGrabCfg.ProcessingRelease = true
                    SelfGrabCfg.GrabCooldown = tick()
                    if not blob then
                        SelfGrabCfg.ProcessingRelease = false
                        return
                    end
                    local remotes = GetBlobRemotes()
                    if remotes and remotes.release then
                        remotes.release:FireServer(remotes.rightWeld)
                        task.wait()
                    end
                    if targetHum then
                        targetHum.Sit = false
                        task.wait()
                    end
                    if wasGrabbed then
                        task.wait()
                        RestoreBlobState(targetRoot)
                        wasGrabbed = false
                    end
                    SelfGrabCfg.ProcessingRelease = false
                end

                EnsureBlob()
                while SelfGrabCfg.enabled do
                    local char = lp.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        FindBlob()
                        local held = lp:WaitForChild("IsHeld").Value
                        if held then
                            wasGrabbed = true
                            if not SelfGrabCfg.RegrabActive then
                                SelfGrabCfg.RegrabActive = true
                            end
                            if wasGrabbed then
                                DoGrab(char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildOfClass("Humanoid"))
                            end
                        else
                            if SelfGrabCfg.RegrabActive then
                                SelfGrabCfg.RegrabActive = false
                                DoRelease(char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildOfClass("Humanoid"))
                            end
                        end
                    end
                    task.wait()
                end
                SelfGrabCfg.MyBlob = blob
                if blob and blob.Parent and destroyToy then
                    destroyToy:FireServer(blob)
                end
            end)
            Notify("Self Grab", "Enabled - Self grab with blob")
            PlayEnableSound()
        else
            SelfGrabCfg.enabled = false
            if SelfGrabCfg.loopThread then
                task.cancel(SelfGrabCfg.loopThread)
                SelfGrabCfg.loopThread = nil
            end
            if SelfGrabCfg.MyBlob then
                local destroyToy = S.ReplicatedStorage:FindFirstChild("MenuToys") and S.ReplicatedStorage:FindFirstChild("MenuToys"):FindFirstChild("DestroyToy")
                if destroyToy then
                    destroyToy:FireServer(SelfGrabCfg.MyBlob)
                end
            end
            SelfGrabCfg.MyBlob = nil
            Notify("Self Grab", "Disabled")
        end
    end
})

DefenseTab:CreateToggle({
    Name = "Noclip Obj players",
    Default = false,
    Callback = function(state)
        if state then
            NoclipCfg.enabled = true
            NoclipCfg.parts = {}
            NoclipCfg.connections = {}

            local function IsInputLagItem(name)
                for _, item in ipairs(AntiInputLagCfg.items) do
                    if item == name then
                        return true
                    end
                end
                return false
            end

            local function SetNoclip(model)
                if not model or not model:IsA("Model") then
                    return
                end
                if IsInputLagItem(model.Name) then
                    return
                end
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end

            local function OnCharacter(character)
                if not character then
                    return
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            for _, player in ipairs(S.Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    NoclipCfg.parts[player] = {}
                    if player.Character then
                        OnCharacter(player.Character)
                    end
                    player.CharacterAdded:Connect(function(character)
                        if NoclipCfg.enabled then
                            OnCharacter(character)
                        end
                    end)
                end
            end

            for _, player in ipairs(S.Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in ipairs(folder:GetChildren()) do
                            SetNoclip(toy)
                        end
                    end
                end
            end

            NoclipCfg.connections.descendantAdded = S.Workspace.DescendantAdded:Connect(function(desc)
                if not NoclipCfg.enabled then
                    return
                end
                if desc:IsA("Model") and not IsInputLagItem(desc.Name) then
                    local parent = desc.Parent
                    local isOwnFolder = false
                    while parent do
                        if parent.Name == LocalPlayer.Name .. "SpawnedInToys" then
                            isOwnFolder = true
                            break
                        end
                        parent = parent.Parent
                    end
                    if not isOwnFolder then
                        task.wait(.1)
                        SetNoclip(desc)
                    end
                end
            end)

            NoclipCfg.connections.playerAdded = S.Players.PlayerAdded:Connect(function(player)
                if not NoclipCfg.enabled or player == LocalPlayer then
                    return
                end
                NoclipCfg.parts[player] = {}
                player.CharacterAdded:Connect(function(character)
                    if NoclipCfg.enabled then
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end)

            NoclipCfg.connections.periodicCheck = task.spawn(function()
                while NoclipCfg.enabled do
                    for _, player in ipairs(S.Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            for _, part in ipairs(player.Character:GetChildren()) do
                                if part:IsA("BasePart") and part.CanCollide then
                                    part.CanCollide = false
                                end
                            end
                            local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                            if folder then
                                for _, toy in ipairs(folder:GetChildren()) do
                                    if toy:IsA("Model") and not IsInputLagItem(toy.Name) then
                                        for _, part in ipairs(toy:GetDescendants()) do
                                            if part:IsA("BasePart") and part.CanCollide then
                                                part.CanCollide = false
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
            Notify("Noclip", "Enabled - Noclip through players/items")
            PlayEnableSound()
        else
            NoclipCfg.enabled = false
            for _, conn in pairs(NoclipCfg.connections) do
                if conn then
                    if typeof(conn) == "RBXScriptConnection" then
                        conn:Disconnect()
                    else
                        task.cancel(conn)
                    end
                end
            end
            NoclipCfg.connections = {}
            NoclipCfg.parts = {}
            Notify("Noclip", "Disabled")
        end
    end
})

DefenseTab:CreateButton({
    Name = "Delete Legs",
    Callback = function()
        local lp = LocalPlayer
        local char = lp.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
        if not char or not ragdollRemote then
            return
        end
        if not (char:FindFirstChild("Left Leg")) then
            Notify("Delete Legs", "Error: Missing body parts", 3)
            return
        end
        local torso = char:FindFirstChild("Torso")
        S.Workspace.FallenPartsDestroyHeight = -100
        Notify("Delete Legs", "Deleting legs...", 3)
        PlayEnableSound()
        ragdollRemote:FireServer(root, 2)
        task.wait(0.5)
        char["Right Leg"].CFrame = CFrame.new(0, -10000, 0)
        char["Left Leg"].CFrame = CFrame.new(0, -10000, 0)
        task.wait(.3)
        if torso then
            torso.CFrame = CFrame.new(0, -9970, 0)
        end
        task.wait(0.5)
        if torso then
            local grab = torso.CFrame
            torso.CFrame = grab
        end
        task.wait(0.5)
        S.Workspace.FallenPartsDestroyHeight = S.Workspace.FallenPartsDestroyHeight
        if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
            Notify("Delete Legs", "Legs successfully deleted!", 5)
            PlayEnableSound()
            task.spawn(function()
                while char.Parent do
                    if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid then
                            local controls = lp.PlayerGui:FindFirstChild("ControlsGui")
                            local pcFrame = controls and controls:FindFirstChild("PCFrame")
                            local stand = pcFrame and pcFrame:FindFirstChild("Stand")
                            if stand then
                                if stand.Visible == false then
                                    humanoid.HipHeight = 2
                                else
                                    humanoid.HipHeight = 0
                                end
                            end
                        end
                        task.wait()
                    end
                end
            end)
        else
            Notify("Delete Legs", "Warning: Legs not fully deleted", 3)
        end
    end
})

pcall(function()
    print("[AMETHYST] Активация Permanent Pallet...")
    PermanentPalletCfg.enabled = true
    local lp = LocalPlayer
    local spawnToyRemote = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
    local destroyToyRemote = S.ReplicatedStorage.MenuToys.DestroyToy
    local setOwnerRemote = S.ReplicatedStorage.GrabEvents.SetNetworkOwner

    local function FindOwnPallet()
        local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
        if not folder then
            return nil
        end
        for _, toy in ipairs(folder:GetChildren()) do
            if toy.Name == "PalletLightBrown" then
                local soundPart = toy:FindFirstChild("SoundPart")
                if soundPart then
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if owner and owner.Value == lp.Name then
                        return toy
                    else
                        setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                        task.wait(.1)
                        owner = soundPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == lp.Name then
                            return toy
                        end
                    end
                end
            end
        end
        return nil
    end

    local function SpawnPallet()
        local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
        if folder then
            for _, toy in ipairs(folder:GetChildren()) do
                if toy.Name == "PalletLightBrown" then
                    local soundPart = toy:FindFirstChild("SoundPart")
                    if not soundPart or not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= lp.Name then
                        destroyToyRemote:FireServer(toy)
                        task.wait(.1)
                    end
                end
            end
        end
        local canSpawn = lp:FindFirstChild("CanSpawnToy")
        if canSpawn then
            local start = tick()
            while canSpawn.Value do
                if tick() - start < 5 then
                    task.wait(.1)
                    if not PermanentPalletCfg.enabled then
                        return nil
                    end
                end
                local char = lp.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return nil
                    end
                end
                return nil
            end
            local char = lp.Character
            if not char then
                return nil
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then
                return nil
            end
            spawnToyRemote:InvokeServer("PalletLightBrown", root.CFrame * CFrame.new(0, 30, 20), Vector3.new(0, -90, 0))
            for _ = 1, 20 do
                if not PermanentPalletCfg.enabled then
                    return nil
                end
                local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                local pallet = folder and folder:FindFirstChild("PalletLightBrown")
                if pallet then
                    local soundPart = pallet:FindFirstChild("SoundPart")
                    if soundPart then
                        setOwnerRemote:FireServer(soundPart, soundPart.CFrame)
                        task.wait(.1)
                        local owner = soundPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == lp.Name then
                            return pallet
                        else
                            setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                            task.wait(.1)
                            owner = soundPart:FindFirstChild("PartOwner")
                            if owner and owner.Value == lp.Name then
                                return pallet
                            else
                                task.wait(.1)
                            end
                        end
                    end
                end
                task.wait(.1)
            end
            return nil
        end
    end

    local function HidePallet(pallet)
        if not pallet then
            return false
        end
        local soundPart = pallet:FindFirstChild("SoundPart")
        if not soundPart then
            return false
        end
        for _, part in ipairs(pallet:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
                part.CanQuery = false
                part.Massless = true
            end
        end
        soundPart.CFrame = CFrame.new(0, 1000000000, 0)
        return true
    end

    PermanentPalletCfg.loopThread = task.spawn(function()
        while PermanentPalletCfg.enabled do
            local pallet = FindOwnPallet()
            if not pallet then
                pallet = SpawnPallet()
            end
            if pallet then
                PermanentPalletCfg.currentPallet = pallet
                PermanentPalletCfg.isReady = true
                HidePallet(pallet)
                local soundPart = pallet:FindFirstChild("SoundPart")
                if soundPart then
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if not owner or owner.Value ~= lp.Name then
                        setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                    end
                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                end
            else
                PermanentPalletCfg.isReady = false
                PermanentPalletCfg.currentPallet = nil
            end
            task.wait(0.5)
        end
        PermanentPalletCfg.currentPallet = nil
        PermanentPalletCfg.isReady = false
    end)
    print("[AMETHYST] ✅ Permanent Pallet активирован автоматически")
end)

local TargetTab = Window:CreateTab("Target")
local playersInPlotsFolder = S.Workspace:WaitForChild("PlotItems"):WaitForChild("PlayersInPlots")

local function IsPlayerInPlot(player)
    if not player then
        return false
    end
    return playersInPlotsFolder:FindFirstChild(player.Name) ~= nil
end

local targetData = {
    loopKick = {},
    ragdollLoopKick = {},
    loopBring = {}
}

local function ClearTargetGroup(groupName)
    if targetData[groupName] then
        for _, obj in pairs(targetData[groupName]) do
            if obj and typeof(obj) == "Instance" then
                pcall(function()
                    obj:Destroy()
                end)
            end
        end
        targetData[groupName] = {}
    end
end

local function TrackInstance(groupName, obj)
    if not targetData[groupName] then
        targetData[groupName] = {}
    end
    table.insert(targetData[groupName], obj)
    return obj
end

task.wait(0.5)
TargetTab:CreateSection("Select Player")

local function PlayerLabel(player)
    local display = player.DisplayName
    local name = player.Name
    if display and display ~= "" and display ~= name then
        return display .. " (" .. name .. ")" .. (IsPlayerInPlot(player) and " [PLOT]" or "")
    else
        return name .. (IsPlayerInPlot(player) and " [PLOT]" or "")
    end
end

local function GetPlayerList()
    local items = {}
    local mapping = {}
    for _, player in ipairs(S.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local label = PlayerLabel(player)
            table.insert(items, label)
            mapping[label] = player
        end
    end
    return items, mapping
end

local targetPlayerName = ""
local targetPlayer = nil

local function RefreshPlayerDropdown()
    local items, mapping = GetPlayerList()
    if targetDropdown then
        targetDropdown:Refresh(items, true)
        if Features.Selected.currentPlayer and Features.Selected.currentPlayer.Parent then
            targetDropdown:Set(PlayerLabel(Features.Selected.currentPlayer))
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        RefreshPlayerDropdown()
    end
end)

local targetDropdown = TargetTab:CreateDropdown({
    Name = "Select Target Player",
    Items = {},
    Default = "",
    Callback = function(selected)
        if selected == "" then
            Features.Selected.kickPlayer = nil
            Features.Selected.currentPlayer = nil
            return
        end
        local player = GetPlayerList()[selected]
        if player then
            Features.Selected.kickPlayer = player
            Features.Selected.currentPlayer = player
            Notify("Target Selected", "Target: " .. PlayerLabel(player), 2)
            PlayEnableSound()
        end
    end
})
RefreshPlayerDropdown()

S.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    RefreshPlayerDropdown()
end)
S.Players.PlayerRemoving:Connect(function(player)
    RefreshPlayerDropdown()
    if Features.Selected.currentPlayer == player then
        Features.Selected.kickPlayer = nil
        Features.Selected.currentPlayer = nil
        targetDropdown:Set("")
        Notify("Target", "Selected player left the game", 2)
    end
end)

playersInPlotsFolder.ChildAdded:Connect(RefreshPlayerDropdown)
playersInPlotsFolder.ChildRemoved:Connect(RefreshPlayerDropdown)

local function IsTargetAlive(player)
    return IsPlayerInPlot(player)
end

TargetTab:CreateSection("Grabs func")

TargetTab:CreateToggle({
    Name = "Fast kick",
    Default = false,
    Callback = function(state)
        if state then
            if not Features.Selected.kickPlayer then
                Notify("Error", "Select a target player first!", 3)
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                Notify("Error", "Enable Permanent Pallet first!", 3)
                return
            end
            ClearTargetGroup("ragdollLoopKick")
            local target = Features.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            RagdollLoopKickCfg.enabled = true
            RagdollLoopKickCfg.savedPos = nil
            RagdollLoopKickCfg.dragging = false
            RagdollLoopKickCfg.grabStart = 0
            RagdollLoopKickCfg.loopThread = task.spawn(function()
                if not (pallet and pallet:FindFirstChild("SoundPart")) then
                    RagdollLoopKickCfg.enabled = false
                    Notify("Error", "SoundPart not found!", 3)
                    return
                end
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local createGrabLine = grabEvents:WaitForChild("CreateGrabLine")
                local destroyGrabLine = grabEvents:WaitForChild("DestroyGrabLine")
                local attachHold, attachTarget, alignPos, alignOri = nil, nil, nil, nil
                local isHeld = false
                local heldSince = 0
                local soundPart = pallet.SoundPart
                while RagdollLoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if not targetRoot or not targetHum or not IsTargetAlive(target) then
                            ClearTargetGroup("ragdollLoopKick")
                            isHeld = false
                            task.wait()
                        else
                            if IsTargetAlive(target) then
                                task.wait(.1)
                            else
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -6, -10)
                                myRoot.Velocity = Vector3.zero
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                task.wait()
                                createGrabLine:FireServer(targetRoot)
                                destroyGrabLine:FireServer(targetRoot, Vector3.zero, targetRoot.Position, false)
                                targetHum.PlatformStand = true
                                targetHum.Sit = true
                                if not isHeld then
                                    heldSince = tick()
                                end
                                if tick() - heldSince > .4 then
                                    if targetHum.PlatformStand then
                                        isHeld = true
                                        myRoot.CFrame = myRoot.CFrame
                                        myRoot.Velocity = Vector3.zero
                                        attachHold = TrackInstance("ragdollLoopKick", Instance.new("Attachment", myRoot))
                                        attachHold.Name = "RagdollLoopKickAttHold"
                                        attachTarget = TrackInstance("ragdollLoopKick", Instance.new("Attachment", targetRoot))
                                        attachTarget.Name = "RagdollLoopKickAttTarget"
                                        alignPos = TrackInstance("ragdollLoopKick", Instance.new("AlignPosition"))
                                        alignPos.Attachment0 = attachTarget
                                        alignPos.Attachment1 = attachHold
                                        alignPos.MaxForce = math.huge
                                        alignPos.Responsiveness = math.huge
                                        alignPos.Name = "RagdollLoopKickAlignPos"
                                        alignPos.Parent = targetRoot
                                        alignOri = TrackInstance("ragdollLoopKick", Instance.new("AlignOrientation"))
                                        alignOri.Attachment0 = attachTarget
                                        alignOri.Attachment1 = attachHold
                                        alignOri.MaxTorque = math.huge
                                        alignOri.Responsiveness = math.huge
                                        alignOri.Name = "RagdollLoopKickAlignOri"
                                        alignOri.Parent = targetRoot
                                        targetHum:ChangeState(Enum.HumanoidStateType.Physics)
                                    else
                                        heldSince = tick()
                                    end
                                end
                                task.wait()
                            end
                            if targetChar and targetRoot then
                                setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                if attachHold then
                                    attachHold.Position = Vector3.new()
                                    attachTarget.CFrame = CFrame.new(0, 14.5, 0) * CFrame.Angles(math.rad((0 + 0 * .016) % 360), 0, 0)
                                end
                                if tick() - (isHeld and heldSince or 0) >= 0 then
                                    soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                    if not soundPart:FindFirstChild("PartOwner") then
                                        setOwner:FireServer(soundPart, soundPart.CFrame)
                                    end
                                    task.wait()
                                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                end
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("ragdollLoopKick")
                isHeld = false
            end)
            Notify("Ragdoll Loop Kick", "Enabled - Target: " .. target.Name, 3)
            PlayEnableSound()
        else
            RagdollLoopKickCfg.enabled = false
            if RagdollLoopKickCfg.loopThread then
                task.cancel(RagdollLoopKickCfg.loopThread)
                RagdollLoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("ragdollLoopKick")
            Notify("Ragdoll Loop Kick", "Disabled", 2)
        end
    end
})

TargetTab:CreateToggle({
    Name = "control kick",
    Default = false,
    Callback = function(state)
        if state then
            if not Features.Selected.kickPlayer then
                Notify("Error", "Select a target player first!", 3)
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                Notify("Error", "Enable Permanent Pallet first!", 3)
                return
            end
            local target = Features.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            ClearTargetGroup("ragdollLoopKick")
            RagdollLoopKickCfg.enabled = true
            RagdollLoopKickCfg.dragging = false
            RagdollLoopKickCfg.savedPos = nil
            RagdollLoopKickCfg.grabStart = 0
            RagdollLoopKickCfg.loopThread = task.spawn(function()
                if not (pallet and pallet:FindFirstChild("SoundPart")) then
                    RagdollLoopKickCfg.enabled = false
                    Notify("Error", "SoundPart not found!", 3)
                    return
                end
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                grabEvents:WaitForChild("CreateGrabLine")
                grabEvents:WaitForChild("DestroyGrabLine")
                local angleCache = {}
                local function getAngle(deg)
                    if not angleCache[deg] then
                        angleCache[deg] = CFrame.Angles(math.rad(deg), 0, 0)
                    end
                    return angleCache[deg]
                end
                while RagdollLoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        if not targetChar or not targetRoot or not targetHum or targetHum.Health <= 0 then
                            task.wait()
                        else
                            local soundPart = pallet:FindFirstChild("SoundPart")
                            if soundPart then
                                soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                if not soundPart:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(soundPart, soundPart.CFrame)
                                end
                                task.wait()
                                soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("ragdollLoopKick")
                return
            end)
            Notify("Ragdoll Loop Kick", "Enabled - Target: " .. target.Name, 3)
            PlayEnableSound()
        else
            RagdollLoopKickCfg.enabled = false
            if RagdollLoopKickCfg.loopThread then
                task.cancel(RagdollLoopKickCfg.loopThread)
                RagdollLoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("ragdollLoopKick")
            Notify("Ragdoll Loop Kick", "Disabled", 2)
        end
    end
})

TargetTab:CreateToggle({
    Name = "loop bring",
    Default = false,
    Callback = function(state)
        if state then
            if not Features.Selected.kickPlayer then
                Notify("Error", "Select a target player first!", 3)
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                Notify("Error", "Enable Permanent Pallet first!", 3)
                return
            end
            local target = Features.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            ClearTargetGroup("loopBring")
            LoopKickCfg.enabled = true
            LoopKickCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local soundPart = pallet:FindFirstChild("SoundPart")
                local attachHold, attachTarget, alignPos, alignOri = nil, nil, nil, nil
                while LoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if not targetChar or not targetHum or targetHum.Health <= 0 or not targetRoot then
                            ClearTargetGroup("loopBring")
                            task.wait()
                        else
                            if IsTargetAlive(target) then
                                task.wait(.4)
                            else
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -6, -10)
                                myRoot.Velocity = Vector3.zero
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                targetRoot.Velocity = Vector3.zero
                                targetRoot.AssemblyLinearVelocity = Vector3.zero
                                targetRoot.AssemblyAngularVelocity = Vector3.zero
                                targetRoot.RotVelocity = Vector3.zero
                                local holdSince = tick()
                                if tick() - holdSince > .35 then
                                    if targetRoot.Velocity.Magnitude < 5 then
                                        attachHold = TrackInstance("loopBring", Instance.new("Attachment", myRoot))
                                        attachHold.Name = "LoopBringAttHold"
                                        attachTarget = TrackInstance("loopBring", Instance.new("Attachment", targetRoot))
                                        attachTarget.Name = "LoopBringAttTarget"
                                        alignPos = TrackInstance("loopBring", Instance.new("AlignPosition"))
                                        alignPos.Attachment0 = attachTarget
                                        alignPos.Attachment1 = attachHold
                                        alignPos.MaxForce = math.huge
                                        alignPos.Responsiveness = 1000
                                        alignPos.Name = "LoopBringAlignPos"
                                        alignPos.Parent = targetRoot
                                        alignOri = TrackInstance("loopBring", Instance.new("AlignOrientation"))
                                        alignOri.Attachment0 = attachTarget
                                        alignOri.Attachment1 = attachHold
                                        alignOri.MaxTorque = math.huge
                                        alignOri.Responsiveness = 1000
                                        alignOri.Name = "LoopBringAlignOri"
                                        alignOri.Parent = targetRoot
                                        if soundPart then
                                            soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                            if not soundPart:FindFirstChild("PartOwner") then
                                                setOwner:FireServer(soundPart, soundPart.CFrame)
                                            end
                                            task.wait()
                                            soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                        end
                                        for _, part in pairs(targetRoot:GetChildren()) do
                                            if part:IsA("BasePart") then
                                                part.CustomPhysicalProperties = PhysicalProperties.new(.2, 0, 10)
                                            end
                                        end
                                    end
                                end
                            end
                            if attachHold and targetRoot then
                                setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                if soundPart then
                                    soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                    if not soundPart:FindFirstChild("PartOwner") then
                                        setOwner:FireServer(soundPart, soundPart.CFrame)
                                    end
                                    task.wait()
                                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                end
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("loopBring")
            end)
            Notify("Loop Kick (Hold + Pallet)", "Holding: " .. target.Name, 3)
            PlayEnableSound()
        else
            LoopKickCfg.enabled = false
            if LoopKickCfg.loopThread then
                task.cancel(LoopKickCfg.loopThread)
                LoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("loopBring")
            Notify("Loop Kick (Hold + Pallet)", "Disabled", 2)
        end
    end
})

TargetTab:CreateSection("removed")

TargetTab:CreateToggle({
    Name = "Remove Anti Kick",
    Default = false,
    Callback = function(state)
        if state then
            if not Features.Selected.kickPlayer then
                Notify("Error", "Select a target player first!", 3)
                return
            end
            RemoveAntiKickCfg.enabled = true
            RemoveAntiKickCfg.targetPlayer = Features.Selected.kickPlayer
            Notify("Remove Anti Kick", "Enabled - Target: " .. RemoveAntiKickCfg.targetPlayer.Name, 3)
            PlayEnableSound()
            RemoveAntiKickCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local target = RemoveAntiKickCfg.targetPlayer
                local processed = {}

                local function Claim(soundPart)
                    if not soundPart then
                        return false
                    end
                    setOwner:FireServer(soundPart, soundPart.CFrame)
                    task.wait()
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if owner and owner.Value == LocalPlayer.Name then
                        soundPart.CFrame = CFrame.new(0, 1000, 0)
                        return true
                    end
                    return false
                end

                while RemoveAntiKickCfg.enabled and target and target.Parent do
                    local folder = S.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in ipairs(folder:GetChildren()) do
                            for _, itemName in ipairs({ "NinjaKunai", "NinjaShuriken", "AntiKick" }) do
                                if toy.Name == itemName then
                                    local key = toy.Name .. "_" .. tostring(toy:GetDebugId())
                                    if not processed[key] then
                                        if Claim(toy) then
                                            processed[key] = true
                                        end
                                    end
                                end
                            end
                        end
                        for key in pairs(processed) do
                            if string.match(key, "_(%d+)$") then
                                local name = string.match(key, "^(.-)_")
                                local item = folder:FindFirstChild(name)
                                if not item or not item:IsDescendantOf(folder) then
                                    processed[key] = nil
                                end
                            end
                        end
                    end
                    task.wait()
                end
                RemoveAntiKickCfg.enabled = false
                RemoveAntiKickCfg.targetPlayer = nil
            end)
        else
            RemoveAntiKickCfg.enabled = false
            RemoveAntiKickCfg.targetPlayer = nil
            if RemoveAntiKickCfg.loopThread then
                task.cancel(RemoveAntiKickCfg.loopThread)
                RemoveAntiKickCfg.loopThread = nil
            end
            Notify("Remove Anti Kick", "Disabled", 2)
        end
    end
})

TargetTab:CreateSection("Blob Functions")

TargetTab:CreateToggle({
    Name = "Auto Sit Blob",
    Default = false,
    Callback = function(state)
        if state then
            AutoSitCfg.enabled = true
            AutoSitCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local spawnToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
                S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
                local function FindBlob()
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function SpawnBlob()
                    local canSpawn = lp:FindFirstChild("CanSpawnToy")
                    if canSpawn then
                        local start = tick()
                        while canSpawn.Value do
                            if tick() - start < 3 then
                                task.wait()
                            end
                            if not lp:FindFirstChild("CanSpawnToy").Value then
                                return nil
                            end
                        end
                        local char = lp.Character
                        if not char then
                            return nil
                        end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then
                            return nil
                        end
                        spawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(0, 0, 5), Vector3.new(0, 0, 0))
                        task.wait(0.3)
                        for _ = 1, 10 do
                            local blob = FindBlob()
                            if blob then
                                return blob
                            end
                            task.wait()
                        end
                        return nil
                    end
                end
                local function SitOnBlob(blob)
                    if not blob then
                        return false
                    end
                    local char = lp.Character
                    if not char then
                        return false
                    end
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not humanoid then
                        return false
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return false
                    end
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if not seat then
                        return false
                    end
                    if humanoid.SeatPart == seat then
                        return true
                    end
                    root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                    task.wait()
                    seat:Sit(humanoid)
                    task.wait()
                    return humanoid.SeatPart == seat
                end
                while AutoSitCfg.enabled do
                    if not lp.Character then
                        task.wait()
                    end
                    local blob = AutoSitCfg.currentBlob
                    if not blob or not blob.Parent then
                        blob = FindBlob()
                        if not blob then
                            blob = SpawnBlob()
                        end
                        if blob then
                            AutoSitCfg.currentBlob = blob
                            SitOnBlob(blob)
                        end
                    end
                    task.wait()
                end
                AutoSitCfg.currentBlob = nil
            end)
            Notify("Auto Sit Blob", "Enabled - Auto sitting on blob")
            PlayEnableSound()
        else
            AutoSitCfg.enabled = false
            if AutoSitCfg.loopThread then
                task.cancel(AutoSitCfg.loopThread)
                AutoSitCfg.loopThread = nil
            end
            AutoSitCfg.currentBlob = nil
            Notify("Auto Sit Blob", "Disabled")
        end
    end
})

TargetTab:CreateToggle({
    Name = "Blob Kill",
    Default = false,
    Callback = function(state)
        if state then
            if not Features.Selected.kickPlayer then
                Notify("Error", "Select a target player first!", 3)
                return
            end
            BlobKillCfg.enabled = true
            BlobKillCfg.selectedPlayers = { Features.Selected.kickPlayer }
            BlobKillCfg.currentBlob = nil
            BlobKillCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                while BlobKillCfg.enabled do
                    local char = lp.Character
                    if not char then
                        task.wait(0.5)
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 or not humanoid.SeatPart then
                            task.wait(0.5)
                        else
                            local blob = humanoid.SeatPart:FindFirstAncestor("CreatureBlobman")
                            local target = BlobKillCfg.selectedPlayers[1]
                            if blob and target and target.Character then
                                local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                                if seatScript then
                                    local grab = seatScript:FindFirstChild("CreatureGrab")
                                    local release = seatScript:FindFirstChild("CreatureRelease") or seatScript:FindFirstChild("CreatureDrop")
                                    local leftDet = blob:FindFirstChild("LeftDetector")
                                    local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                                    local rightDet = blob:FindFirstChild("RightDetector")
                                    local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                                    if grab and release then
                                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                                        if targetRoot then
                                            grab:FireServer(rightDet, targetRoot, rightWeld)
                                            task.wait(.1)
                                            if target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                                                target.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                                            end
                                            release:FireServer(rightWeld)
                                        end
                                    end
                                end
                            end
                            task.wait(1)
                        end
                    end
                end
                BlobKillCfg.currentBlob = nil
            end)
            Notify("Blob Kill", "Enabled - Target: " .. Features.Selected.kickPlayer.Name, 3)
            PlayEnableSound()
        else
            BlobKillCfg.enabled = false
            if BlobKillCfg.loopThread then
                task.cancel(BlobKillCfg.loopThread)
                BlobKillCfg.loopThread = nil
            end
            BlobKillCfg.currentBlob = nil
            BlobKillCfg.selectedPlayers = {}
            Notify("Blob Kill", "Disabled", 2)
        end
    end
})

TargetTab:CreateToggle({
    Name = "Blob - Simple Teleport Spam",
    Default = false,
    Callback = function(state)
        if state then
            if not Features.Selected.kickPlayer then
                Notify("Error", "Select target!", 2)
                return
            end
            local target = Features.Selected.kickPlayer
            TargetTab.SimpleSpamData = {
                active = true
            }
            TargetTab.SimpleSpamData.thread = task.spawn(function()
                while TargetTab.SimpleSpamData and TargetTab.SimpleSpamData.active do
                    if not LocalPlayer.Character then
                        task.wait(.1)
                    else
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetChar = target and target.Character
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if root and targetRoot then
                            root.CFrame = targetRoot.CFrame
                            task.wait(.05)
                        end
                    end
                end
            end)
            Notify("Simple Teleport Spam", "Enabled", 2)
        else
            if TargetTab.SimpleSpamData then
                TargetTab.SimpleSpamData.active = false
                if TargetTab.SimpleSpamData.thread then
                    task.cancel(TargetTab.SimpleSpamData.thread)
                end
                TargetTab.SimpleSpamData = nil
            end
            Notify("Simple Teleport Spam", "Disabled", 2)
        end
    end
})

local AurasTab = Window:CreateTab("Auras")
AurasTab:CreateSection("Ragdoll auras")

AurasTab:CreateToggle({
    Name = "Ragdoll Aura",
    Default = false,
    Callback = function(state)
        if state then
            if not PermanentPalletCfg.enabled then
                Notify("Error", "Enable Permanent Pallet first!", 3)
                return
            end
            local pallet = PermanentPalletCfg.currentPallet
            if not pallet or not pallet.Parent then
                Notify("Error", "Permanent Pallet not found!", 3)
                return
            end
            local soundPart = pallet:FindFirstChild("SoundPart")
            if not soundPart then
                Notify("Error", "Pallet has no SoundPart!", 3)
                return
            end
            local owner = soundPart:FindFirstChild("PartOwner")
            if not owner or owner.Value ~= LocalPlayer.Name then
                Notify("Error", "No ownership on pallet!", 3)
                return
            end
            RagdollAuraCfg.enabled = true
            RagdollAuraCfg.ragdolledPlayers = {}
            RagdollAuraCfg.isTeleportingPallet = false
            RagdollAuraCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local char = lp.Character
                if not char then
                    return
                end
                local myRoot = char:FindFirstChild("HumanoidRootPart")
                if not myRoot then
                    return
                end
                local setOwner = S.ReplicatedStorage.GrabEvents.SetNetworkOwner
                local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote

                local function EnsureOwnership(soundPart)
                    if not soundPart then
                        return false
                    end
                    if not soundPart.Parent then
                        return false
                    end
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if not owner or owner.Value ~= lp.Name then
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                    end
                    return true
                end

                local function RagdollTarget(player)
                    if not player or player == lp then
                        return false
                    end
                    local pChar = player.Character
                    if not pChar then
                        return false
                    end
                    local root = pChar:FindFirstChild("HumanoidRootPart")
                    local humanoid = pChar:FindFirstChild("Humanoid")
                    if not root then
                        return false
                    end
                    if (root.Position - myRoot.Position).Magnitude > 30 then
                        RagdollAuraCfg.ragdolledPlayers[player] = nil
                        return false
                    end
                    if soundPart and soundPart.CFrame then
                        setOwner:FireServer(root, root.CFrame)
                        soundPart.CFrame = root.CFrame * CFrame.new(0, 0, 0.5)
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                        task.wait()
                        soundPart.CFrame = CFrame.new(0, 10000, 0)
                        task.wait()
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                    end
                    RagdollAuraCfg.ragdolledPlayers[player] = os.clock()
                    return true
                end

                while RagdollAuraCfg.enabled do
                    local pChar = lp.Character
                    if pChar then
                        myRoot = pChar:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                                print("[Ragdoll Aura] Permanent Pallet отключилась")
                            else
                                if not EnsureOwnership(soundPart) then
                                    print("[Ragdoll Aura] Не удалось установить ownership на паллет")
                                else
                                    for player, lastTime in pairs(RagdollAuraCfg.ragdolledPlayers) do
                                        if os.clock() - lastTime > 1 then
                                            RagdollAuraCfg.ragdolledPlayers[player] = nil
                                        end
                                    end
                                    local near = {}
                                    for _, player in pairs(S.Players:GetPlayers()) do
                                        if player ~= lp and player.Character then
                                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                                            if root and (root.Position - myRoot.Position).Magnitude <= 30 then
                                                table.insert(near, player)
                                            end
                                        end
                                    end
                                    for i, player in ipairs(near) do
                                        if RagdollAuraCfg.enabled then
                                            RagdollTarget(player)
                                            if i % 3 == 0 then
                                                task.wait()
                                            end
                                        end
                                    end
                                    task.wait()
                                end
                            end
                        end
                    end
                    task.wait()
                end
                RagdollAuraCfg.ragdolledPlayers = {}
            end)
            task.spawn(function()
                while RagdollAuraCfg.enabled do
                    if RagdollAuraCfg.enabled and not PermanentPalletCfg.enabled then
                        print("[Ragdoll Aura] Permanent Pallet отключилась, отключаем...")
                        if RagdollAuraCfg.loopThread then
                            task.cancel(RagdollAuraCfg.loopThread)
                            RagdollAuraCfg.loopThread = nil
                        end
                        RagdollAuraCfg.enabled = false
                        RagdollAuraCfg.ragdolledPlayers = {}
                        RagdollAuraCfg.isTeleportingPallet = false
                        break
                    else
                        task.wait(1)
                    end
                end
            end)
            Notify("Ragdoll Aura", "Enabled", 3)
            PlayEnableSound()
        else
            RagdollAuraCfg.enabled = false
            if RagdollAuraCfg.loopThread then
                task.cancel(RagdollAuraCfg.loopThread)
                RagdollAuraCfg.loopThread = nil
            end
            RagdollAuraCfg.ragdolledPlayers = {}
            RagdollAuraCfg.isTeleportingPallet = false
            Notify("Ragdoll Aura", "Disabled", 2)
        end
    end
})

AurasTab:CreateSection("Blob Auras")

AurasTab:CreateToggle({
    Name = "Auto Sit Blob",
    Default = false,
    Callback = function(state)
        if state then
            AutoSitCfg.enabled = true
            AutoSitCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local spawnToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
                S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
                local function FindBlob()
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function SpawnBlob()
                    local canSpawn = lp:FindFirstChild("CanSpawnToy")
                    if canSpawn then
                        local start = tick()
                        while canSpawn.Value do
                            if tick() - start < 3 then
                                task.wait()
                            end
                            if not lp:FindFirstChild("CanSpawnToy").Value then
                                return nil
                            end
                        end
                        local char = lp.Character
                        if not char then
                            return nil
                        end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then
                            return nil
                        end
                        spawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(0, 0, 5), Vector3.new(0, 0, 0))
                        task.wait(0.3)
                        for _ = 1, 10 do
                            local blob = FindBlob()
                            if blob then
                                return blob
                            end
                            task.wait()
                        end
                        return nil
                    end
                end
                local function SitOnBlob(blob)
                    if not blob then
                        return false
                    end
                    local char = lp.Character
                    if not char then
                        return false
                    end
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not humanoid then
                        return false
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return false
                    end
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if not seat then
                        return false
                    end
                    if humanoid.SeatPart == seat then
                        return true
                    end
                    root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                    task.wait()
                    seat:Sit(humanoid)
                    task.wait()
                    return humanoid.SeatPart == seat
                end
                while AutoSitCfg.enabled do
                    if not lp.Character then
                        task.wait()
                    end
                    local blob = AutoSitCfg.currentBlob
                    if not blob or not blob.Parent then
                        blob = FindBlob()
                        if not blob then
                            blob = SpawnBlob()
                        end
                        if blob then
                            AutoSitCfg.currentBlob = blob
                            SitOnBlob(blob)
                        end
                    end
                    task.wait()
                end
                AutoSitCfg.currentBlob = nil
            end)
            Notify("Auto Sit Blob", "Enabled - Auto sitting on blob")
            PlayEnableSound()
        else
            AutoSitCfg.enabled = false
            if AutoSitCfg.loopThread then
                task.cancel(AutoSitCfg.loopThread)
                AutoSitCfg.loopThread = nil
            end
            AutoSitCfg.currentBlob = nil
            Notify("Auto Sit Blob", "Disabled")
        end
    end
})

AurasTab:CreateToggle({
    Name = "Kill Aura (Blob)",
    Default = false,
    Callback = function(state)
        if state then
            KillAuraCfg.enabled = true
            KillAuraCfg.killCooldown = {}
            KillAuraCfg.targetPlayers = {}
            KillAuraCfg.lastKillTime = 0
            KillAuraCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local ws = S.Workspace
                local function FindBlob()
                    local folder = ws:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function GetBlobRemotes(blob)
                    if not blob then
                        return nil
                    end
                    local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                    if not seatScript then
                        return nil
                    end
                    local leftDet = blob:FindFirstChild("LeftDetector")
                    local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                    local rightDet = blob:FindFirstChild("RightDetector")
                    local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                    return {
                        grab = seatScript:FindFirstChild("CreatureGrab"),
                        release = seatScript:FindFirstChild("CreatureRelease") or seatScript:FindFirstChild("CreatureDrop"),
                        leftDet = leftDet,
                        leftWeld = leftWeld,
                        rightDet = rightDet,
                        rightWeld = rightWeld
                    }
                end
                local function TryKill(player, blob, useLeft)
                    if not player or player == lp then
                        return false
                    end
                    local pChar = player.Character
                    if not pChar then
                        return false
                    end
                    local root = pChar:FindFirstChild("HumanoidRootPart")
                    local humanoid = pChar:FindFirstChild("Humanoid")
                    if not root or not humanoid or humanoid.Health <= 0 then
                        return false
                    end
                    local myChar = lp.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        return false
                    end
                    if (myRoot.Position - root.Position).Magnitude > 30 then
                        return false
                    end
                    local now = tick()
                    if KillAuraCfg.killCooldown[player] and now - KillAuraCfg.killCooldown[player] < 1 then
                        return false
                    end
                    local remotes = GetBlobRemotes(blob)
                    if not remotes or not remotes.grab or not remotes.release then
                        return false
                    end
                    local det = useLeft and remotes.leftDet or remotes.rightDet
                    local weld = useLeft and remotes.leftWeld or remotes.rightWeld
                    if not det or not weld then
                        return false
                    end
                    pcall(function()
                        remotes.grab:FireServer(det, root, weld)
                        task.wait(.0001)
                        remotes.release:FireServer(weld)
                    end)
                    task.wait(.0002)
                    pcall(function()
                        if humanoid and humanoid.Health > 0 then
                            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                        end
                    end)
                    KillAuraCfg.killCooldown[player] = now
                    KillAuraCfg.lastKillTime = now
                    return true
                end
                while KillAuraCfg.enabled do
                    local char = lp.Character
                    if not char then
                        task.wait()
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 then
                            task.wait(0)
                        else
                            local seatPart = humanoid.SeatPart
                            if not seatPart or not seatPart:IsDescendantOf(ws) then
                                task.wait(0.5)
                            else
                                local blob = seatPart:FindFirstAncestor("CreatureBlobman")
                                if not blob or not blob.Parent then
                                    task.wait(0.5)
                                else
                                    KillAuraCfg.currentBlob = blob
                                    local near = {}
                                    for _, player in ipairs(S.Players:GetPlayers()) do
                                        if player ~= lp and player.Character then
                                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                                            local human = player.Character:FindFirstChild("Humanoid")
                                            if root and human and human.Health > 0 then
                                                local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
                                                if myRoot and (myRoot.Position - root.Position).Magnitude <= 30 then
                                                    table.insert(near, player)
                                                end
                                            end
                                        end
                                    end
                                    for i, player in ipairs(near) do
                                        if KillAuraCfg.enabled then
                                            if TryKill(player, blob, true) then
                                                if (i + 1) % 3 == 0 then
                                                    task.wait()
                                                end
                                            end
                                        end
                                    end
                                    KillAuraCfg.targetPlayers = near
                                    for player, cooldown in pairs(KillAuraCfg.killCooldown) do
                                        if tick() - cooldown > 1e-05 then
                                            KillAuraCfg.killCooldown[player] = nil
                                        end
                                    end
                                    task.wait(.1)
                                end
                            end
                        end
                    end
                end
                KillAuraCfg.currentBlob = nil
                KillAuraCfg.spawningBlob = false
                KillAuraCfg.killCooldown = {}
                KillAuraCfg.targetPlayers = {}
                KillAuraCfg.lastKillTime = 0
                print("[Kill Aura] Цикл остановлен")
            end)
            Notify("Kill Aura", "Enabled", 3)
            PlayEnableSound()
        else
            KillAuraCfg.enabled = false
            if KillAuraCfg.loopThread then
                task.cancel(KillAuraCfg.loopThread)
                KillAuraCfg.loopThread = nil
            end
            KillAuraCfg.currentBlob = nil
            KillAuraCfg.spawningBlob = false
            KillAuraCfg.killCooldown = {}
            KillAuraCfg.targetPlayers = {}
            KillAuraCfg.lastKillTime = 0
            Notify("Kill Aura", "Disabled", 2)
        end
    end
})

AurasTab:CreateToggle({
    Name = "Dual Lock Aura",
    Default = false,
    Callback = function(state)
        if state then
            AdvancedDuallockCfg.enabled = true
            AdvancedDuallockCfg.processedPlayers = {}
            AdvancedDuallockCfg.originalBarrierState = {}
            local function DisableBarriers()
                local plots = S.Workspace:FindFirstChild("Plots")
                if plots then
                    for _, plot in ipairs(plots:GetChildren()) do
                        local barrier = plot:FindFirstChild("Barrier")
                        if barrier then
                            for _, part in ipairs(barrier:GetChildren()) do
                                if part:IsA("BasePart") and part.Name == "PlotBarrier" then
                                    AdvancedDuallockCfg.originalBarrierState[part] = part.CanCollide
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end
            AdvancedDuallockCfg.loopThread = task.spawn(function()
                while AdvancedDuallockCfg.enabled do
                    DisableBarriers()
                    task.wait()
                end
            end)
            Notify("Dual Lock Aura", "Enabled", 3)
            PlayEnableSound()
        else
            AdvancedDuallockCfg.enabled = false
            if AdvancedDuallockCfg.loopThread then
                task.cancel(AdvancedDuallockCfg.loopThread)
                AdvancedDuallockCfg.loopThread = nil
            end
            for part, state in pairs(AdvancedDuallockCfg.originalBarrierState) do
                if part and part:IsA("BasePart") then
                    part.CanCollide = state
                end
            end
            AdvancedDuallockCfg.originalBarrierState = {}
            AdvancedDuallockCfg.currentBlob = nil
            AdvancedDuallockCfg.processedPlayers = {}
            Notify("Dual Lock Aura", "Disabled", 2)
        end
    end
})

AurasTab:CreateToggle({
    Name = "Destroy Kick Aura",
    Default = false,
    Callback = function(state)
        if state then
            DestroyKickAuraCfg.enabled = true
            DestroyKickAuraCfg.processedPlayers = {}
            DestroyKickAuraCfg.isSpawning = false
            DestroyKickAuraCfg.lastSpawnTime = 0
            DestroyKickAuraCfg.spawnInterval = 0
            local function BlobOfSeat(humanoid)
                local seat = humanoid.SeatPart
                if seat then
                    return seat:FindFirstAncestor("CreatureBlobman")
                end
                return nil
            end
            local function IsAlive(player)
                if not player or not player.Character then
                    return false
                end
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if not humanoid then
                    return false
                end
                return humanoid.Health > 0
            end
            local function CleanupProcessed()
                for player in pairs(DestroyKickAuraCfg.processedPlayers) do
                    if not player:IsDescendantOf(S.Players) or not player.Character or not IsAlive(player) then
                        DestroyKickAuraCfg.processedPlayers[player] = nil
                    end
                end
            end
            local function GetNearbyPlayers(range)
                local char = LocalPlayer.Character
                if not char then
                    return {}
                end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then
                    return {}
                end
                local pos = root.Position
                CleanupProcessed()
                local near = {}
                for _, player in ipairs(S.Players:GetPlayers()) do
                    if player ~= LocalPlayer and IsAlive(player) then
                        local pChar = player.Character
                        if pChar then
                            local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                            if pRoot and (pRoot.Position - pos).Magnitude <= range then
                                table.insert(near, player)
                            end
                        end
                    end
                end
                return near
            end
            local function KickPlayer(player)
                local lpChar = LocalPlayer.Character
                if not lpChar then
                    return
                end
                local head = lpChar:WaitForChild("Head", 2)
                local lpRoot = lpChar:WaitForChild("HumanoidRootPart", 2)
                if not head or not lpRoot then
                    return
                end
                local pChar = player.Character
                if not pChar then
                    return
                end
                local pRoot = pChar:WaitForChild("HumanoidRootPart", 2)
                if not pRoot then
                    return
                end
                local grabEvents = S.ReplicatedStorage:FindFirstChild("GrabEvents")
                local createGrabLine = grabEvents and grabEvents:FindFirstChild("CreateGrabLine")
                if createGrabLine then
                    createGrabLine:FireServer(pRoot, pRoot.CFrame)
                    task.wait(.1)
                    S.ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(pRoot, pRoot.CFrame)
                    task.wait(.1)
                    pRoot.CFrame = head.CFrame * CFrame.new(0, 12, 0)
                    task.wait(.1)
                    S.ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(pRoot)
                    task.wait()
                    S.ReplicatedStorage.GrabEvents.EndGrabEarly:FireServer(pRoot)
                    task.wait()
                end
                local lpHumanoid = lpChar:FindFirstChild("Humanoid")
                if lpHumanoid then
                    local blob = BlobOfSeat(lpHumanoid)
                    if blob then
                        local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                        local rightDet = blob:FindFirstChild("RightDetector")
                        local leftDet = blob:FindFirstChild("LeftDetector")
                        if seatScript then
                            local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                            local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                            local grabRemote = seatScript:FindFirstChild("CreatureGrab")
                            if grabRemote then
                                if rightWeld then
                                    grabRemote:FireServer(rightDet, pChar:WaitForChild("HumanoidRootPart", 2), rightWeld)
                                    task.wait(.1)
                                end
                                if leftWeld then
                                    grabRemote:FireServer(leftDet, pChar:WaitForChild("HumanoidRootPart", 2), leftWeld)
                                    task.wait(.1)
                                end
                            end
                        end
                    end
                end
                DestroyKickAuraCfg.processedPlayers[player] = true
            end
            DestroyKickAuraCfg.loopThread = task.spawn(function()
                while DestroyKickAuraCfg.enabled do
                    local char = LocalPlayer.Character
                    if not char then
                        task.wait(.1)
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 then
                            task.wait(.1)
                        else
                            local seatPart = humanoid.SeatPart
                            if not seatPart or not seatPart:IsDescendantOf(S.Workspace) then
                                task.wait(0.5)
                            else
                                local blob = seatPart:FindFirstAncestor("CreatureBlobman")
                                if not blob or not blob.Parent then
                                    task.wait(0.5)
                                else
                                    DestroyKickAuraCfg.currentBlob = blob
                                    local near = GetNearbyPlayers(30)
                                    for _, player in ipairs(near) do
                                        if DestroyKickAuraCfg.enabled then
                                            KickPlayer(player)
                                            if #GetNearbyPlayers(30) > 1 then
                                                task.wait(.1)
                                            end
                                        end
                                    end
                                    CleanupProcessed()
                                    if #near == 0 then
                                        task.wait(.1)
                                    else
                                        task.wait()
                                    end
                                end
                            end
                        end
                    end
                end
                DestroyKickAuraCfg.currentBlob = nil
                DestroyKickAuraCfg.processedPlayers = {}
                DestroyKickAuraCfg.isSpawning = false
                print("[Destroy Kick Aura] Цикл остановлен")
            end)
            Notify("Destroy Kick Aura", "Enabled", 3)
            PlayEnableSound()
        else
            DestroyKickAuraCfg.enabled = false
            if DestroyKickAuraCfg.loopThread then
                task.cancel(DestroyKickAuraCfg.loopThread)
                DestroyKickAuraCfg.loopThread = nil
            end
            DestroyKickAuraCfg.currentBlob = nil
            DestroyKickAuraCfg.processedPlayers = {}
            DestroyKickAuraCfg.isSpawning = false
            Notify("Destroy Kick Aura", "Disabled", 2)
        end
    end
})

AurasTab:CreateSection("Kick Auras")

AurasTab:CreateToggle({
    Name = "Kick Aura (Fixed)",
    Default = false,
    Callback = function(state)
        if state then
            KickAuraFixedCfg.enabled = true
            KickAuraFixedCfg.fixedPlayers = {}
            KickAuraFixedCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage.GrabEvents
                local setOwner = grabEvents.SetNetworkOwner
                local destroyGrabLine = grabEvents.DestroyGrabLine
                local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
                local offsets = {
                    Vector3.new(-4, 15, -4),
                    Vector3.new(4, 15, -4),
                    Vector3.new(-4, 15, 4),
                    Vector3.new(4, 15, 4)
                }
                while KickAuraFixedCfg.enabled do
                    if not LocalPlayer.Character then
                        break
                    end
                    task.wait()
                end
            end)
            Notify("Kick Aura (Fixed)", "Enabled", 3)
            PlayEnableSound()
        else
            KickAuraFixedCfg.enabled = false
            if KickAuraFixedCfg.loopThread then
                task.cancel(KickAuraFixedCfg.loopThread)
                KickAuraFixedCfg.loopThread = nil
            end
            for _, data in pairs(KickAuraFixedCfg.fixedPlayers) do
                if data.alignPos and data.alignPos.Parent then
                    data.alignPos:Destroy()
                end
                if data.alignOri and data.alignOri.Parent then
                    data.alignOri:Destroy()
                end
            end
            KickAuraFixedCfg.fixedPlayers = {}
            Notify("Kick Aura (Fixed)", "Disabled", 2)
        end
    end
})

AurasTab:CreateToggle({
    Name = "Jump Kick Aura",
    Default = false,
    Callback = function(state)
        if state then
            JumpKickAuraCfg.enabled = true
            JumpKickAuraCfg.processedPlayers = {}
            JumpKickAuraCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage.GrabEvents
                local setOwner = grabEvents.SetNetworkOwner
                local destroyGrabLine = grabEvents.DestroyGrabLine
                while JumpKickAuraCfg.enabled do
                    if not LocalPlayer.Character then
                        break
                    end
                    task.wait()
                end
            end)
            Notify("Jump Kick Aura", "Enabled", 3)
            PlayEnableSound()
        else
            JumpKickAuraCfg.enabled = false
            if JumpKickAuraCfg.loopThread then
                task.cancel(JumpKickAuraCfg.loopThread)
                JumpKickAuraCfg.loopThread = nil
            end
            JumpKickAuraCfg.processedPlayers = {}
            Notify("Jump Kick Aura", "Disabled", 2)
        end
    end
})

local ServerTab = Window:CreateTab("Server")
ServerTab:CreateSection("Server Lag")

local lagRiskLabel = nil
local packetSizeLabel = nil

local function UpdateLagLabels()
    if packetSizeLabel then
        packetSizeLabel.Text = "Size: " .. Features.PacketLag.packetSize
        if Features.PacketLag.packetSize > 600000 then
            packetSizeLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            if lagRiskLabel then
                lagRiskLabel.Text = "⚠️ HIGH LAG WARNING! ⚠️"
                lagRiskLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        elseif Features.PacketLag.packetSize > 200000 then
            packetSizeLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            if lagRiskLabel then
                lagRiskLabel.Text = "⚠️ Medium lag risk ⚠️"
                lagRiskLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            end
        else
            packetSizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            if lagRiskLabel then
                lagRiskLabel.Text = "Low lag risk"
                lagRiskLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end
end

local function StopPacketLag()
    if Features.PacketLag.loopThread then
        task.cancel(Features.PacketLag.loopThread)
        Features.PacketLag.loopThread = nil
    end
    Features.PacketLag.enabled = false
    if lagRiskLabel then
        lagRiskLabel.Text = "Stopped"
        lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    Notify("Packet Lag", "Disabled", 2)
    task.delay(2, function()
        if lagRiskLabel then
            UpdateLagLabels()
        end
    end)
end

local function StartPacketLag()
    Features.PacketLag.enabled = true
    if lagRiskLabel then
        lagRiskLabel.Text = "STARTING..."
        lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    Features.PacketLag.loopThread = task.spawn(function()
        local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
        local extendRemote = grabEvents:WaitForChild("ExtendGrabLine")
        if not extendRemote then
            warn("[Packet Lag] ExtendGrabLine RemoteEvent not found!")
            StopPacketLag()
            return
        end
        if lagRiskLabel then
            lagRiskLabel.Text = "LAGGING SERVER..."
            lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        end
        Notify("Packet Lag", "Enabled - Packet Size: " .. Features.PacketLag.packetSize, 3)
        PlayEnableSound()
        while Features.PacketLag.enabled do
            extendRemote:FireServer(string.rep("❤️❤️❤️❤️❤️😘😘😘😘😍😍😍😍❤️❤️❤️❤️❤️😘😘😘😘😍😍😍😍❤️❤️❤️❤️❤️😘😘😘😘😍😍😍😍❤️❤️❤️", math.floor(Features.PacketLag.packetSize / 10)))
            print("[Packet Lag] Sent packet size: " .. Features.PacketLag.packetSize)
            task.wait(3e-05)
        end
    end)
end

local packetSizeSlider = ServerTab:CreateSlider({
    Name = "Packet Size",
    Min = 100,
    Max = 1000000,
    Default = 50000,
    Callback = function(value)
        Features.PacketLag.packetSize = value
        UpdateLagLabels()
    end
})

task.spawn(function()
    task.wait(0.5)
    local sliderUI = packetSizeSlider:GetUI()
    if sliderUI then
        for _, item in pairs(sliderUI:GetChildren()) do
            if item:IsA("TextLabel") then
                if string.find(item.Text, "Size:") or item.Name == "ValueLabel" or item.Name == "Value" then
                    packetSizeLabel = item
                end
            end
        end
        if not packetSizeLabel then
            packetSizeLabel = Instance.new("TextLabel")
            packetSizeLabel.Size = UDim2.new(1, -20, 0, 20)
            packetSizeLabel.Position = UDim2.new(0, 10, 0, 70)
            packetSizeLabel.BackgroundTransparency = 1
            packetSizeLabel.Text = "Size: " .. Features.PacketLag.packetSize
            packetSizeLabel.Font = Enum.Font.Gotham
            packetSizeLabel.TextSize = 12
            packetSizeLabel.TextXAlignment = Enum.TextXAlignment.Center
            packetSizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            packetSizeLabel.Parent = sliderUI
        end
        lagRiskLabel = Instance.new("TextLabel")
        lagRiskLabel.Size = UDim2.new(1, -20, 0, 20)
        lagRiskLabel.Position = UDim2.new(0, 10, 0, 90)
        lagRiskLabel.BackgroundTransparency = 1
        lagRiskLabel.Text = "Low lag risk"
        lagRiskLabel.Font = Enum.Font.GothamBold
        lagRiskLabel.TextSize = 11
        lagRiskLabel.TextXAlignment = Enum.TextXAlignment.Center
        lagRiskLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        lagRiskLabel.Parent = sliderUI
        UpdateLagLabels()
    end
end)

ServerTab:CreateToggle({
    Name = "Packet Lag",
    Default = false,
    Callback = function(state)
        if state then
            StartPacketLag()
        else
            StopPacketLag()
        end
    end
})

ServerTab:CreateSection("Line Lag")

ServerTab:CreateToggle({
    Name = "Line Lag (Server Lag)",
    Default = false,
    Callback = function(state)
        if state then
            ServerLagCfg.enabled = true
            task.spawn(function()
                if ServerLagCfg.enabled then
                    local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                    local createGrabLine = grabEvents:WaitForChild("CreateGrabLine")
                    if not createGrabLine then
                        warn("[Server Lag] CreateGrabLine RemoteEvent not found!")
                        ServerLagCfg.enabled = false
                        Notify("Server Lag", "Error: CreateGrabLine not found!", 3)
                        return
                    end
                    print("[Server Lag] Started!")
                    ServerLagCfg.loopThread = task.spawn(function()
                        while ServerLagCfg.enabled do
                            local spawnLoc = S.Workspace:FindFirstChild("SpawnLocation")
                            if spawnLoc then
                                for y = 0, 50 do
                                    if not ServerLagCfg.enabled then
                                        break
                                    end
                                    createGrabLine:FireServer(CFrame.new(0, y, 0))
                                    task.wait(.005)
                                end
                            end
                            task.wait(.1)
                        end
                    end)
                    Notify("Server Lag", "Enabled - Lagging server with lines", 3)
                    PlayEnableSound()
                end
            end)
        else
            ServerLagCfg.enabled = false
            if ServerLagCfg.loopThread then
                task.cancel(ServerLagCfg.loopThread)
                ServerLagCfg.loopThread = nil
            end
            Notify("Server Lag", "Disabled", 2)
            print("[Server Lag] Stopped")
        end
    end
})
return