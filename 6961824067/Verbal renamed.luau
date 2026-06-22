local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")

local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local StruggleEvent = CharacterEvents:WaitForChild("Struggle")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local CreateGrabLine = GrabEvents:WaitForChild("CreateGrabLine")
local DestroyGrabLine = GrabEvents:WaitForChild("DestroyGrabLine")
local DestroyToy = MenuToys:WaitForChild("DestroyToy")
local BombExplode = ReplicatedStorage:WaitForChild("BombEvents"):WaitForChild("BombExplode")
local UpdateLineColorsEvent = ReplicatedStorage:WaitForChild("DataEvents"):WaitForChild("UpdateLineColorsEvent")
local RagdollRemote = ReplicatedStorage:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote")
local ChatTypingEvent = CharacterEvents:WaitForChild("ChatTyping")
local StopAllVelocity = ReplicatedStorage:WaitForChild("GameCorrectionEvents"):WaitForChild("StopAllVelocity")
local SpawnToyRemote = MenuToys:WaitForChild("SpawnToyRemoteFunction")

local LocalPlayer = Players.LocalPlayer
local PlayerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(newChar)
    PlayerCharacter = newChar
end)

local SpawnedInToysFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")

local bombCacheChildAddedConn = nil
local bombCacheCoroutine = nil
local autoRecoverCoroutine = nil
local anchoredPartsList = {}
local partOwnerConnections = {}
local compiledGroups = {}
local cframeChangedConnections = {}
local compileCoroutineRef = nil
local anchorGrabCoroutine = nil
local antiExplosionConnection = nil
local autoAttackerCoroutine = nil
local fireAllCoroutine = nil
local noclipGrabCoroutine = nil
local radioactiveGrabCoroutine = nil
local poisonAuraCoroutine = nil
local renderSteppedConnections = {}
local orbitAuraConnection = nil
local enhancedAuraConnection = nil

local ownedToys = {}
local bombList = {}
local playerList = {}

_G.ToyToLoad = "BombMissile"
_G.MaxMissiles = 9
_G.BlobmanDelay = 0.005

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/Orion%20Hub%20Ui", true))()

local Window = OrionLib:MakeWindow({
    Name = "Verbal Hub Sigma Advance Ftap",
    HidePremium = false,
    SaveConfig = true,
    IntroEnabled = true,
    IntroText = "Welcome To Verbal Sigma Hub Ftap",
    IntroIcon = "rbxassetid://121559441445555",
    ConfigFolder = "OrionTest"
})

local function destroyToy(toyModel)
    local target = toyModel or SpawnedInToysFolder:FindFirstChildWhichIsA("Model")
    DestroyToy:FireServer(target)
end

local function getNearestPlayer()
    local nearestDistance = math.huge
    local nearestPlayer = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (PlayerCharacter.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestPlayer = plr
                nearestDistance = distance
            end
        end
    end
    return nearestPlayer
end

local function spawnItemAt(toyName, cframePos)
    task.spawn(function()
        SpawnToyRemote:InvokeServer(toyName, cframePos, Vector3.new(0, 0, 0))
    end)
end

local function getDescendantPartsByName(partName)
    local parts = {}
    for _, descendant in ipairs(Workspace.Map:GetDescendants()) do
        if descendant:IsA("Part") and descendant.Name == partName then
            table.insert(parts, descendant)
        end
    end
    return parts
end

local poisonHurtParts = getDescendantPartsByName("PoisonHurtPart")
local paintPlayerParts = getDescendantPartsByName("PaintPlayerPart")

local function isDescendantOf(child, ancestor)
    local parent = child.Parent
    while parent do
        if parent == ancestor then
            return true
        end
        parent = parent.Parent
    end
    return false
end

local function findDescendantByName(parent, name)
    for _, descendant in ipairs(parent:GetDescendants()) do
        if descendant.Name == name then
            return descendant
        end
    end
    return nil
end

local function findFirstAncestorOfType(instance, type)
    return instance and instance:FindFirstAncestorWhichIsA(type) or nil
end

local function cleanupConnections(connectionTable)
    for _, conn in ipairs(connectionTable) do
        conn:Disconnect()
    end
    for i = #connectionTable, 1, -1 do
        table.remove(connectionTable, i)
    end
end

for _, child in pairs(LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MenuGui"):WaitForChild("Menu"):WaitForChild("TabContents"):WaitForChild("Toys"):WaitForChild("Contents"):GetChildren()) do
    if child.Name ~= "UIGridLayout" then
        ownedToys[child.Name] = true
    end
end

Players.PlayerAdded:Connect(function(plr)
    table.insert(playerList, plr.Name)
end)
Players.PlayerRemoving:Connect(function(plr)
    for i, name in ipairs(playerList) do
        if name == plr.Name then
            table.remove(playerList, i)
            break
        end
    end
end)

local playerChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = playerChar:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local fireFlailAnim = game:GetService("ReplicatedFirst"):WaitForChild("CatchFire"):WaitForChild("FireFlailAnimation")
local fireAnimTrack = animator:LoadAnimation(fireFlailAnim)

local function playFireAnimation()
    fireAnimTrack:Play()
end

local function stopFireAnimation()
    fireAnimTrack:Stop()
end

local SigmaPlayerTab = Window:MakeTab({
    Name = "Sigma Player",
    Icon = "rbxassetid://18778642981",
    PremiumOnly = false
})

SigmaPlayerTab:AddButton({
    Name = "Our WebSite,Socials",
    Callback = function()
        setclipboard("https://guns.lol/itsjose")
        OrionLib:MakeNotification({
            Name = "You Copied The Discord Link",
            Content = "WebSite link copied to clipboard!",
            Image = "rbxassetid://4483345998",
            Time = 4
        })
    end
})

SigmaPlayerTab:AddToggle({
    Name = " Fire Animation",
    Default = false,
    Callback = function(enabled)
        if enabled then playFireAnimation() else stopFireAnimation() end
    end
})

local infiniteJumpEnabled = true
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

SigmaPlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(enabled)
        infiniteJumpEnabled = enabled
    end
})

SigmaPlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 1000,
    Default = 5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "bananas",
    Callback = function(speed)
        local hackedSpeed = speed
        local myChar = LocalPlayer.Character
        if myChar then
            local hum = myChar.Humanoid
            hum.Changed:Connect(function()
                hum.WalkSpeed = hackedSpeed
            end)
            hum.WalkSpeed = hackedSpeed
        end
        LocalPlayer.CharacterAdded:Connect(function(newChar)
            repeat wait() until newChar:FindFirstChild("Humanoid")
            local newHum = newChar.Humanoid
            newHum.Changed:Connect(function()
                newHum.WalkSpeed = hackedSpeed
            end)
            newHum.WalkSpeed = hackedSpeed
        end)
    end
})

SigmaPlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 20,
    Max = 10000,
    Default = 20,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "power",
    Callback = function(power)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.JumpPower = power
            end
        end
    end
})

local teleportActive = false
local function setupTeleportCharacter(char)
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local mouse = LocalPlayer:GetMouse()
    mouse.KeyDown:Connect(function(key)
        if key == "z" and teleportActive and mouse.Target then
            rootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0))
        end
    end)
end

if LocalPlayer.Character then
    setupTeleportCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(setupTeleportCharacter)

local teleportSection = SigmaPlayerTab:AddSection({ Name = "Teleport" })

SigmaPlayerTab:AddToggle({
    Name = "Teleport Press Z",
    Default = false,
    Callback = function(enabled)
        teleportActive = enabled
    end
})

local rainbowSection = SigmaPlayerTab:AddSection({ Name = "Rainbow Line" })

local function randomColor()
    return Color3.new(math.random(), math.random(), math.random())
end

local function generateRandomColorSequence()
    local keypoints = {}
    for i = 0, 1, 0.1 do
        table.insert(keypoints, ColorSequenceKeypoint.new(i, randomColor()))
    end
    return ColorSequence.new(keypoints)
end

local function updateBeamColors()
    UpdateLineColorsEvent:FireServer(generateRandomColorSequence())
end

local rainbowActive = false
SigmaPlayerTab:AddToggle({
    Name = "Toggle rainbow Beam Color",
    Default = false,
    Callback = function(enabled)
        rainbowActive = enabled
        if rainbowActive then
            while rainbowActive do
                updateBeamColors()
                wait(1)
            end
        end
    end
})

local typingSection = SigmaPlayerTab:AddSection({ Name = "Typing" })

SigmaPlayerTab:AddButton({
    Name = "Fake Typing",
    Callback = function()
        ChatTypingEvent:FireServer("begin")
    end
})

local ExplosionTab = Window:MakeTab({
    Name = "Explosions",
    Icon = "rbxassetid://132562409931708",
    PremiumOnly = false
})

local function toggleMissileCache(enabled)
    if enabled then
        if not ownedToys[_G.ToyToLoad] then
            OrionLib:MakeNotification({
                Name = "Missing toy",
                Content = "You do not own the " .. _G.ToyToLoad .. " toy.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        if not bombCacheCoroutine then
            bombCacheCoroutine = coroutine.create(function()
                bombCacheChildAddedConn = SpawnedInToysFolder.ChildAdded:Connect(function(newToy)
                    if newToy.Name == _G.ToyToLoad and newToy:WaitForChild("ThisToysNumber", 1) and newToy.ThisToysNumber.Value == SpawnedInToysFolder.ToyNumber.Value - 1 then
                        local childRemovedConn
                        childRemovedConn = SpawnedInToysFolder.ChildRemoved:Connect(function(removed)
                            if removed == newToy then
                                childRemovedConn:Disconnect()
                            end
                        end)
                        SetNetworkOwner:FireServer(newToy.Body, newToy.Body.CFrame)
                        local partOwner = newToy.Body:WaitForChild("PartOwner", 0.5)
                        newToy.DescendantAdded:Connect(function(descendant)
                            if descendant.Name == "PartOwner" and descendant.Value ~= LocalPlayer.Name then
                                destroyToy(newToy)
                            end
                        end)
                        Debris:AddItem(childRemovedConn, 60)
                        if partOwner and partOwner.Value == LocalPlayer.Name then
                            for _, child in pairs(newToy:GetChildren()) do
                                if child:IsA("BasePart") then
                                    child.CanCollide = false
                                end
                            end
                            newToy:SetPrimaryPartCFrame(CFrame.new(-72.9304581, -3.96906614, -265.543732))
                            wait(0.2)
                            for _, child in pairs(newToy:GetChildren()) do
                                if child:IsA("BasePart") then
                                    child.Anchored = true
                                end
                            end
                            table.insert(bombList, newToy)
                            newToy.AncestryChanged:Connect(function()
                                if not newToy.Parent then
                                    for i, bomb in ipairs(bombList) do
                                        if bomb == newToy then
                                            table.remove(bombList, i)
                                            break
                                        end
                                    end
                                end
                            end)
                            childRemovedConn:Disconnect()
                        else
                            destroyToy(newToy)
                        end
                    end
                end)
                while true do
                    if LocalPlayer.CanSpawnToy and LocalPlayer.CanSpawnToy.Value and #bombList < _G.MaxMissiles and PlayerCharacter:FindFirstChild("Head") then
                        spawnItemAt(_G.ToyToLoad, PlayerCharacter.Head.CFrame or PlayerCharacter.HumanoidRootPart.CFrame)
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
            coroutine.resume(bombCacheCoroutine)
        end
    else
        if bombCacheCoroutine then
            coroutine.close(bombCacheCoroutine)
            bombCacheCoroutine = nil
        end
        if bombCacheChildAddedConn then
            bombCacheChildAddedConn:Disconnect()
        end
    end
end

local function explodeBombParams(bombModel, positionPart)
    return {
        {
            Radius = 17.5,
            TimeLength = 2,
            Hitbox = bombModel.PartHitDetector,
            ExplodesByFire = false,
            MaxForcePerStudSquared = 225,
            Model = bombModel,
            ImpactSpeed = 100,
            ExplodesByPointy = false,
            DestroysModel = false,
            PositionPart = positionPart
        },
        positionPart.Position
    }
end

ExplosionTab:AddBind({
    Name = "Explode Bomb",
    Default = "B",
    Hold = false,
    Save = true,
    Flag = "ExplodeBombKeybind",
    Callback = function()
        if not ownedToys.BombMissile then
            OrionLib:MakeNotification({
                Name = "Missing toy",
                Content = "You do not own the BombMissile toy.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        local explodeConn
        explodeConn = SpawnedInToysFolder.ChildAdded:Connect(function(newToy)
            if newToy.Name == "BombMissile" and newToy:WaitForChild("ThisToysNumber", 1) and newToy.ThisToysNumber.Value == SpawnedInToysFolder.ToyNumber.Value - 1 then
                explodeConn:Disconnect()
                SetNetworkOwner:FireServer(newToy.PartHitDetector, newToy.PartHitDetector.CFrame)
                BombExplode:FireServer(unpack(explodeBombParams(newToy, newToy.Body)))
            end
        end)
        spawnItemAt("BombMissile", PlayerCharacter.Head.CFrame or PlayerCharacter.HumanoidRootPart.CFrame)
        wait(1)
        explodeConn:Disconnect()
    end
})

ExplosionTab:AddBind({
    Name = "Throw Bomb",
    Default = "C",
    Hold = false,
    Save = true,
    Flag = "ThrowBombKeybind",
    Callback = function()
        if not ownedToys.BombMissile then
            OrionLib:MakeNotification({
                Name = "Missing toy",
                Content = "You do not own the BombMissile toy.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        local throwConn
        throwConn = SpawnedInToysFolder.ChildAdded:Connect(function(newToy)
            if newToy.Name == "BombMissile" and newToy:WaitForChild("ThisToysNumber", 1) and newToy.ThisToysNumber.Value == SpawnedInToysFolder.ToyNumber.Value - 1 then
                throwConn:Disconnect()
                SetNetworkOwner:FireServer(newToy.PartHitDetector, newToy.PartHitDetector.CFrame)
                local bodyVel = Instance.new("BodyVelocity", newToy.PartHitDetector)
                bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVel.Velocity = Workspace.CurrentCamera.CFrame.lookVector * 500
                Debris:AddItem(bodyVel, 10)
            end
        end)
        spawnItemAt("BombMissile", PlayerCharacter.Head.CFrame or PlayerCharacter.HumanoidRootPart.CFrame)
    end
})

ExplosionTab:AddBind({
    Name = "Explode Firework",
    Default = "N",
    Hold = false,
    Save = true,
    Flag = "ExplodeFireworkKeybind",
    Callback = function()
        if not ownedToys.FireworkMissile then
            OrionLib:MakeNotification({
                Name = "Missing toy",
                Content = "You do not own the FireworkMissile toy.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        local fireworkConn
        fireworkConn = SpawnedInToysFolder.ChildAdded:Connect(function(newToy)
            if newToy.Name == "FireworkMissile" and newToy:WaitForChild("ThisToysNumber", 1) and newToy.ThisToysNumber.Value == SpawnedInToysFolder.ToyNumber.Value - 1 then
                fireworkConn:Disconnect()
                SetNetworkOwner:FireServer(newToy.PartHitDetector, newToy.PartHitDetector.CFrame)
                BombExplode:FireServer(unpack(explodeBombParams(newToy, newToy.Body)))
            end
        end)
        spawnItemAt("FireworkMissile", PlayerCharacter.Head.CFrame or PlayerCharacter.HumanoidRootPart.CFrame)
        wait(1)
        fireworkConn:Disconnect()
    end
})

ExplosionTab:AddParagraph("Tip", "Hold to reload bombs")

ExplosionTab:AddBind({
    Name = "Missile Cache Reload",
    Default = "Q",
    Hold = true,
    Save = true,
    Flag = "BombCacheReload",
    Callback = function(enabled)
        toggleMissileCache(enabled)
    end
})

ExplosionTab:AddBind({
    Name = "Explode Cached Missile",
    Default = "T",
    Hold = false,
    Save = true,
    Flag = "ExplodeCachedBombKeybind",
    Callback = function()
        if not bombList or #bombList == 0 then
            OrionLib:MakeNotification({
                Name = "No bombs",
                Content = "There are no cached bombs to explode",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
            return
        end
        local bomb = table.remove(bombList, 1)
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local primaryPart = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
        if rootPart or primaryPart then
            BombExplode:FireServer(unpack(explodeBombParams(bomb, rootPart or primaryPart)))
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Could not find player position",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

ExplosionTab:AddBind({
    Name = "Explode All Cached Missiles",
    Default = "Y",
    Hold = false,
    Save = true,
    Flag = "ExplodeAllCachedBombsKeybind",
    Callback = function()
        if #bombList == 0 then
            OrionLib:MakeNotification({
                Name = "No bombs",
                Content = "There are no cached bombs to explode",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
            return
        end
        for i = #bombList, 1, -1 do
            local bomb = table.remove(bombList, i)
            BombExplode:FireServer(unpack(explodeBombParams(bomb, LocalPlayer.Character.HumanoidRootPart or LocalPlayer.Character.PrimaryPart)))
        end
    end
})

ExplosionTab:AddBind({
    Name = "Explode All Cached Missiles On Nearest Player",
    Default = "U",
    Hold = false,
    Save = true,
    Flag = "ExplodeAllCachedBombsOnNearestPlayerKeybind",
    Callback = function()
        if #bombList == 0 then
            OrionLib:MakeNotification({
                Name = "No bombs",
                Content = "There are no cached bombs to explode",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
            return
        end
        local nearestChar = getNearestPlayer().Character
        for i = #bombList, 1, -1 do
            local bomb = table.remove(bombList, i)
            local positionPart = nearestChar.HumanoidRootPart or (nearestChar.Torso or nearestChar.PrimaryPart)
            BombExplode:FireServer(unpack(explodeBombParams(bomb, positionPart)))
        end
    end
})

ExplosionTab:AddDropdown({
    Name = "Toy to load",
    Default = "BombMissile",
    Options = { "BombMissile", "FireWork Toy" },
    Callback = function(selected)
        _G.ToyToLoad = selected
    end
})

ExplosionTab:AddSlider({
    Name = "How Many Missles?",
    Min = 1,
    Max = LocalPlayer.ToysLimitCap.Value / 10,
    ValueName = "Missiles",
    Increment = 1,
    Default = _G.MaxMissiles,
    Save = true,
    Flag = "NaxMissilesSlider",
    Callback = function(value)
        _G.MaxMissiles = value
    end
})

ExplosionTab:AddToggle({
    Name = "Auto Reload Cache",
    Default = false,
    Save = true,
    Flag = "AutoReloadBombs",
    Callback = function(enabled)
        toggleMissileCache(enabled)
    end
})

local TeleportPlaceTab = Window:MakeTab({
    Name = "Teleport To Place",
    Icon = "rbxassetid://107329484263507",
    PremiumOnly = false
})

local teleportLocations = {
    ["Blue House"] = CFrame.new(497.697, 85.282, -352.059) * CFrame.Angles(-1.382, -0.436, -1.147),
    ["Green House 2"] = CFrame.new(-538.227, -5.479, 76.104) * CFrame.Angles(-1.808, 0.702, 1.929),
    House = CFrame.new(-486.831, -5.447, -151.915) * CFrame.Angles(-1.364, 0.602, 1.216),
    ["Scary House"] = CFrame.new(269.652, -5.437, 440.346) * CFrame.Angles(-2.130, -0.225, -2.799),
    ["Hidden Part"] = CFrame.new(544.995, -5.505, -28.169) * CFrame.Angles(-2.377, -0.058, -3.086),
    ["Small Hidden Base"] = CFrame.new(-26.101, -5.479, -299.150) * CFrame.Angles(-1.642, 0.731, 1.677),
    Cave = CFrame.new(-271.187, -5.408, 531.099) * CFrame.Angles(-1.466, 0.473, 1.344),
    ["Secret Base"] = CFrame.new(-24.925, -5.535, 572.508) * CFrame.Angles(-1.335, 0.866, 1.266),
    ["Japanese House"] = CFrame.new(543.336, 125.297, -93.405) * CFrame.Angles(-1.589, -0.411, -1.615),
    ["Green House First Floor"] = CFrame.new(-310.654, 83.439, 327.566) * CFrame.Angles(-2.240, 0.736, 2.438),
    ["Green House Second Floor"] = CFrame.new(-357.581, 100.589, 354.744) * CFrame.Angles(-1.373, -0.459, -1.146),
    ["Poison Factory"] = CFrame.new(117.795, 349.022, 358.373) * CFrame.Angles(-1.614, 0.855, 1.628),
    ["Barn Yard"] = CFrame.new(-38.915, 61.659, -395.596) * CFrame.Angles(-1.248, -0.639, -1.060),
    ["Barn House"] = CFrame.new(-221.773, 84.592, -310.172) * CFrame.Angles(-2.313, -0.474, -2.680),
    ["House Floor 2"] = CFrame.new(-540.500, 14.155, -172.234) * CFrame.Angles(-1.830, -0.634, -1.992),
    Spawn = CFrame.new(12.952, -5.506, -2.141) * CFrame.Angles(-1.564, 0.812, 1.561)
}

local selectedLocation = nil
TeleportPlaceTab:AddDropdown({
    Name = "Teleport Locations",
    Default = "Spawn",
    Options = {
        "Blue House", "Green House 2", "House", "Scary House", "Hidden Part",
        "Small Hidden Base", "Cave", "Secret Base", "Japanese House",
        "Green House First Floor", "Green House Second Floor", "Poison Factory",
        "Barn Yard", "Barn House", "House Floor 2", "Spawn"
    },
    Callback = function(selected)
        selectedLocation = selected
    end
})

TeleportPlaceTab:AddButton({
    Name = "Teleport To Place!",
    Callback = function()
        if selectedLocation and teleportLocations[selectedLocation] then
            local char = LocalPlayer.Character
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = teleportLocations[selectedLocation]
            end
        end
    end
})

local graphicsEnabled = false
local function enableGraphics()
    Lighting.Brightness = 2.14
    Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
    Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14)
    Lighting.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
    Lighting.ClockTime = 6.7
    Lighting.FogColor = Color3.fromRGB(94, 76, 106)
    Lighting.FogEnd = 1000
    Lighting.FogStart = 0
    Lighting.ExposureCompensation = 0.24
    Lighting.ShadowSoftness = 0
    Lighting.Ambient = Color3.fromRGB(59, 33, 27)
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.1
    bloom.Threshold = 0
    bloom.Size = 100
    bloom.Parent = Lighting
    local blur = Instance.new("BlurEffect")
    blur.Size = 2
    blur.Parent = Lighting
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Name = "WarmTint"
    colorCorrection.Saturation = 0.05
    colorCorrection.TintColor = Color3.fromRGB(255, 224, 219)
    colorCorrection.Parent = Lighting
    local sunRays = Instance.new("SunRaysEffect")
    sunRays.Intensity = 0.05
    sunRays.Parent = Lighting
    local sky = Instance.new("Sky")
    sky.Name = "Tropic"
    sky.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
    sky.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
    sky.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
    sky.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
    sky.StarCount = 100
    sky.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
    sky.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
    sky.Parent = Lighting
end

local function disableGraphics()
    Lighting:ClearAllChildren()
    Lighting.Brightness = 1
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.FogEnd = 10000
end

TeleportPlaceTab:AddToggle({
    Name = "Toggle Enhanced Graphics",
    Default = false,
    Callback = function(enabled)
        graphicsEnabled = enabled
        if graphicsEnabled then enableGraphics() else disableGraphics() end
    end
})

local TelekinesisTab = Window:MakeTab({
    Name = "telekinesis pc only beta mobile soon",
    Icon = "rbxassetid://87851318303275",
    PremiumOnly = false
})

TelekinesisTab:AddButton({
    Name = "Aim at the toy and press c to telekinesis the toy",
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local telekinesisActive = false
        local telekinesisTarget = nil
        local telekinesisDistance = 10

        local function activateTelekinesis(part)
            telekinesisActive = true
            telekinesisTarget = part
            local highlight = Instance.new("Highlight", part)
            highlight.FillColor = Color3.fromRGB(128, 0, 128)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end

        local function deactivateTelekinesis()
            telekinesisActive = false
            if telekinesisTarget then
                telekinesisTarget:FindFirstChildOfClass("Highlight"):Destroy()
                telekinesisTarget = nil
            end
        end

        local function updateTelekinesis()
            if telekinesisActive and telekinesisTarget then
                local camera = Workspace.CurrentCamera
                local targetPos = camera.CFrame.Position + camera.CFrame.LookVector * telekinesisDistance
                telekinesisTarget.CFrame = CFrame.new(targetPos)
            end
        end

        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.C then
                if telekinesisActive then
                    deactivateTelekinesis()
                else
                    local target = mouse.Target
                    if target and target:IsA("BasePart") and not (target:IsDescendantOf(Workspace.Terrain) or target:IsDescendantOf(Workspace.Map)) then
                        activateTelekinesis(target)
                    end
                end
            end
        end)
        RunService.RenderStepped:Connect(updateTelekinesis)
    end
})

local MessUpPlotsTab = Window:MakeTab({
    Name = "Mess Up Plots",
    Icon = "rbxassetid://18778642981",
    PremiumOnly = false
})

local plotLooping = false
local selectedPlot = "Plot1"
local selectedSignType = "Plus"

local plotPositions = {
    Plot1 = { position = CFrame.new(-532.127, -5.749, 91.869), angles = CFrame.Angles(-2.925, 0.335, 3.069) },
    Plot2 = { position = CFrame.new(-484.492, -5.784, -159.563), angles = CFrame.Angles(-0.297, 1.099, 0.267) },
    Plot3 = { position = CFrame.new(256.415, -5.475, 466.581), angles = CFrame.Angles(-2.530, -0.506, -2.814) },
    Plot4 = { position = CFrame.new(511.902, 84.878, -342.774), angles = CFrame.Angles(-0.139, -0.930, -0.112) },
    Plot5 = { position = CFrame.new(557.223, 124.992, -75.296), angles = CFrame.Angles(-0.930, -1.271, -0.908) }
}

local function applyToAllSigns(plotSign, positionCFrame, angleCFrame, signType)
    for _, child in ipairs(plotSign:GetChildren()) do
        local signPart = child:FindFirstChild(signType)
        if signPart and signPart:FindFirstChild(signType .. "GrabPart") then
            SetNetworkOwner:FireServer(signPart[signType .. "GrabPart"], positionCFrame * angleCFrame)
        end
    end
end

local function handlePlotLoop()
    while plotLooping do
        local plot = Workspace.Plots:FindFirstChild(selectedPlot)
        if plot and plot:FindFirstChild("PlotSign") then
            local plotData = plotPositions[selectedPlot]
            applyToAllSigns(plot.PlotSign, plotData.position, plotData.angles, selectedSignType)
        end
        wait(1)
    end
end

MessUpPlotsTab:AddDropdown({
    Name = "Choose Plot",
    Default = "Plot1",
    Options = { "Plot1", "Plot2", "Plot3", "Plot4", "Plot5" },
    Callback = function(selected)
        selectedPlot = selected
    end
})

MessUpPlotsTab:AddDropdown({
    Name = "Choose Sign Type",
    Default = "Plus",
    Options = { "Plus", "Minus" },
    Callback = function(selected)
        selectedSignType = selected
    end
})

MessUpPlotsTab:AddToggle({
    Name = "Start/Stop Mess Up LeaderBoards Plots",
    Default = false,
    Callback = function(enabled)
        plotLooping = enabled
        if plotLooping then
            spawn(handlePlotLoop)
        end
    end
})

local EmergencyTab = Window:MakeTab({
    Name = "Emergency",
    Icon = "rbxassetid://18969927583",
    PremiumOnly = false
})

local autoOwnershipActive = false
local ownershipLoopInterval = 0.4

local function grabAllToys(player)
    local playerToysFolder = Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
    if playerToysFolder then
        for _, toy in ipairs(playerToysFolder:GetChildren()) do
            if not (toy:IsA("Model") and toy.Name:match("MusicKeyboard")) and (toy:IsA("Model") or toy:IsA("Part")) then
                for _, descendant in ipairs(toy:GetDescendants()) do
                    if descendant:IsA("Part") then
                        SetNetworkOwner:FireServer(descendant, CFrame.new(descendant.Position))
                    end
                end
            end
        end
    end
end

EmergencyTab:AddToggle({
    Name = "Auto Ownership Your Toys",
    Default = false,
    Callback = function(enabled)
        autoOwnershipActive = enabled
        if autoOwnershipActive then
            spawn(function()
                while autoOwnershipActive do
                    grabAllToys(LocalPlayer)
                    wait(ownershipLoopInterval)
                end
            end)
        end
    end
})

EmergencyTab:AddParagraph("WARNING READ", "if you put both sliders to 0.1 this will lag your player and if player grabs u and throws u will be kicked by anti cheat leave it to 0.4 if you dont wanna get kicked")

EmergencyTab:AddSlider({
    Name = "Loop Speed",
    Min = 0.1,
    Max = 0.5,
    Default = 0.4,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "seconds",
    Callback = function(value)
        ownershipLoopInterval = value
    end
})

local nearbyToyGrabActive = false
local nearbyGrabRadius = 50

local function grabNearbyPlayersToys()
    local localPos = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.Position
    if not localPos then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local toyFolder = Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
            if toyFolder then
                for _, toy in ipairs(toyFolder:GetChildren()) do
                    if toy:IsA("Model") or toy:IsA("Part") then
                        for _, descendant in ipairs(toy:GetDescendants()) do
                            if descendant:IsA("Part") and (descendant.Position - localPos).Magnitude <= nearbyGrabRadius then
                                SetNetworkOwner:FireServer(descendant, CFrame.new(descendant.Position))
                            end
                        end
                    end
                end
            end
        end
    end
end

local function toggleNearbyToyGrab(enabled)
    if enabled then
        if not nearbyToyGrabActive then
            nearbyToyGrabActive = true
            while nearbyToyGrabActive do
                grabNearbyPlayersToys()
                wait(ownershipLoopInterval)
            end
        end
    else
        nearbyToyGrabActive = false
    end
end

EmergencyTab:AddToggle({
    Name = "Auto Grab Nearby Players' Toys",
    Default = false,
    Callback = function(enabled)
        toggleNearbyToyGrab(enabled)
    end
})

EmergencyTab:AddSlider({
    Name = "Loop Interval",
    Min = 0.1,
    Max = 0.5,
    Default = 0.4,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1,
    ValueName = "Seconds",
    Callback = function(value)
        ownershipLoopInterval = value
        if nearbyToyGrabActive then
            toggleNearbyToyGrab(true)
        end
    end
})

local OrbitTab = Window:MakeTab({
    Name = "Fe Orbit/Non fe orbit",
    Icon = "rbxassetid://103900552082189",
    PremiumOnly = false
})

local orbitFollowActive = false
local orbitFollowDistance = 18
local orbitFollowSpeed = 4
local playerOrbitAngles = {}

local function orbitPlayersLoop()
    RunService.RenderStepped:Connect(function()
        if not orbitFollowActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        local playerPos = rootPart.Position
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    if not playerOrbitAngles[plr] then
                        playerOrbitAngles[plr] = 0
                    end
                    playerOrbitAngles[plr] = playerOrbitAngles[plr] + orbitFollowSpeed * RunService.RenderStepped:Wait()
                    local angle = playerOrbitAngles[plr]
                    local offsetX = math.cos(angle) * orbitFollowDistance
                    local offsetZ = math.sin(angle) * orbitFollowDistance
                    local newPos = playerPos + Vector3.new(offsetX, 0, offsetZ)
                    targetRoot.CFrame = CFrame.new(newPos, playerPos)
                end
            end
        end
    end)
end
orbitPlayersLoop()

OrbitTab:AddToggle({
    Name = "Orbit Not Fe but lets you put players on fire or painted",
    Default = false,
    Callback = function(enabled)
        orbitFollowActive = enabled
    end
})

OrbitTab:AddSlider({
    Name = "Orbit Speed",
    Min = 0, Max = 200, Default = 4,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1, ValueName = "Speed",
    Callback = function(value) orbitFollowSpeed = value end
})

OrbitTab:AddSlider({
    Name = "Orbit Distance",
    Min = 0, Max = 100, Default = 18,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1, ValueName = "Distance",
    Callback = function(value) orbitFollowDistance = value end
})

local AuraToysTab = Window:MakeTab({
    Name = "Sigma Aura Toys",
    Icon = "rbxassetid://18883425120",
    PremiumOnly = false
})

local auraGrabRadius = 33
local auraLoopInterval = 0.5
local auraHighlightColor = Color3.fromRGB(128, 0, 128)
local auraHighlightTransparency = 0.5
local originalPartProperties = {}
local auraToggleOn = false
local auraHeartbeatConn = nil
local lastAuraUpdateTime = tick()

local function saveOriginalProperties(toyModel)
    if not originalPartProperties[toyModel] then
        originalPartProperties[toyModel] = {}
        for _, child in ipairs(toyModel:GetChildren()) do
            if child:IsA("BasePart") then
                originalPartProperties[toyModel][child] = {
                    Material = child.Material,
                    BrickColor = child.BrickColor,
                    Transparency = child.Transparency
                }
            end
        end
    end
end

local function applyAuraHighlight(toyModel)
    saveOriginalProperties(toyModel)
    for _, child in ipairs(toyModel:GetChildren()) do
        if child:IsA("BasePart") then
            child.Material = Enum.Material.Neon
            child.BrickColor = BrickColor.new(auraHighlightColor)
            child.Transparency = auraHighlightTransparency
        end
    end
end

local function removeAuraHighlight(toyModel)
    local saved = originalPartProperties[toyModel]
    if saved then
        for part, props in pairs(saved) do
            if part:IsA("BasePart") then
                part.Material = props.Material
                part.BrickColor = props.BrickColor
                part.Transparency = props.Transparency
            end
        end
        originalPartProperties[toyModel] = nil
    end
end

local function grabAndMoveToys()
    local toyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    if toyFolder then
        for _, toy in pairs(toyFolder:GetChildren()) do
            if toy:IsA("Model") then
                local distance = (toy.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance > auraGrabRadius then
                    removeAuraHighlight(toy)
                else
                    applyAuraHighlight(toy)
                    for _, partName in ipairs({ "Main", "Hitbox", "SoundPart", "Base", "BackPart", "Axel2", "Stick" }) do
                        local part = toy:FindFirstChild(partName)
                        if part then
                            SetNetworkOwner:FireServer(part, CFrame.new(part.Position))
                        end
                    end
                end
            end
        end
    end
end

AuraToysTab:AddToggle({
    Name = "Safe Mode (Highlights The Toys Purple When Grabbed)",
    Default = false,
    Callback = function(enabled)
        auraToggleOn = enabled
        if auraToggleOn then
            auraHeartbeatConn = RunService.Heartbeat:Connect(function()
                local currentTime = tick()
                if currentTime - lastAuraUpdateTime >= auraLoopInterval then
                    lastAuraUpdateTime = currentTime
                    grabAndMoveToys()
                end
            end)
        else
            if auraHeartbeatConn then
                auraHeartbeatConn:Disconnect()
                auraHeartbeatConn = nil
            end
            local toyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if toyFolder then
                for _, toy in pairs(toyFolder:GetChildren()) do
                    if toy:IsA("Model") then
                        removeAuraHighlight(toy)
                    end
                end
            end
        end
    end
})

AuraToysTab:AddSlider({
    Name = "Grab Speed",
    Min = 0.1, Max = 1, Default = 0.5, Increment = 0.1,
    Callback = function(value) auraLoopInterval = value end
})

local selectedEffect = "Ferris Wheel"
local effectActive = false
local effectSpeed = 10
local effectHeight = 10
local effectRadius = 15
local effectXRotation = 0
local effectYRotation = 0
local effectZRotation = 0
local effectLayers = 5

local function clearToyEffects()
    local toyFolder = Workspace[LocalPlayer.Name .. "SpawnedInToys"]
    for _, toy in pairs(toyFolder:GetChildren()) do
        for _, descendant in pairs(toy:GetDescendants()) do
            if descendant:IsA("BasePart") then
                local bodyVel = descendant:FindFirstChild("BodyVelocity")
                local bodyGyro = descendant:FindFirstChild("BodyGyro")
                if bodyVel then bodyVel:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
                descendant.CanCollide = true
            end
        end
    end
end

local function runFerrisWheelEffect()
    local toyFolder = Workspace[LocalPlayer.Name .. "SpawnedInToys"]
    local angleStep = 360 / #toyFolder:GetChildren()
    local currentAngle = 0
    while effectActive and selectedEffect == "Ferris Wheel" do
        local centerPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
        currentAngle = (currentAngle + effectSpeed * 0.1) % 360
        local index = 1
        for _, toy in pairs(toyFolder:GetChildren()) do
            for _, descendant in pairs(toy:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local toyAngle = currentAngle + angleStep * (index - 1)
                    local posX = centerPos.X + effectRadius * math.cos(math.rad(toyAngle))
                    local posZ = centerPos.Z + effectRadius * math.sin(math.rad(toyAngle))
                    local posY = centerPos.Y + math.sin(math.rad(toyAngle)) * effectHeight
                    local targetPos = Vector3.new(posX, posY, posZ)
                    local bodyVel = descendant:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity", descendant)
                    bodyVel.MaxForce = Vector3.new(10000, 10000, 10000)
                    bodyVel.Velocity = (targetPos - descendant.Position) * effectSpeed * 0.1
                    local bodyGyro = descendant:FindFirstChild("BodyGyro") or Instance.new("BodyGyro", descendant)
                    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
                    bodyGyro.CFrame = CFrame.new(targetPos) * CFrame.Angles(math.rad(effectXRotation), math.rad(effectYRotation), math.rad(effectZRotation))
                    descendant.CanCollide = false
                    descendant.Anchored = false
                end
            end
            index = index + 1
        end
        wait(0.05)
    end
end

local function runOrbitEffect()
    local toyFolder = Workspace[LocalPlayer.Name .. "SpawnedInToys"]
    local angleStep = 360 / #toyFolder:GetChildren()
    local currentAngle = 0
    while effectActive and selectedEffect == "Orbit" do
        local centerPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
        currentAngle = (currentAngle + effectSpeed * 0.1) % 360
        local index = 1
        for _, toy in pairs(toyFolder:GetChildren()) do
            local toyAngle = currentAngle + angleStep * (index - 1)
            local posX = centerPos.X + effectRadius * math.cos(math.rad(toyAngle))
            local posZ = centerPos.Z + effectRadius * math.sin(math.rad(toyAngle))
            local targetPos = Vector3.new(posX, centerPos.Y + effectHeight, posZ)
            for _, descendant in pairs(toy:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local bodyVel = descendant:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity", descendant)
                    bodyVel.MaxForce = Vector3.new(10000, 10000, 10000)
                    bodyVel.Velocity = (targetPos - descendant.Position) * effectSpeed * 0.1
                    local bodyGyro = descendant:FindFirstChild("BodyGyro") or Instance.new("BodyGyro", descendant)
                    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
                    bodyGyro.CFrame = CFrame.new(targetPos) * CFrame.Angles(math.rad(effectXRotation), math.rad(effectYRotation), math.rad(effectZRotation))
                    descendant.CanCollide = false
                    descendant.Anchored = false
                end
            end
            index = index + 1
        end
        wait(0.05)
    end
end

local function runTornadoEffect()
    local toyFolder = Workspace[LocalPlayer.Name .. "SpawnedInToys"]
    local angleStep = 360 / #toyFolder:GetChildren()
    local currentAngle = 0
    while effectActive and selectedEffect == "Tornado" do
        local centerPos = LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position
        currentAngle = (currentAngle + effectSpeed * 0.1) % 360
        local index = 1
        for _, toy in pairs(toyFolder:GetChildren()) do
            for _, descendant in pairs(toy:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    local toyAngle = currentAngle + angleStep * (index - 1)
                    local posX = centerPos.X + effectRadius * math.cos(math.rad(toyAngle))
                    local posZ = centerPos.Z + effectRadius * math.sin(math.rad(toyAngle))
                    local posY = centerPos.Y + index % effectLayers * effectHeight
                    local targetPos = Vector3.new(posX, posY, posZ)
                    local bodyVel = descendant:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity", descendant)
                    bodyVel.MaxForce = Vector3.new(10000, 10000, 10000)
                    bodyVel.Velocity = (targetPos - descendant.Position) * effectSpeed * 0.1
                    local bodyGyro = descendant:FindFirstChild("BodyGyro") or Instance.new("BodyGyro", descendant)
                    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
                    bodyGyro.CFrame = CFrame.new(targetPos) * CFrame.Angles(math.rad(effectXRotation), math.rad(effectYRotation), math.rad(effectZRotation))
                    descendant.CanCollide = false
                    descendant.Anchored = false
                end
            end
            index = index + 1
        end
        wait(0.05)
    end
end

AuraToysTab:AddDropdown({
    Name = "Select Effect",
    Default = "Ferris Wheel",
    Options = { "Ferris Wheel", "Orbit", "Tornado" },
    Callback = function(selected)
        selectedEffect = selected
        clearToyEffects()
    end
})

AuraToysTab:AddToggle({
    Name = "Activate Effect",
    Default = false,
    Callback = function(enabled)
        effectActive = enabled
        if effectActive then
            if selectedEffect == "Ferris Wheel" then
                runFerrisWheelEffect()
            elseif selectedEffect == "Orbit" then
                runOrbitEffect()
            elseif selectedEffect == "Tornado" then
                runTornadoEffect()
            end
        else
            clearToyEffects()
        end
    end
})

AuraToysTab:AddSlider({ Name = "Speed", Min = 1, Max = 450, Default = 10, Callback = function(v) effectSpeed = v end })
AuraToysTab:AddSlider({ Name = "Height", Min = 1, Max = 150, Default = 10, Callback = function(v) effectHeight = v end })
AuraToysTab:AddSlider({ Name = "Radius", Min = 5, Max = 450, Default = 15, Callback = function(v) effectRadius = v end })
AuraToysTab:AddSlider({ Name = "X Rotation", Min = -180, Max = 180, Default = 0, Callback = function(v) effectXRotation = v end })
AuraToysTab:AddSlider({ Name = "Y Rotation", Min = -180, Max = 180, Default = 0, Callback = function(v) effectYRotation = v end })
AuraToysTab:AddSlider({ Name = "Z Rotation", Min = -180, Max = 180, Default = 0, Callback = function(v) effectZRotation = v end })
AuraToysTab:AddSlider({ Name = "Layers (For Tornado)", Min = 1, Max = 25, Default = 5, Callback = function(v) effectLayers = v end })

local LagTab = Window:MakeTab({
    Name = "Sigma Lag,Line Player,Workspace (Advance)",
    Icon = "rbxassetid://18883425120",
    PremiumOnly = false
})

local lagWorkspaceEnabled = false
local lagWorkspaceSpeed = 5

local function lagWorkspace()
    local startTime = tick()
    while lagWorkspaceEnabled and tick() - startTime < 2 do
        for _, descendant in pairs(Workspace:GetDescendants()) do
            if not lagWorkspaceEnabled then break end
            if descendant:IsA("BasePart") then
                CreateGrabLine:FireServer(descendant, CFrame.new(-18.161, 91, -36.838))
            end
        end
        wait(lagWorkspaceSpeed)
    end
end

local function lagWorkspaceLoop()
    if lagWorkspaceEnabled then
        lagWorkspace()
        task.delay(5, lagWorkspaceLoop)
    end
end

LagTab:AddToggle({
    Name = "Lag All Player Using(WorkSpace)",
    Default = false,
    Callback = function(enabled)
        lagWorkspaceEnabled = enabled
        if lagWorkspaceEnabled then lagWorkspaceLoop() end
    end
})

LagTab:AddSlider({
    Name = "Lag Player Slider (WorkSpace)",
    Min = 0.001, Max = 10, Default = 5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1, ValueName = "seconds",
    Callback = function(value) lagWorkspaceSpeed = value end
})

local lagPlayersActive = false
local lagSpeed = 0.05

local function createGrabLineForAllPlayers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            CreateGrabLine:FireServer(plr.Character.Head, CFrame.new(0.303, 0.178, -0.5) * CFrame.Angles(0.257, -1.571, 0))
        end
    end
end

local function toggleLag(enabled)
    lagPlayersActive = enabled
    if lagPlayersActive then
        RunService:BindToRenderStep("LagEffect", Enum.RenderPriority.Last.Value, function()
            createGrabLineForAllPlayers()
            wait(lagSpeed)
        end)
    else
        RunService:UnbindFromRenderStep("LagEffect")
    end
end

local function updateLagSpeed(sliderValue)
    lagSpeed = 1 - sliderValue / 20 * 0.95
end

LagTab:AddToggle({
    Name = "Lag Player Using (Players Head)",
    Default = false,
    Callback = function(enabled) toggleLag(enabled) end
})

LagTab:AddSlider({
    Name = "Lag slider Players (Leave it to 0.5 for no lag)",
    Min = 0.01, Max = 2, Default = 0.5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1, ValueName = "bananas",
    Callback = function(value) updateLagSpeed(value) end
})

local lineAllActive = false
local lineAllSpeed = 0.5

local function applyGrabLineLag()
    while lineAllActive do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                CreateGrabLine:FireServer(plr.Character.Head, CFrame.new(0.303, 0.178, -0.5) * CFrame.Angles(0.257, -1.571, 0))
                plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 500, 0)
                RunService.Stepped:Wait()
            end
        end
        wait(lineAllSpeed)
    end
end

local function makePlayerFall(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, -50, 0)
    end
end

LagTab:AddToggle({
    Name = "Line All (Players)",
    Default = false,
    Callback = function(enabled)
        lineAllActive = enabled
        if lineAllActive then
            applyGrabLineLag()
        else
            for _, plr in pairs(Players:GetPlayers()) do
                makePlayerFall(plr)
            end
        end
    end
})

LagTab:AddSlider({
    Name = "Line All Speed (Players)",
    Min = 0.001, Max = 2, Default = 0.5,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1, ValueName = "bananas",
    Callback = function(value) lineAllSpeed = value end
})

local ObjectGrabTab = Window:MakeTab({
    Name = "Sigma Move Anchored Toys",
    Icon = "rbxassetid://139947993442267",
    PremiumOnly = false
})

local function createHighlightAndImage(parentModel)
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.FillTransparency = 1
    highlight.Name = "Highlight"
    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    highlight.OutlineTransparency = 0.5
    highlight.Parent = parentModel
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ImageOverlay"
    billboard.Size = UDim2.new(0, 70, 0, 70)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = parentModel
    billboard.Parent = parentModel
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(1, 0, 1, 0)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "rbxassetid://122000268316876"
    imageLabel.Parent = billboard
    return { Highlight = highlight, BillboardGui = billboard }
end

local function onPartOwnerAdded(descendant, anchoredPart)
    local highlight = descendant.Name == "PartOwner" and descendant.Value ~= LocalPlayer.Name and (findDescendantByName(anchoredPart, "Highlight") or findDescendantByName(findFirstAncestorOfType(anchoredPart, "Model"), "Highlight"))
    if highlight then
        if descendant.Value == LocalPlayer.Name then
            highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
        else
            highlight.OutlineColor = Color3.new(1, 0, 0)
        end
    end
end

local function createBodyMovers(part, position, cframe)
    local bodyPos = Instance.new("BodyPosition")
    local bodyGyro = Instance.new("BodyGyro")
    bodyPos.P = 15000
    bodyPos.D = 200
    bodyPos.MaxForce = Vector3.new(5000000, 5000000, 5000000)
    bodyPos.Position = position
    bodyPos.Parent = part
    bodyGyro.P = 15000
    bodyGyro.D = 200
    bodyGyro.MaxTorque = Vector3.new(5000000, 5000000, 5000000)
    bodyGyro.CFrame = cframe
    bodyGyro.Parent = part
end

local function anchorGrab()
    while true do
        pcall(function()
            local grabParts = Workspace:FindFirstChild("GrabParts")
            if not grabParts then return end
            local grabPart = grabParts:FindFirstChild("GrabPart")
            if not grabPart then return end
            local weldConstraint = grabPart:FindFirstChild("WeldConstraint")
            if not (weldConstraint and weldConstraint.Part1) then return end
            local targetPart
            if weldConstraint.Part1.Name ~= "SoundPart" then
                if weldConstraint.Part1.Parent then
                    targetPart = weldConstraint.Part1.Parent:FindFirstChild("SoundPart") or (weldConstraint.Part1.Parent.PrimaryPart or weldConstraint.Part1)
                else
                    targetPart = weldConstraint.Part1
                end
            else
                targetPart = weldConstraint.Part1
            end
            if not targetPart or targetPart.Anchored then return end
            if Workspace:FindFirstChild("Map") and isDescendantOf(targetPart, Workspace.Map) then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if isDescendantOf(targetPart, plr.Character) then return end
            end
            local alreadyTracked = true
            for _, descendant in pairs(targetPart:GetDescendants()) do
                if table.find(anchoredPartsList, descendant) then
                    alreadyTracked = false
                    break
                end
            end
            if alreadyTracked and not table.find(anchoredPartsList, targetPart) then
                local modelAncestor = findFirstAncestorOfType(targetPart, "Model")
                local highlightTarget = (modelAncestor and modelAncestor ~= Workspace) and modelAncestor or targetPart
                createHighlightAndImage(highlightTarget)
                table.insert(anchoredPartsList, targetPart)
                local ownerConn = highlightTarget.DescendantAdded:Connect(function(descendant)
                    onPartOwnerAdded(descendant, targetPart)
                end)
                table.insert(partOwnerConnections, ownerConn)
            end
            local modelAncestor = findFirstAncestorOfType(targetPart, "Model")
            local cleanupTarget = (modelAncestor and modelAncestor ~= Workspace) and modelAncestor or targetPart
            for _, descendant in ipairs(cleanupTarget:GetDescendants()) do
                if descendant:IsA("BodyPosition") or descendant:IsA("BodyGyro") then
                    descendant:Destroy()
                end
            end
            while Workspace:FindFirstChild("GrabParts") do
                RunService.Heartbeat:Wait()
            end
            createBodyMovers(targetPart, targetPart.Position, targetPart.CFrame)
        end)
        RunService.Heartbeat:Wait()
    end
end

local function cleanupAnchoredParts()
    for _, part in ipairs(anchoredPartsList) do
        if part then
            local bodyPos = part:FindFirstChild("BodyPosition")
            local bodyGyro = part:FindFirstChild("BodyGyro")
            if bodyPos then bodyPos:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            local modelAncestor = findFirstAncestorOfType(part, "Model")
            local highlight = modelAncestor and modelAncestor:FindFirstChild("Highlight") or nil
            if highlight then highlight:Destroy() end
            local overlay = modelAncestor and modelAncestor:FindFirstChild("ImageOverlay") or nil
            if overlay then overlay:Destroy() end
        end
    end
    cleanupConnections(partOwnerConnections)
    anchoredPartsList = {}
end

local function updateBodyMovers(primaryPart)
    for _, group in ipairs(compiledGroups) do
        if group.primaryPart and group.primaryPart == primaryPart then
            for _, groupPart in ipairs(group.group) do
                local bodyPos = groupPart.part:FindFirstChild("BodyPosition")
                local bodyGyro = groupPart.part:FindFirstChild("BodyGyro")
                if bodyPos then
                    bodyPos.Position = (primaryPart.CFrame * groupPart.offset).Position
                end
                if bodyGyro then
                    bodyGyro.CFrame = primaryPart.CFrame * groupPart.offset
                end
            end
        end
    end
end

local function compileGroup()
    if #anchoredPartsList ~= 0 then
        OrionLib:MakeNotification({
            Name = "Success",
            Content = "Compiled " .. #anchoredPartsList .. " Toys together",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "No anchored parts found",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
    local primaryPart = anchoredPartsList[1]
    if primaryPart then
        local modelAncestor = findFirstAncestorOfType(primaryPart, "Model")
        local highlight = modelAncestor and modelAncestor:FindFirstChild("Highlight") or nil
        if not highlight then
            local highlightTarget = primaryPart.Parent:IsA("Model") and primaryPart.Parent or primaryPart
            highlight = createHighlightAndImage(highlightTarget).Highlight
        end
        highlight.OutlineColor = Color3.new(0, 1, 0)
        highlight.FillColor = Color3.new(0, 1, 0)
        highlight.FillTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        local groupParts = {}
        for _, part in ipairs(anchoredPartsList) do
            if part ~= primaryPart then
                table.insert(groupParts, { part = part, offset = primaryPart.CFrame:ToObjectSpace(part.CFrame) })
            end
        end
        table.insert(compiledGroups, { primaryPart = primaryPart, group = groupParts })
        local cframeConn = primaryPart:GetPropertyChangedSignal("CFrame"):Connect(function()
            updateBodyMovers(primaryPart)
        end)
        table.insert(cframeChangedConnections, cframeConn)
        local heartbeatConn = RunService.Heartbeat:Connect(function()
            updateBodyMovers(primaryPart)
        end)
        table.insert(renderSteppedConnections, heartbeatConn)
    end
end

local function cleanupCompiledGroups()
    for _, group in ipairs(compiledGroups) do
        for _, groupPart in ipairs(group.group) do
            if groupPart.part then
                local bodyPos = groupPart.part:FindFirstChild("BodyPosition")
                local bodyGyro = groupPart.part:FindFirstChild("BodyGyro")
                if bodyPos then bodyPos:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
            end
        end
        if group.primaryPart and group.primaryPart.Parent then
            local modelAncestor = findFirstAncestorOfType(group.primaryPart, "Model")
            local highlight = modelAncestor and modelAncestor:FindFirstChild("Highlight") or nil
            if highlight then highlight:Destroy() end
            local overlay = modelAncestor and modelAncestor:FindFirstChild("ImageOverlay") or nil
            if overlay then overlay:Destroy() end
        end
    end
    cleanupConnections(cframeChangedConnections)
    cleanupConnections(renderSteppedConnections)
    compiledGroups = {}
end

local function compileCoroutineFunc()
    while true do
        pcall(function()
            for _, group in ipairs(compiledGroups) do
                updateBodyMovers(group.primaryPart)
            end
        end)
        RunService.Heartbeat:Wait()
    end
end

local function unanchorPrimaryPart()
    local primaryPart = anchoredPartsList[1]
    if primaryPart then
        local bodyPos = primaryPart:FindFirstChild("BodyPosition")
        local bodyGyro = primaryPart:FindFirstChild("BodyGyro")
        if bodyPos then bodyPos:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        local highlight = primaryPart:FindFirstChild("Highlight")
        if highlight then highlight:Destroy() end
        local modelAncestor = findFirstAncestorOfType(primaryPart, "Model")
        local overlay = modelAncestor and modelAncestor:FindFirstChild("ImageOverlay") or nil
        if overlay then overlay:Destroy() end
    end
end

local function recoverParts()
    while true do
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Head") and char:FindFirstChild("HumanoidRootPart") then
                local rootPart = char.HumanoidRootPart
                for _, part in pairs(anchoredPartsList) do
                    if part and (part.Position - rootPart.Position).Magnitude <= 30 then
                        local modelAncestor = findFirstAncestorOfType(part, "Model")
                        local highlight = modelAncestor and modelAncestor:FindFirstChild("Highlight") or nil
                        if highlight and highlight.OutlineColor == Color3.new(1, 0, 0) then
                            SetNetworkOwner:FireServer(part, part.CFrame)
                            if part:FindFirstChild("PartOwner") and part.PartOwner.Value == LocalPlayer.Name then
                                highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                            end
                        end
                    end
                end
            end
        end)
        RunService.Heartbeat:Wait()
    end
end

ObjectGrabTab:AddParagraph("Anchor Grab", "(This Anchors The Toys That You Are Currently Grabbing)")
ObjectGrabTab:AddToggle({
    Name = "Anchor Grab",
    Default = false, Save = true, Flag = "AnchorGrab",
    Callback = function(enabled)
        if enabled then
            if not anchorGrabCoroutine or coroutine.status(anchorGrabCoroutine) == "dead" then
                anchorGrabCoroutine = coroutine.create(anchorGrab)
                coroutine.resume(anchorGrabCoroutine)
            end
        else
            if anchorGrabCoroutine and coroutine.status(anchorGrabCoroutine) ~= "dead" then
                coroutine.close(anchorGrabCoroutine)
                anchorGrabCoroutine = nil
            end
            cleanupAnchoredParts()
        end
    end
})

ObjectGrabTab:AddParagraph("Unanchor Toys", "(Unanchors the Toys That Are Anchored)")
ObjectGrabTab:AddButton({ Name = "Unanchor Toys", Callback = cleanupAnchoredParts })

ObjectGrabTab:AddParagraph("Move Toys Anchored", "(AnchorThe Toys First Highlights The Part U Need To Move Green)")
ObjectGrabTab:AddButton({
    Name = "Move Toys Anchored",
    Callback = function()
        compileGroup()
        if not compileCoroutineRef or coroutine.status(compileCoroutineRef) == "dead" then
            compileCoroutineRef = coroutine.create(compileCoroutineFunc)
            coroutine.resume(compileCoroutineRef)
        end
    end
})

ObjectGrabTab:AddParagraph("Make Toys Fall", "(Drops The Toys)")
ObjectGrabTab:AddButton({
    Name = "Make Toys Fall",
    Callback = function()
        cleanupCompiledGroups()
        cleanupAnchoredParts()
        if compileCoroutineRef and coroutine.status(compileCoroutineRef) ~= "dead" then
            coroutine.close(compileCoroutineRef)
            compileCoroutineRef = nil
        end
    end
})

ObjectGrabTab:AddParagraph("Auto Recover Grabbed Toy", "(Grabs The Toys Back That Are Being Grabbed)")
ObjectGrabTab:AddToggle({
    Name = "Auto Recover Grabbed Toy",
    Default = false, Save = true, Flag = "AutoRecoverDroppedParts",
    Callback = function(enabled)
        if enabled then
            if not autoRecoverCoroutine or coroutine.status(autoRecoverCoroutine) == "dead" then
                autoRecoverCoroutine = coroutine.create(recoverParts)
                coroutine.resume(autoRecoverCoroutine)
            end
        elseif autoRecoverCoroutine and coroutine.status(autoRecoverCoroutine) ~= "dead" then
            coroutine.close(autoRecoverCoroutine)
            autoRecoverCoroutine = nil
        end
    end
})

ObjectGrabTab:AddButton({ Name = "This Unanchor The Green Highlighted Toys", Callback = unanchorPrimaryPart })

local SilentAimTab = Window:MakeTab({
    Name = "Silent Aim (Mobile/Pc)",
    Icon = "rbxassetid://116469757700259",
    PremiumOnly = false
})

local silentAimEnabled = false
local silentAimRange = 30
local silentAimRenderConn = nil
local silentAimHookRef = nil
local aimParts = { "Head", "Torso", "Left Leg", "Right Leg" }

local function getNearestPlayerOnScreen()
    local nearestDist = math.huge
    local nearestPlr = nil
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name ~= LocalPlayer.Name and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local localPos = LocalPlayer.Character.HumanoidRootPart.Position
            local targetRoot = plr.Character.HumanoidRootPart
            local _, onScreen = Workspace.CurrentCamera:WorldToScreenPoint(targetRoot.Position)
            if onScreen then
                local dist = (localPos - targetRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestPlr = plr
                    nearestDist = dist
                end
            end
        end
    end
    return nearestPlr
end

local function setupSilentAim()
    silentAimRenderConn = RunService.RenderStepped:Connect(function()
        if silentAimEnabled then
            getNearestPlayerOnScreen()
        end
    end)
    if not silentAimHookRef then
        silentAimHookRef = hookmetamethod(game, "__namecall", function(...)
            local args = { ... }
            local self = args[1]
            local method = getnamecallmethod()
            if self == Workspace and not checkcaller() and method == "Raycast" and silentAimEnabled then
                local target = getNearestPlayerOnScreen()
                if target and target.Character and target.Character.HumanoidRootPart and LocalPlayer.Character.HumanoidRootPart and target.Character.Humanoid.Health > 0 then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                    local aimPartName = aimParts[math.random(1, #aimParts)]
                    local aimPart = target.Character[aimPartName]
                    if distance <= silentAimRange and aimPart then
                        args[3] = (target.Character[aimPartName].Position - args[2]).Unit * 1000
                        args[4] = RaycastParams.new()
                        args[4].FilterDescendantsInstances = { target.Character }
                        args[4].FilterType = Enum.RaycastFilterType.Include
                    end
                end
            end
            return silentAimHookRef(unpack(args))
        end)
    end
end

local function toggleSilentAim(enabled)
    if enabled then
        if not silentAimRenderConn then
            setupSilentAim()
        end
    elseif silentAimRenderConn then
        silentAimRenderConn:Disconnect()
        silentAimRenderConn = nil
    end
end

SilentAimTab:AddSlider({
    Name = "Reach Silent Aim",
    Min = 0, Max = 50, Default = 30,
    Callback = function(value) silentAimRange = value end
})

SilentAimTab:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(enabled)
        silentAimEnabled = enabled
        toggleSilentAim(silentAimEnabled)
    end
})

SilentAimTab:AddButton({
    Name = "Press Q to Grab Player(Solara)",
    Callback = function()
        StarterGui:SetCore("SendNotification", { Title = "Loaded", Text = "press Q to auto aim" })
        local qGrabActive = false
        local function getNearestPlayerForGrab()
            local nearestDist = math.huge
            local nearestPlr = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < nearestDist then
                        nearestPlr = plr
                        nearestDist = dist
                    end
                end
            end
            return nearestPlr
        end
        local function aimAtPlayer(plr)
            if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = plr.Character.HumanoidRootPart.Position
                Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, targetPos)
                if not qGrabActive then
                    qGrabActive = true
                    mouse1click()
                    qGrabActive = false
                end
            end
        end
        UserInputService.InputBegan:Connect(function(input, isTyping)
            if input.KeyCode == Enum.KeyCode.Q and not isTyping then
                aimAtPlayer(getNearestPlayerForGrab())
            end
        end)
    end
})

local AntiGrabTab = Window:MakeTab({
    Name = "Sigma Anti Grabs",
    Icon = "rbxassetid://18792244597",
    PremiumOnly = false
})

local antiGrabV2Active = false
AntiGrabTab:AddToggle({
    Name = "use this if someone grabs u anti grab v2",
    Default = false,
    Callback = function(enabled) antiGrabV2Active = enabled end
})

spawn(function()
    while true do
        while antiGrabV2Active do
            StruggleEvent:FireServer(LocalPlayer)
            wait(0.01)
        end
        wait(0.01)
    end
end)

local antiVoidEnabled = false
local safePosition = Vector3.new(0, 50, 0)
local voidYLevel = -50

local screenGui = Instance.new("ScreenGui", game.CoreGui)
local infoBox = Instance.new("Frame", screenGui)
infoBox.Position = UDim2.new(1, -150, 1, -150)
infoBox.Size = UDim2.new(0, 150, 0, 150)
infoBox.BackgroundTransparency = 0.5
infoBox.BackgroundColor3 = Color3.new(0, 0, 0)
infoBox.Visible = false

local voidImageLabel = Instance.new("ImageLabel", infoBox)
voidImageLabel.Size = UDim2.new(1, 0, 1, 0)
voidImageLabel.BackgroundTransparency = 1
voidImageLabel.Image = "rbxassetid://75142123538746"
voidImageLabel.ScaleType = Enum.ScaleType.Stretch

local voidMessageLabel = Instance.new("TextLabel", infoBox)
voidMessageLabel.Size = UDim2.new(1, 0, 1, 0)
voidMessageLabel.BackgroundTransparency = 1
voidMessageLabel.Font = Enum.Font.SourceSansBold
voidMessageLabel.TextSize = 16
voidMessageLabel.TextWrapped = true
voidMessageLabel.TextColor3 = Color3.new(1, 1, 1)
voidMessageLabel.Text = ""

local voidSound = Instance.new("Sound", infoBox)
voidSound.SoundId = "rbxassetid://8887499160"
voidSound.Volume = 1
voidSound.Looped = true

local rainbowColorList = {
    Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(75, 0, 130), Color3.fromRGB(148, 0, 211)
}

local function typeMessage(msg)
    voidMessageLabel.Text = ""
    local colorIndex = 1
    for i = 1, #msg do
        voidMessageLabel.Text = string.sub(msg, 1, i)
        voidMessageLabel.TextColor3 = rainbowColorList[colorIndex]
        colorIndex = colorIndex % #rainbowColorList + 1
        wait(0.05)
    end
end

local function showVoidMessage()
    infoBox.Visible = true
    voidSound:Play()
    typeMessage("Nope, you're not gone. I saved you, bozo loser")
    wait(6.2)
    infoBox.Visible = false
    voidSound:Stop()
end

local function checkVoid()
    while antiVoidEnabled do
        local plr = LocalPlayer
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.Position.Y < voidYLevel then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(safePosition)
            showVoidMessage()
        end
        wait(0.1)
    end
end

AntiGrabTab:AddToggle({
    Name = "Anti-Void",
    Default = false,
    Callback = function(enabled)
        antiVoidEnabled = enabled
        if antiVoidEnabled then checkVoid() end
    end
})

local toggleActiveAntiGrabAndBlobman = false
local autoStruggleConn = nil
local savedGrabPosition = nil
local positionThreshold = 10
local velocityThreshold = 1000
local distanceThreshold = 10
local isHeldValue = LocalPlayer:WaitForChild("IsHeld")

local function startAutoStruggle()
    autoStruggleConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Head") and char.Head:FindFirstChild("PartOwner") then
            StruggleEvent:FireServer()
            StopAllVelocity:FireServer()
            for _, child in pairs(char:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Anchored = true
                end
            end
            while LocalPlayer.IsHeld.Value do
                wait()
            end
            for _, child in pairs(char:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Anchored = false
                end
            end
        end
    end)
end

local function resetPlayerPosition()
    if toggleActiveAntiGrabAndBlobman and savedGrabPosition then
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = CFrame.new(savedGrabPosition)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if toggleActiveAntiGrabAndBlobman then
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local velocity = rootPart.AssemblyLinearVelocity
            local distance = (rootPart.Position - savedGrabPosition).Magnitude
            if velocityThreshold < velocity.Magnitude and positionThreshold < distance then
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                resetPlayerPosition()
            end
        end
    end
end)

isHeldValue.Changed:Connect(function(isHeld)
    if toggleActiveAntiGrabAndBlobman and isHeld then
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            savedGrabPosition = rootPart.Position
            local heldConn
            heldConn = RunService.RenderStepped:Connect(function()
                if isHeldValue.Value then
                    if distanceThreshold < (rootPart.Position - savedGrabPosition).Magnitude then
                        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        StruggleEvent:FireServer(LocalPlayer)
                    end
                else
                    heldConn:Disconnect()
                end
            end)
        end
    end
end)

AntiGrabTab:AddToggle({
    Name = "Anti-Grab and Anti-Blobman",
    Default = false, Save = true, Flag = "AutoStruggle",
    Callback = function(enabled)
        toggleActiveAntiGrabAndBlobman = enabled
        if enabled then
            startAutoStruggle()
        elseif autoStruggleConn then
            autoStruggleConn:Disconnect()
            autoStruggleConn = nil
        end
    end
})

local function setupAntiExplosion(char)
    local ragdolled = char:WaitForChild("Humanoid"):FindFirstChild("Ragdolled")
    if ragdolled then
        antiExplosionConnection = ragdolled:GetPropertyChangedSignal("Value"):Connect(function()
            if ragdolled.Value then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("BasePart") then child.Anchored = true end
                end
            else
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("BasePart") then child.Anchored = false end
                end
            end
        end)
    end
end

local antiExplosionCharConn = nil
AntiGrabTab:AddToggle({
    Name = "Anti Explosion",
    Default = false, Save = true, Flag = "AntiExplosion",
    Callback = function(enabled)
        if enabled then
            if LocalPlayer.Character then
                setupAntiExplosion(LocalPlayer.Character)
            end
            antiExplosionCharConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
                if antiExplosionConnection then antiExplosionConnection:Disconnect() end
                setupAntiExplosion(newChar)
            end)
        else
            if antiExplosionConnection then antiExplosionConnection:Disconnect(); antiExplosionConnection = nil end
            if antiExplosionCharConn then antiExplosionCharConn:Disconnect(); antiExplosionCharConn = nil end
        end
    end
})

AntiGrabTab:AddToggle({
    Name = "Auto Atackker - Fling Away",
    Color = Color3.fromRGB(0, 255, 255),
    Default = false, Save = true, Flag = "SelfDefenseFlingAway",
    Callback = function(enabled)
        if enabled then
            autoAttackerCoroutine = coroutine.create(function()
                while wait(0.02) do
                    local char = LocalPlayer.Character
                    local partOwner = char and char:FindFirstChild("Head") and char.Head:FindFirstChild("PartOwner")
                    if partOwner then
                        local attacker = Players:FindFirstChild(partOwner.Value)
                        if attacker and attacker.Character then
                            StruggleEvent:FireServer()
                            SetNetworkOwner:FireServer(attacker.Character.Head or attacker.Character.Torso, attacker.Character.HumanoidRootPart.FirePlayerPart.CFrame)
                            task.wait(0.1)
                            local torso = attacker.Character:FindFirstChild("Torso")
                            if torso then
                                local flingVel = torso:FindFirstChild("l") or Instance.new("BodyVelocity")
                                flingVel.Name = "l"
                                flingVel.Parent = torso
                                flingVel.Velocity = Vector3.new(math.random(-200000000, 200000000), 5000000, math.random(-200, 200))
                                flingVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                Debris:AddItem(flingVel, 1000)
                            end
                        end
                    end
                end
            end)
            coroutine.resume(autoAttackerCoroutine)
        elseif autoAttackerCoroutine then
            coroutine.close(autoAttackerCoroutine)
            autoAttackerCoroutine = nil
        end
    end
})

local antiKickActive = false
coroutine.wrap(function()
    while true do
        if antiKickActive then
            RagdollRemote:FireServer(LocalPlayer.Character:WaitForChild("HumanoidRootPart"), 0)
        end
        task.wait()
    end
end)()

AntiGrabTab:AddToggle({
    Name = "Anti Kick",
    Default = false,
    Callback = function(enabled) antiKickActive = enabled end
})

AntiGrabTab:AddToggle({
    Name = "Anti Lag",
    Default = false,
    Callback = function(enabled)
        if enabled then
            local grabLine = ReplicatedStorage:FindFirstChild("GrabEvents") and ReplicatedStorage.GrabEvents:FindFirstChild("CreateGrabLine")
            if grabLine then grabLine:Destroy() end
        end
    end
})

local SigmaGrabsTab = Window:MakeTab({
    Name = "Sigma Grabs",
    Icon = "rbxassetid://18792162015",
    PremiumOnly = false
})

local function radioactiveGrabHandler()
    while true do
        pcall(function()
            local grabParts = Workspace:FindFirstChild("GrabParts")
            local head = grabParts and grabParts.Name == "GrabParts" and grabParts:FindFirstChild("GrabPart"):FindFirstChild("WeldConstraint").Part1.Parent:FindFirstChild("Head")
            if head then
                while Workspace:FindFirstChild("GrabParts") do
                    for _, part in pairs(poisonHurtParts) do
                        part.Size = Vector3.new(2, 2, 2)
                        part.Transparency = 1
                        part.Position = head.Position
                    end
                    wait()
                    for _, part in pairs(poisonHurtParts) do
                        part.Position = Vector3.new(0, -200, 0)
                    end
                end
            end
        end)
        wait()
    end
end

SigmaGrabsTab:AddToggle({
    Name = "Radioactive Grab",
    Default = false, Save = true, Flag = "RadioactiveGrab",
    Callback = function(enabled)
        if enabled then
            radioactiveGrabCoroutine = coroutine.create(radioactiveGrabHandler)
            coroutine.resume(radioactiveGrabCoroutine)
        elseif radioactiveGrabCoroutine then
            coroutine.close(radioactiveGrabCoroutine)
            radioactiveGrabCoroutine = nil
            for _, part in pairs(paintPlayerParts) do
                part.Position = Vector3.new(0, -200, 0)
            end
        end
    end
})

local function noclipGrabHandler()
    while true do
        pcall(function()
            local grabParts = Workspace:FindFirstChild("GrabParts")
            if grabParts and grabParts.Name == "GrabParts" then
                local targetChar = grabParts:FindFirstChild("GrabPart"):FindFirstChild("WeldConstraint").Part1.Parent
                if targetChar.HumanoidRootPart then
                    while Workspace:FindFirstChild("GrabParts") do
                        for _, child in pairs(targetChar:GetChildren()) do
                            if child:IsA("BasePart") then child.CanCollide = false end
                        end
                        wait()
                    end
                    for _, child in pairs(targetChar:GetChildren()) do
                        if child:IsA("BasePart") then child.CanCollide = true end
                    end
                end
            end
        end)
        wait()
    end
end

SigmaGrabsTab:AddToggle({
    Name = "No-clip Grab",
    Default = false, Save = true, Flag = "NoclipGrab",
    Callback = function(enabled)
        if enabled then
            noclipGrabCoroutine = coroutine.create(noclipGrabHandler)
            coroutine.resume(noclipGrabCoroutine)
        elseif noclipGrabCoroutine then
            coroutine.close(noclipGrabCoroutine)
            noclipGrabCoroutine = nil
        end
    end
})

local mobileFlingEnabled = false
local mobileFlingStrength = 400

SigmaGrabsTab:AddToggle({
    Name = "Stronger Fling(Mobile)",
    Default = false,
    Callback = function(enabled) mobileFlingEnabled = enabled end
})

SigmaGrabsTab:AddSlider({
    Name = "Strength Slider",
    Min = 400, Max = 30000, Default = 400, Increment = 10,
    Callback = function(value) mobileFlingStrength = value end
})

Workspace.ChildAdded:Connect(function(newObject)
    local targetPart = newObject.Name == "GrabParts" and newObject.GrabPart.WeldConstraint.Part1
    if targetPart then
        local flingVel = Instance.new("BodyVelocity", targetPart)
        flingVel.MaxForce = Vector3.new(0, 0, 0)
        local flingButton = nil
        while flingButton == nil and newObject.Parent do
            for _, descendant in pairs(LocalPlayer.PlayerGui.ContextActionGui:GetDescendants()) do
                if descendant:IsA("ImageLabel") and descendant.Image == "http://www.roblox.com/asset/?id=9603678090" then
                    flingButton = descendant.Parent
                end
            end
            RunService.Heartbeat:Wait()
        end
        if flingButton then
            flingButton.MouseButton1Up:Connect(function()
                if mobileFlingEnabled then
                    flingVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    flingVel.Velocity = Workspace.CurrentCamera.CFrame.lookVector * mobileFlingStrength
                end
            end)
            flingButton.MouseButton1Down:Connect(function()
                if mobileFlingEnabled then
                    flingVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    flingVel.Velocity = Workspace.CurrentCamera.CFrame.lookVector * mobileFlingStrength
                end
            end)
        end
        local parentConn = newObject:GetPropertyChangedSignal("Parent"):Connect(function()
            if not newObject.Parent then
                parentConn:Disconnect()
                Debris:AddItem(flingVel, 1)
            end
        end)
    end
end)

local pcFlingEnabled = false
local pcFlingStrength = 400

SigmaGrabsTab:AddToggle({
    Name = "Stronger Fling (PC)",
    Default = false,
    Callback = function(enabled) pcFlingEnabled = enabled end
})

SigmaGrabsTab:AddSlider({
    Name = "Strength",
    Min = 400, Max = 30000, Default = 400,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 10, ValueName = "Strength",
    Callback = function(value) pcFlingStrength = value * 100 end
})

Workspace.ChildAdded:Connect(function(newObject)
    local targetPart = newObject.Name == "GrabParts" and pcFlingEnabled and newObject.GrabPart.WeldConstraint.Part1
    if targetPart then
        local flingVel = Instance.new("BodyVelocity", targetPart)
        newObject:GetPropertyChangedSignal("Parent"):Connect(function()
            if not newObject.Parent then
                if UserInputService:GetLastInputType() ~= Enum.UserInputType.MouseButton2 or not pcFlingEnabled then
                    if UserInputService:GetLastInputType() ~= Enum.UserInputType.MouseButton1 then
                        flingVel:Destroy()
                    else
                        flingVel:Destroy()
                    end
                else
                    flingVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    flingVel.Velocity = Workspace.CurrentCamera.CFrame.lookVector * pcFlingStrength
                    Debris:AddItem(flingVel, 1)
                end
            end
        end)
    end
end)

local skyGrabEnabled = false
local skyGrabConn = nil

SigmaGrabsTab:AddToggle({
    Name = "Sky Grab(Players And Objects)",
    Default = false,
    Callback = function(enabled)
        skyGrabEnabled = enabled
        if skyGrabEnabled then
            if not skyGrabConn then
                skyGrabConn = Workspace.ChildAdded:Connect(function(newObject)
                    if newObject.Name == "GrabParts" then
                        local grabPart = newObject:FindFirstChild("GrabPart")
                        if grabPart and grabPart:FindFirstChild("WeldConstraint") then
                            local bodyVel = Instance.new("BodyVelocity")
                            bodyVel.Parent = grabPart
                            bodyVel.Velocity = Vector3.new(0, 100, 0)
                            bodyVel.MaxForce = Vector3.new(0, math.huge, 0)
                        end
                    end
                end)
            end
        elseif skyGrabConn then
            skyGrabConn:Disconnect()
            skyGrabConn = nil
        end
    end
})

local spinGrabEnabled = false
Workspace.ChildAdded:Connect(function(newObject)
    local targetPart = spinGrabEnabled and newObject.Name == "GrabParts" and newObject.GrabPart.WeldConstraint.Part1
    if targetPart then
        local bodyAngularVel = Instance.new("BodyAngularVelocity")
        bodyAngularVel.Parent = targetPart
        bodyAngularVel.AngularVelocity = Vector3.new(0, 1000, 0)
        bodyAngularVel.MaxTorque = Vector3.new(0, math.huge, 0)
    end
end)

SigmaGrabsTab:AddToggle({
    Name = "Spin Grab(Players And Objects)",
    Default = false,
    Callback = function(enabled) spinGrabEnabled = enabled end
})

local teleportUpEnabled = false
local teleportDownEnabled = false

local function teleportGrabbedUp(grabPartsFolder)
    local part = grabPartsFolder.GrabPart.WeldConstraint.Part1
    if part then
        local hum = part.Parent:FindFirstChildOfClass("Humanoid")
        local rootPart = hum and part.Parent:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, 30, 0))
            hum.PlatformStand = true
            hum.AutoRotate = false
            hum.Sit = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end

local function teleportGrabbedDown(grabPartsFolder)
    local part = grabPartsFolder.GrabPart.WeldConstraint.Part1
    if part then
        local hum = part.Parent:FindFirstChildOfClass("Humanoid")
        local rootPart = hum and part.Parent:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, -50, 0))
            hum.PlatformStand = true
            hum.AutoRotate = false
            hum.Sit = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end

Workspace.ChildAdded:Connect(function(newObject)
    if newObject.Name == "GrabParts" and teleportUpEnabled then
        teleportGrabbedUp(newObject)
    end
end)

Workspace.ChildAdded:Connect(function(newObject)
    if newObject.Name == "GrabParts" and teleportDownEnabled then
        teleportGrabbedDown(newObject)
    end
end)

SigmaGrabsTab:AddToggle({
    Name = "Teleport Up (Players Only)",
    Default = false,
    Callback = function(enabled) teleportUpEnabled = enabled end
})

SigmaGrabsTab:AddToggle({
    Name = "Teleport Down (Players Only)",
    Default = false,
    Callback = function(enabled) teleportDownEnabled = enabled end
})

local killGrabEnabled = false
local killGrabConn = nil

local function killGrabHandler(newObject)
    if newObject.Name == "GrabParts" then
        local weldConstraint = newObject:FindFirstChild("GrabPart") and newObject.GrabPart:FindFirstChild("WeldConstraint")
        if weldConstraint then
            local part1 = weldConstraint.Part1
            if part1 then
                part1.Parent:BreakJoints()
            end
        end
    end
end

SigmaGrabsTab:AddToggle({
    Name = "Kill Grab",
    Default = false,
    Callback = function(enabled)
        killGrabEnabled = enabled
        if killGrabEnabled then
            killGrabConn = Workspace.ChildAdded:Connect(killGrabHandler)
        elseif killGrabConn then
            killGrabConn:Disconnect()
            killGrabConn = nil
        end
    end
})

local GrabAuraTab = Window:MakeTab({
    Name = "Grab Aura Special",
    Icon = "rbxassetid://95273155675205",
    PremiumOnly = false
})

local auraRadius = 20
local grabAuraWhitelist = { JESSETC92BACKUP1 = true }

GrabAuraTab:AddToggle({
    Name = "Poison Aura",
    Default = false, Save = true,
    Callback = function(enabled)
        if enabled then
            poisonAuraCoroutine = coroutine.create(function()
                while enabled do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local rootPart = char.HumanoidRootPart
                            for _, plr in pairs(Players:GetPlayers()) do
                                if plr ~= LocalPlayer and plr.Character then
                                    local targetChar = plr.Character
                                    local torso = targetChar:FindFirstChild("Torso")
                                    if torso then
                                        local distance = (torso.Position - rootPart.Position).Magnitude
                                        if distance <= auraRadius then
                                            local head = targetChar:FindFirstChild("Head")
                                            while distance <= auraRadius do
                                                SetNetworkOwner:FireServer(torso, targetChar.HumanoidRootPart.CFrame)
                                                distance = (torso.Position - rootPart.Position).Magnitude
                                                for _, poisonPart in pairs(poisonHurtParts) do
                                                    poisonPart.Size = Vector3.new(1, 3, 1)
                                                    poisonPart.Transparency = 1
                                                    poisonPart.Position = head.Position
                                                end
                                                wait()
                                                for _, poisonPart in pairs(poisonHurtParts) do
                                                    poisonPart.Position = Vector3.new(0, -200, 0)
                                                end
                                            end
                                            for _, poisonPart in pairs(poisonHurtParts) do
                                                poisonPart.Position = Vector3.new(0, -200, 0)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    wait(0.02)
                end
            end)
            coroutine.resume(poisonAuraCoroutine)
        elseif poisonAuraCoroutine then
            coroutine.close(poisonAuraCoroutine)
            for _, part in pairs(poisonHurtParts) do
                part.Position = Vector3.new(0, -200, 0)
            end
            poisonAuraCoroutine = nil
        end
    end
})

local flingAuraActive = false
local flingAuraRange = 50
local flingAuraMaxVelocity = 6000
local flingAuraHeartbeatConn = nil
local flingAuraGrabbedPlayers = {}

local function getPlayersInFlingRange()
    local playersInRange = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Left Arm") and not grabAuraWhitelist[plr.Name] then
            local distance = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= flingAuraRange then
                table.insert(playersInRange, plr)
            end
        end
    end
    return playersInRange
end

local function fireFlingGrab(leftArm)
    if leftArm then
        pcall(function()
            SetNetworkOwner:FireServer(leftArm, leftArm.CFrame)
        end)
        flingAuraGrabbedPlayers[leftArm.Parent] = true
    end
end

local function applyFlingVelocity(leftArm)
    if leftArm then
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.new(0, 1000, 0)
        bodyVel.MaxForce = Vector3.new(flingAuraMaxVelocity, math.huge, flingAuraMaxVelocity)
        bodyVel.Parent = leftArm.Parent.HumanoidRootPart
    end
end

local function connectFlingHeartbeat()
    if not flingAuraHeartbeatConn then
        flingAuraHeartbeatConn = RunService.Heartbeat:Connect(function()
            if flingAuraActive then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and not grabAuraWhitelist[plr.Name] then
                        local char = plr.Character
                        if char then
                            local leftArm = char:FindFirstChild("Left Arm")
                            if leftArm and not flingAuraGrabbedPlayers[char] and (leftArm.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= flingAuraRange then
                                fireFlingGrab(leftArm)
                                pcall(function() char.Humanoid.Jump = true end)
                                applyFlingVelocity(leftArm)
                            end
                        end
                    end
                end
            end
        end)
    end
end

local function cleanupFlingAuraPlayers()
    for char, _ in pairs(flingAuraGrabbedPlayers) do
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local bodyVel = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVel then bodyVel:Destroy() end
        end
    end
    flingAuraGrabbedPlayers = {}
end

GrabAuraTab:AddToggle({
    Name = "Fling Aura",
    Default = false,
    Callback = function(enabled)
        flingAuraActive = enabled
        if flingAuraActive then
            connectFlingHeartbeat()
            coroutine.wrap(function()
                while flingAuraActive do
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Left Arm") and not grabAuraWhitelist[plr.Name] then
                            local pos = plr.Character.HumanoidRootPart.Position
                            local dist = (pos - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if dist <= flingAuraRange then
                                pcall(function()
                                    SetNetworkOwner:FireServer(plr.Character["Left Arm"], CFrame.new(pos) * CFrame.Angles(-3.032, 0.451, 3.094))
                                end)
                            end
                        end
                    end
                    wait(0.1)
                end
            end)()
        else
            if flingAuraHeartbeatConn then flingAuraHeartbeatConn:Disconnect(); flingAuraHeartbeatConn = nil end
            cleanupFlingAuraPlayers()
        end
    end
})

GrabAuraTab:AddSlider({
    Name = "Max Velocity",
    Min = 400, Max = 60000, Default = 1000,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 100, ValueName = "Velocity",
    Callback = function(value) flingAuraMaxVelocity = value end
})

local AnnoyTab = Window:MakeTab({
    Name = "Annoy All Players",
    Icon = "rbxassetid://137605305057180",
    PremiumOnly = false
})

local function fireAllPlayers()
    while true do
        pcall(function()
            local campfire = SpawnedInToysFolder:FindFirstChild("Campfire")
            if not campfire then
                spawnItemAt("Campfire", PlayerCharacter.Head.CFrame)
                campfire = SpawnedInToysFolder:WaitForChild("Campfire")
            end
            local firePlayerPart = nil
            for _, child in pairs(campfire:GetChildren()) do
                if child.Name == "FirePlayerPart" then
                    child.Size = Vector3.new(10, 10, 10)
                    firePlayerPart = child
                end
            end
            if firePlayerPart then
                local originalPos = PlayerCharacter.Torso.Position
                SetNetworkOwner:FireServer(firePlayerPart, firePlayerPart.CFrame)
                PlayerCharacter:MoveTo(firePlayerPart.Position)
                wait(0.3)
                PlayerCharacter:MoveTo(originalPos)
                local bodyPos = Instance.new("BodyPosition")
                bodyPos.P = 20000
                bodyPos.Position = PlayerCharacter.Head.Position + Vector3.new(0, 600, 0)
                bodyPos.Parent = campfire.Main
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr.Character and plr.Character ~= PlayerCharacter then
                        firePlayerPart.Position = plr.Character.HumanoidRootPart.Position or plr.Character.Head.Position
                        wait()
                    end
                end
            end
        end)
        wait()
    end
end

AnnoyTab:AddToggle({
    Name = "Fire All(Using Campfires)",
    Default = false, Save = true,
    Callback = function(enabled)
        if enabled then
            fireAllCoroutine = coroutine.create(fireAllPlayers)
            coroutine.resume(fireAllCoroutine)
        elseif fireAllCoroutine then
            coroutine.close(fireAllCoroutine)
            fireAllCoroutine = nil
        end
    end
})

local function spawnBanana()
    SpawnToyRemote:InvokeServer("FoodBanana", CFrame.new(67.553, -5.757, -84.976) * CFrame.Angles(-2.702, 1.114, 2.742), Vector3.new(0, 113.989, 0))
end

local function holdBanana()
    local banana = Workspace[LocalPlayer.Name .. "SpawnedInToys"].FoodBanana
    banana.HoldPart.HoldItemRemoteFunction:InvokeServer(banana, LocalPlayer.Character)
end

local function useBanana()
    local banana = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys"):FindFirstChild("FoodBanana")
    if banana then
        ReplicatedStorage.HoldEvents.Use:FireServer(banana)
    end
end

local function dropBanana()
    local banana = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys").FoodBanana
    local head = LocalPlayer.Character:FindFirstChild("Head")
    if banana and head then
        local dropPos = head.Position - Vector3.new(0, 3, 0)
        banana.HoldPart.DropItemRemoteFunction:InvokeServer(banana, CFrame.new(dropPos + Vector3.new(0, 5, 0)), Vector3.new(0, -48.736, 0))
    end
end

local ragdollAllActive = false
local ragdollCoroutine = nil

local function bananaRagdollLoop()
    while ragdollAllActive do
        pcall(function()
            local localChar = LocalPlayer.Character
            local toyFolder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if not toyFolder:FindFirstChild("FoodBanana") then
                spawnBanana()
            end
            local banana = toyFolder:WaitForChild("FoodBanana")
            local bananaPeel = nil
            for _, child in pairs(banana:GetChildren()) do
                if child.Name == "BananaPeel" and child:FindFirstChild("TouchInterest") then
                    child.Size = Vector3.new(10, 10, 10)
                    child.Transparency = 1
                    bananaPeel = child
                    break
                end
            end
            local bodyPos = Instance.new("BodyPosition")
            bodyPos.P = 20000
            bodyPos.D = 1000
            bodyPos.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyPos.Parent = banana.Main
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
            bodyGyro.Parent = banana.Main
            while ragdollAllActive do
                for _, plr in pairs(Players:GetPlayers()) do
                    pcall(function()
                        if plr.Character and plr.Character ~= localChar then
                            if bananaPeel then
                                bananaPeel.Position = plr.Character.HumanoidRootPart.Position or plr.Character.Head.Position
                            end
                            bodyPos.Position = localChar.Head.Position + Vector3.new(0, 10, 0)
                            bodyGyro.CFrame = bodyGyro.CFrame * CFrame.Angles(0, math.rad(5), 0)
                            wait(0.03)
                        end
                    end)
                end
                wait()
            end
        end)
        wait()
    end
end

AnnoyTab:AddToggle({
    Name = "Ragdoll All",
    Default = false,
    Callback = function(enabled)
        if enabled then
            spawnBanana()
            wait(0.2)
            holdBanana()
            wait(0.2)
            useBanana()
            wait(2.3)
            SetNetworkOwner:FireServer(Workspace[LocalPlayer.Name .. "SpawnedInToys"].FoodBanana.SoundPart, Workspace[LocalPlayer.Name .. "SpawnedInToys"].FoodBanana.SoundPart.CFrame)
            wait(0.2)
            dropBanana()
            ragdollAllActive = true
            ragdollCoroutine = coroutine.create(bananaRagdollLoop)
            coroutine.resume(ragdollCoroutine)
        else
            ragdollAllActive = false
        end
    end
})

local BlackHoleTab = Window:MakeTab({
    Name = "Grab Aura Objects/Toys Soon...",
    Icon = "rbxassetid://70380657486456",
    PremiumOnly = false
})

local blackHoleActive = false
local blackHoleResetDone = true
local blackHoleDescendantConn = nil
local blackHoleRenderConn = nil
local blackHoleFolder = Instance.new("Folder", Workspace)
blackHoleFolder.Name = "BlackHoleFolder"
local blackHoleAnchor = Instance.new("Part", blackHoleFolder)
blackHoleAnchor.Name = "BlackHoleAnchor"
blackHoleAnchor.Anchored = true
blackHoleAnchor.CanCollide = false
blackHoleAnchor.Transparency = 1
local blackHoleAttachment = Instance.new("Attachment", blackHoleAnchor)

if not getgenv().Network then
    getgenv().Network = { BaseParts = {}, Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424) }
    function getgenv().Network.RetainPart(part)
        if typeof(part) == "Instance" and part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
            table.insert(getgenv().Network.BaseParts, part)
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            part.CanCollide = false
        end
    end
end

local function forcePartIntoBlackHole(part)
    if part:IsA("Part") and not part.Anchored and not part.Parent:FindFirstChild("Humanoid") and not part.Parent:FindFirstChild("Head") and part.Name ~= "Handle" then
        for _, child in ipairs(part:GetChildren()) do
            if child:IsA("BodyAngularVelocity") or child:IsA("BodyForce") or child:IsA("BodyGyro") or child:IsA("BodyPosition") or child:IsA("BodyThrust") or child:IsA("BodyVelocity") or child:IsA("RocketPropulsion") then
                child:Destroy()
            end
        end
        local existingAttachment = part:FindFirstChild("Attachment")
        if existingAttachment then existingAttachment:Destroy() end
        local existingAlign = part:FindFirstChild("AlignPosition")
        if existingAlign then existingAlign:Destroy() end
        local existingTorque = part:FindFirstChild("Torque")
        if existingTorque then existingTorque:Destroy() end
        part.CanCollide = false
        local torque = Instance.new("Torque", part)
        torque.Torque = Vector3.new(100000, 100000, 100000)
        local alignPosition = Instance.new("AlignPosition", part)
        local partAttachment = Instance.new("Attachment", part)
        torque.Attachment0 = partAttachment
        alignPosition.MaxForce = math.huge
        alignPosition.MaxVelocity = math.huge
        alignPosition.Responsiveness = 200
        alignPosition.Attachment0 = partAttachment
        alignPosition.Attachment1 = blackHoleAttachment
        getgenv().Network.RetainPart(part)
    end
end

local function releasePartFromBlackHole(part)
    if part:IsA("Part") and not part.Anchored then
        local torque = part:FindFirstChild("Torque")
        if torque then torque:Destroy() end
        local align = part:FindFirstChild("AlignPosition")
        if align then align:Destroy() end
        part.CanCollide = true
    end
end

local function toggleBlackHole()
    if blackHoleActive then
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            forcePartIntoBlackHole(descendant)
        end
        blackHoleDescendantConn = Workspace.DescendantAdded:Connect(function(descendant)
            if blackHoleActive then forcePartIntoBlackHole(descendant) end
        end)
        blackHoleRenderConn = RunService.RenderStepped:Connect(function()
            blackHoleAnchor.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end)
    else
        for _, part in ipairs(getgenv().Network.BaseParts) do
            releasePartFromBlackHole(part)
        end
        if blackHoleDescendantConn then blackHoleDescendantConn:Disconnect(); blackHoleDescendantConn = nil end
        if blackHoleRenderConn then blackHoleRenderConn:Disconnect(); blackHoleRenderConn = nil end
        if not blackHoleResetDone then
            blackHoleResetDone = true
            RunService.Heartbeat:Wait()
            LocalPlayer.Character:BreakJoints()
        end
    end
end

BlackHoleTab:AddToggle({
    Name = "Black Hole (Warning Grab Will Be Broken If You Turn this on)",
    Default = false,
    Callback = function(enabled)
        blackHoleActive = enabled
        if blackHoleActive then
            blackHoleResetDone = false
            toggleBlackHole()
        else
            toggleBlackHole()
        end
    end
})

local BlobManTab = Window:MakeTab({
    Name = "Sigma BlobMan",
    Icon = "rbxassetid://18882071652",
    PremiumOnly = false
})

local blobmanGrabActive = false
local blobmanGrabSpeed = 0.01
local blobmanWhitelist = { JESSETC92BACKUP1 = true }
local blobmanGrabbedPlayers = {}

local function findBlobman()
    for _, plr in pairs(Players:GetPlayers()) do
        local toyFolder = Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
        if toyFolder and toyFolder:FindFirstChild("CreatureBlobman") then
            return toyFolder.CreatureBlobman, plr
        end
    end
    return nil, nil
end

local function grabAndDropRandomPlayer()
    local blobman, spawner = findBlobman()
    if not blobman then return end
    local availablePlayers = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name ~= "JESSETC92BACKUP1" and plr ~= spawner and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and not table.find(blobmanGrabbedPlayers, plr) then
            table.insert(availablePlayers, plr)
        end
    end
    if #availablePlayers == 0 then
        blobmanGrabbedPlayers = {}
        return
    end
    local target = availablePlayers[math.random(#availablePlayers)]
    blobman.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(blobman.RightDetector, target.Character.HumanoidRootPart, blobman.RightDetector.RightWeld)
    table.insert(blobmanGrabbedPlayers, target)
    wait(0.05)
    blobman.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(target.Character.HumanoidRootPart)
end

BlobManTab:AddToggle({
    Name = "Grab and Drop Loop Safely",
    Default = false,
    Callback = function(enabled)
        blobmanGrabActive = enabled
        if blobmanGrabActive then
            coroutine.wrap(function()
                while blobmanGrabActive do
                    grabAndDropRandomPlayer()
                    wait(blobmanGrabSpeed)
                end
            end)()
        end
    end
})

BlobManTab:AddSlider({
    Name = "Grab Speed",
    Min = 0.001, Max = 2, Default = 0.01, Increment = 0.001,
    Callback = function(value) blobmanGrabSpeed = value end
})

local FunAuraTab = Window:MakeTab({
    Name = "Sigma Fun Aura Toys",
    Icon = "rbxassetid://18792316398",
    PremiumOnly = false
})

FunAuraTab:AddLabel("do not spam q if flings u reset")
FunAuraTab:AddLabel("press J to make npcs go up u have to the npc slot rbloxions to work")
FunAuraTab:AddLabel("After use of remove map click the rejoin script to fix")
FunAuraTab:AddLabel("Press 0/ZERO to disable No gravity")
FunAuraTab:AddLabel("if somthing buggy click the reset button and press keybind 3")

FunAuraTab:AddButton({
    Name = "Press 0/ZERO keybind to ativate no gravity",
    Callback = function()
        local gravityEnabled = true
        local function disableGravityRecursive(instance)
            if instance:IsA("BasePart") then
                instance.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            end
            for _, child in ipairs(instance:GetChildren()) do
                disableGravityRecursive(child)
            end
        end
        local function toggleGravity()
            gravityEnabled = not gravityEnabled
            if gravityEnabled then
                Workspace.Gravity = 0
                for _, descendant in ipairs(Workspace:GetDescendants()) do
                    disableGravityRecursive(descendant)
                end
            else
                Workspace.Gravity = 196.2
            end
        end
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Zero then
                toggleGravity()
            end
        end)
    end
})

FunAuraTab:AddButton({
    Name = "Reset Press keybind 3 to use",
    Callback = function()
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Three then
                LocalPlayer.Character:BreakJoints()
            end
        end)
    end
})

FunAuraTab:AddButton({
    Name = "Make nearby objects go up press q dont spam",
    Callback = function()
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Q then
                for _, descendant in pairs(Workspace:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        local bodyForce = Instance.new("BodyForce")
                        bodyForce.Force = Vector3.new(0, 2000, 0)
                        bodyForce.Parent = descendant
                    end
                end
            end
        end)
    end
})

FunAuraTab:AddButton({
    Name = "make all npcs go up FE",
    Callback = function()
        local function liftNPCs()
            for _, descendant in pairs(Workspace:GetDescendants()) do
                if descendant:IsA("Model") and descendant:FindFirstChild("Humanoid") then
                    local liftPart = Instance.new("Part")
                    liftPart.Size = Vector3.new(10, 10, 10)
                    liftPart.Position = descendant.PrimaryPart.Position + Vector3.new(0, 20, 0)
                    liftPart.Anchored = true
                    liftPart.Parent = Workspace
                    descendant.HumanoidRootPart.CFrame = liftPart.CFrame
                    liftPart:Destroy()
                end
            end
        end
        UserInputService.InputBegan:Connect(function(input, isTyping)
            if not isTyping and input.KeyCode == Enum.KeyCode.J then
                liftNPCs()
            end
        end)
    end
})

FunAuraTab:AddButton({
    Name = "remove map wait 5 seconds",
    Callback = function()
        for _, child in pairs(Workspace:GetChildren()) do
            if child:IsA("Model") and not child:FindFirstChild("Humanoid") then
                child:BreakJoints()
                child:MoveTo(Vector3.new(math.random(-100, 100), math.random(50, 150), math.random(-100, 100)))
            end
        end
    end
})

FunAuraTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
})

local MiscTab = Window:MakeTab({
    Name = "Sigma Misc",
    Icon = "rbxassetid://18792349054",
    PremiumOnly = false
})

MiscTab:AddButton({
    Name = "Make Fov normal",
    Callback = function()
        if Workspace.CurrentCamera then
            Workspace.CurrentCamera.FieldOfView = 80
        end
    end
})

MiscTab:AddSlider({
    Name = "Fov Changer",
    Min = 10, Max = 120, Default = 80,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1, ValueName = "bananas",
    Callback = function(value)
        if Workspace.CurrentCamera then
            Workspace.CurrentCamera.FieldOfView = value
        end
    end
})

local OtherGuisTab = Window:MakeTab({
    Name = "Sigma Other Guis/Verbal Other Guis",
    Icon = "rbxassetid://18793450630",
    PremiumOnly = false
})

OtherGuisTab:AddButton({
    Name = "Made By Verbal Hub Bee swarm",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/Bee%20Swarm%20Sim.Lua", true))() end
})

OtherGuisTab:AddButton({
    Name = "Chat Admin Made By Verbal Hub",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/Protected_3155119884811326.txt", true))() end
})

OtherGuisTab:AddButton({
    Name = "Our New Music Player",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/Protected_2929642756813318.txt", true))() end
})

OtherGuisTab:AddButton({
    Name = "Chat Bypasser Simple",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hellohellohell012321/KAWAII-BYPASS/main/kawaii-bypass", true))() end
})

OtherGuisTab:AddButton({
    Name = "CatBypasser Op",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/shadow62x/catbypass/main/upfix"))() end
})

OtherGuisTab:AddButton({
    Name = "Dex/Mobile Only",
    Callback = function()
        getgenv().Key = "Bash"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/crceck123/roblox-script/main/MC_IY%20Dex.txt"))()
    end
})

OtherGuisTab:AddButton({
    Name = "Infinite Yield",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end
})

OtherGuisTab:AddButton({
    Name = "Nameless admin",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))() end
})

OtherGuisTab:AddButton({
    Name = "VHS",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/fgdergewrgegr/SVH/main/VHSV4"))() end
})

OtherGuisTab:AddButton({
    Name = "Ftap op script",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua"))() end
})

local keyboardSection = OtherGuisTab:AddSection({ Name = "Mobile Keyboard" })

OtherGuisTab:AddButton({
    Name = "keyboard",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/GGH52lan/GGH52lan/main/keyboard.txt"))() end
})

local DiscordTab = Window:MakeTab({
    Name = "Very Sigma Our Discord Server",
    Icon = "rbxassetid://18793427633",
    PremiumOnly = false
})

DiscordTab:AddParagraph("Our discord", "https://discord.gg/yfQNMyJjnq")

DiscordTab:AddButton({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("https://discord.gg/yfQNMyJjnq")
        OrionLib:MakeNotification({
            Name = "You Copied The Discord Link",
            Content = "Discord link copied to clipboard!",
            Image = "rbxassetid://4483345998",
            Time = 4
        })
    end
})

local function executeScript(url)
    pcall(function()
        loadstring(game:HttpGet(url, true))()
    end)
end

local function executeOnce(url, alreadyExecuted)
    if alreadyExecuted then return alreadyExecuted end
    executeScript(url)
    return true
end

executeOnce("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/ss", false)
executeOnce("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/teleport%20button", false)
executeOnce("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/anchor", false)
executeOnce("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/erm", false)
executeOnce("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/main/s", false)
executeOnce("https://raw.githubusercontent.com/VerbalHubz/Verbal-Hub/refs/heads/main/aaaaaa", false)

OrionLib:MakeNotification({
    Name = "Welcome to Verbal Sigma Hub",
    Content = "Aww my wattle little skibidi is hacking :)",
    Image = "rbxassetid://18793558154",
    Time = 4
})

return;
