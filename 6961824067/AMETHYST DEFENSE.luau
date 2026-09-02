-- FTAP Reverse
-- https://t.me/ReverseFTAP

local Solaris = loadstring(game:HttpGet("https://raw.githubusercontent.com/katnaa-debug/solarisobf/refs/heads/main/solaris.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local MenuToys = ReplicatedStorage:FindFirstChild("MenuToys")
local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
local CharacterEvents = ReplicatedStorage:FindFirstChild("CharacterEvents")
local PlayerEvents = ReplicatedStorage:FindFirstChild("PlayerEvents")
local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")

local HOUSES = {
	{"Pink House", CFrame.new(-491, -7, -166)},
	{"Green House", CFrame.new(-535, -7, 93)},
	{"Purple House", CFrame.new(250, -6, 463)},
	{"China House", CFrame.new(554, 123, -72)},
	{"Blue House", CFrame.new(510, 83, -339)},
	{"Spawn", CFrame.new(3, -7, -2)},
}

local stick_items = {
	"NinjaShuriken", "NinjaKunai", "ToolPencil", "ToolPickaxe",
	"ToolDiggingForkRusty", "ToolCleaver", "NinjaKatana",
}

local lag_items = {
	"FoodHamburger", "InstrumentDrumBongos", "InstrumentBrassTrumpet", "InstrumentBrassBugle",
	"InstrumentVoiceMicrophone", "InstrumentWoodwindOcarina", "InstrumentGuitarUkulele",
	"InstrumentGuitarLyre", "InstrumentGuitarBanjo", "InstrumentGuitarAcoustic",
	"CupMugBrown", "CupMugWhite", "FoodBanana", "FoodBread", "FoodBroccoli", "FoodCakePink",
	"FoodCoconut", "FoodDippyEgg", "FoodDonut", "FoodFrenchFries", "FoodHotdog", "FoodMayonnaise",
	"FoodMeatStick", "FoodMushroomPoison", "FoodPizzaCheese", "FoodPizzaPepperoni", "FoodSodaCan",
	"PoopPile", "PoopPileSparkle",
}

local paint_toys={BucketPaint=true,FoodHotSauce=true,ToiletGold=true,ToiletWhite=true}
local limbs={"Left Leg","Right Leg","Left Arm","Right Arm"}

local cfg = {
	tpTarget = CFrame.new(3, -7, -2),
	tpLoop = false,
	speed = 16,
	speedOn = false,
	speedOrig = nil,
	speedConn = nil,
	fly = false,
	flySpeed = 50,
	flyBV = nil,
	flyBG = nil,
	flyConns = {},
	safeOn = false,
	safeCF = nil,
	safeThread = nil,
	waterOn = false,
	waterParts = {},
	waterOrig = {},
	pcldOn = false,
	pcldBoxes = {},
	pcldTags = {},
	pcldConns = {},
	kickNotifyOn = false,
	kickGui = nil,
	kickConn = nil,
	kickCards = {},
	kickSeen = {},
	autoGucci = false,
	gucciConn = nil,
	gucciThread = nil,
	gucciSafe = nil,
	gucciRestore = 0,
	antiGrab = false,
	grabParts = {},
	grabConns = {},
	antiLag = false,
	antiKickReset = false,
	kickResetConn = nil,
	stickItem = "NinjaShuriken",
	stickOn = false,
	stickThread = nil,
	bananaSit = false,
	bananaSitThread = nil,
	bananaEat = false,
	bananaScan = nil,
	antiAntiInput = false,
	aaiScan = nil,
	barrierOn = false,
	barrierOrig = {},
	antiRagdoll = false,
	ragdollConns = {},
	ragdollSit = false,
	antiBlob = false,
	antiBlobHand = false,
	blobHandConn = nil,
	antiBurn = false,
	burnC1 = nil,
	burnC2 = nil,
	burnBarrier = nil,
	lagItem = "FoodHamburger",
	inputLagOn = false,
	inputLagThread = nil,
	voidOn = false,
	voidThread = nil,
	voidHeight = Workspace.FallenPartsDestroyHeight,
	antiPaint = false,
	paintConn = nil,
	antiExplode = false,
	explodeConn = nil,
	invisible = false,
	invisThread = nil,
	packetOn = false,
	packetBlocked = 0,
	autoSit = false,
	autoSitThread = nil,
	selfGrab = false,
	selfGrabThread = nil,
	selfBlob = nil,
	noclip = false,
	noclipConns = {},
}

local function character()
	return LocalPlayer.Character
end

local function humanoid()
	local c = character()
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function root()
	local c = character()
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function clickSound()
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = "rbxassetid://8745692251"
		s.Volume = 0.5
		s.Parent = SoundService
		s:Play()
		task.delay(3, function()
			if s then s:Stop() s:Destroy() end
		end)
	end)
end

local function kickSound()
	pcall(function()
		local s = Instance.new("Sound")
		s.SoundId = "rbxassetid://1846115874"
		s.Volume = 1
		s.Parent = SoundService
		s:Play()
		task.delay(4.7, function()
			if s then s:Stop() s:Destroy() end
		end)
	end)
end

local Window = Solaris:CreateWindow({
	Title = "AMETHYST DEFENSE",
	Theme = "Void",
	ToggleKey = Enum.KeyCode.RightShift,
	Transparency = 0.15,
	ShowWatermark = true,
})

local function notify(title, content, duration)
	Solaris:Notify({ Title = title, Content = content or "", Duration = duration or 3 })
end

local function fire(folder, name, ...)
	if not folder then return end
	local r = folder:FindFirstChild(name)
	if not r then return end
	pcall(function(...)
		if r:IsA("RemoteEvent") then r:FireServer(...)
		elseif r:IsA("RemoteFunction") then r:InvokeServer(...) end
	end, ...)
end

local function spawnToy(name, cf, vel)
	local fn = MenuToys and MenuToys:FindFirstChild("SpawnToyRemoteFunction")
	if not fn then return end
	pcall(function()
		fn:InvokeServer(name, cf or CFrame.new(), vel or Vector3.zero)
	end)
end

local function destroyToy(model)
	local ev = MenuToys and MenuToys:FindFirstChild("DestroyToy")
	if ev and model then pcall(function() ev:FireServer(model) end) end
end

local function myToys()
	return Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
end

local function waitCanSpawn(t)
	local f = LocalPlayer:FindFirstChild("CanSpawnToy")
	if not f then return true end
	local start = tick()
	while not f.Value and tick() - start < (t or 5) do task.wait() end
	return f.Value
end

local Tab = Window:CreateTab("Defense")

Tab:CreateSection("Player")

local houseNames = {}
for _, h in ipairs(HOUSES) do table.insert(houseNames, h[1]) end

Tab:CreateDropdown({
	Name = "Teleport Location",
	Items = houseNames,
	Default = "Spawn",
	Callback = function(name)
		for _, h in ipairs(HOUSES) do
			if h[1] == name then cfg.tpTarget = h[2] break end
		end
	end,
})

Tab:CreateToggle({
	Name = "Loop Teleport",
	Default = false,
	Callback = function(on)
		cfg.tpLoop = on
		if on then
			task.spawn(function()
				while cfg.tpLoop do
					local r = root()
					if r then r.CFrame = cfg.tpTarget end
					task.wait()
				end
			end)
			notify("Loop TP", "Enabled - Looping to selected location")
			clickSound()
		else
			notify("Loop TP", "Disabled")
		end
	end,
})

Tab:CreateButton({
	Name = "Teleport Once",
	Callback = function()
		local r = root()
		if r then
			r.CFrame = cfg.tpTarget
			notify("Teleport", "Teleported to selected location")
			clickSound()
		end
	end,
})

Tab:CreateToggle({
	Name = "Unlock Third Person",
	Default = false,
	Callback = function(on)
		if on then
			LocalPlayer.CameraMaxZoomDistance = 1000
			LocalPlayer.CameraMode = Enum.CameraMode.Classic
			notify("Third Person", "Camera unlocked")
			clickSound()
		else
			LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
			notify("Third Person", "Camera reset")
		end
	end,
})

Tab:CreateSlider({
	Name = "Speed Control",
	Min = 16, Max = 10000, Default = 16,
	Callback = function(v)
		cfg.speed = v
		local h = humanoid()
		if cfg.speedOn and h then h.WalkSpeed = v end
	end,
})

Tab:CreateToggle({
	Name = "Enable Speed",
	Default = false,
	Callback = function(on)
		cfg.speedOn = on
		local h = humanoid()
		if on then
			if h then cfg.speedOrig = h.WalkSpeed h.WalkSpeed = cfg.speed end
			cfg.speedConn = RunService.Stepped:Connect(function(_, dt)
				if not cfg.speedOn then return end
				local hum, r = humanoid(), root()
				if not hum or not r then return end
				hum.WalkSpeed = cfg.speed
				local md = hum.MoveDirection
				if md.Magnitude > 0 then
					local d = md.Unit * cfg.speed * dt * 0.1
					r.CFrame = r.CFrame + Vector3.new(d.X, 0, d.Z)
				end
			end)
			notify("Speed", "Enabled - WalkSpeed: " .. cfg.speed)
			clickSound()
		else
			if cfg.speedConn then cfg.speedConn:Disconnect() cfg.speedConn = nil end
			if h and cfg.speedOrig then h.WalkSpeed = cfg.speedOrig end
			notify("Speed", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Fly",
	Default = false,
	Callback = function(on)
		if on then
			local r = root()
			if not r or not humanoid() then return end
			for _, ch in ipairs(r:GetChildren()) do
				if ch:IsA("BodyVelocity") or ch:IsA("BodyGyro") then ch:Destroy() end
			end
			local bv = Instance.new("BodyVelocity")
			bv.Name = "FlyBV"
			bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bv.P = 1250
			bv.Velocity = Vector3.zero
			bv.Parent = r
			local bg = Instance.new("BodyGyro")
			bg.Name = "FlyBG"
			bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
			bg.P = 1250
			bg.D = 100
			bg.CFrame = r.CFrame
			bg.Parent = r
			cfg.fly, cfg.flySpeed, cfg.flyBV, cfg.flyBG = true, 50, bv, bg
			cfg.flyConns.render = RunService.RenderStepped:Connect(function()
				if not cfg.fly then return end
				local cam = Workspace.CurrentCamera
				local dir = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector * cfg.flySpeed end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector * cfg.flySpeed end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector * cfg.flySpeed end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector * cfg.flySpeed end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, cfg.flySpeed, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, cfg.flySpeed, 0) end
				if cfg.flyBV then cfg.flyBV.Velocity = dir end
				if cfg.flyBG then cfg.flyBG.CFrame = cam.CFrame end
			end)
			local mouse = LocalPlayer:GetMouse()
			cfg.flyConns.wf = mouse.WheelForward:Connect(function()
				if cfg.fly then cfg.flySpeed = math.min(cfg.flySpeed + 5, 200) end
			end)
			cfg.flyConns.wb = mouse.WheelBackward:Connect(function()
				if cfg.fly then cfg.flySpeed = math.max(cfg.flySpeed - 5, 10) end
			end)
			notify("Fly", "Enabled - WASD/Space/Shift, Mouse Wheel for speed")
			clickSound()
		else
			cfg.fly = false
			for _, c in pairs(cfg.flyConns) do pcall(function() c:Disconnect() end) end
			cfg.flyConns = {}
			if cfg.flyBV then cfg.flyBV:Destroy() cfg.flyBV = nil end
			if cfg.flyBG then cfg.flyBG:Destroy() cfg.flyBG = nil end
			notify("Fly", "Disabled")
		end
	end,
})

local function collectWater()
	cfg.waterParts, cfg.waterOrig = {}, {}
	local map = Workspace:FindFirstChild("Map")
	local tweened = map and map:FindFirstChild("AlwaysHereTweenedObjects")
	local ocean = tweened and tweened:FindFirstChild("Ocean")
	local object = ocean and ocean:FindFirstChild("Object")
	if object then
		for _, p in ipairs(object:GetDescendants()) do
			if p:IsA("BasePart") then
				table.insert(cfg.waterParts, p)
				cfg.waterOrig[p] = p.CanCollide
				p.CanCollide = true
			end
		end
	end
	for _, name in ipairs({ "Water", "Ocean", "Sea", "Lake", "River", "Pool" }) do
		local folder = Workspace:FindFirstChild(name)
		if folder then
			for _, p in ipairs(folder:GetDescendants()) do
				if p:IsA("BasePart") and p.Transparency > 0.5 and cfg.waterOrig[p] == nil then
					table.insert(cfg.waterParts, p)
					cfg.waterOrig[p] = p.CanCollide
					p.CanCollide = true
				end
			end
		end
	end
	return #cfg.waterParts > 0
end

Tab:CreateToggle({
	Name = "Water Walk",
	Default = false,
	Callback = function(on)
		cfg.waterOn = on
		if on then
			if collectWater() then
				notify("Water Walk", "Enabled - Found " .. #cfg.waterParts .. " water parts")
			else
				notify("Water Walk", "Enabled - No water parts found")
			end
			clickSound()
			task.spawn(function()
				while cfg.waterOn do
					task.wait(5)
					for _, p in ipairs(cfg.waterParts) do
						if p and p.Parent then p.CanCollide = true end
					end
					collectWater()
				end
			end)
		else
			for p, st in pairs(cfg.waterOrig) do
				if p and p.Parent then p.CanCollide = st end
			end
			cfg.waterParts, cfg.waterOrig = {}, {}
			notify("Water Walk", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Safe Pos LP",
	Default = false,
	Callback = function(on)
		if on then
			local r = root()
			if not r then notify("Safe Pos", "Error: Could not save position!") return end
			cfg.safeOn = true
			cfg.safeCF = r.CFrame
			cfg.safeThread = task.spawn(function()
				while cfg.safeOn do
					local rr = root()
					if rr then rr.CFrame = cfg.safeCF end
					task.wait()
				end
			end)
			notify("Safe Pos", "Enabled - Position saved")
			clickSound()
		else
			cfg.safeOn = false
			if cfg.safeThread then task.cancel(cfg.safeThread) cfg.safeThread = nil end
			notify("Safe Pos", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "PCLD ESP",
	Default = false,
	Callback = function(on)
		local function isDet(part)
			if not part:IsA("BasePart") then return false end
			local n = part.Name:lower()
			return n == "playercharacterlocationdetector" or n == "partesp" or n == "playercharacterlocationdetectorfake"
		end
		local function addBox(part)
			if cfg.pcldBoxes[part] then return end
			local box = Instance.new("BoxHandleAdornment")
			box.Name = "PCLD_ESP_Box"
			box.Adornee = part
			box.AlwaysOnTop = true
			box.ZIndex = 10
			box.Size = part.Size * 1.05
			box.Transparency = 0.45
			box.Color3 = Color3.fromRGB(180, 150, 255)
			box.Parent = CoreGui
			cfg.pcldBoxes[part] = box
			table.insert(cfg.pcldConns, part.AncestryChanged:Connect(function(_, parent)
				if not parent and cfg.pcldBoxes[part] then
					cfg.pcldBoxes[part]:Destroy()
					cfg.pcldBoxes[part] = nil
				end
			end))
		end
		local function addTag(player)
			if cfg.pcldTags[player] then return end
			local gui = Instance.new("BillboardGui")
			gui.Name = "PlayerNameTag_" .. player.Name
			gui.AlwaysOnTop = true
			gui.Size = UDim2.new(0, 210, 0, 44)
			gui.StudsOffset = Vector3.new(0, 6, 0)
			gui.MaxDistance = 5000
			gui.Parent = CoreGui
			local frame = Instance.new("Frame")
			frame.Size = UDim2.fromScale(1, 1)
			frame.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
			frame.BackgroundTransparency = 0.25
			frame.BorderSizePixel = 0
			frame.Parent = gui
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
			local stroke = Instance.new("UIStroke", frame)
			stroke.Color = Color3.fromRGB(180, 150, 255)
			stroke.Thickness = 1.4
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, -12, 1, -12)
			label.Position = UDim2.fromOffset(6, 6)
			label.BackgroundTransparency = 1
			label.Text = player.DisplayName or player.Name
			label.TextColor3 = Color3.fromRGB(245, 240, 255)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 16
			label.Parent = frame
			cfg.pcldTags[player] = gui
			local function adorn(ch)
				if not ch then gui.Adornee = nil return end
				local hr = ch:WaitForChild("HumanoidRootPart", 3)
				if hr then gui.Adornee = hr end
			end
			table.insert(cfg.pcldConns, player.CharacterAdded:Connect(adorn))
			table.insert(cfg.pcldConns, player.CharacterRemoving:Connect(function() gui.Adornee = nil end))
			if player.Character then adorn(player.Character) end
		end
		if on then
			cfg.pcldOn = true
			for _, d in ipairs(Workspace:GetDescendants()) do
				if isDet(d) then addBox(d) end
			end
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer then addTag(plr) end
			end
			table.insert(cfg.pcldConns, Workspace.DescendantAdded:Connect(function(d)
				if isDet(d) then addBox(d) end
			end))
			table.insert(cfg.pcldConns, Players.PlayerAdded:Connect(addTag))
			notify("PCLD ESP", "Enabled (infinite range)")
			clickSound()
		else
			cfg.pcldOn = false
			for _, d in ipairs(CoreGui:GetDescendants()) do
				if d.Name == "PCLD_ESP_Box" or tostring(d.Name):find("PlayerNameTag_") then d:Destroy() end
			end
			for _, c in ipairs(cfg.pcldConns) do pcall(function() c:Disconnect() end) end
			cfg.pcldBoxes, cfg.pcldTags, cfg.pcldConns = {}, {}, {}
			notify("PCLD ESP", "Disabled")
		end
	end,
})

Tab:CreateButton({
	Name = "Input-Lag",
	Callback = function()
		local r = root()
		if not r then return end
		fire(GrabEvents, "SetNetworkOwner", r, r.CFrame)
		notify("Input-Lag", "Network Owner set", 2)
		clickSound()
	end,
})

Tab:CreateSection("Gucci")

local function spawnBlobFar()
	spawnToy("CreatureBlobman", CFrame.new(0, 5000000, 0), Vector3.new(0, 60, 0))
	local folder = Workspace:WaitForChild(LocalPlayer.Name .. "SpawnedInToys", 5)
	local blob = folder and folder:FindFirstChild("CreatureBlobman")
	if blob and blob:FindFirstChild("Head") then
		blob.Head.CFrame = CFrame.new(0, 50000, 0)
		blob.Head.Anchored = true
	end
	return blob
end

local function sitGucci()
	local c = character()
	if not c then return end
	local h = c:WaitForChild("Humanoid")
	local r = c:WaitForChild("HumanoidRootPart")
	cfg.gucciSafe = r.Position
	local folder = myToys()
	local blob = folder and folder:FindFirstChild("CreatureBlobman")
	local seat = blob and blob:FindFirstChild("VehicleSeat")
	if not seat then
		spawnBlobFar()
		task.wait(1)
		folder = myToys()
		blob = folder and folder:FindFirstChild("CreatureBlobman")
		seat = blob and blob:FindFirstChildWhichIsA("VehicleSeat")
	end
	if seat then
		r.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
		seat:Sit(h)
	end
	h:GetPropertyChangedSignal("Jump"):Connect(function()
		if h.Jump and h.Sit then
			cfg.gucciRestore = 15
			cfg.gucciSafe = r.Position
		end
	end)
	if cfg.gucciConn then cfg.gucciConn:Disconnect() end
	cfg.gucciConn = RunService.Heartbeat:Connect(function()
		if not r or not h then return end
		fire(CharacterEvents, "RagdollRemote", r, 0)
		if cfg.gucciRestore > 0 then
			r.CFrame = CFrame.new(cfg.gucciSafe)
			cfg.gucciRestore -= 1
		end
	end)
end

Tab:CreateToggle({
	Name = "Auto Gucci",
	Default = false,
	Callback = function(on)
		cfg.autoGucci = on
		if on then
			cfg.gucciThread = task.spawn(function()
				while cfg.autoGucci do
					local folder = myToys()
					if not (folder and folder:FindFirstChild("CreatureBlobman")) then
						if cfg.gucciConn then cfg.gucciConn:Disconnect() cfg.gucciConn = nil end
						spawnBlobFar()
						local n = 0
						repeat
							task.wait(0.2)
							n += 1
							folder = myToys()
						until (folder and folder:FindFirstChild("CreatureBlobman")) or n > 25 or not cfg.autoGucci
						if cfg.autoGucci and folder and folder:FindFirstChild("CreatureBlobman") then
							sitGucci()
						end
					end
					task.wait(0.5)
				end
			end)
			notify("Auto Gucci", "Enabled - Auto protection active")
			clickSound()
		else
			if cfg.gucciConn then cfg.gucciConn:Disconnect() cfg.gucciConn = nil end
			if cfg.gucciThread then task.cancel(cfg.gucciThread) cfg.gucciThread = nil end
			local folder = myToys()
			local blob = folder and folder:FindFirstChild("CreatureBlobman")
			if blob then blob:Destroy() end
			notify("Auto Gucci", "Disabled")
		end
	end,
})

local function gucciVehicle(toyName, offset)
	local r, h = root(), humanoid()
	if not r or not h then return end
	waitCanSpawn()
	spawnToy(toyName, r.CFrame * (offset or CFrame.new(5, 10, 20)), Vector3.zero)
	task.wait(0.3)
	local folder = myToys()
	local model = folder and folder:FindFirstChild(toyName)
	if not model then return end
	local seat = model:WaitForChild("VehicleSeat", 3)
	if not seat then return end
	seat:Sit(h)
	task.spawn(function()
		local t = tick()
		while tick() < t + 3 do
			fire(CharacterEvents, "RagdollRemote", r, 0)
			task.wait()
		end
	end)
	task.wait(0.1)
	while seat.Occupant ~= h do task.wait(0.05) end
	h:ChangeState(Enum.HumanoidStateType.Jumping)
	task.wait(0.1)
	while seat.Occupant == h do task.wait(0.05) end
	seat.CFrame = CFrame.new(0, 1e9, 0)
end

Tab:CreateButton({
	Name = "Gucci",
	Callback = function()
		pcall(function()
			local r = root()
			if not r then return end
			waitCanSpawn()
			spawnToy("CreatureBlobman", r.CFrame * CFrame.new(5, 5, 20), Vector3.zero)
			task.wait(0.3)
			gucciVehicle("CreatureBlobman", CFrame.new(5, 5, 20))
		end)
		notify("Gucci", "Activated Gucci protection")
		clickSound()
	end,
})

Tab:CreateButton({
	Name = "Gucci Train",
	Callback = function()
		pcall(function()
			local c = character()
			if not c then return end
			local h = c:WaitForChild("Humanoid")
			local r = c:WaitForChild("HumanoidRootPart")
			local tweened = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("AlwaysHereTweenedObjects")
			local train = tweened and tweened:FindFirstChild("Train")
			if not train then return end
			local seat
			for _, d in ipairs(train:GetDescendants()) do
				if d:IsA("Seat") then seat = d break end
			end
			if not seat then return end
			r.CFrame = seat.CFrame + Vector3.new(0, 2, 0)
			seat:Sit(h)
			task.spawn(function()
				local t = tick()
				while tick() < t + 1 do
					fire(CharacterEvents, "RagdollRemote", r, 0)
					task.wait()
				end
			end)
			task.wait(0.5)
			if seat.Occupant == h then h.Sit = false end
		end)
		notify("Gucci Train", "Activated train protection")
		clickSound()
	end,
})

Tab:CreateButton({
	Name = "Gucci Tractor",
	Callback = function()
		task.spawn(function() pcall(function() gucciVehicle("TractorGreen", CFrame.new(5, 10, 20)) end) end)
		notify("Gucci Tractor", "Activated tractor protection")
		clickSound()
	end,
})

Tab:CreateButton({
	Name = "Santa Sleigh Gucci",
	Callback = function()
		task.spawn(function() pcall(function() gucciVehicle("SantaSleigh", CFrame.new(5, 10, 20)) end) end)
		notify("Santa Sleigh", "Activated sleigh protection")
		clickSound()
	end,
})

Tab:CreateSection("Anti-Function")

Tab:CreateToggle({
	Name = "Anti Grab",
	Default = false,
	Callback = function(on)
		cfg.antiGrab = on
		if not on then notify("Anti Grab", "Disabled") return end
		cfg.grabParts, cfg.grabConns = {}, {}
		local function onHeldTick()
			local p = cfg.grabParts
			if not p.IsHeld or not p.IsHeld.Value or not p.Root or not p.Humanoid then return end
			fire(GrabEvents, "SetNetworkOwner", p.Root, p.Root.CFrame)
			p.Root.Anchored = true
			p.Root.Massless = true
			p.Root.CanCollide = false
			p.Root.CanQuery = false
			p.Root.AssemblyLinearVelocity = Vector3.zero
			p.Root.AssemblyAngularVelocity = Vector3.zero
			p.Root.Velocity = Vector3.zero
			p.Root.RotVelocity = Vector3.zero
			fire(GrabEvents, "Struggle")
			fire(CharacterEvents, "RagdollRemote", p.Root, 0)
			if p.origCF then p.Root.CFrame = p.origCF end
			p.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			p.Humanoid.Sit = false
			p.Humanoid.PlatformStand = false
			if p.Humanoid.MoveDirection.Magnitude > 0 then
				p.Root.CFrame = p.Root.CFrame + p.Humanoid.MoveDirection * 2
			end
		end
		local function heldChanged()
			local p = cfg.grabParts
			if not p.IsHeld then return end
			if p.IsHeld.Value then
				if p.Root then p.origCF = p.Root.CFrame end
				if not cfg.grabConns.hb then
					cfg.grabConns.hb = RunService.Heartbeat:Connect(onHeldTick)
				end
			else
				if cfg.grabConns.hb then cfg.grabConns.hb:Disconnect() cfg.grabConns.hb = nil end
				if p.Root then
					p.Root.Anchored = false
					p.Root.Massless = false
					p.Root.CanCollide = true
					p.Root.CanQuery = true
				end
				if p.Humanoid then p.Humanoid:ChangeState(Enum.HumanoidStateType.Running) end
			end
		end
		local function bind(ch)
			if not ch then return end
			cfg.grabParts.Root = ch:WaitForChild("HumanoidRootPart")
			cfg.grabParts.Humanoid = ch:WaitForChild("Humanoid")
		end
		cfg.grabParts.IsHeld = LocalPlayer:WaitForChild("IsHeld")
		if LocalPlayer.Character then bind(LocalPlayer.Character) end
		cfg.grabConns.char = LocalPlayer.CharacterAdded:Connect(bind)
		cfg.grabConns.held = cfg.grabParts.IsHeld:GetPropertyChangedSignal("Value"):Connect(heldChanged)
		heldChanged()
		notify("Anti Grab", "Enabled - Grab protection active")
		clickSound()
	end,
})

Tab:CreateToggle({
	Name = "Anti Lag",
	Default = false,
	Callback = function(on)
		cfg.antiLag = on
		local ps = LocalPlayer:FindFirstChild("PlayerScripts")
		local mv = ps and ps:FindFirstChild("CharacterAndBeamMove")
		if mv then mv.Enabled = not on end
		notify("Anti Lag", on and "Enabled - Movement script disabled" or "Disabled")
		if on then clickSound() end
	end,
})

Tab:CreateToggle({
	Name = "Anti Kick Reset",
	Default = false,
	Callback = function(on)
		if on then
			local ok, ev = pcall(function()
				return ReplicatedStorage:WaitForChild("GameCorrectionEvents"):WaitForChild("GameCorrectionsNotify")
			end)
			if not ok or not ev then
				notify("Anti Kick Reset", "Error: GameCorrectionsNotify not found!")
				return
			end
			cfg.antiKickReset = true
			cfg.kickResetConn = ev.OnClientEvent:Connect(function(kind)
				if kind == "Flying" then
					notify("AUTO RESET", "Detected flying kick, performing reset...", 5)
					clickSound()
					local h = humanoid()
					if h then h.Health = 0 end
				end
			end)
			notify("Anti Kick Reset", "Enabled - Will auto-reset on flying kick")
			clickSound()
		else
			cfg.antiKickReset = false
			if cfg.kickResetConn then cfg.kickResetConn:Disconnect() cfg.kickResetConn = nil end
			notify("Anti Kick Reset", "Disabled")
		end
	end,
})

Tab:CreateDropdown({
	Name = "Anti Kick Item",
	Items = stick_items,
	Default = "NinjaShuriken",
	Callback = function(item)
		cfg.stickItem = item
		notify("Anti Kick", "Selected: " .. item, 2)
	end,
})

local function attachSticky(model)
	if not model or not model:FindFirstChild("StickyPart") then return end
	local r = root()
	if not r then return end
	local firePart = r:FindFirstChild("FirePlayerPart")
	if not firePart then
		firePart = Instance.new("Part")
		firePart.Name = "FirePlayerPart"
		firePart.Size = Vector3.new(1, 1, 1)
		firePart.Transparency = 1
		firePart.CanCollide = false
		firePart.CanQuery = false
		firePart.Anchored = true
		firePart.Parent = r
		local w = Instance.new("Weld")
		w.Part0 = r
		w.Part1 = firePart
		w.Parent = firePart
	end
	fire(PlayerEvents, "StickyPartEvent", model.StickyPart, firePart, CFrame.new() * CFrame.Angles(0, math.rad(90), math.rad(90)))
	local sound = model:FindFirstChild("SoundPart")
	if sound then
		fire(GrabEvents, "SetNetworkOwner", sound, sound.CFrame)
		sound.Transparency = 1
	end
	model.StickyPart.Transparency = 1
	if model.PrimaryPart then model:SetPrimaryPartCFrame(r.CFrame) end
end

Tab:CreateToggle({
	Name = "Anti Kick (Stick)",
	Default = false,
	Callback = function(on)
		cfg.stickOn = on
		if on then
			cfg.stickThread = task.spawn(function()
				while cfg.stickOn do
					task.wait()
					if not character() or not humanoid() or humanoid().Health <= 0 then continue end
					local folder = myToys()
					local toy = folder and folder:FindFirstChild(cfg.stickItem)
					if not toy and waitCanSpawn() then
						local r = root()
						if r then spawnToy(cfg.stickItem, r.CFrame * CFrame.new(0, 8, 17), Vector3.zero) end
						task.wait(0.3)
						folder = myToys()
						toy = folder and folder:FindFirstChild(cfg.stickItem)
					end
					if toy then
						toy.Name = "AntiKick"
						attachSticky(toy)
					end
				end
			end)
			notify("Anti Kick", "Enabled with " .. cfg.stickItem)
			clickSound()
		else
			if cfg.stickThread then task.cancel(cfg.stickThread) cfg.stickThread = nil end
			notify("Anti Kick", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti-Banana [SIT]",
	Default = false,
	Callback = function(on)
		cfg.bananaSit = on
		if on then
			cfg.bananaSitThread = task.spawn(function()
				while cfg.bananaSit do
					local h, r = humanoid(), root()
					if h and r and h.Health ~= 0 then
						h.Sit = true
						h:ChangeState(Enum.HumanoidStateType.Running)
						if Camera then
							local look = Camera.CFrame.LookVector
							local flat = Vector3.new(look.X, 0, look.Z)
							if flat.Magnitude > 0.1 then
								r.CFrame = CFrame.new(r.Position, r.Position + flat)
							end
						end
					end
					task.wait()
				end
			end)
			notify("Anti-Banana", "SIT protection enabled")
			clickSound()
		else
			if cfg.bananaSitThread then task.cancel(cfg.bananaSitThread) cfg.bananaSitThread = nil end
			notify("Anti-Banana", "Disabled")
		end
	end,
})

local VOID_CF = CFrame.new(10000, -10000, 10000)
local VOID_VEL = Vector3.new(0, -20.34, 0)

local function yeetItem(model)
	if not model or not model.Parent then return end
	if model.Parent.Name == LocalPlayer.Name .. "SpawnedInToys" then return end
	local hold = model:FindFirstChild("HoldPart")
	local holdFn = hold and hold:FindFirstChild("HoldItemRemoteFunction")
	local dropFn = hold and hold:FindFirstChild("DropItemRemoteFunction")
	if holdFn and dropFn then
		pcall(function() holdFn:InvokeServer(model, LocalPlayer.Character) end)
		task.wait(0.05)
		pcall(function() dropFn:InvokeServer(model, VOID_CF, VOID_VEL) end)
	else
		local p = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
		if p then p.CFrame = CFrame.new(0, -10000, 0) p.Anchored = true p.Transparency = 1 end
	end
end

Tab:CreateToggle({
	Name = "Anti Banana (Eat)",
	Default = false,
	Callback = function(on)
		cfg.bananaEat = on
		if on then
			local acc = 0
			cfg.bananaScan = RunService.Heartbeat:Connect(function(dt)
				if not cfg.bananaEat then return end
				acc += dt
				if acc < 0.5 then return end
				acc = 0
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer then
						local f = Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
						if f then
							for _, ch in ipairs(f:GetChildren()) do
								if ch.Name == "FoodBanana" then yeetItem(ch) end
							end
						end
					end
				end
			end)
			notify("Anti Banana", "Eat protection enabled")
			clickSound()
		else
			if cfg.bananaScan then cfg.bananaScan:Disconnect() cfg.bananaScan = nil end
			notify("Anti Banana", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti Anti Input",
	Default = false,
	Callback = function(on)
		cfg.antiAntiInput = on
		if on then
			local acc = 0
			cfg.aaiScan = RunService.Heartbeat:Connect(function(dt)
				if not cfg.antiAntiInput then return end
				acc += dt
				if acc < 0.5 then return end
				acc = 0
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer then
						local f = Workspace:FindFirstChild(plr.Name .. "SpawnedInToys")
						if f then
							for _, ch in ipairs(f:GetChildren()) do
								if table.find(lag_items, ch.Name) then yeetItem(ch) end
							end
						end
					end
				end
			end)
			notify("Anti Anti Input", "Enabled - Countering AntiInputLag items")
			clickSound()
		else
			if cfg.aaiScan then cfg.aaiScan:Disconnect() cfg.aaiScan = nil end
			notify("Anti Anti Input", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti Barrier",
	Default = false,
	Callback = function(on)
		if on then
			local plots = Workspace:FindFirstChild("Plots")
			if not plots then notify("Anti Barrier", "Error: Plots folder not found!") return end
			cfg.barrierOn = true
			cfg.barrierOrig = {}
			task.spawn(function()
				while cfg.barrierOn do
					for _, plot in ipairs(plots:GetChildren()) do
						local bar = plot:FindFirstChild("Barrier")
						if bar then
							for _, p in ipairs(bar:GetChildren()) do
								if p:IsA("BasePart") and p.Name == "PlotBarrier" then
									if cfg.barrierOrig[p] == nil then cfg.barrierOrig[p] = p.CanCollide end
									p.CanCollide = false
								end
							end
						end
					end
					task.wait(0.5)
				end
			end)
			notify("Anti Barrier", "Enabled - Barrier collision disabled")
			clickSound()
		else
			cfg.barrierOn = false
			for p, st in pairs(cfg.barrierOrig) do
				if p and p.Parent then p.CanCollide = st end
			end
			cfg.barrierOrig = {}
			notify("Anti Barrier", "Disabled - Barrier collision restored")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti Ragdoll (for blob)",
	Default = false,
	Callback = function(on)
		if on then
			cfg.antiRagdoll = true
			cfg.ragdollSit = false
			local function hook(ch)
				local h = ch:FindFirstChild("Humanoid")
				local r = ch:FindFirstChild("HumanoidRootPart")
				if not h or not r then return end
				cfg.ragdollConns.seat = h:GetPropertyChangedSignal("SeatPart"):Connect(function()
					if h.SeatPart and h.SeatPart.Parent and h.SeatPart.Parent.Name == "CreatureBlobman" and not cfg.ragdollSit then
						cfg.ragdollSit = true
						local seat = h.SeatPart
						fire(CharacterEvents, "RagdollRemote", r, 0)
						task.wait(0.4)
						if h then
							h.Sit = false
							if seat then seat:Sit(h) end
							task.delay(0.25, function()
								fire(CharacterEvents, "RagdollRemote", r, 0)
								cfg.ragdollSit = false
							end)
						end
					end
				end)
			end
			if LocalPlayer.Character then hook(LocalPlayer.Character) end
			cfg.ragdollConns.char = LocalPlayer.CharacterAdded:Connect(function(ch)
				task.wait(1)
				if cfg.antiRagdoll then hook(ch) end
			end)
			notify("Anti Ragdoll", "Enabled - Blob protection active")
			clickSound()
		else
			cfg.antiRagdoll = false
			for _, c in pairs(cfg.ragdollConns) do if c then c:Disconnect() end end
			cfg.ragdollConns = {}
			notify("Anti Ragdoll", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti Blob",
	Default = false,
	Callback = function(on)
		cfg.antiBlob = on
		notify("Anti Blob", on and "Enabled - Grabbing players off enemy blobs" or "Disabled")
		if on then clickSound() end
	end,
})

local function disableHands(blob)
	local mine = myToys()
	if mine and blob:IsDescendantOf(mine) then return end
	local right = blob:FindFirstChild("RightDetector") or blob:WaitForChild("RightDetector", 3)
	local left = blob:FindFirstChild("LeftDetector") or blob:WaitForChild("LeftDetector", 3)
	if right then
		if right:FindFirstChild("RightAlignOrientation") then right.RightAlignOrientation.Enabled = false end
		if right:FindFirstChild("RightWeld") then right.RightWeld.Enabled = false end
	end
	if left then
		if left:FindFirstChild("LeftAlignOrientation") then left.LeftAlignOrientation.Enabled = false end
		if left:FindFirstChild("LeftWeld") then left.LeftWeld.Enabled = false end
	end
end

Tab:CreateToggle({
	Name = "Anti-blob (Hand-visal)",
	Default = false,
	Callback = function(on)
		if on then
			cfg.antiBlobHand = true
			for _, d in ipairs(Workspace:GetDescendants()) do
				if d.Name == "CreatureBlobman" then pcall(disableHands, d) end
			end
			cfg.blobHandConn = Workspace.DescendantAdded:Connect(function(d)
				if cfg.antiBlobHand and d.Name == "CreatureBlobman" then
					task.wait(0.1)
					pcall(disableHands, d)
				end
			end)
			notify("Anti-blob Hand", "Enabled - Disabling enemy blob grabs")
			clickSound()
		else
			cfg.antiBlobHand = false
			if cfg.blobHandConn then cfg.blobHandConn:Disconnect() cfg.blobHandConn = nil end
			notify("Anti-blob Hand", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti Burn",
	Default = false,
	Callback = function(on)
		if on then
			local plots = Workspace:FindFirstChild("Plots")
			local plot1 = plots and plots:FindFirstChild("Plot1")
			local bf = plot1 and plot1:FindFirstChild("Barrier")
			local barrier = bf and bf:FindFirstChild("PlotBarrier")
			if not barrier then notify("Anti Burn", "Error: Plot1 barrier not found") return end
			if not character() then notify("Anti Burn", "Error: Character not found") return end
			cfg.antiBurn = true
			cfg.burnBarrier = barrier
			local function onFire()
				local h, r = humanoid(), root()
				if not h or not r then return end
				local fd = h:FindFirstChild("FireDebounce")
				if fd and fd.Value == true then
					task.spawn(function()
						barrier.CFrame = r.CFrame
						task.wait(1)
						if cfg.antiBurn then fd.Value = false end
					end)
				end
			end
			local h = humanoid()
			if h and h:FindFirstChild("FireDebounce") then
				cfg.burnC1 = h.FireDebounce.Changed:Connect(onFire)
			end
			cfg.burnC2 = LocalPlayer.CharacterAdded:Connect(function(ch)
				if not cfg.antiBurn then return end
				if cfg.burnC1 then cfg.burnC1:Disconnect() end
				task.wait(0.5)
				local nh = ch:FindFirstChild("Humanoid")
				if nh and nh:FindFirstChild("FireDebounce") then
					cfg.burnC1 = nh.FireDebounce.Changed:Connect(onFire)
				end
			end)
			notify("Anti Burn", "Enabled - Fire protection active")
			clickSound()
		else
			cfg.antiBurn = false
			if cfg.burnC1 then cfg.burnC1:Disconnect() end
			if cfg.burnC2 then cfg.burnC2:Disconnect() end
			notify("Anti Burn", "Disabled")
		end
	end,
})

Tab:CreateDropdown({
	Name = "Anti-Input Lag Item",
	Items = lag_items,
	Default = "FoodHamburger",
	Callback = function(item)
		cfg.lagItem = item
		notify("Anti-Input Lag", "Selected: " .. item, 2)
	end,
})

Tab:CreateToggle({
	Name = "Anti-Input Lag",
	Default = false,
	Callback = function(on)
		cfg.inputLagOn = on
		if on then
			cfg.inputLagThread = task.spawn(function()
				while cfg.inputLagOn do
					local c, r, h = character(), root(), humanoid()
					if not c or not r or not h or h.Health <= 0 then
						task.wait(0.5)
					else
						local folder = myToys()
						if not folder then
							task.wait(0.5)
						else
							local item = folder:FindFirstChild(cfg.lagItem)
							if not item and waitCanSpawn() then
								spawnToy(cfg.lagItem, r.CFrame * CFrame.new(0, 8, 17), Vector3.zero)
								for _ = 1, 20 do
									item = folder:FindFirstChild(cfg.lagItem)
									if item then break end
									task.wait(0.007)
								end
							end
							if item then
								local hold = item:FindFirstChild("HoldPart")
								local holdFn = hold and hold:FindFirstChild("HoldItemRemoteFunction")
								local dropFn = hold and hold:FindFirstChild("DropItemRemoteFunction")
								if holdFn and dropFn then
									pcall(function() holdFn:InvokeServer(item, c) end)
									task.wait(0.05)
									pcall(function() dropFn:InvokeServer(item, r.CFrame * CFrame.new(0, 199, 0), Vector3.zero) end)
									task.wait(0.035)
								else
									task.wait()
								end
							else
								task.wait()
							end
						end
					end
				end
			end)
			notify("Anti-Input Lag", "Enabled with " .. cfg.lagItem)
			clickSound()
		else
			if cfg.inputLagThread then task.cancel(cfg.inputLagThread) cfg.inputLagThread = nil end
			notify("Anti-Input Lag", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti-Void",
	Default = false,
	Callback = function(on)
		if on then
			cfg.voidOn = true
			cfg.voidHeight = Workspace.FallenPartsDestroyHeight
			Workspace.FallenPartsDestroyHeight = -1000
			cfg.voidThread = task.spawn(function()
				while cfg.voidOn do
					local c, r = character(), root()
					if c and r and r.Position.Y < -800 then
						c:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
						notify("Anti-Void", "Player saved from void!", 3)
						clickSound()
					end
					task.wait(0.1)
				end
			end)
			notify("Anti-Void", "Enabled - Void protection active")
			clickSound()
		else
			cfg.voidOn = false
			if cfg.voidThread then task.cancel(cfg.voidThread) cfg.voidThread = nil end
			Workspace.FallenPartsDestroyHeight = cfg.voidHeight
			notify("Anti-Void", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti Paint",
	Default = false,
	Callback = function(on)
		if on then
			cfg.antiPaint = true
			cfg.paintConn = Workspace.DescendantAdded:Connect(function(d)
				if not cfg.antiPaint then return end
				if d.Name == "PaintPlayerPart" or d.Name == "FirePlayerPart" then
					local p = d.Parent
					if p and paint_toys[p.Name] then
						task.wait(0.1)
						if d and d.Parent then d:Destroy() end
					end
				end
			end)
			notify("Anti Paint", "Enabled - Paint and fire protection")
			clickSound()
		else
			cfg.antiPaint = false
			if cfg.paintConn then cfg.paintConn:Disconnect() cfg.paintConn = nil end
			notify("Anti Paint", "Disabled")
		end
	end,
})

local function findBomb()
	for _, folder in ipairs({ GameEvents, CharacterEvents, PlayerEvents, ReplicatedStorage }) do
		if folder then
			for _, n in ipairs({ "BombEvent", "ExplosionEvent", "BombExplosion" }) do
				local ev = folder:FindFirstChild(n)
				if ev and ev:IsA("RemoteEvent") then return ev end
			end
		end
	end
end

Tab:CreateToggle({
	Name = "Anti Explode",
	Default = false,
	Callback = function(on)
		if on then
			local ev = findBomb()
			if not ev then notify("Anti Explode", "Error: Bomb event not found!", 3) return end
			cfg.antiExplode = true
			cfg.explodeConn = ev.OnClientEvent:Connect(function(info, pos)
				if not cfg.antiExplode then return end
				local c, r, h = character(), root(), humanoid()
				if not c or not r or not h or typeof(pos) ~= "Vector3" then return end
				local dist = (pos - r.Position).Magnitude
				local radius = (typeof(info) == "table" and info.Radius) or 20
				if dist < radius + 10 then
					r.Anchored = true
					task.wait(0.05)
					h:ChangeState(Enum.HumanoidStateType.Running)
					r.Anchored = false
					for i = 1, 4 do
						local limb = c:FindFirstChild(limbs[i])
						local rag = limb and limb:FindFirstChild("RagdollLimbPart")
						if rag then rag.CanCollide = false end
					end
					r.AssemblyLinearVelocity = Vector3.zero
					r.AssemblyAngularVelocity = Vector3.zero
					task.delay(1.5, function()
						if c and c.Parent then
							for i = 1, 4 do
								local limb = c:FindFirstChild(limbs[i])
								local rag = limb and limb:FindFirstChild("RagdollLimbPart")
								if rag then rag.CanCollide = true end
							end
						end
					end)
				end
			end)
			notify("Anti Explode", "Enabled - Explosion protection active", 3)
			clickSound()
		else
			cfg.antiExplode = false
			if cfg.explodeConn then cfg.explodeConn:Disconnect() cfg.explodeConn = nil end
			notify("Anti Explode", "Disabled", 3)
		end
	end,
})

Tab:CreateSection("Other")

Tab:CreateToggle({
	Name = "Auto Sit Blob",
	Default = false,
	Callback = function(on)
		cfg.autoSit = on
		if on then
			cfg.autoSitThread = task.spawn(function()
				while cfg.autoSit do
					local h, r = humanoid(), root()
					if h and r and not h.Sit then
						local folder = myToys()
						local blob = folder and folder:FindFirstChild("CreatureBlobman")
						if not blob and waitCanSpawn(3) then
							spawnToy("CreatureBlobman", r.CFrame * CFrame.new(0, 0, 5), Vector3.zero)
							task.wait()
							folder = myToys()
							blob = folder and folder:FindFirstChild("CreatureBlobman")
						end
						if blob then
							local seat = blob:FindFirstChild("VehicleSeat")
							if seat then
								r.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
								task.wait()
								seat:Sit(h)
							end
						end
					end
					task.wait()
				end
			end)
			notify("Auto Sit Blob", "Enabled - Auto sitting on blob")
			clickSound()
		else
			if cfg.autoSitThread then task.cancel(cfg.autoSitThread) cfg.autoSitThread = nil end
			notify("Auto Sit Blob", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Anti-Invisible Players",
	Default = false,
	Callback = function(on)
		cfg.invisible = on
		if on then
			cfg.invisThread = task.spawn(function()
				while cfg.invisible do
					for _, plr in ipairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer and plr.Character then
							for _, p in ipairs(plr.Character:GetChildren()) do
								if p:IsA("BasePart") and p.Massless then p.Massless = false end
							end
						end
					end
					task.wait(3)
				end
			end)
			notify("Anti-Invisible", "Enabled - Making players/models visible")
			clickSound()
		else
			if cfg.invisThread then task.cancel(cfg.invisThread) cfg.invisThread = nil end
			notify("Anti-Invisible", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Self Grab (Blob)",
	Default = false,
	Callback = function(on)
		cfg.selfGrab = on
		if on then
			cfg.selfGrabThread = task.spawn(function()
				local held = LocalPlayer:WaitForChild("IsHeld")
				local function getBlob()
					if cfg.selfBlob and cfg.selfBlob.Parent then return cfg.selfBlob end
					local folder = myToys()
					local b = folder and folder:FindFirstChild("CreatureBlobman")
					if b then cfg.selfBlob = b return b end
					if waitCanSpawn(1) then
						spawnToy("CreatureBlobman", CFrame.new(), Vector3.zero)
						task.wait(0.4)
						folder = myToys()
						b = folder and folder:FindFirstChild("CreatureBlobman")
						cfg.selfBlob = b
					end
					return cfg.selfBlob
				end
				getBlob()
				while cfg.selfGrab do
					local r, h = root(), humanoid()
					local blob = getBlob()
					if r and h and blob then
						if held.Value then
							local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
							local right = blob:FindFirstChild("RightDetector")
							local grab = script and script:FindFirstChild("CreatureGrab")
							local weld = right and right:FindFirstChild("RightWeld")
							if grab then pcall(function() grab:FireServer(r, weld) end) end
							local seat = blob:FindFirstChild("VehicleSeat")
							if seat then
								h.Sit = false
								seat:Sit(h)
							end
						end
					end
					task.wait()
				end
				if cfg.selfBlob then destroyToy(cfg.selfBlob) end
			end)
			notify("Self Grab", "Enabled - Self grab with blob")
			clickSound()
		else
			if cfg.selfGrabThread then task.cancel(cfg.selfGrabThread) cfg.selfGrabThread = nil end
			if cfg.selfBlob then destroyToy(cfg.selfBlob) end
			cfg.selfBlob = nil
			notify("Self Grab", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Noclip Obj players",
	Default = false,
	Callback = function(on)
		if on then
			cfg.noclip = true
			local function strip(m)
				if not m or not m:IsA("Model") then return end
				if table.find(lag_items, m.Name) then return end
				for _, p in ipairs(m:GetDescendants()) do
					if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
				end
			end
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer then
					local function apply(ch)
						if not ch then return end
						for _, p in ipairs(ch:GetChildren()) do
							if p:IsA("BasePart") then p.CanCollide = false end
						end
					end
					if plr.Character then apply(plr.Character) end
					plr.CharacterAdded:Connect(function(ch) if cfg.noclip then apply(ch) end end)
				end
			end
			notify("Noclip", "Enabled - Noclip through players/items")
			clickSound()
		else
			cfg.noclip = false
			notify("Noclip", "Disabled")
		end
	end,
})

Tab:CreateToggle({
	Name = "Soften Packet Lag",
	Default = false,
	Callback = function(on)
		cfg.packetOn = on
		if on then
			pcall(function()
				if hookmetamethod then
					local old
					old = hookmetamethod(game, "__namecall", function(self, ...)
						local args = { ... }
						if cfg.packetOn and getnamecallmethod() == "FireServer" and self:IsA("RemoteEvent") then
							local total = 0
							for _, a in ipairs(args) do
								if type(a) == "string" then
									total += #a
									if #a > 1000 then
										cfg.packetBlocked += 1
										return nil
									end
								end
							end
							if total > 2000 then
								cfg.packetBlocked += 1
								return nil
							end
						end
						return old(self, ...)
					end)
				end
			end)
			notify("Soften Packet Lag", "Enabled - Blocking spam packets", 3)
			clickSound()
		else
			notify("Soften Packet Lag", "Disabled", 3)
		end
	end,
})

Tab:CreateButton({
	Name = "Delete Legs",
	Callback = function()
		local c, r = character(), root()
		if not c or not r or not c:FindFirstChild("Left Leg") or not c:FindFirstChild("Right Leg") then
			notify("Delete Legs", "Error: Missing body parts", 3)
			return
		end
		local oldH = Workspace.FallenPartsDestroyHeight
		Workspace.FallenPartsDestroyHeight = -100
		notify("Delete Legs", "Deleting legs...", 3)
		clickSound()
		fire(CharacterEvents, "RagdollRemote", r, 2)
		task.wait(0.5)
		c["Right Leg"].CFrame = CFrame.new(0, -10000, 0)
		c["Left Leg"].CFrame = CFrame.new(0, -10000, 0)
		task.wait(0.3)
		if c:FindFirstChild("Torso") then
			c.Torso.CFrame = CFrame.new(0, -9970, 0)
		end
		task.wait(0.5)
		Workspace.FallenPartsDestroyHeight = oldH
		if not c:FindFirstChild("Left Leg") and not c:FindFirstChild("Right Leg") then
			notify("Delete Legs", "Legs successfully deleted!", 5)
		else
			notify("Delete Legs", "Warning: Legs not fully deleted", 3)
		end
	end,
})

Tab:CreateToggle({
	Name = "Kick Notify",
	Default = false,
	Callback = function(on)
		if on then
			cfg.kickNotifyOn = true
			local gui = Instance.new("ScreenGui")
			gui.Name = "KickNotifyUI"
			gui.Parent = CoreGui
			cfg.kickGui = gui
			cfg.kickCards, cfg.kickSeen = {}, {}
			local function card(name, display)
				if cfg.kickSeen[name] and tick() - cfg.kickSeen[name] < 30 then return end
				cfg.kickSeen[name] = tick()
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(0, 300, 0, 80)
				frame.Position = UDim2.new(1, -320, 0, 80 + #cfg.kickCards * 90)
				frame.BackgroundColor3 = Color3.fromRGB(40, 25, 60)
				frame.BackgroundTransparency = 0.1
				frame.BorderSizePixel = 0
				frame.Parent = gui
				Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
				local st = Instance.new("UIStroke", frame)
				st.Color = Color3.fromRGB(180, 150, 255)
				st.Thickness = 2
				local function lab(y, text, color, size, font)
					local t = Instance.new("TextLabel")
					t.Size = UDim2.new(1, -20, 0, 20)
					t.Position = UDim2.fromOffset(10, y)
					t.BackgroundTransparency = 1
					t.Text = text
					t.TextColor3 = color
					t.Font = font
					t.TextSize = size
					t.TextXAlignment = Enum.TextXAlignment.Left
					t.Parent = frame
				end
				lab(8, "KICK DETECTED", Color3.fromRGB(255, 100, 100), 16, Enum.Font.GothamBold)
				lab(30, display .. " (" .. name .. ")", Color3.fromRGB(255, 255, 255), 14, Enum.Font.GothamSemibold)
				lab(54, "went to heaven", Color3.fromRGB(200, 200, 200), 12, Enum.Font.Gotham)
				table.insert(cfg.kickCards, frame)
				kickSound()
				task.delay(4.7, function()
					if frame and frame.Parent then
						TweenService:Create(frame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
						task.wait(0.5)
						frame:Destroy()
					end
				end)
			end
			cfg.kickConn = Workspace.ChildAdded:Connect(function(ch)
				if ch.Name == "BlackHoleKick" or ch.Name == "BlackHole" then
					ch.Name = "BlackHole_Detected_" .. tick()
					local before = {}
					for _, plr in ipairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer then before[plr.Name] = plr.DisplayName end
					end
					task.wait(3.25)
					local after = {}
					for _, plr in ipairs(Players:GetPlayers()) do after[plr.Name] = true end
					for name, display in pairs(before) do
						if not after[name] then card(name, display) end
					end
				end
			end)
			notify("Kick Notify", "Enabled - monitoring for kicks")
			clickSound()
		else
			cfg.kickNotifyOn = false
			if cfg.kickConn then cfg.kickConn:Disconnect() end
			if cfg.kickGui then cfg.kickGui:Destroy() end
			cfg.kickGui, cfg.kickCards = nil, {}
			notify("Kick Notify", "Disabled")
		end
	end,
})

RunService.Heartbeat:Connect(function()
	if cfg.antiBlob then
		local me = root()
		if me then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character then
					local seat = plr.Character:FindFirstChildWhichIsA("Seat", true)
					if seat and seat.Parent and seat.Parent.Name == "CreatureBlobman" then
						local oroot = plr.Character:FindFirstChild("HumanoidRootPart")
						if oroot then
							fire(GrabEvents, "SetNetworkOwner", oroot, oroot.CFrame)
							fire(CharacterEvents, "RagdollRemote", oroot, 0)
						end
					end
				end
			end
		end
	end
end)
task.wait(1)
notify("AMETHYST DEFENSE", "Loaded successfully!", 5)
clickSound()