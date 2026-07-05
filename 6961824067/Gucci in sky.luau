local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local PlayerName = LocalPlayer.Name

local originalCFrame = RootPart.CFrame
local antiGrabConnection
local jumpConnection
local hasJumpedOnce = false

local function spawnBlobman()
    local args = {
        [1] = "CreatureBlobman",
        [2] = CFrame.new(0, 50000, 0),
        [3] = Vector3.new(0, 59.667, 0)
    }

    local blobman = ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(unpack(args))
    local head = Workspace:WaitForChild(PlayerName .. "SpawnedInToys", 5):FindFirstChild("CreatureBlobman"):FindFirstChild("Head")

    if head then
        head.Anchored = true
        head.CFrame = CFrame.new(0, 50000, 0)
    end

    return Workspace[PlayerName .. "SpawnedInToys"].CreatureBlobman
end

local function activateGucci()
    local blobman = spawnBlobman()
    local seat = blobman:FindFirstChild("VehicleSeat")

    if seat then
        task.wait(0.5)
        RootPart.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.2)
        seat:Sit(Humanoid)
    end
  
    antiGrabConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(RootPart, 0)
        end)
    end)
  
    jumpConnection = Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
        if Humanoid.Jump and not hasJumpedOnce then
            hasJumpedOnce = true
            task.wait(0.05)
            if originalCFrame then
                RootPart.CFrame = originalCFrame
            end
            jumpConnection:Disconnect() 
        end
    end)
end

activateGucci()
