local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

local FolderName = LocalPlayer.Name .. "SpawnedInToys"
local ToyFolder = Workspace:WaitForChild(FolderName)

local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")

local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local SpawnToyRF = MenuToys:WaitForChild("SpawnToyRemoteFunction")

local EVENT_SPEED = 1
local MAX_LETTERS = 9

local ROWS = {"A","B","C","D","E","F","G","H"}

local function newGrid()
    local g = {}
    for r = 1, 8 do
        g[r] = {}
        for c = 1, 8 do
            g[r][c] = false
        end
    end
    return g
end

local function gridToPads(grid)
    local out = {}
    for r = 1, 8 do
        for c = 1, 8 do
            if grid[r][c] then
                table.insert(out, ROWS[r] .. tostring(c))
            end
        end
    end
    return out
end

local LETTER_PATTERNS = {
    A = {
        "..XXXX..",
        ".XX..XX.",
        ".XX..XX.",
        ".XXXXXX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        "........",
    },

    B = {
        ".XXXXX..",
        ".XX..XX.",
        ".XX..XX.",
        ".XXXXX..",
        ".XX..XX.",
        ".XX..XX.",
        ".XXXXX..",
        "........",
    },

    C = {
        "..XXXX..",
        ".XX..XX.",
        ".XX.....",
        ".XX.....",
        ".XX.....",
        ".XX..XX.",
        "..XXXX..",
        "........",
    },

    D = {
        ".XXXXX..",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XXXXX..",
        "........",
    },

    E = {
        ".XXXXXX.",
        ".XX.....",
        ".XX.....",
        ".XXXXX..",
        ".XX.....",
        ".XX.....",
        ".XXXXXX.",
        "........",
    },

    F = {
        ".XXXXXX.",
        ".XX.....",
        ".XX.....",
        ".XXXXX..",
        ".XX.....",
        ".XX.....",
        ".XX.....",
        "........",
    },

    G = {
        "..XXXX..",
        ".XX..XX.",
        ".XX.....",
        ".XX.....",
        ".XX.XXX.",
        ".XX..XX.",
        "..XXXX..",
        "........",
    },

    H = {
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XXXXXX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        "........",
    },

    I = {
        "..XXXX..",
        "...XX...",
        "...XX...",
        "...XX...",
        "...XX...",
        "...XX...",
        "..XXXX..",
        "........",
    },

    J = {
        "..XXXX..",
        "...XX...",
        "...XX...",
        "...XX...",
        "...XX...",
        ".XX.XX..",
        "..XXX...",
        "........",
    },

    K = {
        ".XX..XX.",
        ".XX.XX..",
        ".XXXXX..",
        ".XXXX...",
        ".XXXXX..",
        ".XX.XX..",
        ".XX..XX.",
        "........",
    },

    L = {
        ".XX.....",
        ".XX.....",
        ".XX.....",
        ".XX.....",
        ".XX.....",
        ".XX.....",
        ".XXXXXX.",
        "........",
    },

    M = {
        ".XX..XX.",
        ".XXXXXX.",
        ".XXXXXX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        "........",
    },

    N = {
        ".XX..XX.",
        ".XXX.XX.",
        ".XXXXXX.",
        ".XX.XXX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        "........",
    },

    O = {
        "..XXXX..",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        "..XXXX..",
        "........",
    },

    P = {
        ".XXXXX..",
        ".XX..XX.",
        ".XX..XX.",
        ".XXXXX..",
        ".XX.....",
        ".XX.....",
        ".XX.....",
        "........",
    },

    Q = {
        "..XXXX..",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX.XXX.",
        "..XXXXX.",
        ".....XX.",
        "........",
    },

    R = {
        ".XXXXX..",
        ".XX..XX.",
        ".XX..XX.",
        ".XXXXX..",
        ".XX.XX..",
        ".XX..XX.",
        ".XX..XX.",
        "........",
    },

    S = {
        "..XXXX..",
        ".XX..XX.",
        ".XX.....",
        "..XXXX..",
        ".....XX.",
        ".XX..XX.",
        "..XXXX..",
        "........",
    },

    T = {
        ".XXXXXX.",
        "...XX...",
        "...XX...",
        "...XX...",
        "...XX...",
        "...XX...",
        "...XX...",
        "........",
    },

    U = {
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        "..XXXX..",
        "........",
    },

    V = {
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        "..XXXX..",
        "...XX...",
        "........",
    },

    W = {
        ".XX..XX.",
        ".XX..XX.",
        ".XX..XX.",
        ".XXXXXX.",
        ".XXXXXX.",
        ".XX..XX.",
        ".XX..XX.",
        "........",
    },

    X = {
        ".XX..XX.",
        ".XX..XX.",
        "..XXXX..",
        "...XX...",
        "..XXXX..",
        ".XX..XX.",
        ".XX..XX.",
        "........",
    },

    Y = {
        ".XX..XX.",
        ".XX..XX.",
        "..XXXX..",
        "...XX...",
        "...XX...",
        "...XX...",
        "...XX...",
        "........",
    },

    Z = {
        ".XXXXXX.",
        ".....XX.",
        "....XX..",
        "...XX...",
        "..XX....",
        ".XX.....",
        ".XXXXXX.",
        "........",
    },
}

local function makeLetterGrid(letter)
    letter = string.upper(letter)
    local pattern = LETTER_PATTERNS[letter]
    if not pattern then
        return nil
    end

    local g = newGrid()
    for r = 1, math.min(8, #pattern) do
        local rowStr = pattern[r]
        if rowStr then
            local rowLen = #rowStr
            for c = 1, math.min(8, rowLen) do
                local ch = rowStr:sub(c, c)
                if ch == "X" then
                    g[r][c] = true
                end
            end
        end
    end
    return g
end

local function teleportToPad(pad)
    if not pad or not pad.Parent then return end

    if not Root or not Root.Parent then
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Root = Character:WaitForChild("HumanoidRootPart")
    end

    Root.CFrame = pad.CFrame + Vector3.new(0, 5, 0)
end

local function getPad(midiMakerModel, name)
    if not midiMakerModel or not midiMakerModel.Parent then
        return nil
    end

    local p = midiMakerModel:FindFirstChild(name)
    if p and p:IsA("MeshPart") then
        return p
    end
    return nil
end

local function fireUntilUnlit(pad, speed)
    speed = speed or EVENT_SPEED or 1
    if speed <= 0 then speed = 1 end

    local maxAttempts = 1
    local attempts = 0

    while pad and pad.Parent and pad.Transparency == 1 and attempts < maxAttempts do
        SetNetworkOwner:FireServer(pad, pad.CFrame)
        attempts += 1
        task.wait(0.01 / speed)
    end
end

local function clearBoard(midiMakerModel, speed)
    speed = speed or EVENT_SPEED or 1
    if speed <= 0 then speed = 1 end

    for r = 1, 8 do
        for c = 1, 8 do
            local padName = ROWS[r] .. tostring(c)
            local pad = getPad(midiMakerModel, padName)
            if pad and pad.Transparency == 1 then
                fireUntilUnlit(pad, speed)
            end
        end
    end
end

local function drawLetterOnMidi(midiMakerModel, letter, speed)
    speed = speed or EVENT_SPEED or 1
    if speed <= 0 then speed = 1 end

    if not midiMakerModel or not midiMakerModel.Parent then
        warn("drawLetterOnMidi: invalid MidiMaker model")
        return 0
    end

    letter = string.upper(letter)

    local grid = makeLetterGrid(letter)
    if not grid then
        warn("No pattern for letter:", letter)
        return 0
    end

    local start = tick()

    clearBoard(midiMakerModel, speed)

    local pads = gridToPads(grid)
    local count = 0

    for _, padName in ipairs(pads) do
        local pad = getPad(midiMakerModel, padName)
        if pad then
            teleportToPad(pad)
            SetNetworkOwner:FireServer(pad, pad.CFrame)
            count += 1
        end
        task.wait(0.01 / speed)
    end

    local elapsed = tick() - start
    local ms = math.floor(elapsed * 1000)

    print(string.format(
        "[LETTER %s] Board=%s | Pads lit: %d | Time: %d ms (%.3f sec) | Pads: %s",
        letter,
        midiMakerModel:GetFullName(),
        count,
        ms,
        elapsed,
        table.concat(pads, ", ")
    ))

    return count
end

local function spawnMidiMaker(index)
    index = index or 1

    local existing = {}
    for _, child in ipairs(ToyFolder:GetChildren()) do
        if child.Name == "MidiMaker" then
            existing[child] = true
        end
    end

    local baseCF = Root.CFrame * CFrame.new((index - 1) * 8, 0, 0)

    local args = {
        [1] = "MidiMaker",
        [2] = baseCF * CFrame.Angles(-2.1337385177612305, 1.0052294731140137, 2.2126595973968506),
        [3] = Vector3.new(0, 108.71299743652344, 0)
    }

    local ok, err = pcall(function()
        SpawnToyRF:InvokeServer(unpack(args))
    end)

    if not ok then
        warn("SpawnMidiMaker failed:", err)
        return nil
    end

    local newMidi
    local deadline = tick() + 8

    repeat
        for _, child in ipairs(ToyFolder:GetChildren()) do
            if child.Name == "MidiMaker" and not existing[child] then
                newMidi = child
                break
            end
        end

        if not newMidi then
            task.wait(0.05)
        end
    until newMidi or tick() > deadline

    if not newMidi then
        warn("Timed out waiting for new MidiMaker at index", index)
        return nil
    end

    local body = newMidi:FindFirstChild("Body") or newMidi:WaitForChild("Body", 3)
    if not body then
        warn("MidiMaker missing Body part at index", index)
        return nil
    end

    SetNetworkOwner:FireServer(body, body.CFrame)

    local ownerTag = body:WaitForChild("PartOwner", 3)
    if not ownerTag or ownerTag.Value ~= LocalPlayer.Name then
        warn("You do not own this MidiMaker at index " .. index)
        return nil
    end

    print("[SPAWN] MidiMaker " .. index .. " ready")
    return newMidi
end

local function lineUpMidiMakers(boards)
    return true
end

local function drawWord(word, speed)
    speed = speed or EVENT_SPEED or 1
    if speed <= 0 then speed = 1 end

    if type(word) ~= "string" then
        warn("drawWord expects a string")
        return
    end

    word = string.upper(word)
    local rawLen = #word

    if rawLen == 0 then
        warn("drawWord: empty string")
        return
    end

    local letters = {}
    for i = 1, rawLen do
        local ch = word:sub(i, i)
        if ch:match("%a") then
            if not LETTER_PATTERNS[ch] then
                warn("No pattern for letter:", ch, " — stopping completely.")
                return
            end
            table.insert(letters, ch)
        end
    end

    if #letters == 0 then
        warn("drawWord: no valid letters in '" .. word .. "'")
        return
    end

    if #letters > MAX_LETTERS then
        warn("drawWord: max " .. MAX_LETTERS .. " letters supported, got " .. #letters)
        return
    end

    local totalPads = 0
    local overallStart = tick()
    local boards = {}

    for i, ch in ipairs(letters) do
        local midi = spawnMidiMaker(i)
        if not midi then
            warn("Stopping drawWord, failed to spawn MidiMaker index " .. i)
            return
        end

        table.insert(boards, midi)

        task.wait(4)

        local ok, padsLitOrErr = pcall(function()
            return drawLetterOnMidi(midi, ch, speed)
        end)

        if not ok then
            warn("Error drawing letter " .. ch .. ": " .. tostring(padsLitOrErr))
            return
        end

        local padsLit = padsLitOrErr or 0
        totalPads += padsLit

        task.wait(0.1)
    end

    lineUpMidiMakers(boards)

    local elapsedTotal = tick() - overallStart
    local msTotal = math.floor(elapsedTotal * 1000)

    print(string.format(
        "[WORD %s] Done | Letters: %d | Total pads lit: %d | Time: %d ms (%.3f sec)",
        word,
        #letters,
        totalPads,
        msTotal,
        elapsedTotal
    ))
end
