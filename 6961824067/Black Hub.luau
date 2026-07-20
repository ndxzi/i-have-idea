local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local apiUrl = "https://little-cell-5b16.farkzzin.workers.dev";
local keyLinkUrl = "https://link-hub.net/3919991/3FDnAvChLwBh";
local keyFileName = "BlackHub_" .. tostring(LocalPlayer.UserId) .. ".dat" ;
local userIdStr = tostring(LocalPlayer.UserId);
local modalButton = nil;
local function ShowModal()
	local screenGui = LocalPlayer.PlayerGui:FindFirstChild("MyPersistentScreenGui");
	if not screenGui then
		screenGui = Instance.new("ScreenGui");
		screenGui.Name = "MyPersistentScreenGui";
		screenGui.ResetOnSpawn = false;
		screenGui.Parent = LocalPlayer.PlayerGui;
	end
	if not modalButton then
		modalButton = Instance.new("TextButton");
		modalButton.Size = UDim2.new(0, 200, 0, 50);
		modalButton.Position = UDim2.new(0.5, -100, 0.5, -25);
		modalButton.BackgroundTransparency = 1;
		modalButton.Text = "";
		modalButton.Modal = true;
		modalButton.Parent = screenGui;
	end
	UserInputService.MouseIconEnabled = true;
end
local function HideModal()
	if modalButton then
		modalButton:Destroy();
		modalButton = nil;
	end
	UserInputService.MouseIconEnabled = false;
end
local function LoadSavedKey()
	local readSuccess, readData = pcall(readfile, keyFileName);
	if (not readSuccess or not readData or (readData == "")) then
		return nil;
	end
	local savedKey, savedExpiry = readData:match("^(.+)|(%d+)$");
	if (savedKey and savedExpiry and (tonumber(savedExpiry) > os.time())) then
		return savedKey, tonumber(savedExpiry);
	end
	return nil;
end
local function SaveKey(keyArg, expiryArg)
	pcall(writefile, keyFileName, keyArg .. "|" .. tostring(expiryArg));
end
local function ValidateKey(keyToValidate)
	local validateSuccess, validateResponse = pcall(function()
		return game:HttpGet(apiUrl .. "/validate?key=" .. keyToValidate .. "&userid=" .. userIdStr);
	end);
	if not validateSuccess then
		return false, "erro de conexÃ£o";
	end
	local jsonSuccess, jsonData = pcall(function()
		return HttpService:JSONDecode(validateResponse);
	end);
	if not jsonSuccess then
		return false, "resposta invÃ¡lida";
	end
	return jsonData.valid == true , jsonData.reason or "" , jsonData.expiresAt;
end
local function RedeemToken(tokenArg)
	local redeemSuccess, redeemResponse = pcall(function()
		return game:HttpGet(apiUrl .. "/redeem?token=" .. tokenArg .. "&userid=" .. userIdStr);
	end);
	if not redeemSuccess then
		return false, "erro de conexÃ£o";
	end
	local redeemJsonSuccess, redeemJsonData = pcall(function()
		return HttpService:JSONDecode(redeemResponse);
	end);
	if not redeemJsonSuccess then
		return false, "resposta invÃ¡lida";
	end
	if redeemJsonData.key then
		return true, redeemJsonData.key, redeemJsonData.expiresAt;
	end
	return false, redeemJsonData.error or "erro desconhecido" ;
end
local function CreateKeyUI()
	if PlayerGui:FindFirstChild("BlackHubKeyUI") then
		PlayerGui.BlackHubKeyUI:Destroy();
	end
	local keyScreenGui = Instance.new("ScreenGui");
	keyScreenGui.Name = "BlackHubKeyUI";
	keyScreenGui.ResetOnSpawn = false;
	keyScreenGui.Parent = PlayerGui;
	local bgFrame = Instance.new("Frame");
	bgFrame.Size = UDim2.new(1, 0, 1, 0);
	bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	bgFrame.BackgroundTransparency = 0.45;
	bgFrame.BorderSizePixel = 0;
	bgFrame.Parent = keyScreenGui;
	local mainFrame = Instance.new("Frame");
	mainFrame.Size = UDim2.new(0, 440, 0, 320);
	mainFrame.Position = UDim2.new(0.5, -220, 0.5, -160);
	mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20);
	mainFrame.BorderSizePixel = 0;
	mainFrame.ZIndex = 2;
	mainFrame.Parent = keyScreenGui;
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12);
	local titleBar = Instance.new("Frame");
	titleBar.Size = UDim2.new(1, 0, 0, 50);
	titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30);
	titleBar.BorderSizePixel = 0;
	titleBar.ZIndex = 3;
	titleBar.Parent = mainFrame;
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12);
	local bottomCorner = Instance.new("Frame");
	bottomCorner.Size = UDim2.new(1, 0, 0, 12);
	bottomCorner.Position = UDim2.new(0, 0, 1, -12);
	bottomCorner.BackgroundColor3 = Color3.fromRGB(20, 20, 30);
	bottomCorner.BorderSizePixel = 0;
	bottomCorner.ZIndex = 3;
	bottomCorner.Parent = titleBar;
	local titleLabel = Instance.new("TextLabel");
	titleLabel.Size = UDim2.new(1, 0, 1, 0);
	titleLabel.BackgroundTransparency = 1;
	titleLabel.Text = "Black Hub â€” Key System";
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
	titleLabel.TextSize = 15;
	titleLabel.Font = Enum.Font.GothamBold;
	titleLabel.ZIndex = 4;
	titleLabel.Parent = titleBar;
	local instructionLabel = Instance.new("TextLabel");
	instructionLabel.Size = UDim2.new(1, -40, 0, 18);
	instructionLabel.Position = UDim2.new(0, 20, 0, 60);
	instructionLabel.BackgroundTransparency = 1;
	instructionLabel.Text = "1. Clique Pegar Key  2. Complete o link  3. Cole o token abaixo";
	instructionLabel.TextColor3 = Color3.fromRGB(150, 150, 170);
	instructionLabel.TextSize = 11;
	instructionLabel.Font = Enum.Font.Gotham;
	instructionLabel.ZIndex = 3;
	instructionLabel.Parent = mainFrame;
	local inputFrame = Instance.new("Frame");
	inputFrame.Size = UDim2.new(1, -40, 0, 40);
	inputFrame.Position = UDim2.new(0, 20, 0, 88);
	inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40);
	inputFrame.BorderSizePixel = 0;
	inputFrame.ZIndex = 3;
	inputFrame.Parent = mainFrame;
	Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 8);
	local tokenTextBox = Instance.new("TextBox");
	tokenTextBox.Size = UDim2.new(1, -20, 1, 0);
	tokenTextBox.Position = UDim2.new(0, 10, 0, 0);
	tokenTextBox.BackgroundTransparency = 1;
	tokenTextBox.PlaceholderText = "Cole o token aqui...";
	tokenTextBox.PlaceholderColor3 = Color3.fromRGB(70, 70, 90);
	tokenTextBox.Text = "";
	tokenTextBox.TextColor3 = Color3.fromRGB(255, 200, 50);
	tokenTextBox.TextSize = 13;
	tokenTextBox.Font = Enum.Font.Code;
	tokenTextBox.ZIndex = 4;
	tokenTextBox.ClearTextOnFocus = false;
	tokenTextBox.Parent = inputFrame;
	local statusLabel = Instance.new("TextLabel");
	statusLabel.Size = UDim2.new(1, -40, 0, 20);
	statusLabel.Position = UDim2.new(0, 20, 0, 136);
	statusLabel.BackgroundTransparency = 1;
	statusLabel.Text = "";
	statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80);
	statusLabel.TextSize = 12;
	statusLabel.Font = Enum.Font.Gotham;
	statusLabel.ZIndex = 3;
	statusLabel.Parent = mainFrame;
	local confirmButton = Instance.new("TextButton");
	confirmButton.Size = UDim2.new(0, 180, 0, 42);
	confirmButton.Position = UDim2.new(0, 20, 0, 164);
	confirmButton.BackgroundColor3 = Color3.fromRGB(50, 130, 50);
	confirmButton.Text = "âœ” Confirmar Token";
	confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255);
	confirmButton.TextSize = 14;
	confirmButton.Font = Enum.Font.GothamBold;
	confirmButton.BorderSizePixel = 0;
	confirmButton.ZIndex = 3;
	confirmButton.Parent = mainFrame;
	Instance.new("UICorner", confirmButton).CornerRadius = UDim.new(0, 8);
	local getKeyButton = Instance.new("TextButton");
	getKeyButton.Size = UDim2.new(0, 180, 0, 42);
	getKeyButton.Position = UDim2.new(0, 240, 0, 164);
	getKeyButton.BackgroundColor3 = Color3.fromRGB(220, 120, 20);
	getKeyButton.Text = "ðŸ”‘ Pegar Key";
	getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255);
	getKeyButton.TextSize = 14;
	getKeyButton.Font = Enum.Font.GothamBold;
	getKeyButton.BorderSizePixel = 0;
	getKeyButton.ZIndex = 3;
	getKeyButton.Parent = mainFrame;
	Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 8);
	local infoLabel = Instance.new("TextLabel");
	infoLabel.Size = UDim2.new(1, -40, 0, 18);
	infoLabel.Position = UDim2.new(0, 20, 0, 218);
	infoLabel.BackgroundTransparency = 1;
	infoLabel.Text = "â± Token vÃ¡lido por 10 min | Key dura 24h por conta";
	infoLabel.TextColor3 = Color3.fromRGB(80, 80, 110);
	infoLabel.TextSize = 11;
	infoLabel.Font = Enum.Font.Gotham;
	infoLabel.ZIndex = 3;
	infoLabel.Parent = mainFrame;
	getKeyButton.MouseButton1Click:Connect(function()
		setclipboard(keyLinkUrl);
		statusLabel.Text = "âœ… Link copiado! Cole no navegador.";
		statusLabel.TextColor3 = Color3.fromRGB(80, 220, 80);
	end);
	ShowModal();
	return keyScreenGui, tokenTextBox, confirmButton, statusLabel;
end
local keyValidated = false;
local function HandleKeySystem()
	local savedKeyData, savedExpiryData = LoadSavedKey();
	if savedKeyData then
		local validateResult = ValidateKey(savedKeyData);
		if validateResult then
			keyValidated = true;
			return true;
		end
	end
	local keyUI, tokenBox, confirmBtn, statusLbl = CreateKeyUI();
	local keyDone, keySuccess = false, false;
	confirmBtn.MouseButton1Click:Connect(function()
		if keyDone then
			return;
		end
		local trimmedToken = tokenBox.Text:gsub("%s+", "");
		if (trimmedToken == "") then
			statusLbl.Text = "âŒ Cole o token primeiro!";
			statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80);
			return;
		end
		statusLbl.Text = "â³ Resgatando token...";
		statusLbl.TextColor3 = Color3.fromRGB(200, 200, 80);
		confirmBtn.Active = false;
		task.spawn(function()
			local redeemSuccess2, newKey, newExpiry = RedeemToken(trimmedToken);
			if redeemSuccess2 then
				local expirySeconds = math.floor((newExpiry or ((os.time() * 1000) + 86400000)) / 1000);
				SaveKey(newKey, expirySeconds);
				statusLbl.Text = "âœ… Key gerada! Carregando hub...";
				statusLbl.TextColor3 = Color3.fromRGB(80, 220, 80);
				confirmBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 30);
				task.wait(1.5);
				keyUI:Destroy();
				HideModal();
				keyDone = true;
				keySuccess = true;
			else
				statusLbl.Text = "âŒ Token invÃ¡lido ou expirado!";
				statusLbl.TextColor3 = Color3.fromRGB(255, 80, 80);
				confirmBtn.Active = true;
				tokenBox.Text = "";
			end
		end);
	end);
	while not keyDone do
		task.wait(0.1);
	end
	return keySuccess;
end
local keyResult = HandleKeySystem();
if not keyResult then
	return;
end
local owners = {
	LUKINHAS123257 = true,
	papafigorito = true,
	XWZ_black1 = true
};
local function IsOwner(playerName)
	return owners[playerName] == true ;
end
local language = nil;
if (game:GetService("LocalizationService").SystemLocaleId == "pt-br") then
	language = "pt-br";
else
	language = "en";
end
local hubTitle = "ã€Œ Black Hub ã€";
local OrionLib = _G.OrionLib;
local workspace = game:GetService("Workspace");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local spawnedInToys = workspace[LocalPlayer.Name .. "SpawnedInToys" ];
local connections = {};
local setNetworkOwnerRemote = ReplicatedStorage.GrabEvents.SetNetworkOwner;
local spawnToyRemote = ReplicatedStorage.MenuToys.SpawnToyRemoteFunction;
local struggleRemote = ReplicatedStorage.CharacterEvents.Struggle;
local ragdollRemote = ReplicatedStorage.CharacterEvents.RagdollRemote;
local stickyPartEvent = ReplicatedStorage.PlayerEvents.StickyPartEvent;
local gameCorrectionsNotify = ReplicatedStorage.GameCorrectionEvents.GameCorrectionsNotify;
local function WaitForChildCustom(parentObj, childName, timeout)
	return parentObj:FindFirstChild(childName) or parentObj:WaitForChild(childName, timeout) ;
end
local function DisconnectConnection(keyPattern)
	for connKey, connObj in connections do
		if connKey:find(keyPattern) then
			connObj:Disconnect();
			connObj = nil;
		end
	end
end
local function FindMyPlot()
	for plotIdx, plotObj in pairs(workspace.Plots:GetChildren()) do
		local plotSign = plotObj:FindFirstChild("PlotSign");
		local plotOwners = plotSign and plotSign:FindFirstChild("ThisPlotsOwners") ;
		if plotOwners then
			for ownerIdx, ownerObj in pairs(plotOwners:GetChildren()) do
				if (ownerObj.Value == LocalPlayer.Name) then
					local plotItems = workspace.PlotItems:FindFirstChild(plotObj.Name);
					if plotItems then
						return plotItems;
					end
				end
			end
		end
	end
	return nil;
end
local function SpawnToyAndWait(toyName, cframeArg, extraArg)
	local inPlot = LocalPlayer.InPlot;
	local inOwnedPlot = LocalPlayer.InOwnedPlot;
	local canSpawnToy = LocalPlayer.CanSpawnToy;
	while inPlot.Value and not inOwnedPlot.Value and not canSpawnToy.Value do
		task.wait();
	end
	if (typeof(extraArg) == "string") then
		if (string.lower(extraArg) == "headup") then
			task.spawn(function()
				spawnToyRemote:InvokeServer(toyName, CFrame.new(cframeArg.Position + Vector3.new(0, 1, 0), cframeArg.Position) * CFrame.Angles(math.pi, 0, 0), Vector3.new(0, 0, 0));
			end);
		end
	elseif extraArg then
		task.spawn(function()
			spawnToyRemote:InvokeServer(toyName, cframeArg, extraArg);
		end);
	else
		task.spawn(function()
			spawnToyRemote:InvokeServer(toyName, cframeArg, Vector3.new(0, 0, 0));
		end);
	end
	local toyModel, isInPlot;
	if inOwnedPlot.Value then
		local plotItemsFolder = FindMyPlot();
		if plotItemsFolder then
			plotItemsFolder.ChildAdded:Once(function(childModel)
				if ((childModel.Name == toyName) and childModel:IsA("Model")) then
					toyModel = childModel;
				end
			end);
			isInPlot = true;
		end
	else
		spawnedInToys.ChildAdded:Once(function(spawnedModel)
			if ((spawnedModel.Name == toyName) and spawnedModel:IsA("Model")) then
				toyModel = spawnedModel;
			end
		end);
		isInPlot = false;
	end
	local spawnStartTime = tick();
	while not toyModel do
		if ((tick() - spawnStartTime) < 3) then
			task.wait();
		else
			return false;
		end
	end
	return toyModel, isInPlot;
end
local function SetNetworkOwner(partArg)
	setNetworkOwnerRemote:FireServer(partArg, partArg.CFrame);
end
local function SetTitle(titleArg)
end
_G.kickLoopEnabled = false;
_G.selectedKickPlayer = nil;
_G.DestroyGucciActive = false;
_G.AnchorEnabled = false;
_G.AnchorConnection = nil;
_G.AntiInputLagActive = false;
_G.RagdollSnowballActive = false;
_G.SelectedAntiLagToy = "FoodApple";
local toyNames = {
	Apple = "FoodApple",
	Banana = "FoodBanana",
	Orange = "FoodOrange",
	Lemon = "FoodLemon",
	Carrot = "FoodCarrot",
	Fries = "FoodFrenchFries",
	MeatStick = "FoodMeatStick",
	Poop = "PoopPile",
	Donut = "FoodDonut",
	Cake = "FoodCakePink",
	Burger = "FoodHamburger",
	Pizza = "FoodPizzaCheese",
	Hotdog = "FoodHotdog",
	Mushroom = "FoodMushroomPoison",
	Banjo = "InstrumentGuitarBanjo",
	Violin = "InstrumentGuitarViolin",
	Ukulele = "InstrumentGuitarUkulele",
	Sax = "InstrumentWoodwindSaxophone",
	Vuvuzela = "InstrumentBrassVuvuzela",
	Bongos = "InstrumentDrumBongos",
	Mic = "InstrumentVoiceMicrophone",
	Pepperoni = "FoodPizzaPepperoni",
	Piano = "InstrumentPianoMelodica",
	Bread = "FoodBread",
	Egg = "FoodDippyEgg",
	Mayo = "FoodMayonnaise",
	WhiteMug = "CupMugWhite",
	Ocarina = "InstrumentWoodwindOcarina",
	SparklePoop = "PoopPileSparkle",
	BrownMug = "CupMugBrown",
	Trumpet = "InstrumentBrassTrumpet",
	Snare = "InstrumentDrumSnare"
};
local function GetOtherPlayerNames()
	local nameList = {};
	for pIdx, pObj in pairs(Players:GetPlayers()) do
		if (pObj ~= LocalPlayer) then
			table.insert(nameList, pObj.Name);
		end
	end
	return nameList;
end
local function FindPlayerByName(targetName)
	return Players:FindFirstChild(targetName);
end
game:GetService("UserInputService").MouseIconEnabled = true;
_G.horario = "âŒœ" .. os.date("%H:%M") .. "âŒŸ" ;
local window = OrionLib:MakeWindow({
	Name = "Black Hub - Fling things and peoples",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "Black Hub"
});
local Players = game:GetService("Players");
local CoreGui = game:GetService("CoreGui");
task.wait(1);
local orionGuiFrame;
for guiIdx, guiObj in pairs(CoreGui:GetChildren()) do
	if (guiObj:IsA("ScreenGui") and string.find(guiObj.Name:lower(), "orion")) then
		orionGuiFrame = guiObj;
		break;
	end
end
if orionGuiFrame then
	local titleBarFrame;
	for descIdx, descObj in pairs(orionGuiFrame:GetDescendants()) do
		if (descObj:IsA("Frame") and ((descObj.Name == "TopBar") or (descObj.Name == "TitleBar"))) then
			titleBarFrame = descObj;
			break;
		end
	end
	if titleBarFrame then
		local hubIcon = Instance.new("ImageLabel");
		hubIcon.Name = "HubIcon";
		hubIcon.Size = UDim2.new(0, 45, 0, 40);
		hubIcon.Position = UDim2.new(0, 9, 0, 9);
		hubIcon.BackgroundTransparency = 1;
		hubIcon.Image = "rbxassetid://104626717224269";
		hubIcon.Parent = titleBarFrame;
		for lblIdx, lblObj in pairs(titleBarFrame:GetChildren()) do
			if lblObj:IsA("TextLabel") then
				lblObj.Position = lblObj.Position + UDim2.new(0, 30, 0, 0) ;
			end
		end
	end
end
local grabsTab = window:MakeTab({
	Name = "Grabs",
	Icon = "rbxassetid://7733955740",
	PremiumOnly = false
});
grabsTab:AddSection({
	Name = " Grab Mods "
});
local invulnTab = window:MakeTab({
	Name = "Invulnerability",
	Icon = "rbxassetid://7734056608",
	PremiumOnly = false
});
invulnTab:AddSection({
	Name = "ðŸ›¡  Invincible  ðŸ›¡"
});
invulnTab:AddToggle({
	Name = "Anti Kick",
	Default = false,
	Callback = function(antiKickState)
		_G.ShurikenAntiKick = antiKickState;
		local function destroyAntiKickToys()
			local akLocalPlayer = game.Players.LocalPlayer;
			local akSpawnedToys = workspace:FindFirstChild(akLocalPlayer.Name .. "SpawnedInToys");
			local akDestroyToy = game.ReplicatedStorage:FindFirstChild("MenuToys") and game.ReplicatedStorage.MenuToys:FindFirstChild("DestroyToy") ;
			if (akSpawnedToys and akDestroyToy) then
				for toyIdx2, toyObj2 in pairs(akSpawnedToys:GetChildren()) do
					if ((toyObj2.Name == "AntiKick") or (toyObj2.Name == "NinjaShuriken")) then
						pcall(function()
							akDestroyToy:FireServer(toyObj2);
						end);
					end
				end
			end
		end
		if antiKickState then
			task.spawn(function()
				local akLP = game.Players.LocalPlayer;
				local akReplicatedStorage = game:GetService("ReplicatedStorage");
				local akSetNetworkOwner = akReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner");
				local akStickyPartEvent = akReplicatedStorage:WaitForChild("PlayerEvents"):WaitForChild("StickyPartEvent");
				local akSpawnToyRemote = akReplicatedStorage.MenuToys.SpawnToyRemoteFunction;
				local akDestroyToyRemote = akReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy");
				local akCanSpawnToy = akLP:WaitForChild("CanSpawnToy");
				local function getHRP()
					if (akLP.Character and akLP.Character:FindFirstChild("HumanoidRootPart")) then
						return akLP.Character.HumanoidRootPart;
					else
						local newCharHRP = akLP.CharacterAdded:Wait();
						return newCharHRP:WaitForChild("HumanoidRootPart");
					end
				end
				local function isInOwnedPlot()
					if not workspace.PlotItems.PlayersInPlots:FindFirstChild(akLP.Name) then
						return false;
					end
					for plotIdx2, plotObj2 in pairs(workspace.Plots:GetChildren()) do
						local plotSign2 = plotObj2:FindFirstChild("PlotSign");
						local plotOwners2 = plotSign2 and plotSign2:FindFirstChild("ThisPlotsOwners") ;
						if plotOwners2 then
							for ownerIdx2, ownerObj2 in pairs(plotOwners2:GetChildren()) do
								if (ownerObj2.Value == akLP.Name) then
									local plotItems2 = workspace.PlotItems:FindFirstChild(plotObj2.Name);
									if plotItems2 then
										return true, plotItems2;
									end
								end
							end
						end
					end
					return false;
				end
				local function setupAntiKickShuriken(shurikenModel)
					if (not shurikenModel or not shurikenModel:FindFirstChild("StickyPart")) then
						return;
					end
					local akHRP = getHRP();
					if not akHRP then
						return;
					end
					if shurikenModel:FindFirstChild("SoundPart") then
						if (not shurikenModel.SoundPart:FindFirstChild("PartOwner") or (shurikenModel.SoundPart.PartOwner.Value ~= akLP.Name)) then
							akSetNetworkOwner:FireServer(shurikenModel.SoundPart, shurikenModel.SoundPart.CFrame);
						end
					end
					local firePlayerPart = akHRP:FindFirstChild("FirePlayerPart") or akHRP:WaitForChild("FirePlayerPart", 5) ;
					if firePlayerPart then
						akStickyPartEvent:FireServer(shurikenModel.StickyPart, firePlayerPart, CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)));
					end
					for childIdx, childObj in pairs(shurikenModel:GetChildren()) do
						if (childObj.Name == "Pyramid") then
							childObj.CanTouch = false;
							childObj.CanCollide = false;
							childObj.CanQuery = false;
							childObj.Transparency = 0;
							if not childObj:FindFirstChild("Highlight") then
								local highlightBlack = Instance.new("Highlight", childObj);
								highlightBlack.FillColor = Color3.fromRGB(0, 0, 0);
							end
						elseif (childObj.Name == "Main") then
							childObj.CanTouch = false;
							childObj.CanCollide = false;
							childObj.CanQuery = false;
							childObj.Transparency = 0;
							if not childObj:FindFirstChild("Highlight") then
								local highlightWhite = Instance.new("Highlight", childObj);
								highlightWhite.FillColor = Color3.fromRGB(255, 255, 255);
							end
						elseif childObj:IsA("BasePart") then
							childObj.CanTouch = false;
							childObj.CanCollide = false;
							childObj.CanQuery = false;
							childObj.Transparency = 1;
						end
					end
				end
				local function spawnAndGetToy(toyName2)
					local spawnToyStart = tick();
					while not akCanSpawnToy.Value do
						if (not _G.ShurikenAntiKick or ((tick() - spawnToyStart) > 5)) then
							return nil;
						end
						task.wait(0.1);
					end
					local akHRP2 = getHRP();
					if akHRP2 then
						task.spawn(function()
							pcall(function()
								akSpawnToyRemote:InvokeServer(toyName2, akHRP2.CFrame * CFrame.new(0, 12, 20), Vector3.new(0, 0, 0));
							end);
						end);
					end
					local akInPlot, akPlotItems = isInOwnedPlot();
					local akSpawnedToys2 = workspace:FindFirstChild(akLP.Name .. "SpawnedInToys");
					if (akInPlot and akPlotItems) then
						return akPlotItems:WaitForChild(toyName2, 2);
					elseif (not workspace.PlotItems.PlayersInPlots:FindFirstChild(akLP.Name) and akSpawnedToys2) then
						return akSpawnedToys2:WaitForChild(toyName2, 2);
					end
					return nil;
				end
				while _G.ShurikenAntiKick do
					task.wait(0.005);
					if (not akLP.Character or not akLP.Character:FindFirstChild("Humanoid") or (akLP.Character.Humanoid.Health <= 0)) then
						continue;
					end
					local akToysFolder = workspace:FindFirstChild(akLP.Name .. "SpawnedInToys");
					local akShuriken = akToysFolder and akToysFolder:FindFirstChild("NinjaShuriken") ;
					if workspace.PlotItems.PlayersInPlots:FindFirstChild(akLP.Name) then
						local akInOwnedPlot, akOwnedPlot = isInOwnedPlot();
						if (akInOwnedPlot and akOwnedPlot and workspace.Plots:FindFirstChild(akOwnedPlot.Name)) then
							local akTimeRemaining = workspace.Plots[akOwnedPlot.Name]:FindFirstChild("PlotSign");
							if (akTimeRemaining and (akTimeRemaining.ThisPlotsOwners.Value.TimeRemainingNum.Value > 89)) then
								akShuriken = spawnAndGetToy("NinjaShuriken");
								if (akShuriken == nil) then
									continue;
								end
								akShuriken.Name = "AntiKick";
								setupAntiKickShuriken(akShuriken);
							end
						end
					end
					if not akShuriken then
						if workspace.PlotItems.PlayersInPlots:FindFirstChild(akLP.Name) then
							continue;
						end
						akShuriken = spawnAndGetToy("NinjaShuriken");
						if (akShuriken == nil) then
							continue;
						end
						akShuriken.Name = "AntiKick";
						if not akShuriken then
							continue;
						end
					end
					repeat
						if (akShuriken and akShuriken:FindFirstChild("StickyPart") and (akShuriken.StickyPart.CanTouch == true)) then
							setupAntiKickShuriken(akShuriken);
							akShuriken.Name = "AntiKick";
						end
						task.wait(0.3);
					until not akShuriken or not _G.ShurikenAntiKick or not akShuriken:FindFirstChild("StickyPart") or (akShuriken.StickyPart.CanTouch == false) or not akLP.Character or not akLP.Character:FindFirstChild("HumanoidRootPart") or not akShuriken:FindFirstChild("StickyPart") or ((akLP.Character.HumanoidRootPart.Position - akShuriken.StickyPart.Position).Magnitude >= 20)
					if (not akShuriken or not akShuriken:FindFirstChild("StickyPart") or not akLP.Character or not akLP.Character:FindFirstChild("HumanoidRootPart") or ((akLP.Character.HumanoidRootPart.Position - akShuriken.StickyPart.Position).Magnitude >= 20)) then
						destroyAntiKickToys();
					end
					pcall(function()
						repeat
							task.wait(0.05);
						until not _G.ShurikenAntiKick or not akLP.Character or not akLP.Character:FindFirstChild("Humanoid") or not akShuriken or not akShuriken:FindFirstChild("StickyPart") or not akShuriken.StickyPart:FindFirstChild("StickyWeld") or not akShuriken.StickyPart.StickyWeld.Part1
						if (not akShuriken or not akShuriken:FindFirstChild("StickyPart") or (akLP.Character and akLP.Character:FindFirstChild("Humanoid") and (akLP.Character.Humanoid.Health <= 0)) or not akShuriken['StickyPart']:FindFirstChild("StickyWeld").Part1) then
							destroyAntiKickToys();
						end
					end);
				end
			end);
		else
			_G.ShurikenAntiKick = false;
			destroyAntiKickToys();
		end
	end
});
invulnTab:AddToggle({
	Name = "Anti Input Lag",
	Default = false,
	Callback = function(antiInputLagState)
		_G.AntiInputLagActive = antiInputLagState;
		if antiInputLagState then
			task.spawn(function()
				local ailToyName = "FoodDonut";
				local ailRunService = game:GetService("RunService");
				while _G.AntiInputLagActive do
					if not _G.AntiInputLagActive then
						break;
					end
					local ailChar = LocalPlayer.Character;
					if not ailChar then
						ailRunService.Heartbeat:Wait();
						continue;
					end
					local ailHRP = ailChar:FindFirstChild("HumanoidRootPart");
					if not ailHRP then
						ailRunService.Heartbeat:Wait();
						continue;
					end
					local ailSpawnedToys = workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys");
					if not ailSpawnedToys then
						ailRunService.Heartbeat:Wait();
						continue;
					end
					local ailToy = ailSpawnedToys:FindFirstChild(ailToyName);
					if ailToy then
						local ailHoldPart = ailToy:FindFirstChild("HoldPart");
						if ailHoldPart then
							local ailHoldingPlayer = ailHoldPart:FindFirstChild("HoldingPlayer");
							ailHoldingPlayer = ailHoldingPlayer and ailHoldingPlayer.Value ;
							if (ailHoldingPlayer and (ailHoldingPlayer ~= LocalPlayer)) then
								pcall(function()
									ailToy:Destroy();
								end);
								ailToy = nil;
							end
						end
					end
					if (not ailToy or not ailToy.Parent) then
						pcall(function()
							ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(ailToyName, ailHRP.CFrame * CFrame.new(0, 5, 0), Vector3.zero);
						end);
						local ailSpawnStart = tick();
						repeat
							ailRunService.Heartbeat:Wait();
							if not _G.AntiInputLagActive then
								break;
							end
							ailSpawnedToys = workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys");
							ailToy = ailSpawnedToys and ailSpawnedToys:FindFirstChild(ailToyName) ;
							if (ailToy and ailToy.Parent) then
								local ailHoldRemote = ailToy:FindFirstChild("HoldPart");
								if ailHoldRemote then
									pcall(function()
										ailHoldRemote.HoldItemRemoteFunction:InvokeServer(ailToy, ailChar);
									end);
								end
							end
						until ailToy or ((tick() - ailSpawnStart) > 1)
						if not _G.AntiInputLagActive then
							break;
						end
					end
					if not _G.AntiInputLagActive then
						break;
					end
					if (ailToy and ailToy.Parent) then
						local ailDropRemote = ailToy:FindFirstChild("HoldPart");
						if ailDropRemote then
							pcall(function()
								ailDropRemote.HoldItemRemoteFunction:InvokeServer(ailToy, ailChar);
							end);
							pcall(function()
								ailDropRemote.DropItemRemoteFunction:InvokeServer(ailToy, ailHRP.CFrame * CFrame.new(0, 2000, 0), Vector3.zero);
							end);
						end
					end
					ailRunService.Heartbeat:Wait();
				end
			end);
		else
			_G.AntiInputLagActive = false;
		end
	end
});
local kickResetActive = false;
invulnTab:AddToggle({
	Name = "kick Reset",
	Default = false,
	Callback = function(kickResetState)
		kickResetActive = kickResetState;
		if kickResetActive then
			connections['GameNotify'] = gameCorrectionsNotify.OnClientEvent:Connect(function(notifyArg)
				if (notifyArg == "Flying") then
					struggleRemote:FireServer(LocalPlayer);
					WaitForChildCustom(LocalPlayer.Character, "Humanoid").Health = 0;
				end
			end);
		else
			DisconnectConnection("GameNotify");
		end
	end
});
invulnTab:AddButton({
	Name = "Break PCLD",
	Callback = function()
		local pcldPlayer = game:GetService("Players").LocalPlayer;
		local pcldChar = pcldPlayer.Character;
		local pcldHRP = pcldChar and pcldChar:FindFirstChild("HumanoidRootPart") ;
		local pcldHumanoid = pcldChar and pcldChar:FindFirstChild("Humanoid") ;
		if not(pcldHRP and pcldHumanoid) then
			return;
		end
		local pcldCFrame = pcldHRP.CFrame;
		pcldHRP.CFrame = pcldCFrame + Vector3.new(0, 50000, 0) ;
		task.wait(0.05);
		pcldHumanoid.Health = 0;
		pcldPlayer.CharacterAdded:Once(function(newChar)
			local newHRP = newChar:WaitForChild("HumanoidRootPart", 5);
			local newHumanoid = newChar:WaitForChild("Humanoid", 5);
			if (newHRP and newHumanoid) then
				task.wait(0.1);
				newHRP.CFrame = pcldCFrame;
				task.wait(0.05);
				newHumanoid.Health = 0;
			end
		end);
	end
});
local gucciBlobmanHeartbeat;
local gucciBlobmanSavedPos;
local gucciBlobmanCounter = 0;
local gucciBlobmanActive = false;
local function spawnGucciBlobman()
	local gbPlayer = game:GetService("Players").LocalPlayer;
	local gbReplicatedStorage = game:GetService("ReplicatedStorage");
	local gbSpawnArgs = {
		[1] = "CreatureBlobman",
		[2] = CFrame.new(0, 5000000, 0),
		[3] = Vector3.new(0, 60, 0)
	};
	pcall(function()
		gbReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(unpack(gbSpawnArgs));
	end);
	local gbSpawnedToys = workspace:WaitForChild(gbPlayer.Name .. "SpawnedInToys", 5);
	if (gbSpawnedToys and gbSpawnedToys:FindFirstChild("CreatureBlobman")) then
		local gbBlobman = gbSpawnedToys.CreatureBlobman;
		if gbBlobman:FindFirstChild("Head") then
			gbBlobman.Head.CFrame = CFrame.new(0, 50000, 0);
			gbBlobman.Head.Anchored = true;
		end
	end
end
local function startGucciBlobman()
	local gucciPlayer = game:GetService("Players").LocalPlayer;
	local gucciRunService = game:GetService("RunService");
	local gucciReplicatedStorage = game:GetService("ReplicatedStorage");
	local gucciChar = gucciPlayer.Character or gucciPlayer.CharacterAdded:Wait() ;
	local gucciHumanoid = gucciChar:WaitForChild("Humanoid");
	local gucciHRP = gucciChar:WaitForChild("HumanoidRootPart");
	gucciBlobmanSavedPos = gucciHRP.Position;
	local gucciSpawnedToys = workspace:FindFirstChild(gucciPlayer.Name .. "SpawnedInToys");
	local gucciBlobman = gucciSpawnedToys and gucciSpawnedToys:FindFirstChild("CreatureBlobman") ;
	local gucciVehicleSeat = gucciBlobman and gucciBlobman:FindFirstChild("VehicleSeat") ;
	if not gucciBlobman then
		spawnGucciBlobman();
		task.wait(1);
		gucciSpawnedToys = workspace:FindFirstChild(gucciPlayer.Name .. "SpawnedInToys");
		gucciBlobman = gucciSpawnedToys and gucciSpawnedToys:FindFirstChild("CreatureBlobman") ;
		gucciVehicleSeat = gucciBlobman and gucciBlobman:FindFirstChild("VehicleSeat") ;
	end
	if (gucciVehicleSeat and gucciVehicleSeat:IsA("VehicleSeat")) then
		gucciHRP.CFrame = gucciVehicleSeat.CFrame + Vector3.new(0, 2, 0) ;
		gucciVehicleSeat:Sit(gucciHumanoid);
	end
	gucciHumanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if (gucciHumanoid.Jump and gucciHumanoid.Sit) then
			gucciBlobmanCounter = 15;
			gucciBlobmanSavedPos = gucciHRP.Position;
		end
	end);
	if gucciBlobmanHeartbeat then
		gucciBlobmanHeartbeat:Disconnect();
	end
	gucciBlobmanHeartbeat = gucciRunService.Heartbeat:Connect(function()
		if (not gucciHRP or not gucciHumanoid) then
			return;
		end
		gucciReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(gucciHRP, 0);
		if (gucciBlobmanCounter > 0) then
			gucciHRP.CFrame = CFrame.new(gucciBlobmanSavedPos);
			gucciBlobmanCounter = gucciBlobmanCounter - 1 ;
		end
	end);
	task.spawn(function()
		while gucciHumanoid.Sit do
			task.wait(1);
		end
		task.wait(0.5);
		gucciHRP.CFrame = CFrame.new(gucciBlobmanSavedPos);
	end);
end
local function stopGucciBlobman()
	local stopPlayer = game:GetService("Players").LocalPlayer;
	if gucciBlobmanHeartbeat then
		gucciBlobmanHeartbeat:Disconnect();
		gucciBlobmanHeartbeat = nil;
	end
	local stopSpawnedToys = workspace:FindFirstChild(stopPlayer.Name .. "SpawnedInToys");
	if (stopSpawnedToys and stopSpawnedToys:FindFirstChild("CreatureBlobman")) then
		stopSpawnedToys.CreatureBlobman:Destroy();
	end
end
local gucciTractorHeartbeat;
local gucciTractorSavedPos;
local gucciTractorCounter = 0;
local function spawnGucciTractor()
	local gtPlayer = game:GetService("Players").LocalPlayer;
	local gtReplicatedStorage = game:GetService("ReplicatedStorage");
	local gtSpawnArgs = {
		[1] = "TractorGreen",
		[2] = CFrame.new(0, 5000000, 0),
		[3] = Vector3.new(0, 60, 0)
	};
	pcall(function()
		gtReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(unpack(gtSpawnArgs));
	end);
	local gtSpawnedToys = workspace:WaitForChild(gtPlayer.Name .. "SpawnedInToys", 5);
	if (gtSpawnedToys and gtSpawnedToys:FindFirstChild("TractorGreen")) then
		local gtTractor = gtSpawnedToys.TractorGreen;
		if gtTractor:FindFirstChild("Main") then
			gtTractor.Main.CFrame = CFrame.new(0, 50000, 0);
			gtTractor.Main.Anchored = true;
		end
	end
end
local function startGucciTractor()
	local gtPlayer2 = game:GetService("Players").LocalPlayer;
	local gtRunService = game:GetService("RunService");
	local gtReplicatedStorage2 = game:GetService("ReplicatedStorage");
	local gtChar = gtPlayer2.Character or gtPlayer2.CharacterAdded:Wait() ;
	local gtHumanoid = gtChar:WaitForChild("Humanoid");
	local gtHRP = gtChar:WaitForChild("HumanoidRootPart");
	gucciTractorSavedPos = gtHRP.Position;
	local gtSpawnedToys2 = workspace:FindFirstChild(gtPlayer2.Name .. "SpawnedInToys");
	local gtTractor2 = gtSpawnedToys2 and gtSpawnedToys2:FindFirstChild("TractorGreen") ;
	local gtVehicleSeat = gtTractor2 and gtTractor2:FindFirstChildOfClass("VehicleSeat") ;
	if not gtTractor2 then
		spawnGucciTractor();
		task.wait(1);
		gtSpawnedToys2 = workspace:FindFirstChild(gtPlayer2.Name .. "SpawnedInToys");
		gtTractor2 = gtSpawnedToys2 and gtSpawnedToys2:FindFirstChild("TractorGreen") ;
		gtVehicleSeat = gtTractor2 and gtTractor2:FindFirstChildOfClass("VehicleSeat") ;
	end
	if (gtVehicleSeat and gtVehicleSeat:IsA("VehicleSeat")) then
		gtHRP.CFrame = gtVehicleSeat.CFrame + Vector3.new(0, 2, 0) ;
		gtVehicleSeat:Sit(gtHumanoid);
	end
	gtHumanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if (gtHumanoid.Jump and gtHumanoid.Sit) then
			gucciTractorCounter = 15;
			gucciTractorSavedPos = gtHRP.Position;
		end
	end);
	if gucciTractorHeartbeat then
		gucciTractorHeartbeat:Disconnect();
	end
	gucciTractorHeartbeat = gtRunService.Heartbeat:Connect(function()
		if (not gtHRP or not gtHumanoid) then
			return;
		end
		gtReplicatedStorage2.CharacterEvents.RagdollRemote:FireServer(gtHRP, 0);
		if (gucciTractorCounter > 0) then
			gtHRP.CFrame = CFrame.new(gucciTractorSavedPos);
			gucciTractorCounter = gucciTractorCounter - 1 ;
		end
	end);
	task.spawn(function()
		while gtHumanoid.Sit do
			task.wait(1);
		end
		task.wait(0.5);
		gtHRP.CFrame = CFrame.new(gucciTractorSavedPos);
		task.wait(5);
		if gucciTractorHeartbeat then
			gucciTractorHeartbeat:Disconnect();
			gucciTractorHeartbeat = nil;
		end
	end);
end
invulnTab:AddButton({
	Name = "Gucci (Tractor)",
	Callback = function()
		startGucciTractor();
	end
});
local gucciBlobman2Heartbeat;
local gucciBlobman2SavedPos;
local gucciBlobman2Counter = 0;
local function spawnGucciBlobman2()
	local gb2Player = game:GetService("Players").LocalPlayer;
	local gb2ReplicatedStorage = game:GetService("ReplicatedStorage");
	local gb2SpawnArgs = {
		[1] = "CreatureBlobman",
		[2] = CFrame.new(0, 5000000, 0),
		[3] = Vector3.new(0, 60, 0)
	};
	pcall(function()
		gb2ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(unpack(gb2SpawnArgs));
	end);
	local gb2SpawnedToys = workspace:WaitForChild(gb2Player.Name .. "SpawnedInToys", 5);
	if (gb2SpawnedToys and gb2SpawnedToys:FindFirstChild("CreatureBlobman")) then
		local gb2Blobman = gb2SpawnedToys.CreatureBlobman;
		if gb2Blobman:FindFirstChild("Head") then
			gb2Blobman.Head.CFrame = CFrame.new(0, 50000, 0);
			gb2Blobman.Head.Anchored = true;
		end
	end
end
local function startGucciBlobman2()
	local gb2Player2 = game:GetService("Players").LocalPlayer;
	local gb2RunService = game:GetService("RunService");
	local gb2ReplicatedStorage2 = game:GetService("ReplicatedStorage");
	local gb2Char = gb2Player2.Character or gb2Player2.CharacterAdded:Wait() ;
	local gb2Humanoid = gb2Char:WaitForChild("Humanoid");
	local gb2HRP = gb2Char:WaitForChild("HumanoidRootPart");
	gucciBlobman2SavedPos = gb2HRP.Position;
	local gb2SpawnedToys2 = workspace:FindFirstChild(gb2Player2.Name .. "SpawnedInToys");
	local gb2Blobman2 = gb2SpawnedToys2 and gb2SpawnedToys2:FindFirstChild("CreatureBlobman") ;
	local gb2VehicleSeat = gb2Blobman2 and gb2Blobman2:FindFirstChild("VehicleSeat") ;
	if not gb2Blobman2 then
		spawnGucciBlobman2();
		task.wait(1);
		gb2SpawnedToys2 = workspace:FindFirstChild(gb2Player2.Name .. "SpawnedInToys");
		gb2Blobman2 = gb2SpawnedToys2 and gb2SpawnedToys2:FindFirstChild("CreatureBlobman") ;
		gb2VehicleSeat = gb2Blobman2 and gb2Blobman2:FindFirstChild("VehicleSeat") ;
	end
	if (gb2VehicleSeat and gb2VehicleSeat:IsA("VehicleSeat")) then
		gb2HRP.CFrame = gb2VehicleSeat.CFrame + Vector3.new(0, 2, 0) ;
		gb2VehicleSeat:Sit(gb2Humanoid);
	end
	gb2Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if (gb2Humanoid.Jump and gb2Humanoid.Sit) then
			gucciBlobman2Counter = 15;
			gucciBlobman2SavedPos = gb2HRP.Position;
		end
	end);
	if gucciBlobman2Heartbeat then
		gucciBlobman2Heartbeat:Disconnect();
	end
	gucciBlobman2Heartbeat = gb2RunService.Heartbeat:Connect(function()
		if (not gb2HRP or not gb2Humanoid) then
			return;
		end
		gb2ReplicatedStorage2.CharacterEvents.RagdollRemote:FireServer(gb2HRP, 0);
		if (gucciBlobman2Counter > 0) then
			gb2HRP.CFrame = CFrame.new(gucciBlobman2SavedPos);
			gucciBlobman2Counter = gucciBlobman2Counter - 1 ;
		end
	end);
	task.spawn(function()
		while gb2Humanoid.Sit do
			task.wait(1);
		end
		task.wait(0.5);
		gb2HRP.CFrame = CFrame.new(gucciBlobman2SavedPos);
		task.wait(5);
		if gucciBlobman2Heartbeat then
			gucciBlobman2Heartbeat:Disconnect();
			gucciBlobman2Heartbeat = nil;
		end
	end);
end
invulnTab:AddButton({
	Name = "Gucci (Blobman)",
	Callback = function()
		startGucciBlobman2();
	end
});
local gucciTrainHeartbeat;
local gucciTrainSavedPos;
local gucciTrainCounter = 0;
local gucciTrainEnabled = false;
local function startGucciTrain()
	local trainPlayer = game:GetService("Players").LocalPlayer;
	local trainRunService = game:GetService("RunService");
	local trainReplicatedStorage = game:GetService("ReplicatedStorage");
	local trainChar = trainPlayer.Character or trainPlayer.CharacterAdded:Wait() ;
	local trainHumanoid = trainChar:WaitForChild("Humanoid");
	local trainHRP = trainChar:WaitForChild("HumanoidRootPart");
	gucciTrainSavedPos = trainHRP.Position;
	local trainTweened = workspace.Map.AlwaysHereTweenedObjects;
	local trainObj = trainTweened and trainTweened:FindFirstChild("Train") ;
	local trainSeat;
	if trainObj then
		for trainDescIdx, trainDescObj in ipairs(trainObj:GetDescendants()) do
			if trainDescObj:IsA("Seat") then
				trainSeat = trainDescObj;
				break;
			end
		end
	end
	if trainSeat then
		trainHRP.CFrame = trainSeat.CFrame + Vector3.new(0, 2, 0) ;
		trainSeat:Sit(trainHumanoid);
	end
	trainHumanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if (trainHumanoid.Jump and trainHumanoid.Sit) then
			gucciTrainCounter = 15;
			gucciTrainSavedPos = trainHRP.Position;
		end
	end);
	if gucciTrainHeartbeat then
		gucciTrainHeartbeat:Disconnect();
	end
	gucciTrainHeartbeat = trainRunService.Heartbeat:Connect(function()
		if (not trainHRP or not trainHumanoid) then
			return;
		end
		trainReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(trainHRP, 0);
		if (gucciTrainCounter > 0) then
			trainHRP.CFrame = CFrame.new(gucciTrainSavedPos);
			gucciTrainCounter = gucciTrainCounter - 1 ;
		end
	end);
	task.spawn(function()
		while trainHumanoid.Sit do
			task.wait(1);
		end
		task.wait(0.5);
		trainHRP.CFrame = CFrame.new(gucciTrainSavedPos);
	end);
end
local function stopGucciTrain()
	if gucciTrainHeartbeat then
		gucciTrainHeartbeat:Disconnect();
		gucciTrainHeartbeat = nil;
	end
end
local gucciTrain2Heartbeat;
local gucciTrain2SavedPos;
local gucciTrain2Counter = 0;
local function startGucciTrain2()
	local train2Player = game:GetService("Players").LocalPlayer;
	local train2RunService = game:GetService("RunService");
	local train2ReplicatedStorage = game:GetService("ReplicatedStorage");
	local train2Char = train2Player.Character or train2Player.CharacterAdded:Wait() ;
	local train2Humanoid = train2Char:WaitForChild("Humanoid");
	local train2HRP = train2Char:WaitForChild("HumanoidRootPart");
	gucciTrain2SavedPos = train2HRP.Position;
	local train2Tweened = workspace.Map.AlwaysHereTweenedObjects;
	local train2Obj = train2Tweened and train2Tweened:FindFirstChild("Train") ;
	local train2Seat;
	if train2Obj then
		for train2DescIdx, train2DescObj in ipairs(train2Obj:GetDescendants()) do
			if train2DescObj:IsA("Seat") then
				train2Seat = train2DescObj;
				break;
			end
		end
	end
	if train2Seat then
		train2HRP.CFrame = train2Seat.CFrame + Vector3.new(0, 2, 0) ;
		train2Seat:Sit(train2Humanoid);
	end
	train2Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if (train2Humanoid.Jump and train2Humanoid.Sit) then
			gucciTrain2Counter = 15;
			gucciTrain2SavedPos = train2HRP.Position;
		end
	end);
	if gucciTrain2Heartbeat then
		gucciTrain2Heartbeat:Disconnect();
	end
	gucciTrain2Heartbeat = train2RunService.Heartbeat:Connect(function()
		if (not train2HRP or not train2Humanoid) then
			return;
		end
		train2ReplicatedStorage.CharacterEvents.RagdollRemote:FireServer(train2HRP, 0);
		if (gucciTrain2Counter > 0) then
			train2HRP.CFrame = CFrame.new(gucciTrain2SavedPos);
			gucciTrain2Counter = gucciTrain2Counter - 1 ;
		end
	end);
	task.spawn(function()
		while train2Humanoid.Sit do
			task.wait(1);
		end
		task.wait(0.5);
		train2HRP.CFrame = CFrame.new(gucciTrain2SavedPos);
		task.wait(5);
		if gucciTrain2Heartbeat then
			gucciTrain2Heartbeat:Disconnect();
			gucciTrain2Heartbeat = nil;
		end
	end);
end
invulnTab:AddButton({
	Name = "Gucci (Train)",
	Callback = function()
		startGucciTrain2();
	end
});
local antiRagdollOnBlob = false;
local antiRagdollBusy = false;
invulnTab:AddToggle({
	Name = "Anti Ragdoll (On Blob)",
	Default = false,
	Callback = function(antiRagdollState)
		antiRagdollOnBlob = antiRagdollState;
		antiRagdollBusy = false;
		if antiRagdollOnBlob then
			local arChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() ;
			local arHumanoid = arChar and WaitForChildCustom(arChar, "Humanoid") ;
			local arHRP = arChar and WaitForChildCustom(arChar, "HumanoidRootPart") ;
			connections['ARSeat'] = arHumanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
				if (arHumanoid.SeatPart and (arHumanoid.SeatPart.Parent.Name == "CreatureBlobman") and not antiRagdollBusy) then
					antiRagdollBusy = true;
					local arSeatPart = arHumanoid.SeatPart;
					while not arHumanoid.Sit do
						task.wait();
					end
					ragdollRemote:FireServer(arHRP, 3);
					while not arHumanoid.Ragdolled.Value and not arHumanoid.Sit do
						task.wait();
					end
					task.wait(0.4);
					arHumanoid.Sit = false;
					arSeatPart:Sit(arHumanoid);
					task.delay(0.25, function()
						while arHumanoid and arHumanoid.SeatPart do
							ragdollRemote:FireServer(LocalPlayer.Character.HumanoidRootPart, 1);
							task.wait(0.05);
						end
						antiRagdollBusy = false;
					end);
				end
			end);
			connections['ARChar'] = LocalPlayer.CharacterAdded:Connect(function(arNewChar)
				arHumanoid = WaitForChildCustom(arNewChar, "Humanoid");
				arHRP = WaitForChildCustom(arNewChar, "HumanoidRootPart");
				connections['ARSeat'] = arHumanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
					if (arHumanoid.SeatPart and (arHumanoid.SeatPart.Parent.Name == "CreatureBlobman") and not antiRagdollBusy) then
						antiRagdollBusy = true;
						local arNewSeatPart = arHumanoid.SeatPart;
						while not arHumanoid.Sit do
							task.wait();
						end
						ragdollRemote:FireServer(arHRP, 3);
						while not arHumanoid.Ragdolled.Value and not arHumanoid.Sit do
							task.wait();
						end
						task.wait(0.4);
						arHumanoid.Sit = false;
						arNewSeatPart:Sit(arHumanoid);
						task.delay(0.25, function()
							while arHumanoid and arHumanoid.SeatPart do
								ragdollRemote:FireServer(LocalPlayer.Character.HumanoidRootPart, 1);
								task.wait(0.05);
							end
							antiRagdollBusy = false;
						end);
					end
				end);
			end);
		else
			DisconnectConnection("ARSeat");
			DisconnectConnection("ARChar");
		end
	end
});
invulnTab:AddToggle({
	Name = "Anti Banana",
	Default = false,
	Callback = function(headlessState)
		_G.Headless = headlessState;
		if headlessState then
			local abPlayers = game:GetService("Players");
			local abLocalPlayer = abPlayers.LocalPlayer;
			local function applyHeadless()
				local abChar = abLocalPlayer.Character or abLocalPlayer.CharacterAdded:Wait() ;
				if not abChar then
					return;
				end
				local abHumanoid = abChar:FindFirstChild("Humanoid");
				local abHRP = abChar:FindFirstChild("HumanoidRootPart");
				if (not abHumanoid or not abHRP) then
					return;
				end
				local abHead = abChar:WaitForChild("Head", 3);
				if not abHead then
					return;
				end
				local abTorso = abChar:FindFirstChild("Torso") or abChar:FindFirstChild("UpperTorso") ;
				if not abTorso then
					return;
				end
				game:GetService("ReplicatedStorage").CharacterEvents.RagdollRemote:FireServer(abHRP, 3);
				task.wait(0.2);
				local abTorsoCF = abTorso.CFrame;
				local abHeadCF = abHead.CFrame;
				local abHRPCF = abHRP.CFrame;
				local abLegs = {
					abChar:FindFirstChild("Left Leg"),
					abChar:FindFirstChild("Right Leg"),
					abChar:FindFirstChild("LeftUpperLeg"),
					abChar:FindFirstChild("RightUpperLeg"),
					abChar:FindFirstChild("LeftLowerLeg"),
					abChar:FindFirstChild("RightLowerLeg"),
					abChar:FindFirstChild("LeftFoot"),
					abChar:FindFirstChild("RightFoot")
				};
				local function hideAndMoveLimbs(torsoY, legY)
					for legIdx, legObj in ipairs(abLegs) do
						if legObj then
							legObj.CFrame = CFrame.new(10000, legY, 10000);
						end
					end
					abHRP.Velocity = Vector3.zero;
					abHead.Velocity = Vector3.zero;
					abHead.CFrame = abHeadCF;
					abHRP.CFrame = abHRPCF;
					abTorso.CFrame = CFrame.new(10000, torsoY, 10000);
				end
				hideAndMoveLimbs(92, -150);
				task.wait();
				abTorso.CFrame = abTorsoCF;
				task.wait(0.1);
				hideAndMoveLimbs(-150, -200);
				task.wait(0.1);
				for waitIdx = 1, 15 do
					task.wait();
					abTorso.CFrame = abTorsoCF;
					abTorso.Velocity = Vector3.zero;
					abHRP.Velocity = Vector3.zero;
				end
				abTorso.Anchored = true;
				task.wait(2);
				abTorso.Anchored = false;
				local abHipHeight = abHumanoid;
				abHipHeight.HipHeight = 2;
				task.spawn(function()
					while _G.Headless and (abHumanoid.Health > 0) do
						task.wait(2);
						abHipHeight.HipHeight = 2;
					end
				end);
			end
			task.spawn(function()
				applyHeadless();
			end);
			task.spawn(function()
				while _G.Headless do
					abLocalPlayer.CharacterAdded:Wait();
					task.wait(0.5);
					if _G.Headless then
						applyHeadless();
					end
				end
			end);
		end
	end
});
invulnTab:AddToggle({
	Name = "Anti Lag",
	Default = false,
	Callback = function(antiLagState)
		_G.AntiLag = antiLagState;
		local alPlayers = game:GetService("Players");
		local alLocalPlayer = alPlayers.LocalPlayer;
		local function logAntiLag(logMsg)
			if LTab then
				LTab:AddLabel(logMsg);
			end
		end
		local alPlayerScripts = alLocalPlayer:FindFirstChild("PlayerScripts");
		if not alPlayerScripts then
			return;
		end
		local alCharBeamMove = alPlayerScripts:FindFirstChild("CharacterAndBeamMove");
		if not alCharBeamMove then
			return;
		end
		if antiLagState then
			alCharBeamMove.Disabled = true;
			logAntiLag(((language == "pt-br") and " - Anti Lag Ativado") or " - Anti Lag Enabled");
		else
			alCharBeamMove.Disabled = false;
			logAntiLag(((language == "pt-br") and " - Anti Lag Desativado") or " - Anti Lag Disabled");
		end
	end
});
do
	local agPlayers = game:GetService("Players");
	local agRunService = game:GetService("RunService");
	local agReplicatedStorage = Game:GetService("ReplicatedStorage");
	local agLocalPlayer = agPlayers.LocalPlayer;
	local agLPRef = agLocalPlayer;
	local agChar = agLocalPlayer.Character or agLocalPlayer.CharacterAdded:Wait() ;
	agLocalPlayer.CharacterAdded:Connect(function(agNewChar)
		agChar = agNewChar;
	end);
	local agPartsDisabled = false;
	local agHeartbeatConn;
	local function disableAllCharParts()
		if not agChar then
			return;
		end
		for descIdx2, descObj2 in ipairs(agChar:GetDescendants()) do
			if descObj2:IsA("BasePart") then
				descObj2.CanTouch = false;
				descObj2.CanCollide = false;
				descObj2.Massless = true;
			end
		end
	end
	local function startDisableParts()
		if agHeartbeatConn then
			agHeartbeatConn:Disconnect();
		end
		agHeartbeatConn = agRunService.Heartbeat:Connect(function()
			if agPartsDisabled then
				disableAllCharParts();
			end
		end);
	end
	local function stopDisableParts()
		agPartsDisabled = false;
		if agHeartbeatConn then
			agHeartbeatConn:Disconnect();
			agHeartbeatConn = nil;
		end
	end
	local agAutoGucciActive = nil;
	local agPermRagdollBusy = false;
	local agRagdollLoopActive = false;
	local agSitJumpActive = nil;
	local agRagdollBusy = false;
	local agBlobman = nil;
	function setRagdollF(ragdollState)
		local setRagChar = agLPRef.Character;
		local setRagHRP = setRagChar:WaitForChild("HumanoidRootPart");
		local setRagHumanoid = setRagChar:WaitForChild("Humanoid");
		if (setRagChar and setRagChar:FindFirstChild("HumanoidRootPart")) then
			agReplicatedStorage:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote"):FireServer(setRagHRP, (ragdollState and 1) or 0);
			if setRagHumanoid then
				setRagHumanoid.PlatformStand = ragdollState;
			end
		end
	end
	function permRagdollLoopF()
		local permChar = agLPRef.Character;
		local permHRP = permChar:WaitForChild("HumanoidRootPart");
		local permHumanoid = permChar:WaitForChild("Humanoid");
		if agPermRagdollBusy then
			return;
		end
		agPermRagdollBusy = true;
		while agAutoGucciActive do
			setRagdollF(true);
			task.wait(0.1);
		end
		agPermRagdollBusy = false;
		setRagdollF(false);
	end
	function getBlobmanF()
		local getBlobChar = agLPRef.Character;
		local getBlobHRP = getBlobChar:WaitForChild("HumanoidRootPart");
		local getBlobHumanoid = getBlobChar:WaitForChild("Humanoid");
		updateCurrentHouseF();
		if (currentHouseNum == 0) then
			if inv then
				return inv:FindFirstChild("CreatureBlobman");
			end
			return nil;
		else
			return workspace.PlotItems:FindFirstChild("Plot" .. currentHouseNum):FindFirstChild("CreatureBlobman");
		end
	end
	function spawnBlobmanF()
		local spawnBlobChar = agLPRef.Character;
		local spawnBlobHRP = spawnBlobChar:WaitForChild("HumanoidRootPart");
		local spawnBlobHumanoid = spawnBlobChar:WaitForChild("Humanoid");
		local spawnToyFunc = agReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction");
		if spawnToyFunc then
			pcall(function()
				spawnToyFunc:InvokeServer("CreatureBlobman", spawnBlobHRP.CFrame * CFrame.new(0, 0, -5), Vector3.new(0, -15.716, 0));
			end);
			task.wait(0.25);
			agBlobman = getBlobmanF();
		end
	end
	function ragdollLoopF()
		local ragLoopChar = agLPRef.Character;
		local ragLoopHRP = ragLoopChar:WaitForChild("HumanoidRootPart");
		local ragLoopHumanoid = ragLoopChar:WaitForChild("Humanoid");
		if agRagdollBusy then
			return;
		end
		agRagdollBusy = true;
		while agRagdollLoopActive do
			if (ragLoopChar and ragLoopHRP) then
				local ragUnpack = {
					[1] = ragLoopHRP,
					[2] = 0
				};
				agReplicatedStorage:WaitForChild("CharacterEvents"):WaitForChild("RagdollRemote"):FireServer(unpack(ragUnpack));
			end
			task.wait();
		end
		agRagdollBusy = false;
	end
	function sitJumpF()
		local sitChar = agLPRef.Character;
		if not sitChar then
			return;
		end
		local sitHumanoid = sitChar:FindFirstChildOfClass("Humanoid");
		local sitHRP = sitChar:FindFirstChild("HumanoidRootPart");
		if (not sitHumanoid or not sitHRP) then
			return;
		end
		local sitStartTick = tick();
		local sitJumped = false;
		while agSitJumpActive and ((tick() - sitStartTick) < 6) do
			if agBlobman then
				local blobSeat = agBlobman:FindFirstChildOfClass("VehicleSeat");
				if (blobSeat and (blobSeat.Occupant ~= sitHumanoid)) then
					blobSeat:Sit(sitHumanoid);
				end
			end
			task.wait(0.3);
			if not sitJumped then
				sitHumanoid:ChangeState(Enum.HumanoidStateType.Jumping);
				sitJumped = true;
			end
			local blobVehicleSeat = agBlobman:FindFirstChildOfClass("VehicleSeat");
			local blobBodyPos = Instance.new("BodyPosition");
			blobBodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
			blobBodyPos.Position = blobVehicleSeat.Parent:WaitForChild("HumanoidRootPart").Position + Vector3.new(0, 1000000, 100000) ;
			blobBodyPos.D = 10000000;
			blobBodyPos.P = 100000000000;
			blobBodyPos.Parent = blobVehicleSeat.Parent:WaitForChild("HumanoidRootPart");
		end
		agSitJumpActive = false;
		agRagdollLoopActive = false;
	end
	function updateCurrentHouseF()
		local updateChar = agLPRef.Character;
		local updateHRP = updateChar:WaitForChild("HumanoidRootPart");
		local updateHumanoid = updateChar:WaitForChild("Humanoid");
		if (updateChar.Parent == workspace) then
			currentHouseNum = 0;
		elseif (updateChar.Parent.Name == "PlayersInPlots") then
			for plotIdx3, plotObj3 in workspace.Plots:GetChildren() do
				for ownerIdx3, ownerObj3 in plotObj3.PlotSign.ThisPlotsOwners:GetChildren() do
					if (ownerObj3.Value == agLPRef.Name) then
						if (ownerObj3.Parent.Parent.Parent.Name == "Plot1") then
							currentHouseNum = 1;
						elseif (ownerObj3.Parent.Parent.Parent.Name == "Plot2") then
							currentHouseNum = 2;
						elseif (ownerObj3.Parent.Parent.Parent.Name == "Plot3") then
							currentHouseNum = 3;
						elseif (ownerObj3.Parent.Parent.Parent.Name == "Plot4") then
							currentHouseNum = 4;
						elseif (ownerObj3.Parent.Parent.Parent.Name == "Plot5") then
							currentHouseNum = 5;
						end
					end
				end
			end
		end
	end
	invulnTab:AddToggle({
		Name = "Auto Gucci (manutencion)",
		Default = false,
		Callback = function(autoGucciState)
			agSitJumpActive = autoGucciState;
			if agSitJumpActive then
				spawnBlobmanF();
				task.wait();
				if not agRagdollLoopActive then
					coroutine.wrap(sitJumpF)();
					agRagdollLoopActive = true;
				end
				coroutine.wrap(ragdollLoopF)();
			else
				agRagdollLoopActive = false;
			end
		end
	});
	invulnTab:AddButton({
		Name = "Ativar SkyBlobman",
		Callback = function()
			local skyPlayer = game.Players.LocalPlayer;
			local function findBlobman()
				local skySpawnedToys = workspace:FindFirstChild(skyPlayer.Name .. "SpawnedInToys");
				if (skySpawnedToys and skySpawnedToys:FindFirstChild("CreatureBlobman")) then
					return skySpawnedToys.CreatureBlobman;
				end
				if workspace:FindFirstChild("PlotItems") then
					for plotIdx4, plotObj4 in pairs(workspace.PlotItems:GetChildren()) do
						local skyBlobman = plotObj4:FindFirstChild("CreatureBlobman");
						if skyBlobman then
							return skyBlobman;
						end
					end
				end
				return nil;
			end
			local function sendBlobmanToSky()
				local skyBlobman2 = findBlobman();
				if not skyBlobman2 then
					warn("Blobman nÃ£o encontrado!");
					return;
				end
				local skyBlobHRP = skyBlobman2:FindFirstChild("HumanoidRootPart");
				if not skyBlobHRP then
					warn("Blobman sem HumanoidRootPart!");
					return;
				end
				local skyBodyPos = Instance.new("BodyPosition");
				skyBodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
				skyBodyPos.D = 10000000;
				skyBodyPos.P = 100000000000;
				skyBodyPos.Parent = skyBlobHRP;
				skyBodyPos.Position = skyBlobHRP.Position + Vector3.new(0, 1000000, 100000) ;
				print("Blobman enviado para o cÃ©u!");
			end
			sendBlobmanToSky();
		end
	});
end
local combatTab = window:MakeTab({
	Name = "Combat",
	Icon = "rbxassetid://7485051715",
	PremiumOnly = false
});
local othersTab = window:MakeTab({
	Name = "Others",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
});
local othersSection = othersTab:AddSection({
	Name = " Others "
});
local configTab = window:MakeTab({
	Name = "Configurations",
	Icon = "rbxassetid://6031280882",
	PremiumOnly = true
});
configTab:AddParagraph("Visual", "âš™ Config âš™");
local logsTab = window:MakeTab({
	Name = "Logs",
	Icon = "rbxassetid://7733687281",
	PremiumOnly = false
});
local logsSection = logsTab:AddSection({
	Name = " Script Logs "
});
services = {
	UserInputService = game:GetService("UserInputService"),
	RunService = game:GetService("RunService"),
	RP = game.ReplicatedStorage,
	Players = game.Players,
	Workspace = game.Workspace,
	ts = game:GetService("TweenService"),
	cam = workspace.CurrentCamera
};
Workspace.Map.FactoryIsland.PoisonContainer.Name = "potato";
local scriptState = {
	mutejukebox = true,
	muteboombox = true,
	blobmanCoroutine,
	strength = 400,
	poison1 = Workspace.Map.FactoryIsland.potato.PoisonHurtPart,
	poison2 = Workspace.Map.FactoryIsland.PoisonContainer.PoisonHurtPart,
	poison3 = Workspace.Map.Hole.PoisonBigHole.PoisonHurtPart,
	poison4 = Workspace.Map.Hole.PoisonSmallHole.PoisonHurtPart,
	inv = Workspace:FindFirstChild(game.Players.LocalPlayer.Name .. "SpawnedInToys"),
	UFO = nil,
	levelofantilagfps = 10,
	levelofantilag = 0.2,
	AutoLag = true,
	fpsdelayvalue = 2,
	animation = true,
	toggleantilag = nil,
	localPlayer = services.Players.LocalPlayer,
	character = services.Players.LocalPlayer.Character or services.Players.LocalPlayer.CharacterAdded:Wait(),
	IsHeld = services.Players.LocalPlayer.IsHeld,
	humanoid = nil,
	ExtinguishPart = services.Workspace.Map.Hole.PoisonBigHole.ExtinguishPart,
	fireDebounce = nil,
	Antigrab = false,
	antifire = false,
	antiexplode = false,
	hrp = nil
};
local ufoSuccess, ufoPart = pcall(function()
	return workspace.Map.AlwaysHereTweenedObjects:WaitForChild("OuterUFO", 1):WaitForChild("Object", 1):WaitForChild("ObjectModel", 1);
end);
if (ufoSuccess and ufoPart) then
	scriptState.UFO = ufoPart:FindFirstChild("PaintPlayerPart");
else
	local fallbackPart = Instance.new("Part");
	fallbackPart.Size = Vector3.new(0.1, 0.1, 0.1);
	fallbackPart.Position = Vector3.new(0, 10, 0);
	fallbackPart.Anchored = true;
	fallbackPart.Transparency = 1;
	fallbackPart.CanCollide = false;
	fallbackPart.Parent = workspace;
	scriptState.UFO = fallbackPart;
end
scriptState.hrp = scriptState.character:WaitForChild("HumanoidRootPart");
scriptState.humanoid = scriptState.character:WaitForChild("Humanoid");
scriptState.fireDebounce = scriptState.humanoid:WaitForChild("FireDebounce");
scriptState.poison1.Size = Vector3.new(2, 2, 2);
scriptState.poison2.Size = Vector3.new(2, 2, 2);
scriptState.poison3.Size = Vector3.new(2, 2, 2);
scriptState.poison4.Size = Vector3.new(2, 2, 2);
local logPrefix = " ";
if (language == "pt-br") then
	logsTab:AddLabel(logPrefix .. " - Variaveis Carregadas");
else
	logsTab:AddLabel(logPrefix .. " - Variables Loadded");
end
fps = nil;
services.RunService.RenderStepped:Connect(function(renderStep)
	fps = math.floor(1 / renderStep);
end);
local lastGrabTime = 0;
local function AutoAntiLagHandler(newDescendant)
	if (newDescendant.Name == "GrabPart") then
		currenttime = os.time();
		if (((currenttime - lastGrabTime) < scriptState.levelofantilag) and (fps < scriptState.levelofantilagfps) and scriptState.AutoLag) then
			scriptState.LocalPlayer.PlayerScripts.CharacterAndBeamMove.Disabled = true;
			for grabPartsIdx, grabPartsObj in pairs(workspace:GetDescendants()) do
				if (grabPartsObj.Name == "GrabParts") then
					grabPartsObj:Destroy();
				end
			end
			wait(20);
			scriptState.LocalPlayer.PlayerScripts.CharacterAndBeamMove.Disabled = false;
		end
		lastGrabTime = currenttime;
	end
	if ((newDescendant.Name == "Boombox") and scriptState.muteboombox) then
		newDescendant:WaitForChild("Speaker"):Destroy();
	end
	if ((newDescendant.Name == "JukeboxOrange") or (newDescendant.Name == "JukeboxBlue") or ((newDescendant.Name == "Jukebox") and scriptState.mutejukebox)) then
		newDescendant:WaitForChild("SpeakerPart"):Destroy();
	end
end
currenttime = " ";
if (language == "pt-br") then
	logsTab:AddLabel(logPrefix .. " - Auto anti-lag carregado");
else
	logsTab:AddLabel(logPrefix .. " - Auto anti-lag Loadded");
end
game:GetService("Workspace").DescendantAdded:Connect(AutoAntiLagHandler);
local function SetupFireHandler()
	if scriptState.fireDebounce then
		scriptState.fireDebounce.Changed:Connect(function(fireDebounceVal)
			if ((fireDebounceVal == true) and scriptState.antifire) then
				scriptState.ExtinguishPart.CFrame = scriptState.hrp.CFrame;
				task.wait();
				scriptState.ExtinguishPart.CFrame = CFrame.new(58.0753174, -71.4460449, 271.346924, -1.1920929e-7, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-7);
			end
		end);
	end
end
SetupFireHandler();
currenttime = " ";
if (language == "pt-br") then
	logsTab:AddLabel(logPrefix .. " - Personagem detectado");
else
	logsTab:AddLabel(logPrefix .. " - Character detected");
end
scriptState.localPlayer.CharacterAdded:Connect(function(newChar2)
	currenttime = " ";
	if (language == "pt-br") then
		logsTab:AddLabel(logPrefix .. " - Novo character detetcado");
	else
		logsTab:AddLabel(logPrefix .. " - new Character Detected");
	end
	scriptState.character = newChar2;
	scriptState.hrp = newChar2:WaitForChild("HumanoidRootPart");
	scriptState.humanoid = newChar2:WaitForChild("Humanoid");
	scriptState.fireDebounce = scriptState.humanoid:WaitForChild("FireDebounce");
	SetupFireHandler();
end);
local remotes = {
	DestroyToy = services.RP:WaitForChild("MenuToys").DestroyToy,
	spawntoy = services.RP.MenuToys.SpawnToyRemoteFunction,
	GrabEvents = services.RP:WaitForChild("GrabEvents"),
	MenuToys = services.RP:WaitForChild("MenuToys"),
	CharacterEvents = services.RP:WaitForChild("CharacterEvents"),
	SetNetworkOwner = nil,
	ragdoll_remote = nil,
	Struggle = nil,
	CreateLine = nil,
	DestroyLine = nil
};
remotes.SetNetworkOwner = remotes.GrabEvents:WaitForChild("SetNetworkOwner");
remotes.ragdoll_remote = remotes.CharacterEvents:WaitForChild("RagdollRemote");
remotes.Struggle = remotes.CharacterEvents:WaitForChild("Struggle");
remotes.CreateLine = remotes.GrabEvents:WaitForChild("CreateGrabLine");
remotes.DestroyLine = remotes.GrabEvents:WaitForChild("DestroyGrabLine");
if (language == "pt-br") then
else
end
configTab:AddToggle({
	Name = "Tittle Animation",
	Default = true,
	Callback = function(animState)
		animationEnabled = animState;
		_G.bloquear = not animationEnabled;
		if not animationEnabled then
			SetTitle(hubTitle);
		end
	end
});
configTab:AddToggle({
	Name = "Enable Sound",
	Default = false,
	Callback = function(soundState)
		_G.somAtivo = soundState;
	end
});
configTab:AddToggle({
	Name = "Show FPS",
	Default = true,
	Callback = function(fpsState)
		_G.mostrarFps = fpsState;
	end
});
configTab:AddToggle({
	Name = "Show Time",
	Default = true,
	Callback = function(timeState)
		_G.mostrarHorario = timeState;
	end
});
Workspace.ChildAdded:Connect(function(childArg)
end);
function setupHeadListener(targetChar, targetPlayer)
	local targetHead = targetChar:WaitForChild("Head", 5);
	if not targetHead then
		return;
	end
	local ufoRef = scriptState.UFO;
	if ufoRef then
		ufoRef.Size = Vector3.new(2, 2, 2);
	else
		ufoRef = scriptState.poison1;
	end
	targetHead.ChildAdded:Connect(function(headChild)
	end);
end
function onPlayerAdded(newPlayer)
	if (newPlayer == scriptState.localPlayer) then
		return;
	end
	local function onPlayerCharAdded(playerChar)
		setupHeadListener(playerChar, newPlayer);
	end
	if newPlayer.Character then
		onPlayerCharAdded(newPlayer.Character);
	end
	newPlayer.CharacterAdded:Connect(onPlayerCharAdded);
	newPlayer.CharacterRemoving:Connect(function()
		local paintPlayerPart = scriptState.UFO:FindFirstChild("PaintPlayerPart");
		if paintPlayerPart then
			paintPlayerPart.CFrame = CFrame.new(100, 100000, 10000);
		end
	end);
end
for playerIdx, currentPlayer in ipairs(services.Players:GetPlayers()) do
	onPlayerAdded(currentPlayer);
end
services.Players.PlayerAdded:Connect(onPlayerAdded);
workspace.ChildAdded:Connect(function(workspaceChild)
	if ((workspaceChild.Name == "Part") and ((workspaceChild.Position - game:service("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 18) and scriptState.antiexplode) then
		game:service("Players").LocalPlayer.Character.HumanoidRootPart.Anchored = true;
		game:service("Players").LocalPlayer.Character.Humanoid.AutoRotate = true;
		game:service("ContextActionService"):UnbindAction("JumpRemover");
		game:service("Players").LocalPlayer.Character.Humanoid.Sit = false;
		for torsoDescIdx, torsoDescObj in pairs(game:service("Players").LocalPlayer.Character.Torso:GetDescendants()) do
			if torsoDescObj:IsA("Motor6D") then
				torsoDescObj.Enabled = true;
			end
		end
		scriptState.hrp.Anchored = false;
	end
end);
local mouseRightClickFlag = false;
services.UserInputService.InputBegan:Connect(function(inputObj, isTyping)
	if isTyping then
		return;
	end
	if (inputObj.UserInputType == Enum.UserInputType.MouseButton2) then
		mouseRightClickFlag = true;
		task.delay(0.2, function()
			mouseRightClickFlag = false;
		end);
	end
end);
local mouseRightClickTick = 0;
services.UserInputService.InputBegan:Connect(function(inputObj2, isTyping2)
	if isTyping2 then
		return;
	end
	if (inputObj2.UserInputType == Enum.UserInputType.MouseButton2) then
		mouseRightClickTick = tick();
	end
end);
_G.KillGrab = false;
grabsTab:AddToggle({
	Name = "Kill Grab",
	Default = false,
	Callback = function(killGrabState)
		_G.KillGrab = killGrabState;
		if killGrabState then
			task.spawn(function()
				while _G.KillGrab do
					for playerIdx2, playerObj2 in ipairs(game:GetService("Players"):GetPlayers()) do
						if (playerObj2 ~= game.Players.LocalPlayer) then
							local targetChar2 = playerObj2.Character or playerObj2.CharacterAdded:Wait() ;
							if targetChar2 then
								local targetHumanoid = targetChar2:FindFirstChild("Humanoid");
								if targetHumanoid then
									targetHumanoid.BreakJointsOnDeath = false;
									targetHumanoid:ChangeState(Enum.HumanoidStateType.Dead);
								end
							end
						end
					end
					task.wait();
				end
			end);
		end
	end
});
grabsTab:AddToggle({
	Name = "Invisible grab",
	Default = false,
	Callback = function(grabInvisibleState)
		_G.GrabInvisible = grabInvisibleState;
		if grabInvisibleState then
			local grabPartsFolder = workspace:FindFirstChild("GrabParts");
			if grabPartsFolder then
				local beamPart = grabPartsFolder:FindFirstChild("BeamPart");
				local dragPart = grabPartsFolder:FindFirstChild("DragPart");
				local grabPart = grabPartsFolder:FindFirstChild("GrabPart");
				if beamPart then
					beamPart:Destroy();
				end
				if dragPart then
					dragPart.Transparency = 1;
				end
				if grabPart then
					grabPart.Transparency = 1;
				end
				ReplicatedStorage.GrabEvents.CreateGrabLine:FireServer();
				LocalPlayer.PlayerScripts.CharacterAndBeamMove.GrabNotifyEvent:Fire(false);
			end
		end
		workspace.ChildAdded:Connect(function()
			if not _G.GrabInvisible then
				return;
			end
			local giGrabParts = workspace:FindFirstChild("GrabParts");
			if not giGrabParts then
				return;
			end
			local giBeamPart = giGrabParts:FindFirstChild("BeamPart");
			local giDragPart = giGrabParts:FindFirstChild("DragPart");
			local giGrabPart = giGrabParts:FindFirstChild("GrabPart");
			if giBeamPart then
				giBeamPart:Destroy();
			end
			if giDragPart then
				giDragPart.Transparency = 1;
			end
			if giGrabPart then
				giGrabPart.Transparency = 1;
			end
			ReplicatedStorage.GrabEvents.CreateGrabLine:FireServer();
			LocalPlayer.PlayerScripts.CharacterAndBeamMove.GrabNotifyEvent:Fire(false);
		end);
	end
});
grabsTab:AddToggle({
	Name = "Grab Noclip",
	Default = false,
	Callback = function(grabNoclipState)
		_G.GrabNoclip = grabNoclipState;
		workspace.ChildAdded:Connect(function()
			if not _G.GrabNoclip then
				return;
			end
			local gnGrabParts = workspace:FindFirstChild("GrabParts");
			if not gnGrabParts then
				return;
			end
			local gnGrabPart = gnGrabParts:FindFirstChild("GrabPart");
			if (not gnGrabPart or not gnGrabPart:FindFirstChild("WeldConstraint")) then
				return;
			end
			local gnPart1 = gnGrabPart.WeldConstraint.Part1;
			if (not gnPart1 or not gnPart1.Parent) then
				return;
			end
			pcall(function()
				local gnTargetModel = gnPart1.Parent;
				if gnTargetModel:FindFirstChild("Humanoid") then
					if gnTargetModel:FindFirstChild("Torso") then
						gnTargetModel.HumanoidRootPart.CanCollide = false;
						gnTargetModel.Torso.CanCollide = false;
						for partIdx3, partObj3 in pairs(gnTargetModel:GetChildren()) do
							if partObj3:IsA("BasePart") then
								partObj3.CanCollide = false;
							end
						end
						repeat
							task.wait();
						until not workspace:FindFirstChild("GrabParts") or not _G.GrabNoclip
						gnTargetModel.Torso.CanCollide = true;
					else
						for partIdx4, partObj4 in pairs(gnTargetModel:GetChildren()) do
							if partObj4:IsA("BasePart") then
								partObj4.CanCollide = false;
							end
						end
						repeat
							task.wait();
						until not workspace:FindFirstChild("GrabParts") or not _G.GrabNoclip
						for partIdx5, partObj5 in pairs(gnTargetModel:GetChildren()) do
							if partObj5:IsA("BasePart") then
								partObj5.CanCollide = true;
							end
						end
					end
				else
					local gnAncestorModel = gnPart1:FindFirstAncestorWhichIsA("Model");
					if gnAncestorModel then
						for partIdx6, partObj6 in pairs(gnAncestorModel:GetChildren()) do
							if (partObj6:IsA("BasePart") and partObj6.CanCollide) then
								partObj6.CanCollide = false;
							end
						end
						repeat
							task.wait();
						until not workspace:FindFirstChild("GrabParts") or not _G.GrabNoclip
						for partIdx7, partObj7 in pairs(gnAncestorModel:GetChildren()) do
							if partObj7:IsA("BasePart") then
								partObj7.CanCollide = true;
							end
						end
					end
				end
			end);
		end);
	end
});
grabsTab:AddToggle({
	Name = "MassLess Grab",
	Default = false,
	Callback = function(masslessGrabState)
		MassLessGrab = masslessGrabState;
		if MassLessGrab then
			connections['MLChild'] = workspace.ChildAdded:Connect(function(mlChild)
				if (mlChild.Name == "GrabParts") then
					local mlGrabPart = mlChild.GrabPart.WeldConstraint.Part1;
					local mlDragPart = WaitForChildCustom(mlChild, "DragPart");
					mlDragPart.AlignOrientation.MaxTorque = "inf";
					mlDragPart.AlignOrientation.Responsiveness = 200;
					mlDragPart.AlignPosition.MaxForce = "inf";
					mlDragPart.AlignPosition.Responsiveness = 200;
				end
			end);
		else
			DisconnectConnection("MLChild");
		end
	end
});
grabsTab:AddToggle({
	Name = "Ragdoll Grab",
	Default = false,
	Callback = function(ragdollGrabState)
		RagdollGrab = ragdollGrabState;
		if RagdollGrab then
			if not spawnedInToys:FindFirstChild("Ragdoll") then
				local rgPallet = SpawnToyAndWait("PalletLightBrown", WaitForChildCustom(LocalPlayer.Character, "Head"), "headup");
				local rgSoundPart = rgPallet:WaitForChild("SoundPart");
				while (rgSoundPart and not rgSoundPart:FindFirstChild("PartOwner")) or (rgSoundPart:FindFirstChild("PartOwner") and (rgSoundPart:FindFirstChild("PartOwner").Value ~= LocalPlayer.Name)) do
					task.spawn(SetNetworkOwner, rgSoundPart);
					task.wait();
				end
				local rgBodyVelocity = Instance.new("BodyVelocity");
				rgBodyVelocity.Parent = rgSoundPart;
				rgBodyVelocity.MaxForce = Vector3.new(0, "inf", 0);
				rgBodyVelocity.Velocity = Vector3.new(0, 1000, 0);
				for rgPartIdx, rgPartObj in pairs(rgPallet:GetChildren()) do
					if rgPartObj:IsA("BasePart") then
						rgPartObj.Transparency = 1;
						rgPartObj.Size = Vector3.new(0.5, 0.5, 0.5);
					end
				end
				if rgSoundPart:FindFirstChild("Wood") then
					rgSoundPart.Wood:Destroy();
				end
				rgPallet.Name = "Ragdoll";
				local rgSlotIdx = nil;
				for rgToyIdx, rgToyObj in pairs(spawnedInToys:GetChildren()) do
					if (rgToyObj.Name == "Ragdoll") then
						rgSlotIdx = rgToyIdx;
					end
				end
				local rgToyDestroy = LocalPlayer.PlayerGui.MenuGui.Menu.TabContents.ToyDestroy.Contents;
				for rgUIToyIdx, rgUIToyObj in ipairs(rgToyDestroy:GetChildren()) do
					if ((rgUIToyObj.Name == "PalletLightBrown") and (rgUIToyIdx == rgSlotIdx)) then
						local rgViewButton = rgUIToyObj.ViewItemButton;
						rgViewButton.Text = "RAGDOLL";
						rgViewButton.TextScaled = true;
						rgViewButton.LowResImage.Image = "";
					end
				end
			end
			connections['RagdollGrab'] = workspace.ChildAdded:Connect(function(rgGrabParts)
				if RagdollGrab then
					if (rgGrabParts.Name == "GrabParts") then
						local rgPart1 = rgGrabParts.GrabPart.WeldConstraint.Part1;
						local rgTargetHRP = rgPart1.Parent:FindFirstChild("HumanoidRootPart");
						if rgPart1.Parent:FindFirstChild("HumanoidRootPart") then
							firetouchinterest(spawnedInToys:FindFirstChild("Ragdoll").SoundPart, rgPart1.Parent.Head, 0);
						end
					end
				end
			end);
		else
			DisconnectConnection("RagdollGrab");
		end
	end
});
_G.CotocoGrabEnabled = false;
_G.CotocoLimbsToRemove = {
	LeftLeg = false,
	RightLeg = false,
	LeftArm = false,
	RightArm = false
};
local cotocoConnection = nil;
grabsTab:AddToggle({
	Name = "Cotoco Grab",
	Default = false,
	Callback = function(cotocoState)
		_G.CotocoGrabEnabled = cotocoState;
		if cotocoState then
			cotocoConnection = Workspace.ChildAdded:Connect(function(cotocoGrabParts)
				if not _G.CotocoGrabEnabled then
					return;
				end
				if (cotocoGrabParts.Name ~= "GrabParts") then
					return;
				end
				task.wait();
				local cotocoGrabPart = cotocoGrabParts:FindFirstChild("GrabPart");
				if not cotocoGrabPart then
					return;
				end
				local cotocoWeld = cotocoGrabPart:FindFirstChildWhichIsA("WeldConstraint");
				if (not cotocoWeld or not cotocoWeld.Part1) then
					return;
				end
				local cotocoModel = cotocoWeld.Part1.Parent;
				if not cotocoModel then
					return;
				end
				local cotocoHumanoid = cotocoModel:FindFirstChild("Humanoid");
				local cotocoHRP = cotocoModel:FindFirstChild("HumanoidRootPart");
				local cotocoDestroyed = false;
				cotocoGrabParts.AncestryChanged:Connect(function(cotocoChild, cotocoParent)
					if not cotocoParent then
						cotocoDestroyed = true;
					end
				end);
				if (not cotocoHumanoid or not cotocoHRP) then
					return;
				end
				local function cotocoShouldStop()
					return cotocoDestroyed or not _G.CotocoGrabEnabled ;
				end
				local cotocoHead = cotocoModel:WaitForChild("Head", 3);
				if (not cotocoHead or cotocoShouldStop()) then
					return;
				end
				local cotocoTorso = cotocoModel:FindFirstChild("Torso");
				if not cotocoTorso then
					return;
				end
				local cotocoTorsoCF = cotocoTorso.CFrame;
				local cotocoHeadCF = cotocoHead.CFrame;
				local cotocoHRPCF = cotocoHRP.CFrame;
				if cotocoShouldStop() then
					return;
				end
				local cotocoBallSocket = cotocoHead:WaitForChild("BallSocketConstraint", 3);
				if (not cotocoBallSocket or cotocoShouldStop()) then
					return;
				end
				repeat
					task.wait();
					if cotocoShouldStop() then
						return;
					end
				until (cotocoBallSocket.Enabled == true) or (cotocoBallSocket.Active == true)
				cotocoHRP.Velocity = Vector3.zero;
				local cotocoLimbs = {};
				if _G.CotocoLimbsToRemove.LeftLeg then
					local cotocoLeftLeg = cotocoModel:FindFirstChild("Left Leg");
					if cotocoLeftLeg then
						table.insert(cotocoLimbs, cotocoLeftLeg);
					end
				end
				if _G.CotocoLimbsToRemove.RightLeg then
					local cotocoRightLeg = cotocoModel:FindFirstChild("Right Leg");
					if cotocoRightLeg then
						table.insert(cotocoLimbs, cotocoRightLeg);
					end
				end
				if _G.CotocoLimbsToRemove.LeftArm then
					local cotocoLeftArm = cotocoModel:FindFirstChild("Left Arm");
					if cotocoLeftArm then
						table.insert(cotocoLimbs, cotocoLeftArm);
					end
				end
				if _G.CotocoLimbsToRemove.RightArm then
					local cotocoRightArm = cotocoModel:FindFirstChild("Right Arm");
					if cotocoRightArm then
						table.insert(cotocoLimbs, cotocoRightArm);
					end
				end
				local function cotocoMoveLimbs(cotocoTorsoY, cotocoLimbsY)
					if cotocoShouldStop() then
						return;
					end
					for cotocoLimbIdx, cotocoLimbObj in ipairs(cotocoLimbs) do
						if cotocoLimbObj then
							cotocoLimbObj.CFrame = CFrame.new(10000, cotocoLimbsY, 10000);
						end
					end
					cotocoHRP.Velocity = Vector3.zero;
					cotocoHead.Velocity = Vector3.zero;
					cotocoHead.CFrame = cotocoHeadCF;
					cotocoHRP.CFrame = cotocoHRPCF;
					cotocoTorso.CFrame = CFrame.new(10000, cotocoTorsoY, 10000);
				end
				cotocoMoveLimbs(92, 102);
				if cotocoShouldStop() then
					return;
				end
				task.wait();
				cotocoTorso.CFrame = cotocoTorsoCF;
				task.wait(0.5);
				if cotocoShouldStop() then
					return;
				end
				cotocoMoveLimbs(-150, 102);
				task.wait(0.1);
				cotocoTorso.Anchored = true;
				cotocoHRP.Anchored = true;
				for cotocoWaitIdx = 1, 15 do
					cotocoTorso.Velocity = Vector3.zero;
					cotocoHRP.Velocity = Vector3.zero;
					cotocoHead.Velocity = Vector3.zero;
					cotocoTorso.CFrame = cotocoTorsoCF;
					cotocoHRP.CFrame = cotocoHRPCF;
				end
				cotocoTorso.Anchored = false;
				cotocoHRP.Anchored = false;
			end);
			local cotocoLog = " ";
			if (language == "pt-br") then
				logsTab:AddLabel(cotocoLog .. " - Cotoco Grab Ativado");
			else
				logsTab:AddLabel(cotocoLog .. " - Cotoco Grab Enabled");
			end
		else
			if cotocoConnection then
				cotocoConnection:Disconnect();
				cotocoConnection = nil;
			end
			local cotocoDisableLog = " ";
			if (language == "pt-br") then
				logsTab:AddLabel(cotocoDisableLog .. " - Cotoco Grab Desativado");
			else
				logsTab:AddLabel(cotocoDisableLog .. " - Cotoco Grab Disabled");
			end
		end
	end
});
grabsTab:AddSection({
	Name = "Cotoco Limb Selection"
});
grabsTab:AddToggle({
	Name = "Remove Left Leg",
	Default = false,
	Callback = function(leftLegState)
		_G.CotocoLimbsToRemove.LeftLeg = leftLegState;
		local leftLegLog = " ";
		if (language == "pt-br") then
			logsTab:AddLabel(leftLegLog .. " - Perna Esquerda: " .. ((leftLegState and "Ativada") or "Desativada"));
		else
			logsTab:AddLabel(leftLegLog .. " - Left Leg: " .. ((leftLegState and "Enabled") or "Disabled"));
		end
	end
});
grabsTab:AddToggle({
	Name = "Remove Right Leg",
	Default = false,
	Callback = function(rightLegState)
		_G.CotocoLimbsToRemove.RightLeg = rightLegState;
		local rightLegLog = " ";
		if (language == "pt-br") then
			logsTab:AddLabel(rightLegLog .. " - Perna Direita: " .. ((rightLegState and "Ativada") or "Desativada"));
		else
			logsTab:AddLabel(rightLegLog .. " - Right Leg: " .. ((rightLegState and "Enabled") or "Disabled"));
		end
	end
});
grabsTab:AddToggle({
	Name = "Remove Left Arm",
	Default = false,
	Callback = function(leftArmState)
		_G.CotocoLimbsToRemove.LeftArm = leftArmState;
		local leftArmLog = " ";
		if (language == "pt-br") then
			logsTab:AddLabel(leftArmLog .. " - BraÃ§o Esquerdo: " .. ((leftArmState and "Ativado") or "Desativado"));
		else
			logsTab:AddLabel(leftArmLog .. " - Left Arm: " .. ((leftArmState and "Enabled") or "Disabled"));
		end
	end
});
grabsTab:AddToggle({
	Name = "Remove Right Arm",
	Default = false,
	Callback = function(rightArmState)
		_G.CotocoLimbsToRemove.RightArm = rightArmState;
		local rightArmLog = " ";
		if (language == "pt-br") then
			logsTab:AddLabel(rightArmLog .. " - BraÃ§o Direito: " .. ((rightArmState and "Ativado") or "Desativado"));
		else
			logsTab:AddLabel(rightArmLog .. " - Right Arm: " .. ((rightArmState and "Enabled") or "Disabled"));
		end
	end
});
grabsTab:AddButton({
	Name = "Select All Limbs",
	Callback = function()
		_G.CotocoLimbsToRemove.LeftLeg = true;
		_G.CotocoLimbsToRemove.RightLeg = true;
		_G.CotocoLimbsToRemove.LeftArm = true;
		_G.CotocoLimbsToRemove.RightArm = true;
		if (language == "pt-br") then
		else
		end
	end
});
grabsTab:AddButton({
	Name = "Deselect All Limbs",
	Callback = function()
		_G.CotocoLimbsToRemove.LeftLeg = false;
		_G.CotocoLimbsToRemove.RightLeg = false;
		_G.CotocoLimbsToRemove.LeftArm = false;
		_G.CotocoLimbsToRemove.RightArm = false;
		if (language == "pt-br") then
		else
		end
	end
});
_G.AntiBanana = false;
local antiBanana = false;
grabsTab:AddToggle({
	Name = "Super Strength",
	Default = false,
	Callback = function(superStrengthState)
		if superStrengthState then
			strConnection = services.Workspace.ChildAdded:Connect(function(ssGrabParts)
				if (ssGrabParts.Name ~= "GrabParts") then
					return;
				end
				local ssPart1 = ssGrabParts:FindFirstChild("GrabPart") and ssGrabParts.GrabPart:FindFirstChild("WeldConstraint") and ssGrabParts.GrabPart.WeldConstraint.Part1 ;
				if not ssPart1 then
					return;
				end
				local ssBodyVelocity = Instance.new("BodyVelocity");
				ssBodyVelocity.MaxForce = Vector3.new();
				ssBodyVelocity.Velocity = Vector3.zero;
				ssBodyVelocity.Parent = ssPart1;
				ssGrabParts:GetPropertyChangedSignal("Parent"):Connect(function()
					if ssGrabParts.Parent then
						return;
					end
					if (services.UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton2) then
						ssBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
						ssBodyVelocity.Velocity = services.cam.CFrame.LookVector * scriptState.strength ;
						task.delay(2, function()
							if (ssBodyVelocity and ssBodyVelocity.Parent) then
								ssBodyVelocity:Destroy();
							end
						end);
					else
						ssBodyVelocity:Destroy();
					end
				end);
			end);
		elseif strConnection then
			strConnection:Disconnect();
		end
	end
});
grabsTab:AddSlider({
	Name = "Strength",
	Min = 10,
	Max = 10000,
	ValueName = "",
	Increment = 1,
	Default = scriptState.strength,
	Save = true,
	Flag = "StrengthSlider",
	Callback = function(strengthVal)
		scriptState.strength = strengthVal;
	end
});
scriptState.IsHeld.Changed:Connect(function()
	while scriptState.IsHeld.Value and scriptState.Antigrab do
		scriptState.hrp.Anchored = true;
		remotes.Struggle:FireServer();
		remotes.ragdoll_remote:FireServer(scriptState.hrp, 0);
		task.wait();
	end
	scriptState.hrp.Anchored = false;
end);
invulnTab:AddToggle({
	Name = "Anti-Grab",
	Default = false,
	Callback = function(antiGrabState)
		scriptState.Antigrab = antiGrabState;
	end
});
invulnTab:AddToggle({
	Name = "Anti-Explode",
	Default = false,
	Callback = function(antiExplodeState)
		scriptState.antiexplode = antiExplodeState;
	end
});
local antiFlingConnections = {};
local function clearAntiFlingConnections()
	for afConnIdx, afConnObj in pairs(antiFlingConnections) do
		afConnObj:Disconnect();
	end
	table.clear(antiFlingConnections);
end
local function tryBlobDrop(afHumanoid, afCharacter)
	if (afHumanoid.Sit and afHumanoid.SeatPart and (afHumanoid.SeatPart.Parent.Name == "CreatureBlobman")) then
		local afBlobman = afHumanoid.SeatPart.Parent;
		local afBlobmanScript = afBlobman:FindFirstChild("BlobmanSeatAndOwnerScript");
		if afBlobmanScript then
			local afCreatureGrab = afBlobmanScript:FindFirstChild("CreatureGrab");
			local afCreatureDrop = afBlobmanScript:FindFirstChild("CreatureDrop");
			if (afCreatureGrab and afCreatureDrop) then
				local afTargetHRP = afCharacter:FindFirstChild("HumanoidRootPart");
				if afTargetHRP then
					for afPartIdx, afPartObj in pairs(afBlobman:GetChildren()) do
						if afPartObj:FindFirstChildOfClass("Attachment") then
							local afAttachment = afPartObj:FindFirstChildOfClass("Attachment");
							local afUnpack = {
								[1] = afAttachment.Parent,
								[2] = afAttachment
							};
							afCreatureDrop:FireServer(unpack(afUnpack));
						end
					end
				end
			end
		end
	end
end
local function setupPlayerAntiFling(afTargetPlayer)
	if (afTargetPlayer == scriptState.LocalPlayer) then
		return;
	end
	local function afOnCharacterAdded(afNewChar)
		local afNewHumanoid = afNewChar:WaitForChild("Humanoid", 5);
		if not afNewHumanoid then
			return;
		end
		tryBlobDrop(afNewHumanoid, afNewChar);
		local afSitChanged = afNewHumanoid:GetPropertyChangedSignal("Sit"):Connect(function()
			tryBlobDrop(afNewHumanoid, afNewChar);
		end);
		table.insert(antiFlingConnections, afSitChanged);
	end
	if afTargetPlayer.Character then
		afOnCharacterAdded(afTargetPlayer.Character);
	end
	local afCharAddedConn = afTargetPlayer.CharacterAdded:Connect(afOnCharacterAdded);
	table.insert(antiFlingConnections, afCharAddedConn);
end
invulnTab:AddToggle({
	Name = "Anti Fling",
	Default = false,
	Callback = function(antiFlingState)
		_G.AntiFling = antiFlingState;
		local function setCollisionGroup(flingChar, collisionGroup)
			pcall(function()
				game:GetService("PhysicsService"):SetPartCollisionGroup(flingChar:FindFirstChild("HumanoidRootPart"), collisionGroup);
			end);
		end
		if antiFlingState then
			setCollisionGroup(LocalPlayer.Character, "PlotPlayers");
		else
			setCollisionGroup(LocalPlayer.Character, "Players");
		end
		workspace.ChildAdded:Connect(function()
			task.wait(0.02);
			if not _G.AntiFling then
				return;
			end
			local af2GrabParts = workspace:FindFirstChild("GrabParts");
			if not af2GrabParts then
				return;
			end
			local af2GrabPart = af2GrabParts:FindFirstChild("GrabPart");
			if (not af2GrabPart or not af2GrabPart:FindFirstChild("WeldConstraint")) then
				return;
			end
			local af2Part1 = af2GrabPart.WeldConstraint.Part1;
			if (not af2Part1 or not af2Part1.Parent) then
				return;
			end
			pcall(function()
				game:GetService("PhysicsService"):SetPartCollisionGroup(af2Part1.Parent:FindFirstChild("HumanoidRootPart"), "PlotItems");
			end);
			repeat
				task.wait();
			until not workspace:FindFirstChild("GrabParts")
			pcall(function()
				game:GetService("PhysicsService"):SetPartCollisionGroup(af2Part1.Parent:FindFirstChild("HumanoidRootPart"), "Items");
			end);
		end);
	end
});
invulnTab:AddToggle({
	Name = "Anti-Fire",
	Default = false,
	Callback = function(antiFireState)
		scriptState.ExtinguishPart.CFrame = scriptState.hrp.CFrame;
		task.wait();
		scriptState.ExtinguishPart.CFrame = CFrame.new(58.0753174, -71.4460449, 271.346924, -1.1920929e-7, 0, -1.00000012, 0, 1, 0, 1.00000012, 0, -1.1920929e-7);
		scriptState.antifire = antiFireState;
	end
});
invulnTab:AddToggle({
	Name = "Anti-Void",
	Default = false,
	Callback = function(antiVoidState)
		if (antiVoidState == true) then
		else
			game.Workspace.FallenPartsDestroyHeight = -100;
		end
	end
});
configTab:AddSlider({
	Name = "Fps Detection Speed",
	Min = 1,
	Max = 5,
	Default = 2,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 0.1,
	ValueName = "",
	Callback = function(fpsDelayVal)
		scriptState.fpsdelayvalue = fpsDelayVal;
	end
});
configTab:AddDropdown({
	Name = "Logs language",
	Default = language,
	Options = {
		"pt-br",
		"en"
	},
	Callback = function(logLang)
		language = logLang;
	end
});
configTab:AddToggle({
	Name = "Mute Boomboxes",
	Default = false,
	Callback = function(muteBoomboxState)
		scriptState.muteboombox = muteBoomboxState;
	end
});
configTab:AddToggle({
	Name = "Mute Jukeboxes",
	Default = false,
	Callback = function(muteJukeboxState)
		scriptState.mutejukebox = muteJukeboxState;
	end
});
configTab:AddSection({
	Name = ""
});
configTab:AddParagraph("Protection", "âš™ Config âš™");
configTab:AddToggle({
	Name = "auto anti-lag",
	Default = true,
	Callback = function(autoLagState)
		scriptState.AutoLag = autoLagState;
	end
});
configTab:AddDropdown({
	Name = "Auto anti-lag Mode",
	Default = "Mid Security",
	Options = {
		"Low security",
		"Mid Security",
		"High Security",
		"Super-High security"
	},
	Callback = function(autoLagMode)
		if (autoLagMode == "Low security") then
			scriptState.levelofantilag = 0.01;
			scriptState.levelofantilagfps = 5;
		elseif (autoLagMode == "Mid Security") then
			scriptState.levelofantilag = 0.02;
			scriptState.levelofantilagfps = 10;
		elseif (autoLagMode == "High Security") then
			scriptState.levelofantilag = 0.03;
			scriptState.levelofantilagfps = 15;
		elseif (autoLagMode == "Super-High security") then
			scriptState.levelofantilag = 0.05;
			scriptState.levelofantilagfps = 17;
		end
	end
});
_G.JerkOffActive = false;
local jerkAnimation = Instance.new("Animation");
jerkAnimation.AnimationId = "rbxassetid://168268306";
local jerkLabel = Instance.new("TextLabel");
local jerkScreenGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") or Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui) ;
jerkScreenGui.Name = "ScreenGui";
jerkScreenGui.ResetOnSpawn = false;
jerkLabel.Parent = jerkScreenGui;
jerkLabel.Size = UDim2.new(0.1, 0, 0.015, 0);
jerkLabel.Position = UDim2.new(0.458, 0, 0.477, 0);
jerkLabel.Text = "Jerk";
jerkLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
jerkLabel.BackgroundTransparency = 1;
jerkLabel.TextScaled = true;
jerkLabel.TextColor3 = Color3.new(255, 255, 255);
jerkLabel.TextStrokeTransparency = 0;
jerkLabel.Visible = false;
othersTab:AddToggle({
	Name = "JerkOff",
	Default = false,
	Callback = function(jerkOffState)
		_G.JerkOffActive = jerkOffState;
		if _G.JerkOffActive then
			jerkLabel.Visible = true;
			OrionLib:MakeNotification({
				Name = "JerkOff",
				Content = "JerkOff Enabled",
				Image = "rbxassetid://7734042071",
				Time = 2
			});
			task.spawn(function()
				while _G.JerkOffActive do
					local jerkChar = game.Players.LocalPlayer.Character;
					if (jerkChar and jerkChar:FindFirstChild("Humanoid")) then
						local jerkHumanoid = jerkChar.Humanoid;
						local jerkAnimator = jerkHumanoid:FindFirstChildOfClass("Animator");
						if not jerkAnimator then
							jerkAnimator = Instance.new("Animator", jerkHumanoid);
						end
						local jerkTrack = jerkAnimator:LoadAnimation(jerkAnimation);
						jerkTrack:Play();
						while _G.JerkOffActive and jerkChar and jerkChar.Parent and (jerkHumanoid.Health > 0) do
							jerkTrack.TimePosition = 0.3;
							task.wait(0.1);
						end
						jerkTrack:Stop();
					end
					if _G.JerkOffActive then
						game.Players.LocalPlayer.CharacterAdded:Wait();
						task.wait(0.5);
					end
				end
			end);
		else
			jerkLabel.Visible = false;
			OrionLib:MakeNotification({
				Name = "JerkOff",
				Content = "JerkOff Disabled",
				Image = "rbxassetid://7734000129",
				Time = 2
			});
		end
	end
});
othersTab:AddBind({
	Name = "Teleport",
	Default = Enum.KeyCode.Z,
	Hold = false,
	Callback = function()
		local tpLocalPlayer = game.Players.LocalPlayer;
		local tpCamera = game.Workspace.CurrentCamera;
		local tpTargetCF = nil;
		local tpCamPos = tpCamera.CFrame.Position;
		local tpLookVec = tpCamera.CFrame.LookVector * 1000 ;
		local tpRay = Ray.new(tpCamPos, tpLookVec);
		local tpHitPart, tpHitPos = game.Workspace:FindPartOnRay(tpRay, tpLocalPlayer.Character);
		if tpHitPart then
			tpTargetCF = CFrame.new(tpHitPos);
			if (tpLocalPlayer.Character and tpLocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
				tpLocalPlayer.Character.HumanoidRootPart.CFrame = tpTargetCF + Vector3.new(0, 5, 0) ;
				tpLocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero;
				tpLocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero;
			end
		else
		end
	end
});
othersTab:AddButton({
	Name = "Break Barriers",
	Callback = function()
		task.spawn(function()
			local bbDone = false;
			local bbBarrierPos = Vector3.new(263.4, -4.79, 466.8);
			local bbSpawnCF = CFrame.new(263.5, -4.5, 486.9);
			local bbConnection;
			bbConnection = workspace.ChildAdded:Connect(function(bbChild)
				if bbDone then
					bbConnection:Disconnect();
					return;
				end
				if ((bbChild.Name == "Part") and ((bbChild.Position - bbBarrierPos).Magnitude <= 2)) then
					bbDone = true;
					bbConnection:Disconnect();
					OrionLib:MakeNotification({
						Name = ((language == "pt-br") and "Sucesso!") or "Success!",
						Content = ((language == "pt-br") and "Barreiras destruÃ­das!") or "Barriers destroyed!",
						Image = "rbxassetid://4483345998",
						Time = 3
					});
					for bbPlotIdx, bbPlotObj in pairs(workspace.Plots:GetChildren()) do
						if bbPlotObj:FindFirstChild("Barrier") then
							for bbBarrierIdx, bbBarrierObj in pairs(bbPlotObj.Barrier:GetChildren()) do
								if (bbBarrierObj:IsA("BasePart") and bbBarrierObj.CanCollide) then
									bbBarrierObj.CanCollide = false;
								end
							end
						end
					end
				end
			end);
			local bbStartTick = tick();
			repeat
				ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("BallSnowball", bbSpawnCF, Vector3.new(0, 0, 0));
				task.wait(1);
			until bbDone or ((tick() - bbStartTick) > 10)
			if not bbDone then
				bbConnection:Disconnect();
				OrionLib:MakeNotification({
					Name = "âŒ Erro",
					Content = ((language == "pt-br") and "Falhou! Tente novamente.") or "Failed! Try again.",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
			end
		end);
	end
});
othersTab:AddToggle({
	Name = "Safe Reset",
	Default = false,
	Callback = function(safeResetState)
		_G.SafeReset = safeResetState;
		if safeResetState then
			local srBindable = Instance.new("BindableEvent");
			srBindable.Event:Connect(function()
				OrionLib:MakeNotification({
					Name = "Event!",
					Content = ((language == "pt-br") and "Safe Reset disparado!") or "Safe Reset Fired!",
					Image = "rbxassetid://7734056411",
					Time = 3
				});
				local srChar = LocalPlayer.Character;
				if not srChar then
					return;
				end
				local srHumanoid = srChar:FindFirstChild("Humanoid");
				if not srHumanoid then
					return;
				end
				local srDied = false;
				srHumanoid.Died:Once(function()
					srDied = true;
				end);
				srChar:BreakJoints();
				local srWaitStart = tick();
				repeat
					task.wait();
				until srDied or ((tick() - srWaitStart) > 5)
			end);
			game:GetService("StarterGui"):SetCore("ResetButtonCallback", srBindable);
		else
			local srDefaultBindable = Instance.new("BindableEvent");
			srDefaultBindable.Event:Connect(function()
				LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead);
			end);
			game:GetService("StarterGui"):SetCore("ResetButtonCallback", srDefaultBindable);
		end
	end
});
othersTab:AddToggle({
	Name = "3rd Person View",
	Default = false,
	Callback = function(thirdPersonState)
		local tpPlayers = game:GetService("Players");
		local tpLocalPlayer2 = tpPlayers.LocalPlayer;
		local tpCam = game:GetService("Workspace").CurrentCamera;
		if thirdPersonState then
			tpLocalPlayer2.CameraMode = Enum.CameraMode.Classic;
			tpCam.CameraType = Enum.CameraType.Custom;
			tpCam.CameraSubject = tpLocalPlayer2.Character:WaitForChild("Humanoid");
			tpLocalPlayer2.CameraMaxZoomDistance = 16456456546;
			tpLocalPlayer2.CameraMinZoomDistance = 0.5;
		else
			tpLocalPlayer2.CameraMode = Enum.CameraMode.LockFirstPerson;
			tpCam.CameraType = Enum.CameraType.Custom;
			tpCam.CameraSubject = tpLocalPlayer2.Character:WaitForChild("Humanoid");
			tpLocalPlayer2.CameraMaxZoomDistance = 0;
			tpLocalPlayer2.CameraMinZoomDistance = 0;
		end
	end
});
function moveCloser(startPos, targetPos, distance)
	local direction = (targetPos - startPos).Unit;
	return startPos + (direction * distance) ;
end
local kickNotifyActive = false;
othersTab:AddToggle({
	Name = "Kick Notify",
	Default = false,
	Callback = function(kickNotifyState)
		kickNotifyActive = kickNotifyState;
		if kickNotifyActive then
			connections['KickNotify'] = workspace.ChildAdded:Connect(function(knChild)
				if (knChild.Name == "BlackHoleKick") then
					local knNames = {};
					local knDisplayNames = {};
					knChild.Name = "BlackHoleDetected";
					for knPIdx, knPObj in pairs(Players:GetPlayers()) do
						table.insert(knNames, knPObj.Name);
						table.insert(knDisplayNames, knPObj.DisplayName);
					end
					task.wait(3.25);
					if ((# knNames - # Players:GetPlayers()) > 1) then
						OrionLib:MakeNotification({
							Name = "Error Kicked " .. (# knNames - # Players:GetPlayers()),
							Content = "Script dont understand who get kicked",
							Image = "rbxassetid://4483362458",
							Time = 5
						});
						return;
					end
					for knCheckIdx, knCheckObj in Players:GetPlayers() do
						if (knCheckObj.Name ~= knNames[knCheckIdx]) then
							OrionLib:MakeNotification({
								Name = "Kicked",
								Content = knDisplayNames[knCheckIdx] .. " (" .. knNames[knCheckIdx] .. ") get kicked!",
								Image = "rbxassetid://4483362458",
								Time = 5
							});
							return;
						end
						if (((# knNames - # Players:GetPlayers()) == 1) and ((knCheckIdx + 1) == # knNames)) then
							OrionLib:MakeNotification({
								Name = "Kicked",
								Content = knDisplayNames[knCheckIdx + 1 ] .. " (" .. knNames[knCheckIdx + 1 ] .. ") get kicked!",
								Image = "rbxassetid://4483362458",
								Time = 5
							});
							return;
						end
					end
				end
			end);
		else
			DisconnectConnection("KickNotify");
		end
	end
});
_G.PCLDEnabled = false;
_G.PCLDBoxes = {};
_G.PCLDConnection = nil;
othersTab:AddToggle({
	Name = "PCLD Viewer",
	Default = false,
	Callback = function(pcldViewerState)
		_G.PCLDEnabled = pcldViewerState;
		local pcldKeywords = {
			"partesp",
			"playercharacterlocationdetector"
		};
		local function isPCLDPart(pcldPart)
			if not pcldPart:IsA("BasePart") then
				return false;
			end
			for kwIdx, kwObj in ipairs(pcldKeywords) do
				if (string.lower(pcldPart.Name) == string.lower(kwObj)) then
					return true;
				end
			end
			return false;
		end
		local function addPCLDBox(pcldTargetPart)
			if _G.PCLDBoxes[pcldTargetPart] then
				return;
			end
			local pcldBox = Instance.new("BoxHandleAdornment");
			pcldBox.Adornee = pcldTargetPart;
			pcldBox.AlwaysOnTop = true;
			pcldBox.ZIndex = 5;
			pcldBox.Color3 = Color3.fromRGB(255, 255, 255);
			pcldBox.Transparency = 0.5;
			pcldBox.Size = pcldTargetPart.Size;
			pcldBox.Parent = game.CoreGui;
			_G.PCLDBoxes[pcldTargetPart] = pcldBox;
			pcldTargetPart.AncestryChanged:Connect(function(pcldADChild, pcldADParent)
				if (not pcldADParent and _G.PCLDBoxes[pcldTargetPart]) then
					_G.PCLDBoxes[pcldTargetPart]:Destroy();
					_G.PCLDBoxes[pcldTargetPart] = nil;
				end
			end);
		end
		local function clearPCLDBoxes()
			for pcldBoxIdx, pcldBoxObj in pairs(_G.PCLDBoxes) do
				if pcldBoxObj then
					pcldBoxObj:Destroy();
				end
			end
			_G.PCLDBoxes = {};
		end
		local function scanPCLDParts()
			for descIdx3, descObj3 in ipairs(workspace:GetDescendants()) do
				if (_G.PCLDEnabled and isPCLDPart(descObj3)) then
					addPCLDBox(descObj3);
				end
			end
		end
		if pcldViewerState then
			scanPCLDParts();
			if _G.PCLDConnection then
				_G.PCLDConnection:Disconnect();
			end
			_G.PCLDConnection = workspace.DescendantAdded:Connect(function(pcldNewDesc)
				if (_G.PCLDEnabled and isPCLDPart(pcldNewDesc)) then
					addPCLDBox(pcldNewDesc);
				end
			end);
		else
			if _G.PCLDConnection then
				_G.PCLDConnection:Disconnect();
				_G.PCLDConnection = nil;
			end
			clearPCLDBoxes();
		end
	end
});
Players = game:GetService("Players");
RunService = game:GetService("RunService");
plr = Players.LocalPlayer;
local antiMasslessHeartbeat;
function startAntiMassless()
	if antiMasslessHeartbeat then
		return;
	end
	antiMasslessHeartbeat = RunService.Heartbeat:Connect(function()
		local amChar = plr.Character;
		if not amChar then
			return;
		end
		local amHRP = amChar:FindFirstChild("HumanoidRootPart");
		if (amHRP and (amHRP.Massless == true)) then
			amHRP.Massless = false;
		end
	end);
end
function stopAntiMassless()
	if antiMasslessHeartbeat then
		antiMasslessHeartbeat:Disconnect();
		antiMasslessHeartbeat = nil;
	end
end
othersTab:AddToggle({
	Name = "Anti Dsync",
	Default = false,
	Callback = function(antiSyncState)
		_G.AntiSync = antiSyncState;
		if antiSyncState then
			for asPIdx, asPObj in pairs(Players:GetPlayers()) do
				if asPObj.Character then
					local asHRP = asPObj.Character:FindFirstChild("HumanoidRootPart");
					if asHRP then
						asHRP.Massless = true;
						asHRP.Massless = false;
					end
				end
			end
			game:GetService("RunService").Heartbeat:Connect(function()
				if not _G.AntiSync then
					return;
				end
				for asPIdx2, asPObj2 in pairs(Players:GetPlayers()) do
					if ((asPObj2 ~= LocalPlayer) and asPObj2.Character) then
						local asHRP2 = asPObj2.Character:FindFirstChild("HumanoidRootPart");
						if (asHRP2 and (asHRP2.Massless == true)) then
							asHRP2.Massless = false;
						end
					end
				end
			end);
		end
	end
});
_G.NicknameESPEnabled = false;
_G.NicknameESPConnections = {};
othersTab:AddToggle({
	Name = "Nickname ESP",
	Default = false,
	Callback = function(nicknameESPState)
		_G.NicknameESPEnabled = nicknameESPState;
		local nespPlayers = game:GetService("Players");
		local nespLocalPlayer = nespPlayers.LocalPlayer;
		local function addNameESP(nespTarget)
			if (nespTarget == nespLocalPlayer) then
				return;
			end
			if (nespTarget.Character and nespTarget.Character:FindFirstChild("HumanoidRootPart")) then
				local nespHRP = nespTarget.Character.HumanoidRootPart;
				if nespHRP:FindFirstChild("NameESP") then
					return;
				end
				local nespBillboard = Instance.new("BillboardGui");
				nespBillboard.Name = "NameESP";
				nespBillboard.Adornee = nespHRP;
				nespBillboard.Size = UDim2.new(0, 100, 0, 30);
				nespBillboard.StudsOffset = Vector3.new(0, 3, 0);
				nespBillboard.AlwaysOnTop = true;
				nespBillboard.Parent = nespHRP;
				local nespLabel = Instance.new("TextLabel");
				nespLabel.Size = UDim2.new(1, 0, 1, 0);
				nespLabel.BackgroundTransparency = 1;
				nespLabel.Text = nespTarget.Name;
				nespLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
				nespLabel.TextStrokeTransparency = 0;
				nespLabel.TextScaled = true;
				nespLabel.Parent = nespBillboard;
			end
		end
		local function removeNameESP(nespRemoveTarget)
			if (nespRemoveTarget.Character and nespRemoveTarget.Character:FindFirstChild("HumanoidRootPart")) then
				local nespRemoveHRP = nespRemoveTarget.Character.HumanoidRootPart;
				if nespRemoveHRP:FindFirstChild("NameESP") then
					nespRemoveHRP.NameESP:Destroy();
				end
			end
		end
		local function clearAllNameESP()
			for nespPIdx, nespPObj in pairs(nespPlayers:GetPlayers()) do
				removeNameESP(nespPObj);
			end
		end
		if nicknameESPState then
			for nespInitIdx, nespInitObj in pairs(nespPlayers:GetPlayers()) do
				addNameESP(nespInitObj);
				local nespCharAdded = nespInitObj.CharacterAdded:Connect(function()
					if _G.NicknameESPEnabled then
						task.wait(0.5);
						addNameESP(nespInitObj);
					end
				end);
				table.insert(_G.NicknameESPConnections, nespCharAdded);
			end
			local nespPlayerAdded = nespPlayers.PlayerAdded:Connect(function(nespNewPlayer)
				if _G.NicknameESPEnabled then
					local nespNewCharAdded = nespNewPlayer.CharacterAdded:Connect(function()
						if _G.NicknameESPEnabled then
							task.wait(0.5);
							addNameESP(nespNewPlayer);
						end
					end);
					table.insert(_G.NicknameESPConnections, nespNewCharAdded);
				end
			end);
			table.insert(_G.NicknameESPConnections, nespPlayerAdded);
		else
			for nespConnIdx, nespConnObj in pairs(_G.NicknameESPConnections) do
				if nespConnObj then
					nespConnObj:Disconnect();
				end
			end
			_G.NicknameESPConnections = {};
			clearAllNameESP();
		end
	end
});
local blobNotifyActive = false;
local blobNotifyTarget = nil;
othersTab:AddToggle({
	Name = "Blob Notify",
	Default = false,
	Callback = function(blobNotifyState)
		blobNotifyActive = blobNotifyState;
		while task.wait() and blobNotifyActive do
			for bnPIdx, bnPObj in pairs(Players:GetPlayers()) do
				if workspace:FindFirstChild(bnPObj.Name .. "SpawnedInToys") then
					for bnToyIdx, bnToyObj in pairs(workspace:FindFirstChild(bnPObj.Name .. "SpawnedInToys"):GetChildren()) do
						if ((bnToyObj.Name == "CreatureBlobman") and not bnToyObj:GetAttribute("SPCHECK") and (bnPObj ~= LocalPlayer)) then
							bnToyObj:SetAttribute("SPCHECK", true);
							task.wait(0.1);
							blobNotifyTarget = bnToyObj:FindFirstChild("HumanoidRootPart");
							OrionLib:MakeNotification({
								Name = "Blob",
								Content = bnPObj.Name .. " (" .. bnPObj.DisplayName .. ") Spawned Blob!",
								Image = "rbxassetid://4483362458",
								Time = 3
							});
						end
					end
				end
			end
			for bnPlotNum = 1, 5 do
				if workspace.PlotItems:FindFirstChild("Plot" .. bnPlotNum) then
					for bnPlotToyIdx, bnPlotToyObj in pairs(workspace.PlotItems["Plot" .. bnPlotNum ]:GetChildren()) do
						if ((bnPlotToyObj.Name == "CreatureBlobman") and not bnPlotToyObj:GetAttribute("SPCHECK")) then
							bnPlotToyObj:SetAttribute("SPCHECK", true);
							task.wait(0.15);
							local bnOwnerName = tostring(bnPlotToyObj:WaitForChild("PlayerValue").Value);
							if (bnOwnerName ~= LocalPlayer.Name) then
								blobNotifyTarget = bnPlotToyObj:FindFirstChild("HumanoidRootPart");
								OrionLib:MakeNotification({
									Name = "House Blob",
									Content = bnOwnerName .. " (" .. tostring(Players[bnOwnerName].DisplayName) .. ") Spawned Blob in house!",
									Image = "rbxassetid://4483362458",
									Time = 3
								});
							end
						end
					end
				end
			end
		end
	end
});
local runService = game:GetService("RunService");
local players = game:GetService("Players");
connections = connections or {} ;
_G.AnchorGrab = false;
_G.CompileParts = false;
local anchorPartList = {};
local compilePartsData = nil;
local function partBelongsToPlayer(anchorCheckPart)
	for anchorPIdx, anchorPObj in ipairs(players:GetPlayers()) do
		if (anchorPObj.Character and anchorCheckPart:IsDescendantOf(anchorPObj.Character)) then
			return true;
		end
	end
	return false;
end
local function removePhysicsBodies(removePart)
	if removePart:FindFirstChild("RB_BP") then
		removePart.RB_BP:Destroy();
	end
	if removePart:FindFirstChild("RB_BG") then
		removePart.RB_BG:Destroy();
	end
end
local function addPhysicsBodies(addPart)
	if addPart:FindFirstChild("RB_BP") then
		return;
	end
	local anchorBodyPos = Instance.new("BodyPosition");
	anchorBodyPos.Name = "RB_BP";
	anchorBodyPos.P = 15000;
	anchorBodyPos.D = 200;
	anchorBodyPos.MaxForce = Vector3.new(5000000, 5000000, 5000000);
	anchorBodyPos.Position = addPart.Position;
	anchorBodyPos.Parent = addPart;
	local anchorBodyGyro = Instance.new("BodyGyro");
	anchorBodyGyro.Name = "RB_BG";
	anchorBodyGyro.P = 15000;
	anchorBodyGyro.D = 200;
	anchorBodyGyro.MaxTorque = Vector3.new(5000000, 5000000, 5000000);
	anchorBodyGyro.CFrame = addPart.CFrame;
	anchorBodyGyro.Parent = addPart;
end
local function anchorCurrentGrab()
	local anchorGrabParts = workspace:FindFirstChild("GrabParts");
	if not anchorGrabParts then
		return;
	end
	local anchorGrabPart = anchorGrabParts:FindFirstChild("GrabPart");
	if not anchorGrabPart then
		return;
	end
	local anchorWeld = anchorGrabPart:FindFirstChild("WeldConstraint");
	if (not anchorWeld or not anchorWeld.Part1) then
		return;
	end
	local anchorModel = anchorWeld.Part1.Parent;
	local anchorPrimary = anchorModel and anchorModel.PrimaryPart ;
	if not anchorPrimary then
		return;
	end
	if partBelongsToPlayer(anchorPrimary) then
		return;
	end
	if (workspace:FindFirstChild("Map") and anchorPrimary:IsDescendantOf(workspace.Map)) then
		return;
	end
	if not table.find(anchorPartList, anchorPrimary) then
		table.insert(anchorPartList, anchorPrimary);
	end
	addPhysicsBodies(anchorPrimary);
end
local function compileGrabbedParts()
	if (# anchorPartList == 0) then
		return;
	end
	local compilePrimary = anchorPartList[1];
	if not compilePrimary then
		return;
	end
	if not compilePartsData then
		compilePartsData = {
			primary = compilePrimary,
			parts = {}
		};
		for compilePartIdx, compilePartObj in ipairs(anchorPartList) do
			if (compilePartObj ~= compilePrimary) then
				table.insert(compilePartsData.parts, {
					part = compilePartObj,
					offset = compilePrimary.CFrame:ToObjectSpace(compilePartObj.CFrame)
				});
				addPhysicsBodies(compilePartObj);
			end
		end
	end
	for compileSlotIdx, compileSlotObj in ipairs(compilePartsData.parts) do
		if (compileSlotObj.part and compileSlotObj.part:FindFirstChild("RB_BP")) then
			compileSlotObj.part.RB_BP.Position = (compilePrimary.CFrame * compileSlotObj.offset).Position;
			compileSlotObj.part.RB_BG.CFrame = compilePrimary.CFrame * compileSlotObj.offset ;
		end
	end
end
local function unanchorHeaderPart()
	if anchorPartList[1] then
		removePhysicsBodies(anchorPartList[1]);
	end
end
local function disassembleParts()
	for disassembleIdx, disassembleObj in ipairs(anchorPartList) do
		removePhysicsBodies(disassembleObj);
	end
	anchorPartList = {};
	compilePartsData = nil;
end
connections.RageByteLoop = runService.Heartbeat:Connect(function()
	if _G.AnchorGrab then
		anchorCurrentGrab();
	end
	if _G.CompileParts then
		compileGrabbedParts();
	end
end);
othersTab:AddSection({
	Name = "Anchor grab"
});
othersTab:AddToggle({
	Name = "Anchor Grab",
	Default = false,
	Callback = function(anchorGrabState)
		_G.AnchorGrab = anchorGrabState;
	end
});
othersTab:AddToggle({
	Name = "Compile Parts",
	Default = false,
	Callback = function(compilePartsState)
		_G.CompileParts = compilePartsState;
	end
});
othersTab:AddButton({
	Name = "Unanchor Header Part",
	Callback = function()
		unanchorHeaderPart();
	end
});
othersTab:AddButton({
	Name = "Disassemble Parts",
	Callback = function()
		disassembleParts();
	end
});
function isInOcean(oceanPart)
	local oceanParent = oceanPart.Parent;
	if (oceanParent and (oceanParent.Name == "Ocean")) then
		return true;
	elseif (oceanParent and oceanParent.Parent and (oceanParent.Parent.Name == "Ocean")) then
		return true;
	elseif (oceanParent and oceanParent.Parent and oceanParent.Parent.Parent and (oceanParent.Parent.Parent.Name == "Ocean")) then
		return true;
	end
	return false;
end
function findClosestPart(closestPos)
	local mapObj = workspace:WaitForChild("Map");
	local closestPart = nil;
	local closestDist = math.huge;
	for mapDescIdx, mapDescObj in ipairs(mapObj:GetDescendants()) do
		if (mapDescObj:IsA("BasePart") and not isInOcean(mapDescObj)) then
			local distToPart = (mapDescObj.Position - closestPos).Magnitude;
			if (distToPart < closestDist) then
				closestDist = distToPart;
				closestPart = mapDescObj;
			end
		end
	end
	return closestPart;
end
function monitorCharacter(monitorChar)
	local monitorRS = game:GetService("RunService");
	local monitorHRP = monitorChar:WaitForChild("HumanoidRootPart");
	local monitorHumanoid = monitorChar:WaitForChild("Humanoid");
	monitorHumanoid.Died:Connect(function()
		monitorCharacter(monitorChar);
	end);
	monitorRS.RenderStepped:Connect(function()
		if (monitorHRP.Position.Y < -200) then
			local monitorClosest = findClosestPart(monitorHRP.Position);
			if monitorClosest then
				local monitorSurface = monitorClosest.Position + Vector3.new(0, monitorClosest.Size.Y / 2, 0) ;
				local monitorSafePos = Vector3.new(monitorSurface.X, 50, monitorSurface.Z);
				monitorHRP.CFrame = CFrame.new(monitorSafePos);
				monitorHRP.AssemblyLinearVelocity = Vector3.zero;
				monitorHRP.AssemblyAngularVelocity = Vector3.zero;
			end
		end
	end);
end
function init()
	local initPlayers = game:GetService("Players");
	local initLocalPlayer = initPlayers.LocalPlayer;
	if initLocalPlayer.Character then
		monitorCharacter(initLocalPlayer.Character);
	end
	initLocalPlayer.CharacterAdded:Connect(monitorCharacter);
end
init();
local titleMessages = {
	"ã€Œ Black best Hub Ever ã€",
	"ã€Œ Best ftap hub ã€",
	"ã€Œ discord.gg/ ã€",
	"ã€Œ Test Bliz_t Hub too! ã€",
	"ã€Œ Bliz_T Hub > TST ã€",
	"ã€Œ You can not win Black hubã€",
	"ã€Œ Bliz_T Hub > TST ã€",
	"ã€Œ Vhck Skid ã€",
	"ã€Œ Bliz_T + Black = ðŸ”¥ ã€",
	"ã€Œ Black dominates the game ã€",
	"ã€Œ TST canâ€™t compete ã€",
	"ã€Œ Tired of dying? Use BlizT Hub ã€",
	"ã€Œ Black on top always ã€",
	"ã€Œ Tired of dying? Use Black Hub ã€",
	"ã€Œ Bliz_T certified W ã€",
	"ã€Œ Black No.1 choice ã€",
	"ã€Œ Join the legends â€“ Black ã€",
	"ã€Œ Bliz_t Hub got that real power ã€",
	"ã€Œ One hub to rule them all: =Black ã€",
	"ã€Œ You saw that? Black did it. ã€"
};
_G.bloquear = true;
_G.somAtivo = false;
_G.mostrarFps = true;
_G.mostrarHorario = true;
local titleAnimationEnabled = true;
local function typeBackwards(typeStr)
	for typeCharIdx = # typeStr, 1, -1 do
		SetTitle(typeStr:sub(1, typeCharIdx));
		tocarSom();
		task.wait(0.05);
	end
end
local function typeTitle()
	if titleAnimationEnabled then
		for fwdCharIdx = 1, # hubTitle do
			SetTitle(hubTitle:sub(1, fwdCharIdx));
			tocarSom();
			task.wait(0.1);
		end
	else
		SetTitle(hubTitle);
	end
end
local function typeTime()
	if not _G.mostrarHorario then
		return;
	end
	_G.horario = "âŒœ âŒŸ" ;
	if titleAnimationEnabled then
		for timeCharIdx = 1, # _G.horario do
			SetTitle(hubTitle .. _G.horario:sub(1, timeCharIdx));
			tocarSom();
			task.wait(0.1);
		end
	else
		SetTitle(hubTitle .. _G.horario);
	end
end
local function typeFps()
	if not _G.mostrarFps then
		return;
	end
	local fpsSuffix = " | Fps:" .. fps ;
	if titleAnimationEnabled then
		for fpsCharIdx = 1, # fpsSuffix do
			SetTitle(hubTitle .. (_G.horario or "") .. fpsSuffix:sub(1, fpsCharIdx));
			tocarSom();
			task.wait(0.1);
		end
	else
		SetTitle(hubTitle .. (_G.horario or "") .. fpsSuffix);
	end
end
task.spawn(function()
	typeTitle();
	typeTime();
	typeFps();
	_G.bloquear = false;
end);
task.spawn(function()
	while true do
		task.wait(scriptState.fpsdelayvalue);
		if (not _G.bloquear and titleAnimationEnabled) then
			local titleStr = hubTitle;
			if _G.mostrarHorario then
				_G.horario = "âŒœ âŒŸ" ;
				titleStr = titleStr .. _G.horario ;
			end
			if _G.mostrarFps then
				titleStr = titleStr .. " | Fps:" .. fps ;
			end
			SetTitle(titleStr);
		end
	end
end);
task.spawn(function()
	while true do
		task.wait(math.random(30, 50));
		if not titleAnimationEnabled then
			continue;
		end
		_G.bloquear = true;
		typeBackwards(hubTitle .. _G.horario .. " | Fps:" .. fps);
		local randomMsg = titleMessages[math.random(1, # titleMessages)];
		for msgCharIdx = 1, # randomMsg do
			if not titleAnimationEnabled then
				break;
			end
			SetTitle(randomMsg:sub(1, msgCharIdx));
			tocarSom();
			task.wait(0.05);
		end
		local titleLog = " ";
		if (language == "pt-br") then
			logsTab:AddLabel(titleLog .. " - mensagens de titulo adicionado");
		else
			logsTab:AddLabel(titleLog .. " - Tittle Added");
		end
		task.wait(10);
		if titleAnimationEnabled then
			typeBackwards(randomMsg);
			titleLog = " ";
			if (language == "pt-br") then
				logsTab:AddLabel(titleLog .. " - mensagens de titulo Removida");
			else
				logsTab:AddLabel(titleLog .. " - Tittle removed");
			end
			typeTitle();
			typeTime();
			typeFps();
		end
		_G.bloquear = false;
	end
end);
function encontrarBlobmanDoJogador()
	local ebHumanoid = scriptState.humanoid;
	if (ebHumanoid.SeatPart and (ebHumanoid.SeatPart.Parent.Name == "CreatureBlobman")) then
		if (ebHumanoid.SeatPart.Parent:FindFirstChild("LeftDetector"):FindFirstChild("RigidConstraint") or ebHumanoid.SeatPart.Parent:FindFirstChild("RightDetector"):FindFirstChild("RigidConstraint")) then
			local ebBlobman = ebHumanoid.SeatPart.Parent;
			return ebBlobman;
		else
			scriptState.humanoid.Sit = false;
		end
		return nil;
	else
		return nil;
	end
end
scriptState.blobmanCoroutine = nil;
local blobmanRef = nil;
local blobmanConnections = {};
local blobmanLoopActive = false;
local blobMode = 1;
local grabMode = 1;
local grabSideToggle = 1;
function encontrarBlobmanDoJogador()
	local ebHumanoid2 = scriptState.humanoid;
	if (ebHumanoid2.SeatPart and (ebHumanoid2.SeatPart.Parent.Name == "CreatureBlobman")) then
		local ebLeftDetector = ebHumanoid2.SeatPart.Parent:FindFirstChild("LeftDetector");
		local ebRightDetector = ebHumanoid2.SeatPart.Parent:FindFirstChild("RightDetector");
		if ((ebLeftDetector and ebLeftDetector:FindFirstChild("RigidConstraint")) or (ebRightDetector and ebRightDetector:FindFirstChild("RigidConstraint"))) then
			return ebHumanoid2.SeatPart.Parent;
		else
			ebHumanoid2.Sit = false;
		end
	end
	return nil;
end
function BreakHeadJoint(targetPlayer2)
	local targetChar3 = targetPlayer2.Character;
	if ((typeof(targetChar3) == "Instance") and targetChar3:IsA("Model")) then
		local targetHead2 = targetChar3:FindFirstChild("Head");
		local targetHRP2 = targetChar3:FindFirstChild("HumanoidRootPart");
		if (targetHead2 and targetHRP2) then
			local ballSocket = targetHead2:FindFirstChild("BallSocketConstraint");
			if (ballSocket and ballSocket.Attachment0 and ballSocket.Attachment1) then
				local bhBlobman = scriptState.inv:FindFirstChild("CreatureBlobman");
				if bhBlobman then
					local bhBlobmanScript = bhBlobman:FindFirstChild("BlobmanSeatAndOwnerScript");
					local bhCreatureDrop = bhBlobmanScript and bhBlobmanScript:FindFirstChild("CreatureDrop") ;
					if bhCreatureDrop then
						bhCreatureDrop:FireServer(ballSocket, ballSocket.Attachment0);
					end
				end
			end
		end
	end
end
function blobGrabPlayer(grabTargetPlayer, grabBlobman)
	if (not grabTargetPlayer.Character or not grabTargetPlayer.Character:FindFirstChild("HumanoidRootPart")) then
		return;
	end
	local grabSide = ((grabSideToggle == 1) and "Left") or "Right" ;
	local grabDetector = grabBlobman:FindFirstChild(grabSide .. "Detector");
	local grabWeld = grabDetector and grabDetector:FindFirstChild(grabSide .. "Weld") ;
	if grabDetector then
		local grabUnpack;
		if (grabMode == 1) then
			grabUnpack = {
				grabDetector,
				grabTargetPlayer.Character.HumanoidRootPart,
				grabWeld
			};
		elseif (grabMode == 2) then
			grabUnpack = {
				grabDetector,
				grabTargetPlayer.Character.HumanoidRootPart,
				workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignPosition
			};
		elseif (grabMode == 3) then
			grabUnpack = {
				grabDetector,
				grabTargetPlayer.Character.HumanoidRootPart,
				workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.FollowThisPart.AlignPosition
			};
		elseif (grabMode == 4) then
			grabUnpack = {
				grabDetector,
				grabTargetPlayer.Character.HumanoidRootPart,
				workspace.Map.AlwaysHereTweenedObjects.LrgDebris.Object.FollowThisPart.AlignPosition
			};
		elseif (grabMode == 5) then
			grabUnpack = {
				grabDetector,
				grabTargetPlayer.Character.HumanoidRootPart,
				grabTargetPlayer.Character.HumanoidRootPart.RootAttachment
			};
		end
		if grabUnpack then
			grabBlobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(grabUnpack));
			grabSideToggle = ((grabSideToggle == 1) and 2) or 1 ;
		end
	end
end
local function checkAndStartBlobmanLoop()
	if blobmanLoopActive then
		if alvosOnline() then
			iniciarBlobmanLoop();
		else
			pararBlobmanLoop();
		end
	end
end
combatTab:AddParagraph("Select Player Here!", "the player selected here will enter the loop");
combatTab:AddPlayerDropdown({
	Name = "Jogadores",
	Callback = function(selectedPlayers)
		local filteredPlayers = {};
		for dropPIdx, dropPObj in ipairs(selectedPlayers) do
			if IsOwner(dropPObj) then
				OrionLib:MakeNotification({
					Name = "Black Hub",
					Content = "This player is owner",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
			else
				table.insert(filteredPlayers, dropPObj);
			end
		end
		_G.alvosSelecionados = filteredPlayers;
	end,
	Save = false,
	Flag = "MultiPlayerDropdown"
});
local function removePlayerFromTargets(leftPlayerName)
	if _G.alvosSelecionados then
		for alvosIdx, alvosObj in ipairs(_G.alvosSelecionados) do
			if (alvosObj == leftPlayerName) then
				table.remove(_G.alvosSelecionados, alvosIdx);
				break;
			end
		end
	end
	if (OrionLib.Flags and OrionLib.Flags['MultiPlayerDropdown']) then
		local multiDropdown = OrionLib.Flags['MultiPlayerDropdown'];
		if multiDropdown.Set then
			multiDropdown:Set({});
		end
	end
end
players.PlayerRemoving:Connect(function(removedPlayer)
	removePlayerFromTargets(removedPlayer.Name);
end);
combatTab:AddToggle({
	Name = "Snowball Ragdoll",
	Default = false,
	Callback = function(snowballState)
		_G.SnowballRagdollActive = snowballState;
		if snowballState then
			if (not _G.alvosSelecionados or (# _G.alvosSelecionados == 0)) then
				OrionLib:MakeNotification({
					Name = "âŒ Erro",
					Content = ((language == "pt-br") and "Selecione pelo menos um alvo no dropdown!") or "Select at least one target in dropdown!",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
				_G.SnowballRagdollActive = false;
				return;
			end
			if (language == "pt-br") then
				logsTab:AddLabel(_G.horario .. " - Snowball Ragdoll ATIVADO para " .. # _G.alvosSelecionados .. " alvo(s)");
			else
				logsTab:AddLabel(_G.horario .. " - Snowball Ragdoll ENABLED for " .. # _G.alvosSelecionados .. " target(s)");
			end
			task.spawn(function()
				local snowballGrabEvents = ReplicatedStorage:WaitForChild("GrabEvents");
				local snowballSpawnedToys = workspace[LocalPlayer.Name .. "SpawnedInToys" ];
				local snowballSpawnFunc = ReplicatedStorage.MenuToys.SpawnToyRemoteFunction;
				local function snowballSetOwner(snowballPart)
					ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(snowballPart, snowballPart.CFrame);
				end
				local function snowballSpawnToy(snowballToyName, snowballHead)
					snowballSpawnFunc:InvokeServer(snowballToyName, CFrame.new(snowballHead.Position + Vector3.new(0, 1, 0), snowballHead.Position) * CFrame.Angles(math.pi, 0, 0), Vector3.new(0, 0, 0));
					local snowballToy;
					local snowballToyStart = tick();
					repeat
						task.wait();
						snowballToy = snowballSpawnedToys:FindFirstChild(snowballToyName);
					until snowballToy or ((tick() - snowballToyStart) > 3)
					return snowballToy;
				end
				local snowballChar = LocalPlayer.Character;
				local snowballHRP = snowballChar and snowballChar:FindFirstChild("HumanoidRootPart") ;
				if not snowballHRP then
					return;
				end
				local snowballStartCF = snowballHRP.CFrame;
				for snowballAlvoIdx, snowballAlvoObj in ipairs(_G.alvosSelecionados or {}) do
					if IsOwner(snowballAlvoObj) then
						continue;
					end
					task.spawn(function()
						while _G.SnowballRagdollActive do
							local snowballGrabStart = 0;
							local snowballGrabbed = false;
							while not snowballGrabbed and _G.SnowballRagdollActive do
								snowballChar = LocalPlayer.Character;
								snowballHRP = snowballChar and snowballChar:FindFirstChild("HumanoidRootPart") ;
								local snowballTargetPlayer2 = players:FindFirstChild(snowballAlvoObj);
								if (not snowballTargetPlayer2 or not snowballTargetPlayer2.Character) then
									game:GetService("RunService").Heartbeat:Wait();
									continue;
								end
								local snowballTargetChar2 = snowballTargetPlayer2.Character;
								local snowballTargetHRP2 = snowballTargetChar2:FindFirstChild("HumanoidRootPart");
								local snowballTargetHumanoid2 = snowballTargetChar2:FindFirstChild("Humanoid");
								if (snowballTargetHRP2 and snowballTargetHumanoid2 and (snowballTargetHumanoid2.Health > 0)) then
									snowballHRP.CFrame = snowballTargetHRP2.CFrame;
									snowballHRP.Velocity = Vector3.zero;
									pcall(function()
										snowballTargetHumanoid2.PlatformStand = true;
										snowballTargetHumanoid2.Sit = true;
										snowballGrabEvents.SetNetworkOwner:FireServer(snowballTargetHRP2, snowballHRP.CFrame);
										snowballGrabEvents.CreateGrabLine:FireServer(snowballTargetHRP2, Vector3.zero, snowballTargetHRP2.Position, false);
									end);
									if (snowballGrabStart == 0) then
										snowballGrabStart = tick();
									end
									if ((tick() - snowballGrabStart) > 0.35) then
										snowballGrabbed = true;
									end
								else
									snowballGrabStart = 0;
								end
								game:GetService("RunService").Heartbeat:Wait();
							end
							if not _G.SnowballRagdollActive then
								break;
							end
							local snowballTarget = players:FindFirstChild(snowballAlvoObj);
							local snowballTargetChar = snowballTarget and snowballTarget.Character ;
							local snowballTargetHRP = snowballTargetChar and snowballTargetChar:FindFirstChild("HumanoidRootPart") ;
							local snowballTargetHumanoid = snowballTargetChar and snowballTargetChar:FindFirstChild("Humanoid") ;
							if (not snowballTargetHRP or not snowballTargetHumanoid) then
								task.wait(0.5);
								continue;
							end
							local snowballAboveCF = snowballStartCF * CFrame.new(0, 20, 0) ;
							local snowballAbovePos = snowballAboveCF.Position;
							snowballHRP.CFrame = snowballStartCF;
							snowballHRP.Velocity = Vector3.zero;
							pcall(function()
								snowballTargetHumanoid.PlatformStand = true;
								snowballTargetHumanoid.Sit = false;
								snowballGrabEvents.SetNetworkOwner:FireServer(snowballTargetHRP, snowballAboveCF);
								snowballGrabEvents.DestroyGrabLine:FireServer(snowballTargetHRP);
								snowballGrabEvents.CreateGrabLine:FireServer(snowballTargetHRP, Vector3.zero, snowballTargetHRP.Position, false);
							end);
							local snowballBodyPos = Instance.new("BodyPosition");
							snowballBodyPos.Position = snowballAbovePos;
							snowballBodyPos.MaxForce = Vector3.new(1000000, 1000000, 1000000);
							snowballBodyPos.D = 1000;
							snowballBodyPos.P = 100000;
							snowballBodyPos.Parent = snowballTargetHRP;
							local snowballHoldTask = task.spawn(function()
								while snowballBodyPos and snowballBodyPos.Parent and _G.SnowballRagdollActive and task.wait(0.05) do
									snowballHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ;
									if snowballHRP then
										snowballAboveCF = snowballHRP.CFrame * CFrame.new(0, 20, 0) ;
										snowballAbovePos = snowballAboveCF.Position;
									end
									snowballGrabEvents.SetNetworkOwner:FireServer(snowballTargetHRP, snowballAboveCF);
									snowballBodyPos.Position = snowballAbovePos;
								end
								if (snowballBodyPos and snowballBodyPos.Parent) then
									snowballBodyPos:Destroy();
								end
							end);
							while _G.SnowballRagdollActive and task.wait(0.1) do
								local snowballTargetChar3 = players:FindFirstChild(snowballAlvoObj) and players:FindFirstChild(snowballAlvoObj).Character ;
								if (not snowballTargetChar3 or (snowballTargetChar3 ~= snowballTargetChar)) then
									break;
								end
								local snowballTargetHRP3 = snowballTargetChar3:FindFirstChild("HumanoidRootPart");
								local snowballTargetHead = snowballTargetChar3:FindFirstChild("Head");
								if (not snowballTargetHRP3 or not snowballTargetHead) then
									break;
								end
								if (snowballTargetHRP3 ~= snowballTargetHRP) then
									break;
								end
								task.spawn(function()
									local snowballSnowball = snowballSpawnToy("BallSnowball", snowballTargetHead);
									if not snowballSnowball then
										return;
									end
									local snowballSoundPart = snowballSnowball:WaitForChild("SoundPart");
									if not snowballSoundPart then
										return;
									end
									local snowballOutOfRange = false;
									while not(snowballSoundPart:FindFirstChild("PartOwner")) or (snowballSoundPart:FindFirstChild("PartOwner") and (snowballSoundPart:FindFirstChild("PartOwner").Value ~= LocalPlayer.Name)) do
										if (snowballSoundPart and snowballSoundPart.Parent) then
											if ((snowballSoundPart.Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 45) then
												task.spawn(snowballSetOwner, snowballSoundPart);
												task.wait();
											else
												snowballOutOfRange = true;
												break;
											end
										else
											snowballOutOfRange = true;
											break;
										end
									end
									if snowballOutOfRange then
										return;
									end
									local snowballBodyVel = Instance.new("BodyVelocity");
									snowballBodyVel.Velocity = Vector3.new(0, 150, 0);
									snowballBodyVel.Parent = snowballSoundPart;
									firetouchinterest(snowballSoundPart, snowballTargetHRP3, 0);
									task.spawn(function()
										while task.wait(0.05) and snowballSoundPart and snowballSoundPart.Parent do
											firetouchinterest(snowballSoundPart, snowballTargetHRP3, 0);
										end
									end);
									while snowballSoundPart and snowballSoundPart.Parent and task.wait() do
										snowballSoundPart.CFrame = snowballTargetHead.CFrame + Vector3.new(0, 2, 0) ;
									end
								end);
							end
							if (snowballBodyPos and snowballBodyPos.Parent) then
								snowballBodyPos:Destroy();
							end
							if not _G.SnowballRagdollActive then
								break;
							end
							local snowballTarget2 = players:FindFirstChild(snowballAlvoObj);
							if snowballTarget2 then
								local snowballWaitChar = snowballTarget2.Character or snowballTarget2.CharacterAdded:Wait() ;
								snowballWaitChar:WaitForChild("HumanoidRootPart", 5);
								task.wait(0.3);
							end
						end
						if (language == "pt-br") then
							logsTab:AddLabel(_G.horario .. " - Snowball Ragdoll DESATIVADO");
						else
							logsTab:AddLabel(_G.horario .. " - Snowball Ragdoll DISABLED");
						end
					end);
				end
			end);
		end
	end
});
combatTab:AddToggle({
	Name = "Kick Ownership",
	Default = false,
	Callback = function(kickOwnerState)
		_G.loopKickOwner = kickOwnerState;
		local function kickOwnerTakeToys(koPlayerName)
			local function koSetOwner(koPart)
				if koPart then
					game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(koPart, koPart.CFrame);
				end
			end
			local koSpawnedToys = workspace:FindFirstChild(koPlayerName .. "SpawnedInToys");
			if not koSpawnedToys then
				return;
			end
			for koToyIdx, koToyObj in pairs(koSpawnedToys:GetChildren()) do
				local koStickyPart = koToyObj:FindFirstChild("StickyPart");
				if (koStickyPart and koStickyPart:IsA("BasePart")) then
					if (# koStickyPart:GetTouchingParts() == 0) then
						koSetOwner(koStickyPart);
					end
				end
			end
		end
		if kickOwnerState then
			task.spawn(function()
				if not spawnedInToys:FindFirstChild("Ragdoll") then
					local koPallet = SpawnToyAndWait("PalletLightBrown", WaitForChildCustom(LocalPlayer.Character, "Head"), "headup");
					local koSoundPart = koPallet:WaitForChild("SoundPart");
					while (koSoundPart and not koSoundPart:FindFirstChild("PartOwner")) or (koSoundPart:FindFirstChild("PartOwner") and (koSoundPart:FindFirstChild("PartOwner").Value ~= LocalPlayer.Name)) do
						task.spawn(SetNetworkOwner, koSoundPart);
						task.wait();
					end
					local koBodyVel = Instance.new("BodyVelocity");
					koBodyVel.Parent = koSoundPart;
					koBodyVel.MaxForce = Vector3.new(0, math.huge, 0);
					koBodyVel.Velocity = Vector3.new(0, 10000, 0);
					for koPartIdx, koPartObj in pairs(koPallet:GetChildren()) do
						if koPartObj:IsA("BasePart") then
							koPartObj.Transparency = 1;
							koPartObj.Size = Vector3.new(0.5, 0.5, 0.5);
						end
					end
					if koSoundPart:FindFirstChild("Wood") then
						koSoundPart.Wood:Destroy();
					end
					koPallet.Name = "Ragdoll";
				end
				for koAlvoIdx, koAlvoObj in ipairs(_G.alvosSelecionados or {}) do
					if IsOwner(koAlvoObj) then
						continue;
					end
					task.spawn(function()
						local function koSetOwner2(koSetOwnerPart)
							if koSetOwnerPart then
								game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(koSetOwnerPart, koSetOwnerPart.CFrame);
							end
						end
						local koGrabEvents = game:GetService("ReplicatedStorage"):WaitForChild("GrabEvents");
						local koChar = LocalPlayer.Character;
						local koHRP = koChar and koChar:FindFirstChild("HumanoidRootPart") ;
						if not koHRP then
							return;
						end
						local koStartCF = koHRP.CFrame;
						while _G.loopKickOwner do
							local koTarget = game.Players:FindFirstChild(koAlvoObj);
							if not koTarget then
								task.wait(0.5);
								continue;
							end
							local koTargetChar = koTarget.Character;
							if not koTargetChar then
								koTargetChar = koTarget.CharacterAdded:Wait();
							end
							local koTargetHRP = koTargetChar:WaitForChild("HumanoidRootPart", 5);
							local koTargetHumanoid = koTargetChar:WaitForChild("Humanoid", 5);
							if (not koTargetHRP or not koTargetHumanoid or not _G.loopKickOwner) then
								break;
							end
							local koGrabStart = 0;
							local koGrabbed = false;
							while not koGrabbed and _G.loopKickOwner do
								koChar = LocalPlayer.Character;
								koHRP = koChar and koChar:FindFirstChild("HumanoidRootPart") ;
								if (koTarget.Character ~= koTargetChar) then
									break;
								end
								if (koTargetHRP and koTargetHumanoid and (koTargetHumanoid.Health > 0)) then
									koHRP.CFrame = koTargetHRP.CFrame;
									koHRP.Velocity = Vector3.zero;
									pcall(function()
										koTargetHumanoid.PlatformStand = true;
										koTargetHumanoid.Sit = true;
										koGrabEvents.SetNetworkOwner:FireServer(koTargetHRP, koHRP.CFrame);
										koGrabEvents.CreateGrabLine:FireServer(koTargetHRP, Vector3.zero, koTargetHRP.Position, false);
									end);
									if (koGrabStart == 0) then
										koGrabStart = tick();
									end
									if ((tick() - koGrabStart) > 0.3) then
										koGrabbed = true;
									end
								else
									koGrabStart = 0;
								end
								task.wait();
							end
							if not _G.loopKickOwner then
								break;
							end
							if not koGrabbed then
								local koWaitChar = koTarget.Character or koTarget.CharacterAdded:Wait() ;
								koWaitChar:WaitForChild("HumanoidRootPart", 5);
								task.wait(0.3);
								continue;
							end
							koTargetChar = koTarget.Character;
							koTargetHRP = koTargetChar and koTargetChar:FindFirstChild("HumanoidRootPart") ;
							koTargetHumanoid = koTargetChar and koTargetChar:FindFirstChild("Humanoid") ;
							if (not koTargetHRP or not koTargetHumanoid) then
								task.wait(0.5);
								continue;
							end
							koHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ;
							if koHRP then
								koHRP.CFrame = koStartCF;
								koHRP.Velocity = Vector3.zero;
							end
							local koAboveCF = koStartCF * CFrame.new(0, 17, 0) ;
							local koAbovePos = koAboveCF.Position;
							pcall(function()
								koTargetHumanoid.PlatformStand = true;
								koTargetHumanoid.Sit = false;
								koGrabEvents.SetNetworkOwner:FireServer(koTargetHRP, koAboveCF);
								koGrabEvents.DestroyGrabLine:FireServer(koTargetHRP);
								koGrabEvents.CreateGrabLine:FireServer(koTargetHRP, Vector3.zero, koTargetHRP.Position, false);
							end);
							local koBodyPos = Instance.new("BodyPosition");
							koBodyPos.Position = koAbovePos;
							koBodyPos.MaxForce = Vector3.new(1000000, 1000000, 1000000);
							koBodyPos.D = 1000;
							koBodyPos.P = 100000;
							koBodyPos.Parent = koTargetHRP;
							task.spawn(function()
								repeat
									local koCheckChar = koTarget.Character;
									if koCheckChar then
										local koCheckHead = koCheckChar:FindFirstChild("Head");
										local koRagdollToy = spawnedInToys:FindFirstChild("Ragdoll");
										if (koRagdollToy and koRagdollToy:FindFirstChild("SoundPart") and koCheckHead) then
											pcall(function()
												firetouchinterest(koRagdollToy.SoundPart, koCheckHead, 0);
												task.wait(0.1);
												firetouchinterest(koRagdollToy.SoundPart, koCheckHead, 1);
											end);
										end
									end
									task.wait(0.1);
								until not _G.loopKickOwner
							end);
							while _G.loopKickOwner do
								local koLoopChar = koTarget.Character;
								if (not koLoopChar or (koLoopChar ~= koTargetChar)) then
									break;
								end
								local koLoopHRP = koLoopChar:FindFirstChild("HumanoidRootPart");
								if (not koLoopHRP or (koLoopHRP ~= koTargetHRP)) then
									break;
								end
								koHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ;
								if koHRP then
									koAboveCF = koHRP.CFrame * CFrame.new(0, 17, 0) ;
									koAbovePos = koAboveCF.Position;
								end
								koGrabEvents.SetNetworkOwner:FireServer(koLoopHRP, koAboveCF);
								koBodyPos.Position = koAbovePos;
								koGrabEvents.DestroyGrabLine:FireServer(koLoopHRP);
								kickOwnerTakeToys(koAlvoObj);
								task.wait();
							end
							if (koBodyPos and koBodyPos.Parent) then
								koBodyPos:Destroy();
							end
							if not _G.loopKickOwner then
								break;
							end
							local koTargetChar2 = koTarget.Character;
							if not koTargetChar2 then
								local koAddedConn;
								local koCharAdded = false;
								koAddedConn = koTarget.CharacterAdded:Connect(function(koNewChar)
									koTargetChar2 = koNewChar;
									koCharAdded = true;
									koAddedConn:Disconnect();
								end);
								local koWaitTick = tick();
								while not koCharAdded do
									koTargetChar2 = koTarget.Character;
									if koTargetChar2 then
										break;
									end
									if ((tick() - koWaitTick) > 5) then
										break;
									end
									task.wait(0.05);
								end
								if koAddedConn then
									pcall(function()
										koAddedConn:Disconnect();
									end);
								end
							end
							if koTargetChar2 then
								koTargetChar2:WaitForChild("HumanoidRootPart", 5);
							end
							task.wait(0.3);
						end
					end);
				end
			end);
		else
			local koRagdollToy2 = spawnedInToys:FindFirstChild("Ragdoll");
			if koRagdollToy2 then
				pcall(function()
					remotes.DestroyToy:FireServer(koRagdollToy2);
				end);
			end
		end
	end
});
function DestroyT(destroyToyArg)
	local destroyToyModel = destroyToyArg or toysFolder:FindFirstChildWhichIsA("Model") ;
	remotes.DestroyToy:FireServer(destroyToyModel);
end
function spawnandsitblob(ssbTargetPlayer)
	local ssbBlobman = scriptState.inv:FindFirstChild("CreatureBlobman");
	if ssbBlobman then
		local ssbLeftDetector = ssbBlobman:FindFirstChild("LeftDetector");
		local ssbRightDetector = ssbBlobman:FindFirstChild("RightDetector");
		if not(ssbLeftDetector and ssbLeftDetector:FindFirstChild("RigidConstraint") and ssbRightDetector and ssbRightDetector:FindFirstChild("RigidConstraint")) then
			DestroyT(ssbBlobman);
			ssbBlobman:Destroy();
			return spawnandsitblob(ssbTargetPlayer);
		end
	end
	if not ssbBlobman then
		remotes.spawntoy:InvokeServer("CreatureBlobman", scriptState.hrp.CFrame, Vector3.new(0, -16.157, 0));
		ssbBlobman = scriptState.inv:WaitForChild("CreatureBlobman");
	end
	local ssbHRPCF = scriptState.hrp.CFrame;
	local ssbVehicleSeat = ssbBlobman:WaitForChild("VehicleSeat");
	while ssbVehicleSeat.Occupant ~= scriptState.humanoid do
		ssbVehicleSeat:Sit(scriptState.humanoid);
		task.wait(0.05);
	end
	scriptState.hrp.CFrame = ssbHRPCF + Vector3.new(0, 5, 0) ;
	scriptState.hrp.AssemblyLinearVelocity = Vector3.zero;
	scriptState.hrp.AssemblyAngularVelocity = Vector3.zero;
	local ssbBlobmanRef = encontrarBlobmanDoJogador();
	if not ssbBlobmanRef then
		task.wait();
		return spawnandsitblob(ssbTargetPlayer);
	end
	if (not ssbTargetPlayer or not ssbTargetPlayer.Character or not ssbTargetPlayer.Character:FindFirstChild("HumanoidRootPart")) then
		local ssbInvalidLog = " ";
		if (language == "pt-br") then
			logsTab:AddLabel(ssbInvalidLog .. " - Target invÃ¡lido!");
		else
			logsTab:AddLabel(ssbInvalidLog .. " - Invalid target!");
		end
		return ssbBlobmanRef;
	end
	local ssbTargetHRP = ssbTargetPlayer.Character.HumanoidRootPart;
	task.wait(0.2);
	local ssbTargetPos = ssbTargetHRP.Position + Vector3.new(0, 5, 0) ;
	scriptState.hrp.CFrame = CFrame.new(ssbTargetPos);
	scriptState.hrp.AssemblyLinearVelocity = Vector3.zero;
	scriptState.hrp.AssemblyAngularVelocity = Vector3.zero;
	task.wait(0.15);
	pcall(function()
		game:GetService("ReplicatedStorage")['GrabEvents']['SetNetworkOwner']:FireServer(ssbTargetHRP, ssbTargetHRP.CFrame);
	end);
	task.wait(0.1);
	if (ssbTargetPlayer.Character and ssbTargetPlayer.Character:FindFirstChild("HumanoidRootPart")) then
		ssbTargetHRP = ssbTargetPlayer.Character.HumanoidRootPart;
		ssbTargetHRP.CFrame = ssbTargetHRP.CFrame + Vector3.new(0, 100, 0) ;
		ssbTargetHRP.AssemblyLinearVelocity = Vector3.zero;
		ssbTargetHRP.AssemblyAngularVelocity = Vector3.zero;
	else
		return ssbBlobmanRef;
	end
	task.wait(0.3);
	if (ssbTargetPlayer.Character and ssbTargetPlayer.Character:FindFirstChild("HumanoidRootPart")) then
		ssbTargetHRP = ssbTargetPlayer.Character.HumanoidRootPart;
		local ssbNewTargetPos = ssbTargetHRP.Position + Vector3.new(0, 5, 0) ;
		scriptState.hrp.CFrame = CFrame.new(ssbNewTargetPos);
		scriptState.hrp.AssemblyLinearVelocity = Vector3.zero;
		scriptState.hrp.AssemblyAngularVelocity = Vector3.zero;
	else
		return ssbBlobmanRef;
	end
	task.wait(0.05);
	if (ssbTargetPlayer.Character and ssbTargetPlayer.Character:FindFirstChild("HumanoidRootPart")) then
		pcall(function()
			local ssbRightDet = ssbBlobmanRef:FindFirstChild("RightDetector");
			local ssbRightWeld = ssbRightDet and ssbRightDet:FindFirstChild("RightWeld") ;
			local ssbLeftDet = ssbBlobmanRef:FindFirstChild("LeftDetector");
			local ssbLeftWeld = ssbLeftDet and ssbLeftDet:FindFirstChild("LeftWeld") ;
			if ssbRightDet then
				local ssbRightGrabUnpack;
				if (grabMode == 1) then
					ssbRightGrabUnpack = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						ssbRightWeld
					};
				elseif (grabMode == 2) then
					ssbRightGrabUnpack = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 3) then
					ssbRightGrabUnpack = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 4) then
					ssbRightGrabUnpack = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.LrgDebris.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 5) then
					ssbRightGrabUnpack = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						ssbTargetPlayer.Character.HumanoidRootPart.RootAttachment
					};
				end
				if ssbRightGrabUnpack then
					ssbBlobmanRef:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(ssbRightGrabUnpack));
				end
			end
			task.wait(0.001);
			if ssbLeftDet then
				local ssbLeftGrabUnpack;
				if (grabMode == 1) then
					ssbLeftGrabUnpack = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						ssbLeftWeld
					};
				elseif (grabMode == 2) then
					ssbLeftGrabUnpack = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 3) then
					ssbLeftGrabUnpack = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 4) then
					ssbLeftGrabUnpack = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.LrgDebris.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 5) then
					ssbLeftGrabUnpack = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						ssbTargetPlayer.Character.HumanoidRootPart.RootAttachment
					};
				end
				if ssbLeftGrabUnpack then
					ssbBlobmanRef:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(ssbLeftGrabUnpack));
				end
			end
			task.wait(0.01);
			if ssbRightDet then
				local ssbRightGrabUnpack2;
				if (grabMode == 1) then
					ssbRightGrabUnpack2 = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						ssbRightWeld
					};
				elseif (grabMode == 2) then
					ssbRightGrabUnpack2 = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 3) then
					ssbRightGrabUnpack2 = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 4) then
					ssbRightGrabUnpack2 = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.LrgDebris.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 5) then
					ssbRightGrabUnpack2 = {
						ssbRightDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						ssbTargetPlayer.Character.HumanoidRootPart.RootAttachment
					};
				end
				if ssbRightGrabUnpack2 then
					ssbBlobmanRef:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(ssbRightGrabUnpack2));
				end
			end
			task.wait(0.001);
			if ssbLeftDet then
				local ssbLeftGrabUnpack2;
				if (grabMode == 1) then
					ssbLeftGrabUnpack2 = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						ssbLeftWeld
					};
				elseif (grabMode == 2) then
					ssbLeftGrabUnpack2 = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.Train.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 3) then
					ssbLeftGrabUnpack2 = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.InnerUFO.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 4) then
					ssbLeftGrabUnpack2 = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						workspace.Map.AlwaysHereTweenedObjects.LrgDebris.Object.FollowThisPart.AlignPosition
					};
				elseif (grabMode == 5) then
					ssbLeftGrabUnpack2 = {
						ssbLeftDet,
						ssbTargetPlayer.Character.HumanoidRootPart,
						ssbTargetPlayer.Character.HumanoidRootPart.RootAttachment
					};
				end
				if ssbLeftGrabUnpack2 then
					ssbBlobmanRef:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(ssbLeftGrabUnpack2));
				end
			end
		end);
		task.wait(0.3);
		local ssbBlobmanScript = ssbBlobmanRef:FindFirstChild("BlobmanSeatAndOwnerScript");
		local ssbCreatureDrop = ssbBlobmanScript and ssbBlobmanScript:FindFirstChild("CreatureDrop") ;
		if ssbCreatureDrop then
			local ssbLeftDet2 = ssbBlobmanRef:FindFirstChild("LeftDetector");
			local ssbRightDet2 = ssbBlobmanRef:FindFirstChild("RightDetector");
			if ssbLeftDet2 then
				local ssbLeftRigid = ssbLeftDet2:FindFirstChild("RigidConstraint");
				if (ssbLeftRigid and ssbLeftRigid.Attachment0) then
					pcall(function()
						ssbCreatureDrop:FireServer(ssbLeftRigid, ssbLeftRigid.Attachment0);
					end);
				end
			end
			if ssbRightDet2 then
				local ssbRightRigid = ssbRightDet2:FindFirstChild("RigidConstraint");
				if (ssbRightRigid and ssbRightRigid.Attachment0) then
					pcall(function()
						ssbCreatureDrop:FireServer(ssbRightRigid, ssbRightRigid.Attachment0);
					end);
				end
			end
			local ssbDropLog = " ";
			if (language == "pt-br") then
				logsTab:AddLabel(ssbDropLog .. " - Player solto!");
			else
				logsTab:AddLabel(ssbDropLog .. " - Player dropped!");
			end
		end
		task.wait(0.4);
		if (ssbTargetPlayer.Character and ssbTargetPlayer.Character:FindFirstChild("HumanoidRootPart")) then
			local ssbReposPos = ssbTargetPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0) ;
			scriptState.hrp.CFrame = CFrame.new(ssbReposPos);
			scriptState.hrp.AssemblyLinearVelocity = Vector3.zero;
			scriptState.hrp.AssemblyAngularVelocity = Vector3.zero;
			task.wait(0.15);
			pcall(function()
				blobGrabPlayer(ssbTargetPlayer, ssbBlobmanRef);
			end);
			local ssbGrabAgainLog = " ";
			if (language == "pt-br") then
				logsTab:AddLabel(ssbGrabAgainLog .. " - Player pegado novamente!");
			else
				logsTab:AddLabel(ssbGrabAgainLog .. " - Player grabbed again!");
			end
		end
		local ssbComboLog = " ";
		if (language == "pt-br") then
			logsTab:AddLabel(ssbComboLog .. " - Combo executado em " .. ssbTargetPlayer.Name);
		else
			logsTab:AddLabel(ssbComboLog .. " - Combo executed on " .. ssbTargetPlayer.Name);
		end
	end
	return ssbBlobmanRef;
end
local function hasActiveTargets()
	for blAlvoIdx, blAlvoObj in ipairs(_G.alvosSelecionados or {}) do
		if IsOwner(blAlvoObj) then
			continue;
		end
		if game.Players:FindFirstChild(blAlvoObj) then
			return true;
		end
	end
	return false;
end
local function startBlobmanCoroutine()
	if scriptState.blobmanCoroutine then
		return;
	end
	scriptState.blobmanCoroutine = coroutine.create(function()
		local blTarget = nil;
		for blAlvoIdx2, blAlvoObj2 in ipairs(_G.alvosSelecionados or {}) do
			if IsOwner(blAlvoObj2) then
				continue;
			end
			local blTarget2 = game.Players:FindFirstChild(blAlvoObj2);
			if blTarget2 then
				blTarget = blTarget2;
				break;
			end
		end
		if not blobmanRef then
			if (blobMode == 1) then
				blobmanRef = spawnandsitblob(blTarget);
			else
				blobmanRef = scriptState.inv:FindFirstChild("CreatureBlobman");
				if not blobmanRef then
					remotes.spawntoy:InvokeServer("CreatureBlobman", CFrame.new(0, 99999998430674940, 0), Vector3.new(0, -16.157, 0));
					blobmanRef = scriptState.inv:WaitForChild("CreatureBlobman");
				end
				if (blTarget and blTarget.Character and blTarget.Character:FindFirstChild("HumanoidRootPart")) then
					task.wait(0.2);
					local blTargetHRP = blTarget.Character.HumanoidRootPart;
					scriptState.hrp.CFrame = CFrame.new(blTargetHRP.Position + Vector3.new(0, 5, 0));
					scriptState.hrp.AssemblyLinearVelocity = Vector3.zero;
					scriptState.hrp.AssemblyAngularVelocity = Vector3.zero;
				end
			end
		end
		while hasActiveTargets() and blobmanLoopActive do
			if (blobMode == 1) then
				local blVehicleSeat = blobmanRef:FindFirstChild("VehicleSeat");
				local blSeatWeld = blVehicleSeat and blVehicleSeat:FindFirstChild("SeatWeld") ;
				if (not blSeatWeld or (blSeatWeld.Part1 ~= scriptState.hrp)) then
					task.wait(0.3);
					local blNewTarget = nil;
					for blSearchIdx, blSearchObj in ipairs(_G.alvosSelecionados or {}) do
						if IsOwner(blSearchObj) then
							continue;
						end
						local blFoundTarget = game.Players:FindFirstChild(blSearchObj);
						if blFoundTarget then
							blNewTarget = blFoundTarget;
							break;
						end
					end
					blobmanRef = spawnandsitblob(blNewTarget);
				end
			elseif ((blobMode == 2) and (not blobmanRef or not blobmanRef.Parent)) then
				blobmanRef = scriptState.inv:FindFirstChild("CreatureBlobman");
				if not blobmanRef then
					remotes.spawntoy:InvokeServer("CreatureBlobman", CFrame.new(0, 10000000000000000000, 0), Vector3.new(0, -16.157, 0));
					blobmanRef = scriptState.inv:WaitForChild("CreatureBlobman");
				end
			end
			for blGrabIdx, blGrabObj in ipairs(_G.alvosSelecionados or {}) do
				if IsOwner(blGrabObj) then
					continue;
				end
				local blGrabTarget = game.Players:FindFirstChild(blGrabObj);
				if (blGrabTarget and blobmanRef) then
					if (blobMode == 1) then
						blobGrabPlayer(blGrabTarget, blobmanRef);
					elseif (blobMode == 2) then
						BreakHeadJoint(blGrabTarget);
					end
					task.wait();
				end
			end
			task.wait();
		end
		coroutine.close(scriptState.blobmanCoroutine);
		scriptState.blobmanCoroutine = nil;
		blobmanRef = nil;
		local blDestroyBlobman = scriptState.inv:FindFirstChild("CreatureBlobman");
		if blDestroyBlobman then
			local blDestroySuccess, blDestroyErr = pcall(function()
				remotes.DestroyToy:FireServer(blDestroyBlobman);
			end);
		end
	end);
	coroutine.resume(scriptState.blobmanCoroutine);
end
local function stopBlobmanCoroutine()
	if scriptState.blobmanCoroutine then
		coroutine.close(scriptState.blobmanCoroutine);
		scriptState.blobmanCoroutine = nil;
		blobmanRef = nil;
		local blStopBlobman = scriptState.inv:FindFirstChild("CreatureBlobman");
		if blStopBlobman then
			pcall(function()
				remotes.DestroyToy:FireServer(blStopBlobman);
			end);
		end
	end
end
combatTab:AddParagraph("Blobman Loops", "loops using blobman");
local function clearBlobmanConnections()
	for blConnIdx, blConnObj in ipairs(blobmanConnections) do
		blConnObj:Disconnect();
	end
	blobmanConnections = {};
end
combatTab:AddToggle({
	Name = "Loop blobman",
	Default = false,
	Callback = function(loopBlobmanState)
		blobmanLoopActive = loopBlobmanState;
		clearBlobmanConnections();
		if loopBlobmanState then
			table.insert(blobmanConnections, game.Players.PlayerAdded:Connect(checkAndStartBlobmanLoop));
			table.insert(blobmanConnections, game.Players.PlayerRemoving:Connect(function()
				task.delay(0.2, checkAndStartBlobmanLoop);
			end));
			checkAndStartBlobmanLoop();
		else
			stopBlobmanCoroutine();
		end
	end
});
combatTab:AddDropdown({
	Name = "Grab Mode",
	Default = "Hand",
	Options = {
		"Hand",
		"Train",
		"Ufo",
		"Rock",
		"own rootpart - Beta"
	},
	Callback = function(grabModeVal)
		if (grabModeVal == "Hand") then
			grabMode = 1;
		elseif (grabModeVal == "Train") then
			grabMode = 2;
		elseif (grabModeVal == "Ufo") then
			grabMode = 3;
		elseif (grabModeVal == "Rock") then
			grabMode = 4;
		elseif (grabModeVal == "own rootpart - Beta") then
			grabMode = 5;
		end
	end
});
combatTab:AddDropdown({
	Name = "Blob Mode",
	Default = "Type 1",
	Options = {
		"Type1",
		"Type2"
	},
	Callback = function(blobModeVal)
		if (blobModeVal == "Type1") then
			blobMode = 1;
		elseif (blobModeVal == "Type2") then
			blobMode = 2;
		end
	end
});
combatTab:AddParagraph("Loops", "loops that use map items/things");
combatTab:AddToggle({
	Name = "Loop grab",
	Default = false,
	Callback = function(loopGrabState)
		_G.loopKill = loopGrabState;
		if loopGrabState then
			task.spawn(function()
				local function loopGrabSetOwner(loopGrabPart)
					game:GetService("ReplicatedStorage")['GrabEvents']['SetNetworkOwner']:FireServer(loopGrabPart, loopGrabPart.CFrame);
				end
				for loopGrabAlvoIdx, loopGrabAlvoObj in ipairs(_G.alvosSelecionados or {}) do
					if IsOwner(loopGrabAlvoObj) then
						continue;
					end
					task.spawn(function()
						while _G.loopKill do
							local loopGrabTarget = game.Players:FindFirstChild(loopGrabAlvoObj);
							if not loopGrabTarget then
								task.wait(0.5);
								continue;
							end
							local loopGrabTargetChar = loopGrabTarget.Character;
							if not loopGrabTargetChar then
								loopGrabTargetChar = loopGrabTarget.CharacterAdded:Wait();
							end
							local loopGrabTargetHRP = loopGrabTargetChar:WaitForChild("HumanoidRootPart", 5);
							local loopGrabTargetHumanoid = loopGrabTargetChar:WaitForChild("Humanoid", 5);
							if (not loopGrabTargetHRP or not loopGrabTargetHumanoid) then
								task.wait(0.5);
								continue;
							end
							local loopGrabOwned = false;
							while not loopGrabOwned and _G.loopKill do
								if (loopGrabTarget.Character ~= loopGrabTargetChar) then
									break;
								end
								scriptState.hrp.CFrame = loopGrabTargetHRP.CFrame;
								loopGrabSetOwner(loopGrabTargetHRP);
								task.wait(0.05);
								if (loopGrabTargetHRP:FindFirstChild("PartOwner") and (loopGrabTargetHRP.PartOwner.Value == LocalPlayer.Name)) then
									loopGrabOwned = true;
								else
									task.wait(0.05);
								end
							end
							if not _G.loopKill then
								break;
							end
							if not loopGrabOwned then
								local loopGrabWaitChar2 = loopGrabTarget.Character or loopGrabTarget.CharacterAdded:Wait() ;
								loopGrabWaitChar2:WaitForChild("HumanoidRootPart", 5);
								task.wait(0.3);
								continue;
							end
							local loopGrabOceanPart = workspace.Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel:GetChildren()[22];
							loopGrabTargetHRP.CFrame = loopGrabOceanPart.CFrame;
							local loopGrabDied = false;
							local loopGrabDiedConn = loopGrabTargetHumanoid.Died:Connect(function()
								loopGrabDied = true;
							end);
							local loopGrabDiedStart = tick();
							while not loopGrabDied and _G.loopKill and ((tick() - loopGrabDiedStart) < 5) do
								if (loopGrabTarget.Character ~= loopGrabTargetChar) then
									loopGrabDied = true;
								end
								task.wait(0.1);
							end
							loopGrabDiedConn:Disconnect();
							if not _G.loopKill then
								break;
							end
							local loopGrabWaitChar = loopGrabTarget.Character or loopGrabTarget.CharacterAdded:Wait() ;
							loopGrabWaitChar:WaitForChild("HumanoidRootPart", 5);
							task.wait(0.3);
						end
					end);
				end
				local loopGrabLog = " ";
				if (language == "pt-br") then
					logsTab:AddLabel(loopGrabLog .. " - Loop Kill Ativado");
				else
					logsTab:AddLabel(loopGrabLog .. " - Loop Kill Enabled");
				end
			end);
		else
			local loopGrabDisableLog = " ";
			if (language == "pt-br") then
				logsTab:AddLabel(loopGrabDisableLog .. " - Loop Kill Desativado");
			else
				logsTab:AddLabel(loopGrabDisableLog .. " - Loop Kill Disabled");
			end
		end
	end
});
combatTab:AddToggle({
	Name = "Destroy Gucci Sit",
	Default = false,
	Callback = function(destroyGucciState)
		_G.DestroyGucciActive = destroyGucciState;
		if destroyGucciState then
			if (not _G.alvosSelecionados or (# _G.alvosSelecionados == 0)) then
				OrionLib:MakeNotification({
					Name = "âŒ Erro",
					Content = ((language == "pt-br") and "Selecione pelo menos um alvo no dropdown!") or "Select at least one target in dropdown!",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
				return;
			end
			task.spawn(function()
				local dgRunService = game:GetService("RunService");
				local dgChar = LocalPlayer.Character;
				local dgHRP = dgChar and dgChar:FindFirstChild("HumanoidRootPart") ;
				local dgHumanoid = dgChar and dgChar:FindFirstChild("Humanoid") ;
				if (not dgHRP or not dgHumanoid) then
					_G.DestroyGucciActive = false;
					return;
				end
				local dgStartCF = dgHRP.CFrame;
				if (language == "pt-br") then
					logsTab:AddLabel(_G.horario .. " - Destroy Gucci ATIVADO para " .. # _G.alvosSelecionados .. " alvo(s)");
				else
					logsTab:AddLabel(_G.horario .. " - Destroy Gucci ENABLED for " .. # _G.alvosSelecionados .. " target(s)");
				end
				while _G.DestroyGucciActive do
					dgChar = LocalPlayer.Character;
					dgHRP = dgChar and dgChar:FindFirstChild("HumanoidRootPart") ;
					dgHumanoid = dgChar and dgChar:FindFirstChild("Humanoid") ;
					if (not dgHRP or not dgHumanoid) then
						break;
					end
					for dgAlvoIdx, dgAlvoObj in ipairs(_G.alvosSelecionados or {}) do
						if IsOwner(dgAlvoObj) then
							continue;
						end
						if not _G.DestroyGucciActive then
							break;
						end
						local dgTargetPlayer = players:FindFirstChild(dgAlvoObj);
						if (dgTargetPlayer and dgTargetPlayer.Parent) then
							local dgToysName = dgAlvoObj .. "SpawnedInToys" ;
							local dgToysFolder = workspace:FindFirstChild(dgToysName);
							if dgToysFolder then
								for dgToyIdx, dgToyObj in ipairs(dgToysFolder:GetChildren()) do
									if not _G.DestroyGucciActive then
										break;
									end
									if (dgToyObj.Name == "CreatureBlobman") then
										local dgVehicleSeat = dgToyObj:FindFirstChild("VehicleSeat") or dgToyObj:FindFirstChildWhichIsA("VehicleSeat", true) ;
										if dgVehicleSeat then
											if (dgHumanoid.SeatPart ~= dgVehicleSeat) then
												local dgSteppedConn;
												dgSteppedConn = dgRunService.Stepped:Connect(function()
													if (dgHRP and dgVehicleSeat) then
														dgHRP.CFrame = dgVehicleSeat.CFrame;
														dgHRP.Velocity = Vector3.zero;
														if dgToyObj.PrimaryPart then
															dgToyObj.PrimaryPart.Velocity = Vector3.zero;
															dgToyObj.PrimaryPart.RotVelocity = Vector3.zero;
														end
													end
												end);
												local dgSitStart = tick();
												while (tick() - dgSitStart) < 1 do
													if not _G.DestroyGucciActive then
														break;
													end
													if (dgHumanoid.SeatPart == dgVehicleSeat) then
														break;
													end
													dgVehicleSeat:Sit(dgHumanoid);
													task.wait();
												end
												if dgSteppedConn then
													dgSteppedConn:Disconnect();
												end
												if (dgHumanoid.SeatPart == dgVehicleSeat) then
													task.wait(0.3);
													dgHumanoid.Sit = false;
													dgHumanoid.Jump = true;
													task.wait(0.05);
													dgHRP.CFrame = dgStartCF;
													dgHRP.Velocity = Vector3.zero;
													if (language == "pt-br") then
														logsTab:AddLabel(_G.horario .. " - Gucci de " .. dgAlvoObj .. " removido!");
													else
														logsTab:AddLabel(_G.horario .. " - " .. dgAlvoObj .. "'s Gucci removed!");
													end
													task.wait(0.5);
												else
													dgHRP.CFrame = dgStartCF;
												end
											end
										end
									end
								end
							end
						end
					end
					task.wait(1);
				end
				if (language == "pt-br") then
					logsTab:AddLabel(_G.horario .. " - Destroy Gucci DESATIVADO");
				else
					logsTab:AddLabel(_G.horario .. " - Destroy Gucci DISABLED");
				end
			end);
		end
	end
});
_G.LoopKickBlobActive = false;
_G.LoopKickBlobActive = false;
combatTab:AddToggle({
	Name = "Loop Kick (Blob + Spam Grab)",
	Default = false,
	Callback = function(loopKickBlobState)
		_G.LoopKickBlobActive = loopKickBlobState;
		if loopKickBlobState then
			if (not _G.alvosSelecionados or (# _G.alvosSelecionados == 0)) then
				_G.LoopKickBlobActive = false;
				return;
			end
			task.spawn(function()
				local lkbPlayers = game:GetService("Players");
				local lkbLocalPlayer = lkbPlayers.LocalPlayer;
				local lkbReplicatedStorage = game:GetService("ReplicatedStorage");
				local lkbRunService = game:GetService("RunService");
				local function lkbGetBlobman()
					local lkbGetChar = lkbLocalPlayer.Character;
					local lkbGetHRP = lkbGetChar and lkbGetChar:FindFirstChild("HumanoidRootPart") ;
					if not lkbGetHRP then
						return false;
					end
					local lkbToysName = lkbLocalPlayer.Name .. "SpawnedInToys" ;
					local lkbToysFolder = workspace:FindFirstChild(lkbToysName);
					local lkbBlobToy = lkbToysFolder and lkbToysFolder:FindFirstChild("CreatureBlobman") ;
					if not lkbBlobToy then
						pcall(function()
							lkbReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("CreatureBlobman", lkbGetHRP.CFrame, Vector3.zero);
						end);
						task.wait(0.5);
						if not lkbToysFolder then
							lkbToysFolder = workspace:WaitForChild(lkbToysName, 5);
						end
						if lkbToysFolder then
							lkbBlobToy = lkbToysFolder:WaitForChild("CreatureBlobman", 5);
						end
					end
					return lkbBlobToy;
				end
				local function lkbSitOnBlobman(lkbBlobToyArg)
					local lkbSitChar = lkbLocalPlayer.Character;
					local lkbSitHRP = lkbSitChar and lkbSitChar:FindFirstChild("HumanoidRootPart") ;
					local lkbSitHumanoid = lkbSitChar and lkbSitChar:FindFirstChild("Humanoid") ;
					if (not lkbSitHRP or not lkbSitHumanoid or not lkbBlobToyArg) then
						return false;
					end
					local lkbSitVehicleSeat = lkbBlobToyArg:WaitForChild("VehicleSeat", 5);
					if not lkbSitVehicleSeat then
						return false;
					end
					local lkbSitStartTick = tick();
					repeat
						if not lkbSitHumanoid.SeatPart then
							lkbSitHRP.CFrame = lkbSitVehicleSeat.CFrame + Vector3.new(0, 1, 0) ;
							lkbSitHRP.Velocity = Vector3.zero;
							lkbSitVehicleSeat:Sit(lkbSitHumanoid);
						end
						lkbRunService.Heartbeat:Wait();
					until (lkbSitHumanoid.SeatPart == lkbSitVehicleSeat) or ((tick() - lkbSitStartTick) > 1.5)
					return lkbSitHumanoid.SeatPart == lkbSitVehicleSeat ;
				end
				local lkbBlobman = lkbGetBlobman();
				if not lkbBlobman then
					_G.LoopKickBlobActive = false;
					return;
				end
				local lkbSitResult = lkbSitOnBlobman(lkbBlobman);
				if not lkbSitResult then
					_G.LoopKickBlobActive = false;
					return;
				end
				task.wait(0.3);
				local lkbChar = lkbLocalPlayer.Character;
				local lkbHumanoid = lkbChar and lkbChar:FindFirstChild("Humanoid") ;
				local lkbSeatPart = lkbHumanoid and lkbHumanoid.SeatPart ;
				if (not lkbSeatPart or (lkbSeatPart.Parent.Name ~= "CreatureBlobman")) then
					_G.LoopKickBlobActive = false;
					return;
				end
				local lkbGrabEvents = lkbReplicatedStorage:WaitForChild("GrabEvents");
				local lkbBlobHRP = lkbBlobman:FindFirstChild("HumanoidRootPart") or lkbBlobman.PrimaryPart ;
				local lkbBlobScript = lkbBlobman:FindFirstChild("BlobmanSeatAndOwnerScript");
				local lkbCreatureGrab = lkbBlobScript and lkbBlobScript:FindFirstChild("CreatureGrab") ;
				local lkbCreatureDrop = lkbBlobScript and lkbBlobScript:FindFirstChild("CreatureDrop") ;
				local lkbRightDetector = lkbBlobman:FindFirstChild("RightDetector");
				local lkbRightWeld = lkbRightDetector and (lkbRightDetector:FindFirstChild("RightWeld") or lkbRightDetector:FindFirstChildWhichIsA("Weld")) ;
				local lkbStartCF = lkbBlobHRP.CFrame;
				local lkbFirstTarget = _G.alvosSelecionados[1];
				local lkbTarget = lkbPlayers:FindFirstChild(lkbFirstTarget);
				if not lkbTarget then
					_G.LoopKickBlobActive = false;
					return;
				end
				local function lkbGrabSequence(lkbSeqHRP, lkbSeqTarget)
					if (not lkbSeqTarget or not lkbBlobHRP) then
						return;
					end
					local lkbSeqTick = tick();
					while (tick() - lkbSeqTick) < 0.35 do
						if not _G.LoopKickBlobActive then
							break;
						end
						lkbBlobHRP.CFrame = lkbSeqTarget.CFrame;
						lkbBlobHRP.Velocity = Vector3.zero;
						pcall(function()
							if (lkbCreatureGrab and lkbRightDetector) then
								lkbCreatureGrab:FireServer(lkbRightDetector, lkbSeqTarget, lkbRightWeld);
							end
							lkbGrabEvents.CreateGrabLine:FireServer(lkbSeqTarget, Vector3.zero, lkbSeqTarget.Position, false);
							lkbGrabEvents.SetNetworkOwner:FireServer(lkbSeqTarget, lkbBlobHRP.CFrame);
						end);
						lkbRunService.Heartbeat:Wait();
					end
					lkbBlobHRP.CFrame = lkbStartCF;
					lkbBlobHRP.Velocity = Vector3.zero;
					task.wait(0.05);
				end
				local lkbTargetChar = lkbTarget.Character;
				local lkbTargetHRP = lkbTargetChar and lkbTargetChar:FindFirstChild("HumanoidRootPart") ;
				lkbGrabSequence(lkbTargetChar, lkbTargetHRP);
				local lkbLastTick = 0;
				while _G.LoopKickBlobActive do
					if (not lkbTarget or not lkbTarget.Parent) then
						break;
					end
					local lkbLoopChar = lkbTarget.Character;
					if not lkbLoopChar then
						lkbLoopChar = lkbTarget.CharacterAdded:Wait();
						lkbLoopChar:WaitForChild("HumanoidRootPart", 5);
						task.wait(0.3);
						local lkbLoopWaitHRP = lkbLoopChar:FindFirstChild("HumanoidRootPart");
						lkbGrabSequence(lkbLoopChar, lkbLoopWaitHRP);
						lkbTargetChar = lkbLoopChar;
						lkbTargetHRP = lkbLoopWaitHRP;
						continue;
					end
					local lkbLoopHRP = lkbLoopChar:FindFirstChild("HumanoidRootPart");
					local lkbLoopHumanoid = lkbLoopChar:FindFirstChild("Humanoid");
					if ((lkbLoopChar ~= lkbTargetChar) or (lkbLoopHRP ~= lkbTargetHRP)) then
						lkbTargetChar = lkbLoopChar;
						lkbTargetHRP = lkbLoopHRP;
						lkbLoopHRP = lkbTargetHRP;
						lkbGrabSequence(lkbTargetChar, lkbTargetHRP);
						continue;
					end
					if (lkbLoopHRP and lkbLoopHumanoid and (lkbLoopHumanoid.Health > 0) and lkbBlobHRP) then
						lkbBlobHRP.CFrame = lkbStartCF;
						lkbBlobHRP.Velocity = Vector3.zero;
						local lkbAboveCF = lkbStartCF * CFrame.new(0, 27, 0) ;
						lkbLoopHRP.CFrame = lkbAboveCF;
						lkbLoopHRP.Velocity = Vector3.zero;
						lkbLoopHRP.RotVelocity = Vector3.zero;
						if ((tick() - lkbLastTick) > 0.05) then
							lkbLastTick = tick();
							pcall(function()
								lkbLoopHumanoid.PlatformStand = true;
								lkbLoopHumanoid.Sit = true;
								lkbGrabEvents.SetNetworkOwner:FireServer(lkbLoopHRP, lkbAboveCF);
								if lkbRightDetector then
									local lkbAltWeld = lkbRightDetector:FindFirstChild("RightWeld") or lkbRightDetector:FindFirstChildWhichIsA("Weld") ;
									if lkbAltWeld then
										lkbCreatureDrop:FireServer(lkbAltWeld);
									end
								end
								lkbGrabEvents.DestroyGrabLine:FireServer(lkbLoopHRP);
								if lkbRightDetector then
									lkbCreatureGrab:FireServer(lkbRightDetector, lkbLoopHRP, lkbRightWeld);
								end
								lkbGrabEvents.CreateGrabLine:FireServer(lkbLoopHRP, Vector3.zero, lkbLoopHRP.Position, false);
							end);
						end
					elseif lkbBlobHRP then
						lkbBlobHRP.CFrame = lkbStartCF;
						lkbBlobHRP.Velocity = Vector3.zero;
					end
					if not _G.LoopKickBlobActive then
						break;
					end
					lkbRunService.Heartbeat:Wait();
				end
				_G.LoopKickBlobActive = false;
				if lkbBlobHRP then
					lkbBlobHRP.CFrame = lkbStartCF;
					lkbBlobHRP.Velocity = Vector3.zero;
				end
			end);
		else
			_G.LoopKickBlobActive = false;
		end
	end
});
_G.KillPermOwner = false;
local function spawnAndSitBlobman()
	local kpoPlayers = game:GetService("Players");
	local kpoLocalPlayer = kpoPlayers.LocalPlayer;
	local kpoChar = kpoLocalPlayer.Character or kpoLocalPlayer.CharacterAdded:Wait() ;
	local kpoHRP = kpoChar:WaitForChild("HumanoidRootPart");
	local kpoHumanoid = kpoChar:WaitForChild("Humanoid");
	local kpoSpawnedToys = workspace:FindFirstChild(kpoLocalPlayer.Name .. "SpawnedInToys");
	if not kpoSpawnedToys then
		return nil;
	end
	local kpoBlobman = kpoSpawnedToys:FindFirstChild("CreatureBlobman");
	if not kpoBlobman then
		remotes.spawntoy:InvokeServer("CreatureBlobman", kpoHRP.CFrame, Vector3.new(0, -16.157, 0));
		kpoBlobman = kpoSpawnedToys:WaitForChild("CreatureBlobman", 3);
	end
	if not kpoBlobman then
		return nil;
	end
	local kpoVehicleSeat = kpoBlobman:WaitForChild("VehicleSeat");
	while kpoVehicleSeat.Occupant ~= kpoHumanoid do
		kpoVehicleSeat:Sit(kpoHumanoid);
		task.wait();
	end
	return kpoBlobman;
end
_G.KillPermOwner = false;
combatTab:AddToggle({
	Name = "Kill Perm Owner",
	Default = false,
	Callback = function(killPermOwnerState)
		_G.KillPermOwner = killPermOwnerState;
		if killPermOwnerState then
			task.spawn(function()
				local kpoPlayers2 = game:GetService("Players");
				local kpoLP2 = kpoPlayers2.LocalPlayer;
				local kpoChar2 = kpoLP2.Character or kpoLP2.CharacterAdded:Wait() ;
				local kpoHRP2 = kpoChar2:WaitForChild("HumanoidRootPart");
				local kpoBlobman2 = spawnAndSitBlobman();
				if not kpoBlobman2 then
					return;
				end
				local kpoBlobScript = kpoBlobman2:WaitForChild("BlobmanSeatAndOwnerScript");
				local kpoCreatureGrab = kpoBlobScript:WaitForChild("CreatureGrab");
				local kpoCreatureRelease = kpoBlobScript:WaitForChild("CreatureRelease");
				local kpoRightDetector = kpoBlobman2:WaitForChild("RightDetector");
				local kpoRightWeld = kpoRightDetector:WaitForChild("RightWeld");
				while _G.KillPermOwner do
					if (not kpoBlobman2 or not kpoBlobman2.Parent) then
						kpoBlobman2 = spawnAndSitBlobman();
						if not kpoBlobman2 then
							task.wait(0.25);
							continue;
						end
					end
					for kpoAlvoIdx, kpoAlvoObj in ipairs(_G.alvosSelecionados or {}) do
						if IsOwner(kpoAlvoObj) then
							continue;
						end
						local kpoAlvoPlayer = kpoPlayers2:FindFirstChild(kpoAlvoObj);
						if (kpoAlvoPlayer and kpoAlvoPlayer.Character) then
							local kpoAlvoChar = kpoAlvoPlayer.Character;
							local kpoAlvoHumanoid = kpoAlvoChar:FindFirstChild("Humanoid");
							local kpoAlvoHRP = kpoAlvoChar:FindFirstChild("HumanoidRootPart");
							if (kpoAlvoHumanoid and kpoAlvoHRP) then
								kpoBlobman2.HumanoidRootPart.CFrame = kpoAlvoHRP.CFrame;
								kpoAlvoHumanoid.BreakJointsOnDeath = false;
								kpoCreatureGrab:FireServer(kpoRightDetector, kpoAlvoHRP, kpoRightWeld);
								kpoCreatureGrab:FireServer(kpoRightDetector, kpoHRP2, kpoRightWeld);
								kpoCreatureGrab:FireServer(kpoRightDetector, kpoAlvoHRP, kpoRightWeld);
								kpoCreatureRelease:FireServer(kpoRightWeld);
								kpoAlvoHumanoid:ChangeState(Enum.HumanoidStateType.Dead);
							end
						end
					end
					task.wait(0.25);
				end
			end);
		end
	end
});
combatTab:AddParagraph("Spawn itens inside your the safe to use this option", "enjoy");
_G.InstrumentAuraActive = false;
_G.auraAlvosSelecionados = {};
combatTab:AddPlayerDropdown({
	Name = ((language == "pt-br") and "Alvo da Aura") or "Aura Target",
	Callback = function(auraDropdownData)
		local auraFiltered = {};
		for auraDropIdx, auraDropObj in ipairs(auraDropdownData) do
			if IsOwner(auraDropObj) then
				OrionLib:MakeNotification({
					Name = "Instrument Aura",
					Content = "This player is owner",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
			else
				table.insert(auraFiltered, auraDropObj);
			end
		end
		_G.auraAlvosSelecionados = auraFiltered;
	end,
	Save = false,
	Flag = "AuraPlayerDropdown"
});
local function removePlayerFromAura(auraLeftPlayer)
	if _G.auraAlvosSelecionados then
		for auraAlvosIdx, auraAlvosObj in ipairs(_G.auraAlvosSelecionados) do
			if (auraAlvosObj == auraLeftPlayer) then
				table.remove(_G.auraAlvosSelecionados, auraAlvosIdx);
				break;
			end
		end
	end
	if (OrionLib.Flags and OrionLib.Flags['AuraPlayerDropdown']) then
		local auraDropDown = OrionLib.Flags['AuraPlayerDropdown'];
		if auraDropDown.Set then
			auraDropDown:Set({});
		end
	end
end
players.PlayerRemoving:Connect(function(auraRemovedPlayer)
	removePlayerFromAura(auraRemovedPlayer.Name);
end);
combatTab:AddToggle({
	Name = "Instrument Aura (troll)",
	Default = false,
	Callback = function(instrumentAuraState)
		_G.InstrumentAuraActive = instrumentAuraState;
		if instrumentAuraState then
			task.spawn(function()
				if (not _G.auraAlvosSelecionados or (# _G.auraAlvosSelecionados == 0)) then
					OrionLib:MakeNotification({
						Name = "Instrument Aura",
						Content = ((language == "pt-br") and "Selecione pelo menos um alvo!") or "Select at least one target!",
						Image = "rbxassetid://4483345998",
						Time = 3
					});
					_G.InstrumentAuraActive = false;
					return;
				end
				local auraRadius = 12;
				local auraHeight = 3;
				local auraSpeed = 0.05;
				local auraSetOwner = ReplicatedStorage.GrabEvents.SetNetworkOwner;
				local auraUseEvent = ReplicatedStorage.HoldEvents.Use;
				local function auraSetOwnerFunc(auraPart)
					auraSetOwner:FireServer(auraPart, auraPart.CFrame);
				end
				local auraPlotItems = FindMyPlot();
				if not auraPlotItems then
					OrionLib:MakeNotification({
						Name = "Instrument Aura",
						Content = ((language == "pt-br") and "VocÃª nÃ£o tem um plot!") or "You don't have a plot!",
						Image = "rbxassetid://4483345998",
						Time = 3
					});
					_G.InstrumentAuraActive = false;
					return;
				end
				local auraInstruments = {};
				for auraInstIdx, auraInstObj in pairs(auraPlotItems:GetChildren()) do
					if not string.find(auraInstObj.Name, "Instrument") then
						continue;
					end
					local auraHoldPart = auraInstObj:FindFirstChild("HoldPart");
					if not auraHoldPart then
						continue;
					end
					local auraHoldRemote = auraHoldPart:FindFirstChild("HoldItemRemoteFunction");
					local auraDropRemote = auraHoldPart:FindFirstChild("DropItemRemoteFunction");
					local auraMain = auraInstObj:FindFirstChild("Main");
					local auraSoundPart = auraInstObj:FindFirstChild("SoundPart");
					if (auraHoldRemote and auraDropRemote and auraMain) then
						table.insert(auraInstruments, {
							mdl = auraInstObj,
							main = auraMain,
							soundPart = auraSoundPart or auraMain,
							hold = auraHoldRemote,
							drop = auraDropRemote
						});
					end
				end
				if (# auraInstruments == 0) then
					OrionLib:MakeNotification({
						Name = "Instrument Aura",
						Content = ((language == "pt-br") and "Nenhum instrumento no seu plot!") or "No instruments in your plot!",
						Image = "rbxassetid://4483345998",
						Time = 3
					});
					_G.InstrumentAuraActive = false;
					return;
				end
				local auraChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() ;
				local auraHRP = auraChar:WaitForChild("HumanoidRootPart");
				for auraSetupIdx, auraSetupObj in ipairs(auraInstruments) do
					if not _G.InstrumentAuraActive then
						break;
					end
					auraHRP.CFrame = auraSetupObj.main.CFrame + Vector3.new(0, 3, 0) ;
					task.wait(0.05);
					pcall(function()
						auraSetupObj.hold:InvokeServer(auraSetupObj.mdl, auraChar);
						task.wait(0.05);
						auraUseEvent:FireServer(auraSetupObj.mdl);
						auraSetupObj.drop:InvokeServer(auraSetupObj.mdl);
					end);
					task.wait(0.05);
					auraHRP.CFrame = auraSetupObj.soundPart.CFrame + Vector3.new(0, 3, 0) ;
					task.wait(0.05);
					auraSetOwnerFunc(auraSetupObj.soundPart);
					task.wait(0.1);
				end
				task.wait(0.3);
				for auraOrbitIdx, auraOrbitObj in ipairs(auraInstruments) do
					local auraMainPart = auraOrbitObj.main;
					auraMainPart.Anchored = false;
					auraMainPart.CanCollide = false;
					if auraMainPart:FindFirstChild("AuraBodyPosition") then
						auraMainPart.AuraBodyPosition:Destroy();
					end
					if auraMainPart:FindFirstChild("AuraBodyGyro") then
						auraMainPart.AuraBodyGyro:Destroy();
					end
					local auraBodyPos = Instance.new("BodyPosition");
					auraBodyPos.Name = "AuraBodyPosition";
					auraBodyPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
					auraBodyPos.D = 500;
					auraBodyPos.P = 10000;
					auraBodyPos.Position = auraMainPart.Position;
					auraBodyPos.Parent = auraMainPart;
					local auraBodyGyro = Instance.new("BodyGyro");
					auraBodyGyro.Name = "AuraBodyGyro";
					auraBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge);
					auraBodyGyro.D = 500;
					auraBodyGyro.P = 10000;
					auraBodyGyro.CFrame = auraMainPart.CFrame;
					auraBodyGyro.Parent = auraMainPart;
				end
				OrionLib:MakeNotification({
					Name = "Instrument Aura",
					Content = ((language == "pt-br") and "Aura iniciada!") or "Aura started!",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
				local auraAngle = 0;
				while _G.InstrumentAuraActive do
					task.wait(0);
					local auraCurrentTarget = _G.auraAlvosSelecionados and _G.auraAlvosSelecionados[1] ;
					if not auraCurrentTarget then
						task.wait(1);
						continue;
					end
					local auraTargetPlayer = players:FindFirstChild(auraCurrentTarget);
					if not auraTargetPlayer then
						task.wait(1);
						continue;
					end
					local auraTargetHRP = auraTargetPlayer.Character and auraTargetPlayer.Character:FindFirstChild("HumanoidRootPart") ;
					if not auraTargetHRP then
						continue;
					end
					auraAngle = auraAngle + auraSpeed ;
					local auraSafeHeight = (_G.SafeBlockHidden and 85) or auraHeight ;
					for auraRotIdx, auraRotObj in ipairs(auraInstruments) do
						local auraRotBodyPos = auraRotObj.main:FindFirstChild("AuraBodyPosition");
						if not auraRotBodyPos then
							continue;
						end
						local auraAngleRad = ((2 * math.pi) / # auraInstruments) * (auraRotIdx - 1) ;
						local auraFinalAngle = auraAngle + auraAngleRad ;
						auraRotBodyPos.Position = Vector3.new(auraTargetHRP.Position.X + (math.cos(auraFinalAngle) * auraRadius), auraTargetHRP.Position.Y + auraSafeHeight, auraTargetHRP.Position.Z + (math.sin(auraFinalAngle) * auraRadius));
					end
				end
				for auraCleanupIdx, auraCleanupObj in ipairs(auraInstruments) do
					if auraCleanupObj.main:FindFirstChild("AuraBodyPosition") then
						auraCleanupObj.main.AuraBodyPosition:Destroy();
					end
					if auraCleanupObj.main:FindFirstChild("AuraBodyGyro") then
						auraCleanupObj.main.AuraBodyGyro:Destroy();
					end
				end
			end);
		end
	end
});
combatTab:AddToggle({
	Name = "Safe Block (Aura)",
	Default = false,
	Callback = function(safeBlockState)
		_G.SafeBlockActive = safeBlockState;
		if not safeBlockState then
			_G.SafeBlockHidden = false;
		end
		if safeBlockState then
			task.spawn(function()
				while _G.SafeBlockActive do
					task.wait(0.3);
					if not _G.InstrumentAuraActive then
						_G.SafeBlockHidden = false;
						continue;
					end
					local sbAuraTarget = _G.auraAlvosSelecionados and _G.auraAlvosSelecionados[1] ;
					if not sbAuraTarget then
						_G.SafeBlockHidden = false;
						continue;
					end
					local sbPlayersInPlots = workspace.PlotItems:FindFirstChild("PlayersInPlots");
					local sbTargetInPlot = sbPlayersInPlots and (sbPlayersInPlots:FindFirstChild(sbAuraTarget) ~= nil) ;
					_G.SafeBlockHidden = sbTargetInPlot;
				end
				_G.SafeBlockHidden = false;
			end);
		end
	end
});
_G.BananaTripActive = false;
_G.bananaAlvoSelecionado = nil;
combatTab:AddParagraph("Loop Banana", ((language == "pt-br") and "Faz o alvo escorregar na casca de banana") or "Makes the target slip on a banana peel");
combatTab:AddPlayerDropdown({
	Name = ((language == "pt-br") and "Alvo da Banana") or "Banana Target",
	Callback = function(bananaDropdownData)
		if (bananaDropdownData and (# bananaDropdownData > 0)) then
			local bananaFirstTarget = bananaDropdownData[1];
			if IsOwner(bananaFirstTarget) then
				OrionLib:MakeNotification({
					Name = "Banana Loop",
					Content = "This player is owner",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
				_G.bananaAlvoSelecionado = nil;
			else
				_G.bananaAlvoSelecionado = bananaFirstTarget;
			end
		else
			_G.bananaAlvoSelecionado = nil;
		end
	end,
	Save = false,
	Flag = "BananaPlayerDropdown"
});
local function clearBananaTarget(bananaLeftPlayer)
	if (_G.bananaAlvoSelecionado == bananaLeftPlayer) then
		_G.bananaAlvoSelecionado = nil;
	end
	if (OrionLib.Flags and OrionLib.Flags['BananaPlayerDropdown']) then
		local bananaDropdown = OrionLib.Flags['BananaPlayerDropdown'];
		if bananaDropdown.Set then
			bananaDropdown:Set({});
		end
	end
end
players.PlayerRemoving:Connect(function(bananaRemovedPlayer)
	clearBananaTarget(bananaRemovedPlayer.Name);
end);
combatTab:AddToggle({
	Name = "Loop Banana",
	Default = false,
	Callback = function(bananaLoopState)
		_G.BananaTripActive = bananaLoopState;
		if bananaLoopState then
			task.spawn(function()
				if not _G.bananaAlvoSelecionado then
					OrionLib:MakeNotification({
						Name = "Loop Banana",
						Content = ((language == "pt-br") and "Selecione um alvo no dropdown!") or "Select a target in the dropdown!",
						Image = "rbxassetid://4483345998",
						Time = 3
					});
					_G.BananaTripActive = false;
					return;
				end
				local blpLocalPlayer = services.Players.LocalPlayer;
				local blpChar = blpLocalPlayer.Character or blpLocalPlayer.CharacterAdded:Wait() ;
				local blpReplicatedStorage = game:GetService("ReplicatedStorage");
				local blpSpawnToy = blpReplicatedStorage.MenuToys.SpawnToyRemoteFunction;
				local function blpSetOwner(blpPartArg)
					blpReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(blpPartArg, blpPartArg.CFrame);
				end
				local function blpFindPlotItems()
					local blpPlots = workspace:FindFirstChild("Plots");
					if not blpPlots then
						return nil;
					end
					for blpPlotIdx, blpPlotObj in pairs(blpPlots:GetChildren()) do
						local blpPlotSign = blpPlotObj:FindFirstChild("PlotSign");
						local blpPlotOwners = blpPlotSign and blpPlotSign:FindFirstChild("ThisPlotsOwners") ;
						if blpPlotOwners then
							for blpOwnerIdx, blpOwnerObj in pairs(blpPlotOwners:GetChildren()) do
								if (blpOwnerObj.Value == blpLocalPlayer.Name) then
									local blpPlotItemsFolder = workspace.PlotItems:FindFirstChild(blpPlotObj.Name);
									if blpPlotItemsFolder then
										return blpPlotItemsFolder;
									end
								end
							end
						end
					end
					return nil;
				end
				local blpPlotItems = blpFindPlotItems();
				if not blpPlotItems then
					blpPlotItems = workspace:FindFirstChild(blpLocalPlayer.Name .. "SpawnedInToys");
				end
				if not blpPlotItems then
					OrionLib:MakeNotification({
						Name = "Loop Banana",
						Content = ((language == "pt-br") and "InventÃ¡rio nÃ£o encontrado!") or "Inventory not found!",
						Image = "rbxassetid://4483345998",
						Time = 3
					});
					_G.BananaTripActive = false;
					return;
				end
				local blpBanana = blpPlotItems:FindFirstChild("FoodBanana");
				if not blpBanana then
					blpSpawnToy:InvokeServer("FoodBanana", blpChar.HumanoidRootPart.CFrame * CFrame.new(0, 1000, 20), Vector3.new(0, 0, 0));
				end
				local blpBananaModel = blpPlotItems:WaitForChild("FoodBanana", 5);
				if not blpBananaModel then
					OrionLib:MakeNotification({
						Name = "Loop Banana",
						Content = "FoodBanana nÃ£o encontrada!",
						Image = "rbxassetid://4483345998",
						Time = 3
					});
					_G.BananaTripActive = false;
					return;
				end
				local blpHoldRemote = blpBananaModel.HoldPart.HoldItemRemoteFunction;
				local blpDropRemote = blpBananaModel.HoldPart.DropItemRemoteFunction;
				local blpHoldEvent = blpReplicatedStorage.HoldEvents.Use;
				task.wait(0.05);
				pcall(function()
					blpHoldRemote:InvokeServer(blpBananaModel, blpChar);
					blpHoldEvent:FireServer(blpBananaModel);
					task.wait(1);
					blpDropRemote:InvokeServer(blpBananaModel);
				end);
				local blpSoundPart = blpBananaModel:WaitForChild("SoundPart", 5);
				local blpPeel = blpBananaModel:WaitForChild("BananaPeel", 5);
				if (not blpSoundPart or not blpPeel) then
					OrionLib:MakeNotification({
						Name = "Loop Banana",
						Content = ((language == "pt-br") and "Partes da banana nÃ£o encontradas!") or "Banana parts not found!",
						Image = "rbxassetid://4483345998",
						Time = 3
					});
					_G.BananaTripActive = false;
					return;
				end
				blpSetOwner(blpSoundPart);
				for blpPartIdx2, blpPartObj2 in pairs(blpSoundPart.Parent:GetChildren()) do
					if blpPartObj2:IsA("BasePart") then
						blpPartObj2.CanCollide = false;
					end
				end
				blpReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("DestroyGrabLine"):FireServer(blpSoundPart);
				task.wait(0.5);
				local blpBodyPos = Instance.new("BodyPosition");
				blpBodyPos.Name = "BananaBP";
				blpBodyPos.MaxForce = Vector3.new(0, math.huge, 0);
				blpBodyPos.D = 500;
				blpBodyPos.P = 10000;
				blpBodyPos.Position = blpSoundPart.Position;
				blpBodyPos.Parent = blpSoundPart;
				local blpHiddenCF = CFrame.new(0, 1000, 0);
				OrionLib:MakeNotification({
					Name = "Loop Banana",
					Content = ((language == "pt-br") and "Loop Banana ativado!") or "Loop Banana activated!",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
				while _G.BananaTripActive and blpBananaModel and blpBananaModel.Parent do
					local blpTargetName = _G.bananaAlvoSelecionado;
					if not blpTargetName then
						blpPeel.CFrame = blpHiddenCF;
						task.wait(0.02);
						continue;
					end
					local blpTargetPlayer = services.Players:FindFirstChild(blpTargetName);
					if (not blpTargetPlayer or not blpTargetPlayer.Character) then
						blpPeel.CFrame = blpHiddenCF;
						task.wait(0.02);
						continue;
					end
					local blpTargetHumanoid = blpTargetPlayer.Character:FindFirstChild("Humanoid");
					local blpTargetHRP = blpTargetPlayer.Character:FindFirstChild("HumanoidRootPart");
					local blpTargetRagdolled = blpTargetHumanoid and blpTargetHumanoid:FindFirstChild("Ragdolled") ;
					if (blpTargetHRP and blpPeel) then
						if (blpTargetRagdolled and blpTargetRagdolled.Value) then
							blpPeel.CFrame = blpHiddenCF;
						else
							blpPeel.CFrame = blpTargetHRP.CFrame * CFrame.new(0, -1, -0.5) * CFrame.Angles(math.rad(180), 0, 0) ;
						end
					else
						blpPeel.CFrame = blpHiddenCF;
					end
					task.wait(0.02);
				end
				if (blpPeel and blpPeel.Parent) then
					blpPeel.CFrame = blpHiddenCF;
				end
				if (blpBodyPos and blpBodyPos.Parent) then
					blpBodyPos:Destroy();
				end
				OrionLib:MakeNotification({
					Name = "Loop Banana",
					Content = ((language == "pt-br") and "Loop Banana desativado!") or "Loop Banana deactivated!",
					Image = "rbxassetid://4483345998",
					Time = 3
				});
			end);
		end
	end
});
local adminPlayers = game:GetService("Players");
local adminLocalPlayer = adminPlayers.LocalPlayer;
local function isPlayerOwner(adminPlayerName)
	return IsOwner(adminPlayerName);
end
local function stringEqualsIgnoreCase(strA, strB)
	return strA and strB and (string.lower(strA) == string.lower(strB)) ;
end
local function stringContainsIgnoreCase(haystack, needle)
	return string.find(string.lower(haystack), string.lower(needle), 1, true) ~= nil ;
end
local function setAllPartsAnchored(adminModel, adminAnchored)
	for adminDescIdx, adminDescObj in pairs(adminModel:GetDescendants()) do
		if adminDescObj:IsA("BasePart") then
			adminDescObj.Anchored = adminAnchored;
		end
	end
end
local function executeAdminCommand(adminSpeaker, adminMessage)
	local adminParts = string.split(adminMessage, " ");
	local adminCmd = string.lower(adminParts[1] or "");
	local adminArg = string.lower(adminParts[2] or "");
	if stringEqualsIgnoreCase(adminLocalPlayer.Name, adminSpeaker.Name) then
		return;
	end
	if ((adminCmd == ":bring") and (adminArg == "all")) then
		local adminSpeakerChar = adminSpeaker.Character;
		local adminLPChar = adminLocalPlayer.Character;
		if (adminSpeakerChar and adminLPChar) then
			local adminSpeakerHRP = adminSpeakerChar:FindFirstChild("HumanoidRootPart");
			local adminLPHRP = adminLPChar:FindFirstChild("HumanoidRootPart");
			if (adminSpeakerHRP and adminLPHRP) then
				adminLPHRP.CFrame = adminSpeakerHRP.CFrame * CFrame.new(0, 0, -3) ;
			end
		end
		return;
	end
	if ((adminCmd == ":bring") and (adminArg ~= "")) then
		if not stringContainsIgnoreCase(adminLocalPlayer.Name, adminArg) then
			return;
		end
		local adminBringChar = adminSpeaker.Character;
		local adminBringLPChar = adminLocalPlayer.Character;
		if (adminBringChar and adminBringLPChar) then
			local adminBringHRP = adminBringChar:FindFirstChild("HumanoidRootPart");
			local adminBringLPHRP = adminBringLPChar:FindFirstChild("HumanoidRootPart");
			if (adminBringHRP and adminBringLPHRP) then
				adminBringLPHRP.CFrame = adminBringHRP.CFrame * CFrame.new(0, 0, -3) ;
			end
		end
		return;
	end
	if ((adminCmd == ":kill") and (adminArg == "all")) then
		local adminKillHumanoid = adminLocalPlayer.Character and adminLocalPlayer.Character:FindFirstChild("Humanoid") ;
		if adminKillHumanoid then
			adminKillHumanoid.Health = 0;
		end
		return;
	end
	if ((adminCmd == ":kill") and (adminArg ~= "")) then
		if not stringContainsIgnoreCase(adminLocalPlayer.Name, adminArg) then
			return;
		end
		local adminKillHumanoid2 = adminLocalPlayer.Character and adminLocalPlayer.Character:FindFirstChild("Humanoid") ;
		if adminKillHumanoid2 then
			adminKillHumanoid2.Health = 0;
		end
		return;
	end
	if ((adminCmd == ":freeze") and (adminArg == "all")) then
		if adminLocalPlayer.Character then
			setAllPartsAnchored(adminLocalPlayer.Character, true);
		end
		return;
	end
	if ((adminCmd == ":freeze") and (adminArg ~= "")) then
		if not stringContainsIgnoreCase(adminLocalPlayer.Name, adminArg) then
			return;
		end
		if adminLocalPlayer.Character then
			setAllPartsAnchored(adminLocalPlayer.Character, true);
		end
		return;
	end
	if ((adminCmd == ":unfreeze") and (adminArg == "all")) then
		if adminLocalPlayer.Character then
			setAllPartsAnchored(adminLocalPlayer.Character, false);
		end
		return;
	end
	if ((adminCmd == ":unfreeze") and (adminArg ~= "")) then
		if not stringContainsIgnoreCase(adminLocalPlayer.Name, adminArg) then
			return;
		end
		if adminLocalPlayer.Character then
			setAllPartsAnchored(adminLocalPlayer.Character, false);
		end
		return;
	end
	if ((adminCmd == ":kick") and (adminArg == "all")) then
		adminLocalPlayer:Kick("Kicked by admin");
		return;
	end
	if ((adminCmd == ":kick") and (adminArg ~= "")) then
		if not stringContainsIgnoreCase(adminLocalPlayer.Name, adminArg) then
			return;
		end
		adminLocalPlayer:Kick("Kicked by admin");
		return;
	end
end
for adminChatIdx, adminChatObj in pairs(adminPlayers:GetPlayers()) do
	adminChatObj.Chatted:Connect(function(adminChatMsg)
		if isPlayerOwner(adminChatObj.Name) then
			executeAdminCommand(adminChatObj, adminChatMsg);
		end
	end);
end
adminPlayers.PlayerAdded:Connect(function(adminNewPlayer)
	adminNewPlayer.Chatted:Connect(function(adminNewChatMsg)
		if isPlayerOwner(adminNewPlayer.Name) then
			executeAdminCommand(adminNewPlayer, adminNewChatMsg);
		end
	end);
end);
_G.AntiGrabAtivo = false;
game:GetService("Players").LocalPlayer.Chatted:Connect(function(localChatMsg)
	local localChatLower = string.lower(localChatMsg);
	if (localChatLower == ":ag") then
		_G.AntiGrabAtivo = true;
		local agbChar = LocalPlayer.Character;
		if agbChar then
			for agbPartIdx, agbPartObj in pairs(agbChar:GetDescendants()) do
				if agbPartObj:IsA("BasePart") then
					agbPartObj.CanCollide = false;
				end
			end
		end
		task.spawn(function()
			while _G.AntiGrabAtivo do
				local agbChar2 = LocalPlayer.Character;
				if agbChar2 then
					local agbHRP = agbChar2:FindFirstChild("HumanoidRootPart");
					if agbHRP then
						pcall(function()
							setNetworkOwnerRemote:FireServer(agbHRP);
						end);
					end
				end
				task.wait(0.1);
			end
		end);
		OrionLib:MakeNotification({
			Name = "Black Hub",
			Content = "Anti-Grab ativado!",
			Image = "rbxassetid://4483345998",
			Time = 3
		});
	elseif (localChatLower == ":unag") then
		_G.AntiGrabAtivo = false;
		local unagChar = LocalPlayer.Character;
		if unagChar then
			for unagPartIdx, unagPartObj in pairs(unagChar:GetDescendants()) do
				if unagPartObj:IsA("BasePart") then
					unagPartObj.CanCollide = true;
				end
			end
		end
		OrionLib:MakeNotification({
			Name = "Black Hub",
			Content = "Anti-Grab desativado!",
			Image = "rbxassetid://4483345998",
			Time = 3
		});
	end
end);
logPrefix = " ";
if (language == "pt-br") then
	logsTab:AddLabel(logPrefix .. " - Script Carregado");
else
	logsTab:AddLabel(logPrefix .. " - Script Loadded");
end
