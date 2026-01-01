-- [[ UNX HUB: ALL-IN-ONE BOOTLOADER ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. ИНИЦИАЛИЗАЦИЯ НАСТРОЕК (Чтобы не было ошибок Callback)
getgenv().TuffSettings = {
    Aim = {
        Enabled = false, Fov = 150, Prediction = 0.165, 
        WallCheck = true, Strafe = false, Radius = 12, Speed = 4
    },
    Visuals = {
        Enabled = false, Chams = true, Names = true, 
        Color = Color3.fromRGB(169, 112, 255)
    },
    Misc = {
        WalkSpeed = 16, InfJump = false
    }
}

-- 2. АВТО-ЗАГРУЗКА МОДУЛЕЙ (Вставь свои ссылки ниже)
local function LoadModule(url, name)
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if success then
        print("UNX: [SUCCESS] " .. name .. " Loaded")
    else
        warn("UNX: [ERROR] Failed to load " .. name .. ": " .. err)
    end
end

-- ЗАМЕНИ ЭТИ ССЫЛКИ НА СВОИ:
LoadModule("ССЫЛКА_НА_VISUALS.LUA", "Visuals")
LoadModule("ССЫЛКА_НА_AIMBOT.LUA", "Aimbot")
LoadModule("ССЫЛКА_НА_MISC.LUA", "Misc")

-- 3. СОЗДАНИЕ ИНТЕРФЕЙСА
local Window = Rayfield:CreateWindow({
   Name = "UNX HUB | FLICK EDITION V2",
   LoadingTitle = "Ecosystem Initializing...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = true, Folder = "UNX_Configs" }
})

-- Создаем вкладки
local TabCombat = Window:CreateTab("Combat", 4483362458)
local TabVisuals = Window:CreateTab("Visuals", 4483345998)
local TabMisc = Window:CreateTab("Misc", 4483362458)

-- Кнопки Combat
TabCombat:CreateSection("Aimbot Settings")
TabCombat:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(v) getgenv().TuffSettings.Aim.Enabled = v end,
})

TabCombat:CreateToggle({
   Name = "Wall Check (Visible Only)",
   CurrentValue = true,
   Callback = function(v) getgenv().TuffSettings.Aim.WallCheck = v end,
})

TabCombat:CreateToggle({
   Name = "Safe Velocity Strafe",
   CurrentValue = false,
   Callback = function(v) getgenv().TuffSettings.Aim.Strafe = v end,
})

TabCombat:CreateSlider({
   Name = "Aim FOV",
   Range = {0, 600},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) getgenv().TuffSettings.Aim.Fov = v end,
})

-- Кнопки Visuals
TabVisuals:CreateSection("ESP Options")
TabVisuals:CreateToggle({
   Name = "Enable Master ESP",
   CurrentValue = false,
   Callback = function(v) getgenv().TuffSettings.Visuals.Enabled = v end,
})

TabVisuals:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(169, 112, 255),
    Callback = function(v) getgenv().TuffSettings.Visuals.Color = v end
})

-- Кнопки Misc
TabMisc:CreateSection("Movement")
TabMisc:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 60},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) getgenv().TuffSettings.Misc.WalkSpeed = v end,
})

TabMisc:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(v) getgenv().TuffSettings.Misc.InfJump = v end,
})

Rayfield:Notify({
   Title = "UNX HUB LOADED",
   Content = "Все модули запущены автоматически!",
   Duration = 5
})