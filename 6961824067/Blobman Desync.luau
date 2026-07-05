local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function getNearestPlayerHRP(fromHRP)
    local nearest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - fromHRP.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = hrp
                end
            end
        end
    end
    return nearest
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local seat = humanoid.SeatPart
    if seat and Camera.CameraSubject and seat.Parent
        and Camera.CameraSubject:IsDescendantOf(seat.Parent) then
        Camera.CameraSubject = humanoid
    end
end)

local function hookHumanoid(humanoid)
    local lastSeat = nil
    humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
        local seat = humanoid.SeatPart
        if not seat then
            lastSeat = nil
            return
        end
        if seat == lastSeat then return end
        lastSeat = seat
        local blob = seat:FindFirstAncestor("CreatureBlobman")
        if not blob then return end
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        local char = humanoid.Parent
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        task.defer(function()
            local targetHRP = getNearestPlayerHRP(hrp)
            if targetHRP then
                hrp.CFrame = targetHRP.CFrame
            end
            for i = 1, 20 do
                task.wait(0.000001)
                humanoid.Jump = true
            end
        end)
    end)
end

local function start()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    hookHumanoid(humanoid)
end

start()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.4)
    start()
end)
