local function applyRealisticBH(model)
    if not model then return end

    local success, realisticModel = pcall(function()
        return game:GetObjects("rbxassetid://16797584940")[1]
    end)
    if not success or not realisticModel then return end
    
    local hole = model:FindFirstChild("Hole")
    if not hole then return end

    for _, obj in pairs(realisticModel:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Sound") or obj:IsA("Trail") then
            local clone = obj:Clone()
            clone.Parent = hole
        end
        if obj:IsA("BillboardGui") then
            local currentGui = hole:FindFirstChild("BillboardGui")
            if currentGui then
                local newGui = obj:Clone()
                newGui.Parent = hole
                if currentGui:FindFirstChild("Large") and newGui:FindFirstChild("Large") then
                    currentGui.Large.Image = newGui.Large.Image
                end
                if currentGui:FindFirstChild("Small") and newGui:FindFirstChild("Small") then
                    currentGui.Small.Image = newGui.Small.Image
                end
                newGui:Destroy()
            end
        end
    end
    
    realisticModel:Destroy()
end

local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect

Sect.CBHKSection = Tabs.VisualTab:AddSection({Name = "Custom Blackhole", Side = "Right"})
    Sect.CBHKSection:AddToggle({
    Name = "Realistic Black Hole",
    Callback = function(Value)
        customBH = Value
        
        if Value then
            local current = workspace:FindFirstChild("BlackHoleKick")
            if current then
                applyRealisticBH(current)
            end
            
            bhConnection = workspace.ChildAdded:Connect(function(child)
                if child.Name == "BlackHoleKick" then
                    task.wait()
                    applyRealisticBH(child)
                end
            end)
        else
            if bhConnection then bhConnection:Disconnect(); bhConnection = nil end
        end
    end
})
