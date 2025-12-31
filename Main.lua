local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ СОЗДАНИЕ ОКНА ]]
local Window = Rayfield:CreateWindow({
   Name = "UNX Hub | Flick Edition",
   LoadingTitle = "Initializing UNX Ecosystem...",
   LoadingSubtitle = "by Gemini Thought Partner",
   ConfigurationSaving = {
      Enabled = true,
      Folder = "UNX_Configs",
      FileName = "FlickSettings"
   },
   KeySystem = false -- Можешь включить потом для приватности
})

-- [[ ВКЛАДКИ ]]
local TabCombat = Window:CreateTab("Combat", 4483362458) 
local TabVisuals = Window:CreateTab("Visuals", 4483345998)
local TabMisc = Window:CreateTab("Misc / Movement", 4483362458)

-- [[ СЕКЦИЯ: COMBAT ]]
TabCombat:CreateSection("Aimbot & Flick")

TabCombat:CreateToggle({
   Name = "Enable Aimbot (Flick)",
   CurrentValue = getgenv().AimSettings.Enabled,
   Callback = function(Value) getgenv().AimSettings.Enabled = Value end,
})

TabCombat:CreateSlider({
   Name = "Flick FOV",
   Range = {0, 500},
   Increment = 10,
   Suffix = "px",
   CurrentValue = getgenv().AimSettings.Fov,
   Callback = function(Value) getgenv().AimSettings.Fov = Value end,
})

TabCombat:CreateSlider({
   Name = "Prediction Speed",
   Range = {0.1, 0.3},
   Increment = 0.001,
   CurrentValue = getgenv().AimSettings.Prediction,
   Callback = function(Value) getgenv().AimSettings.Prediction = Value end,
})

TabCombat:CreateSection("Gun Mods")

TabCombat:CreateToggle({
   Name = "No Recoil / No Shake",
   CurrentValue = getgenv().CombatSettings.NoRecoil,
   Callback = function(Value) getgenv().CombatSettings.NoRecoil = Value end,
})

TabCombat:CreateToggle({
   Name = "Instant Reload & Ammo",
   CurrentValue = getgenv().CombatSettings.NoReload,
   Callback = function(Value) getgenv().CombatSettings.NoReload = Value end,
})

-- [[ СЕКЦИЯ: VISUALS ]]
TabVisuals:CreateSection("ESP Settings")

TabVisuals:CreateToggle({
   Name = "Master ESP Toggle",
   CurrentValue = getgenv().VisualSettings.Enabled,
   Callback = function(Value) getgenv().VisualSettings.Enabled = Value end,
})

TabVisuals:CreateToggle({
   Name = "Boxes & Chams",
   CurrentValue = getgenv().VisualSettings.Chams,
   Callback = function(Value) 
      getgenv().VisualSettings.Chams = Value 
      getgenv().VisualSettings.Boxes = Value
   end,
})

TabVisuals:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(169, 112, 255),
    Callback = function(Value) getgenv().VisualSettings.AliveColor = Value end
})

-- [[ СЕКЦИЯ: MISC ]]
TabMisc:CreateSection("Movement Exploits")

TabMisc:CreateToggle({
   Name = "Enable Target Strafe",
   CurrentValue = getgenv().AimSettings.StrafeEnabled,
   Callback = function(Value) getgenv().AimSettings.StrafeEnabled = Value end,
})

TabMisc:CreateSlider({
   Name = "Strafe Radius",
   Range = {5, 30},
   Increment = 1,
   CurrentValue = getgenv().AimSettings.StrafeRadius,
   Callback = function(Value) getgenv().AimSettings.StrafeRadius = Value end,
})

TabMisc:CreateButton({
   Name = "Unload Hub",
   Callback = function() Rayfield:Destroy() end,
})

Rayfield:Notify({
   Title = "Hub Loaded!",
   Content = "Press Right Shift to hide/show menu",
   Duration = 5,
   Image = 4483362458,
})