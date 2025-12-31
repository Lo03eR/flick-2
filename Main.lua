local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Инициализируем настройки, если они вдруг не были загружены из модулей
getgenv().AimSettings = getgenv().AimSettings or {Enabled = false, Fov = 150, Prediction = 0.165, StrafeEnabled = false, StrafeRadius = 10}
getgenv().VisualSettings = getgenv().VisualSettings or {Enabled = false, Chams = false, Boxes = false, AliveColor = Color3.fromRGB(169, 112, 255)}
getgenv().CombatSettings = getgenv().CombatSettings or {NoRecoil = false, NoReload = false}

local Window = Rayfield:CreateWindow({
   Name = "UNX Hub | Flick Edition",
   LoadingTitle = "Loading Elements...",
   LoadingSubtitle = "Please wait",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false 
})

-- 1. Создаем вкладки СНАЧАЛА
local TabCombat = Window:CreateTab("Combat", 4483362458) 
local TabVisuals = Window:CreateTab("Visuals", 4483345998)
local TabMisc = Window:CreateTab("Misc", 4483362458)

task.wait(0.1) -- Даем Rayfield "продышаться"

-- [[ COMBAT SECTION ]]
TabCombat:CreateSection("Aimbot Logic")

TabCombat:CreateToggle({
   Name = "Enable Flick Aimbot",
   CurrentValue = getgenv().AimSettings.Enabled,
   Flag = "AimToggle", 
   Callback = function(Value) getgenv().AimSettings.Enabled = Value end,
})

TabCombat:CreateSlider({
   Name = "FOV Radius",
   Range = {0, 500},
   Increment = 10,
   Suffix = "px",
   CurrentValue = getgenv().AimSettings.Fov,
   Flag = "FovSlider",
   Callback = function(Value) getgenv().AimSettings.Fov = Value end,
})

TabCombat:CreateSection("Weapon Mods")

TabCombat:CreateToggle({
   Name = "No Recoil",
   CurrentValue = getgenv().CombatSettings.NoRecoil,
   Flag = "RecoilToggle",
   Callback = function(Value) getgenv().CombatSettings.NoRecoil = Value end,
})

TabCombat:CreateToggle({
   Name = "Infinite Ammo / No Reload",
   CurrentValue = getgenv().CombatSettings.NoReload,
   Flag = "ReloadToggle",
   Callback = function(Value) getgenv().CombatSettings.NoReload = Value end,
})

-- [[ VISUALS SECTION ]]
TabVisuals:CreateSection("ESP Elements")

TabVisuals:CreateToggle({
   Name = "Master ESP",
   CurrentValue = getgenv().VisualSettings.Enabled,
   Flag = "EspMaster",
   Callback = function(Value) getgenv().VisualSettings.Enabled = Value end,
})

TabVisuals:CreateToggle({
   Name = "Chams & Boxes",
   CurrentValue = getgenv().VisualSettings.Chams,
   Flag = "ChamsToggle",
   Callback = function(Value) 
      getgenv().VisualSettings.Chams = Value 
      getgenv().VisualSettings.Boxes = Value
   end,
})

-- [[ MISC SECTION ]]
TabMisc:CreateSection("Movement")

TabMisc:CreateToggle({
   Name = "Target Strafe",
   CurrentValue = getgenv().AimSettings.StrafeEnabled,
   Flag = "StrafeToggle",
   Callback = function(Value) getgenv().AimSettings.StrafeEnabled = Value end,
})

Rayfield:Notify({
   Title = "Success!",
   Content = "All functions loaded successfully.",
   Duration = 3,
   Image = 4483362458,
})