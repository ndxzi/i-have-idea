local function httpGet(url)
    if type(url) ~= "string" then return "" end
    local ok, res = pcall(game.HttpGet, game, url)
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

local Library = loadstring(httpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"))()
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
game:GetService("RunService")

local window = Library.CreateWindow(Library, {
    Title = "Pallet Editor",
    Theme = "Dark",
    Size = UDim2.fromOffset(620, 750),
    Transparency = 0.2,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.LeftAlt
})

local themes = {
    Light = {
        Primary = Color3.fromRGB(232, 232, 232),
        Secondary = Color3.fromRGB(255, 255, 255),
        Component = Color3.fromRGB(245, 245, 245),
        Interactables = Color3.fromRGB(235, 235, 235),
        Tab = Color3.fromRGB(50, 50, 50),
        Title = Color3.fromRGB(0, 0, 0),
        Description = Color3.fromRGB(100, 100, 100),
        Shadow = Color3.fromRGB(255, 255, 255),
        Outline = Color3.fromRGB(210, 210, 210),
        Icon = Color3.fromRGB(100, 100, 100)
    },
    Dark = {
        Primary = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(35, 35, 35),
        Component = Color3.fromRGB(40, 40, 40),
        Interactables = Color3.fromRGB(45, 45, 45),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(200, 200, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220)
    },
    Void = {
        Primary = Color3.fromRGB(15, 15, 15),
        Secondary = Color3.fromRGB(20, 20, 20),
        Component = Color3.fromRGB(25, 25, 25),
        Interactables = Color3.fromRGB(30, 30, 30),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(200, 200, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220)
    }
}

window.SetTheme(window, themes.Dark)
window.AddTabSection(window, { Name = "Main", Order = 1 })
window.AddTabSection(window, { Name = "Graphics", Order = 2 })
window.AddTabSection(window, { Name = "ESP", Order = 3 })
window.AddTabSection(window, { Name = "Settings", Order = 4 })

local editorTab = window.AddTab(window, {
    Title = "Editor",
    Section = "Main",
    Icon = "rbxassetid://11963373994"
})

local materials = {
    Plastic = Enum.Material.Plastic,
    Wood = Enum.Material.Wood,
    WoodPlanks = Enum.Material.WoodPlanks,
    Brick = Enum.Material.Brick,
    Concrete = Enum.Material.Concrete,
    Marble = Enum.Material.Marble,
    Granite = Enum.Material.Granite,
    Glass = Enum.Material.Glass,
    Metal = Enum.Material.Metal,
    Neon = Enum.Material.Neon,
    Ice = Enum.Material.Ice,
    Sand = Enum.Material.Sand,
    Grass = Enum.Material.Grass,
    Slate = Enum.Material.Slate,
    Basalt = Enum.Material.Basalt,
    Asphalt = Enum.Material.Asphalt,
    Rock = Enum.Material.Rock
}

local selectedColor = Color3.fromRGB(139, 69, 19)
local selectedMaterial = "Wood"
local autoApply = true
local settingsFileName = "PalletEditorSettings.txt"

local function saveSettings()
    local data = ""
    for key, value in pairs({
        ColorR = math.round(selectedColor.R * 255),
        ColorG = math.round(selectedColor.G * 255),
        ColorB = math.round(selectedColor.B * 255),
        Material = selectedMaterial,
        AutoApply = tostring(autoApply)
    }) do
        data = data .. key .. "=" .. tostring(value) .. "\n"
    end
    pcall(function()
        if writefile then
            writefile(settingsFileName, data)
            print("Settings saved")
        end
    end)
end

local function loadSettings()
    local success, fileData = pcall(function()
        if readfile then
            return readfile(settingsFileName)
        end
        return nil
    end)
    if not success or not fileData then
        return false
    end
    local config = {}
    for line in string.gmatch(fileData, "[^\n]+") do
        local key, value = string.match(line, "^([^=]+)=(.+)$")
        if key and value then
            config[key] = value
        end
    end
    if config.ColorR and config.ColorG and config.ColorB then
        selectedColor = Color3.fromRGB(
            tonumber(config.ColorR) or 139,
            tonumber(config.ColorG) or 69,
            tonumber(config.ColorB) or 19
        )
    end
    if config.Material then
        selectedMaterial = config.Material
    end
    if config.AutoApply then
        autoApply = config.AutoApply == "true"
    end
    return true
end

local function findPallets()
    local pallets = {}
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name == "PalletLightBrown" then
            table.insert(pallets, descendant)
        end
    end
    return pallets
end

local function applyToAllPallets()
    local pallets = findPallets()
    local material = materials[selectedMaterial] or Enum.Material.Wood
    local partCount = 0
    for _, pallet in ipairs(pallets) do
        for _, descendant in ipairs(pallet:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Color = selectedColor
                descendant.Material = material
                partCount = partCount + 1
            end
        end
    end
    return #pallets, partCount
end

local function applyToPallet(pallet)
    if not pallet or not pallet:IsA("Model") then
        return
    end
    local material = materials[selectedMaterial] or Enum.Material.Wood
    for _, descendant in ipairs(pallet:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Color = selectedColor
            descendant.Material = material
        end
    end
end

window.AddSection(window, { Name = "Color", Tab = editorTab })
window.AddDropdown(window, {
    Title = "Select Color",
    Description = "Choose a color for all pallets",
    Tab = editorTab,
    Options = {
        Brown = Color3.fromRGB(139, 69, 19),
        Red = Color3.fromRGB(255, 0, 0),
        Green = Color3.fromRGB(0, 255, 0),
        Blue = Color3.fromRGB(0, 0, 255),
        Yellow = Color3.fromRGB(255, 255, 0),
        Purple = Color3.fromRGB(128, 0, 128),
        Orange = Color3.fromRGB(255, 165, 0),
        Pink = Color3.fromRGB(255, 192, 203),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
        Gray = Color3.fromRGB(128, 128, 128),
        Cyan = Color3.fromRGB(0, 255, 255),
        Gold = Color3.fromRGB(255, 215, 0),
        Silver = Color3.fromRGB(192, 192, 192)
    },
    Callback = function(color)
        selectedColor = color
        saveSettings()
        local count, parts = applyToAllPallets()
        window.Notify(window, {
            Title = "Color Updated",
            Description = count .. " pallets (" .. parts .. " parts)",
            Duration = 2
        })
    end
})

window.AddSection(window, { Name = "Material", Tab = editorTab })
local materialOptions = {}
for name, _ in pairs(materials) do
    materialOptions[name] = name
end
window.AddDropdown(window, {
    Title = "Select Material",
    Description = "Choose a material for all pallets",
    Tab = editorTab,
    Options = materialOptions,
    Callback = function(material)
        selectedMaterial = material
        saveSettings()
        local count, parts = applyToAllPallets()
        window.Notify(window, {
            Title = "Material Updated",
            Description = count .. " pallets (" .. parts .. " parts)",
            Duration = 2
        })
    end
})

window.AddSection(window, { Name = "Options", Tab = editorTab })
window.AddToggle(window, {
    Title = "Auto-Apply New Pallets",
    Description = "Automatically update new pallets",
    Default = autoApply,
    Tab = editorTab,
    Callback = function(value)
        autoApply = value
        saveSettings()
    end
})

window.AddButton(window, {
    Title = "Update All Pallets",
    Description = "Apply current settings to all pallets",
    Tab = editorTab,
    Callback = function()
        local count, parts = applyToAllPallets()
        window.Notify(window, {
            Title = "Updated!",
            Description = count .. " pallets (" .. parts .. " parts)",
            Duration = 2
        })
    end
})

window.AddButton(window, {
    Title = "Reset to Default",
    Description = "Reset to Brown + Wood",
    Tab = editorTab,
    Callback = function()
        selectedColor = Color3.fromRGB(139, 69, 19)
        selectedMaterial = "Wood"
        autoApply = true
        saveSettings()
        local count, parts = applyToAllPallets()
        window.Notify(window, {
            Title = "Reset!",
            Description = count .. " pallets reset",
            Duration = 2
        })
    end
})

window.AddButton(window, {
    Title = "Count Pallets",
    Description = "Count all pallets on map",
    Tab = editorTab,
    Callback = function()
        local pallets = findPallets()
        local partCount = 0
        for _, pallet in ipairs(pallets) do
            for _, descendant in ipairs(pallet:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    partCount = partCount + 1
                end
            end
        end
        window.Notify(window, {
            Title = "Count",
            Description = #pallets .. " pallets (" .. partCount .. " parts)",
            Duration = 3
        })
    end
})

local graphicsTab = window.AddTab(window, {
    Title = "Graphics",
    Section = "Graphics",
    Icon = "rbxassetid://11293977610"
})

local function applyLowGraphics()
    lighting.Brightness = 0.5
    lighting.ClockTime = 12
    lighting.Ambient = Color3.fromRGB(80, 80, 80)
    lighting.GlobalShadows = false
    lighting.EnvironmentDiffuseScale = 0.5
    lighting.EnvironmentSpecularScale = 0.5
    if lighting:FindFirstChild("SunRays") then
        lighting.SunRays.Enabled = false
    end
    if lighting:FindFirstChild("DepthOfField") then
        lighting.DepthOfField.Enabled = false
    end
    if lighting:FindFirstChild("Bloom") then
        lighting.Bloom.Enabled = false
    end
    if lighting:FindFirstChild("ColorCorrection") then
        lighting.ColorCorrection.Enabled = false
    end
    if lighting:FindFirstChild("Atmosphere") then
        lighting.Atmosphere.Enabled = false
    end
    if lighting:FindFirstChild("Blur") then
        lighting.Blur.Enabled = false
    end
    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = 70
    end
    window.Notify(window, {
        Title = "LOW Graphics Applied!",
        Description = "Clean, sharp, minimal style",
        Duration = 2
    })
end

window.AddSection(window, { Name = "Graphics Style", Tab = graphicsTab })
window.AddButton(window, {
    Title = "LOW Graphics",
    Description = "Clean, sharp, minimal style - NO effects",
    Tab = graphicsTab,
    Callback = function()
        applyLowGraphics()
    end
})

window.AddSection(window, { Name = "Field of View (FOV)", Tab = graphicsTab })
window.AddSlider(window, {
    Title = "FOV",
    Description = "Adjust camera Field of View (1-120)",
    Tab = graphicsTab,
    MinValue = 1,
    MaxValue = 120,
    AllowDecimals = false,
    Default = 70,
    Callback = function(value)
        local camera = workspace.CurrentCamera
        if camera then
            camera.FieldOfView = value
        end
    end
})

window.AddButton(window, {
    Title = "Reset FOV",
    Description = "Reset FOV to default (70)",
    Tab = graphicsTab,
    Callback = function()
        local camera = workspace.CurrentCamera
        if camera then
            camera.FieldOfView = 70
            window.Notify(window, {
                Title = "FOV Reset",
                Description = "Field of View: 70",
                Duration = 1
            })
        end
    end
})

window.AddSection(window, { Name = "Additional Settings", Tab = graphicsTab })
window.AddSlider(window, {
    Title = "Brightness",
    Description = "Adjust lighting brightness (0-3)",
    Tab = graphicsTab,
    MinValue = 0,
    MaxValue = 3,
    AllowDecimals = true,
    Default = 0.5,
    Callback = function(value)
        lighting.Brightness = value
    end
})

window.AddSlider(window, {
    Title = "Time of Day",
    Description = "Change the time of day (0-24)",
    Tab = graphicsTab,
    MinValue = 0,
    MaxValue = 24,
    AllowDecimals = true,
    Default = 12,
    Callback = function(value)
        lighting.ClockTime = value
    end
})

window.AddToggle(window, {
    Title = "Global Shadows",
    Description = "Enable/disable global shadows",
    Default = false,
    Tab = graphicsTab,
    Callback = function(value)
        lighting.GlobalShadows = value
    end
})

window.AddToggle(window, {
    Title = "Bloom Effect",
    Description = "Enable/disable bloom",
    Default = false,
    Tab = graphicsTab,
    Callback = function(value)
        if lighting:FindFirstChild("Bloom") then
            lighting.Bloom.Enabled = value
        end
    end
})

window.AddToggle(window, {
    Title = "Atmosphere",
    Description = "Enable/disable atmosphere",
    Default = false,
    Tab = graphicsTab,
    Callback = function(value)
        if lighting:FindFirstChild("Atmosphere") then
            lighting.Atmosphere.Enabled = value
        end
    end
})

local espTab = window.AddTab(window, {
    Title = "ESP",
    Section = "ESP",
    Icon = "rbxassetid://11293977610"
})

local espEnabled = false
local espData = {}
local espColor = Color3.fromRGB(255, 0, 0)

local function addESP(player)
    if not player or not player.Character then
        return
    end
    local character = player.Character
    if not character then
        return
    end
    local parts = {}
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(parts, descendant)
        end
    end
    if #parts == 0 then
        return
    end
    local highlights = {}
    for _, part in ipairs(parts) do
        local highlight = Instance.new("Highlight")
        highlight.Parent = part
        highlight.Adornee = part
        highlight.FillColor = espColor
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = espColor
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        table.insert(highlights, highlight)
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = rootPart
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = rootPart
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = player.Name
        label.TextColor3 = espColor
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.TextStrokeTransparency = 0.2
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = billboard
        espData[player] = {
            Highlights = highlights,
            Billboard = billboard,
            Label = label
        }
    else
        espData[player] = {
            Highlights = highlights,
            Billboard = nil,
            Label = nil
        }
    end
end

local function removeESP(player)
    if espData[player] then
        if espData[player].Highlights then
            for _, highlight in ipairs(espData[player].Highlights) do
                if highlight and highlight:IsA("Highlight") then
                    highlight:Destroy()
                end
            end
        end
        if espData[player].Billboard then
            espData[player].Billboard:Destroy()
        end
        espData[player] = nil
    end
end

local function setESPColor(color)
    espColor = color
    for player, data in pairs(espData) do
        if data.Highlights then
            for _, highlight in ipairs(data.Highlights) do
                if highlight and highlight:IsA("Highlight") then
                    highlight.FillColor = color
                    highlight.OutlineColor = color
                end
            end
        end
        if data.Label then
            data.Label.TextColor3 = color
        end
    end
end

local function toggleESP(enabled)
    espEnabled = enabled
    if enabled then
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= players.LocalPlayer then
                addESP(player)
            end
        end
        window.Notify(window, {
            Title = "ESP Enabled",
            Description = "Player outlines visible through walls!",
            Duration = 2
        })
    else
        for player, _ in pairs(espData) do
            removeESP(player)
        end
        window.Notify(window, {
            Title = "ESP Disabled",
            Description = "ESP turned off",
            Duration = 2
        })
    end
end

window.AddSection(window, { Name = "ESP Settings", Tab = espTab })
window.AddToggle(window, {
    Title = "Enable ESP",
    Description = "Show players through walls with colored outline",
    Default = false,
    Tab = espTab,
    Callback = function(value)
        toggleESP(value)
    end
})

window.AddSection(window, { Name = "ESP Colors", Tab = espTab })
window.AddDropdown(window, {
    Title = "ESP Color",
    Description = "Choose color for player outline",
    Tab = espTab,
    Options = {
        Red = Color3.fromRGB(255, 0, 0),
        Green = Color3.fromRGB(0, 255, 0),
        Blue = Color3.fromRGB(0, 0, 255),
        Yellow = Color3.fromRGB(255, 255, 0),
        Purple = Color3.fromRGB(128, 0, 128),
        Orange = Color3.fromRGB(255, 165, 0),
        Cyan = Color3.fromRGB(0, 255, 255),
        Pink = Color3.fromRGB(255, 192, 203),
        White = Color3.fromRGB(255, 255, 255)
    },
    Callback = function(color)
        setESPColor(color)
    end
})

window.AddSection(window, { Name = "ESP Settings", Tab = espTab })
window.AddSlider(window, {
    Title = "Fill Transparency",
    Description = "Adjust fill transparency (0-1)",
    Tab = espTab,
    MinValue = 0,
    MaxValue = 1,
    AllowDecimals = true,
    Default = 0.7,
    Callback = function(value)
        for _, data in pairs(espData) do
            if data.Highlights then
                for _, highlight in ipairs(data.Highlights) do
                    if highlight and highlight:IsA("Highlight") then
                        highlight.FillTransparency = value
                    end
                end
            end
        end
    end
})

window.AddSlider(window, {
    Title = "Outline Transparency",
    Description = "Adjust outline transparency (0-1)",
    Tab = espTab,
    MinValue = 0,
    MaxValue = 1,
    AllowDecimals = true,
    Default = 0,
    Callback = function(value)
        for _, data in pairs(espData) do
            if data.Highlights then
                for _, highlight in ipairs(data.Highlights) do
                    if highlight and highlight:IsA("Highlight") then
                        highlight.OutlineTransparency = value
                    end
                end
            end
        end
    end
})

window.AddSection(window, { Name = "ESP Options", Tab = espTab })
window.AddButton(window, {
    Title = "Refresh ESP",
    Description = "Manually refresh ESP for all players",
    Tab = espTab,
    Callback = function()
        if espEnabled then
            for player, _ in pairs(espData) do
                removeESP(player)
            end
            for _, player in ipairs(players:GetPlayers()) do
                if player ~= players.LocalPlayer then
                    addESP(player)
                end
            end
            window.Notify(window, {
                Title = "ESP Refreshed",
                Description = "Updated ESP for all players",
                Duration = 2
            })
        else
            window.Notify(window, {
                Title = "ESP Disabled",
                Description = "Enable ESP first!",
                Duration = 2
            })
        end
    end
})

players.PlayerAdded:Connect(function(player)
    task.wait(0.5)
    if espEnabled then
        addESP(player)
    end
end)

players.PlayerRemoving:Connect(function(player)
    if espEnabled then
        removeESP(player)
    end
end)

local settingsTab = window.AddTab(window, {
    Title = "Settings",
    Section = "Settings",
    Icon = "rbxassetid://11293977610"
})

window.AddKeybind(window, {
    Title = "Minimize Keybind",
    Description = "Set minimize key",
    Tab = settingsTab,
    Callback = function(keybind)
        window.SetSetting(window, "Keybind", keybind)
    end
})

window.AddDropdown(window, {
    Title = "Theme",
    Description = "Change UI theme",
    Tab = settingsTab,
    Options = {
        Light = "Light",
        Dark = "Dark",
        Void = "Void"
    },
    Callback = function(theme)
        window.SetTheme(window, themes[theme])
    end
})

window.AddSlider(window, {
    Title = "UI Transparency",
    Description = "Set UI transparency",
    Tab = settingsTab,
    AllowDecimals = true,
    MaxValue = 1,
    Default = 0.2,
    Callback = function(value)
        window.SetSetting(window, "Transparency", value)
    end
})

window.AddButton(window, {
    Title = "Save Settings",
    Description = "Manually save current settings",
    Tab = settingsTab,
    Callback = function()
        saveSettings()
    end
})

window.AddButton(window, {
    Title = "Load Settings",
    Description = "Manually load settings from file",
    Tab = settingsTab,
    Callback = function()
        local loaded = loadSettings()
        if loaded then
            applyToAllPallets()
            window.Notify(window, {
                Title = "Settings Loaded!",
                Description = "Settings restored from file",
                Duration = 2
            })
        else
            window.Notify(window, {
                Title = "No Settings Found",
                Description = "No saved settings file found",
                Duration = 2
            })
        end
    end
})

workspace.ChildAdded:Connect(function(child)
    task.wait(0.1)
    if autoApply and child:IsA("Model") and child.Name == "PalletLightBrown" then
        applyToPallet(child)
    end
end)

workspace.DescendantAdded:Connect(function(descendant)
    task.wait(0.1)
    if autoApply and descendant:IsA("Model") and descendant.Name == "PalletLightBrown" then
        applyToPallet(descendant)
    end
end)

task.wait(0.5);

(function()
    if not lighting:FindFirstChild("SunRays") then
        local v = Instance.new("SunRaysEffect")
        v.Parent = lighting
        v.Enabled = false
    end
    if not lighting:FindFirstChild("DepthOfField") then
        local v = Instance.new("DepthOfFieldEffect")
        v.Parent = lighting
        v.Enabled = false
    end
    if not lighting:FindFirstChild("Bloom") then
        local v = Instance.new("BloomEffect")
        v.Parent = lighting
        v.Enabled = false
    end
    if not lighting:FindFirstChild("ColorCorrection") then
        local v = Instance.new("ColorCorrectionEffect")
        v.Parent = lighting
        v.Enabled = false
    end
    if not lighting:FindFirstChild("Atmosphere") then
        local v = Instance.new("Atmosphere")
        v.Parent = lighting
        v.Enabled = false
    end
    if not lighting:FindFirstChild("Blur") then
        local v = Instance.new("BlurEffect")
        v.Parent = lighting
        v.Enabled = false
    end
end)()

applyLowGraphics()

local settingsLoaded = loadSettings()
local palletCount, partCount = applyToAllPallets()

window.Notify(window, {
    Title = "Pallet Editor Loaded!",
    Description = palletCount .. " pallets (" .. partCount .. " parts)" .. (settingsLoaded and " Settings Restored" or ""),
    Duration = 4
})

print("Pallet Editor Loaded!")
print("Found " .. palletCount .. " pallets with " .. partCount .. " parts")
