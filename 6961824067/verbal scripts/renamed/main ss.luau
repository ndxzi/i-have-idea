--rename by ai ((( 
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local grabDistance = 50
local grabPart = nil
local isGrabbing = false
local grabbedPlayers = {}
local grabTargets = {}
local targetUsername = "JESSETC92BACKUP1"

local button = nil

LocalPlayer.CharacterAdded:Connect(function(character)
    local playerGui = LocalPlayer.PlayerGui
    local toggleGui = playerGui:FindFirstChild("ToggleButtonGui")
    if toggleGui then
        toggleGui:Destroy()
    end
    createToggleButton()
end)

if LocalPlayer.Character then
    createToggleButton()
end

local function clearGrabTargets()
    for playerName, data in pairs(grabTargets) do
        local character = data.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local weld = hrp:FindFirstChild("GrabWeld")
                if weld then
                    weld:Destroy()
                end
            end
        end
    end
    grabTargets = {}
end

local function handleRagdollTouch(hitPart)
    local ragdollPart = hitPart:FindFirstChild("RagdollTouchedHitbox")
    if ragdollPart then
        local grabEvents = ragdollPart:FindFirstChild("GrabEvents")
        if grabEvents then
            local setOwner = grabEvents:FindFirstChild("SetNetworkOwner")
            if setOwner then
                setOwner:FireServer(LocalPlayer)
            end
        end
        grabTargets[hitPart.Parent.Name] = nil
    end
end

local function cleanupGrabPart()
    if grabPart then
        grabPart:Destroy()
        grabPart = nil
    end
end

local function disableJump()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 0
        end
    end
end

local function createToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToggleButtonGui"
    screenGui.Parent = LocalPlayer.PlayerGui
    
    local imageButton = Instance.new("ImageButton")
    button = imageButton
    button.Size = UDim2.new(0, 65, 0, 65)
    button.Position = UDim2.new(0, 10, 0, 270)
    button.Image = "rbxassetid://18940741484"
    button.BackgroundTransparency = 0.5
    button.BorderSizePixel = 0
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = button
    
    button.Parent = screenGui
    
    button.MouseButton1Click:Connect(function()
        toggleGrab()
    end)
end

local function toggleGrab()
    isGrabbing = not isGrabbing
    
    if isGrabbing then
        clearGrabTargets()
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        cleanupGrabPart()
        clearGrabTargets()
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end

local function launchUpward(part)
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 90, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = part
end

local function startHeartbeatLoop()
    RunService.Heartbeat:Connect(function(deltaTime)
        updateGrab()
    end)
end

local function updateGrab()
    if not isGrabbing then
        return
    end
    
    local character = LocalPlayer.Character
    if not character then
        return
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        local targetName = player.Name
        if targetName == targetUsername then
            if player.Character then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = player.Character:FindFirstChild("Humanoid")
                
                if targetHrp and targetHumanoid then
                    local distance = (targetHrp.Position - hrp.Position).Magnitude
                    
                    if distance <= grabDistance then
                        local existingGrab = grabTargets[targetName]
                        if existingGrab then
                            existingGrab.Weld.C0 = hrp.CFrame:ToObjectSpace(targetHrp.CFrame)
                            existingGrab.BodyPosition.Position = hrp.Position
                            launchUpward(targetHrp)
                        end
                    end
                end
            end
        end
    end
end

local function tableFind(tbl, value)
    return table.find(tbl, value)
end

startHeartbeatLoop()
