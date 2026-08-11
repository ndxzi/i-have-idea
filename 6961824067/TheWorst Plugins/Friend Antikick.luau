local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local selectedPlayers = {}

local RS = game:GetService("ReplicatedStorage")
local GrabEvents = RS:WaitForChild("GrabEvents")
local PlayerEvents = RS:WaitForChild("PlayerEvents")

local SNO = GrabEvents:WaitForChild("SetNetworkOwner")
local SPE = PlayerEvents:WaitForChild("StickyPartEvent")
local SpawnRemote = RS.MenuToys:WaitForChild("SpawnToyRemoteFunction")
local DestroyRemote = RS.MenuToys:WaitForChild("DestroyToy")

local function UpdatePlayersList()
    local PlayersList = {}
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            PlayersList[#PlayersList + 1] = Player.Name .. " (" .. Player.DisplayName .. ")"
        end
    end
    return PlayersList
end

local AntiKick = Sect.AntikickSection:AddToggle({
    Name = "Anti Kick",
    Default = false,
    Flag = "FriendAntiKick",
    Binded = true,
    DefaultBind = "",
    Settings = true,
    Callback = function(Value)
        _G.ShurikenAntiKick = Value

        local function ClearKunai()
            local inv = workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            if inv and DestroyRemote then
                for _, v in pairs(inv:GetChildren()) do
                    if v.Name == "AntiKick" or v.Name == "NinjaShuriken" then
                        pcall(function() DestroyRemote:FireServer(v) end)
                    end
                end
            end
        end

        if Value then
            task.spawn(function()
                local plr = LocalPlayer
                local canSpawn = plr:WaitForChild("CanSpawnToy")

                local activeKunais = {}

                local function getHRP(char)
                    return char and char:FindFirstChild("HumanoidRootPart")
                end

                local function getTargetHRP(targetName)
                    local target = Players:FindFirstChild(targetName)
                    return target and getHRP(target.Character)
                end
				
                local function EnsureOwnership(kunai)
                    local soundPart = kunai:FindFirstChild("SoundPart")
                    if not soundPart then return false end
                    
                    local timeout = tick() + 4
                    while tick() < timeout do
                        local owner = soundPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == plr.Name then
                            return true
                        end
                        SNO:FireServer(soundPart, soundPart.CFrame)
                        task.wait(0.025)
                    end
                    return false
                end

                local function StickKunai(kunai, targetName)
                    if not kunai or not kunai:FindFirstChild("StickyPart") then return end
                    
                    local hrp = getTargetHRP(targetName)
                    if not hrp then return end
                    
                    local firePart = hrp:FindFirstChild("FirePlayerPart") or hrp:WaitForChild("FirePlayerPart", 2)
                    if firePart then
                        SPE:FireServer(
                            kunai.StickyPart,
                            firePart,
                            CFrame.new(0,0,0) * CFrame.Angles(0, math.rad(90), math.rad(90))
                        )
                    end

                    for _, obj in pairs(kunai:GetChildren()) do
                        if obj.Name == "Pyramid" or obj.Name == "Main" or obj:IsA("BasePart") then
                            obj.CanTouch = false
                            obj.CanCollide = false
                            obj.CanQuery = false
                            obj.Transparency = (obj.Name == "Main" or obj.Name == "Pyramid") and 0 or 1
                            
                            if (obj.Name == "Pyramid" or obj.Name == "Main") and not obj:FindFirstChild("Highlight") then
                                local high = Instance.new("Highlight", obj)
                                high.FillColor = obj.Name == "Pyramid" and Color3.new(0,0,0) or Color3.new(1,1,1)
                            end
                        end
                    end
                end

                local function SpawnToy()
                    local t = tick()
                    while not canSpawn.Value do
                        if not _G.ShurikenAntiKick or tick() - t > 5 then return nil end
                        task.wait(0.08)
                    end

                    local myHRP = getHRP(plr.Character)
                    if myHRP then
                        pcall(function()
                            SpawnRemote:InvokeServer("NinjaShuriken", myHRP.CFrame * CFrame.new(0, 1, -1), Vector3.new(0,0,0))
                        end)
                    end
                    
                    local inv = workspace:FindFirstChild(plr.Name.."SpawnedInToys")
                    if inv then
                        return inv:WaitForChild("NinjaShuriken", 2)
                    end
                    return nil
                end

                local function GetPlayerNameFromDropdown(text)
                    return text:match("^(.+) %(")
                end

                while _G.ShurikenAntiKick do 
                    task.wait(0.1)
                    
                    if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health <= 0 then 
                        task.wait(0.5) 
                        continue 
                    end

                    for _, playerText in ipairs(selectedPlayers) do
                        local targetName = GetPlayerNameFromDropdown(playerText)
                        if not targetName then continue end
                        
                        local targetPlr = Players:FindFirstChild(targetName)
                        if not targetPlr or not targetPlr.Character then continue end
                        if not targetPlr.Character:FindFirstChild("Humanoid") or targetPlr.Character.Humanoid.Health <= 0 then continue end

                        local kunai = activeKunais[targetName]

                        if not kunai or not kunai.Parent then
                            kunai = SpawnToy()
                            if kunai then
                                kunai.Name = "AntiKick"
                                activeKunais[targetName] = kunai
                            end
                        end

                        if kunai then
                            if EnsureOwnership(kunai) then
                                StickKunai(kunai, targetName)
                            end
                        end
                    end

                    for targetName, kunai in pairs(activeKunais) do
                        local isSelected = false
                        for _, v in ipairs(selectedPlayers) do
                            if GetPlayerNameFromDropdown(v) == targetName then
                                isSelected = true
                                break
                            end
                        end
                        
                        if not isSelected or not kunai or not kunai.Parent then
                            pcall(function() DestroyRemote:FireServer(kunai) end)
                            activeKunais[targetName] = nil
                        end
                    end
                end

                ClearKunai()
            end)
        else
            _G.ShurikenAntiKick = false
            ClearKunai()
        end
    end
})

local PlayerSelectDropdown
PlayerSelectDropdown = AntiKick:AddDropdown({
    Name = "Select Players",
    Options = UpdatePlayersList(),
    Multi = true,
    Default = {},
    MaxSize = 12,
    Search = true,
    Flag = "FriendList",
    Callback = function(Value)
        selectedPlayers = Value
    end
})

game.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    PlayerSelectDropdown:Refresh(UpdatePlayersList(), true)
end)

game.Players.PlayerRemoving:Connect(function()
    PlayerSelectDropdown:Refresh(UpdatePlayersList(), true)
end)
