--[[ 
    FLING IN PEOPLE - COMPLETE SCRIPT (ALL FEATURES WORKING!)
    For green8333 - WITH FREEZE FEATURE
--]]

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Get game's real spawn data
local SpawnToyRemote = ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")

-- ========== DYNAMIC TOY LOADING ==========
local MenuToysData = require(ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("MenuToysData"))

local toyNameMap = {}
local allToyNames = MenuToysData.GetAllToysSortedByName()

for _, toyName in ipairs(allToyNames) do
    local data = MenuToysData.GetMenuToyData(toyName)
    local display = data.FakeName
    if not toyNameMap[display] then
        toyNameMap[display] = toyName
    end
end

local toyDisplayNames = {}
for display, _ in pairs(toyNameMap) do
    table.insert(toyDisplayNames, display)
end
table.sort(toyDisplayNames)

-- Configuration
local flingEnabled = false
local flingStrength = 25
local gravityEnabled = false
local gravityForce = 5000
local zeroGravityEnabled = false
local zeroGravityForce = 50000
local spinEnabled = false
local spinSpeed = 500

-- Boomerang Configuration
local boomerangEnabled = false
local boomerangReturnTime = 5
local boomerangThrowStrength = 100
local boomerangArcHeight = 150

-- Teleport Configuration
local teleportEnabled = false
local selectedPlayersForTeleport = {}
local teleportingItems = {}
local teleportSpeed = 50
local teleportCycleTime = 5
local orbitEnabled = false
local orbitRadius = 10
local orbitSpeed = 5

-- Rapid Fling Teleport Configuration
local rapidFlingEnabled = false
local rapidFlingSpeed = 500
local rapidFlingItems = {}
local selectedPlayersForRapidFling = {}

-- ========== FREEZE CONFIGURATION ==========
local freezeEnabled = false
local freezePlayers = false
local freezeItems = false

-- ========== ANTI-GRAB PROTECTION ==========
local antiGrabEnabled = false
local antiGrabConnection = nil

-- ========== SPECTATOR GRAB VARIABLES ==========
local spectatorGrabEnabled = false
local spectatorTargetName = nil
local spectatorConnection = nil
local useRightHand = true
local useLeftHand = true
local pullStrength = 80
local teleportToCreature = true

-- Anti-lag protection
local antiLagEnabled = true
local maxGrabsPerSecond = 10
local grabTimestamps = {}

-- Tracking for active effects
local spinningItems = {}
local activeForces = {}
local boomerangItems = {}
local touchedConnections = {}
local grabPartsToItems = {}
local allGrabbedParts = {}
local frozenItems = {} -- Track frozen items

-- Item Follow Configuration
local followEnabled = false
local followingItems = {}
local followBodyPositions = {}
local followSpeed = 50

-- Spawner Config
local spawnerEnabled = false
local selectedToy = nil
local selectedToyRealName = nil
local spawnHeight = 2
local spawnDistance = 20
local spawnSpeed = 0.05
local useCircleSpawn = false
local circleRadius = 20
local circleAngle = 0
local spawnAtCamera = true
local clickedLocation = nil
local spawnConnection = nil
local spawnedItems = {}

-- Optimization counters
local tickCounter = 0
local antiGrabCounter = 0
local spectatorCounter = 0

-- ========== ORIGINAL FUNCTIONS ==========

local function isValidItem(part)
    if not part or not part.Parent then return false end
    if part.Parent:FindFirstChild("Humanoid") or (part.Parent.Parent and part.Parent.Parent:FindFirstChild("Humanoid")) then
        return true
    end
    if part.Anchored then return false end
    if part:IsDescendantOf(Workspace.Terrain) then return false end
    local name = part.Name:lower()
    if name == "baseplate" or name == "ground" or name == "floor" or name:find("map") or name:find("wall") then
        return false
    end
    if not part:IsA("BasePart") then return false end
    return true
end

local function getFootPosition()
    if not LocalPlayer.Character then return Vector3.new(0, -1000, 0) end
    local leftFoot = LocalPlayer.Character:FindFirstChild("LeftFoot")
    local rightFoot = LocalPlayer.Character:FindFirstChild("RightFoot")
    local footPosition = Vector3.new(0, -1000, 0)
    if leftFoot then
        footPosition = leftFoot.Position
    elseif rightFoot then
        footPosition = rightFoot.Position
    else
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            footPosition = hrp.Position
        end
    end
    return footPosition - Vector3.new(0, 1, 0)
end

local function getPlayerTorsoPosition(player)
    if not player or not player.Character then return nil end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp.Position + Vector3.new(0, 2, 0)
    end
    return getPlayerFeetPosition(player)
end

local function getPlayerFeetPosition(player)
    if not player or not player.Character then return nil end
    local leftFoot = player.Character:FindFirstChild("LeftFoot")
    local rightFoot = player.Character:FindFirstChild("RightFoot")
    if leftFoot then
        return leftFoot.Position - Vector3.new(0, 1, 0)
    elseif rightFoot then
        return rightFoot.Position - Vector3.new(0, 1, 0)
    end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp.Position - Vector3.new(0, 3, 0)
    end
    return nil
end

local function isPartBeingHeld(part)
    for _, child in pairs(Workspace:GetChildren()) do
        if child.Name == "GrabParts" then
            local grabPart = child:FindFirstChild("GrabPart")
            if grabPart then
                local weld = grabPart:FindFirstChild("WeldConstraint")
                if weld and weld.Part1 == part then
                    return true
                end
            end
        end
    end
    return false
end

local function clearForces(part)
    if not part or not part.Parent then return end
    if followingItems[part] or teleportingItems[part] or rapidFlingItems[part] then return end
    spinningItems[part] = nil
    activeForces[part] = nil
    boomerangItems[part] = nil
    frozenItems[part] = nil -- Clear freeze
    if touchedConnections[part] then
        pcall(function() touchedConnections[part]:Disconnect() end)
        touchedConnections[part] = nil
    end
    for _, child in ipairs(part:GetChildren()) do
        if child:IsA("BodyVelocity") or child:IsA("BodyForce") or
           child:IsA("BodyAngularVelocity") or child:IsA("BodyGyro") or
           child:IsA("BodyPosition") then
            pcall(function() child:Destroy() end)
        end
    end
end

-- ========== FREEZE FUNCTIONS ==========
local function freezeItem(part)
    if not part or not part.Parent then return end
    if frozenItems[part] then return end
    
    frozenItems[part] = true
    
    -- Stop all movement
    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    
    -- Create BodyPosition to hold in place
    local bp = Instance.new("BodyPosition")
    bp.D = 1000
    bp.P = 100000
    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bp.Parent = part
    bp.Position = part.Position
    
    -- Also add BodyGyro to prevent rotation
    local bg = Instance.new("BodyGyro")
    bg.D = 1000
    bg.P = 100000
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.Parent = part
    bg.CFrame = part.CFrame
    
    -- Store references to clean up later
    part:SetAttribute("FreezeBP", bp)
    part:SetAttribute("FreezeBG", bg)
    
    -- Touch detection to remove freeze when clicked
    if touchedConnections[part] then
        touchedConnections[part]:Disconnect()
    end
    touchedConnections[part] = part.Touched:Connect(function(hit)
        if hit and hit.Parent then
            -- Check if a player touched it
            local humanoid = hit.Parent:FindFirstChild("Humanoid")
            if humanoid then
                -- Remove freeze effect
                unfreezeItem(part)
            end
        end
    end)
end

local function unfreezeItem(part)
    if not part then return end
    frozenItems[part] = nil
    
    -- Remove BodyPosition
    local bp = part:FindFirstChild("BodyPosition")
    if bp then pcall(function() bp:Destroy() end) end
    
    -- Remove BodyGyro
    local bg = part:FindFirstChild("BodyGyro")
    if bg then pcall(function() bg:Destroy() end) end
    
    -- Clear attributes
    part:SetAttribute("FreezeBP", nil)
    part:SetAttribute("FreezeBG", nil)
    
    -- Remove touch connection
    if touchedConnections[part] then
        pcall(function() touchedConnections[part]:Disconnect() end)
        touchedConnections[part] = nil
    end
end

local function unfreezeAll()
    for part, _ in pairs(frozenItems) do
        unfreezeItem(part)
    end
    frozenItems = {}
end

-- ========== STOP FOLLOWING ==========
local function stopFollowing(part)
    if part then
        followingItems[part] = nil
        if followBodyPositions[part] then
            pcall(function() followBodyPositions[part]:Destroy() end)
            followBodyPositions[part] = nil
        end
    else
        for p, _ in pairs(followingItems) do
            stopFollowing(p)
        end
    end
end

local function stopTeleporting(part)
    if part then
        if part:FindFirstChild("TeleportBP") then
            pcall(function() part.TeleportBP:Destroy() end)
        end
        if part:FindFirstChild("OrbitBP") then
            pcall(function() part.OrbitBP:Destroy() end)
        end
        teleportingItems[part] = nil
        for i, p in ipairs(allGrabbedParts) do
            if p == part then
                table.remove(allGrabbedParts, i)
                break
            end
        end
    else
        for p, _ in pairs(teleportingItems) do
            if p:FindFirstChild("TeleportBP") then
                pcall(function() p.TeleportBP:Destroy() end)
            end
            if p:FindFirstChild("OrbitBP") then
                pcall(function() p.OrbitBP:Destroy() end)
            end
            teleportingItems[p] = nil
        end
        allGrabbedParts = {}
    end
end

local function stopRapidFling(part)
    if part then
        rapidFlingItems[part] = nil
        if part:FindFirstChild("FlingBP") then
            pcall(function() part.FlingBP:Destroy() end)
        end
    else
        for p, _ in pairs(rapidFlingItems) do
            if p:FindFirstChild("FlingBP") then
                pcall(function() p.FlingBP:Destroy() end)
            end
            rapidFlingItems[p] = nil
        end
    end
end

local function deleteAllItems()
    for _, part in ipairs(allGrabbedParts) do
        if part and part:IsDescendantOf(Workspace) then
            pcall(function() part:Destroy() end)
        end
    end
    allGrabbedParts = {}
    for _, part in pairs(spawnedItems) do
        if part and part:IsDescendantOf(Workspace) then
            pcall(function() part:Destroy() end)
        end
    end
    spawnedItems = {}
    stopRapidFling()
    unfreezeAll()
end

local function isLagAttack()
    local now = tick()
    for i = #grabTimestamps, 1, -1 do
        if now - grabTimestamps[i] > 1 then
            table.remove(grabTimestamps, i)
        end
    end
    if #grabTimestamps >= maxGrabsPerSecond then
        return true
    end
    table.insert(grabTimestamps, now)
    return false
end

local function followItem(part)
    if not part or not part.Parent or not LocalPlayer.Character then return end
    if followingItems[part] then return end
    followingItems[part] = true
    local bp = Instance.new("BodyPosition")
    bp.D = 50
    bp.P = followSpeed * 20
    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bp.Parent = part
    followBodyPositions[part] = bp
    bp.Position = getFootPosition()
    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end

local selectedPlayersLabel
function updateSelectedPlayersLabel()
    local selectedNames = {}
    for name, isSelected in pairs(selectedPlayersForTeleport) do
        if isSelected then
            table.insert(selectedNames, name)
        end
    end
    if #selectedNames == 0 then
        selectedPlayersLabel:Set("Selected: None")
    else
        selectedPlayersLabel:Set("Selected: " .. table.concat(selectedNames, ", "))
    end
end

-- ========== FIND CREATURE FUNCTIONS ==========
local function GetCreature()
    local folderName = LocalPlayer.Name .. "SpawnedInToys"
    local userFolder = workspace:FindFirstChild(folderName)
    if userFolder then
        for _, obj in ipairs(userFolder:GetChildren()) do
            if obj:FindFirstChild("BlobmanSeatAndOwnerScript") then
                return obj
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "BlobmanSeatAndOwnerScript" then
            return obj.Parent
        end
    end
    return nil
end

local function FindAnyCreature()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "BlobmanSeatAndOwnerScript" then
            local parent = obj.Parent
            if parent and parent:IsA("Model") then
                return parent
            end
        end
    end
    return nil
end

-- ========== ANTI-GRAB - OPTIMIZED ==========
local function DoAntiGrab()
    if not antiGrabEnabled then return end
    if not LocalPlayer.Character then return end
    
    antiGrabCounter = antiGrabCounter + 1
    if antiGrabCounter % 3 ~= 0 then return end
    
    pcall(function()
        local characterEvents = ReplicatedStorage:FindFirstChild("CharacterEvents")
        if characterEvents then
            local struggle = characterEvents:FindFirstChild("Struggle")
            if struggle then
                struggle:FireServer()
            end
        end
    end)
    
    pcall(function()
        local character = LocalPlayer.Character
        if character then
            for _, child in pairs(Workspace:GetChildren()) do
                if child.Name == "GrabParts" then
                    local grabPart = child:FindFirstChild("GrabPart")
                    if grabPart then
                        local weld = grabPart:FindFirstChild("WeldConstraint")
                        if weld then
                            local part1 = weld.Part1
                            local part0 = weld.Part0
                            if part1 and part1:IsDescendantOf(character) or 
                               part0 and part0:IsDescendantOf(character) then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function StartAntiGrab()
    if antiGrabConnection then
        antiGrabConnection:Disconnect()
        antiGrabConnection = nil
    end
    
    antiGrabEnabled = true
    antiGrabCounter = 0
    
    antiGrabConnection = RunService.Heartbeat:Connect(function()
        DoAntiGrab()
    end)
    
    Rayfield:Notify({
        Title = "🛡️ Anti-Grab ON",
        Content = "You cannot be grabbed!",
        Duration = 3
    })
end

local function StopAntiGrab()
    if antiGrabConnection then
        antiGrabConnection:Disconnect()
        antiGrabConnection = nil
    end
    antiGrabEnabled = false
    Rayfield:Notify({
        Title = "🛡️ Anti-Grab OFF",
        Content = "Players can grab you again.",
        Duration = 3
    })
end

-- ========== SPECTATOR GRAB FUNCTIONS ==========
local function SpectatorGrab()
    if not spectatorTargetName then return end
    
    spectatorCounter = spectatorCounter + 1
    if spectatorCounter % 2 ~= 0 then return end
    
    local targetPlayer = Players:FindFirstChild(spectatorTargetName)
    if not targetPlayer then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local creature = GetCreature()
    if not creature then
        creature = FindAnyCreature()
        if not creature then 
            pcall(function()
                if LocalPlayer.Character then
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local direction = (hrp.Position - targetRoot.Position).Unit
                        targetRoot.AssemblyLinearVelocity = direction * pullStrength
                    end
                end
            end)
            return 
        end
    end
    
    local sf = creature:FindFirstChild("BlobmanSeatAndOwnerScript")
    if not sf then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
             local hrp = LocalPlayer.Character.HumanoidRootPart
                local direction = (hrp.Position - targetRoot.Position).Unit
                targetRoot.AssemblyLinearVelocity = direction * pullStrength
            end
        end)
        return
    end
    
    local grab = sf:FindFirstChild("CreatureGrab")
    local drop = sf:FindFirstChild("CreatureDrop")
    local rightDetector = creature:FindFirstChild("RightDetector")
    local leftDetector = creature:FindFirstChild("LeftDetector")
    local rightWeld = rightDetector and rightDetector:FindFirstChild("RightWeld")
    local leftWeld = leftDetector and leftDetector:FindFirstChild("LeftWeld")
    
    if not grab then return end
    
    local animations = creature:FindFirstChild("BlobmanAnimations")
    local relayAnimation = nil
    if animations then
        relayAnimation = animations:FindFirstChild("RelayClientAnimation")
    end
    
    local originalPosition = nil
    local character = LocalPlayer.Character
    
    if teleportToCreature and character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            originalPosition = hrp.CFrame
            local creatureRoot = creature:FindFirstChild("HumanoidRootPart")
            if creatureRoot then
                hrp.CFrame = creatureRoot.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.05)
            end
        end
    end
    
    if useRightHand and rightDetector and rightWeld then
        pcall(function()
            grab:FireServer(rightDetector, targetRoot, rightWeld)
            if relayAnimation then
                relayAnimation:FireServer("RightGrabAnimation", true)
            end
        end)
    end
    
    if useLeftHand and leftDetector and leftWeld then
        pcall(function()
            grab:FireServer(leftDetector, targetRoot, leftWeld)
            if relayAnimation then
                relayAnimation:FireServer("LeftGrabAnimation", true)
            end
        end)
    end
    
        if targetRoot and character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local targetPos = originalPosition and originalPosition.Position or hrp.Position
            local direction = (targetPos - targetRoot.Position)
            local distance = direction.Magnitude
            
            local pullForce = math.min(pullStrength * 1.5, distance * 2)
            if distance > 1 then
                local velocity = direction.Unit * pullForce
                targetRoot.AssemblyLinearVelocity = velocity
            end
        end
    end
    
    task.wait(0.001)
    
    if drop then
        pcall(function()
            if rightWeld then drop:FireServer(rightWeld) end
            if leftWeld then drop:FireServer(leftWeld) end
        end)
    end
    
    if teleportToCreature and character and originalPosition then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = originalPosition
        end
    end
end

local function StartSpectatorGrab()
    if spectatorConnection then
        spectatorConnection:Disconnect()
        spectatorConnection = nil
    end
    
    if not spectatorTargetName then
        Rayfield:Notify({
            Title = "❌ Error",
            Content = "Select a target first!",
            Duration = 3
        })
        return false
    end
    
    spectatorGrabEnabled = true
    spectatorCounter = 0
    spectatorConnection = RunService.Heartbeat:Connect(function()
        SpectatorGrab()
    end)
    
    Rayfield:Notify({
        Title = "🚀 Spectator Grab STARTED",
        Content = "Grabbing: " .. spectatorTargetName,
        Duration = 3
    })
    return true
end

local function StopSpectatorGrab()
    if spectatorConnection then
        spectatorConnection:Disconnect()
        spectatorConnection = nil
    end
    spectatorGrabEnabled = false
end

-- ========== STOP EVERYTHING) ==========
local function StopEverything()
    pcall(function()
        -- Stop spawner
        spawnerEnabled = false
        if spawnConnection then
            spawnConnection:Disconnect()
            spawnConnection = nil
        end
        if spawnerStatusLabel then
            pcall(function() spawnerStatusLabel:Set("Status: Stopped") end)
        end
        
        -- Stop spectator grab
        if spectatorConnection then
            spectatorConnection:Disconnect()
            spectatorConnection = nil
        end
        spectatorGrabEnabled = false
        
        -- Stop teleporting items
        for part, _ in pairs(teleportingItems) do
            if part and part.Parent then
                if part:FindFirstChild("TeleportBP") then
                    pcall(function() part.TeleportBP:Destroy() end)
                end
                if part:FindFirstChild("OrbitBP") then
                    pcall(function() part.OrbitBP:Destroy() end)
                end
                pcall(function()
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end
        teleportingItems = {}
        
        -- Stop rapid fling items
        for part, _ in pairs(rapidFlingItems) do
            if part and part.Parent then
                if part:FindFirstChild("FlingBP") then
                    pcall(function() part.FlingBP:Destroy() end)
                end
                pcall(function()
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end
        rapidFlingItems = {}
        
        -- Stop following items
        for part, bp in pairs(followBodyPositions) do
            if bp then
                pcall(function() bp:Destroy() end)
            end
        end
        followingItems = {}
        followBodyPositions = {}
        
        -- Unfreeze all items
        for part, _ in pairs(frozenItems) do
            if part then
                local bp = part:FindFirstChild("BodyPosition")
                if bp then pcall(function() bp:Destroy() end) end
                local bg = part:FindFirstChild("BodyGyro")
                if bg then pcall(function() bg:Destroy() end) end
                part:SetAttribute("FreezeBP", nil)
                part:SetAttribute("FreezeBG", nil)
                pcall(function()
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end
        frozenItems = {}
        
        -- Clear all active forces
        for part, _ in pairs(activeForces) do
            if part and part.Parent then
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("BodyVelocity") or child:IsA("BodyForce") or
                       child:IsA("BodyAngularVelocity") or child:IsA("BodyGyro") or
                       child:IsA("BodyPosition") then
                        pcall(function() child:Destroy() end)
                    end
                end
                pcall(function()
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end
        activeForces = {}
        
        -- Clear spinning items
        for part, _ in pairs(spinningItems) do
            if part and part.Parent then
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("BodyAngularVelocity") then
                        pcall(function() child:Destroy() end)
                    end
                end
                pcall(function()
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end
        spinningItems = {}
        
        -- Clear boomerang items
        for part, _ in pairs(boomerangItems) do
            if part and part.Parent then
                if touchedConnections[part] then
                    pcall(function() touchedConnections[part]:Disconnect() end)
                    touchedConnections[part] = nil
                end
                pcall(function()
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end
        boomerangItems = {}
        
        -- Clear all grabbed parts
        for _, part in ipairs(allGrabbedParts) do
            if part and part:IsDescendantOf(Workspace) then
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("BodyVelocity") or child:IsA("BodyForce") or
                       child:IsA("BodyAngularVelocity") or child:IsA("BodyGyro") or
                       child:IsA("BodyPosition") then
                        pcall(function() child:Destroy() end)
                    end
                end
                pcall(function()
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end
        
        -- Delete all grabbed items
        for _, part in ipairs(allGrabbedParts) do
            if part and part:IsDescendantOf(Workspace) then
                pcall(function() part:Destroy() end)
            end
        end
        allGrabbedParts = {}
        
        -- Delete spawned items
        for _, part in pairs(spawnedItems) do
            if part and part:IsDescendantOf(Workspace) then
                pcall(function() part:Destroy() end)
            end
        end
        spawnedItems = {}
        
        -- Clear tracking tables
        grabPartsToItems = {}
        
        -- Reset spectator target label
        if spectatorTargetLabel then
            pcall(function() spectatorTargetLabel:Set("Target: None") end)
        end
        
        -- Clear any leftover touch connections
        for part, conn in pairs(touchedConnections) do
            pcall(function() conn:Disconnect() end)
        end
        touchedConnections = {}
        
        Rayfield:Notify({
            Title = "✅ ITEMS STOPPED",
            Content = "All grabbed items/players stopped. Toggles still ON!",
            Duration = 4
        })
    end)
end  

-- ========== CREATE WINDOW ==========
local Window = Rayfield:CreateWindow({
    Name = "Fling in People | (green8333💥)",
    LoadingTitle = "Full Menu - ALL FEATURES",
    LoadingSubtitle = "by green8333 - 0.6-script",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
    Theme = "Green"
})

-- TABS
local GameTab = Window:CreateTab("🎮 Game", 4483362458)
local BoomerangTab = Window:CreateTab("🪃 Boomerang", 4483362458)
local FollowTab = Window:CreateTab("🐕 Item Follow", 4483362458)
local TeleportTab = Window:CreateTab("📍 Teleport", 4483362458)
local SpawnerTab = Window:CreateTab("📦 Item Spawner", 4483362458)
local SpectatorTab = Window:CreateTab("👻 Kick Players Auto", 4483362458)
local FreezeTab = Window:CreateTab("❄️ Freeze", 4483362458)

-- ========== GAME TAB ==========
local flingToggle = GameTab:CreateToggle({
    Name = "🔥 Enable Fling",
    CurrentValue = false,
    Callback = function(Value) flingEnabled = Value end,
})

GameTab:CreateSlider({
    Name = "💥 Fling Power (0-500)",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = 25,
    Callback = function(Value) flingStrength = Value end,
})

local gravityToggle = GameTab:CreateToggle({
    Name = "🪨 Gravity (Sends in Air)",
    CurrentValue = false,
    Callback = function(Value) gravityEnabled = Value end,
})

GameTab:CreateSlider({
    Name = "⬆️ Gravity Force",
    Range = {0, 10000},
    Increment = 500,
    CurrentValue = 0,
    Callback = function(Value) gravityForce = Value end,
})

local zeroGravityToggle = GameTab:CreateToggle({
    Name = "🪐 Zero-Gravity (Float While Held)",
    CurrentValue = false,
    Callback = function(Value) zeroGravityEnabled = Value end,
})

GameTab:CreateSlider({
    Name = "⬆️ Zero-Gravity Force",
    Range = {0, 100000},
    Increment = 5000,
    CurrentValue = 0,
    Callback = function(Value) zeroGravityForce = Value end,
})

local spinToggle = GameTab:CreateToggle({
    Name = "🌀 Enable Spin",
    CurrentValue = false,
    Callback = function(Value) spinEnabled = Value end,
})

GameTab:CreateSlider({
    Name = "🌀 Spin Speed (Max 500)",
    Range = {1, 500},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value) spinSpeed = Value end,
})

local antiGrabToggle = GameTab:CreateToggle({
    Name = "🛡️ Anti-Grab Protection",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            StartAntiGrab()
        else
            StopAntiGrab()
        end
    end
})

GameTab:CreateButton({
    Name = "🛑 STOP EVERYTHING",
    Callback = function()
        StopEverything()
    end
})

-- ========== BOOMERANG TAB ==========
local boomerangToggle = BoomerangTab:CreateToggle({
    Name = "🔄 Enable Boomerang",
    CurrentValue = false,
    Callback = function(Value) boomerangEnabled = Value end,
})

BoomerangTab:CreateSlider({
    Name = "⏳ Return Time (Seconds)",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(Value) boomerangReturnTime = Value end,
})

BoomerangTab:CreateSlider({
    Name = "📈 Throw Strength",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(Value) boomerangThrowStrength = Value end,
})

BoomerangTab:CreateSlider({
    Name = "📈 Arc Height",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(Value) boomerangArcHeight = Value end,
})

-- ========== FOLLOW TAB ==========
local followToggle = FollowTab:CreateToggle({
    Name = "🐕 Enable Item Follow (ON/OFF)",
    CurrentValue = false,
    Callback = function(Value)
        followEnabled = Value
        if not Value then
            stopFollowing()
        end
    end,
})

FollowTab:CreateSlider({
    Name = "🐢 Follow Speed (0-100)",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        followSpeed = Value
        for part, bp in pairs(followBodyPositions) do
            bp.P = followSpeed * 20
        end
    end,
})

-- ========== TELEPORT TAB ==========
selectedPlayersLabel = TeleportTab:CreateLabel("Selected: None")

local teleportToggle = TeleportTab:CreateToggle({
    Name = "📍 Enable Smooth Teleport",
    CurrentValue = false,
    Callback = function(V) teleportEnabled = V end
})

TeleportTab:CreateToggle({
    Name = "🌀 Orbit Around Player",
    CurrentValue = false,
    Callback = function(V) orbitEnabled = V end
})

TeleportTab:CreateSlider({
    Name = "📐 Orbit Radius (5-50)",
    Range = {5, 50},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(V) orbitRadius = V end
})

TeleportTab:CreateSlider({
    Name = "🌀 Orbit Speed (1-20)",
    Range = {1, 20},
    Increment = 0.5,
    CurrentValue = 5,
    Callback = function(V) orbitSpeed = V end
})

TeleportTab:CreateSlider({
    Name = "⚡ Teleport Speed (10-200)",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(V) teleportSpeed = V end
})

TeleportTab:CreateSlider({
    Name = "⏳ Cycle Time (Seconds)",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(V) teleportCycleTime = V end
})

local rapidFlingToggle = TeleportTab:CreateToggle({
    Name = "🚀 Enable Rapid Fling Teleport",
    CurrentValue = false,
    Callback = function(Value) rapidFlingEnabled = Value end
})

TeleportTab:CreateSlider({
    Name = "⚡ Rapid Fling Speed (Max 900)",
    Range = {1, 900},
    Increment = 10,
    CurrentValue = 500,
    Callback = function(Value) rapidFlingSpeed = Value end
})

local playerSelectionDropdown = TeleportTab:CreateDropdown({
    Name = "👥 Select Players",
    Options = {LocalPlayer.Name},
    CurrentOption = {},
    Multi = true,
    Callback = function(options)
        selectedPlayersForTeleport = {}
        for _, option in ipairs(options) do
            selectedPlayersForTeleport[option] = true
        end
        updateSelectedPlayersLabel()
    end
})

local rapidFlingDropdown = TeleportTab:CreateDropdown({
    Name = "👥 Select Player for Fling",
    Options = {LocalPlayer.Name},
    CurrentOption = {},
    Multi = false,
    Callback = function(option)
        selectedPlayersForRapidFling = {}
        if #option > 0 then
            selectedPlayersForRapidFling[option[1]] = true
        end
    end
})

TeleportTab:CreateButton({
    Name = "🛑 Stop Teleporting Items",
    Callback = function()
        stopTeleporting()
        stopRapidFling()
        Rayfield:Notify({
            Title = "✅ Stopped",
            Content = "All teleport & fling stopped.",
            Duration = 3
        })
    end
})

-- ========== SPECTATOR GRAB TAB ==========
local spectatorTargetLabel = SpectatorTab:CreateLabel("Target: None")

local spectatorPlayerDropdown = SpectatorTab:CreateDropdown({
    Name = "👥 Select Player to Grab",
    Options = {LocalPlayer.Name},
    CurrentOption = {},
    Multi = false,
    Callback = function(option)
        if #option > 0 then
            local playerName = option[1]
            spectatorTargetName = playerName
            spectatorTargetLabel:Set("Target: " .. playerName)
            Rayfield:Notify({
                Title = "✅ Target Set",
                Content = "Now targeting: " .. playerName,
                Duration = 2
            })
        else
            spectatorTargetName = nil
            spectatorTargetLabel:Set("Target: None")
        end
    end
})

local spectatorToggle = SpectatorTab:CreateToggle({
    Name = "⚡ AUTO Blobman CLICK",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            if not spectatorTargetName then
                Rayfield:Notify({
                    Title = "❌ Error",
                    Content = "Select a target first!",
                    Duration = 3
                })
                return
            end
            local success = StartSpectatorGrab()
            if success then
                Rayfield:Notify({
                    Title = "🚀 Spectator Grab STARTED",
                    Content = "Grabbing: " .. spectatorTargetName,
                    Duration = 3
                })
            end
        else
            StopSpectatorGrab()
            Rayfield:Notify({
                Title = "⛔ Spectator Grab STOPPED",
                Content = "Spectator grab stopped.",
                Duration = 2
            })
        end
    end
})

SpectatorTab:CreateToggle({
    Name = "🖐️ Use Right Hand",
    CurrentValue = true,
    Callback = function(Value) useRightHand = Value end
})

SpectatorTab:CreateToggle({
    Name = "🖐️ Use Left Hand",
    CurrentValue = true,
    Callback = function(Value) useLeftHand = Value end
})

SpectatorTab:CreateSlider({
    Name = "💪 Pull Strength",
    Range = {1, 300},
    Increment = 1,
    CurrentValue = 80,
    Callback = function(Value) pullStrength = Value end
})

SpectatorTab:CreateToggle({
    Name = "🔄 Teleport Character to Blobman",
    CurrentValue = true,
    Callback = function(Value) teleportToCreature = Value end
})

SpectatorTab:CreateButton({
    Name = "👊 GRAB ONCE",
    Callback = function()
        if not spectatorTargetName then
            Rayfield:Notify({
                Title = "❌ Error",
                Content = "Select a target first!",
                Duration = 3
            })
            return
        end
        SpectatorGrab()
        Rayfield:Notify({
            Title = "👊 Grab Executed",
            Content = "Grabbed: " .. spectatorTargetName,
            Duration = 2
        })
    end
})

SpectatorTab:CreateButton({
    Name = "🛑 STOP SPECTATOR GRAB",
    Callback = function()
        StopSpectatorGrab()
        Rayfield:Notify({
            Title = "✅ Stopped",
            Content = "Spectator grab stopped.",
            Duration = 2
        })
    end
})

-- ========== FREEZE TAB ==========
local freezeToggle = FreezeTab:CreateToggle({
    Name = "❄️ Enable Freeze",
    CurrentValue = false,
    Callback = function(Value)
        freezeEnabled = Value
        if not Value then
            unfreezeAll()
        end
    end
})

FreezeTab:CreateToggle({
    Name = "🧊 Freeze Items",
    CurrentValue = false,
    Callback = function(Value)
        freezeItems = Value
        if freezeEnabled and Value then
            for _, part in ipairs(allGrabbedParts) do
                if part and part:IsDescendantOf(Workspace) then
                    if not part.Parent:FindFirstChild("Humanoid") then
                        freezeItem(part)
                    end
                end
            end
        end
    end
})

FreezeTab:CreateToggle({
    Name = "🧊 Freeze Players",
    CurrentValue = false,
    Callback = function(Value)
        freezePlayers = Value
        if freezeEnabled and Value then
            for _, part in ipairs(allGrabbedParts) do
                if part and part:IsDescendantOf(Workspace) then
                    if part.Parent:FindFirstChild("Humanoid") then
                        freezeItem(part)
                    end
                end
            end
        end
    end
})

FreezeTab:CreateButton({
    Name = "🔥 Unfreeze All",
    Callback = function()
        unfreezeAll()
        Rayfield:Notify({
            Title = "✅ Unfrozen",
            Content = "All items/players unfrozen.",
            Duration = 2
        })
    end
})

FreezeTab:CreateButton({
    Name = "🧊 Freeze All Grabbed",
    Callback = function()
        if not freezeEnabled then
            Rayfield:Notify({
                Title = "❌ Error",
                Content = "Enable Freeze first!",
                Duration = 2
            })
            return
        end
        for _, part in ipairs(allGrabbedParts) do
            if part and part:IsDescendantOf(Workspace) then
                freezeItem(part)
            end
        end
        Rayfield:Notify({
            Title = "🧊 Frozen",
            Content = "All grabbed items/players frozen.",
            Duration = 2
        })
    end
})

-- ========== SPAWNER TAB ==========
local spawnerStatusLabel = SpawnerTab:CreateLabel("Status: Ready - Select an item")

local toyDropdown = SpawnerTab:CreateDropdown({
    Name = "🎯 Select Item",
    Options = toyDisplayNames,
    CurrentOption = {},
    Multi = false,
    Callback = function(option)
        if #option > 0 then
            selectedToy = option[1]
            selectedToyRealName = toyNameMap[selectedToy]
            print("Selected: " .. selectedToy .. " | Internal: " .. selectedToyRealName)
            spawnerStatusLabel:Set("Status: Selected - " .. selectedToy)
        end
    end
})

local spawnerToggle = SpawnerTab:CreateToggle({
    Name = "✅ Enable Spawner",
    CurrentValue = false,
    Callback = function(Value)
        spawnerEnabled = Value
        if Value then
            if not selectedToyRealName then
                Rayfield:Notify({Title = "❌ Error", Content = "Select an item first!", Duration = 3})
                spawnerToggle:Set(false)
                return
            end
            startSpawning()
        else
            stopSpawning()
        end
    end
})

SpawnerTab:CreateSlider({
    Name = "⬆️ Spawn Height (0-500)",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(Value) spawnHeight = Value end
})

SpawnerTab:CreateSlider({
    Name = "📏 Spawn Distance (1-500)",
    Range = {1, 500},
    Increment = 1,
    CurrentValue = 20,
    Callback = function(Value) spawnDistance = Value end
})

SpawnerTab:CreateToggle({
    Name = "🎠 Circle Spawn",
    CurrentValue = false,
    Callback = function(Value) useCircleSpawn = Value end
})

SpawnerTab:CreateSlider({
    Name = "📐 Circle Radius (5-100)",
    Range = {5, 100},
    Increment = 1,
    CurrentValue = 20,
    Callback = function(Value) circleRadius = Value end
})
 
SpawnerTab:CreateButton({
    Name = "🎯 Click to Set Location",
    Callback = function()
        Rayfield:Notify({
            Title = "🎯 Click a Location",
            Content = "Click ANYWHERE. Items will spawn EXACTLY there.",
            Duration = 5
        })
        local mouse = LocalPlayer:GetMouse()
        local connection
        connection = mouse.Button1Down:Connect(function()
            connection:Disconnect()
            local ray = Ray.new(Camera.CFrame.Position, mouse.UnitRay.Direction * 100000)
            local ignoreList = {LocalPlayer.Character, Camera}
            local hit, hitPosition = Workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
            if hit then
                clickedLocation = hitPosition
                Rayfield:Notify({
                    Title = "✅ Location Set",
                    Content = "X=" .. math.floor(clickedLocation.X) .. ", Y=" .. math.floor(clickedLocation.Y) .. ", Z=" .. math.floor(clickedLocation.Z),
                    Duration = 5
                })
            else
                Rayfield:Notify({Title = "❌ No Surface", Content = "Click on a surface.", Duration = 3})
            end
        end)
    end
})

SpawnerTab:CreateButton({
    Name = "🗑️ Clear Location",
    Callback = function()
        clickedLocation = nil
        Rayfield:Notify({Title = "✅ Location Cleared", Content = "Items will spawn at camera/player.", Duration = 3})
    end
})

SpawnerTab:CreateSlider({
    Name = "⚡ Spawn Speed (0.01-1s)",
    Range = {0.01, 1},
    Increment = 0.01,
    CurrentValue = 0.05,
    Callback = function(Value) spawnSpeed = Value end
})

SpawnerTab:CreateToggle({
    Name = "🎯 Spawn at Camera",
    CurrentValue = true,
    Callback = function(Value) spawnAtCamera = Value end
})

SpawnerTab:CreateButton({
    Name = "🛑 STOP SPAWNING",
    Callback = function()
        stopSpawning()
        spawnerStatusLabel:Set("Status: Stopped")
    end
})

SpawnerTab:CreateButton({
    Name = "🗑️ DELETE ALL ITEMS",
    Callback = function() deleteAllItems() end
})

-- ========== SPAWNER FUNCTIONS ==========
function startSpawning()
    if spawnConnection then spawnConnection:Disconnect() end
    spawnerStatusLabel:Set("Status: Spawning " .. selectedToy)
    local spawnTimer = 0
    spawnConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not spawnerEnabled or not selectedToyRealName then return end
        
        spawnTimer = spawnTimer + deltaTime
        if spawnTimer < spawnSpeed then return end
        spawnTimer = 0

        local spawnCFrame
        if clickedLocation then
            if useCircleSpawn then
                circleAngle = (circleAngle + 0.1) % (2 * math.pi)
                local x = math.cos(circleAngle) * circleRadius
                local z = math.sin(circleAngle) * circleRadius
                spawnCFrame = CFrame.new(
                    clickedLocation.X + x,
                    clickedLocation.Y + spawnHeight,
                    clickedLocation.Z + z
                )
            else
                spawnCFrame = CFrame.new(clickedLocation.X, clickedLocation.Y + spawnHeight, clickedLocation.Z)
            end
        else
            local center
            if spawnAtCamera then
                center = Camera.CFrame.Position
            else
                center = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                         LocalPlayer.Character.HumanoidRootPart.Position or Camera.CFrame.Position)
            end

            if useCircleSpawn then
                circleAngle = (circleAngle + 0.1) % (2 * math.pi)
                local x = math.cos(circleAngle) * circleRadius
                local z = math.sin(circleAngle) * circleRadius
                spawnCFrame = CFrame.new(center.X + x, center.Y + spawnHeight, center.Z + z)
            else
                spawnCFrame = CFrame.new(center.X, center.Y + spawnHeight, center.Z - spawnDistance)
            end
        end

        local success, result = pcall(function()
            local newItem = SpawnToyRemote:InvokeServer(selectedToyRealName, spawnCFrame, Vector3.new(0, 0, 0))
            if newItem then
                table.insert(spawnedItems, newItem)
                newItem.Transparency = 0
            end
            return newItem
        end)
        if not success then warn("Spawn failed: " .. tostring(result)) end
    end)
end

function stopSpawning()
    spawnerEnabled = false
    if spawnConnection then
        spawnConnection:Disconnect()
        spawnConnection = nil
    end
    spawnerStatusLabel:Set("Status: Stopped")
end

-- ========== PLAYER LIST REFRESH ==========
task.spawn(function()
    while task.wait(3) do
        local names = {LocalPlayer.Name}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        playerSelectionDropdown:Refresh(names)
        rapidFlingDropdown:Refresh(names)
        spectatorPlayerDropdown:Refresh(names)
    end
end)

-- ========== CORE LOGIC ==========
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "GrabParts" then
        if antiLagEnabled and isLagAttack() then
            task.wait()
            child:Destroy()
            return
        end

        local success, grabbedPart = pcall(function()
            local grabPart = child:WaitForChild("GrabPart")
            local weld = grabPart:WaitForChild("WeldConstraint")
            return weld.Part1
        end)

        if not success or not grabbedPart or not isValidItem(grabbedPart) then
            return
        end

        grabPartsToItems[child] = grabbedPart
table.insert(allGrabbedParts, grabbedPart)

if teleportEnabled and next(selectedPlayersForTeleport) then
    teleportingItems[grabbedPart] = {
        lastCycle = tick(),
        currentIndex = 1,
        orbitAngle = 0
    }
end

if followingItems[grabbedPart] then
    stopFollowing(grabbedPart)
end

local isPlayer = grabbedPart.Parent and grabbedPart.Parent:FindFirstChild("Humanoid")
if not isPlayer then
    clearForces(grabbedPart)
    grabbedPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    grabbedPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
end
        if zeroGravityEnabled then
            local bodyForce = Instance.new("BodyForce")
            bodyForce.Name = "ZeroGravityForce"
            bodyForce.Parent = grabbedPart
            bodyForce.Force = Vector3.new(0, zeroGravityForce, 0)
            activeForces[grabbedPart] = true
        end
        
        child.AncestryChanged:Connect(function()
            if not child:IsDescendantOf(Workspace) then
                local grabbedPart = grabPartsToItems[child]
                if not grabbedPart then return end
                
local isPlayer = grabbedPart.Parent and grabbedPart.Parent:FindFirstChild("Humanoid")
if not isPlayer then
    clearForces(grabbedPart)
end

if followEnabled and grabbedPart then
    followItem(grabbedPart)
end

                if grabbedPart and followingItems[grabbedPart] then
                    return
                end

                if freezeEnabled then
                    local isPlayer = grabbedPart.Parent and grabbedPart.Parent:FindFirstChild("Humanoid")
                    if freezeItems and not isPlayer then
                        freezeItem(grabbedPart)
                        return
                    elseif freezePlayers and isPlayer then
                        freezeItem(grabbedPart)
                        return
                    end
                end

                if flingEnabled then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bv.Velocity = Camera.CFrame.LookVector * (flingStrength * 5)
                    bv.Parent = grabbedPart
                    activeForces[grabbedPart] = true
                end

                if gravityEnabled then
                    local bf = Instance.new("BodyForce")
                    bf.Force = Vector3.new(0, gravityForce, 0)
                    bf.Parent = grabbedPart
                    activeForces[grabbedPart] = true
                end

                if spinEnabled then
                    local av = Instance.new("BodyAngularVelocity")
                    av.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    av.AngularVelocity = Vector3.new(0, spinSpeed, 0)
                    av.Parent = grabbedPart
                    spinningItems[grabbedPart] = spinSpeed
                    activeForces[grabbedPart] = true
                end

                if boomerangEnabled then
                    local lookDir = Camera.CFrame.LookVector
                    grabbedPart.AssemblyLinearVelocity = lookDir * boomerangThrowStrength + Vector3.new(0, boomerangArcHeight * 0.5, 0)
                    if touchedConnections[grabbedPart] then
                        touchedConnections[grabbedPart]:Disconnect()
                    end
                    touchedConnections[grabbedPart] = grabbedPart.Touched:Connect(function(hit)
                        if hit and hit.Parent and LocalPlayer.Character and hit:IsDescendantOf(LocalPlayer.Character) then
                            clearForces(grabbedPart)
                        end
                    end)
                    boomerangItems[grabbedPart] = { elapsed = 0 }
                end

                if rapidFlingEnabled then
                    local targetName = next(selectedPlayersForRapidFling)
                    if targetName then
                        local targetPlayer = Players:FindFirstChild(targetName)
                        if targetPlayer then
                            rapidFlingItems[grabbedPart] = targetPlayer
                        end
                    end
                end
            end
        end)
    end
end)

-- ========== MAIN LOOP ==========
RunService.Heartbeat:Connect(function(deltaTime)
    tickCounter = tickCounter + 1
    
    if tickCounter % 2 == 0 then
        for part, _ in pairs(spinningItems) do
            if part and part.Parent then
                part.AssemblyAngularVelocity = Vector3.new(0, spinSpeed, 0)
            else
                spinningItems[part] = nil
            end
        end

        for part, data in pairs(boomerangItems) do
            if not part or not part.Parent then
                boomerangItems[part] = nil
            else
                data.elapsed = (data.elapsed or 0) + deltaTime
                if data.elapsed >= boomerangReturnTime then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = LocalPlayer.Character.HumanoidRootPart.Position
                        local direction = (targetPos - part.Position).Unit
                        part.AssemblyLinearVelocity = direction * 80 + Vector3.new(0, boomerangArcHeight * 0.3, 0)
                    end
                end
            end
        end

        if LocalPlayer.Character then
            local footPos = getFootPosition()
            for part, bp in pairs(followBodyPositions) do
                if part and part.Parent and bp then
                    bp.Position = footPos
                end
            end
        end

        local currentTime = tick()
        for part, data in pairs(teleportingItems) do
            if part and part.Parent and not isPartBeingHeld(part) then
                local selectedPlayers = {}
                for name, isSelected in pairs(selectedPlayersForTeleport) do
                    local player = Players:FindFirstChild(name)
                    if isSelected and player then table.insert(selectedPlayers, player) end
                end

                if #selectedPlayers == 0 then
                    stopTeleporting(part)
                else
                    if currentTime - (data.lastCycle or 0) >= teleportCycleTime then
                        data.currentIndex = (data.currentIndex or 1) + 1
                        if data.currentIndex > #selectedPlayers then data.currentIndex = 1 end
                        data.lastCycle = currentTime
                    end

                    local targetPlayer = selectedPlayers[data.currentIndex or 1]
                    if targetPlayer and targetPlayer.Character then
                        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetHRP then
                            if orbitEnabled then
                                data.orbitAngle = (data.orbitAngle or 0) + deltaTime * orbitSpeed
                                local offsetX = math.cos(data.orbitAngle) * orbitRadius
                                local offsetZ = math.sin(data.orbitAngle) * orbitRadius
                                local orbitPos = Vector3.new(targetHRP.Position.X + offsetX, targetHRP.Position.Y, targetHRP.Position.Z + offsetZ)
                                local bp = part:FindFirstChild("OrbitBP") or Instance.new("BodyPosition")
                                bp.Name = "OrbitBP"
                                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                bp.P = teleportSpeed * 500
                                bp.D = 50
                                bp.Position = orbitPos
                                bp.Parent = part
                            else
                                local targetPos = getPlayerFeetPosition(targetPlayer)
                                if targetPos then
                                    local bp = part:FindFirstChild("TeleportBP") or Instance.new("BodyPosition")
                                    bp.Name = "TeleportBP"
                                    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    bp.P = teleportSpeed * 500
                                    bp.Position = targetPos
                                    bp.Parent = part
                                end
                            end
                        end
                    end
                end
            end
        end

        if tickCounter % 4 == 0 then
            for part, targetPlayer in pairs(rapidFlingItems) do
                if part and part.Parent and targetPlayer and targetPlayer.Character and not isPartBeingHeld(part) then
                    local targetPos = getPlayerTorsoPosition(targetPlayer)
                    if targetPos then
                        local phase = tick() * (rapidFlingSpeed / 50)
                        local offsetY = math.sin(phase * 25) * 15
                        local flingPos = targetPos + Vector3.new(0, offsetY + 4, 0)

                        local bp = part:FindFirstChild("FlingBP") or Instance.new("BodyPosition")
                        bp.Name = "FlingBP"
                        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bp.P = rapidFlingSpeed * 35
                        bp.D = 5
                        bp.Position = flingPos
                        bp.Parent = part

                        part.AssemblyLinearVelocity = Vector3.new(0, rapidFlingSpeed * 2.5, 0)
                    end
                end
            end
        end
    end
end)

-- Click to Fling Players Up
local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if zeroGravityEnabled then
        local target = mouse.Target
        if target and target.Parent then
            local char = target.Parent
            if char:FindFirstChild("Humanoid") then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, zeroGravityForce / 10, 0)
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bv.Velocity = Vector3.new(0, zeroGravityForce / 5, 0)
                    bv.Parent = hrp
                    game:GetService("Debris"):AddItem(bv, 0.5)
                end
            end
        end
    end
end)

print("✅ Everything works good! Try it out!")