-- [[ FLICK HUB MONOLITH ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. Инициализация Глобальных Настроек (Защита от nil)
getgenv().AimSettings = {Enabled = false, Fov = 150, Prediction = 0.165, StrafeEnabled = false, StrafeRadius = 10, TargetPart = "Head", ShowFov = true}
getgenv().VisualSettings = {Enabled = false, Chams = false, Boxes = false, Names = true, Tracers = false, AliveColor = Color3.fromRGB(169, 112, 255)}
getgenv().CombatSettings = {NoRecoil = false, NoReload = false}

-- 2. Создание окна
local Window = Rayfield:CreateWindow({
   Name = "UNX Hub | Flick Edition",
   LoadingTitle = "Building Interface...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- 3. Создание вкладок
local TabCombat = Window:CreateTab("Combat", 4483362458) 
local TabVisuals = Window:CreateTab("Visuals", 4483345998)
local TabMisc = Window:CreateTab("Misc", 4483362458)

-- [[ ФУНКЦИИ COMBAT (Встраиваем сразу) ]]
TabCombat:CreateSection("Aimbot & Flick")

TabCombat:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value) getgenv().AimSettings.Enabled = Value end,
})

TabCombat:CreateSlider({
   Name = "Aimbot FOV",
   Range = {0, 500},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 150,
   Flag = "FovSlider",
   Callback = function(Value) getgenv().AimSettings.Fov = Value end,
})

TabCombat:CreateSection("Gun Mods")

TabCombat:CreateToggle({
   Name = "No Recoil",
   CurrentValue = false,
   Flag = "RecoilToggle",
   Callback = function(Value) getgenv().CombatSettings.NoRecoil = Value end,
})

TabCombat:CreateToggle({
   Name = "Infinite Ammo / No Reload",
   CurrentValue = false,
   Flag = "ReloadToggle",
   Callback = function(Value) getgenv().CombatSettings.NoReload = Value end,
})

-- [[ ФУНКЦИИ VISUALS ]]
TabVisuals:CreateSection("ESP Options")

TabVisuals:CreateToggle({
   Name = "Master ESP",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value) getgenv().VisualSettings.Enabled = Value end,
})

TabVisuals:CreateToggle({
   Name = "Chams & Boxes",
   CurrentValue = false,
   Flag = "ChamsToggle",
   Callback = function(Value) 
      getgenv().VisualSettings.Chams = Value 
      getgenv().VisualSettings.Boxes = Value
   end,
})

TabVisuals:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(169, 112, 255),
    Flag = "EspColor",
    Callback = function(Value) getgenv().VisualSettings.AliveColor = Value end
})

-- [[ ФУНКЦИИ MISC ]]
TabMisc:CreateSection("Movement")

TabMisc:CreateToggle({
   Name = "Target Strafe",
   CurrentValue = false,
   Flag = "StrafeToggle",
   Callback = function(Value) getgenv().AimSettings.StrafeEnabled = Value end,
})

TabMisc:CreateSlider({
   Name = "Strafe Speed",
   Range = {1, 20},
   Increment = 1,
   CurrentValue = 5,
   Flag = "StrafeSpeed",
   Callback = function(Value) getgenv().AimSettings.StrafeSpeed = Value end,
})

-- [[ ЗАПУСК ФОНОВЫХ ЛОГИК (Чтобы всё работало) ]]
-- (Тут должны быть твои циклы из Aimbot.lua, Visuals.lua и Combat.lua)
-- Для теста я добавил уведомление:
Rayfield:Notify({
   Title = "UNX Loaded",
   Content = "Интерфейс готов к работе!",
   Duration = 5,
   Image = 4483362458,
})