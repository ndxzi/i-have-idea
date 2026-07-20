local KEY_LINK = "https://work.ink/2H6f/prisma-hub-key-part-11"
local SCRIPT_URL = ""  
local httpGet = nil
if syn and syn.request then
    httpGet = function(url) return syn.request({Url=url,Method="GET"}).Body end
elseif http and http.request then
    httpGet = function(url) return http.request({Url=url,Method="GET"}).Body end
elseif request then
    httpGet = function(url) return request({Url=url,Method="GET"}).Body end
elseif game.HttpGet then
    httpGet = game.HttpGet
end

local C_BG = Color3.fromRGB(12, 10, 20)
local C_CARD = Color3.fromRGB(24, 22, 38)
local C_ACCENT = Color3.fromRGB(130, 80, 255)
local C_ACCENT2 = Color3.fromRGB(255, 70, 120)
local C_TEXT = Color3.fromRGB(245, 240, 255)
local C_GRAY = Color3.fromRGB(170, 165, 190)


local player = game.Players.LocalPlayer
if not player then return end

local ts = game:GetService("TweenService")
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PrismaUltimate"

local bg = Instance.new("Frame", gui)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = C_BG
bg.BackgroundTransparency = 1
ts:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 0.35}):Play()

local card = Instance.new("Frame", gui)
card.Size = UDim2.new(0, 480, 0, 320)
card.Position = UDim2.new(0.5, -240, 0.5, -160)
card.BackgroundColor3 = C_CARD
card.BorderSizePixel = 0
card.ClipsDescendants = true

local grad = Instance.new("UIGradient", card)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 70, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 30, 120))
})
grad.Rotation = 45

local corner = Instance.new("UICorner", card)
corner.CornerRadius = UDim.new(0, 16)

card.Position = UDim2.new(0.5, -240, 0.5, -220)
card.BackgroundTransparency = 0.8
ts:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -240, 0.5, -160),
    BackgroundTransparency = 0
}):Play()

local topBar = Instance.new("Frame", card)
topBar.Size = UDim2.new(1,0,0,8)
topBar.BackgroundColor3 = C_ACCENT
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,16)

local titleShadow = Instance.new("TextLabel", card)
titleShadow.Size = UDim2.new(1,-30,0,40)
titleShadow.Position = UDim2.new(0,16,0,22)
titleShadow.Text = "🔐  PRISMA HUB KEY 24H"
titleShadow.TextColor3 = Color3.fromRGB(0,0,0)
titleShadow.TextTransparency = 0.6
titleShadow.Font = Enum.Font.GothamBlack
titleShadow.TextSize = 26
titleShadow.BackgroundTransparency = 1

local title = Instance.new("TextLabel", card)
title.Size = UDim2.new(1,-30,0,40)
title.Position = UDim2.new(0,15,0,20)
title.Text = "🔐  PRISMA HUB KEY 24H"
title.TextColor3 = C_TEXT
title.Font = Enum.Font.GothamBlack
title.TextSize = 26
title.BackgroundTransparency = 1

local sub = Instance.new("TextLabel", card)
sub.Size = UDim2.new(1,-30,0,20)
sub.Position = UDim2.new(0,15,0,65)
sub.Text = "Obtain a token and unlock the hub"
sub.TextColor3 = C_GRAY
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 14
sub.BackgroundTransparency = 1

local linkFrame = Instance.new("Frame", card)
linkFrame.Size = UDim2.new(1,-30,0,42)
linkFrame.Position = UDim2.new(0,15,0,100)
linkFrame.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
linkFrame.BorderSizePixel = 0
Instance.new("UICorner", linkFrame).CornerRadius = UDim.new(0,10)

local linkLabel = Instance.new("TextLabel", linkFrame)
linkLabel.Size = UDim2.new(1,-52,1,0)
linkLabel.Position = UDim2.new(0,12,0,0)
linkLabel.Text = KEY_LINK
linkLabel.TextColor3 = Color3.fromRGB(180, 160, 255)
linkLabel.Font = Enum.Font.Code
linkLabel.TextSize = 12
linkLabel.BackgroundTransparency = 1
linkLabel.TextTruncate = Enum.TextTruncate.AtEnd

local copyLinkBtn = Instance.new("TextButton", linkFrame)
copyLinkBtn.Size = UDim2.new(0,44,0,44)
copyLinkBtn.Position = UDim2.new(1,-44,0,-1)
copyLinkBtn.BackgroundColor3 = C_ACCENT
copyLinkBtn.Text = "📋"
copyLinkBtn.TextColor3 = Color3.new(1,1,1)
copyLinkBtn.Font = Enum.Font.GothamBold
copyLinkBtn.TextSize = 20
Instance.new("UICorner", copyLinkBtn).CornerRadius = UDim.new(0,10)

local tokenBox = Instance.new("TextBox", card)
tokenBox.Size = UDim2.new(1,-30,0,48)
tokenBox.Position = UDim2.new(0,15,0,160)
tokenBox.PlaceholderText = "Paste your token here..."
tokenBox.Text = ""
tokenBox.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
tokenBox.TextColor3 = C_TEXT
tokenBox.Font = Enum.Font.GothamMedium
tokenBox.TextSize = 16
tokenBox.ClearTextOnFocus = false
Instance.new("UICorner", tokenBox).CornerRadius = UDim.new(0,10)

local progressBar = Instance.new("Frame", card)
progressBar.Size = UDim2.new(1,-30,0,6)
progressBar.Position = UDim2.new(0,15,0,218)
progressBar.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
progressBar.BorderSizePixel = 0
progressBar.Visible = false
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0,3)

local progressFill = Instance.new("Frame", progressBar)
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.BackgroundColor3 = C_ACCENT2
progressFill.BorderSizePixel = 0
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0,3)

local verifyBtn = Instance.new("TextButton", card)
verifyBtn.Size = UDim2.new(1,-30,0,50)
verifyBtn.Position = UDim2.new(0,15,0,235)
verifyBtn.Text = "VERIFY & UNLOCK"
verifyBtn.BackgroundColor3 = C_ACCENT2
verifyBtn.TextColor3 = Color3.new(1,1,1)
verifyBtn.Font = Enum.Font.GothamBlack
verifyBtn.TextSize = 20
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0,10)

local status = Instance.new("TextLabel", card)
status.Size = UDim2.new(1,-30,0,20)
status.Position = UDim2.new(0,15,0,293)
status.Text = ""
status.TextColor3 = C_ACCENT2
status.Font = Enum.Font.GothamMedium
status.TextSize = 13
status.BackgroundTransparency = 1

local glow = Instance.new("ImageLabel", card)
glow.Size = UDim2.new(1,0,1,0)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://284402402"
glow.ImageColor3 = C_ACCENT
glow.ImageTransparency = 0.85
glow.ScaleType = Enum.ScaleType.Fit
glow.ZIndex = 0

copyLinkBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(KEY_LINK)
    elseif syn and syn.write_clipboard then syn.write_clipboard(KEY_LINK)
    end
    status.Text = "✅ Link copied to clipboard!"
    task.wait(1.5)
    status.Text = ""
end)

verifyBtn.MouseButton1Click:Connect(function()
    local token = tokenBox.Text:gsub("%s+", "")
    if token == "" then
        status.Text = "⚠️ Please paste your token"
        return
    end

    if not httpGet then
        status.Text = "❌ HTTP not available in this executor"
        return
    end

    verifyBtn.Text = "VERIFYING..."
    verifyBtn.Interactable = false
    progressBar.Visible = true
    progressFill.Size = UDim2.new(0,0,1,0)
    ts:Create(progressFill, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}):Play()
    status.Text = "⏳ Connecting to Work.ink..."

    local url = "https://work.ink/_api/v2/token/isValid/" .. token .. "?deleteToken=1"
    local success, response = pcall(httpGet, url)

    if not success then
        status.Text = "❌ Connection error – try again"
        verifyBtn.Interactable = true
        verifyBtn.Text = "VERIFY & UNLOCK"
        progressBar.Visible = false
        return
    end

    local data
    pcall(function()
        data = game:GetService("HttpService"):JSONDecode(response)
    end)

    progressFill.Size = UDim2.new(1,0,1,0)
    task.wait(0.1)
    progressBar.Visible = false

    if data and data.valid == true then
        status.Text = "✅ Access granted! Loading script..."
        verifyBtn.Text = "UNLOCKED"
        verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

        ts:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -240, 0.5, 400),
            BackgroundTransparency = 1
        }):Play()
        ts:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()

        task.wait(0.5)
        gui:Destroy()

        local scriptContent = httpGet(SCRIPT_URL)
        if scriptContent then
            local func, err = loadstring(scriptContent)
            if func then
                func()
            else
                warn("Błąd w pobranym skrypcie: " .. tostring(err))
            end
        else
            warn("Nie udało się pobrać skryptu z GitHuba")
        end
    else
        status.Text = "❌ Invalid or expired token"
        verifyBtn.Interactable = true
        verifyBtn.Text = "VERIFY & UNLOCK"
    end
end)

SCRIPT_URL = "https://raw.githubusercontent.com/Artss1/Flades_Hub/main/We%20Are%20Arts.lua"

print("🔐 PRISMA HUB KEY 24H – DZIAŁA!")
print("   Script URL: " .. SCRIPT_URL)
