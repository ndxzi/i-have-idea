-- Packet script for Obsidian UI Library
-- Modified from example script

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "Packet Manager",
    Footer = "version: 2.0",
    Icon = "package",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- Создание вкладок
local Tabs = {
    Packets = Window:AddTab("Packets", "send"),
    Generator = Window:AddTab("Generator", "shuffle"),
    FakePackets = Window:AddTab("Fake Packets", "copy"),
    Console = Window:AddTab("Console", "terminal"),
    Settings = Window:AddTab("Settings", "settings"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- Таблица с символами
local symbols = {
    [1] = "𖥶",
    [2] = "ဩ", 
    [3] = "𓁷",
    [4] = "〠",
    [5] = "﷽"
}

local symbolNames = {
    [1] = "Symbol 1 (𖥶)",
    [2] = "Symbol 2 (ဩ)",
    [3] = "Symbol 3 (𓁷)",
    [4] = "Symbol 4 (〠)",
    [5] = "Symbol 5 (﷽)"
}

-- Таблица с фейк пакетами для разных софтов
local fakePackets = {
    TheWorst = {
        name = "TheWorst",
        packets = {
            "Floppa | floppa loves you",
            "Floppa | my little floppa",
            "Floppa | floppa is the best",
            "Floppa | i love floppa",
            "Floppa | floppa forever"
        }
    },
    Vape = {
        name = "Vape",
        packets = {
            "Vape | v4.10 loaded",
            "Vape | bypass successful",
            "Vape | injection complete",
            "Vape | all modules loaded",
            "Vape | silent aim active"
        }
    },
    Synapse = {
        name = "Synapse",
        packets = {
            "Synapse X | connected",
            "Synapse X | script executed",
            "Synapse X | bypassed",
            "Synapse X | running",
            "Synapse X | exploit ready"
        }
    },
    Krnl = {
        name = "Krnl",
        packets = {
            "Krnl | key validated",
            "Krnl | injected",
            "Krnl | executing",
            "Krnl | success",
            "Krnl | ready"
        }
    },
    ScriptWare = {
        name = "ScriptWare",
        packets = {
            "ScriptWare | loaded",
            "ScriptWare | ui initialized",
            "ScriptWare | scripts ready",
            "ScriptWare | hook installed",
            "ScriptWare | running"
        }
    },
    Electron = {
        name = "Electron",
        packets = {
            "Electron | connected",
            "Electron | bypassed",
            "Electron | ready",
            "Electron | executing",
            "Electron | done"
        }
    }
}

-- Логгер для консоли
local ConsoleLogs = {}
local ConsoleGroup

function AddConsoleLog(type, message, details)
    local timestamp = os.date("%H:%M:%S")
    local logEntry = {
        Time = timestamp,
        Type = type,
        Message = message,
        Details = details
    }
    table.insert(ConsoleLogs, 1, logEntry)
    
    if #ConsoleLogs > 100 then
        table.remove(ConsoleLogs)
    end
    
    if ConsoleGroup and ConsoleGroup.UpdateConsole then
        ConsoleGroup:UpdateConsole(ConsoleLogs)
    end
    
    local colorPrefix = ""
    if type == "SEND" then
        colorPrefix = "[📤 SEND]"
    elseif type == "INFO" then
        colorPrefix = "[ℹ️ INFO]"
    elseif type == "ERROR" then
        colorPrefix = "[❌ ERROR]"
    elseif type == "WARN" then
        colorPrefix = "[⚠️ WARN]"
    elseif type == "GEN" then
        colorPrefix = "[🎲 GEN]"
    elseif type == "FAKE" then
        colorPrefix = "[🎭 FAKE]"
    end
    
    print(string.format("%s [%s] %s", colorPrefix, timestamp, message))
    if details then
        print(string.format("   └─ %s", details))
    end
end

-- ============================================
-- ФУНКЦИЯ 1: КАСТОМНЫЕ ПАКЕТЫ
-- ============================================
local CustomPackets = {}

function CustomPackets.SendCustomPacket(text, strength)
    strength = strength or (Options.PacketStrength and Options.PacketStrength.Value or 6250)
    
    if not text or text == "" then
        AddConsoleLog("WARN", "Cannot send empty custom packet", "Please enter text")
        return false
    end
    
    local GrabEvents = game.ReplicatedStorage:FindFirstChild("GrabEvents")
    if not GrabEvents then
        AddConsoleLog("ERROR", "GrabEvents not found", "Remote folder missing")
        return false
    end
    
    local ExtendGrabLine = GrabEvents:FindFirstChild("ExtendGrabLine")
    if not ExtendGrabLine then
        AddConsoleLog("ERROR", "ExtendGrabLine not found", "Remote event missing")
        return false
    end
    
    local packetData = string.rep(text, strength)
    
    AddConsoleLog("INFO", "Custom packet created", string.format("Text: \"%s\" | Strength: %d | Length: %d", 
        string.sub(text, 1, 50), strength, #packetData))
    
    ExtendGrabLine:FireServer(packetData)
    
    AddConsoleLog("SEND", "Custom packet sent successfully", string.format("Size: %.2f KB", #packetData / 1024))
    
    Library:Notify({
        Title = "Custom Packet Sent",
        Description = string.format("Text: %s | Size: %.2f KB", string.sub(text, 1, 30), #packetData / 1024),
        Time = 2
    })
    
    return true
end

-- ============================================
-- ФУНКЦИЯ 2: ОРИГИНАЛЬНЫЕ ПАКЕТЫ (с эмодзи)
-- ============================================
local OriginalPackets = {}

function OriginalPackets.SendOriginalPacket(strength)
    strength = strength or (Options.PacketStrength and Options.PacketStrength.Value or 6250)
    
    local GrabEvents = game.ReplicatedStorage:FindFirstChild("GrabEvents")
    if not GrabEvents then
        AddConsoleLog("ERROR", "GrabEvents not found", "Remote folder missing")
        return false
    end
    
    local ExtendGrabLine = GrabEvents:FindFirstChild("ExtendGrabLine")
    if not ExtendGrabLine then
        AddConsoleLog("ERROR", "ExtendGrabLine not found", "Remote event missing")
        return false
    end
    
    local originalString = string.rep("😂😂😂😂🤣🤣🤣🤣", 100 * strength)
    
    AddConsoleLog("INFO", "Original packet created", string.format("Emojis: 😂😂😂😂🤣🤣🤣🤣 | Strength: %d | Length: %d", 
        strength, #originalString))
    
    ExtendGrabLine:FireServer(originalString)
    
    AddConsoleLog("SEND", "Original emoji packet sent", string.format("Size: %.2f KB | Contains %d emojis", 
        #originalString / 1024, 8 * 100 * strength))
    
    Library:Notify({
        Title = "Original Packet Sent",
        Description = string.format("Emoji packet | Size: %.2f KB", #originalString / 1024),
        Time = 2
    })
    
    return true
end

-- ============================================
-- ФУНКЦИЯ 3: ГЕНЕРАТОР ПОСЛЕДОВАТЕЛЬНОСТИ СИМВОЛОВ
-- ============================================
local SequenceGenerator = {}

-- Перемешивание таблицы
function SequenceGenerator.ShuffleTable(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

-- Генерация случайной последовательности
function SequenceGenerator.GenerateRandomSequence(length, useRandomOrder)
    length = length or (Options.SequenceLength and Options.SequenceLength.Value or 50)
    local sequence = {}
    
    if useRandomOrder then
        -- Создаем массив индексов и перемешиваем его
        local indices = {1, 2, 3, 4, 5}
        indices = SequenceGenerator.ShuffleTable(indices)
        
        for i = 1, length do
            local symbolIndex = indices[((i - 1) % 5) + 1]
            table.insert(sequence, symbols[symbolIndex])
        end
        
        AddConsoleLog("GEN", "Generated random order sequence", 
            string.format("Order: %s", table.concat(indices, " → ")))
    else
        -- Простая последовательность по кругу
        for i = 1, length do
            local symbolIndex = ((i - 1) % 5) + 1
            table.insert(sequence, symbols[symbolIndex])
        end
        
        AddConsoleLog("GEN", "Generated cyclic sequence", "Order: 1→2→3→4→5→1→2...")
    end
    
    local result = table.concat(sequence)
    
    -- Показываем превью
    local preview = string.sub(result, 1, 50)
    if #result > 50 then preview = preview .. "..." end
    
    AddConsoleLog("GEN", "Sequence generated", 
        string.format("Length: %d | Preview: %s", length, preview))
    
    return result
end

function SequenceGenerator.SendGeneratedPacket(useRandomOrder, strength)
    strength = strength or (Options.PacketStrength and Options.PacketStrength.Value or 6250)
    local length = Options.SequenceLength and Options.SequenceLength.Value or 50
    
    local GrabEvents = game.ReplicatedStorage:FindFirstChild("GrabEvents")
    if not GrabEvents then
        AddConsoleLog("ERROR", "GrabEvents not found", "Remote folder missing")
        return false
    end
    
    local ExtendGrabLine = GrabEvents:FindFirstChild("ExtendGrabLine")
    if not ExtendGrabLine then
        AddConsoleLog("ERROR", "ExtendGrabLine not found", "Remote event missing")
        return false
    end
    
    local sequence = SequenceGenerator.GenerateRandomSequence(length, useRandomOrder)
    local packetData = string.rep(sequence, strength)
    
    AddConsoleLog("INFO", "Generated packet created", 
        string.format("Sequence length: %d | Strength: %d | Total length: %d", 
        length, strength, #packetData))
    
    ExtendGrabLine:FireServer(packetData)
    
    AddConsoleLog("SEND", "Generated packet sent", 
        string.format("Type: %s | Size: %.2f KB", 
        useRandomOrder and "Random Order" or "Cyclic", #packetData / 1024))
    
    Library:Notify({
        Title = "Generated Packet Sent",
        Description = string.format("Sequence length: %d | Size: %.2f KB", length, #packetData / 1024),
        Time = 2
    })
    
    return true
end

-- ============================================
-- ФУНКЦИЯ 4: ФЕЙК ПАКЕТЫ (для разных софтов)
-- ============================================
local FakePacketSystem = {}

function FakePacketSystem.SendFakePacket(scriptName, strength)
    strength = strength or (Options.PacketStrength and Options.PacketStrength.Value or 6250)
    
    local GrabEvents = game.ReplicatedStorage:FindFirstChild("GrabEvents")
    if not GrabEvents then
        AddConsoleLog("ERROR", "GrabEvents not found", "Remote folder missing")
        return false
    end
    
    local ExtendGrabLine = GrabEvents:FindFirstChild("ExtendGrabLine")
    if not ExtendGrabLine then
        AddConsoleLog("ERROR", "ExtendGrabLine not found", "Remote event missing")
        return false
    end
    
    local scriptData = fakePackets[scriptName]
    if not scriptData then
        AddConsoleLog("ERROR", "Unknown script", string.format("Script: %s not found", scriptName))
        return false
    end
    
    -- Выбираем случайный пакет из списка
    local randomPacket = scriptData.packets[math.random(1, #scriptData.packets)]
    local packetData = string.rep(randomPacket .. " | ", strength)
    
    AddConsoleLog("FAKE", string.format("Sending fake packet from %s", scriptData.name), 
        string.format("Content: %s | Strength: %d", randomPacket, strength))
    
    ExtendGrabLine:FireServer(packetData)
    
    AddConsoleLog("SEND", string.format("Fake %s packet sent", scriptData.name), 
        string.format("Size: %.2f KB", #packetData / 1024))
    
    Library:Notify({
        Title = string.format("Fake %s Packet", scriptData.name),
        Description = string.format("Sent: %s", randomPacket),
        Time = 2
    })
    
    return true
end

function FakePacketSystem.SendAllFakePackets(strength)
    strength = strength or (Options.PacketStrength and Options.PacketStrength.Value or 6250)
    
    AddConsoleLog("FAKE", "Starting fake packet spam", "Will send packets from all scripts")
    
    for scriptName, scriptData in pairs(fakePackets) do
        FakePacketSystem.SendFakePacket(scriptName, strength)
        wait(0.2)
    end
    
    AddConsoleLog("FAKE", "All fake packets sent", "Completed spam from all scripts")
    
    Library:Notify({
        Title = "Fake Packets Sent",
        Description = "Sent packets from all scripts",
        Time = 2
    })
end

function FakePacketSystem.SendCustomFakePacket(scriptName, customMessage, strength)
    strength = strength or (Options.PacketStrength and Options.PacketStrength.Value or 6250)
    
    local GrabEvents = game.ReplicatedStorage:FindFirstChild("GrabEvents")
    if not GrabEvents then
        AddConsoleLog("ERROR", "GrabEvents not found", "Remote folder missing")
        return false
    end
    
    local ExtendGrabLine = GrabEvents:FindFirstChild("ExtendGrabLine")
    if not ExtendGrabLine then
        AddConsoleLog("ERROR", "ExtendGrabLine not found", "Remote event missing")
        return false
    end
    
    local packetData = string.rep(string.format("%s | %s", scriptName, customMessage), strength)
    
    AddConsoleLog("FAKE", string.format("Sending custom fake packet from %s", scriptName), 
        string.format("Message: %s | Strength: %d", customMessage, strength))
    
    ExtendGrabLine:FireServer(packetData)
    
    AddConsoleLog("SEND", string.format("Custom fake %s packet sent", scriptName), 
        string.format("Size: %.2f KB", #packetData / 1024))
    
    Library:Notify({
        Title = string.format("Custom Fake %s", scriptName),
        Description = string.format("Message: %s", string.sub(customMessage, 1, 30)),
        Time = 2
    })
    
    return true
end

-- ============================================
-- GUI: Вкладка PACKETS (Кастомные и Оригинальные)
-- ============================================
local PacketsGroup = Tabs.Packets:AddLeftGroupbox("Packet Controls")

-- Слайдер силы
PacketsGroup:AddSlider("PacketStrength", {
    Text = "Packet Strength",
    Default = 6250,
    Min = 1000,
    Max = 25000,
    Rounding = 0,
    Suffix = "",
    Compact = false,
    Tooltip = "Controls the power of the packet",
    Callback = function(Value)
        AddConsoleLog("INFO", "Packet strength changed", string.format("New strength: %d", Value))
    end,
})

PacketsGroup:AddDivider()

-- ОРИГИНАЛЬНЫЕ ПАКЕТЫ
PacketsGroup:AddLabel("📦 ORIGINAL PACKETS (Emoji)", true)
PacketsGroup:AddButton({
    Text = "Send Original Packet",
    Func = function()
        AddConsoleLog("INFO", "Sending original packet", "Emoji packet triggered")
        OriginalPackets.SendOriginalPacket()
    end,
    Tooltip = "Send original emoji packet: 😂😂😂😂🤣🤣🤣🤣",
})

PacketsGroup:AddDivider()

-- КАСТОМНЫЕ ПАКЕТЫ
PacketsGroup:AddLabel("✏️ CUSTOM PACKETS", true)

local CustomTextInput
PacketsGroup:AddInput("CustomText", {
    Default = "",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = true,
    Text = "Enter custom text",
    Placeholder = "Type anything here...",
    Tooltip = "Enter custom text to send as packet",
    Callback = function(Value)
        CustomTextInput = Value
    end,
})

PacketsGroup:AddButton({
    Text = "Send Custom Packet",
    Func = function()
        if CustomTextInput and CustomTextInput ~= "" then
            CustomPackets.SendCustomPacket(CustomTextInput)
        else
            AddConsoleLog("WARN", "Empty custom text", "Please enter text first")
            Library:Notify({
                Title = "Warning",
                Description = "Please enter some text first!",
                Time = 2
            })
        end
    end,
    Tooltip = "Send packet with your custom text",
})

-- ============================================
-- GUI: Вкладка GENERATOR (Генератор символов)
-- ============================================
local GeneratorGroup = Tabs.Generator:AddLeftGroupbox("Sequence Generator")

GeneratorGroup:AddSlider("SequenceLength", {
    Text = "Sequence Length",
    Default = 50,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Suffix = " symbols",
    Compact = false,
    Tooltip = "Length of symbol sequence to generate",
    Callback = function(Value)
        AddConsoleLog("INFO", "Sequence length changed", string.format("New length: %d", Value))
    end,
})

GeneratorGroup:AddDivider()

GeneratorGroup:AddButton({
    Text = "Send Cyclic Sequence (1→2→3→4→5)",
    Func = function()
        AddConsoleLog("INFO", "Sending cyclic sequence", "Order: 1→2→3→4→5 repeating")
        SequenceGenerator.SendGeneratedPacket(false)
    end,
    Tooltip = "Send packet with cyclic symbol sequence",
})

GeneratorGroup:AddButton({
    Text = "Send Random Order Sequence",
    Func = function()
        AddConsoleLog("INFO", "Sending random order sequence", "Symbols in random order")
        SequenceGenerator.SendGeneratedPacket(true)
    end,
    Tooltip = "Send packet with randomly ordered symbols",
})

GeneratorGroup:AddDivider()

-- Превью последовательности
GeneratorGroup:AddLabel("📊 Sequence Preview:", true)
local PreviewLabel = GeneratorGroup:AddLabel("Click generate to see preview", true)

GeneratorGroup:AddButton({
    Text = "Generate Preview",
    Func = function()
        local length = Options.SequenceLength.Value
        local sequence = SequenceGenerator.GenerateRandomSequence(length, false)
        local preview = string.sub(sequence, 1, 100)
        if #sequence > 100 then preview = preview .. "..." end
        PreviewLabel:SetText(string.format("Cyclic: %s", preview))
        
        wait(0.1)
        
        local randomSequence = SequenceGenerator.GenerateRandomSequence(length, true)
        local randomPreview = string.sub(randomSequence, 1, 100)
        if #randomSequence > 100 then randomPreview = randomPreview .. "..." end
        
        local secondLabel = Options["RandomPreviewLabel"]
        if not secondLabel then
            secondLabel = GeneratorGroup:AddLabel(string.format("Random: %s", randomPreview), true)
        else
            secondLabel:SetText(string.format("Random: %s", randomPreview))
        end
    end,
    Tooltip = "Generate preview of sequences",
})

-- ============================================
-- GUI: Вкладка FAKE PACKETS
-- ============================================
local FakeGroup = Tabs.FakePackets:AddLeftGroupbox("Fake Packet System")

FakeGroup:AddLabel("🎭 Fake packets from different executors/scripts", true)
FakeGroup:AddDivider()

-- Кнопки для каждого софта
for scriptKey, scriptData in pairs(fakePackets) do
    FakeGroup:AddButton({
        Text = string.format("Send Fake %s Packet", scriptData.name),
        Func = function()
            FakePacketSystem.SendFakePacket(scriptKey)
        end,
        Tooltip = string.format("Send fake packet that looks like from %s", scriptData.name),
    })
end

FakeGroup:AddDivider()

FakeGroup:AddButton({
    Text = "Send ALL Fake Packets (Spam)",
    Func = function()
        FakePacketSystem.SendAllFakePackets()
    end,
    Tooltip = "Send fake packets from all scripts",
    Risky = true,
})

FakeGroup:AddDivider()

-- Кастомный фейк пакет
FakeGroup:AddLabel("✏️ Custom Fake Packet", true)

local FakeScriptInput
local FakeMessageInput

FakeGroup:AddInput("FakeScriptName", {
    Default = "TheWorst",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = true,
    Text = "Script name",
    Placeholder = "TheWorst, Vape, Synapse...",
    Tooltip = "Enter script name to fake",
    Callback = function(Value)
        FakeScriptInput = Value
    end,
})

FakeGroup:AddInput("FakeMessage", {
    Default = "",
    Numeric = false,
    Finished = false,
    ClearTextOnFocus = true,
    Text = "Custom message",
    Placeholder = "Enter fake message...",
    Tooltip = "Enter custom message for fake packet",
    Callback = function(Value)
        FakeMessageInput = Value
    end,
})

FakeGroup:AddButton({
    Text = "Send Custom Fake Packet",
    Func = function()
        if FakeScriptInput and FakeScriptInput ~= "" and FakeMessageInput and FakeMessageInput ~= "" then
            FakePacketSystem.SendCustomFakePacket(FakeScriptInput, FakeMessageInput)
        else
            AddConsoleLog("WARN", "Missing fake packet info", "Please enter both script name and message")
            Library:Notify({
                Title = "Warning",
                Description = "Please enter script name and message!",
                Time = 2
            })
        end
    end,
    Tooltip = "Send custom fake packet with your own message",
})

-- ============================================
-- GUI: Консоль
-- ============================================
local ConsoleTab = Tabs.Console:AddLeftGroupbox("Packet Console")
ConsoleGroup = ConsoleTab

function ConsoleGroup:UpdateConsole(logs)
    for i = 1, 20 do
        local label = Options["ConsoleLog_" .. i]
        if label then
            label:SetText("")
        end
    end
    
    for i = 1, math.min(15, #logs) do
        local log = logs[i]
        local logText = string.format("[%s] [%s] %s", log.Time, log.Type, log.Message)
        if log.Details then
            logText = logText .. "\n      └─ " .. log.Details
        end
        
        local labelName = "ConsoleLog_" .. i
        if not Options[labelName] then
            ConsoleTab:AddLabel(labelName, {
                Text = logText,
                DoesWrap = true,
            })
        else
            Options[labelName]:SetText(logText)
        end
    end
end

ConsoleTab:AddButton({
    Text = "Clear Console",
    Func = function()
        while #ConsoleLogs > 0 do
            table.remove(ConsoleLogs)
        end
        ConsoleGroup:UpdateConsole(ConsoleLogs)
        AddConsoleLog("INFO", "Console cleared", "All logs removed")
    end,
    Tooltip = "Clear all console logs",
})

-- ============================================
-- Информация и API
-- ============================================
local InfoGroup = Tabs.Settings:AddLeftGroupbox("Information & API")

InfoGroup:AddLabel("📦 Available Functions:", true)
InfoGroup:AddLabel("1. CustomPackets.SendCustomPacket(text, strength)", true)
InfoGroup:AddLabel("2. OriginalPackets.SendOriginalPacket(strength)", true)
InfoGroup:AddLabel("3. SequenceGenerator.SendGeneratedPacket(randomOrder, strength)", true)
InfoGroup:AddLabel("4. FakePacketSystem.SendFakePacket(scriptName, strength)", true)

InfoGroup:AddDivider()
InfoGroup:AddLabel("🎭 Fake Script Names:", true)
local scriptsList = ""
for key, data in pairs(fakePackets) do
    scriptsList = scriptsList .. data.name .. ", "
end
InfoGroup:AddLabel(scriptsList:sub(1, -3), true)

-- Глобальный API
_G.PacketAPI = {
    -- Кастомные пакеты
    SendCustom = function(text, strength)
        return CustomPackets.SendCustomPacket(text, strength)
    end,
    
    -- Оригинальные пакеты
    SendOriginal = function(strength)
        return OriginalPackets.SendOriginalPacket(strength)
    end,
    
    -- Генератор последовательностей
    SendGenerated = function(randomOrder, strength)
        return SequenceGenerator.SendGeneratedPacket(randomOrder, strength)
    end,
    
    -- Фейк пакеты
    SendFake = function(scriptName, strength)
        return FakePacketSystem.SendFakePacket(scriptName, strength)
    end,
    
    SendAllFake = function(strength)
        return FakePacketSystem.SendAllFakePackets(strength)
    end,
    
    -- Утилиты
    GetSymbols = function()
        return symbols
    end,
    
    GetFakeScripts = function()
        return fakePackets
    end,
}

-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

-- Addons
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("PacketScript")
SaveManager:SetFolder("PacketScript/configs")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

-- Инициализация
AddConsoleLog("INFO", "Packet script loaded successfully", "Version 2.0 with 4 main functions")
print("╔════════════════════════════════════════════════════════════╗")
print("║     PACKET SCRIPT LOADED!                                  ║")
print("║                                                            ║")
print("║  Functions available:                                      ║")
print("║  1. CustomPackets.SendCustomPacket(text, strength)        ║")
print("║  2. OriginalPackets.SendOriginalPacket(strength)          ║")
print("║  3. SequenceGenerator.SendGeneratedPacket(random, strength)║")
print("║  4. FakePacketSystem.SendFakePacket(script, strength)     ║")
print("║                                                            ║")
print("║  Use _G.PacketAPI for easy access                         ║")
print("╚════════════════════════════════════════════════════════════╝")