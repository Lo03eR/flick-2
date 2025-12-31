local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ ЗАГРУЗКА МОДУЛЕЙ ]]
-- loadstring(game:HttpGet("ТВОЯ_ССЫЛКА_НА_SETTINGS"))()
-- task.spawn(function() loadstring(game:HttpGet("ТВОЯ_ССЫЛКА_НА_VISUALS"))() end)
-- task.spawn(function() loadstring(game:HttpGet("ТВОЯ_ССЫЛКА_НА_AIMBOT"))() end)

local Window = Rayfield:CreateWindow({
   Name = "UNX HUB | FLICK EDITION",
   LoadingTitle = "Loading Professional UI...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = true, Folder = "UNX_Configs" }
})

local TabCombat = Window:CreateTab("Combat", 4483362458)
local TabVisuals = Window:CreateTab("Visuals", 4483345998)

-- [[ COMBAT UI ]]
TabCombat:CreateToggle({
   Name = "Enable Flick Aimbot",
   CurrentValue = false,
   Callback = function(Value) getgenv().TuffSettings.Aim.Enabled = Value end,
})

TabCombat:CreateSlider({
   Name = "FOV Radius",
   Range = {0, 600},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(Value) getgenv().TuffSettings.Aim.Fov = Value end,
})

TabCombat:CreateToggle({
   Name = "Target Strafe",
   CurrentValue = false,
   Callback = function(Value) getgenv().TuffSettings.Aim.Strafe = Value end,
})

-- [[ VISUALS UI ]]
TabVisuals:CreateToggle({
   Name = "Master ESP (Chams)",
   CurrentValue = false,
   Callback = function(Value) getgenv().TuffSettings.Visuals.Enabled = Value end,
})

TabVisuals:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(169, 112, 255),
    Callback = function(Value) getgenv().TuffSettings.Visuals.Color = Value end
})

Rayfield:Notify({Title = "UNX Loaded", Content = "Full Modular System Active", Duration = 5})