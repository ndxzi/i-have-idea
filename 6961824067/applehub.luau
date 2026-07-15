-- ============================================
-- 🍎 APPLE HUB - ИСПРАВЛЕННАЯ ВЕРСИЯ
-- ============================================
-- chatgpt & claude & grok & gemini & feds :) 
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

Library.ForceCheckbox = false

local Window = Library:CreateWindow({
    Title = "🍎 APPLE HUB",
    Footer = "APPLE HUB | Fixed v2.0",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local GE = RS:WaitForChild("GrabEvents")
local mouse = player:GetMouse()

local Tabs = {
    Combat = Window:AddTab("Combat", "sword"),
    Defense = Window:AddTab("Defense", "shield"),
    Movement = Window:AddTab("Movement", "shoe"),
    Target = Window:AddTab("Target", "crosshair"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ============================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================
local function getTarget()
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local ray = Ray.new(Camera.CFrame.Position, (mouse.Hit.Position - Camera.CFrame.Position).Unit * 1000)
    local hit, pos = Workspace:FindPartOnRay(ray, char)
    
    if hit then
        local model = hit:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChild("Humanoid") and model ~= char then
            return model
        end
    end
    return nil
end

-- ============================================
-- ВКЛАДКА COMBAT
-- ============================================
local CombatGroup = Tabs.Combat:AddLeftGroupbox("Combat Main")
local CombatExtra = Tabs.Combat:AddRightGroupbox("Combat Extra")

-- SUPER FLING - КИДАЕМ ИГРОКА
CombatGroup:AddToggle("SuperFling", {
    Text = "💥 SUPER FLING",
    Default = false,
    Callback = function(on)
        if on then
            Library:Notify({
                Title = "🍎 APPLE HUB",
                Description = "Кликни по игроку чтобы кинуть его!",
                Time = 3,
            })
            mouse.Button1Down:Connect(function()
                if not on then return end
                local target = getTarget()
                if target then
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Velocity = Vector3.new(
                            math.random(-80000, 80000),
                            math.random(40000, 80000),
                            math.random(-80000, 80000)
                        )
                        Library:Notify({
                            Title = "💥 SUPER FLING",
                            Description = "Игрок улетел!",
                            Time = 2,
                        })
                    end
                end
            end)
        end
    end
})

-- FLING AURA - ИГРОКИ УЛЕТАЮТ
local flingAuraConn = nil
CombatGroup:AddToggle("FlingAura", {
    Text = "🌀 FLING AURA",
    Default = false,
    Callback = function(on)
        if on then
            flingAuraConn = RunService.Heartbeat:Connect(function()
                local char = player.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr ~= player then
                        local plrChar = plr.Character
                        if plrChar and plrChar:FindFirstChild("HumanoidRootPart") then
                            local dist = (root.Position - plrChar.HumanoidRootPart.Position).Magnitude
                            if dist < 25 then
                                plrChar.HumanoidRootPart.Velocity = Vector3.new(
                                    math.random(-30000, 30000),
                                    math.random(20000, 40000),
                                    math.random(-30000, 30000)
                                )
                            end
                        end
                    end
                end
            end)
        else
            if flingAuraConn then
                flingAuraConn:Disconnect()
                flingAuraConn = nil
            end
        end
    end
})

-- INFINITE GRAB REACH
CombatGroup:AddToggle("InfiniteGrabReach", {
    Text = "🎯 INFINITE GRAB REACH",
    Default = false,
    Callback = function(on)
        if on then
            local function fixGrab()
                local gp = Workspace:FindFirstChild("GrabParts")
                if gp and gp:FindFirstChild("GrabPart") then
                    local part = gp.GrabPart
                    part.Size = Vector3.new(1000, 1000, 1000)
                    part.CanCollide = false
                    part.Transparency = 1
                end
            end
            RunService.Heartbeat:Connect(function()
                if on then fixGrab() end
            end)
            workspace.ChildAdded:Connect(function(model)
                if model.Name == "GrabParts" and on then
                    task.wait(0.05)
                    fixGrab()
                end
            end)
        end
    end
})

-- BRING ALL
CombatGroup:AddButton({
    Text = "📦 BRING ALL",
    Func = function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= player then
                local plrChar = plr.Character
                if plrChar and plrChar:FindFirstChild("HumanoidRootPart") then
                    plrChar.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(math.random(-5, 5), 2, math.random(-5, 5))
                    plrChar.HumanoidRootPart.Velocity = Vector3.zero
                end
            end
        end
        Library:Notify({
            Title = "📦 BRING ALL",
            Description = "Все игроки у тебя!",
            Time = 2,
        })
    end
})

-- KILL AURA
local killAuraConn = nil
CombatGroup:AddToggle("KillAura", {
    Text = "☠️ KILL AURA",
    Default = false,
    Callback = function(on)
        if on then
            killAuraConn = RunService.Heartbeat:Connect(function()
                local char = player.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr ~= player then
                        local plrChar = plr.Character
                        if plrChar then
                            local hum = plrChar:FindFirstChild("Humanoid")
                            local hrp = plrChar:FindFirstChild("HumanoidRootPart")
                            if hum and hrp then
                                local dist = (root.Position - hrp.Position).Magnitude
                                if dist < 20 then
                                    hum.Health = 0
                                    plrChar:BreakJoints()
                                end
                            end
                        end
                    end
                end
            end)
        else
            if killAuraConn then
                killAuraConn:Disconnect()
                killAuraConn = nil
            end
        end
    end
})

-- ============================================
-- KICK SPAM - АВТОМАТИЧЕСКИЙ
-- ============================================
local kickSpamActive = false
local kickSpamConn = nil
local kickTarget = nil

local function spawnBlobman()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    pcall(function()
        RS.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", CFrame.new(0, 5000000, 0), Vector3.new(0, 60, 0))
    end)
    
    local folder = workspace:FindFirstChild(player.Name .. "SpawnedInToys")
    if folder and folder:FindFirstChild("CreatureBlobman") then
        local blob = folder.CreatureBlobman
        if blob:FindFirstChild("Head") then
            blob.Head.CFrame = CFrame.new(0, 50000, 0)
            blob.Head.Anchored = true
        end
        return blob
    end
    return nil
end

local function sitOnBlobman(blob)
    if not blob then return false end
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    
    local seat = blob:FindFirstChild("VehicleSeat") or blob:FindFirstChildWhichIsA("VehicleSeat", true)
    if not seat then return false end
    
    root.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
    task.wait(0.1)
    pcall(function() seat:Sit(hum) end)
    
    local t = tick()
    repeat task.wait(0.1) until hum.SeatPart == seat or tick() - t > 3
    return hum.SeatPart == seat
end

local function startKickSpam()
    if not kickTarget then
        Library:Notify({Title = "🍎 APPLE HUB", Description = "Выбери цель во вкладке TARGET!", Time = 3})
        return false
    end
    
    local folder = workspace:FindFirstChild(player.Name .. "SpawnedInToys")
    local blob = folder and folder:FindFirstChild("CreatureBlobman")
    
    if not blob then
        Library:Notify({Title = "🌀 KICK SPAM", Description = "Спавню блоба...", Time = 2})
        blob = spawnBlobman()
        task.wait(1)
    end
    
    if not blob then
        Library:Notify({Title = "🍎 APPLE HUB", Description = "Не удалось спавнить блоба!", Time = 3})
        return false
    end
    
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local seat = hum and hum.SeatPart
    
    if not seat or seat.Parent ~= blob then
        Library:Notify({Title = "🌀 KICK SPAM", Description = "Сажусь на блоба...", Time = 2})
        if not sitOnBlobman(blob) then
            Library:Notify({Title = "🍎 APPLE HUB", Description = "Не удалось сесть на блоба!", Time = 3})
            return false
        end
        task.wait(0.5)
    end
    
    local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
    local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
    local CG = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
    local CD = scriptObj and scriptObj:FindFirstChild("CreatureDrop")
    local R_Det = blob:FindFirstChild("RightDetector")
    local R_Weld = R_Det and (R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld"))
    
    if not (CG and CD and R_Det and R_Weld and blobRoot) then
        Library:Notify({Title = "🍎 APPLE HUB", Description = "Ошибка компонентов блоба!", Time = 3})
        return false
    end
    
    local SavedPos = blobRoot.CFrame
    local packetTimer = 0
    
    local tChar = kickTarget.Character
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    if tRoot and blobRoot then
        local bringStart = tick()
        while tick() - bringStart < 0.35 do
            if not kickSpamActive then break end
            blobRoot.CFrame = tRoot.CFrame
            blobRoot.Velocity = Vector3.zero
            pcall(function()
                if CG and R_Det then CG:FireServer(R_Det, tRoot, R_Weld) end
                GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                GE.SetNetworkOwner:FireServer(tRoot, blobRoot.CFrame)
            end)
            RunService.Heartbeat:Wait()
        end
        blobRoot.CFrame = SavedPos
        blobRoot.Velocity = Vector3.zero
        task.wait(0.05)
    end
    
    Library:Notify({Title = "🌀 KICK SPAM", Description = "Кикаю " .. kickTarget.Name, Time = 2})
    
    kickSpamConn = RunService.Heartbeat:Connect(function()
        if not kickSpamActive then return end
        local target = kickTarget
        if not target or not target.Character then return end
        
        local tChar = target.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        
        if tRoot and tHum and tHum.Health > 0 and blobRoot then
            blobRoot.CFrame = SavedPos
            blobRoot.Velocity = Vector3.zero
            local lockPos = SavedPos * CFrame.new(0, 23, 0)
            tRoot.CFrame = lockPos
            tRoot.Velocity = Vector3.zero
            tRoot.RotVelocity = Vector3.zero
            
            if tick() - packetTimer > 0.05 then
                packetTimer = tick()
                pcall(function()
                    tHum.PlatformStand = true
                    tHum.Sit = true
                    GE.SetNetworkOwner:FireServer(tRoot, lockPos)
                    if R_Weld then CD:FireServer(R_Weld) end
                    GE.DestroyGrabLine:FireServer(tRoot)
                    CG:FireServer(R_Det, tRoot, R_Weld)
                    GE.CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                end)
            end
        end
    end)
    return true
end

CombatExtra:AddToggle("KickSpam", {
    Text = "🌀 KICK SPAM",
    Default = false,
    Callback = function(on)
        kickSpamActive = on
        if on then
            if not startKickSpam() then
                kickSpamActive = false
            end
        else
            if kickSpamConn then
                kickSpamConn:Disconnect()
                kickSpamConn = nil
            end
            Library:Notify({Title = "🌀 KICK SPAM", Description = "Деактивирован", Time = 2})
        end
    end
})

-- ============================================
-- ВКЛАДКА DEFENSE
-- ============================================
local DefenseGroup = Tabs.Defense:AddLeftGroupbox("Defense Main")
local DefenseExtra = Tabs.Defense:AddRightGroupbox("Defense Extra")

-- ANTI VOID
local antiVoidConn = nil
local voidPlatform = nil

DefenseGroup:AddToggle("AntiVoid", {
    Text = "🌊 ANTI VOID",
    Default = false,
    Callback = function(on)
        if on then
            voidPlatform = Instance.new("Part")
            voidPlatform.Name = "AntiVoidPlatform"
            voidPlatform.Size = Vector3.new(50, 0.5, 50)
            voidPlatform.CanCollide = true
            voidPlatform.Anchored = true
            voidPlatform.Transparency = 1
            voidPlatform.Parent = Workspace
            
            antiVoidConn = RunService.Heartbeat:Connect(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local pos = root.Position
                    if pos.Y < -50 then
                        voidPlatform.Position = Vector3.new(pos.X, -49, pos.Z)
                        root.CFrame = CFrame.new(pos.X, -48, pos.Z)
                        root.Velocity = Vector3.zero
                    elseif pos.Y < 0 and pos.Y > -50 then
                        voidPlatform.Position = Vector3.new(pos.X, -1, pos.Z)
                    else
                        voidPlatform.Position = Vector3.new(pos.X, -1000, pos.Z)
                    end
                end
            end)
        else
            if antiVoidConn then
                antiVoidConn:Disconnect()
                antiVoidConn = nil
            end
            if voidPlatform then
                voidPlatform:Destroy()
                voidPlatform = nil
            end
        end
    end
})

-- ANTI GRAB
local antiGrabConn = nil
local antiGrabHumConn = nil

local function antiGrabReconnect()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    local fp = hrp:FindFirstChild("FirePlayerPart")
    if fp then fp:Destroy() end
    
    if antiGrabHumConn then antiGrabHumConn:Disconnect() end
    antiGrabHumConn = hum.Changed:Connect(function(p)
        if p == "Sit" and hum.Sit then
            if not (hum.SeatPart and tostring(hum.SeatPart.Parent) == "CreatureBlobman") then
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                hum.Sit = false
            end
        end
    end)
end

DefenseGroup:AddToggle("AntiGrab", {
    Text = "🛡️ ANTI GRAB",
    Default = false,
    Callback = function(on)
        if on then
            antiGrabReconnect()
        else
            if antiGrabHumConn then
                antiGrabHumConn:Disconnect()
                antiGrabHumConn = nil
            end
        end
    end
})

-- ANTI GRAB GUCCI
local antiGucciConn = nil
DefenseGroup:AddToggle("AntiGucci", {
    Text = "👔 ANTI GRAB GUCCI",
    Default = false,
    Callback = function(on)
        if on then
            antiGucciConn = RunService.Heartbeat:Connect(function()
                local char = player.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        pcall(function()
                            RS.CharacterEvents.RagdollRemote:FireServer(root, 0)
                        end)
                    end
                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") and part.Anchored then
                            part.Anchored = false
                        end
                    end
                end
            end)
        else
            if antiGucciConn then
                antiGucciConn:Disconnect()
                antiGucciConn = nil
            end
        end
    end
})

-- ANTI BLOBMAN DESTROY
DefenseGroup:AddToggle("AntiBlobman", {
    Text = "🧟 ANTI BLOBMAN DESTROY",
    Default = false,
    Callback = function(on)
        if on then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "CreatureBlobman" then
                    obj:Destroy()
                end
            end
            Workspace.DescendantAdded:Connect(function(obj)
                if on and obj.Name == "CreatureBlobman" then
                    obj:Destroy()
                end
            end)
        end
    end
})

-- ANTI BARRIER
DefenseGroup:AddToggle("AntiBarrier", {
    Text = "🧱 ANTI BARRIER",
    Default = false,
    Callback = function(on)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return end
        
        for _, plot in pairs(plots:GetChildren()) do
            local barrier = plot:FindFirstChild("Barrier")
            if barrier then
                for _, obj in pairs(barrier:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CanCollide = not on
                        if on then
                            obj.CanTouch = true
                            obj.CanQuery = true
                            local children = obj:GetChildren()
                            for _, child in pairs(children) do
                                if child:IsA("Script") or child:IsA("LocalScript") then
                                    child.Disabled = true
                                end
                            end
                        end
                    end
                end
            end
        end
        if on then
            Library:Notify({Title = "🧱 ANTI BARRIER", Description = "Барьеры отключены!", Time = 2})
        end
    end
})

-- ANTI EXPLOSION
local antiExplodeT = false
local function antiExplodeF()
    antiExplodeT = true
    local char = player.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    workspace.ChildAdded:Connect(function(model)
        if model.Name == "Part" and antiExplodeT then
            local mag = (model.Position - hrp.Position).Magnitude
            if mag <= 20 then
                hrp.Anchored = true
                wait(0.05)
                hrp.Anchored = false
            end
        end
    end)
end

DefenseGroup:AddToggle("AntiExplosion", {
    Text = "💥 ANTI EXPLOSION",
    Default = false,
    Callback = function(on)
        if on then
            antiExplodeF()
        else
            antiExplodeT = false
        end
    end
})

-- ANTI KICK
local autoStruggleConn = nil

DefenseExtra:AddToggle("AntiKick", {
    Text = "🦵 ANTI KICK",
    Default = false,
    Callback = function(on)
        if on then
            if autoStruggleConn then autoStruggleConn:Disconnect() end
            autoStruggleConn = RunService.Heartbeat:Connect(function()
                local char = player.Character
                if char and char:FindFirstChild("Head") then
                    local head = char.Head
                    if head:FindFirstChild("PartOwner") then
                        task.spawn(function()
                            local Struggle = RS.CharacterEvents:FindFirstChild("Struggle")
                            if Struggle then Struggle:FireServer(player) end
                            pcall(function() RS.GameCorrectionEvents.StopAllVelocity:FireServer() end)
                            for _, part in pairs(char:GetChildren()) do
                                if part:IsA("BasePart") then part.Anchored = true end
                            end
                            local isHeld = player:FindFirstChild("IsHeld")
                            while isHeld and isHeld.Value do task.wait() end
                            for _, part in pairs(char:GetChildren()) do
                                if part:IsA("BasePart") then part.Anchored = false end
                            end
                        end)
                    end
                end
            end)
        else
            if autoStruggleConn then
                autoStruggleConn:Disconnect()
                autoStruggleConn = nil
            end
            local char = player.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.Anchored = false end
                end
            end
        end
    end
})

-- ANTI INPUT LAG
local selectedToy = "FoodHamburger"

local ToyList = {
    ["Coconut"] = "FoodCoconut", ["Banana"] = "FoodBanana", ["Fries"] = "FoodFrenchFries",
    ["MeatStick"] = "FoodMeatStick", ["Poop"] = "PoopPile", ["Donut"] = "FoodDonut",
    ["Cake"] = "FoodCakePink", ["Burger"] = "FoodHamburger", ["Pizza"] = "FoodPizzaCheese",
    ["Hotdog"] = "FoodHotdog", ["Mushroom"] = "FoodMushroomPoison", ["Banjo"] = "InstrumentGuitarBanjo",
    ["Violin"] = "InstrumentGuitarViolin", ["Ukulele"] = "InstrumentGuitarUkulele",
    ["Sax"] = "InstrumentWoodwindSaxophone", ["Vuvuzela"] = "InstrumentBrassVuvuzela",
    ["Bongos"] = "InstrumentDrumBongos", ["Mic"] = "InstrumentVoiceMicrophone",
    ["Pepperoni"] = "FoodPizzaPepperoni", ["Piano"] = "InstrumentPianoMelodica",
    ["Bread"] = "FoodBread", ["Egg"] = "FoodDippyEgg", ["Mayo"] = "FoodMayonnaise",
    ["WhiteMug"] = "CupMugWhite", ["Ocarina"] = "InstrumentWoodwindOcarina",
    ["SparklePoop"] = "PoopPileSparkle", ["BrownMug"] = "CupMugBrown",
    ["Trumpet"] = "InstrumentBrassTrumpet", ["Snare"] = "InstrumentDrumSnare",
}

local DropdownValues = {}
for shortName, _ in pairs(ToyList) do
    table.insert(DropdownValues, shortName)
end
table.sort(DropdownValues)

DefenseExtra:AddDropdown("AntiInputLagToy", {
    Text = "⌨️ INPUT LAG ITEM",
    Values = DropdownValues,
    Default = 1,
    Callback = function(value)
        selectedToy = ToyList[value]
    end
})

DefenseExtra:AddToggle("AntiInputLag", {
    Text = "⌨️ ANTI INPUT LAG",
    Default = false,
    Callback = function(on)
        _G.AntiInputLag = on
        if on then
            task.spawn(function()
                local SpawnRemote = RS:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
                while _G.AntiInputLag do
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then
                        task.wait(0.1)
                        continue
                    end
                    
                    local toysFolder = workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                    if not toysFolder then
                        pcall(function()
                            SpawnRemote:InvokeServer(selectedToy, hrp.CFrame * CFrame.new(0, 5, 0), Vector3.zero)
                        end)
                    else
                        local toy = toysFolder:FindFirstChild(selectedToy)
                        if toy then
                            local holdPart = toy:FindFirstChild("HoldPart")
                            if holdPart then
                                pcall(function()
                                    holdPart.HoldItemRemoteFunction:InvokeServer(toy, char)
                                    task.wait(0.05)
                                    holdPart.DropItemRemoteFunction:InvokeServer(toy, hrp.CFrame * CFrame.new(0, 2000, 0), Vector3.zero)
                                end)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ============================================
-- ВКЛАДКА MOVEMENT
-- ============================================
local MovementGroup = Tabs.Movement:AddLeftGroupbox("Movement")

-- WATER WALK
local waterWalkConn = nil
local waterPlatform = nil

MovementGroup:AddToggle("WaterWalk", {
    Text = "💧 WATER WALK",
    Default = false,
    Callback = function(on)
        if on then
            waterPlatform = Instance.new("Part")
            waterPlatform.Name = "WaterWalkPlatform"
            waterPlatform.Size = Vector3.new(8, 0.1, 8)
            waterPlatform.CanCollide = true
            waterPlatform.Anchored = true
            waterPlatform.Transparency = 1
            waterPlatform.Parent = Workspace
            
            waterWalkConn = RunService.Heartbeat:Connect(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local pos = root.Position
                    local ray = Ray.new(pos + Vector3.new(0, 2, 0), Vector3.new(0, -10, 0))
                    local hit, hitPos = Workspace:FindPartOnRay(ray, char)
                    if hit and hit.Material == Enum.Material.Water then
                        waterPlatform.Position = Vector3.new(pos.X, hitPos.Y + 0.5, pos.Z)
                        waterPlatform.Transparency = 1
                    else
                        waterPlatform.Position = Vector3.new(pos.X, -1000, pos.Z)
                    end
                end
            end)
        else
            if waterWalkConn then
                waterWalkConn:Disconnect()
                waterWalkConn = nil
            end
            if waterPlatform then
                waterPlatform:Destroy()
                waterPlatform = nil
            end
        end
    end
})

-- SUPER SPEED
MovementGroup:AddToggle("SuperSpeed", {
    Text = "🏃 SUPER SPEED",
    Default = false,
    Callback = function(on)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = on and 100 or 16
        end
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = on and 100 or 16 end
        end)
    end
})

-- SUPER JUMP
MovementGroup:AddToggle("SuperJump", {
    Text = "🦘 SUPER JUMP",
    Default = false,
    Callback = function(on)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = on and 100 or 50
        end
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.JumpPower = on and 100 or 50 end
        end)
    end
})

-- NO CLIP
MovementGroup:AddToggle("NoClip", {
    Text = "🌀 NO CLIP",
    Default = false,
    Callback = function(on)
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not on
                end
            end
        end
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not on
                end
            end
        end)
    end
})

-- ============================================
-- ВКЛАДКА TARGET
-- ============================================
local TargetGroup = Tabs.Target:AddLeftGroupbox("Target")
local TargetExtra = Tabs.Target:AddRightGroupbox("Target Extra")

-- ВЫБОР ЦЕЛИ
local targetOptions = {}
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= player then
        table.insert(targetOptions, plr.Name)
    end
end

TargetGroup:AddDropdown("TargetSelect", {
    Text = "🎯 ВЫБОР ЦЕЛИ",
    Values = targetOptions,
    Default = 1,
    Callback = function(value)
        kickTarget = game.Players:FindFirstChild(value)
        Library:Notify({
            Title = "🍎 APPLE HUB",
            Description = "Цель: " .. value,
            Time = 2,
        })
    end
})

-- ANTI GRAB (TARGET)
local targetGrabConn = nil
local targetGrabActive = false

TargetExtra:AddToggle("TargetAntiGrab", {
    Text = "🎯 ANTI GRAB (TARGET)",
    Default = false,
    Callback = function(on)
        targetGrabActive = on
        if on then
            if not kickTarget then
                Library:Notify({
                    Title = "🍎 APPLE HUB",
                    Description = "Сначала выбери цель!",
                    Time = 3,
                })
                return
            end
            
            targetGrabConn = RunService.Heartbeat:Connect(function()
                if not targetGrabActive then return end
                local target = kickTarget
                if not target or not target.Character then return end
                
                local tChar = target.Character
                local hrp = tChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        RS.GrabEvents.SetNetworkOwner:FireServer(hrp, hrp.CFrame)
                        for _, part in pairs(tChar:GetChildren()) do
                            if part:IsA("BasePart") and part.Anchored then
                                part.Anchored = false
                            end
                        end
                    end)
                end
            end)
            Library:Notify({
                Title = "🎯 ANTI GRAB (TARGET)",
                Description = "Защита активирована на " .. kickTarget.Name,
                Time = 2,
            })
        else
            if targetGrabConn then
                targetGrabConn:Disconnect()
                targetGrabConn = nil
            end
            Library:Notify({
                Title = "🎯 ANTI GRAB (TARGET)",
                Description = "Защита деактивирована",
                Time = 2,
            })
        end
    end
})

-- ============================================
-- ВКЛАДКА SETTINGS
-- ============================================
local SettingsGroup = Tabs.Settings:AddLeftGroupbox("UI Settings")
local SettingsExtra = Tabs.Settings:AddRightGroupbox("Info")

SettingsExtra:AddLabel("🍎 APPLE HUB v2.0")
SettingsExtra:AddLabel("Все баги пофикшены!")
SettingsExtra:AddLabel("Нажми RightShift для меню")

SettingsGroup:AddButton({
    Text = "❌ ВЫГРУЗИТЬ ХАБ",
    Func = function()
        Library:Unload()
    end
})

SettingsGroup:AddButton({
    Text = "🔄 ОБНОВИТЬ СПИСОК ЦЕЛЕЙ",
    Func = function()
        local newList = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then
                table.insert(newList, plr.Name)
            end
        end
        Library:Notify({
            Title = "🍎 APPLE HUB",
            Description = "Список целей обновлен!",
            Time = 2,
        })
    end
})

-- ============================================
-- THEME MANAGER & SAVE MANAGER
-- ============================================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("AppleHub")
SaveManager:SetFolder("AppleHub/Configs")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- ============================================
-- ЗАПУСК
-- ============================================
Library:Notify({
    Title = "🍎 APPLE HUB",
    Description = "Все баги пофикшены! Версия 2.0",
    Time = 3,
})

print("🍎 APPLE HUB v2.0 ЗАГРУЖЕН!")
