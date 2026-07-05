local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Pallet Anchor",
    LoadingTitle = "NIGGAAAAAAAAAAAAAAAAAAA",
    LoadingSubtitle = "niggerI",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("pallet", 4483362458)

local anchored = false
local currentWeld = nil

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getPalletBelow()
    local character = getCharacter()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(hrp.Position, Vector3.new(0, -6, 0), rayParams)

    if result and result.Instance then
        return result.Instance
    end

    return nil
end

local function anchorToPallet()
    if anchored then return end

    local character = getCharacter()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local pallet = getPalletBelow()
    if not pallet then
        Rayfield:Notify({
            Title = "No Pallet",
            Content = "You're not standing on anything.",
            Duration = 2
        })
        return
    end

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = pallet
    weld.Parent = hrp

    currentWeld = weld
    anchored = true
end

local function unanchor()
    if currentWeld then
        currentWeld:Destroy()
        currentWeld = nil
    end
    anchored = false
end

local function toggleAnchor()
    if anchored then
        unanchor()
    else
        anchorToPallet()
    end
end

Tab:CreateToggle({
    Name = "Anchor to Pallet",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            anchorToPallet()
        else
            unanchor()
        end
    end
})

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.X then
        toggleAnchor()
    end
end)
