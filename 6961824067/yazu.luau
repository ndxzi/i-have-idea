--[[
    WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
    Blobman - Fling Things and People UI: Rayfield Library Update: 
    チャット間隔の最小値を0.1秒に変更 & レインボーエフェクトの最適化
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

-- 設定値
local config = {
    enabled = false,
    tpEnabled = false,
    shieldBreaker = false,
    infJump = false,
    autoChat = false,
    chatMessage = "こんにちは！",
    chatInterval = 0.5, -- 初期値を0.5秒に変更
    interval = 0.1,
    range = 100,
    keyToTap = Enum.KeyCode.F,
    lookAtTarget = true,
    holdTime = 0.05
}

-- チャット送信関数
local function SendChatMessage(message)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService.TextChannels.RBXGeneral
        if channel then
            channel:SendAsync(message)
        end
    else
        local remote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") 
        if remote then
            local sayMessageRequest = remote:FindFirstChild("SayMessageRequest")
            if sayMessageRequest then
                sayMessageRequest:FireServer(message, "All")
            end
        end
    end
end

-- 起動時に一度発言
task.spawn(function()
    task.wait(1)
    SendChatMessage("[yuzu hub起動完了]")
end)

-- 無限チャットループ
task.spawn(function()
    while true do
        if config.autoChat then
            SendChatMessage(config.chatMessage)
        end
        task.wait(config.chatInterval)
    end
end)

-- ウィンドウ作成
local Window = Rayfield:CreateWindow({
    Name = "yazu hub ❤(/ω＼)ｲﾔﾝ機能少ないです❤",
    LoadingTitle = "yazu hub ❤(/ω＼)ｲﾔﾝ Loading...",
    LoadingSubtitle = "yazu hub ❤",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
    Theme = "Default"
})

-- 強制レインボーRGBループ
task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        hue = hue + 0.01
        if hue > 1 then hue = 0 end
        
        local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
        
        if Rayfield.Settings then
            Rayfield.Settings.Theme.AccentColor = rainbowColor
        end
        
        local gui = game:GetService("CoreGui"):FindFirstChild("Rayfield") or localPlayer:FindFirstChild("PlayerGui"):FindFirstChild("Rayfield")
        if gui then
            local main = gui:FindFirstChild("Main")
            if main then
                local topbar = main:FindFirstChild("Topbar")
                if topbar then
                    topbar.BackgroundColor3 = rainbowColor
                end
                -- 追加のビジュアル調整が必要な場合はここに記述
            end
        end
    end
end)

-- タブ作成
local MainTab = Window:CreateTab("メイン設定", 4483362458)
local PlayerTab = Window:CreateTab("プレイヤー設定", 4483362458)
local MiscTab = Window:CreateTab("その他", 4483362458)

-- --- メインタブ ---
MainTab:CreateSection("自動掴み設定")

MainTab:CreateToggle({
    Name = "自動掴みを起動",
    CurrentValue = false,
    Flag = "AutoGrabToggle",
    Callback = function(Value)
        config.enabled = Value
        if Value then
            Rayfield:Notify({
                Title = "起動",
                Content = "自動掴みモードがオンになりました。",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

MainTab:CreateToggle({
    Name = "Shield Breaker (高速連打+物理振動)",
    CurrentValue = false,
    Flag = "ShieldBreakerToggle",
    Callback = function(Value)
        config.shieldBreaker = Value
        if Value then
            config.interval = 0.03
            config.holdTime = 0.01
        else
            config.interval = 0.1
            config.holdTime = 0.05
        end
    end,
})

MainTab:CreateToggle({
    Name = "テレポート掴み (遠くの人を捕まえに行く)",
    CurrentValue = false,
    Flag = "TPGrabToggle",
    Callback = function(Value)
        config.tpEnabled = Value
    end,
})

MainTab:CreateSlider({
    Name = "ターゲット検索範囲 (Studs)",
    Range = {5, 500},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 100,
    Flag = "RangeSlider",
    Callback = function(Value)
        config.range = Value
    end,
})

-- --- プレイヤータブ ---
PlayerTab:CreateSection("移動・アクション")

PlayerTab:CreateToggle({
    Name = "無限ジャンプ",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value)
        config.infJump = Value
    end,
})

-- --- その他タブ ---
MiscTab:CreateSection("自動チャット設定")

MiscTab:CreateToggle({
    Name = "自動で「こんにちは！」と言う",
    CurrentValue = false,
    Flag = "AutoChatToggle",
    Callback = function(Value)
        config.autoChat = Value
    end,
})

-- スライダーの範囲を 0.1 ～ 10 に変更
MiscTab:CreateSlider({
    Name = "チャットの間隔 (秒)",
    Range = {0.1, 10},
    Increment = 0.1,
    Suffix = "秒",
    CurrentValue = 0.5,
    Flag = "ChatIntervalSlider",
    Callback = function(Value)
        config.chatInterval = Value
    end,
})

-- 無限ジャンプ用イベント
UserInputService.JumpRequest:Connect(function()
    if config.infJump then
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 掴み実行関数
local function performGrab(target)
    if not target then return end
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if config.tpEnabled then
        root.CFrame = target.CFrame * CFrame.new(0, 0, 2)
        task.wait(0.01)
    end

    if config.lookAtTarget then
        local targetPos = Vector3.new(target.Position.X, root.Position.Y, target.Position.Z)
        root.CFrame = CFrame.lookAt(root.Position, targetPos)
    end

    if config.shieldBreaker then
        root.CFrame = root.CFrame * CFrame.new(math.random(-1, 1) / 10, 0, math.random(-1, 1) / 10)
    end

    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInputManager:SendKeyEvent(true, config.keyToTap, false, game)
    task.wait(config.holdTime)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    VirtualInputManager:SendKeyEvent(false, config.keyToTap, false, game)
end

-- メインループ
task.spawn(function()
    while true do
        if config.enabled then
            local char = localPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local targetPart = nil
                local closestDist = config.range
                
                for _, other in pairs(Players:GetPlayers()) do
                    if other ~= localPlayer and other.Character then
                        local oRoot = other.Character:FindFirstChild("HumanoidRootPart")
                        local oHum = other.Character:FindFirstChild("Humanoid")
                        if oRoot and oHum and oHum.Health > 0 then
                            local d = (root.Position - oRoot.Position).Magnitude
                            if d <= closestDist then
                                targetPart = oRoot
                                closestDist = d
                            end
                        end
                    end
                end
                
                if targetPart then
                    performGrab(targetPart)
                end
            end
        end
        task.wait(config.interval)
    end
end)

Rayfield:Notify({
    Title = "yazu hub",
    Content = "チャット速度を調整可能にしました❤",
    Duration = 5,
    Image = 4483362458,
})
