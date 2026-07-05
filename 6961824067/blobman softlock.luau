Players = game:GetService("Players")
ReplicatedStorage = game:GetService("ReplicatedStorage")
LocalPlayer = Players.LocalPlayer

lockLoopActive = false

function isnetworkowner(part)
    return part and part:IsDescendantOf(workspace) and part.ReceiveAge == 0
end

function FWC(Parent, Name, Time)
    return Parent:FindFirstChild(Name) or Parent:WaitForChild(Name, Time)
end

function grab(HRP)
    pcall(function()
        ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(HRP, HRP.CFrame)
    end)
end

function blob_lock(blob, hrp, rl, v)
    local detec = FWC(blob, rl .. "Detector", 0.1)
    if detec then
        local grab = blob.BlobmanSeatAndOwnerScript.CreatureGrab
        local drop = blob.BlobmanSeatAndOwnerScript.CreatureDrop
        local rel = blob.BlobmanSeatAndOwnerScript.CreatureRelease
        if v == "Default" and detec then
            grab:FireServer(detec, hrp, detec[rl .. "Weld"])
        elseif v == "DDrop" then
            drop:FireServer(detec[rl .. "Weld"])
        elseif v == "Release" then
            rel:FireServer(detec[rl .. "Weld"], hrp)
        end
    end
end

BlobTab:CreateToggle({
    Name = "Softlock",
    CurrentValue = false,
    Flag = "LoopLock",
    Callback = function(Value)
        lockLoopActive = Value
        
        if Value then
            if not SelectedPlayer then
                lockLoopActive = false
                return
            end
            
            task.spawn(function()
                local MyBlob
                local Time = tick()
                local lastCheck = 0
                
                while lockLoopActive do
                    local currentTime = tick()
                    local mychar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local myHRP = FWC(mychar, "HumanoidRootPart", 0.1)
                    local myhum = FWC(mychar, "Humanoid", 0.1)
                    
                    if myhum and myhum.SeatPart then
                        MyBlob = myhum.SeatPart.Parent
                    end
                    
                    local targetPlr = Players:FindFirstChild(SelectedPlayer)
                    if targetPlr then
                        local char = targetPlr.Character
                        local hum = char and FWC(char, "Humanoid", 0.1)
                        local HRP = char and FWC(char, "HumanoidRootPart", 0.1)
                        
                        if HRP and hum and MyBlob and MyBlob.Parent then
                            if isnetworkowner(HRP) then
                                if currentTime - Time > 0.1 then
                                    hum.Sit = true
                                    task.wait(0.01)
                                    hum.Sit = false
                                    Time = currentTime
                                end
                                
                                local LD = MyBlob:FindFirstChild("LeftDetector")
                                if LD then
                                    HRP.CFrame = LD.CFrame
                                end
                                
                                for _, v in pairs(char:GetChildren()) do
                                    if v:IsA("BasePart") then
                                        v.Velocity = Vector3.new()
                                    end
                                end
                                
                                if myHRP and (myHRP.Position - HRP.Position).Magnitude < 40 and hum.SeatPart then
                                    grab(HRP)
                                end
                            end
                            
                            if currentTime - lastCheck > 0 then
                                blob_lock(MyBlob, HRP, "Left", "Default")
                                blob_lock(MyBlob, HRP, "Left", "Release")
                                lastCheck = currentTime
                            end
                        end
                    end
                    task.wait(0)
                end
            end)
        end
    end
})
