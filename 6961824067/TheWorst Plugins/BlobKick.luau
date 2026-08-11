local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect
local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer

local selectedTarget = nil
local kickLoopEnabled = false

local function UpdatePlayersList()
	local PlayersList = {}
	for _, Player in ipairs(Players:GetPlayers()) do
		if Player ~= LocalPlayer then
			PlayersList[#PlayersList + 1] = Player.Name .. " (" .. Player.DisplayName .. ")"
		end
	end
	return PlayersList
end

local PlayerSelectDropdown = Sect.PlayersBlobSection:AddDropdown({
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
	Name = "Loop Kick",
	Default = false,
	Flag = "LoopKick",
	Binded = true,
	DefaultBind = "",
	Settings = false,
	Callback = function(on)
		kickLoopEnabled = on

		if on and not selectedTarget then
			kickLoopEnabled = false
			return
		end

		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChild("Humanoid")
		local seat = hum and hum.SeatPart

		if on and (not seat or seat.Parent.Name ~= "CreatureBlobman") then
			kickLoopEnabled = false
			return
		end

		if not on then
			kickLoopEnabled = false
			return
		end

		task.spawn(function()
			local RS = game:GetService("ReplicatedStorage")
			local GE = RS:WaitForChild("GrabEvents")

			local blob = seat.Parent
			local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
			local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")

			local CG = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
			local CD = scriptObj and scriptObj:FindFirstChild("CreatureDrop")

			local R_Det = blob:FindFirstChild("RightDetector")
			local R_Weld = R_Det and (R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld"))

			local SNO = GE:WaitForChild("SetNetworkOwner")
			local CreateGrabLine = GE:WaitForChild("CreateGrabLine")
			local DestroyGrabLine = GE:WaitForChild("DestroyGrabLine")

			local SavedPos = blobRoot.CFrame
			local packetCount = 0
			local wasDead = false
			local lockPos = SavedPos * CFrame.new(0, 19, 0)

			local function TeleportToTarget()
				if selectedTarget and selectedTarget.Character then
					local tRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
					if tRoot and blobRoot then
						blobRoot.CFrame = tRoot.CFrame
						blobRoot.Velocity = Vector3.zero
						if CG and R_Det then CG:FireServer(R_Det, tRoot, R_Weld) end
						if CreateGrabLine then CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false) end

						local startTime = tick()
						while tick() - startTime < 0.7 do
							if SNO and tRoot.Parent then
								SNO:FireServer(tRoot, tRoot.CFrame)
							end
							Heartbeat:Wait()
						end

						blobRoot.CFrame = SavedPos
						blobRoot.Velocity = Vector3.zero

						startTime = tick()
						while tick() - startTime < 0.7 do
							if SNO and tRoot.Parent then
								SNO:FireServer(tRoot, tRoot.CFrame)
							end
							Heartbeat:Wait()
						end
					end
				end
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
					Heartbeat:Wait()
					continue
				end

				if tHum.Health > 0 and wasDead then
					wasDead = false
					TeleportToTarget()
					Heartbeat:Wait()
					continue
				end

				if tHum.Health <= 0 then
					wasDead = true
					Heartbeat:Wait()
					continue
				end

				blobRoot.CFrame = SavedPos
				blobRoot.Velocity = Vector3.zero

				tRoot.CFrame = lockPos
				tRoot.Velocity = Vector3.zero
				tRoot.RotVelocity = Vector3.zero

				if tRoot.AssemblyLinearVelocity then
					tRoot.AssemblyLinearVelocity = Vector3.zero
					tRoot.AssemblyAngularVelocity = Vector3.zero
				end

				if SNO then SNO:FireServer(tRoot, lockPos) end

				packetCount = packetCount + 1
				if packetCount >= 2 then
					packetCount = 0

					tHum.PlatformStand = true
					tHum.Sit = true

					if R_Det then
						local weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
						if weld and CD then CD:FireServer(weld) end
					end

					if DestroyGrabLine then DestroyGrabLine:FireServer(tRoot) end
					if R_Det and CG then CG:FireServer(R_Det, tRoot, R_Weld) end
					if CreateGrabLine then CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false) end
				end

				Heartbeat:Wait()
			end

			kickLoopEnabled = false
			if blobRoot then
				blobRoot.CFrame = SavedPos
				blobRoot.Velocity = Vector3.zero
			end
		end)
	end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer

local selectedTarget = nil
local kickLoopEnabled = false

local function UpdatePlayersList()
	local PlayersList = {}
	for _, Player in ipairs(Players:GetPlayers()) do
		if Player ~= LocalPlayer then
			PlayersList[#PlayersList + 1] = Player.Name .. " (" .. Player.DisplayName .. ")"
		end
	end
	return PlayersList
end

local PlayerSelectDropdown = Sect.PlayersBlobSection:AddDropdown({
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
	Name = "Loop Kick",
	Default = false,
	Flag = "LoopKick",
	Binded = true,
	DefaultBind = "",
	Settings = false,
	Callback = function(on)
		kickLoopEnabled = on

		if on and not selectedTarget then
			kickLoopEnabled = false
			return
		end

		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChild("Humanoid")
		local seat = hum and hum.SeatPart

		if on and (not seat or seat.Parent.Name ~= "CreatureBlobman") then
			kickLoopEnabled = false
			return
		end

		if not on then
			kickLoopEnabled = false
			return
		end

		task.spawn(function()
			local RS = game:GetService("ReplicatedStorage")
			local GE = RS:WaitForChild("GrabEvents")

			local blob = seat.Parent
			local blobRoot = blob:FindFirstChild("HumanoidRootPart") or blob.PrimaryPart
			local scriptObj = blob:FindFirstChild("BlobmanSeatAndOwnerScript")

			local CG = scriptObj and scriptObj:FindFirstChild("CreatureGrab")
			local CD = scriptObj and scriptObj:FindFirstChild("CreatureDrop")

			local R_Det = blob:FindFirstChild("RightDetector")
			local R_Weld = R_Det and (R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld"))

			local SNO = GE:WaitForChild("SetNetworkOwner")
			local CreateGrabLine = GE:WaitForChild("CreateGrabLine")
			local DestroyGrabLine = GE:WaitForChild("DestroyGrabLine")

			local SavedPos = blobRoot.CFrame
			local packetCount = 0
			local wasDead = false
			local lockPos = SavedPos * CFrame.new(0, 19, 0)

			local function TeleportToTarget()
				if selectedTarget and selectedTarget.Character then
					local tRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
					if tRoot and blobRoot then
						blobRoot.CFrame = tRoot.CFrame
						blobRoot.Velocity = Vector3.zero
						if CG and R_Det then CG:FireServer(R_Det, tRoot, R_Weld) end
						if CreateGrabLine then CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false) end

						local startTime = tick()
						while tick() - startTime < 0.7 do
							if SNO and tRoot.Parent then
								SNO:FireServer(tRoot, tRoot.CFrame)
							end
							Heartbeat:Wait()
						end

						blobRoot.CFrame = SavedPos
						blobRoot.Velocity = Vector3.zero

						startTime = tick()
						while tick() - startTime < 0.7 do
							if SNO and tRoot.Parent then
								SNO:FireServer(tRoot, tRoot.CFrame)
							end
							Heartbeat:Wait()
						end
					end
				end
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
					Heartbeat:Wait()
					continue
				end

				if tHum.Health > 0 and wasDead then
					wasDead = false
					TeleportToTarget()
					Heartbeat:Wait()
					continue
				end

				if tHum.Health <= 0 then
					wasDead = true
					Heartbeat:Wait()
					continue
				end

				blobRoot.CFrame = SavedPos
				blobRoot.Velocity = Vector3.zero

				tRoot.CFrame = lockPos
				tRoot.Velocity = Vector3.zero
				tRoot.RotVelocity = Vector3.zero

				if tRoot.AssemblyLinearVelocity then
					tRoot.AssemblyLinearVelocity = Vector3.zero
					tRoot.AssemblyAngularVelocity = Vector3.zero
				end

				if SNO then SNO:FireServer(tRoot, lockPos) end

				packetCount = packetCount + 1
				if packetCount >= 2 then
					packetCount = 0

					tHum.PlatformStand = true
					tHum.Sit = true

					if R_Det then
						local weld = R_Det:FindFirstChild("RightWeld") or R_Det:FindFirstChildWhichIsA("Weld")
						if weld and CD then CD:FireServer(weld) end
					end

					if DestroyGrabLine then DestroyGrabLine:FireServer(tRoot) end
					if R_Det and CG then CG:FireServer(R_Det, tRoot, R_Weld) end
					if CreateGrabLine then CreateGrabLine:FireServer(tRoot, Vector3.zero, tRoot.Position, false) end
				end

				Heartbeat:Wait()
			end

			kickLoopEnabled = false
			if blobRoot then
				blobRoot.CFrame = SavedPos
				blobRoot.Velocity = Vector3.zero
			end
		end)
	end
})
