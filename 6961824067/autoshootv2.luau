_G.AutoShotV2 = true
local currentlyHolding = false

task.spawn(function()
    while _G.AutoShotV2 do
        local mouse = game.Players.LocalPlayer:GetMouse()
        local target = mouse.Target

        if target then
            local character = target.Parent
            if not character:FindFirstChild("Humanoid") then
                character = character.Parent
            end

            local humanoid = character and character:FindFirstChild("Humanoid")
            local isPlayer = character and game.Players:GetPlayerFromCharacter(character)

            if isPlayer and humanoid and humanoid.Health > 0 then
                if not currentlyHolding then
                    mouse1press()
                    currentlyHolding = true
                end
            else
                if currentlyHolding then
                    mouse1release()
                    currentlyHolding = false
                end
            end
        else
            if currentlyHolding then
                mouse1release()
                currentlyHolding = false
            end
        end

        task.wait(0.05)
    end

    if currentlyHolding then
        mouse1release()
        currentlyHolding = false
    end
end)
