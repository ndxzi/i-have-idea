local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local selectedTarget = nil
local kickLoopEnabled = false

local GE = ReplicatedStorage:WaitForChild("GrabEvents")
local CreateGrabLine = GE:WaitForChild("CreateGrabLine")
local DestroyGrabLine = GE:WaitForChild("DestroyGrabLine")

local function UpdatePlayersList()
    local PlayersList = {}
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            PlayersList[#PlayersList + 1] = Player.Name .. " (" .. Player.DisplayName .. ")"
        end
    end
    return PlayersList
end

local PlayerSelectDropdown
PlayerSelectDropdown = Sect.PlayersBlobSection:AddDropdown({
    Name = "Select Target",
    Options = UpdatePlayersList(),
    Default = "",
    Search = true,
    MaxSize = 6,
    Flag = "BlobPlayerDropdown",
    Callback = function(option)
        if option and option ~= "" then
            local playerName = option:match("^(.+)%s%(") or option
            selectedTarget = Players:FindFirstChild(playerName)
        else
            selectedTarget = nil
        end
    end
})

game.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    PlayerSelectDropdown:Refresh(UpdatePlayersList(), true)
end)

game.Players.PlayerRemoving:Connect(function()
    PlayerSelectDropdown:Refresh(UpdatePlayersList(), true)
end)

Sect.PlayersBlobSection:AddToggle({
    Name = "Destroy Gucci",
    Default = false,
    Flag = "DestroyGucci",
    Binded = true,
    DefaultBind = "",
    Settings = false,
    Callback = function(on)
        kickLoopEnabled = on

        if not on then return end

        if not selectedTarget then
            kickLoopEnabled = false
            return
        end

        local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart
        if not seat or seat.Parent.Name ~= "CreatureBlobman" then
            kickLoopEnabled = false
            return
        end

        task.spawn(function()
            local blob = seat.Parent
            local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
            local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")

            local CG = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
            local CR = scriptObj and scriptObj:FindFirstChild("CreatureRelease")

            local R_Det = blob:FindFirstChild("RightDetector")
            local R_Weld = R_Det and (R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld"))

            local SavedPos = blobRoot.CFrame
            local packetCount = 0
            local wasDead = false

            local function TeleportToTarget()
                if not selectedTarget or not selectedTarget.Character then return end
                
                local tRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
                if not tRoot or not blobRoot then return end

                blobRoot.CFrame = tRoot.CFrame
                blobRoot.Velocity = Vector3.zero
                if CG and R_Det then CG:FireServer(R_Det, tRoot, R_Weld) end
                CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                task.wait(0.5)
                blobRoot.CFrame = SavedPos
                blobRoot.Velocity = Vector3.zero
            end

            TeleportToTarget()

            while kickLoopEnabled do
                if not selectedTarget or not selectedTarget.Parent or not selectedTarget.Character then
                    kickLoopEnabled = false
                    break
                end

                local tChar = selectedTarget.Character
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                local tHum = tChar and tChar:FindFirstChild("Humanoid")

                if not tHum or not tRoot then
                    task.wait(0.05)
                    continue
                end

                if tHum.Health > 0 and wasDead then
                    wasDead = false
                    TeleportToTarget()
                    task.wait(0.05)
                    continue
                end

                if tHum.Health <= 0 then
                    wasDead = true
                    task.wait(0.05)
                    continue
                end

                blobRoot.CFrame = SavedPos
                blobRoot.Velocity = Vector3.zero

                local lockPos = tRoot.CFrame * CFrame.new(0, -2, 0)

                tRoot.CFrame = lockPos
                tRoot.Velocity = Vector3.zero
                tRoot.RotVelocity = Vector3.zero

                if tRoot.AssemblyLinearVelocity then
                    tRoot.AssemblyLinearVelocity = Vector3.zero
                    tRoot.AssemblyAngularVelocity = Vector3.zero
                end

                packetCount = packetCount + 1
                if packetCount >= 2 then
                    packetCount = 0

                    if R_Det then
                        local weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
                        if weld and CR then
                            CR:FireServer(weld)
                            tHum.Sit = true
                        end
                    end

                    DestroyGrabLine:FireServer(tRoot)
                    if R_Det and CG then CG:FireServer(R_Det, tRoot, R_Weld) end
                    CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false)
                end

                task.wait(0.05)
            end

            if blobRoot then
                blobRoot.CFrame = SavedPos
                blobRoot.Velocity = Vector3.zero
            end
        end)
    end
})
