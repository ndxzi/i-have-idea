local lp = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local GrabEvents = rs:WaitForChild("GrabEvents")
local SNO = GrabEvents:WaitForChild("SetNetworkOwner")
local menutoys = rs:WaitForChild("MenuToys")
local STRF = menutoys:WaitForChild("SpawnToyRemoteFunction")
local PlayerEvents = rs:WaitForChild("PlayerEvents")
local SPE = PlayerEvents:WaitForChild("StickyPartEvent")

local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect

local Grass = workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel:GetChildren()[14]
local breakOceanEnabled = false

Sect.FunLineSection:AddToggle({
    Name = "Break Ocean",
    Default = false,
    Callback = function(Value)
        breakOceanEnabled = Value
    end
})

task.spawn(function()
    while true do
        if breakOceanEnabled then
            local spawned = workspace:FindFirstChild(lp.Name.."SpawnedInToys")
            if spawned and Grass then
                local mychar = lp.Character
                if mychar then
                    local myroot = mychar:FindFirstChild("HumanoidRootPart")
                    if myroot then
                        for i = 1, 11 do
                            if not breakOceanEnabled then break end

                            pcall(function()
                                STRF:InvokeServer("NinjaShuriken", myroot.CFrame * CFrame.new(0, 0, 2), Vector3.new(0, 0, 0))
                            end)
                            task.wait(0.01)

                            local Shuriken = spawned:FindFirstChild("NinjaShuriken")
                            
                            if Shuriken then
                                local SoundPart = Shuriken:FindFirstChild("SoundPart")
                                local StickyPart = Shuriken:FindFirstChild("StickyPart")
                                
                                if SoundPart and StickyPart then
                                    local PartOwner = SoundPart:FindFirstChild("PartOwner")
                                    for j = 1, 3 do
                                        if not breakOceanEnabled then break end
                                        if PartOwner and PartOwner.Value ~= lp.Name then
                                            pcall(function()
                                                SNO:FireServer(SoundPart, SoundPart.CFrame)
                                            end)
                                            task.wait(0.05)
                                        end
                                    end

                                    pcall(function()
                                        SPE:FireServer(StickyPart, Grass, CFrame.new(21990233, 2199023355, 21990233, -1, 0, 0, 0, 1, 0, 0, 0, -1))
                                    end)
                                end
                            end
                            
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)
