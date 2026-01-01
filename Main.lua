local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local Window = Library:CreateWindow({ Title = "TUFF HUB | FLICK", Footer = "Version 1.0", Icon = 85154843954874 })

-- ЗАГРУЗКА МОДУЛЕЙ
task.spawn(function()
    loadstring(game:HttpGet("ССЫЛКА_НА_SETTINGS.LUA"))()
    loadstring(game:HttpGet("ССЫЛКА_НА_AIMBOT.LUA"))()
    -- Добавь сюда Visuals.lua когда создашь
end)

local Tabs = { Main = Window:AddTab("Combat", "crosshair"), Visuals = Window:AddTab("Visuals", "eye") }

-- НАСТРОЙКИ АИМА (Привязываем к Obsidian)
local AimGroup = Tabs.Main:AddLeftGroupbox("Aimbot")

AimGroup:AddCheckbox("AimEnabled", { Text = "Enable Aimbot", Default = false, Callback = function(v) 
    getgenv().TuffConfig.Aim.Enabled = v 
end })

AimGroup:AddSlider("AimSmooth", { Text = "Smoothing", Default = 4, Min = 1, Max = 10, Callback = function(v) 
    getgenv().TuffConfig.Aim.Smooth = v / 10 
end })

AimGroup:AddSlider("AimFov", { Text = "FOV Size", Default = 150, Min = 10, Max = 800, Callback = function(v) 
    getgenv().TuffConfig.Aim.Fov = v 
end })

Library:Notify("Tuff Hub Loaded!")