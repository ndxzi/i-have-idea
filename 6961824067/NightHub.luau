-- services
local RS = game:GetService("ReplicatedStorage")
local RF = game:GetService("ReplicatedFirst")
local PS = game:GetService("Players")
local DB = game:GetService("Debris")
local Tween = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/BlizTBr/scripts/main/Orion%20X')))()
local R = game:GetService("RunService")
local request = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local W = game:GetService("Workspace")
local Cam = workspace.CurrentCamera
local downDir = Vector3.new(0, -1, 0)
local lastH
local lastHitTime = tick()
local raycastParams = RaycastParams.new()
local xcl
local ycl
local zcl
local offPos = Vector3.new(xcl, ycl, zcl)
local freeze
local frt

-- Player
local CE = RS:WaitForChild("CharacterEvents")
local localPlayer = PS.LocalPlayer
local localChar = localPlayer.Character
local HR = localChar:WaitForChild("HumanoidRootPart")
local localName = localPlayer.Name
local localTFolder = workspace:WaitForChild(localName .. "SpawnedInToys")
local Mouse = localPlayer:GetMouse()
local hum = localChar:WaitForChild("Humanoid")

-- Toy Events
local SpawnToy = RS:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
local DeleteToy = RS:WaitForChild("MenuToys"):WaitForChild("DestroyToy")

-- Grab Events
local CreateGrabLine = RS:WaitForChild("GrabEvents"):WaitForChild("CreateGrabLine")
local DestroyGrabLine = RS:WaitForChild("GrabEvents"):WaitForChild("DestroyGrabLine")
local SetNetworkOwnership = RS:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
local ExtendLine = RS:WaitForChild("GrabEvents"):WaitForChild("ExtendGrabLine")

-- Struggle
local SE = CE:WaitForChild("Struggle")

-- Toggles

_G.SuperStrength = nil
_G.AntiGrab = nil
_G.AntiExplosion = nil
_G.AntiBurn = nil
_G.KickAttacker = nil
_G.AutoAttacker = nil
_G.KillAttacker = nil
_G.Poison_Grab = nil
_G.KickGrab = nil
_G.PaintGrab = nil
_G.MasslessGrab = nil
_G.BlobmanSpeed = nil
_G.BlobAntiE = nil
_G.Burn_Grab = nil
_G.Radioactive_Grab = nil
_G.Kill_Grab = nil
_G.WalkSpeed = nil
_G.InfiniteJump = nil
_G.Teleport = nil
_G.KickAura = nil
_G.FlingAura = nil
_G.BurnAura = nil
_G.AttractionAura = nil
_G.KillAura = nil
_G.PaintAura = nil
_G.WalkspeedAura = nil
_G.PoisionAura = nil
local autocl
local SIL
local dist = 30


-- Slider
getgenv().Multiplier = 0.5
_G.Strength = nil
_G.WalkA = nil
_G.Jpower = nil
_G.BSpeed = nil

-- Functions

local function checkFirePart()
    for i, toy in pairs(localTFolder:GetChildren()) do
        if toy.Name == "Campfire" then
            local firePlayerPart = toy:FindFirstChild("FirePlayerPart")
            if firePlayerPart and firePlayerPart:FindFirstChild("CanBurn") then
                if not firePlayerPart.CanBurn.Value then
                    DeleteToy:FireServer(toy)
                end
            end
        end
    end

    local campfire = localTFolder:FindFirstChild("Campfire")
    if campfire then
        local firePlayerPart = campfire:FindFirstChild("FirePlayerPart")
        if firePlayerPart and firePlayerPart:FindFirstChild("CanBurn") then
            if firePlayerPart.CanBurn.Value then
                return campfire
            end
        end
    else
        local args = {
            [1] = "Campfire",
            [2] = CFrame.new(508.073517, 67.2614441, -261.901917, -0.133750245, -0.471861839, 0.871468484, -3.7252903e-09, 0.879369617, 0.476139903, -0.991015136, 0.0636838302, -0.117615893),
            [3] = Vector3.new(0, 97.69000244140625, 0)
        }

        repeat
            local spawnResult = SpawnToy:InvokeServer(unpack(args))
            if spawnResult == "YouDontOwnToy" then
                for i, toy in pairs(workspace:GetChildren()) do
                    if toy:FindFirstChild("Campfire") then
                        local firePlayerPart = toy:FindFirstChild("FirePlayerPart")
                        if firePlayerPart and firePlayerPart:FindFirstChild("CanBurn") then
                            if firePlayerPart.CanBurn.Value then
                                campfire = toy
                                break
                            end
                        end
                    end
                end

                if campfire then
                    break
                end
            else
                campfire = localTFolder:FindFirstChild("Campfire")
            end

            wait(1)
        until campfire ~= nil

        return campfire
    end
end

local function NightHub()
-- Anti-burn setup
local anfr = W.Map.Hole.PoisonBigHole.ExtinguishPart
anfr.Size = Vector3.new(0.5, 0.5, 0.5)
anfr.Transparency = 1
anfr.Tex.Transparency = 1

local function STS()
local Hitbox = {"Head", "Torso", "Left Leg", "Right Leg"}

local function GetClosest()
    local Target, Closest = nil, math.huge
    
    for _, player in pairs(PS:GetPlayers()) do
        if player.Name ~= localPlayer.Name and player.Character and localPlayer and localPlayer.Character and localPlayer.Character.HumanoidRootPart then
            local playerPosition = localPlayer.Character.HumanoidRootPart.Position
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                local screenPos, onScreen = Cam:WorldToScreenPoint(humanoidRootPart.Position)
                
                if onScreen then
                    local distance = (playerPosition - humanoidRootPart.Position).magnitude
                    
                    if distance < Closest then
                        Closest = distance
                        Target = player
                    end
                end
            end
        end
    end
    
    return Target
end

local Target
local part
local partn
local ch

R.RenderStepped:Connect(function()
    Target = GetClosest()
end)

local function CalculateDirection(Origin, Destination, Length)
    return (Destination - Origin).Unit * Length
end

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(...)
    local args = {...}
    local self = args[1]
    local method = getnamecallmethod()
    
    if self == workspace and not checkcaller() and method == "Raycast" and Target and Target.Character and Target.Character.HumanoidRootPart and localPlayer.Character.HumanoidRootPart and Target.Character.Humanoid and Target.Character.Humanoid.Health > 0 and not Target.InPlot.Value and SIL then
        local playerPosition = localPlayer.Character.HumanoidRootPart.Position
        local targetPosition = Target.Character.HumanoidRootPart.Position
        local distance = (playerPosition - targetPosition).magnitude
        part = math.random(1, #Hitbox)
        partn = Hitbox[part]
        ch = Target.Character[partn]

        if distance <= dist and ch then
            args[3] = CalculateDirection(args[2], Target.Character[partn].Position, 1000)
            args[4] = RaycastParams.new()
            args[4].FilterDescendantsInstances = {Target.Character}
            args[4].FilterType = Enum.RaycastFilterType.Include
            part = nil
            partn = nil
            ch = nil
        end
    end

    return __namecall(unpack(args))
end)
end

local Window = OrionLib:MakeWindow({
    Name = "Night Hub(FTAP)",
    HidePremium = false,
    SaveConfig = true,
    IntroEnabled = true,
    IntroText = "Welcome to a new experience of exploiting with Night Hub",
    IntroIcon = "rbxassetid://1234567890",
    ConfigFolder = "NightHubConfig"
})

local GrabsTab = Window:MakeTab({
    Name = "Grabs",
    PremiumOnly = false
})


GrabsTab:AddSlider({
    Name = "Reach Silent Aim",
    Min = 0,
    Max = 50,
    Default = 30,
    Callback = function(Value)
        dist = Value
    end
})

GrabsTab:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(Value)
        SIL = Value
    end
})

STS()

local function acl()

local function ResetVariables()
    local localPlayer = PS.LocalPlayer
    if localPlayer then
        local localChar = localPlayer.Character
        if localChar then
            HR = localChar:FindFirstChild("HumanoidRootPart")
            hum = localChar:FindFirstChild("Humanoid")
        end
    end
end

local function AntiRay(position)
    if position and downDir and raycastParams then
        local data = W:Raycast(position + Vector3.new(0, 3, 0), downDir * 15000, raycastParams)
        if data and data.Instance and data.Instance:IsA("BasePart") and data.Position then
            return true
        else
            return false
        end
    end
end

local function Ray(HR, hum)
    if hum and hum.Health > 0 and HR and HR.Position and downDir and raycastParams then
        return W:Raycast(HR.Position, downDir * 15000, raycastParams)
    end
end

local function onCharacterAdded(character)
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character}
end

local function SaveD(HR, hum)
    local data = Ray(HR, hum)
    if data and data.Instance and data.Instance:IsA("BasePart") and data.Position then
        lastH = data.Position
    elseif lastH and not freeze and AntiRay(lastH) then
        SE:FireServer(localPlayer)
        HR.AssemblyLinearVelocity = Vector3.new()
        HR.CFrame = CFrame.new(lastH + offPos)
    elseif lastH and freeze and AntiRay(lastH) then
        SE:FireServer(localPlayer)
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = HR
        wait(frt)
        bodyVelocity:Destroy()
        HR.AssemblyLinearVelocity = Vector3.new()
        HR.CFrame = CFrame.new(lastH + offPos)
    elseif lastH and not freeze and not AntiRay(lastH) and not bodyVelocity then
        SE:FireServer(localPlayer)
        HR.AssemblyLinearVelocity = Vector3.new()
        HR.CFrame = CFrame.new(Vector3.new(0, 0, 0) + offPos)
    elseif lastH and freeze and not AntiRay(lastH) and not bodyVelocity then
        SE:FireServer(localPlayer)
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = HR
        wait(frt)
        bodyVelocity:Destroy()
        HR.AssemblyLinearVelocity = Vector3.new()
        HR.CFrame = CFrame.new(Vector3.new(0, 0, 0) + offPos)
    end
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)
onCharacterAdded(localChar)

R.Heartbeat:Connect(function()
    if autocl then
        ResetVariables()
        SaveD(HR, hum)
    end
end)
end

local AntiTab = Window:MakeTab({
    Name = "Anti",
    PremiumOnly = false
})

local AutoTab = Window:MakeTab({
    Name = "Autos",
    PremiumOnly = false
})

AutoTab:AddToggle({
    Name = "Auto Clutch",
    Default = false,
    Callback = function(Value)
        autocl = Value
    end
})

AutoTab:AddToggle({
    Name = "Freeze Toggle(Auto Clutch)",
    Default = false,
    Callback = function(Value)
        freeze = Value
    end
})

AutoTab:AddSlider({
    Name = "Freeze Delay(Auto Clutch)",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(Value)
        frt = Value
    end
})

acl()

AutoTab:AddParagraph("Important!","Don't edit the values below if you don't know what you are doing.")

local MiscTab = Window:MakeTab({
    Name = "Misc",
    PremiumOnly = false
})

AutoTab:AddSlider({
    Name = "X Axis(Auto Clutch)",
    Min = -5,
    Max = 5,
    Default = -3,
    Callback = function(Value)
        xcl = Value
    end
})

AutoTab:AddSlider({
    Name = "Y Axis(Auto Clutch)",
    Min = 0,
    Max = 5,
    Default = 1,
    Callback = function(Value)
        ycl = Value
    end
})

AutoTab:AddSlider({
    Name = "Z Axis(Auto Clutch)",
    Min = -5,
    Max = 5,
    Default = 0,
    Callback = function(Value)
        zcl = Value
    end
})

local GrabLineTab = Window:MakeTab({
    Name = "Grab Line",
    PremiumOnly = false
})

local BlobmanTab = Window:MakeTab({
    Name = "Blobman",
    PremiumOnly = false
})

OrionLib:Init()
end

NightHub()
