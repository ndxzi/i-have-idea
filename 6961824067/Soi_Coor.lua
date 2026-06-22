-- サービス宣言
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- 二重起動防止
local oldGui = LP:WaitForChild("PlayerGui"):FindFirstChild("Soi_CoordGui")
if oldGui then oldGui:Destroy() end

-- --- UI作成 ---
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Soi_CoordGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LP:WaitForChild("PlayerGui")

-- メインフレーム（縦幅を 85 → 70 に短縮）
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 140, 0, 70) 
frame.Position = UDim2.new(0, 15, 0, 15)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.5

frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = screenGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = frame

-- テキストラベル（行間を詰めるために LineHeight を調整）
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 1, 0)
label.Position = UDim2.new(0, 8, 0, -2) -- さらに上に配置
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Font = Enum.Font.Arcade
label.TextSize = 14
label.LineHeight = 0.8 -- 行間をギュッと詰める
label.Parent = frame

-- ボタン共通設定
local function styleButton(btn, pos, text, color)
    btn.Size = UDim2.new(0, 20, 0, 20)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text
    btn.Font = Enum.Font.Arcade
    btn.TextColor3 = color
    btn.TextSize = 12

    btn.Parent = frame
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = btn
end

local copyBtn = Instance.new("TextButton")
styleButton(copyBtn, UDim2.new(1, -50, 0, 5), "C", Color3.fromRGB(255, 255, 0))
local toggleBtn = Instance.new("TextButton")
styleButton(toggleBtn, UDim2.new(1, -25, 0, 5), "-", Color3.fromRGB(0, 255, 255))

-- --- ロジック ---
local isMinimized = false
local lastPosString = ""
local displayFps = 0
local lastFpsUpdate = 0
toggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        frame.Size = UDim2.new(0, 85, 0, 30) -- 最小化時もさらに薄く
        toggleBtn.Text = "+"
        copyBtn.Visible = false
        label.Position = UDim2.new(0, 8, 0, 2)
    else
        frame.Size = UDim2.new(0, 140, 0, 70) -- 元のサイズをコンパクトに
        toggleBtn.Text = "-"
        copyBtn.Visible = true
        label.Position = UDim2.new(0, 8, 0, -2)
    end
end)
copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(lastPosString)
        copyBtn.Text = "V"
        task.wait(0.5)
        copyBtn.Text = "C"
    end
end)

-- --- ドラッグ機能（省略なし） ---
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)
RunService.RenderStepped:Connect(function(deltaTime)
    lastFpsUpdate = lastFpsUpdate + deltaTime
    if lastFpsUpdate >= 0.5 then
        displayFps = math.floor(1 / deltaTime)
        lastFpsUpdate = 0
    end
    local character = LP.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            lastPosString = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            if isMinimized then
                label.Text = string.format("FPS: %d", displayFps)
            else
                -- 文字の間隔を詰めるために改行を調整
                label.Text = string.format("FPS: %d\n[POS]\nX:%.1f\nY:%.1f\nZ:%.1f", displayFps, pos.X, pos.Y, pos.Z)
            end
        end
    end
end)
