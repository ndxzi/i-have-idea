-- ========== МГНОВЕННЫЙ AIM ДЛЯ FTAP ==========
-- ВСТАВЬ ЭТОТ КОД В СВОЙ ЭКЗЕКЬЮТОР

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ========== НАСТРОЙКИ ==========
_G.AimEnabled = true
_G.AimKey = Enum.KeyCode.Q
_G.AimPart = "Head" -- Head, HumanoidRootPart, Torso
_G.AimFOV = 500

-- ========== ПОИСК БЛИЖАЙШЕГО ИГРОКА ==========
local function GetClosest()
    local closest = nil
    local closestDist = _G.AimFOV
    local myChar = LocalPlayer.Character
    if not myChar then return nil end
    
    local viewportSize = Camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if not char then continue end
            
            local targetPart = char:FindFirstChild(_G.AimPart) or char:FindFirstChild("HumanoidRootPart")
            if not targetPart then continue end
            
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health <= 0 then continue end
            
            -- Проверка на экране
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
            if not onScreen then continue end
            
            -- Расстояние от центра экрана
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            
            if dist < closestDist then
                closestDist = dist
                closest = player
            end
        end
    end
    
    return closest
end

-- ========== МГНОВЕННАЯ НАВОДКА (БЕЗ ПЛАВНОСТИ) ==========
local function InstantAim(target)
    if not target or not target.Character then return end
    
    local targetPart = target.Character:FindFirstChild(_G.AimPart) or target.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end
    
    -- Получаем позицию цели
    local targetPos = targetPart.Position
    if _G.AimPart == "Head" then
        targetPos = targetPos + Vector3.new(0, 0.3, 0)
    end
    
    -- МГНОВЕННАЯ НАВОДКА (без Lerp)
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
end

-- ========== ОТСЛЕЖИВАНИЕ КЛАВИШ ==========
_G.IsHolding = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == _G.AimKey then
        _G.IsHolding = true
        print("🔴 AIM ВКЛЮЧЁН (МГНОВЕННЫЙ)")
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == _G.AimKey then
        _G.IsHolding = false
        print("🔴 AIM ВЫКЛЮЧЁН")
    end
end)

-- ========== ГЛАВНЫЙ ЦИКЛ ==========
RunService.RenderStepped:Connect(function()
    if _G.IsHolding then
        local target = GetClosest()
        if target then
            InstantAim(target)
        end
    end
end)

print("====================================")
print("🎯 МГНОВЕННЫЙ AIM ДЛЯ FTAP")
print("📌 Зажми Q - камера ПРЫГАЕТ на цель")
print("📌 Отпусти Q - наводка отключается")
print("📌 Целится в: " .. _G.AimPart)
print("====================================")