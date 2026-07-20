local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CloudHub = Instance.new("ScreenGui")
CloudHub.Name = "CloudHub"
CloudHub.DisplayOrder = 999
CloudHub.ResetOnSpawn = false
CloudHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
CloudHub.Parent = playerGui

local splashScreenActive = true

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local isTablet = isMobile and (GuiService:GetScreenResolution().X > 1000)

local mobileTextSize = isTablet and 14 or 16
local mobileTitleSize = isTablet and 16 or 18
local mainFrameWidth = isMobile and (isTablet and 600 or 450) or 650
local mainFrameHeight = isMobile and (isTablet and 450 or 350) or 450

local function saveSettings()
end

local function loadSettings()
end

local function showSplashScreen()
    local SplashFrame = Instance.new("Frame")
    SplashFrame.Name = "SplashFrame"
    SplashFrame.Size = UDim2.new(1, 0, 1, 0)
    SplashFrame.BackgroundTransparency = 1
    SplashFrame.BorderSizePixel = 0
    SplashFrame.ZIndex = 1000
    SplashFrame.Parent = CloudHub

    local MainText = Instance.new("TextLabel")
    MainText.Name = "MainText"
    MainText.Size = UDim2.new(0, 400, 0, 80)
    MainText.Position = UDim2.new(0.5, -200, 0.5, -60)
    MainText.BackgroundTransparency = 1
    MainText.Text = "CLOUD VISUAL"
    MainText.TextColor3 = Color3.new(1, 1, 1)
    MainText.TextTransparency = 1
    MainText.TextSize = 36
    MainText.Font = Enum.Font.GothamBold
    MainText.ZIndex = 1001
    MainText.Parent = SplashFrame

    local SubText = Instance.new("TextLabel")
    SubText.Name = "SubText"
    SubText.Size = UDim2.new(0, 400, 0, 40)
    SubText.Position = UDim2.new(0.5, -200, 0.5, 30)
    SubText.BackgroundTransparency = 1
    SubText.Text = "by cloud(vz23z)\nPress Right Shift to open menu"
    SubText.TextColor3 = Color3.new(1, 1, 1)
    SubText.TextTransparency = 1
    SubText.TextSize = 16
    SubText.Font = Enum.Font.Gotham
    SubText.TextWrapped = true
    SubText.ZIndex = 1001
    SubText.Parent = SplashFrame

    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    wait(0.5)
    TweenService:Create(MainText, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(SubText, tweenInfo, {TextTransparency = 0}):Play()
    
    wait(3)
    
    TweenService:Create(MainText, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(SubText, tweenInfo, {TextTransparency = 1}):Play()
    
    wait(1.5)
    SplashFrame:Destroy()
    splashScreenActive = false
end

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 120, 0, 40)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
OpenButton.BackgroundTransparency = 0.2
OpenButton.BorderSizePixel = 0
OpenButton.Text = "CLOUD VISUAL"
OpenButton.TextColor3 = Color3.fromRGB(200, 220, 255)
OpenButton.TextSize = 14
OpenButton.Font = Enum.Font.GothamBold
OpenButton.ZIndex = 10
OpenButton.Visible = false
OpenButton.Parent = CloudHub

local OpenButtonCorner = Instance.new("UICorner")
OpenButtonCorner.CornerRadius = UDim.new(0, 6)
OpenButtonCorner.Parent = OpenButton

local OpenButtonStroke = Instance.new("UIStroke")
OpenButtonStroke.Thickness = 2
OpenButtonStroke.Color = Color3.fromRGB(30, 60, 120)
OpenButtonStroke.Parent = OpenButton

OpenButton.MouseEnter:Connect(function()
    TweenService:Create(OpenButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
end)

OpenButton.MouseLeave:Connect(function()
    TweenService:Create(OpenButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
end)

local StatsFrame = Instance.new("Frame")
StatsFrame.Name = "StatsFrame"
StatsFrame.Size = UDim2.new(0, 150, 0, 100)
StatsFrame.Position = UDim2.new(1, -160, 0, 10)
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
StatsFrame.BackgroundTransparency = 0.3
StatsFrame.BorderSizePixel = 0
StatsFrame.Visible = false
StatsFrame.ZIndex = 100
StatsFrame.Parent = CloudHub

local StatsUICorner = Instance.new("UICorner")
StatsUICorner.CornerRadius = UDim.new(0, 6)
StatsUICorner.Parent = StatsFrame

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "StatsLabel"
StatsLabel.Size = UDim2.new(1, -10, 1, -10)
StatsLabel.Position = UDim2.new(0, 5, 0, 5)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "FPS: 0\nPing: 0ms\nTime: 00:00:00\nSpeed: 0 studs"
StatsLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
StatsLabel.TextSize = 14
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.TextYAlignment = Enum.TextYAlignment.Top
StatsLabel.ZIndex = 101
StatsLabel.Parent = StatsFrame

local draggingStats = false
local dragInputStats
local dragStartStats
local startPosStats

local function updateStatsInput(input)
    local delta = input.Position - dragStartStats
    StatsFrame.Position = UDim2.new(startPosStats.X.Scale, startPosStats.X.Offset + delta.X, startPosStats.Y.Scale, startPosStats.Y.Offset + delta.Y)
end

StatsFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingStats = true
        dragStartStats = input.Position
        startPosStats = StatsFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingStats = false
            end
        end)
    end
end)

StatsFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputStats = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputStats and draggingStats then
        updateStatsInput(input)
    end
end)

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.new(0, 0, 0)
Background.BackgroundTransparency = 0.7
Background.BorderSizePixel = 0
Background.Visible = false
Background.ZIndex = 1
Background.Parent = CloudHub

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 10
BlurEffect.Enabled = false
BlurEffect.Parent = Lighting

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, mainFrameWidth, 0, mainFrameHeight)
MainFrame.Position = UDim2.new(0.5, -mainFrameWidth/2, 0.5, -mainFrameHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.ZIndex = 2
MainFrame.Parent = CloudHub

local dragging = false
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(30, 60, 120)
UIStroke.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BackgroundTransparency = 0.2
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.ZIndex = 10
CloseButton.Parent = MainFrame

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(15, 30, 60)
Title.BackgroundTransparency = 0.5
Title.BorderSizePixel = 0
Title.Text = "CLOUD VISUAL V3.2"
Title.TextColor3 = Color3.fromRGB(200, 220, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 3
Title.Parent = MainFrame

local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(0, 2, 1, -40)
Divider.Position = UDim2.new(0, 150, 0, 40)
Divider.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
Divider.BorderSizePixel = 0
Divider.ZIndex = 3
Divider.Parent = MainFrame

local leftPanelWidth = isMobile and 120 or 150

local LeftPanel = Instance.new("ScrollingFrame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, leftPanelWidth, 1, -40)
LeftPanel.Position = UDim2.new(0, 0, 0, 40)
LeftPanel.BackgroundTransparency = 1
LeftPanel.BorderSizePixel = 0
LeftPanel.ScrollBarThickness = 4
LeftPanel.ScrollBarImageColor3 = Color3.fromRGB(30, 60, 120)
LeftPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
LeftPanel.ZIndex = 3
LeftPanel.Parent = MainFrame

local RightPanel = Instance.new("ScrollingFrame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(1, -leftPanelWidth - 2, 1, -40)
RightPanel.Position = UDim2.new(0, leftPanelWidth + 2, 0, 40)
RightPanel.BackgroundTransparency = 1
RightPanel.BorderSizePixel = 0
RightPanel.ScrollBarThickness = 4
RightPanel.ScrollBarImageColor3 = Color3.fromRGB(30, 60, 120)
RightPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
RightPanel.ZIndex = 3
RightPanel.Parent = MainFrame

RightPanel.ScrollingEnabled = true

local currentLanguage = "English"
local currentTheme = "Blue"

local translations = {
    English = {
        light = "Light",
        season = "Season", 
        shaders = "Shaders",
        other = "Other",
        settings = "Settings",
        textures = "Textures",
        fpsboost = "FPS Boost",
        nightMode = "Night Mode",
        winterMode = "Winter Mode",
        springMode = "Spring Mode",
        summerMode = "Summer Mode",
        autumnMode = "Autumn Mode",
        discoMode = "Disco Mode",
        esp = "ESP",
        lowGraphics = "Low Graphics",
        viewFPS = "View Stats",
        fogIntensity = "Fog Intensity",
        fogColor = "Fog Color",
        lightColor = "Light Color",
        lightSaturation = "Light Saturation",
        fieldOfView = "Field of View",
        language = "Language",
        theme = "Theme",
        aspectRatio43 = "4:3 Aspect Ratio",
        espColor = "ESP Color",
        graphics = "Graphics",
        neon = "Neon",
        midnight = "Midnight",
        vintage = "Vintage",
        credit = "credit by cloud(vz23z)",
        fpsPlaceholder = "FPS: 0\nPing: 0ms\nTime: 00:00:00\nSpeed: 0 studs",
        intensityPlaceholder = "Enter intensity (0-100)",
        saturationPlaceholder = "Enter saturation (0-200)",
        fovPlaceholder = "Enter FOV value (50-120)",
        selectLanguage = "Select Language",
        selectTheme = "Select Theme",
        red = "Red",
        blue = "Blue",
        cyan = "Cyan",
        pink = "Pink",
        purple = "Purple",
        green = "Green",
        yellow = "Yellow",
        white = "White",
        black = "Black",
        gray = "Gray",
        customRGB = "Custom RGB",
        enterR = "R",
        enterG = "G",
        enterB = "B",
        applyRGB = "Apply",
        time = "Time",
        enterTime = "Enter time (0-24)",
        screenBlur = "Screen Blur",
        depthBlur = "Depth Blur",
        rtxGraphics = "RTX Graphics (Irreversible!)",
        pshade = "PShade",
        grassColor = "Grass Color",
        sandColor = "Sand Color",
        rockColor = "Rock Color",
        oceanColor = "Ocean Color",
        snowColor = "Snow Color",
        groundColor = "Ground Color",
        applyTextureColors = "Apply Texture Colors",
        resetTextureColors = "Reset Texture Colors",
        removeTexture = "Remove Texture",
        removeColor = "Remove Color",
        renderDistance = "Render Distance",
        simpleLighting = "Simple Lighting",
        enterDistance = "Enter distance (1-100)",
        resetSeasonColors = "Reset Season Colors",
        showHitboxes = "Show Hitboxes",
        saveConfig = "Save Configuration",
        loadConfig = "Load Configuration",
        tail = "Tail",
        fireflies = "Fireflies",
        timeCycle = "Time Cycle",
        realTime = "Real Time",
        tailLength = "Tail Length",
        fireflyCount = "Firefly Count",
        fireflyColor = "Firefly Color",
        tailColor = "Tail Color",
        crosshair = "Crosshair",
        crosshairColor = "Crosshair Color"
    },
    Russian = {
        light = "Свет",
        season = "Сезон", 
        shaders = "Шейдеры",
        other = "Другое",
        settings = "Настройки",
        textures = "Текстуры",
        fpsboost = "Буст ФПС",
        nightMode = "Ночной режим",
        winterMode = "Зимний режим",
        springMode = "Весенний режим",
        summerMode = "Летний режим",
        autumnMode = "Осенний режим",
        discoMode = "Диско режим",
        esp = "ESP",
        lowGraphics = "Низкая графика",
        viewFPS = "Показать статист.",
        fogIntensity = "Интенсивность тумана",
        fogColor = "Цвет тумана",
        lightColor = "Цвет света",
        lightSaturation = "Насыщенность света",
        fieldOfView = "Поле зрения",
        language = "Язык",
        theme = "Тема",
        aspectRatio43 = "Соотношение 4:3",
        espColor = "Цвет ESP",
        graphics = "Графика",
        neon = "Неон",
        midnight = "Полночь",
        vintage = "Винтаж",
        credit = "автор: cloud(vz23z)",
        fpsPlaceholder = "FPS: 0\nПинг: 0мс\nВремя: 00:00:00\nСкорость: 0 studs",
        intensityPlaceholder = "Введите интенсивность (0-100)",
        saturationPlaceholder = "Введите насыщенность (0-200)",
        fovPlaceholder = "Введите значение FOV (50-120)",
        selectLanguage = "Выберите язык",
        selectTheme = "Выберите тему",
        red = "Красный",
        blue = "Синий",
        cyan = "Голубой",
        pink = "Розовый",
        purple = "Фиолетовый",
        green = "Зеленый",
        yellow = "Желтый",
        white = "Белый",
        black = "Черный",
        gray = "Серый",
        customRGB = "Свой RGB",
        enterR = "R",
        enterG = "G",
        enterB = "B",
        applyRGB = "Применить",
        time = "Время",
        enterTime = "Введите время (0-24)",
        screenBlur = "Размытие экрана",
        depthBlur = "Размытие вдали",
        rtxGraphics = "RTX Графика (Необратимо!)",
        pshade = "PShade",
        grassColor = "Цвет травы",
        sandColor = "Цвет песка",
        rockColor = "Цвет скал",
        oceanColor = "Цвет океана",
        snowColor = "Цвет снега",
        groundColor = "Цвет земли",
        applyTextureColors = "Применить цвета",
        resetTextureColors = "Сбросить цвета",
        removeTexture = "Удалить текстуры",
        removeColor = "Удалить цвета",
        renderDistance = "Дальность прорисовки",
        simpleLighting = "Простое освещение",
        enterDistance = "Введите расстояние (1-100)",
        resetSeasonColors = "Сбросить цвета сезона",
        showHitboxes = "Показать хитбоксы",
        saveConfig = "Сохранить конфиг",
        loadConfig = "Загрузить конфиг",
        tail = "Хвост",
        fireflies = "Светлячки",
        timeCycle = "Цикл времени",
        realTime = "Реальное время",
        tailLength = "Длина хвоста",
        fireflyCount = "Кол-во светлячков",
        fireflyColor = "Цвет светлячков",
        tailColor = "Цвет хвоста",
        crosshair = "Прицел",
        crosshairColor = "Цвет прицела"
    },
    Ukrainian = {
        light = "Світло",
        season = "Сезон", 
        shaders = "Шейдери",
        other = "Інше",
        settings = "Налаштування",
        textures = "Текстури",
        fpsboost = "Буст ФПС",
        nightMode = "Нічний режим",
        winterMode = "Зимовий режим",
        springMode = "Весняний режим",
        summerMode = "Літній режим",
        autumnMode = "Осінній режим",
        discoMode = "Діско режим",
        esp = "ESP",
        lowGraphics = "Низька графіка",
        viewFPS = "Показати статист.",
        fogIntensity = "Інтенсивність туману",
        fogColor = "Колір туману",
        lightColor = "Колір світла",
        lightSaturation = "Насиченість світла",
        fieldOfView = "Поле зору",
        language = "Мова",
        theme = "Тема",
        aspectRatio43 = "Співвідношення 4:3",
        espColor = "Колір ESP",
        graphics = "Графіка",
        neon = "Неон",
        midnight = "Північ",
        vintage = "Вінтаж",
        credit = "автор: cloud(vz23z)",
        fpsPlaceholder = "FPS: 0\nПінг: 0мс\nЧас: 00:00:00\nШвидкість: 0 studs",
        intensityPlaceholder = "Введіть інтенсивність (0-100)",
        saturationPlaceholder = "Введіть насиченість (0-200)",
        fovPlaceholder = "Введіть значення FOV (50-120)",
        selectLanguage = "Виберіть мову",
        selectTheme = "Виберіть тему",
        red = "Червоний",
        blue = "Синій",
        cyan = "Блакитний",
        pink = "Рожевий",
        purple = "Фіолетовий",
        green = "Зелений",
        yellow = "Жовтий",
        white = "Білий",
        black = "Чорний",
        gray = "Сірий",
        customRGB = "Власний RGB",
        enterR = "R",
        enterG = "G",
        enterB = "B",
        applyRGB = "Застосувати",
        time = "Час",
        enterTime = "Введіть час (0-24)",
        screenBlur = "Розмиття екрану",
        depthBlur = "Розмиття вдалині",
        rtxGraphics = "RTX Графіка (Необоротно!)",
        pshade = "PShade",
        grassColor = "Колір трави",
        sandColor = "Колір піску",
        rockColor = "Колір скель",
        oceanColor = "Колір океану",
        snowColor = "Колір снігу",
        groundColor = "Колір землі",
        applyTextureColors = "Застосувати кольори",
        resetTextureColors = "Скинути кольори",
        removeTexture = "Видалити текстури",
        removeColor = "Видалити кольори",
        renderDistance = "Дальність прорисовки",
        simpleLighting = "Просте освітлення",
        enterDistance = "Введіть відстань (1-100)",
        resetSeasonColors = "Скинути кольори сезону",
        showHitboxes = "Показати хітбокси",
        saveConfig = "Зберегти конфіг",
        loadConfig = "Завантажити конфіг",
        tail = "Хвіст",
        fireflies = "Світлячки",
        timeCycle = "Цикл часу",
        realTime = "Реальний час",
        tailLength = "Довжина хвоста",
        fireflyCount = "Кількість світлячків",
        fireflyColor = "Колір світлячків",
        tailColor = "Колір хвоста",
        crosshair = "Прицел",
        crosshairColor = "Колір прицілу"
    }
}

local themes = {
    Blue = {
        mainColor = Color3.fromRGB(10, 20, 40),
        secondaryColor = Color3.fromRGB(15, 30, 60),
        accentColor = Color3.fromRGB(30, 60, 120),
        textColor = Color3.fromRGB(200, 220, 255),
        buttonColor = Color3.fromRGB(20, 40, 80),
        toggleOn = Color3.fromRGB(50, 150, 255),
        hoverColor = Color3.fromRGB(30, 60, 100)
    },
    Purple = {
        mainColor = Color3.fromRGB(30, 10, 50),
        secondaryColor = Color3.fromRGB(50, 20, 80),
        accentColor = Color3.fromRGB(100, 50, 180),
        textColor = Color3.fromRGB(220, 200, 255),
        buttonColor = Color3.fromRGB(60, 30, 100),
        toggleOn = Color3.fromRGB(150, 80, 220),
        hoverColor = Color3.fromRGB(70, 40, 110)
    },
    Red = {
        mainColor = Color3.fromRGB(40, 10, 10),
        secondaryColor = Color3.fromRGB(60, 15, 15),
        accentColor = Color3.fromRGB(120, 30, 30),
        textColor = Color3.fromRGB(255, 200, 200),
        buttonColor = Color3.fromRGB(80, 20, 20),
        toggleOn = Color3.fromRGB(255, 50, 50),
        hoverColor = Color3.fromRGB(100, 25, 25)
    },
    Green = {
        mainColor = Color3.fromRGB(10, 40, 10),
        secondaryColor = Color3.fromRGB(15, 60, 15),
        accentColor = Color3.fromRGB(30, 120, 30),
        textColor = Color3.fromRGB(200, 255, 200),
        buttonColor = Color3.fromRGB(20, 80, 20),
        toggleOn = Color3.fromRGB(50, 255, 50),
        hoverColor = Color3.fromRGB(25, 100, 25)
    },
    Yellow = {
        mainColor = Color3.fromRGB(40, 35, 5),
        secondaryColor = Color3.fromRGB(60, 50, 10),
        accentColor = Color3.fromRGB(150, 130, 20),
        textColor = Color3.fromRGB(255, 240, 180),
        buttonColor = Color3.fromRGB(80, 70, 15),
        toggleOn = Color3.fromRGB(255, 220, 50),
        hoverColor = Color3.fromRGB(100, 90, 20)
    },
    Cyan = {
        mainColor = Color3.fromRGB(5, 25, 30),
        secondaryColor = Color3.fromRGB(10, 40, 45),
        accentColor = Color3.fromRGB(20, 120, 140),
        textColor = Color3.fromRGB(180, 240, 255),
        buttonColor = Color3.fromRGB(15, 60, 70),
        toggleOn = Color3.fromRGB(50, 200, 230),
        hoverColor = Color3.fromRGB(20, 80, 90)
    },
    Pink = {
        mainColor = Color3.fromRGB(40, 5, 25),
        secondaryColor = Color3.fromRGB(60, 10, 40),
        accentColor = Color3.fromRGB(150, 20, 100),
        textColor = Color3.fromRGB(255, 200, 230),
        buttonColor = Color3.fromRGB(80, 15, 55),
        toggleOn = Color3.fromRGB(255, 80, 180),
        hoverColor = Color3.fromRGB(100, 20, 70)
    },
    Orange = {
        mainColor = Color3.fromRGB(40, 20, 5),
        secondaryColor = Color3.fromRGB(60, 30, 10),
        accentColor = Color3.fromRGB(150, 80, 20),
        textColor = Color3.fromRGB(255, 220, 180),
        buttonColor = Color3.fromRGB(80, 50, 15),
        toggleOn = Color3.fromRGB(255, 140, 50),
        hoverColor = Color3.fromRGB(100, 60, 20)
    },
    Sand = {
        mainColor = Color3.fromRGB(45, 35, 20),
        secondaryColor = Color3.fromRGB(60, 50, 35),
        accentColor = Color3.fromRGB(140, 120, 80),
        textColor = Color3.fromRGB(255, 240, 220),
        buttonColor = Color3.fromRGB(80, 70, 50),
        toggleOn = Color3.fromRGB(200, 180, 140),
        hoverColor = Color3.fromRGB(100, 85, 60)
    },
    Ocean = {
        mainColor = Color3.fromRGB(5, 20, 35),
        secondaryColor = Color3.fromRGB(10, 35, 55),
        accentColor = Color3.fromRGB(20, 100, 160),
        textColor = Color3.fromRGB(180, 230, 255),
        buttonColor = Color3.fromRGB(15, 50, 75),
        toggleOn = Color3.fromRGB(50, 170, 255),
        hoverColor = Color3.fromRGB(20, 65, 95)
    },
    Forest = {
        mainColor = Color3.fromRGB(10, 25, 15),
        secondaryColor = Color3.fromRGB(15, 40, 25),
        accentColor = Color3.fromRGB(30, 100, 60),
        textColor = Color3.fromRGB(200, 240, 210),
        buttonColor = Color3.fromRGB(20, 60, 35),
        toggleOn = Color3.fromRGB(60, 180, 100),
        hoverColor = Color3.fromRGB(25, 75, 45)
    },
    Midnight = {
        mainColor = Color3.fromRGB(5, 5, 15),
        secondaryColor = Color3.fromRGB(10, 10, 25),
        accentColor = Color3.fromRGB(30, 30, 80),
        textColor = Color3.fromRGB(180, 180, 220),
        buttonColor = Color3.fromRGB(15, 15, 40),
        toggleOn = Color3.fromRGB(80, 80, 180),
        hoverColor = Color3.fromRGB(20, 20, 50)
    },
    Lavender = {
        mainColor = Color3.fromRGB(25, 15, 35),
        secondaryColor = Color3.fromRGB(40, 25, 55),
        accentColor = Color3.fromRGB(100, 70, 140),
        textColor = Color3.fromRGB(230, 210, 255),
        buttonColor = Color3.fromRGB(60, 40, 80),
        toggleOn = Color3.fromRGB(160, 120, 200),
        hoverColor = Color3.fromRGB(75, 50, 100)
    },
    Coral = {
        mainColor = Color3.fromRGB(40, 15, 20),
        secondaryColor = Color3.fromRGB(60, 25, 30),
        accentColor = Color3.fromRGB(160, 60, 80),
        textColor = Color3.fromRGB(255, 210, 220),
        buttonColor = Color3.fromRGB(80, 35, 45),
        toggleOn = Color3.fromRGB(255, 100, 120),
        hoverColor = Color3.fromRGB(100, 40, 55)
    },
    Emerald = {
        mainColor = Color3.fromRGB(5, 25, 20),
        secondaryColor = Color3.fromRGB(10, 40, 30),
        accentColor = Color3.fromRGB(20, 120, 90),
        textColor = Color3.fromRGB(180, 240, 220),
        buttonColor = Color3.fromRGB(15, 60, 45),
        toggleOn = Color3.fromRGB(50, 200, 150),
        hoverColor = Color3.fromRGB(20, 75, 60)
    },
    Sunset = {
        mainColor = Color3.fromRGB(40, 15, 10),
        secondaryColor = Color3.fromRGB(60, 25, 15),
        accentColor = Color3.fromRGB(160, 80, 40),
        textColor = Color3.fromRGB(255, 220, 200),
        buttonColor = Color3.fromRGB(80, 40, 25),
        toggleOn = Color3.fromRGB(255, 140, 80),
        hoverColor = Color3.fromRGB(100, 50, 30)
    },
    Arctic = {
        mainColor = Color3.fromRGB(10, 20, 30),
        secondaryColor = Color3.fromRGB(20, 35, 50),
        accentColor = Color3.fromRGB(60, 120, 180),
        textColor = Color3.fromRGB(200, 230, 255),
        buttonColor = Color3.fromRGB(30, 50, 70),
        toggleOn = Color3.fromRGB(100, 180, 255),
        hoverColor = Color3.fromRGB(40, 65, 90)
    },
    Berry = {
        mainColor = Color3.fromRGB(25, 5, 30),
        secondaryColor = Color3.fromRGB(40, 10, 50),
        accentColor = Color3.fromRGB(120, 30, 150),
        textColor = Color3.fromRGB(240, 200, 255),
        buttonColor = Color3.fromRGB(60, 20, 75),
        toggleOn = Color3.fromRGB(180, 60, 220),
        hoverColor = Color3.fromRGB(75, 25, 95)
    },
    Gold = {
        mainColor = Color3.fromRGB(30, 25, 5),
        secondaryColor = Color3.fromRGB(50, 40, 10),
        accentColor = Color3.fromRGB(150, 120, 30),
        textColor = Color3.fromRGB(255, 240, 180),
        buttonColor = Color3.fromRGB(70, 60, 15),
        toggleOn = Color3.fromRGB(220, 180, 50),
        hoverColor = Color3.fromRGB(90, 75, 20)
    },
    Sky = {
        mainColor = Color3.fromRGB(15, 25, 40),
        secondaryColor = Color3.fromRGB(25, 40, 60),
        accentColor = Color3.fromRGB(70, 120, 200),
        textColor = Color3.fromRGB(210, 230, 255),
        buttonColor = Color3.fromRGB(35, 50, 80),
        toggleOn = Color3.fromRGB(120, 170, 255),
        hoverColor = Color3.fromRGB(45, 65, 100)
    }
}

local sections = {
    "Light",
    "Season", 
    "Shaders",
    "Textures",
    "FPS boost",
    "Animation",
    "Other",
    "Settings"
}

local settingsState = {
    nightMode = false,
    winterMode = false,
    springMode = false,
    summerMode = false,
    autumnMode = false,
    discoMode = false,
    esp = false,
    lowGraphics = false,
    viewFPS = false,
    aspectRatio43 = false,
    fogIntensity = 0,
    fieldOfView = 70,
    lightColor = Color3.fromRGB(255, 255, 255),
    lightSaturation = 100,
    fogColor = Color3.fromRGB(255, 255, 255),
    espColor = Color3.fromRGB(255, 0, 0),
    language = "English",
    theme = "Blue",
    currentGraphics = "Default",
    time = 14,
    screenBlur = 0,
    depthBlur = 0,
    textureColors = {
        grass = Color3.fromRGB(0, 170, 0),
        sand = Color3.fromRGB(255, 255, 0),
        rock = Color3.fromRGB(128, 128, 128),
        ocean = Color3.fromRGB(0, 0, 255),
        snow = Color3.fromRGB(255, 255, 255),
        ground = Color3.fromRGB(139, 69, 19)
    },
    removeTexture = false,
    removeColor = false,
    renderDistance = 100,
    simpleLighting = false,
    showHitboxes = false,
    tailEnabled = false,
    firefliesEnabled = false,
    timeCycleEnabled = false,
    realTimeEnabled = false,
    tailLength = 15,
    fireflyCount = 50,
    fireflyColor = Color3.fromRGB(255, 255, 100),
    tailColor = Color3.fromRGB(0, 100, 255),
    crosshairEnabled = false,
    crosshairColor = Color3.fromRGB(255, 255, 255)
}

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local espEnabled = false
local espConnections = {}
local espHighlights = {}
local aspectRatioEnabled = false
local aspectRatioConnection = nil
local winterEnabled = false
local springEnabled = false
local summerEnabled = false
local autumnEnabled = false
local originalMaterials = {}
local originalColors = {}
local nightModeEnabled = false
local discoEnabled = false
local lowGraphicsEnabled = false
local viewFPSEnabled = false
local menuOpen = false
local originalGraphicsSettings = {}
local depthOfFieldEnabled = false
local neonLights = {}
local textureColorsEnabled = false
local originalTextureColors = {}
local removeTextureEnabled = false
local removeColorEnabled = false
local simpleLightingEnabled = false
local originalRenderDistance = 10000
local showHitboxesEnabled = false
local hitboxConnections = {}
local hitboxHighlights = {}

local tailEnabled = false
local firefliesEnabled = false
local tailParts = {}
local tailConnections = {}
local fireflies = {}
local fireflyConnections = {}

local timeCycleEnabled = false
local realTimeEnabled = false
local timeCycleConnection = nil
local realTimeConnection = nil

local crosshairEnabled = false
local crosshairFrame = nil
local crosshairColor = Color3.fromRGB(255, 255, 255)

local draggingCrosshair = false
local dragStartCrosshair
local startPosCrosshair

local snowEnabled = false
local snowflakes = {}
local snowConnections = {}
local lastSnowSpawnTime = 0
local snowCreationTimes = {}

local frameCount = 0
local fps = 0
local lastTime = 0
local startTime = tick()

local graphicsPresets = {
    Default = {
        ambient = Color3.fromRGB(255, 255, 255),
        outdoorAmbient = Color3.fromRGB(255, 255, 255),
        brightness = 1,
        fogColor = Color3.fromRGB(255, 255, 255),
        fogEnd = 100000,
        clockTime = 14,
        globalShadows = true
    },
    Neon = {
        ambient = Color3.fromRGB(0, 0, 0),
        outdoorAmbient = Color3.fromRGB(50, 0, 100),
        brightness = 0.3,
        fogColor = Color3.fromRGB(100, 0, 200),
        fogEnd = 100000,
        clockTime = 0,
        globalShadows = true
    },
    Midnight = {
        ambient = Color3.fromRGB(40, 40, 80),
        outdoorAmbient = Color3.fromRGB(60, 60, 120),
        brightness = 0.6,
        fogColor = Color3.fromRGB(70, 70, 150),
        fogEnd = 100000,
        clockTime = 0,
        globalShadows = true
    },
    Vintage = {
        ambient = Color3.fromRGB(150, 120, 80),
        outdoorAmbient = Color3.fromRGB(180, 150, 100),
        brightness = 0.8,
        fogColor = Color3.fromRGB(200, 180, 120),
        fogEnd = 100000,
        clockTime = 16,
        globalShadows = true
    }
}

local function getText(key)
    return translations[currentLanguage][key] or key
end

local function showNotification(message)
    local notification = Instance.new("TextLabel")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(0.5, -150, 0.1, 0)
    notification.BackgroundColor3 = themes[currentTheme].buttonColor
    notification.BackgroundTransparency = 0.2
    notification.Text = message
    notification.TextColor3 = themes[currentTheme].textColor
    notification.TextSize = mobileTextSize
    notification.Font = Enum.Font.Gotham
    notification.TextWrapped = true
    notification.ZIndex = 1000
    notification.Parent = CloudHub
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 6)
    notifCorner.Parent = notification
    
    notification.BackgroundTransparency = 1
    notification.TextTransparency = 1
    
    TweenService:Create(notification, tweenInfo, {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
    wait(2)
    TweenService:Create(notification, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    
    wait(0.3)
    notification:Destroy()
end

local function updateTheme()
    local theme = themes[currentTheme]
    
    MainFrame.BackgroundColor3 = theme.mainColor
    Title.BackgroundColor3 = theme.secondaryColor
    UIStroke.Color = theme.accentColor
    Title.TextColor3 = theme.textColor
    Divider.BackgroundColor3 = theme.accentColor
    LeftPanel.ScrollBarImageColor3 = theme.accentColor
    RightPanel.ScrollBarImageColor3 = theme.accentColor
    StatsFrame.BackgroundColor3 = theme.buttonColor
    StatsLabel.TextColor3 = theme.textColor
    OpenButton.BackgroundColor3 = theme.buttonColor
    OpenButton.TextColor3 = theme.textColor
    OpenButtonStroke.Color = theme.accentColor
    Background.BackgroundColor3 = Color3.new(0, 0, 0)
    
    CloseButton.BackgroundColor3 = theme.buttonColor
    CloseButton.TextColor3 = theme.textColor
    
    local activeSection = nil
    for _, sectionName in ipairs(sections) do
        local button = LeftPanel:FindFirstChild(sectionName .. "Button")
        if button then
            if button.BackgroundColor3 == themes[currentTheme].accentColor then
                button.BackgroundColor3 = theme.accentColor
                activeSection = sectionName
            else
                button.BackgroundColor3 = theme.buttonColor
            end
            button.TextColor3 = theme.textColor
            
            for _, connection in pairs(button:GetChildren()) do
                if connection:IsA("UIStroke") then
                    connection.Color = theme.accentColor
                end
            end
        end
    end
    
    local creditLabel = LeftPanel:FindFirstChild("Credit")
    if creditLabel then
        creditLabel.TextColor3 = Color3.fromRGB(150, 170, 210)
    end
    
    if activeSection then
        if activeSection == "Light" then
            setupLightSection()
        elseif activeSection == "Season" then
            setupSeasonSection()
        elseif activeSection == "Shaders" then
            setupShadersSection()
        elseif activeSection == "Textures" then
            setupTexturesSection()
        elseif activeSection == "FPS boost" then
            setupFPSBoostSection()
        elseif activeSection == "Animation" then
            setupAnimationSection()
        elseif activeSection == "Other" then
            setupOtherSection()
        elseif activeSection == "Settings" then
            setupSettingsSection()
        end
    end
end

local function animateElement(element, properties)
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    return tween
end

local sectionButtonHeight = isMobile and 35 or 40
local sectionButtonSpacing = isMobile and 5 or 10

local function createSectionButton(sectionName, index)
    local button = Instance.new("TextButton")
    button.Name = sectionName .. "Button"
    button.Size = UDim2.new(1, -10, 0, sectionButtonHeight)
    button.Position = UDim2.new(0, 5, 0, (index-1) * (sectionButtonHeight + sectionButtonSpacing) + 5)
    button.BackgroundColor3 = themes[currentTheme].buttonColor
    button.BorderSizePixel = 0
    button.Text = getText(sectionName:lower())
    button.TextColor3 = themes[currentTheme].textColor
    button.TextSize = isMobile and mobileTextSize or 16
    button.Font = Enum.Font.Gotham
    button.AutoButtonColor = false
    button.ZIndex = 4
    button.Parent = LeftPanel
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Thickness = 1
    buttonStroke.Color = themes[currentTheme].accentColor
    buttonStroke.Transparency = 0.8
    buttonStroke.Parent = button
    
    button.MouseEnter:Connect(function()
        if button.BackgroundColor3 ~= themes[currentTheme].accentColor then
            animateElement(button, {BackgroundColor3 = themes[currentTheme].hoverColor})
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button.BackgroundColor3 ~= themes[currentTheme].accentColor then
            animateElement(button, {BackgroundColor3 = themes[currentTheme].buttonColor})
        end
    end)
    
    return button
end

local function createToggle(nameKey, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = nameKey .. "Toggle"
    toggleFrame.Size = UDim2.new(1, -20, 0, isMobile and 40 or 50)
    toggleFrame.BackgroundColor3 = themes[currentTheme].buttonColor
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 4
    toggleFrame.Parent = RightPanel
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = getText(nameKey)
    label.TextColor3 = themes[currentTheme].textColor
    label.TextSize = isMobile and mobileTextSize or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.ZIndex = 5
    label.Parent = toggleFrame
    
    local toggleBackground = Instance.new("Frame")
    toggleBackground.Name = "ToggleBackground"
    toggleBackground.Size = UDim2.new(0, isMobile and 35 or 40, 0, isMobile and 18 or 20)
    toggleBackground.Position = UDim2.new(1, isMobile and -45 or -50, 0.5, isMobile and -9 or -10)
    toggleBackground.BackgroundColor3 = defaultValue and themes[currentTheme].toggleOn or Color3.fromRGB(60, 60, 80)
    toggleBackground.BorderSizePixel = 0
    toggleBackground.ZIndex = 5
    toggleBackground.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleBackground
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, isMobile and 14 or 16, 0, isMobile and 14 or 16)
    toggleButton.Position = UDim2.new(defaultValue and 1 or 0, defaultValue and (isMobile and -16 or -18) or (isMobile and 2 or 2), 0.5, isMobile and -7 or -8)
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleButton.BorderSizePixel = 0
    toggleButton.ZIndex = 6
    toggleButton.Parent = toggleBackground
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = toggleButton
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.ZIndex = 7
    toggleBtn.Parent = toggleBackground
    
    local isEnabled = defaultValue
    
    local function updateToggle()
        if isEnabled then
            animateElement(toggleButton, {Position = UDim2.new(1, isMobile and -16 or -18, 0.5, isMobile and -7 or -8)})
            animateElement(toggleBackground, {BackgroundColor3 = themes[currentTheme].toggleOn})
        else
            animateElement(toggleButton, {Position = UDim2.new(0, isMobile and 2 or 2, 0.5, isMobile and -7 or -8)})
            animateElement(toggleBackground, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)})
        end
        callback(isEnabled)
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        updateToggle()
    end)
    
    return toggleFrame
end

local function createButton(nameKey, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = nameKey .. "Button"
    buttonFrame.Size = UDim2.new(1, -20, 0, isMobile and 35 or 40)
    buttonFrame.BackgroundColor3 = themes[currentTheme].buttonColor
    buttonFrame.BackgroundTransparency = 0.2
    buttonFrame.BorderSizePixel = 0
    buttonFrame.ZIndex = 4
    buttonFrame.Parent = RightPanel
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = buttonFrame
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = getText(nameKey)
    button.TextColor3 = themes[currentTheme].textColor
    button.TextSize = isMobile and mobileTextSize or 14
    button.Font = Enum.Font.Gotham
    button.ZIndex = 5
    button.Parent = buttonFrame
    
    button.MouseEnter:Connect(function()
        animateElement(buttonFrame, {BackgroundColor3 = themes[currentTheme].hoverColor})
    end)
    
    button.MouseLeave:Connect(function()
        animateElement(buttonFrame, {BackgroundColor3 = themes[currentTheme].buttonColor})
    end)
    
    button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return buttonFrame
end

local function createInputField(nameKey, defaultValue, placeholderKey, callback)
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = nameKey .. "Input"
    inputFrame.Size = UDim2.new(1, -20, 0, isMobile and 50 or 60)
    inputFrame.BackgroundColor3 = themes[currentTheme].buttonColor
    inputFrame.BackgroundTransparency = 0.2
    inputFrame.BorderSizePixel = 0
    inputFrame.ZIndex = 4
    inputFrame.Parent = RightPanel
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = inputFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, isMobile and 18 or 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = getText(nameKey)
    label.TextColor3 = themes[currentTheme].textColor
    label.TextSize = isMobile and mobileTextSize or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.ZIndex = 5
    label.Parent = inputFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, -20, 0, isMobile and 22 or 25)
    textBox.Position = UDim2.new(0, 10, 0, isMobile and 25 or 30)
    textBox.BackgroundColor3 = themes[currentTheme].secondaryColor
    textBox.BorderSizePixel = 0
    textBox.Text = tostring(defaultValue)
    textBox.PlaceholderText = getText(placeholderKey)
    textBox.TextColor3 = themes[currentTheme].textColor
    textBox.TextSize = isMobile and mobileTextSize or 14
    textBox.Font = Enum.Font.Gotham
    textBox.ZIndex = 5
    textBox.Parent = inputFrame
    
    local textBoxCorner = Instance.new("UICorner")
    textBoxCorner.CornerRadius = UDim.new(0, 4)
    textBoxCorner.Parent = textBox
    
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textBox.Text)
        end
    end)
    
    return inputFrame
end

local function createColorPalette(nameKey, defaultColor, callback)
    local colorFrame = Instance.new("Frame")
    colorFrame.Name = nameKey .. "Color"
    colorFrame.Size = UDim2.new(1, -20, 0, isMobile and 160 or 180)
    colorFrame.BackgroundColor3 = themes[currentTheme].buttonColor
    colorFrame.BackgroundTransparency = 0.2
    colorFrame.BorderSizePixel = 0
    colorFrame.ClipsDescendants = false
    colorFrame.ZIndex = 4
    colorFrame.Parent = RightPanel
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = colorFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.6, 0, 0, isMobile and 18 or 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = getText(nameKey)
    label.TextColor3 = themes[currentTheme].textColor
    label.TextSize = isMobile and mobileTextSize or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.ZIndex = 5
    label.Parent = colorFrame
    
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 182, 193),
        Color3.fromRGB(128, 0, 255),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(128, 128, 128)
    }
    
    local colorNames = {"red", "blue", "cyan", "pink", "purple", "green", "yellow", "white", "black", "gray"}
    
    local buttonSize = isMobile and 22 or 25
    local buttonsPerRow = 5
    local spacing = isMobile and 6 or 8
    local startX = 10
    local startY = isMobile and 25 or 30
    
    for i, color in ipairs(colors) do
        local row = math.floor((i-1) / buttonsPerRow)
        local col = (i-1) % buttonsPerRow
        
        local colorButton = Instance.new("TextButton")
        colorButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
        colorButton.Position = UDim2.new(0, startX + col * (buttonSize + spacing), 0, startY + row * (buttonSize + spacing))
        colorButton.BackgroundColor3 = color
        colorButton.BorderSizePixel = 0
        colorButton.Text = ""
        colorButton.ZIndex = 5
        colorButton.Parent = colorFrame
    
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = colorButton
        
        local selectionStroke = Instance.new("UIStroke")
        selectionStroke.Thickness = 2
        selectionStroke.Color = Color3.new(1, 1, 1)
        selectionStroke.Enabled = (color == defaultColor)
        selectionStroke.Parent = colorButton
        
        colorButton.MouseButton1Click:Connect(function()
            for _, btn in ipairs(colorFrame:GetChildren()) do
                if btn:IsA("TextButton") and btn:FindFirstChild("UIStroke") then
                    btn.UIStroke.Enabled = false
                end
            end
            selectionStroke.Enabled = true
            callback(color, getText(colorNames[i]))
        end)
    end
    
    local rgbContainer = Instance.new("Frame")
    rgbContainer.Name = "RGBContainer"
    rgbContainer.Size = UDim2.new(0, isMobile and 100 or 120, 0, isMobile and 100 or 120)
    rgbContainer.Position = UDim2.new(1, isMobile and -110 or -130, 0, isMobile and 25 or 30)
    rgbContainer.BackgroundColor3 = themes[currentTheme].secondaryColor
    rgbContainer.BackgroundTransparency = 0.3
    rgbContainer.BorderSizePixel = 0
    rgbContainer.ZIndex = 5
    rgbContainer.Parent = colorFrame
    
    local rgbCorner = Instance.new("UICorner")
    rgbCorner.CornerRadius = UDim.new(0, 6)
    rgbCorner.Parent = rgbContainer
    
    local rgbLabel = Instance.new("TextLabel")
    rgbLabel.Name = "RGBLabel"
    rgbLabel.Size = UDim2.new(1, 0, 0, isMobile and 18 or 20)
    rgbLabel.Position = UDim2.new(0, 0, 0, 5)
    rgbLabel.BackgroundTransparency = 1
    rgbLabel.Text = getText("customRGB")
    rgbLabel.TextColor3 = themes[currentTheme].textColor
    rgbLabel.TextSize = isMobile and 10 or 12
    rgbLabel.Font = Enum.Font.GothamBold
    rgbLabel.ZIndex = 6
    rgbLabel.Parent = rgbContainer
    
    local rContainer = Instance.new("Frame")
    rContainer.Name = "RContainer"
    rContainer.Size = UDim2.new(1, -10, 0, isMobile and 22 or 25)
    rContainer.Position = UDim2.new(0, 5, 0, isMobile and 20 or 25)
    rContainer.BackgroundTransparency = 1
    rContainer.ZIndex = 6
    rContainer.Parent = rgbContainer
    
    local rLabel = Instance.new("TextLabel")
    rLabel.Name = "RLabel"
    rLabel.Size = UDim2.new(0, 15, 1, 0)
    rLabel.Position = UDim2.new(0, 0, 0, 0)
    rLabel.BackgroundTransparency = 1
    rLabel.Text = getText("enterR")
    rLabel.TextColor3 = themes[currentTheme].textColor
    rLabel.TextSize = isMobile and 10 or 12
    rLabel.Font = Enum.Font.GothamBold
    rLabel.ZIndex = 7
    rLabel.Parent = rContainer
    
    local rInput = Instance.new("TextBox")
    rInput.Name = "RInput"
    rInput.Size = UDim2.new(1, -20, 1, 0)
    rInput.Position = UDim2.new(0, 20, 0, 0)
    rInput.BackgroundColor3 = themes[currentTheme].buttonColor
    rInput.BorderSizePixel = 0
    rInput.Text = tostring(math.floor(defaultColor.R * 255))
    rInput.TextColor3 = themes[currentTheme].textColor
    rInput.TextSize = isMobile and 10 or 12
    rInput.Font = Enum.Font.Gotham
    rInput.ZIndex = 7
    rInput.Parent = rContainer
    
    local rCorner = Instance.new("UICorner")
    rCorner.CornerRadius = UDim.new(0, 4)
    rCorner.Parent = rInput
    
    local gContainer = Instance.new("Frame")
    gContainer.Name = "GContainer"
    gContainer.Size = UDim2.new(1, -10, 0, isMobile and 22 or 25)
    gContainer.Position = UDim2.new(0, 5, 0, isMobile and 45 or 55)
    gContainer.BackgroundTransparency = 1
    gContainer.ZIndex = 6
    gContainer.Parent = rgbContainer
    
    local gLabel = Instance.new("TextLabel")
    gLabel.Name = "GLabel"
    gLabel.Size = UDim2.new(0, 15, 1, 0)
    gLabel.Position = UDim2.new(0, 0, 0, 0)
    gLabel.BackgroundTransparency = 1
    gLabel.Text = getText("enterG")
    gLabel.TextColor3 = themes[currentTheme].textColor
    gLabel.TextSize = isMobile and 10 or 12
    gLabel.Font = Enum.Font.GothamBold
    gLabel.ZIndex = 7
    gLabel.Parent = gContainer
    
    local gInput = Instance.new("TextBox")
    gInput.Name = "GInput"
    gInput.Size = UDim2.new(1, -20, 1, 0)
    gInput.Position = UDim2.new(0, 20, 0, 0)
    gInput.BackgroundColor3 = themes[currentTheme].buttonColor
    gInput.BorderSizePixel = 0
    gInput.Text = tostring(math.floor(defaultColor.G * 255))
    gInput.TextColor3 = themes[currentTheme].textColor
    gInput.TextSize = isMobile and 10 or 12
    gInput.Font = Enum.Font.Gotham
    gInput.ZIndex = 7
    gInput.Parent = gContainer
    
    local gCorner = Instance.new("UICorner")
    gCorner.CornerRadius = UDim.new(0, 4)
    gCorner.Parent = gInput
    
    local bContainer = Instance.new("Frame")
    bContainer.Name = "BContainer"
    bContainer.Size = UDim2.new(1, -10, 0, isMobile and 22 or 25)
    bContainer.Position = UDim2.new(0, 5, 0, isMobile and 70 or 85)
    bContainer.BackgroundTransparency = 1
    bContainer.ZIndex = 6
    bContainer.Parent = rgbContainer
    
    local bLabel = Instance.new("TextLabel")
    bLabel.Name = "BLabel"
    bLabel.Size = UDim2.new(0, 15, 1, 0)
    bLabel.Position = UDim2.new(0, 0, 0, 0)
    bLabel.BackgroundTransparency = 1
    bLabel.Text = getText("enterB")
    bLabel.TextColor3 = themes[currentTheme].textColor
    bLabel.TextSize = isMobile and 10 or 12
    bLabel.Font = Enum.Font.GothamBold
    bLabel.ZIndex = 7
    bLabel.Parent = bContainer
    
    local bInput = Instance.new("TextBox")
    bInput.Name = "BInput"
    bInput.Size = UDim2.new(1, -20, 1, 0)
    bInput.Position = UDim2.new(0, 20, 0, 0)
    bInput.BackgroundColor3 = themes[currentTheme].buttonColor
    bInput.BorderSizePixel = 0
    bInput.Text = tostring(math.floor(defaultColor.B * 255))
    bInput.TextColor3 = themes[currentTheme].textColor
    bInput.TextSize = isMobile and 10 or 12
    bInput.Font = Enum.Font.Gotham
    bInput.ZIndex = 7
    bInput.Parent = bContainer
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = bInput
    
    local function updateRGBInputs(color)
        rInput.Text = tostring(math.floor(color.R * 255))
        gInput.Text = tostring(math.floor(color.G * 255))
        bInput.Text = tostring(math.floor(color.B * 255))
    end
    
    local function applyRGBColor()
        local r = tonumber(rInput.Text) or 0
        local g = tonumber(gInput.Text) or 0
        local b = tonumber(bInput.Text) or 0
        
        r = math.clamp(r, 0, 255)
        g = math.clamp(g, 0, 255)
        b = math.clamp(b, 0, 255)
        
        local color = Color3.fromRGB(r, g, b)
        callback(color)
        showNotification("RGB Color Applied: " .. r .. ", " .. g .. ", " .. b)
        
        for _, btn in ipairs(colorFrame:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("UIStroke") then
                btn.UIStroke.Enabled = false
            end
        end
    end
    
    rInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            applyRGBColor()
        end
    end)
    
    gInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            applyRGBColor()
        end
    end)
    
    bInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            applyRGBColor()
        end
    end)
    
    local originalCallback = callback
    callback = function(color, colorName)
        updateRGBInputs(color)
        originalCallback(color, colorName)
    end
    
    return colorFrame
end

for i, sectionName in ipairs(sections) do
    createSectionButton(sectionName, i)
end

local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "Credit"
creditLabel.Size = UDim2.new(1, -10, 0, isMobile and 25 or 30)
creditLabel.Position = UDim2.new(0, 5, 1, isMobile and -30 or -35)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = getText("credit")
creditLabel.TextColor3 = Color3.fromRGB(150, 170, 210)
creditLabel.TextSize = isMobile and 10 or 12
creditLabel.Font = Enum.Font.Gotham
creditLabel.ZIndex = 4
creditLabel.Parent = LeftPanel

LeftPanel.CanvasSize = UDim2.new(0, 0, 0, #sections * (sectionButtonHeight + sectionButtonSpacing) + 40)

local function updateStats()
    frameCount = frameCount + 1
    local currentTime = tick()
    
    if currentTime - lastTime >= 1 then
        fps = math.floor(frameCount / (currentTime - lastTime))
        frameCount = 0
        lastTime = currentTime
        
        local ping = math.random(20, 80)
        
        local now = os.date("*t")
        local timeString = string.format("%02d:%02d:%02d", now.hour, now.min, now.sec)
        
        local speed = 0
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    speed = math.floor(rootPart.Velocity.Magnitude)
                end
            end
        end
        
        if viewFPSEnabled then
            StatsLabel.Text = string.format("FPS: %d\nPing: %dms\nTime: %s\nSpeed: %d studs", fps, ping, timeString, speed)
        end
    end
end

RunService.Heartbeat:Connect(updateStats)

local function toggleMenu()
    if splashScreenActive then
        showNotification("Please wait for splash screen to finish")
        return
    end
    
    menuOpen = not menuOpen
    
    if menuOpen then
        Background.Visible = true
        MainFrame.Visible = true
        BlurEffect.Enabled = true
        OpenButton.Visible = false
        
        Background.BackgroundTransparency = 1
        
        TweenService:Create(Background, tweenInfo, {BackgroundTransparency = 0.7}):Play()
        
    else
        TweenService:Create(Background, tweenInfo, {BackgroundTransparency = 1}):Play()
        
        spawn(function()
            wait(0.35)
            if not menuOpen then
                Background.Visible = false
                MainFrame.Visible = false
                BlurEffect.Enabled = false
                OpenButton.Visible = true
            end
        end)
    end
end

OpenButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

CloseButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

local function clearRightPanel()
    for _, child in ipairs(RightPanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

local function setupTimeCycle(enabled)
    timeCycleEnabled = enabled
    settingsState.timeCycleEnabled = enabled
    
    if enabled then
        realTimeEnabled = false
        settingsState.realTimeEnabled = false
        if realTimeConnection then
            realTimeConnection:Disconnect()
            realTimeConnection = nil
        end
        
        timeCycleConnection = RunService.Heartbeat:Connect(function()
            if not timeCycleEnabled then
                timeCycleConnection:Disconnect()
                return
            end
            
            local cycleSpeed = 24 / 600
            Lighting.ClockTime = (Lighting.ClockTime + cycleSpeed * 0.0167) % 24
        end)
        showNotification("Time cycle enabled - 24 hours in 10 minutes")
    else
        if timeCycleConnection then
            timeCycleConnection:Disconnect()
            timeCycleConnection = nil
        end
        showNotification("Time cycle disabled")
    end
end

local function setupRealTime(enabled)
    realTimeEnabled = enabled
    settingsState.realTimeEnabled = enabled
    
    if enabled then
        timeCycleEnabled = false
        settingsState.timeCycleEnabled = false
        if timeCycleConnection then
            timeCycleConnection:Disconnect()
            timeCycleConnection = nil
        end
        
        realTimeConnection = RunService.Heartbeat:Connect(function()
            if not realTimeEnabled then
                realTimeConnection:Disconnect()
                return
            end
            
            local now = os.date("*t")
            local hour = now.hour
            local minute = now.min
            local second = now.sec
            
            local gameTime = hour + minute / 60 + second / 3600
            Lighting.ClockTime = gameTime
        end)
        showNotification("Real time sync enabled")
    else
        if realTimeConnection then
            realTimeConnection:Disconnect()
            realTimeConnection = nil
        end
        showNotification("Real time sync disabled")
    end
end

local function setupTail(enabled)
    tailEnabled = enabled
    settingsState.tailEnabled = enabled
    
    if enabled then
        local function createTailForPlayer(character)
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            local tailParts = {}
            local maxTailLength = 15
            
            for i = 1, maxTailLength do
                local part = Instance.new("Part")
                part.Name = "TailPart"
                part.Size = Vector3.new(0.4, 0.4, 0.4)
                part.Material = Enum.Material.Neon
                part.BrickColor = BrickColor.new(tostring(settingsState.tailColor))
                part.Anchored = true
                part.CanCollide = false
                part.Transparency = i / maxTailLength
                part.Parent = Workspace
                
                local pointLight = Instance.new("PointLight")
                pointLight.Brightness = 2
                pointLight.Range = 3
                pointLight.Color = settingsState.tailColor
                pointLight.Enabled = true
                pointLight.Parent = part
                
                table.insert(tailParts, part)
            end
            
            tailParts[character] = tailParts
            
            local lastPositions = {}
            local connection = RunService.Heartbeat:Connect(function()
                if not character or not character.Parent then
                    connection:Disconnect()
                    for _, part in ipairs(tailParts) do
                        if part and part.Parent then
                            part:Destroy()
                        end
                    end
                    return
                end
                
                local currentPosition = rootPart.Position
                table.insert(lastPositions, 1, currentPosition)
                
                if #lastPositions > maxTailLength then
                    table.remove(lastPositions)
                end
                
                for i, part in ipairs(tailParts) do
                    if lastPositions[i] then
                        part.Position = lastPositions[i] - Vector3.new(0, 1, 0)
                        part.Transparency = (i - 1) / maxTailLength
                        part.Color = settingsState.tailColor
                        if part:FindFirstChild("PointLight") then
                            part.PointLight.Color = settingsState.tailColor
                        end
                    end
                end
            end)
            
            tailConnections[character] = connection
        end
        
        if player.Character then
            createTailForPlayer(player.Character)
        end
        
        player.CharacterAdded:Connect(function(character)
            wait(1)
            createTailForPlayer(character)
        end)
        
        showNotification("Tail effect enabled")
    else
        for character, connection in pairs(tailConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        tailConnections = {}
        
        for character, parts in pairs(tailParts) do
            for _, part in ipairs(parts) do
                if part and part.Parent then
                    part:Destroy()
                end
            end
        end
        tailParts = {}
        
        showNotification("Tail effect disabled")
    end
end

local function updateTailColor(color)
    settingsState.tailColor = color
    for character, parts in pairs(tailParts) do
        for _, part in ipairs(parts) do
            if part and part.Parent then
                part.Color = color
                if part:FindFirstChild("PointLight") then
                    part.PointLight.Color = color
                end
            end
        end
    end
end

local function setupFireflies(enabled)
    firefliesEnabled = enabled
    settingsState.firefliesEnabled = enabled
    
    if enabled then
        local maxFireflies = 200
        local spawnRadius = 50
        local despawnDistance = 70
        
        local function createFirefly(position)
            local firefly = Instance.new("Part")
            firefly.Name = "Firefly"
            firefly.Size = Vector3.new(0.15, 0.15, 0.15)
            firefly.Shape = Enum.PartType.Ball
            firefly.Material = Enum.Material.Neon
            firefly.BrickColor = BrickColor.new(tostring(settingsState.fireflyColor))
            firefly.Anchored = false
            firefly.CanCollide = false
            firefly.Transparency = 0
            firefly.Parent = Workspace
            
            local pointLight = Instance.new("PointLight")
            pointLight.Brightness = 4
            pointLight.Range = 4
            pointLight.Color = settingsState.fireflyColor
            pointLight.Enabled = true
            pointLight.Parent = firefly
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(
                math.random(-2, 2),
                math.random(-1, 1),
                math.random(-2, 2)
            )
            bodyVelocity.Parent = firefly
            
            firefly.Position = position
            
            table.insert(fireflies, firefly)
            return firefly
        end
        
        local function getSpawnPosition()
            local character = player.Character
            if not character then
                return Vector3.new(math.random(-50, 50), math.random(5, 20), math.random(-50, 50))
            end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then
                return Vector3.new(math.random(-50, 50), math.random(5, 20), math.random(-50, 50))
            end
            
            local angle = math.random() * 2 * math.pi
            local distance = math.random() * spawnRadius
            local x = rootPart.Position.X + math.cos(angle) * distance
            local z = rootPart.Position.Z + math.sin(angle) * distance
            local y = rootPart.Position.Y + math.random(-10, 15)
            
            return Vector3.new(x, math.max(y, 2), z)
        end
        
        for i = 1, maxFireflies do
            spawn(function()
                wait(math.random(0, 0.5))
                createFirefly(getSpawnPosition())
            end)
        end
        
        local fireflyConnection = RunService.Heartbeat:Connect(function()
            if not firefliesEnabled then
                fireflyConnection:Disconnect()
                return
            end
            
            local character = player.Character
            local playerPosition = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
            
            for i = #fireflies, 1, -1 do
                local firefly = fireflies[i]
                if firefly and firefly.Parent then
                    local distance = (firefly.Position - playerPosition).Magnitude
                    if distance > despawnDistance then
                        firefly:Destroy()
                        table.remove(fireflies, i)
                    end
                else
                    table.remove(fireflies, i)
                end
            end
            
            if #fireflies < maxFireflies then
                local neededFireflies = maxFireflies - #fireflies
                for i = 1, math.min(10, neededFireflies) do
                    createFirefly(getSpawnPosition())
                end
            end
            
            for _, firefly in ipairs(fireflies) do
                if firefly and firefly.Parent then
                    local bodyVelocity = firefly:FindFirstChild("BodyVelocity")
                    if bodyVelocity then
                        local randomMovement = Vector3.new(
                            math.random(-1.5, 1.5),
                            math.random(-0.5, 0.5),
                            math.random(-1.5, 1.5)
                        )
                        
                        bodyVelocity.Velocity = randomMovement
                        
                        if firefly.Position.Y > 30 then
                            firefly.Position = Vector3.new(
                                firefly.Position.X,
                                20,
                                firefly.Position.Z
                            )
                        elseif firefly.Position.Y < 2 then
                            firefly.Position = Vector3.new(
                                firefly.Position.X,
                                5,
                                firefly.Position.Z
                            )
                        end
                    end
                    
                    firefly.Color = settingsState.fireflyColor
                    if firefly:FindFirstChild("PointLight") then
                        firefly.PointLight.Color = settingsState.fireflyColor
                    end
                end
            end
        end)
        
        fireflyConnections["main"] = fireflyConnection
        showNotification("Fireflies enabled")
    else
        for _, connection in pairs(fireflyConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        fireflyConnections = {}
        
        for _, firefly in ipairs(fireflies) do
            if firefly and firefly.Parent then
                firefly:Destroy()
            end
        end
        fireflies = {}
        
        showNotification("Fireflies disabled")
    end
end

local function updateFireflyColor(color)
    settingsState.fireflyColor = color
    for _, firefly in ipairs(fireflies) do
        if firefly and firefly.Parent then
            firefly.Color = color
            if firefly:FindFirstChild("PointLight") then
                firefly.PointLight.Color = color
            end
        end
    end
end

local function setupSnowfall(enabled)
    snowEnabled = enabled
    
    if enabled then
        local maxSnowflakes = 400
        local spawnHeight = 80
        local despawnHeight = -10
        local spawnRadius = 150
        local snowLifetime = 12
        
        local function createSnowflake(position)
            local snowflake = Instance.new("Part")
            snowflake.Name = "Snowflake"
            snowflake.Size = Vector3.new(0.3, 0.3, 0.3)
            snowflake.Shape = Enum.PartType.Ball
            snowflake.Material = Enum.Material.SmoothPlastic
            snowflake.BrickColor = BrickColor.new("White")
            snowflake.Anchored = false
            snowflake.CanCollide = true
            snowflake.Transparency = 0.1
            snowflake.Parent = Workspace
            
            local pointLight = Instance.new("PointLight")
            pointLight.Brightness = 2
            pointLight.Range = 5
            pointLight.Color = Color3.new(1, 1, 1)
            pointLight.Enabled = true
            pointLight.Parent = snowflake
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(
                math.random(-5, 5),
                math.random(-12, -8),
                math.random(-5, 5)
            )
            bodyVelocity.Parent = snowflake
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 1000
            bodyGyro.D = 50
            bodyGyro.Parent = snowflake
            
            snowflake.Position = position
            
            local creationTime = tick()
            snowCreationTimes[snowflake] = creationTime
            
            local touchConnection
            touchConnection = snowflake.Touched:Connect(function(hit)
                if hit.Parent ~= player.Character then
                    snowflake:Destroy()
                    touchConnection:Disconnect()
                    snowCreationTimes[snowflake] = nil
                end
            end)
            
            table.insert(snowflakes, snowflake)
            return snowflake
        end
        
        local function getSnowSpawnPosition()
            local character = player.Character
            if not character then
                return Vector3.new(math.random(-spawnRadius, spawnRadius), math.random(spawnHeight - 30, spawnHeight + 30), math.random(-spawnRadius, spawnRadius))
            end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then
                return Vector3.new(math.random(-spawnRadius, spawnRadius), math.random(spawnHeight - 30, spawnHeight + 30), math.random(-spawnRadius, spawnRadius))
            end
            
            local angle = math.random() * 2 * math.pi
            local distance = math.random() * spawnRadius
            local x = rootPart.Position.X + math.cos(angle) * distance
            local z = rootPart.Position.Z + math.sin(angle) * distance
            local y = rootPart.Position.Y + math.random(spawnHeight - 30, spawnHeight + 30)
            
            return Vector3.new(x, y, z)
        end
        
        for i = 1, math.min(100, maxSnowflakes) do
            spawn(function()
                wait(math.random(0, 0.2))
                createSnowflake(getSnowSpawnPosition())
            end)
        end
        
        local snowConnection = RunService.Heartbeat:Connect(function()
            if not snowEnabled then
                snowConnection:Disconnect()
                return
            end
            
            local character = player.Character
            local playerPosition = character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
            
            for i = #snowflakes, 1, -1 do
                local snowflake = snowflakes[i]
                if snowflake and snowflake.Parent then
                    local distance = (snowflake.Position - playerPosition).Magnitude
                    local currentTime = tick()
                    local creationTime = snowCreationTimes[snowflake] or currentTime
                    
                    if snowflake.Position.Y <= despawnHeight or distance > spawnRadius + 30 or (currentTime - creationTime) > snowLifetime then
                        snowflake:Destroy()
                        table.remove(snowflakes, i)
                        snowCreationTimes[snowflake] = nil
                    end
                else
                    table.remove(snowflakes, i)
                    snowCreationTimes[snowflake] = nil
                end
            end
            
            local currentTime = tick()
            if currentTime - lastSnowSpawnTime >= 0.3 and #snowflakes < maxSnowflakes then
                lastSnowSpawnTime = currentTime
                
                local snowflakesToCreate = math.min(15, maxSnowflakes - #snowflakes)
                for i = 1, snowflakesToCreate do
                    spawn(function()
                        createSnowflake(getSnowSpawnPosition())
                    end)
                end
            end
            
            for _, snowflake in ipairs(snowflakes) do
                if snowflake and snowflake.Parent then
                    local bodyVelocity = snowflake:FindFirstChild("BodyVelocity")
                    if bodyVelocity then
                        local randomMovement = Vector3.new(
                            math.random(-3, 3),
                            math.random(-15, -10),
                            math.random(-3, 3)
                        )
                        
                        bodyVelocity.Velocity = randomMovement
                    end
                    
                    snowflake.Transparency = 0.05 + math.abs(math.sin(tick() * 4 + snowflake.Position.X)) * 0.2
                end
            end
        end)
        
        snowConnections["main"] = snowConnection
        showNotification("Enhanced snowfall enabled")
    else
        for _, connection in pairs(snowConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        snowConnections = {}
        
        for _, snowflake in ipairs(snowflakes) do
            if snowflake and snowflake.Parent then
                snowflake:Destroy()
            end
        end
        snowflakes = {}
        snowCreationTimes = {}
        
        showNotification("Snowfall disabled")
    end
end

local function setupCrosshair(enabled)
    crosshairEnabled = enabled
    settingsState.crosshairEnabled = enabled
    
    if enabled then
        crosshairFrame = Instance.new("Frame")
        crosshairFrame.Name = "Crosshair"
        crosshairFrame.Size = UDim2.new(0, 20, 0, 20)
        crosshairFrame.Position = UDim2.new(0.5, -10, 0.5, -15)
        crosshairFrame.BackgroundTransparency = 1
        crosshairFrame.ZIndex = 999
        crosshairFrame.Parent = CloudHub
        
        local horizontalLine = Instance.new("Frame")
        horizontalLine.Name = "HorizontalLine"
        horizontalLine.Size = UDim2.new(1, 0, 0, 2)
        horizontalLine.Position = UDim2.new(0, 0, 0.5, -1)
        horizontalLine.BackgroundColor3 = settingsState.crosshairColor
        horizontalLine.BorderSizePixel = 0
        horizontalLine.ZIndex = 1000
        horizontalLine.Parent = crosshairFrame
        
        local verticalLine = Instance.new("Frame")
        verticalLine.Name = "VerticalLine"
        verticalLine.Size = UDim2.new(0, 2, 1, 0)
        verticalLine.Position = UDim2.new(0.5, -1, 0, 0)
        verticalLine.BackgroundColor3 = settingsState.crosshairColor
        verticalLine.BorderSizePixel = 0
        verticalLine.ZIndex = 1000
        verticalLine.Parent = crosshairFrame
        
        local outerCircle = Instance.new("Frame")
        outerCircle.Name = "OuterCircle"
        outerCircle.Size = UDim2.new(1, 0, 1, 0)
        outerCircle.Position = UDim2.new(0, 0, 0, 0)
        outerCircle.BackgroundTransparency = 1
        outerCircle.ZIndex = 999
        outerCircle.Parent = crosshairFrame
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = outerCircle
        
        local circleStroke = Instance.new("UIStroke")
        circleStroke.Thickness = 1
        circleStroke.Color = settingsState.crosshairColor
        circleStroke.Parent = outerCircle
        
        local function updateCrosshairInput(input)
            if not draggingCrosshair then return end
            local delta = input.Position - dragStartCrosshair
            crosshairFrame.Position = UDim2.new(
                startPosCrosshair.X.Scale, 
                startPosCrosshair.X.Offset + delta.X, 
                startPosCrosshair.Y.Scale, 
                startPosCrosshair.Y.Offset + delta.Y
            )
        end

        crosshairFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingCrosshair = true
                dragStartCrosshair = input.Position
                startPosCrosshair = crosshairFrame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        draggingCrosshair = false
                    end
                end)
            end
        end)

        crosshairFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInputCrosshair = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInputCrosshair and draggingCrosshair then
                updateCrosshairInput(input)
            end
        end)
        
        showNotification("Crosshair enabled")
    else
        if crosshairFrame then
            crosshairFrame:Destroy()
            crosshairFrame = nil
        end
        showNotification("Crosshair disabled")
    end
end

local function updateCrosshairColor(color)
    settingsState.crosshairColor = color
    if crosshairFrame and crosshairEnabled then
        local horizontalLine = crosshairFrame:FindFirstChild("HorizontalLine")
        local verticalLine = crosshairFrame:FindFirstChild("VerticalLine")
        local outerCircle = crosshairFrame:FindFirstChild("OuterCircle")
        
        if horizontalLine then
            horizontalLine.BackgroundColor3 = color
        end
        if verticalLine then
            verticalLine.BackgroundColor3 = color
        end
        if outerCircle then
            local stroke = outerCircle:FindFirstChild("UIStroke")
            if stroke then
                stroke.Color = color
            end
        end
    end
end

local function createPlayerESP(otherPlayer)
    if not otherPlayer.Character then return end
    
    local character = otherPlayer.Character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP"
    highlight.FillColor = settingsState.espColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    espHighlights[otherPlayer] = highlight
end

local function updateESPColor(color)
    settingsState.espColor = color
    for _, highlight in pairs(espHighlights) do
        if highlight and highlight.Parent then
            highlight.FillColor = color
        end
    end
end

local function setupESP(enabled)
    espEnabled = enabled
    settingsState.esp = enabled
    
    if enabled then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                if otherPlayer.Character then
                    createPlayerESP(otherPlayer)
                end
                
                local characterAddedConnection = otherPlayer.CharacterAdded:Connect(function(character)
                    wait(1)
                    createPlayerESP(otherPlayer)
                end)
                
                espConnections[otherPlayer] = characterAddedConnection
            end
        end
        
        local playerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(character)
                wait(1)
                createPlayerESP(newPlayer)
            end)
        end)
        
        espConnections["PlayerAdded"] = playerAddedConnection
        
    else
        for _, connection in pairs(espConnections) do
            connection:Disconnect()
        end
        espConnections = {}
        
        for _, highlight in pairs(espHighlights) do
            if highlight then
                highlight:Destroy()
            end
        end
        espHighlights = {}
    end
end

local function createPlayerHitbox(otherPlayer)
    if not otherPlayer.Character then return end
    
    local character = otherPlayer.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "Hitbox"
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    hitboxHighlights[otherPlayer] = highlight
end

local function setupHitboxes(enabled)
    showHitboxesEnabled = enabled
    settingsState.showHitboxes = enabled
    
    if enabled then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                if otherPlayer.Character then
                    createPlayerHitbox(otherPlayer)
                end
                
                local characterAddedConnection = otherPlayer.CharacterAdded:Connect(function(character)
                    wait(1)
                    createPlayerHitbox(otherPlayer)
                end)
                
                hitboxConnections[otherPlayer] = characterAddedConnection
            end
        end
        
        local playerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(character)
                wait(1)
                createPlayerHitbox(newPlayer)
            end)
        end)
        
        hitboxConnections["PlayerAdded"] = playerAddedConnection
        
    else
        for _, connection in pairs(hitboxConnections) do
            connection:Disconnect()
        end
        hitboxConnections = {}
        
        for _, highlight in pairs(hitboxHighlights) do
            if highlight then
                highlight:Destroy()
            end
        end
        hitboxHighlights = {}
    end
end

local function setupAspectRatio43(enabled)
    aspectRatioEnabled = enabled
    settingsState.aspectRatio43 = enabled
    
    if enabled then
        local Camera = workspace.CurrentCamera
        aspectRatioConnection = RunService.RenderStepped:Connect(function()
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.75, 0, 0, 0, 1)
        end)
    else
        if aspectRatioConnection then
            aspectRatioConnection:Disconnect()
            aspectRatioConnection = nil
        end
    end
end

local function applyGraphicsPreset(presetName)
    local preset = graphicsPresets[presetName]
    if preset then
        Lighting.Ambient = preset.ambient
        Lighting.OutdoorAmbient = preset.outdoorAmbient
        Lighting.Brightness = preset.brightness
        Lighting.FogColor = preset.fogColor
        Lighting.FogEnd = preset.fogEnd
        Lighting.ClockTime = preset.clockTime
        Lighting.GlobalShadows = preset.globalShadows
        
        settingsState.currentGraphics = presetName
        
        if presetName == "Neon" then
            setupNeonEffects(true)
        else
            setupNeonEffects(false)
        end
        
        showNotification(getText("graphics") .. ": " .. getText(presetName:lower()))
    end
end

local function setupNeonEffects(enabled)
    if enabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                local shouldGlow = true
                
                if obj.Name:lower():find("baseplate") or 
                   obj.Name:lower():find("ground") or 
                   obj.Name:lower():find("floor") or
                   obj.Name:lower():find("terrain") or
                   obj:IsA("TrussPart") or
                   obj:IsA("WedgePart") or
                   obj.Name:lower():find("spawn") then
                    shouldGlow = false
                end
                
                if shouldGlow then
                    if not originalMaterials[obj] then
                        originalMaterials[obj] = obj.Material
                    end
                    obj.Material = Enum.Material.Neon
                    
                    if not neonLights[obj] then
                        local pointLight = Instance.new("PointLight")
                        pointLight.Brightness = 2
                        pointLight.Range = 8
                        pointLight.Color = obj.Color
                        pointLight.Parent = obj
                        neonLights[obj] = pointLight
                    end
                end
            elseif obj:IsA("Model") then
                local shouldGlowModel = true
                
                if obj.Name:lower():find("baseplate") or 
                   obj.Name:lower():find("ground") or 
                   obj.Name:lower():find("floor") or
                   obj.Name:lower():find("terrain") or
                   obj.Name:lower():find("spawn") then
                    shouldGlowModel = false
                end
                
                if shouldGlowModel then
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("Part") then
                            if not originalMaterials[part] then
                                originalMaterials[part] = part.Material
                            end
                            part.Material = Enum.Material.Neon
                            
                            if not neonLights[part] then
                                local pointLight = Instance.new("PointLight")
                                pointLight.Brightness = 1.5
                                pointLight.Range = 6
                                pointLight.Color = part.Color
                                pointLight.Parent = part
                                neonLights[part] = pointLight
                            end
                        end
                    end
                end
            end
        end
    else
        for obj, originalMaterial in pairs(originalMaterials) do
            if obj and obj.Parent then
                obj.Material = originalMaterial
            end
        end
        
        for obj, light in pairs(neonLights) do
            if light and light.Parent then
                light:Destroy()
            end
        end
        neonLights = {}
    end
end

local function resetSeasonColors()
    for obj, originalMaterial in pairs(originalMaterials) do
        if obj and obj.Parent then
            obj.Material = originalMaterial
        end
    end
    
    for obj, originalColor in pairs(originalColors) do
        if obj and obj.Parent then
            obj.Color = originalColor
        end
    end
    
    originalMaterials = {}
    originalColors = {}
    
    showNotification("Season colors reset")
end

local function disableAllSeasons()
    winterEnabled = false
    springEnabled = false
    summerEnabled = false
    autumnEnabled = false
    
    settingsState.winterMode = false
    settingsState.springMode = false
    settingsState.summerMode = false
    settingsState.autumnMode = false
    
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    Lighting.FogColor = Color3.new(1, 1, 1)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.Brightness = 1
end

local function setupWinter(enabled)
    if enabled then
        disableAllSeasons()
    end
    
    winterEnabled = enabled
    settingsState.winterMode = enabled
    
    if enabled then
        Lighting.Ambient = Color3.fromRGB(120, 150, 200)
        Lighting.OutdoorAmbient = Color3.fromRGB(100, 130, 180)
        Lighting.Brightness = 0.7
        Lighting.ClockTime = 12
        
        Lighting.FogColor = Color3.fromRGB(180, 200, 220)
        Lighting.FogEnd = 50000
        Lighting.FogStart = 0
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                if obj.Name:lower():find("grass") or 
                   obj.Name:lower():find("lawn") or 
                   obj.Name:lower():find("field") or
                   obj.Name:lower():find("ground") then
                    
                    if not originalMaterials[obj] then
                        originalMaterials[obj] = obj.Material
                        originalColors[obj] = obj.Color
                    end
                    
                    obj.Material = Enum.Material.Snow
                    obj.BrickColor = BrickColor.new("White")
                    obj.Color = Color3.new(1, 1, 1)
                end
            elseif obj:IsA("Model") then
                if obj.Name:lower():find("grass") or 
                   obj.Name:lower():find("lawn") or 
                   obj.Name:lower():find("field") then
                    
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("Part") then
                            if not originalMaterials[part] then
                                originalMaterials[part] = part.Material
                                originalColors[part] = part.Color
                            end
                            
                            part.Material = Enum.Material.Snow
                            part.BrickColor = BrickColor.new("White")
                            part.Color = Color3.new(1, 1, 1)
                        end
                    end
                end
            end
        end
        
        setupSnowfall(true)
        
    else
        if not springEnabled and not summerEnabled and not autumnEnabled then
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.FogColor = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.Brightness = 1
        end
        
        setupSnowfall(false)
    end
end

local function setupSpring(enabled)
    if enabled then
        disableAllSeasons()
    end
    
    springEnabled = enabled
    settingsState.springMode = enabled
    
    if enabled then
        Lighting.Ambient = Color3.fromRGB(150, 200, 150)
        Lighting.OutdoorAmbient = Color3.fromRGB(130, 180, 130)
        Lighting.Brightness = 0.9
        Lighting.ClockTime = 10
        
        Lighting.FogColor = Color3.fromRGB(180, 220, 180)
        Lighting.FogEnd = 80000
        Lighting.FogStart = 0
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                if obj.Name:lower():find("grass") or 
                   obj.Name:lower():find("lawn") or 
                   obj.Name:lower():find("field") or
                   obj.Name:lower():find("ground") then
                    
                    if not originalMaterials[obj] then
                        originalMaterials[obj] = obj.Material
                        originalColors[obj] = obj.Color
                    end
                    
                    obj.Material = Enum.Material.Grass
                    obj.BrickColor = BrickColor.new("Bright green")
                    obj.Color = Color3.fromRGB(0, 170, 0)
                end
            elseif obj:IsA("Model") then
                if obj.Name:lower():find("grass") or 
                   obj.Name:lower():find("lawn") or 
                   obj.Name:lower():find("field") then
                    
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("Part") then
                            if not originalMaterials[part] then
                                originalMaterials[part] = part.Material
                                originalColors[part] = part.Color
                            end
                            
                            part.Material = Enum.Material.Grass
                            part.BrickColor = BrickColor.new("Bright green")
                            part.Color = Color3.fromRGB(0, 170, 0)
                        end
                    end
                end
            end
        end
    else
        if not winterEnabled and not summerEnabled and not autumnEnabled then
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.FogColor = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.Brightness = 1
        end
    end
end

local function setupSummer(enabled)
    if enabled then
        disableAllSeasons()
    end
    
    summerEnabled = enabled
    settingsState.summerMode = enabled
    
    if enabled then
        Lighting.Ambient = Color3.fromRGB(255, 220, 150)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 200, 130)
        Lighting.Brightness = 1.2
        Lighting.ClockTime = 14
        
        Lighting.FogColor = Color3.fromRGB(255, 240, 200)
        Lighting.FogEnd = 120000
        Lighting.FogStart = 0
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                if obj.Name:lower():find("grass") or 
                   obj.Name:lower():find("lawn") or 
                   obj.Name:lower():find("field") or
                   obj.Name:lower():find("ground") then
                    
                    if not originalMaterials[obj] then
                        originalMaterials[obj] = obj.Material
                        originalColors[obj] = obj.Color
                    end
                    
                    obj.Material = Enum.Material.Grass
                    obj.BrickColor = BrickColor.new("Dark green")
                    obj.Color = Color3.fromRGB(0, 100, 0)
                end
            elseif obj:IsA("Model") then
                if obj.Name:lower():find("grass") or 
                   obj.Name:lower():find("lawn") or 
                   obj.Name:lower():find("field") then
                    
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("Part") then
                            if not originalMaterials[part] then
                                originalMaterials[part] = part.Material
                                originalColors[part] = part.Color
                            end
                            
                            part.Material = Enum.Material.Grass
                            part.BrickColor = BrickColor.new("Dark green")
                            part.Color = Color3.fromRGB(0, 100, 0)
                        end
                    end
                end
            end
        end
    else
        if not winterEnabled and not springEnabled and not autumnEnabled then
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.FogColor = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.Brightness = 1
        end
    end
end

local function setupAutumn(enabled)
    if enabled then
        disableAllSeasons()
    end
    
    autumnEnabled = enabled
    settingsState.autumnMode = enabled
    
    if enabled then
        Lighting.Ambient = Color3.fromRGB(200, 150, 100)
        Lighting.OutdoorAmbient = Color3.fromRGB(180, 130, 80)
        Lighting.Brightness = 0.8
        Lighting.ClockTime = 16
        
        Lighting.FogColor = Color3.fromRGB(220, 180, 120)
        Lighting.FogEnd = 70000
        Lighting.FogStart = 0
        
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                if obj.Name:lower():find("grass") or 
                   obj.Name:lower():find("lawn") or 
                   obj.Name:lower():find("field") or
                   obj.Name:lower():find("ground") then
                    
                    if not originalMaterials[obj] then
                        originalMaterials[obj] = obj.Material
                        originalColors[obj] = obj.Color
                    end
                    
                    obj.Material = Enum.Material.Grass
                    obj.BrickColor = BrickColor.new("Brown")
                    obj.Color = Color3.fromRGB(139, 69, 19)
                end
            elseif obj:IsA("Model") then
                if obj.Name:lower():find("grass") or 
                   obj.Name:lower():find("lawn") or 
                   obj.Name:lower():find("field") then
                    
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("Part") then
                            if not originalMaterials[part] then
                                originalMaterials[part] = part.Material
                                originalColors[part] = part.Color
                            end
                            
                            part.Material = Enum.Material.Grass
                            part.BrickColor = BrickColor.new("Brown")
                            part.Color = Color3.fromRGB(139, 69, 19)
                        end
                    end
                end
            end
        end
    else
        if not winterEnabled and not springEnabled and not summerEnabled then
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            Lighting.FogColor = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.Brightness = 1
        end
    end
end

local function setupTextureColors()
    if not textureColorsEnabled then return end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") then
            local textureType = nil
            
            if obj.Name:lower():find("grass") or obj.Name:lower():find("lawn") or obj.Name:lower():find("field") then
                textureType = "grass"
            elseif obj.Name:lower():find("sand") or obj.Name:lower():find("beach") then
                textureType = "sand"
            elseif obj.Name:lower():find("rock") or obj.Name:lower():find("stone") or obj.Name:lower():find("cliff") then
                textureType = "rock"
            elseif obj.Name:lower():find("water") or obj.Name:lower():find("ocean") or obj.Name:lower():find("sea") or obj.Name:lower():find("river") then
                textureType = "ocean"
            elseif obj.Name:lower():find("snow") or obj.Name:lower():find("ice") then
                textureType = "snow"
            elseif obj.Name:lower():find("ground") or obj.Name:lower():find("dirt") or obj.Name:lower():find("soil") then
                textureType = "ground"
            end
            
            if textureType and settingsState.textureColors[textureType] then
                if not originalTextureColors[obj] then
                    originalTextureColors[obj] = obj.Color
                end
                obj.Color = settingsState.textureColors[textureType]
            end
        elseif obj:IsA("Model") then
            local textureType = nil
            
            if obj.Name:lower():find("grass") or obj.Name:lower():find("lawn") or obj.Name:lower():find("field") then
                textureType = "grass"
            elseif obj.Name:lower():find("sand") or obj.Name:lower():find("beach") then
                textureType = "sand"
            elseif obj.Name:lower():find("rock") or obj.Name:lower():find("stone") or obj.Name:lower():find("cliff") then
                textureType = "rock"
            elseif obj.Name:lower():find("water") or obj.Name:lower():find("ocean") or obj.Name:lower():find("sea") or obj.Name:lower():find("river") then
                textureType = "ocean"
            elseif obj.Name:lower():find("snow") or obj.Name:lower():find("ice") then
                textureType = "snow"
            elseif obj.Name:lower():find("ground") or obj.Name:lower():find("dirt") or obj.Name:lower():find("soil") then
                textureType = "ground"
            end
            
            if textureType and settingsState.textureColors[textureType] then
                for _, part in ipairs(obj:GetDescendants()) do
                    if part:IsA("Part") then
                        if not originalTextureColors[part] then
                            originalTextureColors[part] = part.Color
                        end
                        part.Color = settingsState.textureColors[textureType]
                    end
                end
            end
        end
    end
end

local function resetTextureColors()
    for obj, originalColor in pairs(originalTextureColors) do
        if obj and obj.Parent then
            obj.Color = originalColor
        end
    end
    originalTextureColors = {}
end

local function setupRemoveTexture(enabled)
    removeTextureEnabled = enabled
    settingsState.removeTexture = enabled
    
    if enabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                if not originalMaterials[obj] then
                    originalMaterials[obj] = obj.Material
                end
                obj.Material = Enum.Material.Plastic
            elseif obj:IsA("Model") then
                for _, part in ipairs(obj:GetDescendants()) do
                    if part:IsA("Part") then
                        if not originalMaterials[part] then
                            originalMaterials[part] = part.Material
                        end
                        part.Material = Enum.Material.Plastic
                    end
                end
            end
        end
        showNotification("Textures removed for FPS boost")
    else
        for obj, originalMaterial in pairs(originalMaterials) do
            if obj and obj.Parent then
                obj.Material = originalMaterial
            end
        end
        showNotification("Textures restored")
    end
end

local function setupRemoveColor(enabled)
    removeColorEnabled = enabled
    settingsState.removeColor = enabled
    
    if enabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                if not originalColors[obj] then
                    originalColors[obj] = obj.Color
                end
                obj.Color = Color3.fromRGB(128, 128, 128)
            elseif obj:IsA("Model") then
                for _, part in ipairs(obj:GetDescendants()) do
                    if part:IsA("Part") then
                        if not originalColors[part] then
                            originalColors[part] = part.Color
                        end
                        part.Color = Color3.fromRGB(128, 128, 128)
                    end
                end
            end
        end
        showNotification("Colors removed for FPS boost")
    else
        for obj, originalColor in pairs(originalColors) do
            if obj and obj.Parent then
                obj.Color = originalColor
            end
        end
        showNotification("Colors restored")
    end
end

local function setupRenderDistance(distance)
    local value = tonumber(distance) or 100
    value = math.clamp(value, 1, 100)
    settingsState.renderDistance = value
    
    local fogEnd = 10000 - (value * 100)
    fogEnd = math.max(fogEnd, 10)
    Lighting.FogEnd = fogEnd
    
    showNotification("Render distance set to: " .. value)
end

local function setupSimpleLighting(enabled)
    simpleLightingEnabled = enabled
    settingsState.simpleLighting = enabled
    
    if enabled then
        if not originalGraphicsSettings.globalShadows then
            originalGraphicsSettings.globalShadows = Lighting.GlobalShadows
            originalGraphicsSettings.brightness = Lighting.Brightness
        end
        
        Lighting.GlobalShadows = false
        Lighting.Brightness = 2
        showNotification("Simple lighting enabled for FPS boost")
    else
        if originalGraphicsSettings.globalShadows ~= nil then
            Lighting.GlobalShadows = originalGraphicsSettings.globalShadows
            Lighting.Brightness = originalGraphicsSettings.brightness or 1
        else
            Lighting.GlobalShadows = true
            Lighting.Brightness = 1
        end
        showNotification("Lighting restored")
    end
end

local function setupLightColor(color, colorName)
    if color then
        local saturation = settingsState.lightSaturation / 100
        local h, s, v = color:ToHSV()
        local saturatedColor = Color3.fromHSV(h, math.min(s * saturation, 1), v)
        
        Lighting.Ambient = saturatedColor
        Lighting.OutdoorAmbient = saturatedColor
        Lighting.ColorShift_Top = saturatedColor
        settingsState.lightColor = color
    end
end

local function setupLightSaturation(saturation)
    local value = tonumber(saturation) or 100
    value = math.clamp(value, 0, 200)
    settingsState.lightSaturation = value
    setupLightColor(settingsState.lightColor)
end

local function setupTime(timeValue)
    local value = tonumber(timeValue) or 14
    value = math.clamp(value, 0, 24)
    settingsState.time = value
    Lighting.ClockTime = value
end

local function setupNightMode(enabled)
    nightModeEnabled = enabled
    settingsState.nightMode = enabled
    if enabled then
        Lighting.ClockTime = 0
        Lighting.Ambient = Color3.new(0.1, 0.1, 0.2)
        Lighting.Brightness = 0.1
    else
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
    end
end

local function setupLowGraphics(enabled)
    lowGraphicsEnabled = enabled
    settingsState.lowGraphics = enabled
    if enabled then
        if not originalGraphicsSettings.globalShadows then
            originalGraphicsSettings.globalShadows = Lighting.GlobalShadows
            originalGraphicsSettings.fogEnd = Lighting.FogEnd
        end
        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") then
                if not originalMaterials[obj] then
                    originalMaterials[obj] = obj.Material
                end
                obj.Material = Enum.Material.Plastic
            end
        end
    else
        if originalGraphicsSettings.globalShadows ~= nil then
            Lighting.GlobalShadows = originalGraphicsSettings.globalShadows
            Lighting.FogEnd = originalGraphicsSettings.fogEnd or 100000
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
        end
        
        for obj, originalMaterial in pairs(originalMaterials) do
            if obj and obj.Parent then
                obj.Material = originalMaterial
            end
        end
    end
end

local function setupDisco(enabled)
    discoEnabled = enabled
    settingsState.discoMode = enabled
    if enabled then
        local discoConnection
        local hue = 0
        discoConnection = RunService.Heartbeat:Connect(function()
            if not discoEnabled then
                discoConnection:Disconnect()
                Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
                return
            end
            
            hue = (hue + 0.01) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            Lighting.Ambient = color
            Lighting.Brightness = 2
        end)
    else
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = 1
    end
end

local function setupScreenBlur(intensity)
    local value = tonumber(intensity) or 0
    value = math.clamp(value, 1, 100)
    settingsState.screenBlur = value
    BlurEffect.Size = value
    BlurEffect.Enabled = value > 0
end

local function setupDepthBlur(intensity)
    local value = tonumber(intensity) or 0
    value = math.clamp(value, 1, 100)
    settingsState.depthBlur = value
    
    local camera = workspace.CurrentCamera
    if camera then
        if not camera:FindFirstChild("DepthOfField") then
            local depthOfField = Instance.new("DepthOfFieldEffect")
            depthOfField.Name = "DepthOfField"
            depthOfField.Parent = camera
        end
        
        local depthOfField = camera:FindFirstChild("DepthOfField")
        depthOfField.Enabled = value > 0
        depthOfField.FarIntensity = value / 100
        depthOfField.FocusDistance = 0.1
        depthOfField.InFocusRadius = 10
    end
end

local function setupFogIntensity(intensity)
    local value = tonumber(intensity) or 0
    value = math.clamp(value, 0, 100)
    settingsState.fogIntensity = value
    
    local fogEnd = 10000 - (value * 100)
    fogEnd = math.max(fogEnd, 10)
    Lighting.FogEnd = fogEnd
    Lighting.FogStart = 0
end

local function setupFogColor(color, colorName)
    Lighting.FogColor = color
    settingsState.fogColor = color
end

local function setupRTXGraphics()
    loadstring(game:HttpGet("https://pastebin.com/raw/uqD7VqQU"))()
    showNotification("RTX Graphics enabled! This action is irreversible!")
end

local function setupPShade()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua'))()
    showNotification("PShade Ultimate loaded!")
end

local function setupViewFPS(enabled)
    viewFPSEnabled = enabled
    settingsState.viewFPS = enabled
    StatsFrame.Visible = enabled
end

local function updateLanguage()
    local t = translations[currentLanguage]
    settingsState.language = currentLanguage
    
    for _, sectionName in ipairs(sections) do
        local button = LeftPanel:FindFirstChild(sectionName .. "Button")
        if button then
            button.Text = getText(sectionName:lower())
        end
    end
    
    creditLabel.Text = getText("credit")
    
    if viewFPSEnabled then
        StatsLabel.Text = getText("fpsPlaceholder")
    end
    
    local activeSection = nil
    for _, sectionName in ipairs(sections) do
        local button = LeftPanel:FindFirstChild(sectionName .. "Button")
        if button and button.BackgroundColor3 == themes[currentTheme].accentColor then
            activeSection = sectionName
            break
        end
    end
    
    if activeSection then
        if activeSection == "Light" then
            setupLightSection()
        elseif activeSection == "Season" then
            setupSeasonSection()
        elseif activeSection == "Shaders" then
            setupShadersSection()
        elseif activeSection == "Textures" then
            setupTexturesSection()
        elseif activeSection == "FPS boost" then
            setupFPSBoostSection()
        elseif activeSection == "Animation" then
            setupAnimationSection()
        elseif activeSection == "Other" then
            setupOtherSection()
        elseif activeSection == "Settings" then
            setupSettingsSection()
        end
    end
end

local function setupLightSection()
    clearRightPanel()
    
    local yOffset = 10
    
    local timeInput = createInputField("time", tostring(settingsState.time), "enterTime", function(text)
        setupTime(text)
    end)
    timeInput.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 60 or 70)
    
    local timeCycleToggle = createToggle("timeCycle", timeCycleEnabled, function(enabled)
        setupTimeCycle(enabled)
    end)
    timeCycleToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local realTimeToggle = createToggle("realTime", realTimeEnabled, function(enabled)
        setupRealTime(enabled)
    end)
    realTimeToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local lightColorPalette = createColorPalette("lightColor", settingsState.lightColor, function(color, colorName)
        setupLightColor(color, colorName)
    end)
    lightColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local saturationInput = createInputField("lightSaturation", tostring(settingsState.lightSaturation), "saturationPlaceholder", function(text)
        setupLightSaturation(text)
    end)
    saturationInput.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 60 or 70)
    
    local graphicsFrame = Instance.new("Frame")
    graphicsFrame.Name = "GraphicsFrame"
    graphicsFrame.Size = UDim2.new(1, -20, 0, isMobile and 160 or 180)
    graphicsFrame.Position = UDim2.new(0, 10, 0, yOffset)
    graphicsFrame.BackgroundColor3 = themes[currentTheme].buttonColor
    graphicsFrame.BackgroundTransparency = 0.2
    graphicsFrame.BorderSizePixel = 0
    graphicsFrame.ZIndex = 4
    graphicsFrame.Parent = RightPanel
    
    local graphicsCorner = Instance.new("UICorner")
    graphicsCorner.CornerRadius = UDim.new(0, 6)
    graphicsCorner.Parent = graphicsFrame
    
    local graphicsLabel = Instance.new("TextLabel")
    graphicsLabel.Name = "GraphicsLabel"
    graphicsLabel.Size = UDim2.new(1, -20, 0, isMobile and 22 or 25)
    graphicsLabel.Position = UDim2.new(0, 10, 0, 10)
    graphicsLabel.BackgroundTransparency = 1
    graphicsLabel.Text = getText("graphics")
    graphicsLabel.TextColor3 = themes[currentTheme].textColor
    graphicsLabel.TextSize = isMobile and mobileTextSize or 16
    graphicsLabel.Font = Enum.Font.GothamBold
    graphicsLabel.ZIndex = 5
    graphicsLabel.Parent = graphicsFrame
    
    local graphicsPresetsList = {"Default", "Neon", "Midnight", "Vintage"}
    
    for i, preset in ipairs(graphicsPresetsList) do
        local presetButton = Instance.new("TextButton")
        presetButton.Name = preset .. "Button"
        presetButton.Size = UDim2.new(1, -20, 0, isMobile and 22 or 25)
        presetButton.Position = UDim2.new(0, 10, 0, 40 + (i-1) * (isMobile and 27 or 30))
        presetButton.BackgroundColor3 = settingsState.currentGraphics == preset and themes[currentTheme].accentColor or themes[currentTheme].secondaryColor
        presetButton.BorderSizePixel = 0
        presetButton.Text = getText(preset:lower())
        presetButton.TextColor3 = themes[currentTheme].textColor
        presetButton.TextSize = isMobile and mobileTextSize or 14
        presetButton.Font = Enum.Font.Gotham
        presetButton.ZIndex = 5
        presetButton.Parent = graphicsFrame
    
        local presetCorner = Instance.new("UICorner")
        presetCorner.CornerRadius = UDim.new(0, 4)
        presetCorner.Parent = presetButton
        
        presetButton.MouseButton1Click:Connect(function()
            applyGraphicsPreset(preset)
            setupLightSection()
        end)
    end
    
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local nightToggle = createToggle("nightMode", nightModeEnabled, function(enabled)
        setupNightMode(enabled)
    end)
    nightToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

local function setupAnimationSection()
    clearRightPanel()
    
    local yOffset = 10
    
    local tailToggle = createToggle("tail", tailEnabled, function(enabled)
        setupTail(enabled)
    end)
    tailToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local tailColorPalette = createColorPalette("tailColor", settingsState.tailColor, function(color, colorName)
        updateTailColor(color)
    end)
    tailColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local firefliesToggle = createToggle("fireflies", firefliesEnabled, function(enabled)
        setupFireflies(enabled)
    end)
    firefliesToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local fireflyColorPalette = createColorPalette("fireflyColor", settingsState.fireflyColor, function(color, colorName)
        updateFireflyColor(color)
    end)
    fireflyColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

local function setupOtherSection()
    clearRightPanel()
    
    local yOffset = 10
    
    local crosshairToggle = createToggle("crosshair", crosshairEnabled, function(enabled)
        setupCrosshair(enabled)
    end)
    crosshairToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local crosshairColorPalette = createColorPalette("crosshairColor", settingsState.crosshairColor, function(color, colorName)
        updateCrosshairColor(color)
    end)
    crosshairColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local discoToggle = createToggle("discoMode", discoEnabled, function(enabled)
        setupDisco(enabled)
    end)
    discoToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local fovInput = createInputField("fieldOfView", tostring(settingsState.fieldOfView), "fovPlaceholder", function(text)
        local value = tonumber(text)
        if value then
            value = math.clamp(value, 50, 120)
            settingsState.fieldOfView = value
            local camera = workspace.CurrentCamera
            if camera then
                camera.FieldOfView = value
            end
        end
    end)
    fovInput.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 60 or 70)
    
    local espToggle = createToggle("esp", espEnabled, function(enabled)
        setupESP(enabled)
    end)
    espToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local espColorPalette = createColorPalette("espColor", settingsState.espColor, function(color, colorName)
        updateESPColor(color)
    end)
    espColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local hitboxToggle = createToggle("showHitboxes", showHitboxesEnabled, function(enabled)
        setupHitboxes(enabled)
    end)
    hitboxToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local lowGraphicsToggle = createToggle("lowGraphics", lowGraphicsEnabled, function(enabled)
        setupLowGraphics(enabled)
    end)
    lowGraphicsToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local viewFPSToggle = createToggle("viewFPS", viewFPSEnabled, function(enabled)
        setupViewFPS(enabled)
    end)
    viewFPSToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local aspectToggle = createToggle("aspectRatio43", aspectRatioEnabled, function(enabled)
        setupAspectRatio43(enabled)
    end)
    aspectToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

local function setupSeasonSection()
    clearRightPanel()
    
    local yOffset = 10
    
    local winterToggle = createToggle("winterMode", winterEnabled, function(enabled)
        setupWinter(enabled)
    end)
    winterToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local springToggle = createToggle("springMode", springEnabled, function(enabled)
        setupSpring(enabled)
    end)
    springToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local summerToggle = createToggle("summerMode", summerEnabled, function(enabled)
        setupSummer(enabled)
    end)
    summerToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local autumnToggle = createToggle("autumnMode", autumnEnabled, function(enabled)
        setupAutumn(enabled)
    end)
    autumnToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local resetButton = createButton("resetSeasonColors", function()
        resetSeasonColors()
    end)
    resetButton.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 45 or 50)
    
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

local function setupShadersSection()
    clearRightPanel()
    
    local yOffset = 10
    
    local screenBlurInput = createInputField("screenBlur", tostring(settingsState.screenBlur), "intensityPlaceholder", function(text)
        setupScreenBlur(text)
    end)
    screenBlurInput.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 60 or 70)
    
    local depthBlurInput = createInputField("depthBlur", tostring(settingsState.depthBlur), "intensityPlaceholder", function(text)
        setupDepthBlur(text)
    end)
    depthBlurInput.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 60 or 70)
    
    local fogInput = createInputField("fogIntensity", tostring(settingsState.fogIntensity), "intensityPlaceholder", function(text)
        setupFogIntensity(text)
    end)
    fogInput.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 60 or 70)
    
    local fogColorPalette = createColorPalette("fogColor", settingsState.fogColor, function(color, colorName)
        setupFogColor(color, colorName)
    end)
    fogColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local rtxButton = createButton("rtxGraphics", function()
        setupRTXGraphics()
    end)
    rtxButton.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 45 or 50)
    
    local pshadeButton = createButton("pshade", function()
        setupPShade()
    end)
    pshadeButton.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 45 or 50)
    
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

local function setupTexturesSection()
    clearRightPanel()
    
    local yOffset = 10
    
    local textureToggle = createToggle("textures", textureColorsEnabled, function(enabled)
        textureColorsEnabled = enabled
        if enabled then
            setupTextureColors()
        else
            resetTextureColors()
        end
    end)
    textureToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local grassColorPalette = createColorPalette("grassColor", settingsState.textureColors.grass, function(color, colorName)
        settingsState.textureColors.grass = color
        if textureColorsEnabled then
            setupTextureColors()
        end
    end)
    grassColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local sandColorPalette = createColorPalette("sandColor", settingsState.textureColors.sand, function(color, colorName)
        settingsState.textureColors.sand = color
        if textureColorsEnabled then
            setupTextureColors()
        end
    end)
    sandColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local rockColorPalette = createColorPalette("rockColor", settingsState.textureColors.rock, function(color, colorName)
        settingsState.textureColors.rock = color
        if textureColorsEnabled then
            setupTextureColors()
        end
    end)
    rockColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local oceanColorPalette = createColorPalette("oceanColor", settingsState.textureColors.ocean, function(color, colorName)
        settingsState.textureColors.ocean = color
        if textureColorsEnabled then
            setupTextureColors()
        end
    end)
    oceanColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local snowColorPalette = createColorPalette("snowColor", settingsState.textureColors.snow, function(color, colorName)
        settingsState.textureColors.snow = color
        if textureColorsEnabled then
            setupTextureColors()
        end
    end)
    snowColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local groundColorPalette = createColorPalette("groundColor", settingsState.textureColors.ground, function(color, colorName)
        settingsState.textureColors.ground = color
        if textureColorsEnabled then
            setupTextureColors()
        end
    end)
    groundColorPalette.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 170 or 190)
    
    local applyButton = createButton("applyTextureColors", function()
        setupTextureColors()
        showNotification("Texture colors applied!")
    end)
    applyButton.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 45 or 50)
    
    local resetButton = createButton("resetTextureColors", function()
        resetTextureColors()
        showNotification("Texture colors reset!")
    end)
    resetButton.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 45 or 50)
    
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

local function setupFPSBoostSection()
    clearRightPanel()
    
    local yOffset = 10
    
    local removeTextureToggle = createToggle("removeTexture", removeTextureEnabled, function(enabled)
        setupRemoveTexture(enabled)
    end)
    removeTextureToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local removeColorToggle = createToggle("removeColor", removeColorEnabled, function(enabled)
        setupRemoveColor(enabled)
    end)
    removeColorToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    local renderDistanceInput = createInputField("renderDistance", tostring(settingsState.renderDistance), "enterDistance", function(text)
        setupRenderDistance(text)
    end)
    renderDistanceInput.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 60 or 70)
    
    local simpleLightingToggle = createToggle("simpleLighting", simpleLightingEnabled, function(enabled)
        setupSimpleLighting(enabled)
    end)
    simpleLightingToggle.Position = UDim2.new(0, 10, 0, yOffset)
    yOffset = yOffset + (isMobile and 50 or 60)
    
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

local function setupSettingsSection()
    clearRightPanel()
    
    local yOffset = 10
    
    local languageFrame = Instance.new("Frame")
    languageFrame.Name = "LanguageFrame"
    languageFrame.Size = UDim2.new(1, -20, 0, isMobile and 100 or 120)
    languageFrame.Position = UDim2.new(0, 10, 0, yOffset)
    languageFrame.BackgroundColor3 = themes[currentTheme].buttonColor
    languageFrame.BackgroundTransparency = 0.2
    languageFrame.BorderSizePixel = 0
    languageFrame.ZIndex = 4
    languageFrame.Parent = RightPanel
    
    local languageCorner = Instance.new("UICorner")
    languageCorner.CornerRadius = UDim.new(0, 6)
    languageCorner.Parent = languageFrame
    
    local languageLabel = Instance.new("TextLabel")
    languageLabel.Name = "LanguageLabel"
    languageLabel.Size = UDim2.new(1, -20, 0, isMobile and 22 or 25)
    languageLabel.Position = UDim2.new(0, 10, 0, 10)
    languageLabel.BackgroundTransparency = 1
    languageLabel.Text = getText("selectLanguage")
    languageLabel.TextColor3 = themes[currentTheme].textColor
    languageLabel.TextSize = isMobile and mobileTextSize or 16
    languageLabel.Font = Enum.Font.GothamBold
    languageLabel.ZIndex = 5
    languageLabel.Parent = languageFrame
    
    local languages = {"English", "Russian", "Ukrainian"}
    
    for i, lang in ipairs(languages) do
        local langButton = Instance.new("TextButton")
        langButton.Name = lang .. "Button"
        langButton.Size = UDim2.new(1, -20, 0, isMobile and 22 or 25)
        langButton.Position = UDim2.new(0, 10, 0, 40 + (i-1) * (isMobile and 27 or 30))
        langButton.BackgroundColor3 = currentLanguage == lang and themes[currentTheme].accentColor or themes[currentTheme].secondaryColor
        langButton.BorderSizePixel = 0
        langButton.Text = lang
        langButton.TextColor3 = themes[currentTheme].textColor
        langButton.TextSize = isMobile and mobileTextSize or 14
        langButton.Font = Enum.Font.Gotham
        langButton.ZIndex = 5
        langButton.Parent = languageFrame
    
        local langCorner = Instance.new("UICorner")
        langCorner.CornerRadius = UDim.new(0, 4)
        langCorner.Parent = langButton
        
        langButton.MouseButton1Click:Connect(function()
            currentLanguage = lang
            updateLanguage()
            setupSettingsSection()
        end)
    end
    
    yOffset = yOffset + (isMobile and 110 or 130)
    
    local themeFrame = Instance.new("Frame")
    themeFrame.Name = "ThemeFrame"
    themeFrame.Size = UDim2.new(1, -20, 0, isMobile and 220 or 260)
    themeFrame.Position = UDim2.new(0, 10, 0, yOffset)
    themeFrame.BackgroundColor3 = themes[currentTheme].buttonColor
    themeFrame.BackgroundTransparency = 0.2
    themeFrame.BorderSizePixel = 0
    themeFrame.ZIndex = 4
    themeFrame.Parent = RightPanel
    
    local themeCorner = Instance.new("UICorner")
    themeCorner.CornerRadius = UDim.new(0, 6)
    themeCorner.Parent = themeFrame
    
    local themeLabel = Instance.new("TextLabel")
    themeLabel.Name = "ThemeLabel"
    themeLabel.Size = UDim2.new(1, -20, 0, isMobile and 22 or 25)
    themeLabel.Position = UDim2.new(0, 10, 0, 10)
    themeLabel.BackgroundTransparency = 1
    themeLabel.Text = getText("selectTheme")
    themeLabel.TextColor3 = themes[currentTheme].textColor
    themeLabel.TextSize = isMobile and mobileTextSize or 16
    themeLabel.Font = Enum.Font.GothamBold
    themeLabel.ZIndex = 5
    themeLabel.Parent = themeFrame
    
    local themeColors = {"Blue", "Purple", "Red", "Green", "Yellow", "Cyan", "Pink", "Orange", "Sand", "Ocean", "Forest", "Midnight", "Lavender", "Coral", "Emerald", "Sunset", "Arctic", "Berry", "Gold", "Sky"}
    
    local buttonsPerRow = 4
    local buttonWidth = 0.23
    local buttonHeight = isMobile and 20 or 24
    local buttonSpacing = isMobile and 5 or 8
    local startY = 40
    
    for i, theme in ipairs(themeColors) do
        local row = math.floor((i-1) / buttonsPerRow)
        local col = (i-1) % buttonsPerRow
        
        local themeButton = Instance.new("TextButton")
        themeButton.Name = theme .. "Button"
        themeButton.Size = UDim2.new(buttonWidth, -5, 0, buttonHeight)
        themeButton.Position = UDim2.new(buttonWidth * col, 10 + (col * 5), 0, startY + row * (buttonHeight + buttonSpacing))
        themeButton.BackgroundColor3 = themes[theme].accentColor
        themeButton.BorderSizePixel = 0
        themeButton.Text = theme
        themeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        themeButton.TextSize = isMobile and 8 or 10
        themeButton.Font = Enum.Font.GothamBold
        themeButton.ZIndex = 5
        themeButton.Parent = themeFrame
        
        local themeCorner = Instance.new("UICorner")
        themeCorner.CornerRadius = UDim.new(0, 4)
        themeCorner.Parent = themeButton
        
        local themeStroke = Instance.new("UIStroke")
        themeStroke.Thickness = 2
        themeStroke.Color = Color3.new(1, 1, 1)
        themeStroke.Enabled = currentTheme == theme
        themeStroke.Parent = themeButton
        
        themeButton.MouseButton1Click:Connect(function()
            currentTheme = theme
            settingsState.theme = theme
            updateTheme()
            setupSettingsSection()
        end)
    end
    
    yOffset = yOffset + (isMobile and 220 or 260)
    
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

for _, sectionName in ipairs(sections) do
    local button = LeftPanel:FindFirstChild(sectionName .. "Button")
    if button then
        button.MouseButton1Click:Connect(function()
            for _, otherButton in ipairs(LeftPanel:GetChildren()) do
                if otherButton:IsA("TextButton") then
                    otherButton.BackgroundColor3 = themes[currentTheme].buttonColor
                end
            end
            button.BackgroundColor3 = themes[currentTheme].accentColor
            
            if sectionName == "Light" then
                setupLightSection()
            elseif sectionName == "Season" then
                setupSeasonSection()
            elseif sectionName == "Shaders" then
                setupShadersSection()
            elseif sectionName == "Textures" then
                setupTexturesSection()
            elseif sectionName == "FPS boost" then
                setupFPSBoostSection()
            elseif sectionName == "Animation" then
                setupAnimationSection()
            elseif sectionName == "Other" then
                setupOtherSection()
            elseif sectionName == "Settings" then
                setupSettingsSection()
            end
        end)
    end
end

spawn(function()
    showSplashScreen()
    OpenButton.Visible = true
end)

local firstButton = LeftPanel:FindFirstChild(sections[1] .. "Button")
if firstButton then
    firstButton.BackgroundColor3 = themes[currentTheme].accentColor
    setupLightSection()
end
