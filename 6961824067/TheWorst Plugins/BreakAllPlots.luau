--Plugin The Worst

local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect

Sect.FunLineSection:AddButton({
    Name = "Break all plots",
    Callback = function(Value)
        if Value then
            getgenv()._breakPlotsActive = true
            getgenv().ShurikenSpawnedCount = 0
            getgenv().Shurikens = {}

            task.spawn(function()
                local lp = game.Players.LocalPlayer
                local rs = game:GetService("ReplicatedStorage")

                local SNO = rs.GrabEvents:FindFirstChild("SetNetworkOwner")
                local STRF = rs.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
                local SPE = rs.PlayerEvents:FindFirstChild("StickyPartEvent")
                local spawned = workspace:FindFirstChild(lp.Name .. "SpawnedInToys")

                local Objects = {
                    workspace.Plots.Plot1.PlotArea,
                    workspace.Plots.Plot2.PlotArea,
                    workspace.Plots.Plot3.PlotArea,
                    workspace.Plots.Plot4.PlotArea,
                    workspace.Plots.Plot5.PlotArea
                }

                local function GetStickTarget(obj)
                    if obj:IsA("BasePart") then
                        return obj
                    end
                    return obj:FindFirstChildWhichIsA("BasePart", true)
                end

                local currentPlotIndex = 1
                local myroot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

                local connection
                connection = spawned.ChildAdded:Connect(function(child)
                    if not getgenv()._breakPlotsActive then return end
                    if child.Name ~= "NinjaShuriken" then return end

                    local myIndex = currentPlotIndex
                    currentPlotIndex = currentPlotIndex % 5 + 1

                    table.insert(getgenv().Shurikens, child)
                    getgenv().ShurikenSpawnedCount += 1
                    task.spawn(function()
                        local SoundPart = child:WaitForChild("SoundPart", 5)
                        local StickyPart = child:WaitForChild("StickyPart", 5)

                        if not SoundPart or not StickyPart then return end

                        local Object = GetStickTarget(Objects[myIndex])
                        if not Object then return end

                        SNO:FireServer(SoundPart, SoundPart.CFrame)
                        task.wait(0.2)

                        if not getgenv()._breakPlotsActive then return end

                        SPE:FireServer(StickyPart, Object,
                            CFrame.new(2.19902378e+12, 2.19902326e+12, 2.19902378e+12, -1, 0, 0, 0, 1, 0, 0, 0, -1))
                    end)
                end)

                while getgenv()._breakPlotsActive and myroot and getgenv().ShurikenSpawnedCount < 5 do
                    STRF:InvokeServer("NinjaShuriken", myroot.CFrame * CFrame.new(0, 0, 25), Vector3.new(0, 0, 0))
                    task.wait(0.01)
                end
                
                task.wait(0.01)
                if connection then
                    connection:Disconnect()
                end
            end)
        else
            getgenv()._breakPlotsActive = false

            local rs = game:GetService("ReplicatedStorage")
            local DestroyToy = rs.MenuToys:FindFirstChild("DestroyToy")

            if DestroyToy then
                for _, shuriken in ipairs(getgenv().Shurikens or {}) do
                    if shuriken and shuriken.Parent then
                        pcall(function()
                            DestroyToy:InvokeServer(shuriken)
                        end)
                    end
                end
            end

            getgenv().ShurikenSpawnedCount = 0
            getgenv().Shurikens = {}
        end
    end
})
