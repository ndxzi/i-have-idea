local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false

local Window = Library:CreateWindow({
    Title = "Terra client",
    Footer = "Terra client",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

Library:SetMinimizeKey(Enum.KeyCode.X)

local Tabs = {
    Defense = Window:AddTab("defense", "shield"),
    Target = Window:AddTab("target", "crosshair"),
    Grab = Window:AddTab("grab", "hand"),
    Player = Window:AddTab("player", "user"),
    Misc = Window:AddTab("misc", "layers"),
    Build = Window:AddTab("build", "box"),
    Keybinds = Window:AddTab("keybinds", "keyboard"),
    Auras = Window:AddTab("auras", "sparkles"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings")
}

local DefenseGroup = Tabs.Defense:AddLeftGroupbox("Antis")

local plr = LocalPlayer
local antiGrabConn = nil

DefenseGroup:AddToggle("AntiGrab", {
    Text = "anti grab!!",
    Default = false,
    Callback = function(Value)
        local isHeld = plr:WaitForChild("IsHeld", 5)
        local struggleEvent = ReplicatedStorage:WaitForChild("CharacterEvents"):WaitForChild("Struggle")
        local savedCFrame = nil

        if antiGrabConn then 
            antiGrabConn:Disconnect()
            antiGrabConn = nil
        end

        if not Value then
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.Anchored = false
            end
            return 
        end

        local function onHeldChanged(heldState)
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if heldState then
                if hrp then 
                    savedCFrame = hrp.CFrame
                    hrp.Anchored = true 
                end
                
                task.spawn(function()
                    while isHeld.Value and Value do 
                        struggleEvent:FireServer(plr)
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

        if isHeld then
            antiGrabConn = isHeld.Changed:Connect(onHeldChanged)
            if isHeld.Value then
                onHeldChanged(true)
            end
        end
    end
})

local antiExplodeT = false

DefenseGroup:AddToggle("AntiExplode", {
    Text = "anti Explode LOLOLOL",
    Default = false,
    Callback = function(Value)
        antiExplodeT = Value
        if not Value then return end
        local conn
        conn = workspace.ChildAdded:Connect(function(model)
            if not antiExplodeT then conn:Disconnect() return end
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and model.Name == "Part" then
                local mag = (model.Position - hrp.Position).Magnitude
                if mag <= 20 then
                    hrp.Anchored = true
                    task.wait(0.05)
                    if char:FindFirstChild("Right Arm") and char["Right Arm"]:FindFirstChild("RagdollLimbPart") then
                        while char["Right Arm"].RagdollLimbPart.CanCollide do task.wait(0.01) end
                    end
                    hrp.Anchored = false
                end
            end
        end)
    end
})

local mapTeleportLoop = nil
local savedPositionTP = nil
local mapTeleportActive = false

DefenseGroup:AddToggle("LoopTP", {
    Text = "Loop TP",
    Default = false,
    Callback = function(val)
        mapTeleportActive = val
        
        if val then
            local char = plr.Character
            local HRP = char and char:FindFirstChild("HumanoidRootPart")
            
            if not HRP then
                return
            end
            
            savedPositionTP = HRP.CFrame
            
            local teleportPoints = {
                Vector3.new(500, 0, 500),
                Vector3.new(-500, 0, -500),
                Vector3.new(500, 0, -500),
                Vector3.new(-500, 0, 500),
                Vector3.new(1000, 0, 0),
                Vector3.new(-1000, 0, 0),
                Vector3.new(0, 0, 1000),
                Vector3.new(0, 0, -1000),
                Vector3.new(750, 0, 750),
                Vector3.new(-750, 0, -750),
                Vector3.new(750, 0, -750),
                Vector3.new(-750, 0, 750),
                Vector3.new(1500, 0, 500),
                Vector3.new(-1500, 0, -500),
                Vector3.new(500, 0, 1500),
                Vector3.new(-500, 0, -1500),
                Vector3.new(2000, 0, 0),
                Vector3.new(-2000, 0, 0),
                Vector3.new(0, 0, 2000),
                Vector3.new(0, 0, -2000),
                Vector3.new(1200, 0, 1200),
                Vector3.new(-1200, 0, -1200),
                Vector3.new(1200, 0, -1200),
                Vector3.new(-1200, 0, 1200),
                Vector3.new(800, 0, -1500),
                Vector3.new(-800, 0, 1500),
                Vector3.new(1800, 0, 800),
                Vector3.new(-1800, 0, -800),
                Vector3.new(300, 0, 2000),
                Vector3.new(-300, 0, -2000),
            }
            
            local currentIndex = 0
            
            local function getGroundY(x, z)
                local rayOrigin = Vector3.new(x, 1000, z)
                local rayDirection = Vector3.new(0, -2000, 0)
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {plr.Character}
                
                local result = workspace:Raycast(rayOrigin, rayDirection, rayParams)
                
                if result then
                    return result.Position.Y + 3
                else
                    return 10
                end
            end
            
            mapTeleportLoop = RunService.Heartbeat:Connect(function()
                if not mapTeleportActive then return end
                
                local char = plr.Character
                local HRP = char and char:FindFirstChild("HumanoidRootPart")
                
                if not HRP then return end
                
                task.wait(0.1)
                
                currentIndex = currentIndex + 1
                if currentIndex > #teleportPoints then
                    currentIndex = 1
                end
                
                local point = teleportPoints[currentIndex]
                local groundY = getGroundY(point.X, point.Z)
                
                HRP.CFrame = CFrame.new(point.X, groundY, point.Z)
                HRP.Velocity = Vector3.zero
                HRP.AssemblyLinearVelocity = Vector3.zero
                HRP.AssemblyAngularVelocity = Vector3.zero
            end)
        else
            if mapTeleportLoop then
                mapTeleportLoop:Disconnect()
                mapTeleportLoop = nil
            end
            
            local char = plr.Character
            local HRP = char and char:FindFirstChild("HumanoidRootPart")
            
            if HRP and savedPositionTP then
                HRP.CFrame = savedPositionTP
                HRP.Velocity = Vector3.zero
                HRP.AssemblyLinearVelocity = Vector3.zero
                HRP.AssemblyAngularVelocity = Vector3.zero
            end
            
            savedPositionTP = nil
        end
    end
})