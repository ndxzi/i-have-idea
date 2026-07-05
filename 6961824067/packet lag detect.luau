local KB_THRESHOLD = 5
local BYTE_THRESHOLD = KB_THRESHOLD * 1024
local COOLDOWN = 30
local lastNotify = 0
local connections = {}

-- Utility functions
local function notify(title, text)
    pcall(function()
        Rayfield:Notify({
            Title = title or "Sussy packet detected",
            Content = text or "",
            Duration = 7
        })
    end)
end

local function resolveSender(args)
    for _, v in ipairs(args) do
        if typeof(v) == "Instance" and v:IsA("Player") then
            return v
        end
        if typeof(v) == "Instance" and v:IsA("Model") then
            local plr = Players:GetPlayerFromCharacter(v)
            if plr then return plr end
        end
        if typeof(v) == "Instance" and v:IsA("BasePart") then
            local model = v:FindFirstAncestorOfClass("Model")
            if model then
                local plr = Players:GetPlayerFromCharacter(model)
                if plr then return plr end
            end
        end
        if typeof(v) == "Instance" and v:IsA("Tool") then
            local model = v:FindFirstAncestorOfClass("Model")
            if model then
                local plr = Players:GetPlayerFromCharacter(model)
                if plr then return plr end
            end
        end
    end
    return LocalPlayer
end

local function shortenString(str)
    if #str <= 80 then return str end
    return str:sub(1, 80) .. "... (+" .. (#str - 80) .. " chars)"
end

local function summarizeTable(tbl)
    local preview = {}
    local count = 0
    for _, v in pairs(tbl) do
        count += 1
        if count <= 5 then
            table.insert(preview, tostring(v))
        end
    end
    return "table["..count.."] { "..table.concat(preview, ", ").." ... }"
end

local function compressArgs(args)
    local seen = {}
    local summary = {}

    for _, v in ipairs(args) do
        local key
        if typeof(v) == "string" then
            key = "str:"..shortenString(v)
        elseif typeof(v) == "Instance" then
            key = "inst:"..v.ClassName.."("..v.Name..")"
        elseif typeof(v) == "table" then
            key = "tbl:"..summarizeTable(v)
        else
            key = typeof(v)..":"..tostring(v)
        end
        seen[key] = (seen[key] or 0) + 1
    end

    for k, count in pairs(seen) do
        if count > 1 then
            table.insert(summary, k.." x"..count)
        else
            table.insert(summary, k)
        end
    end

    return summary
end

-- Handle any event
local function handleEvent(eventType, remoteName, ...)
    local args = {...}
    local totalBytes = 0
    for _, v in ipairs(args) do
        if typeof(v) == "string" then
            totalBytes += #v
        end
    end

    if totalBytes < BYTE_THRESHOLD then return end
    if tick() - lastNotify < COOLDOWN then return end
    lastNotify = tick()

    local sender = resolveSender(args)
    local senderName = sender.DisplayName
    if sender == LocalPlayer then
        senderName = senderName .. " (You)"
    end

    local mbSize = totalBytes / (1024 * 1024)
    local summarized = compressArgs(args)

    notify(
        string.format("[%s] %s", eventType, remoteName),
        string.format("Player: %s\nSize: %.3f MB\nArgs:\n%s", senderName, mbSize, table.concat(summarized, "\n"))
    )
end

-- Recursive function to find all RelayClientAnimation in a parent
local function scanForBlobRemotes(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("RemoteEvent") and child.Name == "RelayClientAnimation" and child.Parent and child.Parent.Name == "BlobmanAnimations" then
            table.insert(connections, child.OnClientEvent:Connect(function(...) handleEvent("Blob", child.Parent.Parent.Name, ...) end))
        end
        scanForBlobRemotes(child)
    end
end

-- Watch for any new children dynamically
local function watchChildren(parent)
    table.insert(connections, parent.ChildAdded:Connect(function(child)
        scanForBlobRemotes(child)
        watchChildren(child) -- recursively watch deeper levels
    end))
    for _, child in ipairs(parent:GetChildren()) do
        watchChildren(child)
    end
end

-- Start monitoring
local function startDetector()
    if #connections > 0 then return end

    -- Monitor GrabRemote
    local GrabRemote = ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("ExtendGrabLine")
    table.insert(connections, GrabRemote.OnClientEvent:Connect(function(...) handleEvent("Grab", "ExtendGrabLine", ...) end))

    -- Scan the entire workspace for Blob Remotes
    scanForBlobRemotes(workspace)
    watchChildren(workspace)
end

-- Stop monitoring
local function stopDetector()
    for _, conn in ipairs(connections) do
        conn:Disconnect()
    end
    connections = {}
end

-- AntiTab toggle
AntiTab:CreateToggle({
    Name = "Detect packets",
    CurrentValue = false,
    Flag = "GrabRemoteDetector",
    Callback = function(Value)
        if Value then
            startDetector()
            Rayfield:Notify({
                Title = "Enabled",
                Content = "Packet detector active",
                Duration = 5
            })
        else
            stopDetector()
            Rayfield:Notify({
                Title = "Disabled",
                Content = "Packet detector off",
                Duration = 5
            })
        end
    end
})
