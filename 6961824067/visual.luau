print("Hello, World!")
local oceanFolder = game.Workspace:FindFirstChild("Map")
and game.Workspace.Map:FindFirstChild("AlwaysHereTweenedObjects")
and game.Workspace.Map.AlwaysHereTweenedObjects:FindFirstChild("Ocean")
if not oceanFolder then return end
local Lighting = game:GetService("Lighting")
local sky = Instance.new("Sky")
sky.SkyboxBk = "rbxassetid://15542516997"
sky.SkyboxDn = "rbxassetid://15542518076"
sky.SkyboxFt = "rbxassetid://15542518821"
sky.SkyboxLf = "rbxassetid://15542519595"
sky.SkyboxRt = "rbxassetid://15542520652"
sky.SkyboxUp = "rbxassetid://15542521515"
sky.Parent = Lighting
sky.Name = "Sky"
_G.FOVChangerConnection = _G.FOVChangerConnection or nil
if _G.FOVChangerConnection then
_G.FOVChangerConnection:Disconnect()
_G.FOVChangerConnection = nil
end
local camera = workspace.Camera
G.FOVChangerConnection = camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
if camera.FieldOfView ~= 120 then
camera.FieldOfView = 120
end
end)
camera.FieldOfView = 100
local function destroyOceans(parent)
for , child in pairs(parent:GetChildren()) do
if child.Name == "Ocean" then
child:Destroy()
elseif #child:GetChildren() > 0 then
destroyOceans(child)
end
end
end
local function applyNearBlackEffect(model)
for , part in ipairs(model:GetDescendants()) do
if part:IsA("BasePart") then
-- Изменено на почти черный цвет (очень темный серый, например, Color3.fromRGB(15, 15, 15))
part.Color = Color3.fromRGB(15, 15, 15)
part.Material = Enum.Material.Plastic -- Материал по умолчанию
part.Reflectance = 0
end
end
end
-- Применяем эффект к уже существующим моделям с указанным именем
for , obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("Model") and obj.Name == "PalletLightBrown" then
applyNearBlackEffect(obj)
end
end
-- Применяем эффект к моделям, которые будут добавлены позже с указанным именем
workspace.DescendantAdded:Connect(function(descendant)
task.spawn(function()
if descendant:IsA("Model") and descendant.Name == "PalletLightBrown" then
task.wait(0.1) -- Необязательная задержка
applyNearBlackEffect(descendant)
end
end)
end)
destroyOceans(oceanFolder)
