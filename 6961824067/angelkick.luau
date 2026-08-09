local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local flyingPlayers = {}

local function hideBlackHole(obj)
    if obj:IsA("BasePart") then
        obj.Transparency = 1
        obj.CanCollide = false
        
        if obj:IsA("MeshPart") then
            obj.TextureID = ""
        end
    end
    
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    end
    
    if obj:IsA("ParticleEmitter") then
        obj:Destroy()
    end
    
    if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        obj:Destroy()
    end
    
    if obj:IsA("Trail") or obj:IsA("Beam") then
        obj:Destroy()
    end
    
    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
        obj:Destroy()
    end
    
    if obj:IsA("SpecialMesh") or obj:IsA("BlockMesh") or obj:IsA("CylinderMesh") then
        obj.Scale = Vector3.new(0, 0, 0)
    end
end

local function addAngelWings(player)
    if not player or not player.Character then return end
    
    local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
    if not torso then return end
    
    if torso:FindFirstChild("AngelWings") then return end
    
    local wingsModel = Instance.new("Model")
    wingsModel.Name = "AngelWings"
    wingsModel.Parent = torso
    
    local leftWing = Instance.new("Part")
    leftWing.Name = "LeftWing"
    leftWing.Size = Vector3.new(0.5, 6, 4)
    leftWing.Color = Color3.fromRGB(255, 255, 255)
    leftWing.Material = Enum.Material.Neon
    leftWing.Transparency = 0.3
    leftWing.CanCollide = false
    leftWing.Parent = wingsModel
    
    local leftWeld = Instance.new("Weld")
    leftWeld.Part0 = torso
    leftWeld.Part1 = leftWing
    leftWeld.C0 = CFrame.new(-2.5, 0, 1) * CFrame.Angles(0, 0, math.rad(-30))
    leftWeld.Parent = leftWing
    
    local rightWing = Instance.new("Part")
    rightWing.Name = "RightWing"
    rightWing.Size = Vector3.new(0.5, 6, 4)
    rightWing.Color = Color3.fromRGB(255, 255, 255)
    rightWing.Material = Enum.Material.Neon
    rightWing.Transparency = 0.3
    rightWing.CanCollide = false
    rightWing.Parent = wingsModel
    
    local rightWeld = Instance.new("Weld")
    rightWeld.Part0 = torso
    rightWeld.Part1 = rightWing
    rightWeld.C0 = CFrame.new(2.5, 0, 1) * CFrame.Angles(0, 0, math.rad(30))
    rightWeld.Parent = rightWing
    
    local leftFeather1 = Instance.new("Part")
    leftFeather1.Name = "LeftFeather1"
    leftFeather1.Size = Vector3.new(0.3, 5, 3)
    leftFeather1.Color = Color3.fromRGB(255, 255, 255)
    leftFeather1.Material = Enum.Material.Neon
    leftFeather1.Transparency = 0.4
    leftFeather1.CanCollide = false
    leftFeather1.Parent = wingsModel
    
    local leftFeatherWeld1 = Instance.new("Weld")
    leftFeatherWeld1.Part0 = torso
    leftFeatherWeld1.Part1 = leftFeather1
    leftFeatherWeld1.C0 = CFrame.new(-3.5, -1, 1.5) * CFrame.Angles(0, 0, math.rad(-45))
    leftFeatherWeld1.Parent = leftFeather1
    
    local rightFeather1 = Instance.new("Part")
    rightFeather1.Name = "RightFeather1"
    rightFeather1.Size = Vector3.new(0.3, 5, 3)
    rightFeather1.Color = Color3.fromRGB(255, 255, 255)
    rightFeather1.Material = Enum.Material.Neon
    rightFeather1.Transparency = 0.4
    rightFeather1.CanCollide = false
    rightFeather1.Parent = wingsModel
    
    local rightFeatherWeld1 = Instance.new("Weld")
    rightFeatherWeld1.Part0 = torso
    rightFeatherWeld1.Part1 = rightFeather1
    rightFeatherWeld1.C0 = CFrame.new(3.5, -1, 1.5) * CFrame.Angles(0, 0, math.rad(45))
    rightFeatherWeld1.Parent = rightFeather1
    
    local leftFeather2 = Instance.new("Part")
    leftFeather2.Name = "LeftFeather2"
    leftFeather2.Size = Vector3.new(0.2, 4, 2.5)
    leftFeather2.Color = Color3.fromRGB(255, 255, 255)
    leftFeather2.Material = Enum.Material.Neon
    leftFeather2.Transparency = 0.5
    leftFeather2.CanCollide = false
    leftFeather2.Parent = wingsModel
    
    local leftFeatherWeld2 = Instance.new("Weld")
    leftFeatherWeld2.Part0 = torso
    leftFeatherWeld2.Part1 = leftFeather2
    leftFeatherWeld2.C0 = CFrame.new(-4, -2, 2) * CFrame.Angles(0, 0, math.rad(-60))
    leftFeatherWeld2.Parent = leftFeather2
    
    local rightFeather2 = Instance.new("Part")
    rightFeather2.Name = "RightFeather2"
    rightFeather2.Size = Vector3.new(0.2, 4, 2.5)
    rightFeather2.Color = Color3.fromRGB(255, 255, 255)
    rightFeather2.Material = Enum.Material.Neon
    rightFeather2.Transparency = 0.5
    rightFeather2.CanCollide = false
    rightFeather2.Parent = wingsModel
    
    local rightFeatherWeld2 = Instance.new("Weld")
    rightFeatherWeld2.Part0 = torso
    rightFeatherWeld2.Part1 = rightFeather2
    rightFeatherWeld2.C0 = CFrame.new(4, -2, 2) * CFrame.Angles(0, 0, math.rad(60))
    rightFeatherWeld2.Parent = rightFeather2
    
    local head = player.Character:FindFirstChild("Head")
    if head then
        local halo = Instance.new("Part")
        halo.Name = "Halo"
        halo.Shape = Enum.PartType.Cylinder
        halo.Size = Vector3.new(0.3, 3, 3)
        halo.Color = Color3.fromRGB(255, 255, 100)
        halo.Material = Enum.Material.Neon
        halo.Transparency = 0.2
        halo.CanCollide = false
        halo.Parent = wingsModel
        
        local haloWeld = Instance.new("Weld")
        haloWeld.Part0 = head
        haloWeld.Part1 = halo
        haloWeld.C0 = CFrame.new(0, 1.5, 0) * CFrame.Angles(0, 0, math.rad(90))
        haloWeld.Parent = halo
        
        local haloLight = Instance.new("PointLight")
        haloLight.Color = Color3.fromRGB(255, 255, 100)
        haloLight.Brightness = 5
        haloLight.Range = 20
        haloLight.Parent = halo
    end
    
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local heavenLight = Instance.new("PointLight")
        heavenLight.Name = "HeavenLight"
        heavenLight.Color = Color3.fromRGB(255, 255, 200)
        heavenLight.Brightness = 10
        heavenLight.Range = 50
        heavenLight.Shadows = true
        heavenLight.Parent = hrp
        
        local spotLight = Instance.new("SpotLight")
        spotLight.Name = "HeavenSpot"
        spotLight.Color = Color3.fromRGB(255, 255, 200)
        spotLight.Brightness = 15
        spotLight.Range = 100
        spotLight.Angle = 45
        spotLight.Face = Enum.NormalId.Top
        spotLight.Shadows = true
        spotLight.Parent = hrp
        
        local particles = Instance.new("ParticleEmitter")
        particles.Name = "HeavenParticles"
        particles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 200))
        particles.Size = NumberSequence.new(0.5, 0)
        particles.Lifetime = NumberRange.new(1, 2)
        particles.Rate = 50
        particles.Speed = NumberRange.new(5, 10)
        particles.SpreadAngle = Vector2.new(30, 30)
        particles.EmissionDirection = Enum.NormalId.Top
        particles.LightEmission = 1
        particles.Parent = hrp
    end
end

local function findNearestPlayer(blackHole)
    local position = nil
    
    if blackHole:IsA("BasePart") then
        position = blackHole.Position
    elseif blackHole:IsA("Model") then
        local part = blackHole:FindFirstChildWhichIsA("BasePart")
        if part then
            position = part.Position
        end
    end
    
    if not position then return end
    
    local nearestPlayer = nil
    local nearestDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestPlayer = player
            end
        end
    end
    
    if nearestPlayer and not flyingPlayers[nearestPlayer] then
        flyingPlayers[nearestPlayer] = blackHole
        addAngelWings(nearestPlayer)
    end
end

local function processBlackHole(obj)
    if obj.Name == "BlackHoleKick" then
        hideBlackHole(obj)
        
        for _, child in pairs(obj:GetDescendants()) do
            hideBlackHole(child)
        end
        
        findNearestPlayer(obj)
    end
end

for _, obj in pairs(Workspace:GetDescendants()) do
    processBlackHole(obj)
end

Workspace.DescendantAdded:Connect(function(obj)
    task.wait()
    processBlackHole(obj)
    
    if obj.Name == "BlackHoleKick" then
        obj.DescendantAdded:Connect(function(child)
            task.wait()
            hideBlackHole(child)
        end)
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    for player, blackHole in pairs(flyingPlayers) do
        if not blackHole or not blackHole.Parent then
            flyingPlayers[player] = nil
        elseif player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 30 * deltaTime, 0)
        else
            flyingPlayers[player] = nil
        end
    end
end)