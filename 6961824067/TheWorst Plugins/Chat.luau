local Tabs = getgenv().UI.Tabs
local Sect = getgenv().UI.Sect
Sect.ChatSect = Tabs.ServerTab:AddSection({Name = "Chat", Side = "Left"})

local chatLoaded = false

Sect.ChatSect:AddButton({
    Name = "Load ChatGui",
    Icon = "rbxassetid://3944703587",
    DoubleTap = false,
    TapDelay = 0.5,
    Callback = function()
        if chatLoaded then return end
        chatLoaded = true
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZxcQuiltikk/Plugins/refs/heads/main/Chatv1.1.lua"))()
    end
})
