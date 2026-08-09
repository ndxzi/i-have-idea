local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "FreedomUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local mainWidth = 720
local mainHeight = 500

local customCursor = Instance.new("Frame")
customCursor.Name = "CustomCursor"
customCursor.Size = UDim2.new(0, 8, 0, 8)
customCursor.AnchorPoint = Vector2.new(0.5, 0.5)
customCursor.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
customCursor.BorderSizePixel = 0
customCursor.ZIndex = 100
customCursor.Parent = gui
Instance.new("UICorner", customCursor).CornerRadius = UDim.new(1, 0)

local cursorGlow = Instance.new("Frame")
cursorGlow.Size = UDim2.new(0, 16, 0, 16)
cursorGlow.AnchorPoint = Vector2.new(0.5, 0.5)
cursorGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
cursorGlow.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
cursorGlow.BackgroundTransparency = 0.7
cursorGlow.BorderSizePixel = 0
cursorGlow.ZIndex = 99
cursorGlow.Parent = customCursor
Instance.new("UICorner", cursorGlow).CornerRadius = UDim.new(1, 0)

local statsBar = Instance.new("Frame")
statsBar.Name = "StatsBar"
statsBar.Size = UDim2.new(0, 400, 0, 32)
statsBar.Position = UDim2.new(0.5, -200, 0, 5)
statsBar.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
statsBar.BackgroundTransparency = 0.2
statsBar.BorderSizePixel = 0
statsBar.Active = true
statsBar.Draggable = true
statsBar.Parent = gui
Instance.new("UICorner", statsBar).CornerRadius = UDim.new(0, 10)
local statsStroke = Instance.new("UIStroke")
statsStroke.Color = Color3.fromRGB(80, 190, 255)
statsStroke.Thickness = 1
statsStroke.Transparency = 0.4
statsStroke.Parent = statsBar

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -16, 1, 0)
statsLabel.Position = UDim2.new(0, 8, 0, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.GothamMedium
statsLabel.TextColor3 = Color3.fromRGB(200, 220, 240)
statsLabel.TextSize = 13
statsLabel.Text = ""
statsLabel.TextXAlignment = Enum.TextXAlignment.Center
statsLabel.Parent = statsBar

local frameCount = 0
local lastFPSTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        local now = tick()
        local fps = math.floor(frameCount / (now - lastFPSTime))
        frameCount = 0
        lastFPSTime = now
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        local timeStr = os.date("%H:%M:%S")
        statsLabel.Text = player.DisplayName .. "  |  FPS: " .. fps .. "  |  PING: " .. ping .. "ms  |  " .. timeStr
    end
end)

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, mainWidth, 0, mainHeight)
main.Position = UDim2.new(0.5, -mainWidth / 2, 0.5, -mainHeight / 2)
main.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 190, 255)
mainStroke.Thickness = 1.6
mainStroke.Transparency = 0.3
mainStroke.Parent = main

local modalButton = Instance.new("TextButton")
modalButton.Name = "ModalCapture"
modalButton.Size = UDim2.new(1, 0, 1, 0)
modalButton.BackgroundTransparency = 1
modalButton.Text = ""
modalButton.Modal = true
modalButton.ZIndex = 0
modalButton.Parent = main

local patternLayer = Instance.new("Frame")
patternLayer.Name = "PatternLayer"
patternLayer.BackgroundTransparency = 1
patternLayer.Size = UDim2.new(1, 0, 2, 0)
patternLayer.Position = UDim2.new(0, 0, 0, 0)
patternLayer.ZIndex = 1
patternLayer.ClipsDescendants = false
patternLayer.Parent = main

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
topBar.BorderSizePixel = 0
topBar.ZIndex = 10
topBar.Active = true
topBar.Parent = main

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topCorner.Parent = topBar

local topFix = Instance.new("Frame")
topFix.BackgroundColor3 = topBar.BackgroundColor3
topFix.BorderSizePixel = 0
topFix.Size = UDim2.new(1, 0, 0, 14)
topFix.Position = UDim2.new(0, 0, 1, -14)
topFix.ZIndex = 10
topFix.Parent = topBar

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.AnchorPoint = Vector2.new(1, 0.5)
title.Position = UDim2.new(1, -16, 0.5, 0)
title.Size = UDim2.new(0, 180, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "Freedom"
title.TextColor3 = Color3.fromRGB(80, 200, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Right
title.ZIndex = 11
title.Parent = topBar

local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 150, 1, -38)
leftPanel.Position = UDim2.new(0, 0, 0, 38)
leftPanel.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
leftPanel.BorderSizePixel = 0
leftPanel.ZIndex = 5
leftPanel.ClipsDescendants = true
leftPanel.Parent = main

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 14)
leftCorner.Parent = leftPanel

local leftFixRight = Instance.new("Frame")
leftFixRight.BackgroundColor3 = leftPanel.BackgroundColor3
leftFixRight.BorderSizePixel = 0
leftFixRight.Size = UDim2.new(0, 14, 1, -14)
leftFixRight.Position = UDim2.new(1, -14, 0, 0)
leftFixRight.ZIndex = 5
leftFixRight.Parent = leftPanel

local leftFixTop = Instance.new("Frame")
leftFixTop.BackgroundColor3 = leftPanel.BackgroundColor3
leftFixTop.BorderSizePixel = 0
leftFixTop.Size = UDim2.new(1, -14, 0, 14)
leftFixTop.Position = UDim2.new(0, 0, 0, 0)
leftFixTop.ZIndex = 5
leftFixTop.Parent = leftPanel

local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.BackgroundTransparency = 1
tabContainer.Size = UDim2.new(1, 0, 1, 0)
tabContainer.ZIndex = 6
tabContainer.Parent = leftPanel

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 6)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 14)
tabPadding.Parent = tabContainer

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.BackgroundTransparency = 1
contentArea.Size = UDim2.new(1, -172, 1, -50)
contentArea.Position = UDim2.new(0, 156, 0, 44)
contentArea.ZIndex = 5
contentArea.Parent = main

local pages = {}
local tabs = {}
local currentTab = nil

local function switchTab(name)
    if currentTab == name then return end
    for n, t in pairs(tabs) do
        if n == name then
            t.page.Visible = true
            TweenService:Create(t.btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(60, 75, 90)}):Play()
            TweenService:Create(t.label, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(230, 245, 255)}):Play()
            TweenService:Create(t.stroke, TweenInfo.new(0.25), {Thickness = 1.2}):Play()
            TweenService:Create(t.indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 22)}):Play()
        else
            t.page.Visible = false
            TweenService:Create(t.btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(48, 48, 55)}):Play()
            TweenService:Create(t.label, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(175, 185, 195)}):Play()
            TweenService:Create(t.stroke, TweenInfo.new(0.25), {Thickness = 0}):Play()
            TweenService:Create(t.indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 0)}):Play()
        end
    end
    currentTab = name
end

local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = Color3.fromRGB(48, 48, 55)
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.ZIndex = 7
    btn.Parent = tabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(80, 190, 255)
    btnStroke.Thickness = 0
    btnStroke.Parent = btn

    local btnLabel = Instance.new("TextLabel")
    btnLabel.BackgroundTransparency = 1
    btnLabel.Size = UDim2.new(1, -20, 1, 0)
    btnLabel.Position = UDim2.new(0, 14, 0, 0)
    btnLabel.Font = Enum.Font.GothamBold
    btnLabel.Text = name
    btnLabel.TextColor3 = Color3.fromRGB(175, 185, 195)
    btnLabel.TextSize = 14
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    btnLabel.ZIndex = 8
    btnLabel.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 9
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 200, 255)
    page.BorderSizePixel = 0
    page.Visible = false
    page.ZIndex = 5
    page.Parent = contentArea

    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 8)
    pagePadding.PaddingLeft = UDim.new(0, 8)
    pagePadding.PaddingRight = UDim.new(0, 8)
    pagePadding.PaddingBottom = UDim.new(0, 8)
    pagePadding.Parent = page

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    end)

    pages[name] = page
    tabs[name] = {btn = btn, label = btnLabel, stroke = btnStroke, indicator = indicator, page = page}

    btn.MouseEnter:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 64)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(48, 48, 55)}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)

    return page
end

local settingsPage = createTab("Settings", 1)
local timerPage = createTab("Others", 2)
local blackholePage = createTab("Blackhole", 3)

local function createSectionLabel(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 28)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(80, 200, 255)
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order
    lbl.ZIndex = 6
    lbl.Parent = parent
end

local function createDropdown(parent, labelText, items, default, order, callback)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 0, 80)
    holder.ClipsDescendants = false
    holder.LayoutOrder = order
    holder.ZIndex = 20
    holder.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 210, 220)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 21
    lbl.Parent = holder

    local btn = Instance.new("TextButton")
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, 28)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 22
    btn.Parent = holder
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(80, 190, 255)
    btnStroke.Thickness = 1.2
    btnStroke.Transparency = 0.3
    btnStroke.Parent = btn

    local selLabel = Instance.new("TextLabel")
    selLabel.BackgroundTransparency = 1
    selLabel.Position = UDim2.new(0, 14, 0, 0)
    selLabel.Size = UDim2.new(1, -44, 1, 0)
    selLabel.Font = Enum.Font.GothamMedium
    selLabel.Text = default
    selLabel.TextColor3 = Color3.fromRGB(230, 240, 250)
    selLabel.TextSize = 14
    selLabel.TextXAlignment = Enum.TextXAlignment.Left
    selLabel.ZIndex = 23
    selLabel.Parent = btn

    local arrowLbl = Instance.new("TextLabel")
    arrowLbl.BackgroundTransparency = 1
    arrowLbl.AnchorPoint = Vector2.new(1, 0.5)
    arrowLbl.Position = UDim2.new(1, -12, 0.5, 0)
    arrowLbl.Size = UDim2.new(0, 16, 0, 16)
    arrowLbl.Font = Enum.Font.GothamBold
    arrowLbl.Text = "▾"
    arrowLbl.TextColor3 = Color3.fromRGB(200, 230, 255)
    arrowLbl.TextSize = 14
    arrowLbl.ZIndex = 23
    arrowLbl.Parent = btn

    local listFrame = Instance.new("Frame")
    listFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
    listFrame.Position = UDim2.new(0, 0, 0, 70)
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.BorderSizePixel = 0
    listFrame.ClipsDescendants = true
    listFrame.ZIndex = 30
    listFrame.Parent = holder
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 10)

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = Color3.fromRGB(80, 190, 255)
    listStroke.Thickness = 1
    listStroke.Transparency = 0.35
    listStroke.Parent = listFrame

    local scroll = Instance.new("ScrollingFrame")
    scroll.BackgroundTransparency = 1
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 200, 255)
    scroll.BorderSizePixel = 0
    scroll.ZIndex = 31
    scroll.Parent = listFrame

    Instance.new("UIPadding", scroll).PaddingTop = UDim.new(0, 6)
    scroll:FindFirstChildOfClass("UIPadding").PaddingBottom = UDim.new(0, 6)
    scroll:FindFirstChildOfClass("UIPadding").PaddingLeft = UDim.new(0, 6)
    scroll:FindFirstChildOfClass("UIPadding").PaddingRight = UDim.new(0, 6)

    local sLayout = Instance.new("UIListLayout")
    sLayout.Padding = UDim.new(0, 4)
    sLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sLayout.Parent = scroll

    sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, sLayout.AbsoluteContentSize.Y + 12)
    end)

    local opened = false

    for i, itemName in ipairs(items) do
        local ibtn = Instance.new("TextButton")
        ibtn.AutoButtonColor = false
        ibtn.BackgroundColor3 = Color3.fromRGB(58, 58, 66)
        ibtn.Size = UDim2.new(1, 0, 0, 30)
        ibtn.Text = itemName
        ibtn.Font = Enum.Font.GothamMedium
        ibtn.TextColor3 = Color3.fromRGB(220, 230, 240)
        ibtn.TextSize = 13
        ibtn.BorderSizePixel = 0
        ibtn.LayoutOrder = i
        ibtn.ZIndex = 32
        ibtn.Parent = scroll
        Instance.new("UICorner", ibtn).CornerRadius = UDim.new(0, 8)

        ibtn.MouseEnter:Connect(function()
            TweenService:Create(ibtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(68, 78, 92)}):Play()
        end)
        ibtn.MouseLeave:Connect(function()
            TweenService:Create(ibtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(58, 58, 66)}):Play()
        end)
        ibtn.MouseButton1Click:Connect(function()
            selLabel.Text = itemName
            if callback then callback(itemName) end
            opened = false
            TweenService:Create(listFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(arrowLbl, TweenInfo.new(0.18), {Rotation = 0}):Play()
        end)
    end

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(58, 58, 68)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(52, 52, 60)}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        opened = not opened
        local tH = opened and math.min(sLayout.AbsoluteContentSize.Y + 12, 150) or 0
        TweenService:Create(listFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, tH)}):Play()
        TweenService:Create(arrowLbl, TweenInfo.new(0.18), {Rotation = opened and 180 or 0}):Play()
    end)
end

local function clearChildren(parent)
    for _, v in ipairs(parent:GetChildren()) do
        v:Destroy()
    end
end

local patternShapes = {}

local function fillPattern(parent, patternName, w, h)
    clearChildren(parent)
    patternShapes = {}
    if w <= 0 or h <= 0 then w = 720 h = 500 end
    local totalH = h * 2

    if patternName == "Circles" then
        for y = 20, totalH, 48 do
            for x = 20, w, 48 do
                local s = math.random(12, 22)
                local f = Instance.new("Frame")
                f.BackgroundColor3 = Color3.fromRGB(58, 58, 66)
                f.BackgroundTransparency = 0.55
                f.Size = UDim2.new(0, s, 0, s)
                f.Position = UDim2.new(0, x + math.random(-6, 6), 0, y + math.random(-6, 6))
                f.BorderSizePixel = 0
                f.ZIndex = 1
                f.Parent = parent
                Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
                table.insert(patternShapes, f)
            end
        end
    elseif patternName == "Squares" then
        for y = 20, totalH, 50 do
            for x = 20, w, 50 do
                local s = math.random(12, 20)
                local f = Instance.new("Frame")
                f.BackgroundColor3 = Color3.fromRGB(58, 58, 66)
                f.BackgroundTransparency = 0.55
                f.Size = UDim2.new(0, s, 0, s)
                f.Position = UDim2.new(0, x + math.random(-5, 5), 0, y + math.random(-5, 5))
                f.BorderSizePixel = 0
                f.ZIndex = 1
                f.Parent = parent
                Instance.new("UICorner", f).CornerRadius = UDim.new(0, 3)
                table.insert(patternShapes, f)
            end
        end
    elseif patternName == "Triangles" then
        for y = 20, totalH, 52 do
            for x = 20, w, 52 do
                local s = math.random(16, 26)
                local f = Instance.new("TextLabel")
                f.BackgroundTransparency = 1
                f.Text = "▲"
                f.TextColor3 = Color3.fromRGB(62, 62, 70)
                f.TextTransparency = 0.55
                f.TextSize = s
                f.Font = Enum.Font.GothamBold
                f.Size = UDim2.new(0, s, 0, s)
                f.Position = UDim2.new(0, x + math.random(-5, 5), 0, y + math.random(-5, 5))
                f.ZIndex = 1
                f.Parent = parent
                table.insert(patternShapes, f)
            end
        end
    elseif patternName == "Rings" then
        for y = 20, totalH, 54 do
            for x = 20, w, 54 do
                local s = math.random(16, 26)
                local f = Instance.new("Frame")
                f.BackgroundTransparency = 1
                f.Size = UDim2.new(0, s, 0, s)
                f.Position = UDim2.new(0, x + math.random(-5, 5), 0, y + math.random(-5, 5))
                f.BorderSizePixel = 0
                f.ZIndex = 1
                f.Parent = parent
                Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
                local st = Instance.new("UIStroke")
                st.Color = Color3.fromRGB(62, 62, 70)
                st.Thickness = 2
                st.Transparency = 0.5
                st.Parent = f
                table.insert(patternShapes, f)
            end
        end
    elseif patternName == "Diamonds" then
        for y = 20, totalH, 50 do
            for x = 20, w, 50 do
                local s = math.random(12, 18)
                local f = Instance.new("Frame")
                f.BackgroundColor3 = Color3.fromRGB(58, 58, 66)
                f.BackgroundTransparency = 0.55
                f.Size = UDim2.new(0, s, 0, s)
                f.Position = UDim2.new(0, x + math.random(-5, 5), 0, y + math.random(-5, 5))
                f.BorderSizePixel = 0
                f.Rotation = 45
                f.ZIndex = 1
                f.Parent = parent
                table.insert(patternShapes, f)
            end
        end
    elseif patternName == "Dots" then
        for y = 14, totalH, 30 do
            for x = 14, w, 30 do
                local s = math.random(5, 8)
                local f = Instance.new("Frame")
                f.BackgroundColor3 = Color3.fromRGB(60, 60, 68)
                f.BackgroundTransparency = 0.45
                f.Size = UDim2.new(0, s, 0, s)
                f.Position = UDim2.new(0, x + math.random(-3, 3), 0, y + math.random(-3, 3))
                f.BorderSizePixel = 0
                f.ZIndex = 1
                f.Parent = parent
                Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
                table.insert(patternShapes, f)
            end
        end
    end
end

local currentPattern = "Circles"

local function refreshMainPattern()
    fillPattern(patternLayer, currentPattern, mainWidth, mainHeight)
end

refreshMainPattern()

local patternScrollSpeed = 0.15
RunService.RenderStepped:Connect(function(dt)
    if currentPattern == "None" or #patternShapes == 0 then return end
    local totalH = mainHeight * 2
    for _, shape in ipairs(patternShapes) do
        local pos = shape.Position
        local newY = pos.Y.Offset + patternScrollSpeed
        if newY > totalH then
            newY = newY - totalH
        end
        shape.Position = UDim2.new(pos.X.Scale, pos.X.Offset, 0, newY)
    end
end)

local patternNames = {"Circles", "Squares", "Triangles", "Rings", "Diamonds", "Dots", "None"}

createSectionLabel(settingsPage, "Appearance", 1)
createDropdown(settingsPage, "Background Pattern", patternNames, currentPattern, 2, function(name)
    currentPattern = name
    refreshMainPattern()
end)

createSectionLabel(settingsPage, "Keybind", 10)

local keybindHolder = Instance.new("Frame")
keybindHolder.BackgroundTransparency = 1
keybindHolder.Size = UDim2.new(1, 0, 0, 78)
keybindHolder.LayoutOrder = 11
keybindHolder.ZIndex = 6
keybindHolder.Parent = settingsPage

local keybindLbl = Instance.new("TextLabel")
keybindLbl.BackgroundTransparency = 1
keybindLbl.Size = UDim2.new(1, 0, 0, 22)
keybindLbl.Font = Enum.Font.GothamMedium
keybindLbl.Text = "Toggle Key"
keybindLbl.TextColor3 = Color3.fromRGB(200, 210, 220)
keybindLbl.TextSize = 14
keybindLbl.TextXAlignment = Enum.TextXAlignment.Left
keybindLbl.ZIndex = 7
keybindLbl.Parent = keybindHolder

local keybindButton = Instance.new("TextButton")
keybindButton.AutoButtonColor = false
keybindButton.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
keybindButton.Size = UDim2.new(0, 180, 0, 38)
keybindButton.Position = UDim2.new(0, 0, 0, 28)
keybindButton.Text = ""
keybindButton.BorderSizePixel = 0
keybindButton.ZIndex = 8
keybindButton.Parent = keybindHolder
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 10)

local kbStroke = Instance.new("UIStroke")
kbStroke.Color = Color3.fromRGB(80, 190, 255)
kbStroke.Thickness = 1.2
kbStroke.Transparency = 0.3
kbStroke.Parent = keybindButton

local kbLabel = Instance.new("TextLabel")
kbLabel.BackgroundTransparency = 1
kbLabel.Size = UDim2.new(1, 0, 1, 0)
kbLabel.Font = Enum.Font.GothamBold
kbLabel.Text = "RightShift"
kbLabel.TextColor3 = Color3.fromRGB(230, 240, 250)
kbLabel.TextSize = 14
kbLabel.ZIndex = 9
kbLabel.Parent = keybindButton

local toggleKey = Enum.KeyCode.RightShift
local listening = false

keybindButton.MouseEnter:Connect(function()
    if not listening then
        TweenService:Create(keybindButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(58, 58, 68)}):Play()
    end
end)
keybindButton.MouseLeave:Connect(function()
    if not listening then
        TweenService:Create(keybindButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(52, 52, 60)}):Play()
    end
end)
keybindButton.MouseButton1Click:Connect(function()
    if listening then return end
    listening = true
    kbLabel.Text = "..."
    TweenService:Create(keybindButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 75, 90)}):Play()
    TweenService:Create(kbStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(120, 220, 255)}):Play()
end)

createSectionLabel(timerPage, "Alarm Timer", 1)

local timerHolder = Instance.new("Frame")
timerHolder.BackgroundTransparency = 1
timerHolder.Size = UDim2.new(1, 0, 0, 110)
timerHolder.LayoutOrder = 2
timerHolder.ZIndex = 6
timerHolder.Parent = timerPage

local function createTimeInput(parent, label, posX)
    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(0, 60, 0, 55)
    holder.Position = UDim2.new(0, posX, 0, 0)
    holder.ZIndex = 7
    holder.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(200, 210, 220)
    lbl.TextSize = 11
    lbl.ZIndex = 8
    lbl.Parent = holder

    local box = Instance.new("TextBox")
    box.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
    box.Size = UDim2.new(1, 0, 0, 30)
    box.Position = UDim2.new(0, 0, 0, 20)
    box.Font = Enum.Font.GothamBold
    box.Text = "0"
    box.TextColor3 = Color3.fromRGB(230, 240, 250)
    box.TextSize = 15
    box.ClearTextOnFocus = true
    box.BorderSizePixel = 0
    box.ZIndex = 9
    box.Parent = holder
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local bxStroke = Instance.new("UIStroke")
    bxStroke.Color = Color3.fromRGB(80, 190, 255)
    bxStroke.Thickness = 1
    bxStroke.Transparency = 0.3
    bxStroke.Parent = box

    return box
end

local hoursBox = createTimeInput(timerHolder, "Hours", 0)
local minutesBox = createTimeInput(timerHolder, "Minutes", 68)
local secondsBox = createTimeInput(timerHolder, "Seconds", 136)

local timerDisplay = Instance.new("TextLabel")
timerDisplay.BackgroundTransparency = 1
timerDisplay.Size = UDim2.new(0, 120, 0, 30)
timerDisplay.Position = UDim2.new(0, 204, 0, 18)
timerDisplay.Font = Enum.Font.GothamBold
timerDisplay.Text = "00:00:00"
timerDisplay.TextColor3 = Color3.fromRGB(80, 200, 255)
timerDisplay.TextSize = 18
timerDisplay.TextXAlignment = Enum.TextXAlignment.Center
timerDisplay.ZIndex = 8
timerDisplay.Parent = timerHolder

local startTimerBtn = Instance.new("TextButton")
startTimerBtn.AutoButtonColor = false
startTimerBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
startTimerBtn.Size = UDim2.new(0, 90, 0, 30)
startTimerBtn.Position = UDim2.new(0, 0, 0, 60)
startTimerBtn.Text = "Start"
startTimerBtn.Font = Enum.Font.GothamBold
startTimerBtn.TextColor3 = Color3.fromRGB(230, 240, 250)
startTimerBtn.TextSize = 13
startTimerBtn.BorderSizePixel = 0
startTimerBtn.ZIndex = 9
startTimerBtn.Parent = timerHolder
Instance.new("UICorner", startTimerBtn).CornerRadius = UDim.new(0, 8)
local stStroke = Instance.new("UIStroke")
stStroke.Color = Color3.fromRGB(80, 190, 255)
stStroke.Thickness = 1.2
stStroke.Transparency = 0.3
stStroke.Parent = startTimerBtn

local stopTimerBtn = Instance.new("TextButton")
stopTimerBtn.AutoButtonColor = false
stopTimerBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
stopTimerBtn.Size = UDim2.new(0, 90, 0, 30)
stopTimerBtn.Position = UDim2.new(0, 100, 0, 60)
stopTimerBtn.Text = "Stop"
stopTimerBtn.Font = Enum.Font.GothamBold
stopTimerBtn.TextColor3 = Color3.fromRGB(230, 240, 250)
stopTimerBtn.TextSize = 13
stopTimerBtn.BorderSizePixel = 0
stopTimerBtn.ZIndex = 9
stopTimerBtn.Parent = timerHolder
Instance.new("UICorner", stopTimerBtn).CornerRadius = UDim.new(0, 8)
local spStroke = Instance.new("UIStroke")
spStroke.Color = Color3.fromRGB(80, 190, 255)
spStroke.Thickness = 1.2
spStroke.Transparency = 0.3
spStroke.Parent = stopTimerBtn

local timerActive = false

local alarmSound = Instance.new("Sound")
alarmSound.SoundId = "rbxassetid://93045970900035"
alarmSound.Volume = 3
alarmSound.Looped = true
alarmSound.Parent = SoundService

startTimerBtn.MouseButton1Click:Connect(function()
    if timerActive then return end
    local h = tonumber(hoursBox.Text) or 0
    local m = tonumber(minutesBox.Text) or 0
    local s = tonumber(secondsBox.Text) or 0
    local total = h * 3600 + m * 60 + s
    if total <= 0 then return end
    timerActive = true
    startTimerBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
    task.spawn(function()
        while timerActive and total > 0 do
            local dh = math.floor(total / 3600)
            local dm = math.floor((total % 3600) / 60)
            local ds = total % 60
            timerDisplay.Text = string.format("%02d:%02d:%02d", dh, dm, ds)
            task.wait(1)
            total = total - 1
        end
        if timerActive then
            timerDisplay.Text = "00:00:00"
            alarmSound:Play()
            task.delay(10, function()
                alarmSound:Stop()
            end)
        end
        timerActive = false
        startTimerBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
    end)
end)

stopTimerBtn.MouseButton1Click:Connect(function()
    timerActive = false
    timerDisplay.Text = "00:00:00"
    alarmSound:Stop()
    startTimerBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
end)

createSectionLabel(timerPage, "Music Player", 10)

local musicHolder = Instance.new("Frame")
musicHolder.BackgroundTransparency = 1
musicHolder.Size = UDim2.new(1, 0, 0, 130)
musicHolder.LayoutOrder = 11
musicHolder.ZIndex = 6
musicHolder.Parent = timerPage

local musicIdLabel = Instance.new("TextLabel")
musicIdLabel.BackgroundTransparency = 1
musicIdLabel.Size = UDim2.new(1, 0, 0, 16)
musicIdLabel.Font = Enum.Font.GothamMedium
musicIdLabel.Text = "Sound ID"
musicIdLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
musicIdLabel.TextSize = 11
musicIdLabel.TextXAlignment = Enum.TextXAlignment.Left
musicIdLabel.ZIndex = 7
musicIdLabel.Parent = musicHolder

local musicIdBox = Instance.new("TextBox")
musicIdBox.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
musicIdBox.Size = UDim2.new(1, -100, 0, 30)
musicIdBox.Position = UDim2.new(0, 0, 0, 20)
musicIdBox.Font = Enum.Font.GothamMedium
musicIdBox.PlaceholderText = "rbxassetid://..."
musicIdBox.Text = ""
musicIdBox.TextColor3 = Color3.fromRGB(230, 240, 250)
musicIdBox.TextSize = 13
musicIdBox.ClearTextOnFocus = false
musicIdBox.BorderSizePixel = 0
musicIdBox.ZIndex = 8
musicIdBox.Parent = musicHolder
Instance.new("UICorner", musicIdBox).CornerRadius = UDim.new(0, 8)
local midStroke = Instance.new("UIStroke")
midStroke.Color = Color3.fromRGB(80, 190, 255)
midStroke.Thickness = 1
midStroke.Transparency = 0.3
midStroke.Parent = musicIdBox

local musicLoopBtn = Instance.new("TextButton")
musicLoopBtn.AutoButtonColor = false
musicLoopBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
musicLoopBtn.Size = UDim2.new(0, 88, 0, 30)
musicLoopBtn.Position = UDim2.new(1, -88, 0, 20)
musicLoopBtn.Text = "Loop: OFF"
musicLoopBtn.Font = Enum.Font.GothamBold
musicLoopBtn.TextColor3 = Color3.fromRGB(200, 210, 220)
musicLoopBtn.TextSize = 11
musicLoopBtn.BorderSizePixel = 0
musicLoopBtn.ZIndex = 8
musicLoopBtn.Parent = musicHolder
Instance.new("UICorner", musicLoopBtn).CornerRadius = UDim.new(0, 8)
local mlStroke = Instance.new("UIStroke")
mlStroke.Color = Color3.fromRGB(80, 190, 255)
mlStroke.Thickness = 1
mlStroke.Transparency = 0.3
mlStroke.Parent = musicLoopBtn

local musicLooped = false
musicLoopBtn.MouseButton1Click:Connect(function()
    musicLooped = not musicLooped
    musicLoopBtn.Text = musicLooped and "Loop: ON" or "Loop: OFF"
    musicLoopBtn.BackgroundColor3 = musicLooped and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(52, 52, 60)
end)

local volLabel = Instance.new("TextLabel")
volLabel.BackgroundTransparency = 1
volLabel.Size = UDim2.new(1, 0, 0, 16)
volLabel.Position = UDim2.new(0, 0, 0, 56)
volLabel.Font = Enum.Font.GothamMedium
volLabel.Text = "Volume"
volLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
volLabel.TextSize = 11
volLabel.TextXAlignment = Enum.TextXAlignment.Left
volLabel.ZIndex = 7
volLabel.Parent = musicHolder

local volBar = Instance.new("Frame")
volBar.Size = UDim2.new(1, 0, 0, 8)
volBar.Position = UDim2.new(0, 0, 0, 76)
volBar.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
volBar.BorderSizePixel = 0
volBar.ZIndex = 8
volBar.Parent = musicHolder
Instance.new("UICorner", volBar).CornerRadius = UDim.new(0, 4)

local volFill = Instance.new("Frame")
volFill.Size = UDim2.new(0.5, 0, 1, 0)
volFill.BackgroundColor3 = Color3.fromRGB(80, 190, 255)
volFill.BorderSizePixel = 0
volFill.ZIndex = 9
volFill.Parent = volBar
Instance.new("UICorner", volFill).CornerRadius = UDim.new(0, 4)

local volValue = Instance.new("TextLabel")
volValue.BackgroundTransparency = 1
volValue.Size = UDim2.new(0, 40, 0, 16)
volValue.Position = UDim2.new(1, -40, 0, 56)
volValue.Font = Enum.Font.GothamBold
volValue.Text = "50%"
volValue.TextColor3 = Color3.fromRGB(80, 200, 255)
volValue.TextSize = 11
volValue.TextXAlignment = Enum.TextXAlignment.Right
volValue.ZIndex = 8
volValue.Parent = musicHolder

local musicVolume = 0.5
local volDragging = false

volBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        volDragging = true
        local rel = math.clamp((input.Position.X - volBar.AbsolutePosition.X) / volBar.AbsoluteSize.X, 0, 1)
        musicVolume = rel
        volFill.Size = UDim2.new(rel, 0, 1, 0)
        volValue.Text = math.floor(rel * 100) .. "%"
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then volDragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if volDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local rel = math.clamp((input.Position.X - volBar.AbsolutePosition.X) / volBar.AbsoluteSize.X, 0, 1)
        musicVolume = rel
        volFill.Size = UDim2.new(rel, 0, 1, 0)
        volValue.Text = math.floor(rel * 100) .. "%"
    end
end)

local musicSound = Instance.new("Sound")
musicSound.Name = "FreedomMusic"
musicSound.Parent = SoundService

local musicPlayBtn = Instance.new("TextButton")
musicPlayBtn.AutoButtonColor = false
musicPlayBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
musicPlayBtn.Size = UDim2.new(0, 90, 0, 30)
musicPlayBtn.Position = UDim2.new(0, 0, 0, 92)
musicPlayBtn.Text = "Play"
musicPlayBtn.Font = Enum.Font.GothamBold
musicPlayBtn.TextColor3 = Color3.fromRGB(230, 240, 250)
musicPlayBtn.TextSize = 13
musicPlayBtn.BorderSizePixel = 0
musicPlayBtn.ZIndex = 9
musicPlayBtn.Parent = musicHolder
Instance.new("UICorner", musicPlayBtn).CornerRadius = UDim.new(0, 8)
local mpStroke = Instance.new("UIStroke")
mpStroke.Color = Color3.fromRGB(80, 190, 255)
mpStroke.Thickness = 1.2
mpStroke.Transparency = 0.3
mpStroke.Parent = musicPlayBtn

local musicStopBtn = Instance.new("TextButton")
musicStopBtn.AutoButtonColor = false
musicStopBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
musicStopBtn.Size = UDim2.new(0, 90, 0, 30)
musicStopBtn.Position = UDim2.new(0, 100, 0, 92)
musicStopBtn.Text = "Stop"
musicStopBtn.Font = Enum.Font.GothamBold
musicStopBtn.TextColor3 = Color3.fromRGB(230, 240, 250)
musicStopBtn.TextSize = 13
musicStopBtn.BorderSizePixel = 0
musicStopBtn.ZIndex = 9
musicStopBtn.Parent = musicHolder
Instance.new("UICorner", musicStopBtn).CornerRadius = UDim.new(0, 8)
local msStroke = Instance.new("UIStroke")
msStroke.Color = Color3.fromRGB(80, 190, 255)
msStroke.Thickness = 1.2
msStroke.Transparency = 0.3
msStroke.Parent = musicStopBtn

musicPlayBtn.MouseButton1Click:Connect(function()
    local id = musicIdBox.Text
    if id == "" then return end
    if not id:find("rbxassetid://") then
        id = "rbxassetid://" .. id
    end
    musicSound:Stop()
    musicSound.SoundId = id
    musicSound.Volume = musicVolume
    musicSound.Looped = musicLooped
    musicSound:Play()
    musicPlayBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
end)

musicStopBtn.MouseButton1Click:Connect(function()
    musicSound:Stop()
    musicPlayBtn.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
end)

RunService.Heartbeat:Connect(function()
    if musicSound.IsPlaying then
        musicSound.Volume = musicVolume
        musicSound.Looped = musicLooped
    end
end)

createSectionLabel(blackholePage, "Blackhole Customizer", 1)

local bhHolder = Instance.new("Frame")
bhHolder.BackgroundTransparency = 1
bhHolder.Size = UDim2.new(1, 0, 0, 220)
bhHolder.LayoutOrder = 2
bhHolder.ZIndex = 6
bhHolder.Parent = blackholePage

local bhColorLabel = Instance.new("TextLabel")
bhColorLabel.BackgroundTransparency = 1
bhColorLabel.Size = UDim2.new(1, 0, 0, 16)
bhColorLabel.Font = Enum.Font.GothamMedium
bhColorLabel.Text = "Sphere Color (R, G, B)"
bhColorLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
bhColorLabel.TextSize = 11
bhColorLabel.TextXAlignment = Enum.TextXAlignment.Left
bhColorLabel.ZIndex = 7
bhColorLabel.Parent = bhHolder

local bhColorR, bhColorG, bhColorB = 255, 0, 0

local function createColorInput(parent, posX, default)
    local box = Instance.new("TextBox")
    box.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
    box.Size = UDim2.new(0, 55, 0, 28)
    box.Position = UDim2.new(0, posX, 0, 20)
    box.Font = Enum.Font.GothamBold
    box.Text = tostring(default)
    box.TextColor3 = Color3.fromRGB(230, 240, 250)
    box.TextSize = 13
    box.ClearTextOnFocus = true
    box.BorderSizePixel = 0
    box.ZIndex = 9
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(80, 190, 255)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.3
    bStroke.Parent = box
    return box
end

local rBox = createColorInput(bhHolder, 0, 255)
local gBox = createColorInput(bhHolder, 65, 0)
local bBox = createColorInput(bhHolder, 130, 0)

local bhColorPreview = Instance.new("Frame")
bhColorPreview.Size = UDim2.new(0, 28, 0, 28)
bhColorPreview.Position = UDim2.new(0, 200, 0, 20)
bhColorPreview.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bhColorPreview.BorderSizePixel = 0
bhColorPreview.ZIndex = 9
bhColorPreview.Parent = bhHolder
Instance.new("UICorner", bhColorPreview).CornerRadius = UDim.new(0, 6)
local cpStroke = Instance.new("UIStroke")
cpStroke.Color = Color3.fromRGB(80, 190, 255)
cpStroke.Thickness = 1
cpStroke.Transparency = 0.3
cpStroke.Parent = bhColorPreview

local function updateColorPreview()
    bhColorR = math.clamp(tonumber(rBox.Text) or 0, 0, 255)
    bhColorG = math.clamp(tonumber(gBox.Text) or 0, 0, 255)
    bhColorB = math.clamp(tonumber(bBox.Text) or 0, 0, 255)
    bhColorPreview.BackgroundColor3 = Color3.fromRGB(bhColorR, bhColorG, bhColorB)
end

rBox.FocusLost:Connect(updateColorPreview)
gBox.FocusLost:Connect(updateColorPreview)
bBox.FocusLost:Connect(updateColorPreview)

local bhTransLabel = Instance.new("TextLabel")
bhTransLabel.BackgroundTransparency = 1
bhTransLabel.Size = UDim2.new(1, 0, 0, 16)
bhTransLabel.Position = UDim2.new(0, 0, 0, 58)
bhTransLabel.Font = Enum.Font.GothamMedium
bhTransLabel.Text = "Sphere Transparency"
bhTransLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
bhTransLabel.TextSize = 11
bhTransLabel.TextXAlignment = Enum.TextXAlignment.Left
bhTransLabel.ZIndex = 7
bhTransLabel.Parent = bhHolder

local bhTransValue = Instance.new("TextLabel")
bhTransValue.BackgroundTransparency = 1
bhTransValue.Size = UDim2.new(0, 40, 0, 16)
bhTransValue.Position = UDim2.new(1, -40, 0, 58)
bhTransValue.Font = Enum.Font.GothamBold
bhTransValue.Text = "30%"
bhTransValue.TextColor3 = Color3.fromRGB(80, 200, 255)
bhTransValue.TextSize = 11
bhTransValue.TextXAlignment = Enum.TextXAlignment.Right
bhTransValue.ZIndex = 8
bhTransValue.Parent = bhHolder

local bhTransBar = Instance.new("Frame")
bhTransBar.Size = UDim2.new(1, 0, 0, 8)
bhTransBar.Position = UDim2.new(0, 0, 0, 78)
bhTransBar.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
bhTransBar.BorderSizePixel = 0
bhTransBar.ZIndex = 8
bhTransBar.Parent = bhHolder
Instance.new("UICorner", bhTransBar).CornerRadius = UDim.new(0, 4)

local bhTransFill = Instance.new("Frame")
bhTransFill.Size = UDim2.new(0.3, 0, 1, 0)
bhTransFill.BackgroundColor3 = Color3.fromRGB(80, 190, 255)
bhTransFill.BorderSizePixel = 0
bhTransFill.ZIndex = 9
bhTransFill.Parent = bhTransBar
Instance.new("UICorner", bhTransFill).CornerRadius = UDim.new(0, 4)

local bhTransparency = 0.3
local bhTransDragging = false

bhTransBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bhTransDragging = true
        local rel = math.clamp((input.Position.X - bhTransBar.AbsolutePosition.X) / bhTransBar.AbsoluteSize.X, 0, 1)
        bhTransparency = rel
        bhTransFill.Size = UDim2.new(rel, 0, 1, 0)
        bhTransValue.Text = math.floor(rel * 100) .. "%"
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then bhTransDragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if bhTransDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local rel = math.clamp((input.Position.X - bhTransBar.AbsolutePosition.X) / bhTransBar.AbsoluteSize.X, 0, 1)
        bhTransparency = rel
        bhTransFill.Size = UDim2.new(rel, 0, 1, 0)
        bhTransValue.Text = math.floor(rel * 100) .. "%"
    end
end)

local bhSoundLabel = Instance.new("TextLabel")
bhSoundLabel.BackgroundTransparency = 1
bhSoundLabel.Size = UDim2.new(1, 0, 0, 16)
bhSoundLabel.Position = UDim2.new(0, 0, 0, 96)
bhSoundLabel.Font = Enum.Font.GothamMedium
bhSoundLabel.Text = "Custom Sound ID"
bhSoundLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
bhSoundLabel.TextSize = 11
bhSoundLabel.TextXAlignment = Enum.TextXAlignment.Left
bhSoundLabel.ZIndex = 7
bhSoundLabel.Parent = bhHolder

local bhSoundBox = Instance.new("TextBox")
bhSoundBox.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
bhSoundBox.Size = UDim2.new(1, 0, 0, 28)
bhSoundBox.Position = UDim2.new(0, 0, 0, 116)
bhSoundBox.Font = Enum.Font.GothamMedium
bhSoundBox.PlaceholderText = "rbxassetid://..."
bhSoundBox.Text = ""
bhSoundBox.TextColor3 = Color3.fromRGB(230, 240, 250)
bhSoundBox.TextSize = 12
bhSoundBox.ClearTextOnFocus = false
bhSoundBox.BorderSizePixel = 0
bhSoundBox.ZIndex = 8
bhSoundBox.Parent = bhHolder
Instance.new("UICorner", bhSoundBox).CornerRadius = UDim.new(0, 8)
local bsStroke = Instance.new("UIStroke")
bsStroke.Color = Color3.fromRGB(80, 190, 255)
bsStroke.Thickness = 1
bsStroke.Transparency = 0.3
bsStroke.Parent = bhSoundBox

local bhEnabled = false
local bhToggle = Instance.new("TextButton")
bhToggle.AutoButtonColor = false
bhToggle.BackgroundColor3 = Color3.fromRGB(52, 52, 60)
bhToggle.Size = UDim2.new(1, 0, 0, 34)
bhToggle.Position = UDim2.new(0, 0, 0, 158)
bhToggle.Text = "Customizer: OFF"
bhToggle.Font = Enum.Font.GothamBold
bhToggle.TextColor3 = Color3.fromRGB(230, 240, 250)
bhToggle.TextSize = 13
bhToggle.BorderSizePixel = 0
bhToggle.ZIndex = 9
bhToggle.Parent = bhHolder
Instance.new("UICorner", bhToggle).CornerRadius = UDim.new(0, 8)
local btStroke = Instance.new("UIStroke")
btStroke.Color = Color3.fromRGB(80, 190, 255)
btStroke.Thickness = 1.2
btStroke.Transparency = 0.3
btStroke.Parent = bhToggle

local bhSpheres = {}

local function replaceBH(obj)
    if not obj or not obj.Parent or obj.Name ~= "BlackHoleKick" then return end

    updateColorPreview()

    local pos = nil

    if obj:IsA("BasePart") then
        pos = obj.Position
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then
            pos = obj.PrimaryPart.Position
        else
            for _, v in pairs(obj:GetDescendants()) do
                if v:IsA("BasePart") then
                    pos = v.Position
                    break
                end
            end
        end
    end

    obj:Destroy()

    if not pos then return end

    local sphere = Instance.new("Part")
    sphere.Name = "FreedomSphere"
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(0.5, 0.5, 0.5)
    sphere.Position = pos
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.CanTouch = false
    sphere.CanQuery = false
    sphere.Material = Enum.Material.Neon
    sphere.CastShadow = false
    sphere.Color = Color3.fromRGB(bhColorR, bhColorG, bhColorB)
    sphere.Transparency = 1
    sphere.Parent = workspace
    table.insert(bhSpheres, sphere)

    local innerGlow = Instance.new("Part")
    innerGlow.Name = "InnerGlow"
    innerGlow.Shape = Enum.PartType.Ball
    innerGlow.Size = Vector3.new(0.3, 0.3, 0.3)
    innerGlow.Position = pos
    innerGlow.Anchored = true
    innerGlow.CanCollide = false
    innerGlow.CanTouch = false
    innerGlow.CanQuery = false
    innerGlow.Material = Enum.Material.ForceField
    innerGlow.CastShadow = false
    innerGlow.Color = Color3.fromRGB(255, 255, 255)
    innerGlow.Transparency = 1
    innerGlow.Parent = workspace
    table.insert(bhSpheres, innerGlow)

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(bhColorR, bhColorG, bhColorB)
    highlight.FillTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(bhColorR, bhColorG, bhColorB)
    highlight.OutlineTransparency = 0
    highlight.Parent = sphere

    local particles = Instance.new("ParticleEmitter")
    particles.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(bhColorR, bhColorG, bhColorB)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(bhColorR, bhColorG, bhColorB))
    })
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 1.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    particles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Lifetime = NumberRange.new(0.5, 1.5)
    particles.Rate = 60
    particles.Speed = NumberRange.new(3, 8)
    particles.SpreadAngle = Vector2.new(360, 360)
    particles.RotSpeed = NumberRange.new(-180, 180)
    particles.LightEmission = 1
    particles.LightInfluence = 0
    particles.Parent = sphere

    local rings = Instance.new("ParticleEmitter")
    rings.Color = ColorSequence.new(Color3.fromRGB(bhColorR, bhColorG, bhColorB))
    rings.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 3),
        NumberSequenceKeypoint.new(1, 0)
    })
    rings.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    rings.Lifetime = NumberRange.new(0.8, 1.2)
    rings.Rate = 15
    rings.Speed = NumberRange.new(0, 1)
    rings.SpreadAngle = Vector2.new(360, 360)
    rings.LightEmission = 1
    rings.LightInfluence = 0
    rings.Parent = sphere

    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(bhColorR, bhColorG, bhColorB)
    pointLight.Brightness = 0
    pointLight.Range = 40
    pointLight.Parent = sphere

    local soundId = bhSoundBox.Text
    if soundId ~= "" then
        local snd = Instance.new("Sound")
        snd.SoundId = soundId:find("rbxassetid://") and soundId or "rbxassetid://" .. soundId
        snd.Volume = 1
        snd.Parent = sphere
        snd:Play()
    end

    TweenService:Create(sphere, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = Vector3.new(25, 25, 25),
        Transparency = bhTransparency
    }):Play()

    TweenService:Create(innerGlow, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = Vector3.new(15, 15, 15),
        Transparency = bhTransparency + 0.3
    }):Play()

    TweenService:Create(pointLight, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Brightness = 3
    }):Play()

    task.spawn(function()
        local t = 0
        while bhEnabled and sphere and sphere.Parent do
            updateColorPreview()
            t = t + RunService.Heartbeat:Wait()

            local pulse = math.sin(t * 3) * 0.08
            local baseSize = 25
            local glowSize = 15

            sphere.Color = Color3.fromRGB(bhColorR, bhColorG, bhColorB)
            sphere.Transparency = bhTransparency + pulse
            sphere.Size = Vector3.new(baseSize + pulse * 30, baseSize + pulse * 30, baseSize + pulse * 30)

            innerGlow.Position = sphere.Position
            innerGlow.Color = Color3.fromRGB(
                math.clamp(bhColorR + 50, 0, 255),
                math.clamp(bhColorG + 50, 0, 255),
                math.clamp(bhColorB + 50, 0, 255)
            )
            innerGlow.Transparency = bhTransparency + 0.3 + pulse
            innerGlow.Size = Vector3.new(glowSize + pulse * 20, glowSize + pulse * 20, glowSize + pulse * 20)

            highlight.FillColor = Color3.fromRGB(bhColorR, bhColorG, bhColorB)
            highlight.OutlineColor = Color3.fromRGB(
                math.clamp(bhColorR + 30, 0, 255),
                math.clamp(bhColorG + 30, 0, 255),
                math.clamp(bhColorB + 30, 0, 255)
            )
            highlight.FillTransparency = 0.3 + pulse

            pointLight.Color = Color3.fromRGB(bhColorR, bhColorG, bhColorB)
            pointLight.Brightness = 3 + math.sin(t * 5) * 1.5

            particles.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(bhColorR, bhColorG, bhColorB)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(bhColorR, bhColorG, bhColorB))
            })

            rings.Color = ColorSequence.new(Color3.fromRGB(bhColorR, bhColorG, bhColorB))

            sphere.CFrame = sphere.CFrame * CFrame.Angles(0, math.rad(1.5), math.rad(0.5))
        end
    end)

    task.delay(4, function()
        if sphere and sphere.Parent then
            particles.Enabled = false
            rings.Enabled = false

            TweenService:Create(sphere, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = Vector3.new(0.5, 0.5, 0.5),
                Transparency = 1
            }):Play()

            TweenService:Create(innerGlow, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = Vector3.new(0.3, 0.3, 0.3),
                Transparency = 1
            }):Play()

            TweenService:Create(pointLight, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Brightness = 0
            }):Play()

            task.delay(1.6, function()
                if sphere and sphere.Parent then sphere:Destroy() end
                if innerGlow and innerGlow.Parent then innerGlow:Destroy() end
            end)
        end
    end)
end

bhToggle.MouseButton1Click:Connect(function()
    bhEnabled = not bhEnabled
    bhToggle.Text = bhEnabled and "Customizer: ON" or "Customizer: OFF"
    bhToggle.BackgroundColor3 = bhEnabled and Color3.fromRGB(60, 80, 60) or Color3.fromRGB(52, 52, 60)
    if bhEnabled then
        for _, o in pairs(workspace:GetChildren()) do
            if o.Name == "BlackHoleKick" then
                replaceBH(o)
            end
        end
    else
        for _, s in pairs(bhSpheres) do
            if s and s.Parent then s:Destroy() end
        end
        bhSpheres = {}
    end
end)

workspace.ChildAdded:Connect(function(child)
    if bhEnabled and child.Name == "BlackHoleKick" then
        task.wait()
        replaceBH(child)
    end
end)

workspace.DescendantAdded:Connect(function(desc)
    if bhEnabled and desc.Name == "BlackHoleKick" then
        task.wait()
        replaceBH(desc)
    end
end)

local guiVisible = true
local tweening = false
local savedPosition = main.Position

local function unlockMouse()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = false
    modalButton.Modal = true
    customCursor.Visible = true
end

local function lockMouse()
    modalButton.Modal = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
    customCursor.Visible = false
end

local function hideGui()
    if tweening then return end
    tweening = true
    guiVisible = false
    savedPosition = main.Position
    lockMouse()
    local bounce = TweenService:Create(main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(savedPosition.X.Scale, savedPosition.X.Offset, savedPosition.Y.Scale, savedPosition.Y.Offset + 15)
    })
    bounce.Completed:Connect(function()
        local fly = TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(savedPosition.X.Scale, savedPosition.X.Offset, 0, -mainHeight - 80)
        })
        fly.Completed:Connect(function()
            main.Visible = false
            tweening = false
        end)
        fly:Play()
    end)
    bounce:Play()
end

local function showGui()
    if tweening then return end
    tweening = true
    guiVisible = true
    main.Visible = true
    unlockMouse()
    local target = savedPosition or UDim2.new(0.5, -mainWidth / 2, 0.5, -mainHeight / 2)
    main.Position = UDim2.new(target.X.Scale, target.X.Offset, 0, -mainHeight - 80)
    local fly = TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(target.X.Scale, target.X.Offset, target.Y.Scale, target.Y.Offset + 12)
    })
    fly.Completed:Connect(function()
        local settle = TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = target
        })
        settle.Completed:Connect(function() tweening = false end)
        settle:Play()
    end)
    fly:Play()
end

RunService.RenderStepped:Connect(function()
    if guiVisible then
        local mousePos = UserInputService:GetMouseLocation()
        customCursor.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
        toggleKey = input.KeyCode
        kbLabel.Text = input.KeyCode.Name
        listening = false
        TweenService:Create(keybindButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(52, 52, 60)}):Play()
        TweenService:Create(kbStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 190, 255)}):Play()
        return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == toggleKey then
        if guiVisible then hideGui() else showGui() end
    end
end)

local dragging = false
local dragStart = nil
local startPos = nil
local dragTarget = nil

local function setupDrag(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            dragTarget = main
        end
    end)
end

setupDrag(topBar)
setupDrag(leftPanel)
setupDrag(main)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        dragTarget = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragTarget and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(dragTarget, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
        savedPosition = newPos
    end
end)

switchTab("Settings")
unlockMouse()