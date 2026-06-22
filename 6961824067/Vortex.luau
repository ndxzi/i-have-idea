local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🔥 Vortex Hub - Fling Things and People",
    LoadingTitle = "Vortex Hub Yükleniyor kanka...",
    LoadingSubtitle = "Kendi hilemiz hazır 🚀",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VortexHubFTAP",
        FileName = "VortexConfig"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Ana Özellikler", 4483362458)
local FunTab = Window:CreateTab("Eğlence & Görseller", 4483362458)

-- ==================== FLİNG ÖZELLİKLERİ ====================
local flingPower = 150

MainTab:CreateSlider({
    Name = "Fling Gücü Ayarla",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(Value)
        flingPower = Value
    end
})

MainTab:CreateButton({
    Name = "🔥 Fling Nearby Players (Güçlü)",
    Callback = function()
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr \~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                root.AssemblyLinearVelocity = Vector3.new(
                    math.random(-flingPower, flingPower),
                    flingPower * 1.8,
                    math.random(-flingPower, flingPower)
                )
            end
        end
        Rayfield:Notify({Title = "Fling Patladı!", Content = "Herkes roket gibi uçtu 😂", Duration = 4})
    end
})

-- ==================== ORBIT AURA ====================
local orbitConnection = nil
local orbiting = false

FunTab:CreateToggle({
    Name = "🌌 Orbit Aura (Kendine Çek)",
    CurrentValue = false,
    Callback = function(Value)
        orbiting = Value
        if orbiting then
            if orbitConnection then orbitConnection:Disconnect() end
            orbitConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local myChar = game.Players.LocalPlayer.Character
                if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
                local myRoot = myChar.HumanoidRootPart

                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr \~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local root = plr.Character.HumanoidRootPart
                        local dist = (root.Position - myRoot.Position).Magnitude
                        if dist < 40 and dist > 5 then
                            local angle = tick() * 8
                            root.CFrame = myRoot.CFrame * CFrame.new(math.cos(angle) * 18, 6 + math.sin(tick()*3)*3, math.sin(angle) * 18)
                        end
                    end
                end
            end)
        else
            if orbitConnection then 
                orbitConnection:Disconnect() 
                orbitConnection = nil 
            end
        end
    end
})

-- ==================== WİNG & SPARKLER ====================
FunTab:CreateButton({
    Name = "🪽 Wing Ekle (Güzel Efekt)",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local attachLeft = Instance.new("Attachment", char.HumanoidRootPart)
            attachLeft.Position = Vector3.new(-2, 0, 0)
            local attachRight = Instance.new("Attachment", char.HumanoidRootPart)
            attachRight.Position = Vector3.new(2, 0, 0)

            local wing = Instance.new("ParticleEmitter", attachLeft)
            wing.Texture = "rbxassetid://243098098"
            wing.Lifetime = NumberRange.new(1.5, 3)
            wing.Rate = 80
            wing.Speed = NumberRange.new(0)
            wing.SpreadAngle = Vector2.new(90, 90)
            wing.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255))

            local wing2 = wing:Clone()
            wing2.Parent = attachRight

            Rayfield:Notify({Title = "Wing Takıldı!", Content = "Şimdi güzel uç kanka 🕊️", Duration = 3})
        end
    end
})

FunTab:CreateButton({
    Name = "✨ Sparkler Efekti (Parıltı)",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Head") then
            local spark = Instance.new("ParticleEmitter", char.Head)
            spark.Texture = "rbxassetid://241650934"
            spark.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,100)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,50,50))}
            spark.Lifetime = NumberRange.new(0.6, 1.8)
            spark.Rate = 150
            spark.Speed = NumberRange.new(8, 20)
            spark.SpreadAngle = Vector2.new(360, 360)
            spark.Size = NumberSequence.new(0.5)

            task.wait(6)
            spark:Destroy()
            Rayfield:Notify({Title = "Sparkler Patladı!", Content = "Parıl parıl oldun 😂", Duration = 3})
        end
    end
})

-- Ekstra ufak bir buton
MainTab:CreateButton({
    Name = "🚀 Super Fling (Çok Güçlü)",
    Callback = function()
        flingPower = 350
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr \~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                root.AssemblyLinearVelocity = Vector3.new(math.random(-350,350), 600, math.random(-350,350))
            end
        end
        Rayfield:Notify({Title = "SUPER FLING!", Content = "Herkes uzaya gitti kanka 🌌", Duration = 4})
    end
})

print("Vortex Hub başarıyla yüklendi! Keyifli fling'ler kanka 😂")
