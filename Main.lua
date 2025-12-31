local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Безопасная функция для Callback
local function SafeSet(tab, key, value)
    if getgenv().TuffSettings and getgenv().TuffSettings[tab] then
        getgenv().TuffSettings[tab][key] = value
    else
        warn("UNX Error: Settings not loaded yet!")
    end
end

local Window = Rayfield:CreateWindow({
   Name = "UNX HUB | FLICK",
   LoadingTitle = "UNX ECOSYSTEM",
   LoadingSubtitle = "Modular Fix",
   ConfigurationSaving = { Enabled = false }
})

local TabCombat = Window:CreateTab("Combat")
local TabVisuals = Window:CreateTab("Visuals")

-- COMBAT
TabCombat:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(v) SafeSet("Aim", "Enabled", v) end,
})

TabCombat:CreateToggle({
   Name = "Target Strafe",
   CurrentValue = false,
   Callback = function(v) SafeSet("Aim", "Strafe", v) end,
})

-- VISUALS
TabVisuals:CreateToggle({
   Name = "Master ESP",
   CurrentValue = false,
   Callback = function(v) SafeSet("Visuals", "Enabled", v) end,
})

TabVisuals:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(169, 112, 255),
    Callback = function(v) SafeSet("Visuals", "Color", v) end
})

Rayfield:Notify({Title = "UNX Fixed", Content = "Callbacks are now safe.", Duration = 3})