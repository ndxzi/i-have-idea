Players = game:GetService("Players")
Workspace = game:GetService("Workspace")
SoundService = game:GetService("SoundService")
RunService = game:GetService("RunService")

LocalPlayer = Players.LocalPlayer

blackHoleNotifyEnabled = false
blackHoleConnection = nil
espEnabled = false
espConns = {}
rgbConnection = nil
SelectedPlayer = nil

function playKickSound()
	s = Instance.new("Sound")
	s.SoundId = "rbxassetid://98136259530074"
	s.Volume = 5
	s.PlayOnRemove = true
	s.Parent = SoundService
	s:Destroy()
end

function notifyKick(displayName, username)
	Rayfield:Notify({
		Title = "Black Hole Kick",
		Content = displayName .. " (" .. username .. ") has been kicked",
		Duration = 6,
		Image = 4483362458,
	})
end

function isTargetPlayer(plr)
	if not SelectedPlayer then return false end
	return plr and plr.Name == SelectedPlayer
end

function getClosestPlayer(pos)
	if not SelectedPlayer then return nil end
	
	targetPlayer = Players:FindFirstChild(SelectedPlayer)
	if not targetPlayer or not targetPlayer.Character then return nil end
	
	hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	
	dist = (hrp.Position - pos).Magnitude
	if dist < 50 then
		return targetPlayer
	end
	
	return nil
end

function getRGBColor()
	hue = tick() % 5 / 5
	return Color3.fromHSV(hue, 1, 1)
end

function addESP(obj)
	if not obj:IsA("BasePart") and not obj:IsA("Model") then
		return
	end
	if obj:FindFirstChild("ESPHighlight") then
		return
	end
	highlight = Instance.new("Highlight")
	highlight.Name = "ESPHighlight"
	highlight.FillColor = getRGBColor()
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineTransparency = 0
	highlight.Parent = obj
end

function clearESPs()
	for _, obj in ipairs(Workspace:GetDescendants()) do
		esp = obj:FindFirstChild("ESPHighlight")
		if esp then
			esp:Destroy()
		end
	end
end

function startRGBEffect()
	if rgbConnection then
		rgbConnection:Disconnect()
	end
	rgbConnection = RunService.RenderStepped:Connect(function()
		if not espEnabled then
			return
		end
		color = getRGBColor()
		for _, obj in ipairs(Workspace:GetDescendants()) do
			esp = obj:FindFirstChild("ESPHighlight")
			if esp and esp:IsA("Highlight") then
				esp.FillColor = color
			end
		end
	end)
end

function stopRGBEffect()
	if rgbConnection then
		rgbConnection:Disconnect()
		rgbConnection = nil
	end
end

function startBlackHoleDetection()
	if blackHoleConnection then
		blackHoleConnection:Disconnect()
		blackHoleConnection = nil
	end
	blackHoleConnection = Workspace.ChildAdded:Connect(function(obj)
		if not blackHoleNotifyEnabled then
			return
		end
		if obj.Name == "BlackHoleKick" or obj.Name == "BlackHoleDetected" then
			task.wait(0.05)
			
			pos = nil
			if obj:IsA("BasePart") then
				pos = obj.Position
			elseif obj:IsA("Model") and obj.PrimaryPart then
				pos = obj.PrimaryPart.Position
			end
			if not pos then
				return
			end
			
			plr = getClosestPlayer(pos)
			if not plr then
				return
			end
			
			if espEnabled then
				addESP(obj)
			end
			
			playKickSound()
			notifyKick(plr.DisplayName, plr.Name)
		end
	end)
end

function stopBlackHoleDetection()
	if blackHoleConnection then
		blackHoleConnection:Disconnect()
		blackHoleConnection = nil
	end
end

function updateBlackHoleDetection()
	if blackHoleNotifyEnabled then
		startBlackHoleDetection()
	end
end

function updateESP()
	if espEnabled then
		clearESPs()
		
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj.Name == "BlackHoleKick" or obj.Name == "BlackHoleDetected" then
				pos = nil
				if obj:IsA("BasePart") then
					pos = obj.Position
				elseif obj:IsA("Model") and obj.PrimaryPart then
					pos = obj.PrimaryPart.Position
				end
				
				if pos then
					plr = getClosestPlayer(pos)
					if plr then
						addESP(obj)
					end
				end
			end
		end
	end
end

BlackHoleToggle = LoopTab:CreateToggle({
	Name = "Black Hole Kick Notify (Target)",
	CurrentValue = false,
	Flag = "BlackHoleNotify",
	Callback = function(Value)
		blackHoleNotifyEnabled = Value
		if Value then
			if not SelectedPlayer then
				Rayfield:Notify({
					Title = "Error",
					Content = "Please select a target player first",
					Duration = 3,
					Image = 4483362458,
				})
				BlackHoleToggle:Set(false)
				return
			end
			startBlackHoleDetection()
		else
			stopBlackHoleDetection()
		end
	end,
})

ESPToggle = LoopTab:CreateToggle({
	Name = "ESP BlackHoles (Target)",
	CurrentValue = false,
	Flag = "BlackHoleESP",
	Callback = function(state)
		espEnabled = state
		if state then
			if not SelectedPlayer then
				Rayfield:Notify({
					Title = "Error",
					Content = "Please select a target player first",
					Duration = 3,
					Image = 4483362458,
				})
				ESPToggle:Set(false)
				return
			end
			
			for _, obj in ipairs(Workspace:GetDescendants()) do
				if obj.Name == "BlackHoleKick" or obj.Name == "BlackHoleDetected" then
					pos = nil
					if obj:IsA("BasePart") then
						pos = obj.Position
					elseif obj:IsA("Model") and obj.PrimaryPart then
						pos = obj.PrimaryPart.Position
					end
					
					if pos then
						plr = getClosestPlayer(pos)
						if plr then
							addESP(obj)
						end
					end
				end
			end
			
			table.insert(espConns, Workspace.DescendantAdded:Connect(function(obj)
				if espEnabled and (obj.Name == "BlackHoleKick" or obj.Name == "BlackHoleDetected") then
					task.wait(0.05)
					pos = nil
					if obj:IsA("BasePart") then
						pos = obj.Position
					elseif obj:IsA("Model") and obj.PrimaryPart then
						pos = obj.PrimaryPart.Position
					end
					
					if pos then
						plr = getClosestPlayer(pos)
						if plr then
							addESP(obj)
						end
					end
				end
			end))
			startRGBEffect()
		else
			for _, c in ipairs(espConns) do
				c:Disconnect()
			end
			table.clear(espConns)
			clearESPs()
			stopRGBEffect()
		end
	end,
})

function onSelectedPlayerChanged(newPlayer)
	SelectedPlayer = newPlayer
	updateBlackHoleDetection()
	updateESP()
end

game:GetService("Players").PlayerRemoving:Connect(function(plr)
	if plr == LocalPlayer then
		stopBlackHoleDetection()
		stopRGBEffect()
		for _, c in ipairs(espConns) do
			c:Disconnect()
		end
		clearESPs()
	end
end)
