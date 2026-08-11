local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect

local removeAntiKickAuraActive = false
local removeAntiKickAuraConnection = nil
local useWhitelistRemoveAntiKick = true

local toggle = Sect.AdvancedSection:AddToggle({
	Name = "Grab antikick aura",
	Default = false,
	Flag = "UnstickToggle",
	Binded = true,
	DefaultBind = "",
	Settings = true,
	Callback = function(on)
		removeAntiKickAuraActive = on
		if not on then
			if removeAntiKickAuraConnection then
				removeAntiKickAuraConnection:Disconnect()
				removeAntiKickAuraConnection = nil
			end
			return
		end
		task.spawn(function()
			local RS = game:GetService("ReplicatedStorage")
			local Players = game:GetService("Players")
			local RunService = game:GetService("RunService")
			local LocalPlayer = Players.LocalPlayer
			local GrabEvents = RS:WaitForChild("GrabEvents")
			local SetNetOwner = GrabEvents:WaitForChild("SetNetworkOwner")
			removeAntiKickAuraConnection = RunService.Heartbeat:Connect(function()
				local myChar = LocalPlayer.Character
				local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
				if not myRoot then
					return
				end
				for _, target in ipairs(Players:GetPlayers()) do
					if target ~= LocalPlayer then
						local tChar = target.Character
						local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
						if not tRoot then
							continue
						end

						if (tRoot.Position - myRoot.Position).Magnitude <= removeAntiKickRadius then
							local spawned = workspace:FindFirstChild(target.Name .. "SpawnedInToys")
							if spawned then
								for _, toyName in ipairs({
									"NinjaKunai",
									"NinjaShuriken",
									"AntiKick",
									"ToolPickaxe",
									"FoodPlate",
									"JapaneseLantern",
									"SpookyCandle1",
									"NinjaKatana",
									"ToolPencil",
									"FoodDonut",
									""
								}) do
									local toy = spawned:FindFirstChild(toyName)
									if toy then
										local part = toy:FindFirstChild("SoundPart")
										if part then
											pcall(function()
												SetNetOwner:FireServer(part, part.CFrame)
											end)
											if part:FindFirstChild("PartOwner")
												and part.PartOwner.Value == LocalPlayer.Name then
												part.CFrame = CFrame.new(0, 100000, 0)
											end
										end
									end
								end
							end
						end
					end
				end
			end)
		end)
	end
})

toggle:AddDropdown({
	Name = "Radius",
	Options = {"14", "16", "18", "20", "31"},
	Multi = false,
	Default = "20",
	MaxSize = 5,
	Search = false,
	Flag = "AntiKickAuraRadius",
	Callback = function(value)
		removeAntiKickRadius = tonumber(value)
	end
})

