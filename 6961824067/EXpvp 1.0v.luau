--[[
    EXpvp 1.0v — GUI с расширенными функциями
    Инжектор: любой исполнитель (Synapse, Krnl, ScriptWare и т.д.)
    Для игры Fling Things And People (FTAP)
]]

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // НАСТРОЙКИ
local SKYBOX_ID = "15803128405"
local FRIEND_SKYBOX_ID = "169210149"

-- // Переменные
local GUI_ENABLED = true
local SHADER_ENABLED = false
local ESP_ENABLED = false
local AIMBOT_ENABLED = false
local TAB_ENABLED = false
local aimConnection = nil
local espConnections = {}
local musicSound = nil
local skyboxRestoreId = SKYBOX_ID
local shadowsEnabled = false

-- // Параметры шейдера и теней
local shaderWarmth = 0
local shaderColdness = 30
local sunRaysIntensity = 30
local shadowSoftness = 50
local menuColor = Color3.fromRGB(25, 25, 25)  -- цвет меню по умолчанию
local menuScale = 1.0                         -- масштаб меню

-- // Бинды клавиш
local AimbotKey = Enum.KeyCode.Q
local TabKey = Enum.KeyCode.F
local MenuToggleKey = Enum.KeyCode.T
local listeningForBind = nil

-- // Очистка старого GUI
if _G.FTAP_GUI then
    _G.FTAP_GUI:Destroy()
end

-- // Создание GUI (увеличенная высота до 550)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EXpvp_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
_G.FTAP_GUI = ScreenGui

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300 * menuScale, 0, 550 * menuScale)
MainFrame.Position = UDim2.new(0.5, -150 * menuScale, 0.3, 0)
MainFrame.BackgroundColor3 = menuColor
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundColor3 = menuColor
TitleBar.BackgroundTransparency = 0.1
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -10, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "EXpvp 1.0v"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Вкладки
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 25)
TabFrame.Position = UDim2.new(0, 0, 0, 28)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabFrame.BackgroundTransparency = 0.1
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabFrame

local mainTabButton, settingsTabButton
local currentTab = "Main"

local function switchTab(tab)
    currentTab = tab
    for _, child in pairs(MainFrame:GetChildren()) do
        if child.Name == "ContentFrame" then
            child:Destroy()
        end
    end
    if tab == "Main" then
        createMainTab()
        mainTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        settingsTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    elseif tab == "Settings" then
        createSettingsTab()
        mainTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        settingsTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end

mainTabButton = Instance.new("TextButton")
mainTabButton.Size = UDim2.new(0.5, -2, 1, -4)
mainTabButton.Position = UDim2.new(0, 2, 0, 2)
mainTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
mainTabButton.BorderSizePixel = 0
mainTabButton.Text = "Main"
mainTabButton.TextColor3 = Color3.new(1, 1, 1)
mainTabButton.Font = Enum.Font.SourceSansBold
mainTabButton.TextSize = 13
mainTabButton.Parent = TabFrame
local tabBtnCorner1 = Instance.new("UICorner")
tabBtnCorner1.CornerRadius = UDim.new(0, 6)
tabBtnCorner1.Parent = mainTabButton

settingsTabButton = Instance.new("TextButton")
settingsTabButton.Size = UDim2.new(0.5, -2, 1, -4)
settingsTabButton.Position = UDim2.new(0.5, 0, 0, 2)
settingsTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
settingsTabButton.BorderSizePixel = 0
settingsTabButton.Text = "Settings"
settingsTabButton.TextColor3 = Color3.new(1, 1, 1)
settingsTabButton.Font = Enum.Font.SourceSansBold
settingsTabButton.TextSize = 13
settingsTabButton.Parent = TabFrame
local tabBtnCorner2 = Instance.new("UICorner")
tabBtnCorner2.CornerRadius = UDim.new(0, 6)
tabBtnCorner2.Parent = settingsTabButton

mainTabButton.MouseButton1Click:Connect(function()
    switchTab("Main")
end)
settingsTabButton.MouseButton1Click:Connect(function()
    switchTab("Settings")
end)

-- Описание снизу
local DescLabel = Instance.new("TextLabel")
DescLabel.Size = UDim2.new(1, -10, 0, 20)
DescLabel.Position = UDim2.new(0, 5, 1, -25)
DescLabel.BackgroundTransparency = 1
DescLabel.Text = ""
DescLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
DescLabel.Font = Enum.Font.SourceSansBold
DescLabel.TextSize = 11
DescLabel.TextXAlignment = Enum.TextXAlignment.Left
DescLabel.Parent = MainFrame

local function addDescription(guiObject, text)
    if guiObject:IsA("GuiButton") then
        guiObject.MouseEnter:Connect(function()
            DescLabel.Text = text
        end)
        guiObject.MouseLeave:Connect(function()
            DescLabel.Text = ""
        end)
    elseif guiObject:IsA("Frame") then
        guiObject.MouseEnter:Connect(function()
            DescLabel.Text = text
        end)
        guiObject.MouseLeave:Connect(function()
            DescLabel.Text = ""
        end)
    end
end

-- // ================== ФУНКЦИИ ==================
local function applySkybox(assetId)
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end
    local newSky = Instance.new("Sky")
    newSky.SkyboxBk = "rbxassetid://" .. assetId
    newSky.SkyboxDn = "rbxassetid://" .. assetId
    newSky.SkyboxFt = "rbxassetid://" .. assetId
    newSky.SkyboxLf = "rbxassetid://" .. assetId
    newSky.SkyboxRt = "rbxassetid://" .. assetId
    newSky.SkyboxUp = "rbxassetid://" .. assetId
    newSky.Parent = Lighting
end

local function updateSkyboxForShader()
    if SHADER_ENABLED then
        applySkybox(FRIEND_SKYBOX_ID)
    else
        applySkybox(skyboxRestoreId)
    end
end

-- Шейдер (эффекты)
local shaderEffects = {}
local mainColorCorrection = nil
local sunRays1, sunRays2, sunRays3 = nil, nil, nil

local function updateShaderParams()
    if not mainColorCorrection then return end
    local warmFactor = shaderWarmth / 100
    local coldFactor = shaderColdness / 100

    local r = 255
    local g = 255
    local b = 255
    r = r - coldFactor * 80
    g = g - coldFactor * 60
    b = b + coldFactor * 0
    r = math.clamp(r, 100, 255)
    g = math.clamp(g, 120, 255)
    b = math.clamp(b, 150, 255)
    mainColorCorrection.TintColor = Color3.fromRGB(r, g, b)

    local sat = 0.2 - coldFactor * 0.5 + warmFactor * 0.3
    mainColorCorrection.Saturation = sat
    local contrast = 0.1 + (warmFactor - coldFactor) * 0.05
    local brightness = 0.05 + (warmFactor * 0.03) - (coldFactor * 0.02)
    mainColorCorrection.Contrast = contrast
    mainColorCorrection.Brightness = brightness

    local intensity = sunRaysIntensity / 100 * 0.5
    if sunRays1 then sunRays1.Intensity = intensity * 0.2 end
    if sunRays2 then sunRays2.Intensity = intensity * 0.6 end
    if sunRays3 then sunRays3.Intensity = intensity * 1.0 end
end

local function createShaderEffects()
    local sr1 = Instance.new("SunRaysEffect")
    sr1.Enabled = false
    sr1.Parent = Lighting
    table.insert(shaderEffects, sr1)
    sunRays1 = sr1

    local sr2 = Instance.new("SunRaysEffect")
    sr2.Enabled = false
    sr2.Parent = Lighting
    table.insert(shaderEffects, sr2)
    sunRays2 = sr2

    local sr3 = Instance.new("SunRaysEffect")
    sr3.Enabled = false
    sr3.Parent = Lighting
    table.insert(shaderEffects, sr3)
    sunRays3 = sr3

    local mainCC = Instance.new("ColorCorrectionEffect")
    mainCC.Name = "Shader_Main"
    mainCC.Enabled = false
    mainCC.Parent = Lighting
    table.insert(shaderEffects, mainCC)
    mainColorCorrection = mainCC

    local extraCC = Instance.new("ColorCorrectionEffect")
    extraCC.Name = "Shader_Extra"
    extraCC.Enabled = false
    extraCC.TintColor = Color3.fromRGB(160, 190, 255)
    extraCC.Saturation = -0.15
    extraCC.Contrast = 0.05
    extraCC.Parent = Lighting
    table.insert(shaderEffects, extraCC)

    updateShaderParams()
end
createShaderEffects()

local function toggleShader(state)
    if state and not SHADER_ENABLED then
        local currentSky = Lighting:FindFirstChildOfClass("Sky")
        if currentSky then
            local id = currentSky.SkyboxBk:match("%d+")
            if id then skyboxRestoreId = id end
        end
    end
    SHADER_ENABLED = state
    for _, effect in ipairs(shaderEffects) do
        effect.Enabled = state
    end
    if state then
        updateShaderParams()
    end
    updateSkyboxForShader()
end

-- Функции обновления параметров (вызываются из слайдеров)
local function updateWarmth(value)
    shaderWarmth = math.clamp(value, 0, 100)
    if SHADER_ENABLED then updateShaderParams() end
end
local function updateColdness(value)
    shaderColdness = math.clamp(value, 0, 100)
    if SHADER_ENABLED then updateShaderParams() end
end
local function updateSunRays(value)
    sunRaysIntensity = math.clamp(value, 0, 100)
    if SHADER_ENABLED then updateShaderParams() end
end
local function updateShadowSoftness(value)
    shadowSoftness = math.clamp(value, 0, 100)
    if shadowsEnabled then
        Lighting.Technology = Enum.Technology.Future
        Lighting.ShadowSoftness = shadowSoftness / 100
    end
end
local function toggleShadows(state)
    shadowsEnabled = state
    if state then
        Lighting.Technology = Enum.Technology.Future
        Lighting.ShadowSoftness = shadowSoftness / 100
    else
        Lighting.Technology = Enum.Technology.Voxel
        Lighting.ShadowSoftness = 0
    end
end

-- Функции для настроек меню
local function updateMenuColor(color)
    menuColor = color
    MainFrame.BackgroundColor3 = color
    TitleBar.BackgroundColor3 = color
end

local function updateMenuScale(scale)
    menuScale = math.clamp(scale, 0.8, 1.5)
    MainFrame.Size = UDim2.new(0, 300 * menuScale, 0, 550 * menuScale)
    MainFrame.Position = UDim2.new(0.5, -150 * menuScale, 0.3, 0)
end

-- 2. ESP
local function updateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local char = plr.Character
            local highlight = char:FindFirstChild("ESP_Highlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = char
            end
            highlight.FillColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            highlight.OutlineColor = Color3.fromHSV((tick() + 0.5) % 5 / 5, 1, 1)
        end
    end
end

local function toggleESP(state)
    ESP_ENABLED = state
    if not state then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local hl = plr.Character:FindFirstChild("ESP_Highlight")
                if hl then hl:Destroy() end
            end
        end
        if espConnections.render then
            espConnections.render:Disconnect()
            espConnections.render = nil
        end
    else
        espConnections.render = RunService.RenderStepped:Connect(updateESP)
    end
end

-- 3. Оптимизация
local function optimizeMap()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(Player.Character) then
            obj.Material = Enum.Material.SmoothPlastic
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child:Destroy()
                end
            end
        end
    end
end

-- 4. FOV
local fovSliderValue = 70
local function setFOV(value)
    value = math.clamp(value, 30, 120)
    fovSliderValue = value
    Camera.FieldOfView = value
end

-- 5. Яркость
local brightnessValue = 2
local function setBrightness(value)
    value = math.clamp(value, 0, 5)
    brightnessValue = value
    Lighting.Brightness = value
end

-- 6. Aimbot
local function getNearestPlayerToCamera()
    local nearest, minDist = nil, math.huge
    local camPos = Camera.CFrame.Position
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local dist = (head.Position - camPos).Magnitude
            if dist < minDist then
                nearest = head
                minDist = dist
            end
        end
    end
    return nearest
end

local function startAim()
    if aimConnection then return end
    aimConnection = RunService.Heartbeat:Connect(function()
        if AIMBOT_ENABLED then
            local target = getNearestPlayerToCamera()
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end
    end)
end

local function stopAim()
    if aimConnection then
        aimConnection:Disconnect()
        aimConnection = nil
    end
end

local function toggleAimbot(state)
    AIMBOT_ENABLED = state
    if not state then stopAim() end
end

-- 7. TAB
local function freezeCharacter(freeze)
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = freeze
    end
end

-- 8. Статистика
local pingLabel, fpsLabel, uptimeLabel

local function updateStats()
    local ping = math.floor(Player:GetNetworkPing() * 1000)
    if pingLabel then pingLabel.Text = "Ping: " .. ping .. " ms" end
    local fps = math.floor(1 / (RunService.RenderStepped:Wait()))
    if fpsLabel then fpsLabel.Text = "FPS: " .. fps end
    local serverTime = Workspace.DistributedGameTime
    local hours = math.floor(serverTime / 3600)
    local minutes = math.floor((serverTime % 3600) / 60)
    local seconds = math.floor(serverTime % 60)
    if uptimeLabel then uptimeLabel.Text = string.format("Server: %02d:%02d:%02d", hours, minutes, seconds) end
end

spawn(function()
    while true do
        updateStats()
        task.wait(0.5)
    end
end)

-- // ПЕРЕБИНД
local function startRebind(actionName, currentKey)
    listeningForBind = actionName
    DescLabel.Text = "Нажмите новую клавишу для " .. actionName .. "..."
end

UserInputService.InputBegan:Connect(function(input, processed)
    if listeningForBind then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local newKey = input.KeyCode
            if listeningForBind == "Aimbot" then
                AimbotKey = newKey
            elseif listeningForBind == "Tab" then
                TabKey = newKey
            elseif listeningForBind == "Menu" then
                MenuToggleKey = newKey
            end
            listeningForBind = nil
            DescLabel.Text = "Клавиша изменена на " .. newKey.Name
            if currentTab == "Settings" then
                switchTab("Settings")
            end
            task.wait(1.5)
            DescLabel.Text = ""
            return
        end
    end
    if processed then return end
    if input.KeyCode == AimbotKey and AIMBOT_ENABLED then
        startAim()
    elseif input.KeyCode == TabKey and TAB_ENABLED then
        freezeCharacter(true)
    elseif input.KeyCode == MenuToggleKey then
        GUI_ENABLED = not GUI_ENABLED
        MainFrame.Visible = GUI_ENABLED
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == AimbotKey then
        stopAim()
    elseif input.KeyCode == TabKey then
        freezeCharacter(false)
    end
end)

-- // ================== ПОСТРОЕНИЕ ВКЛАДОК ==================
function createMainTab()
    local Content = Instance.new("Frame")
    Content.Name = "ContentFrame"
    Content.Size = UDim2.new(1, 0, 1, -53)
    Content.Position = UDim2.new(0, 0, 0, 53)
    Content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Content.BackgroundTransparency = 0.2
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = Content

    local y = 10
    local step = 28

    -- Shader кнопка
    local shaderBtn = Instance.new("TextButton")
    shaderBtn.Size = UDim2.new(1, -20, 0, 28)
    shaderBtn.Position = UDim2.new(0, 10, 0, y)
    shaderBtn.BackgroundColor3 = SHADER_ENABLED and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    shaderBtn.Text = "Shader: " .. (SHADER_ENABLED and "ON" or "OFF")
    shaderBtn.TextColor3 = Color3.new(1,1,1)
    shaderBtn.BorderSizePixel = 0
    shaderBtn.Font = Enum.Font.SourceSansBold
    shaderBtn.TextSize = 13
    shaderBtn.Parent = Content
    Instance.new("UICorner", shaderBtn).CornerRadius = UDim.new(0,5)
    addDescription(shaderBtn, "Включает весь шейдер (цвет, лучи, скайбокс).")
    shaderBtn.MouseButton1Click:Connect(function()
        SHADER_ENABLED = not SHADER_ENABLED
        toggleShader(SHADER_ENABLED)
        shaderBtn.Text = "Shader: " .. (SHADER_ENABLED and "ON" or "OFF")
        shaderBtn.BackgroundColor3 = SHADER_ENABLED and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    end)
    y = y + step + 6

    -- Warmth слайдер
    local function createSlider(labelText, initialValue, min, max, updateFunc, color, desc)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 30)
        frame.Position = UDim2.new(0, 10, 0, y)
        frame.BackgroundTransparency = 1
        frame.Parent = Content
        addDescription(frame, desc)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 100, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText .. ": " .. initialValue
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.SourceSansBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, -110, 0, 10)
        bg.Position = UDim2.new(0, 110, 0.5, -5)
        bg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        bg.BorderSizePixel = 0
        bg.Parent = frame
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 5)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((initialValue - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = color or Color3.fromRGB(255, 200, 0)
        fill.BorderSizePixel = 0
        fill.Parent = bg
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 5)

        local dragger = Instance.new("TextButton")
        dragger.Size = UDim2.new(0, 16, 0, 16)
        dragger.Position = UDim2.new((initialValue - min) / (max - min), -8, 0.5, -8)
        dragger.BackgroundColor3 = Color3.new(1,1,1)
        dragger.Text = ""
        dragger.BorderSizePixel = 0
        dragger.Parent = bg
        Instance.new("UICorner", dragger).CornerRadius = UDim.new(1, 1)

        local dragging = false
        dragger.MouseButton1Down:Connect(function() dragging = true end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relX = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + relX * (max - min))
                lbl.Text = labelText .. ": " .. val
                fill.Size = UDim2.new(relX, 0, 1, 0)
                dragger.Position = UDim2.new(relX, -8, 0.5, -8)
                updateFunc(val)
            end
        end)
        y = y + step + 6
        return frame
    end

    createSlider("Warmth", shaderWarmth, 0, 100, updateWarmth, Color3.fromRGB(255, 150, 50), "Теплота (0-100) – добавляет красный/жёлтый оттенок.")
    createSlider("Coldness", shaderColdness, 0, 100, updateColdness, Color3.fromRGB(50, 150, 255), "Холодность (0-100) – добавляет синий оттенок.")
    createSlider("SunRays", sunRaysIntensity, 0, 100, updateSunRays, Color3.fromRGB(255, 200, 100), "Интенсивность лучей (0-100).")
    createSlider("Shadow Softness", shadowSoftness, 0, 100, updateShadowSoftness, Color3.fromRGB(150, 150, 150), "Мягкость теней (0-100).")

    -- Shadows кнопка
    local shadowBtn = Instance.new("TextButton")
    shadowBtn.Size = UDim2.new(1, -20, 0, 28)
    shadowBtn.Position = UDim2.new(0, 10, 0, y)
    shadowBtn.BackgroundColor3 = shadowsEnabled and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    shadowBtn.Text = "Shadows: " .. (shadowsEnabled and "ON" or "OFF")
    shadowBtn.TextColor3 = Color3.new(1,1,1)
    shadowBtn.BorderSizePixel = 0
    shadowBtn.Font = Enum.Font.SourceSansBold
    shadowBtn.TextSize = 13
    shadowBtn.Parent = Content
    Instance.new("UICorner", shadowBtn).CornerRadius = UDim.new(0,5)
    addDescription(shadowBtn, "Включает/выключает глобальные тени.")
    shadowBtn.MouseButton1Click:Connect(function()
        shadowsEnabled = not shadowsEnabled
        toggleShadows(shadowsEnabled)
        shadowBtn.Text = "Shadows: " .. (shadowsEnabled and "ON" or "OFF")
        shadowBtn.BackgroundColor3 = shadowsEnabled and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    end)
    y = y + step + 6

    -- ESP
    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(1, -20, 0, 28)
    espBtn.Position = UDim2.new(0, 10, 0, y)
    espBtn.BackgroundColor3 = ESP_ENABLED and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    espBtn.Text = "ESP: " .. (ESP_ENABLED and "ON" or "OFF")
    espBtn.TextColor3 = Color3.new(1,1,1)
    espBtn.BorderSizePixel = 0
    espBtn.Font = Enum.Font.SourceSansBold
    espBtn.TextSize = 13
    espBtn.Parent = Content
    Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,5)
    addDescription(espBtn, "Радужные хитбоксы вокруг игроков.")
    espBtn.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        toggleESP(ESP_ENABLED)
        espBtn.Text = "ESP: " .. (ESP_ENABLED and "ON" or "OFF")
        espBtn.BackgroundColor3 = ESP_ENABLED and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    end)
    y = y + step + 6

    -- Optimization
    local optBtn = Instance.new("TextButton")
    optBtn.Size = UDim2.new(1, -20, 0, 28)
    optBtn.Position = UDim2.new(0, 10, 0, y)
    optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    optBtn.Text = "Optimization"
    optBtn.TextColor3 = Color3.new(1,1,1)
    optBtn.BorderSizePixel = 0
    optBtn.Font = Enum.Font.SourceSansBold
    optBtn.TextSize = 13
    optBtn.Parent = Content
    Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0,5)
    addDescription(optBtn, "Удаляет текстуры карты для повышения FPS.")
    optBtn.MouseButton1Click:Connect(function()
        optimizeMap()
        optBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        optBtn.Text = "Optimization: APPLIED"
        task.wait(2)
        optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        optBtn.Text = "Optimization"
    end)
    y = y + step + 6

    -- FOV слайдер
    local fovFrame = Instance.new("Frame")
    fovFrame.Size = UDim2.new(1, -20, 0, 30)
    fovFrame.Position = UDim2.new(0, 10, 0, y)
    fovFrame.BackgroundTransparency = 1
    fovFrame.Parent = Content
    addDescription(fovFrame, "Поле зрения (30-120).")

    local fovLabel = Instance.new("TextLabel")
    fovLabel.Size = UDim2.new(0, 100, 1, 0)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "FOV: " .. fovSliderValue
    fovLabel.TextColor3 = Color3.new(1,1,1)
    fovLabel.Font = Enum.Font.SourceSansBold
    fovLabel.TextSize = 12
    fovLabel.TextXAlignment = Enum.TextXAlignment.Left
    fovLabel.Parent = fovFrame

    local fovSliderBG = Instance.new("Frame")
    fovSliderBG.Size = UDim2.new(1, -110, 0, 10)
    fovSliderBG.Position = UDim2.new(0, 110, 0.5, -5)
    fovSliderBG.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    fovSliderBG.BorderSizePixel = 0
    fovSliderBG.Parent = fovFrame
    Instance.new("UICorner", fovSliderBG).CornerRadius = UDim.new(0, 5)

    local fovFill = Instance.new("Frame")
    fovFill.Size = UDim2.new((fovSliderValue - 30) / 90, 0, 1, 0)
    fovFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fovFill.BorderSizePixel = 0
    fovFill.Parent = fovSliderBG
    Instance.new("UICorner", fovFill).CornerRadius = UDim.new(0, 5)

    local fovDragger = Instance.new("TextButton")
    fovDragger.Size = UDim2.new(0, 16, 0, 16)
    fovDragger.Position = UDim2.new((fovSliderValue - 30) / 90, -8, 0.5, -8)
    fovDragger.BackgroundColor3 = Color3.new(1,1,1)
    fovDragger.Text = ""
    fovDragger.BorderSizePixel = 0
    fovDragger.Parent = fovSliderBG
    Instance.new("UICorner", fovDragger).CornerRadius = UDim.new(1, 1)

    local draggingFov = false
    fovDragger.MouseButton1Down:Connect(function() draggingFov = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingFov = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingFov and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp((input.Position.X - fovSliderBG.AbsolutePosition.X) / fovSliderBG.AbsoluteSize.X, 0, 1)
            local val = math.floor(30 + relX * 90)
            setFOV(val)
            fovLabel.Text = "FOV: " .. val
            fovFill.Size = UDim2.new(relX, 0, 1, 0)
            fovDragger.Position = UDim2.new(relX, -8, 0.5, -8)
        end
    end)
    y = y + step + 6

    -- Brightness слайдер
    local brightFrame = Instance.new("Frame")
    brightFrame.Size = UDim2.new(1, -20, 0, 30)
    brightFrame.Position = UDim2.new(0, 10, 0, y)
    brightFrame.BackgroundTransparency = 1
    brightFrame.Parent = Content
    addDescription(brightFrame, "Яркость освещения (0-5).")

    local brightLabel = Instance.new("TextLabel")
    brightLabel.Size = UDim2.new(0, 100, 1, 0)
    brightLabel.BackgroundTransparency = 1
    brightLabel.Text = "Brightness: " .. brightnessValue
    brightLabel.TextColor3 = Color3.new(1,1,1)
    brightLabel.Font = Enum.Font.SourceSansBold
    brightLabel.TextSize = 12
    brightLabel.TextXAlignment = Enum.TextXAlignment.Left
    brightLabel.Parent = brightFrame

    local brightSliderBG = Instance.new("Frame")
    brightSliderBG.Size = UDim2.new(1, -110, 0, 10)
    brightSliderBG.Position = UDim2.new(0, 110, 0.5, -5)
    brightSliderBG.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    brightSliderBG.BorderSizePixel = 0
    brightSliderBG.Parent = brightFrame
    Instance.new("UICorner", brightSliderBG).CornerRadius = UDim.new(0, 5)

    local brightFill = Instance.new("Frame")
    brightFill.Size = UDim2.new(brightnessValue / 5, 0, 1, 0)
    brightFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    brightFill.BorderSizePixel = 0
    brightFill.Parent = brightSliderBG
    Instance.new("UICorner", brightFill).CornerRadius = UDim.new(0, 5)

    local brightDragger = Instance.new("TextButton")
    brightDragger.Size = UDim2.new(0, 16, 0, 16)
    brightDragger.Position = UDim2.new(brightnessValue / 5, -8, 0.5, -8)
    brightDragger.BackgroundColor3 = Color3.new(1,1,1)
    brightDragger.Text = ""
    brightDragger.BorderSizePixel = 0
    brightDragger.Parent = brightSliderBG
    Instance.new("UICorner", brightDragger).CornerRadius = UDim.new(1, 1)

    local draggingBright = false
    brightDragger.MouseButton1Down:Connect(function() draggingBright = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingBright = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingBright and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp((input.Position.X - brightSliderBG.AbsolutePosition.X) / brightSliderBG.AbsoluteSize.X, 0, 1)
            local val = math.floor(relX * 5 * 10 + 0.5) / 10
            val = math.clamp(val, 0, 5)
            setBrightness(val)
            brightLabel.Text = "Brightness: " .. string.format("%.1f", val)
            brightFill.Size = UDim2.new(val / 5, 0, 1, 0)
            brightDragger.Position = UDim2.new(val / 5, -8, 0.5, -8)
        end
    end)
    y = y + step + 6

    -- Aimbot
    local aimBtn = Instance.new("TextButton")
    aimBtn.Size = UDim2.new(1, -20, 0, 28)
    aimBtn.Position = UDim2.new(0, 10, 0, y)
    aimBtn.BackgroundColor3 = AIMBOT_ENABLED and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    aimBtn.Text = "Aimbot: " .. (AIMBOT_ENABLED and "ON" or "OFF")
    aimBtn.TextColor3 = Color3.new(1,1,1)
    aimBtn.BorderSizePixel = 0
    aimBtn.Font = Enum.Font.SourceSansBold
    aimBtn.TextSize = 13
    aimBtn.Parent = Content
    Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0,5)
    addDescription(aimBtn, "Автоприцел при зажатии " .. AimbotKey.Name .. ".")
    aimBtn.MouseButton1Click:Connect(function()
        AIMBOT_ENABLED = not AIMBOT_ENABLED
        toggleAimbot(AIMBOT_ENABLED)
        aimBtn.Text = "Aimbot: " .. (AIMBOT_ENABLED and "ON" or "OFF")
        aimBtn.BackgroundColor3 = AIMBOT_ENABLED and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    end)
    y = y + step + 6

    -- TAB
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -20, 0, 28)
    tabBtn.Position = UDim2.new(0, 10, 0, y)
    tabBtn.BackgroundColor3 = TAB_ENABLED and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    tabBtn.Text = "TAB: " .. (TAB_ENABLED and "ON" or "OFF")
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.BorderSizePixel = 0
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 13
    tabBtn.Parent = Content
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0,5)
    addDescription(tabBtn, "Зависание при зажатии " .. TabKey.Name .. ".")
    tabBtn.MouseButton1Click:Connect(function()
        TAB_ENABLED = not TAB_ENABLED
        tabBtn.Text = "TAB: " .. (TAB_ENABLED and "ON" or "OFF")
        tabBtn.BackgroundColor3 = TAB_ENABLED and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 50, 50)
    end)
    y = y + step + 6

    -- Статистика
    local statFrame = Instance.new("Frame")
    statFrame.Size = UDim2.new(1, -20, 0, 50)
    statFrame.Position = UDim2.new(0, 10, 0, y)
    statFrame.BackgroundTransparency = 0.7
    statFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    statFrame.BorderSizePixel = 0
    statFrame.Parent = Content
    Instance.new("UICorner", statFrame).CornerRadius = UDim.new(0,5)

    pingLabel = Instance.new("TextLabel")
    pingLabel.Size = UDim2.new(1, -10, 0, 14)
    pingLabel.Position = UDim2.new(0, 5, 0, 4)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "Ping: --"
    pingLabel.TextColor3 = Color3.new(1,1,1)
    pingLabel.Font = Enum.Font.SourceSansBold
    pingLabel.TextSize = 11
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left
    pingLabel.Parent = statFrame

    fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(1, -10, 0, 14)
    fpsLabel.Position = UDim2.new(0, 5, 0, 18)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: --"
    fpsLabel.TextColor3 = Color3.new(1,1,1)
    fpsLabel.Font = Enum.Font.SourceSansBold
    fpsLabel.TextSize = 11
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = statFrame

    uptimeLabel = Instance.new("TextLabel")
    uptimeLabel.Size = UDim2.new(1, -10, 0, 14)
    uptimeLabel.Position = UDim2.new(0, 5, 0, 32)
    uptimeLabel.BackgroundTransparency = 1
    uptimeLabel.Text = "Server: --:--:--"
    uptimeLabel.TextColor3 = Color3.new(1,1,1)
    uptimeLabel.Font = Enum.Font.SourceSansBold
    uptimeLabel.TextSize = 11
    uptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    uptimeLabel.Parent = statFrame
end

-- // Новая вкладка Settings
function createSettingsTab()
    local Content = Instance.new("Frame")
    Content.Name = "ContentFrame"
    Content.Size = UDim2.new(1, 0, 1, -53)
    Content.Position = UDim2.new(0, 0, 0, 53)
    Content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Content.BackgroundTransparency = 0.2
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = Content

    local y = 10
    local step = 28

    -- Закрыть скрипт
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(1, -20, 0, 28)
    closeBtn.Position = UDim2.new(0, 10, 0, y)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "Close Script"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 14
    closeBtn.Parent = Content
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,5)
    addDescription(closeBtn, "Полностью удаляет GUI и скрипт.")
    closeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    y = y + step + 6

    -- Keybinds
    local bindLabel = Instance.new("TextLabel")
    bindLabel.Size = UDim2.new(1, -20, 0, 18)
    bindLabel.Position = UDim2.new(0, 10, 0, y)
    bindLabel.BackgroundTransparency = 1
    bindLabel.Text = "Keybinds:"
    bindLabel.TextColor3 = Color3.new(1,1,1)
    bindLabel.Font = Enum.Font.SourceSansBold
    bindLabel.TextSize = 12
    bindLabel.TextXAlignment = Enum.TextXAlignment.Left
    bindLabel.Parent = Content
    y = y + 22

    local function createBindRow(actionName, currentKey)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -20, 0, 25)
        row.Position = UDim2.new(0, 10, 0, y)
        row.BackgroundTransparency = 1
        row.Parent = Content

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 100, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = actionName .. ":"
        nameLabel.TextColor3 = Color3.new(1,1,1)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 12
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = row

        local keyLabel = Instance.new("TextLabel")
        keyLabel.Size = UDim2.new(0, 60, 1, 0)
        keyLabel.Position = UDim2.new(0, 105, 0, 0)
        keyLabel.BackgroundTransparency = 1
        keyLabel.Text = currentKey.Name
        keyLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        keyLabel.Font = Enum.Font.SourceSansBold
        keyLabel.TextSize = 12
        keyLabel.Parent = row

        local rebindBtn = Instance.new("TextButton")
        rebindBtn.Size = UDim2.new(0, 70, 1, 0)
        rebindBtn.Position = UDim2.new(1, -70, 0, 0)
        rebindBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        rebindBtn.Text = "Rebind"
        rebindBtn.TextColor3 = Color3.new(1,1,1)
        rebindBtn.BorderSizePixel = 0
        rebindBtn.Font = Enum.Font.SourceSansBold
        rebindBtn.TextSize = 11
        rebindBtn.Parent = row
        Instance.new("UICorner", rebindBtn).CornerRadius = UDim.new(0,4)
        addDescription(rebindBtn, "Нажмите, затем новую клавишу для " .. actionName)
        rebindBtn.MouseButton1Click:Connect(function()
            startRebind(actionName, currentKey)
        end)

        return row
    end

    createBindRow("Aimbot", AimbotKey)
    y = y + 30
    createBindRow("Tab", TabKey)
    y = y + 30
    createBindRow("Menu Toggle", MenuToggleKey)
    y = y + 35

    -- Палитра цветов
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Size = UDim2.new(1, -20, 0, 18)
    colorLabel.Position = UDim2.new(0, 10, 0, y)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = "Menu Color:"
    colorLabel.TextColor3 = Color3.new(1,1,1)
    colorLabel.Font = Enum.Font.SourceSansBold
    colorLabel.TextSize = 12
    colorLabel.TextXAlignment = Enum.TextXAlignment.Left
    colorLabel.Parent = Content
    y = y + 22

    local colorFrame = Instance.new("Frame")
    colorFrame.Size = UDim2.new(1, -20, 0, 30)
    colorFrame.Position = UDim2.new(0, 10, 0, y)
    colorFrame.BackgroundTransparency = 1
    colorFrame.Parent = Content

    local colors = {
        {Color3.fromRGB(25,25,25), "Тёмный"},
        {Color3.fromRGB(50,50,50), "Серый"},
        {Color3.fromRGB(200,200,200), "Светлый"},
        {Color3.fromRGB(30, 70, 150), "Синий"},
        {Color3.fromRGB(40, 140, 60), "Зелёный"},
        {Color3.fromRGB(180, 50, 50), "Красный"},
        {Color3.fromRGB(140, 50, 180), "Фиолетовый"},
        {Color3.fromRGB(220, 140, 40), "Оранжевый"}
    }

    for i, data in ipairs(colors) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 28, 0, 28)
        btn.Position = UDim2.new((i-1) / #colors, 2, 0, 0)
        btn.BackgroundColor3 = data[1]
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = 0.2
        btn.Text = ""
        btn.Parent = colorFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        addDescription(btn, data[2] .. " цвет")
        btn.MouseButton1Click:Connect(function()
            updateMenuColor(data[1])
        end)
    end
    y = y + 36

    -- Ползунок размера
    local scaleFrame = Instance.new("Frame")
    scaleFrame.Size = UDim2.new(1, -20, 0, 30)
    scaleFrame.Position = UDim2.new(0, 10, 0, y)
    scaleFrame.BackgroundTransparency = 1
    scaleFrame.Parent = Content
    addDescription(scaleFrame, "Размер меню (0.8 - 1.5).")

    local scaleLabel = Instance.new("TextLabel")
    scaleLabel.Size = UDim2.new(0, 100, 1, 0)
    scaleLabel.BackgroundTransparency = 1
    scaleLabel.Text = "Size: " .. string.format("%.2f", menuScale)
    scaleLabel.TextColor3 = Color3.new(1,1,1)
    scaleLabel.Font = Enum.Font.SourceSansBold
    scaleLabel.TextSize = 12
    scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
    scaleLabel.Parent = scaleFrame

    local scaleSliderBG = Instance.new("Frame")
    scaleSliderBG.Size = UDim2.new(1, -110, 0, 10)
    scaleSliderBG.Position = UDim2.new(0, 110, 0.5, -5)
    scaleSliderBG.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    scaleSliderBG.BorderSizePixel = 0
    scaleSliderBG.Parent = scaleFrame
    Instance.new("UICorner", scaleSliderBG).CornerRadius = UDim.new(0, 5)

    local scaleFill = Instance.new("Frame")
    scaleFill.Size = UDim2.new((menuScale - 0.8) / 0.7, 0, 1, 0)
    scaleFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    scaleFill.BorderSizePixel = 0
    scaleFill.Parent = scaleSliderBG
    Instance.new("UICorner", scaleFill).CornerRadius = UDim.new(0, 5)

    local scaleDragger = Instance.new("TextButton")
    scaleDragger.Size = UDim2.new(0, 16, 0, 16)
    scaleDragger.Position = UDim2.new((menuScale - 0.8) / 0.7, -8, 0.5, -8)
    scaleDragger.BackgroundColor3 = Color3.new(1,1,1)
    scaleDragger.Text = ""
    scaleDragger.BorderSizePixel = 0
    scaleDragger.Parent = scaleSliderBG
    Instance.new("UICorner", scaleDragger).CornerRadius = UDim.new(1, 1)

    local draggingScale = false
    scaleDragger.MouseButton1Down:Connect(function() draggingScale = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingScale = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingScale and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp((input.Position.X - scaleSliderBG.AbsolutePosition.X) / scaleSliderBG.AbsoluteSize.X, 0, 1)
            local val = 0.8 + relX * 0.7
            val = math.round(val * 100) / 100
            scaleLabel.Text = "Size: " .. string.format("%.2f", val)
            scaleFill.Size = UDim2.new(relX, 0, 1, 0)
            scaleDragger.Position = UDim2.new(relX, -8, 0.5, -8)
            updateMenuScale(val)
        end
    end)
    y = y + 36
end

-- Инициализация
switchTab("Main")