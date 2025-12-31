local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MT = getrawmetatable(game) -- Доступ к скрытым настройкам игры
local OldIndex = MT.__index
setreadonly(MT, false)

-- [[ НАСТРОЙКИ КОМБАТА ]]
getgenv().CombatSettings = {
    NoReload = true,
    NoRecoil = true,
    InfiniteAmmo = true,
    RapidFire = false, -- Очень палевно, используй осторожно
    FireRateValue = 0.05
}

-- [[ ХУКИНГ (ГЛАВНАЯ МАГИЯ) ]]
MT.__index = newcclosure(function(self, property)
    -- Если скрипт игры пытается узнать отдачу или перезарядку
    if CombatSettings.NoRecoil and (property == "Recoil" or property == "Shake" or property == "Kickback") then
        return 0 -- Возвращаем ноль (отдачи нет)
    end
    
    if CombatSettings.NoReload and (property == "ReloadTime" or property == "ReloadSpeed") then
        return 0 -- Мгновенная перезарядка
    end
    
    if CombatSettings.InfiniteAmmo and (property == "Ammo" or property == "ClipSize" or property == "StoredAmmo") then
        return 999 -- Всегда полный магазин
    end

    return OldIndex(self, property)
end)

setreadonly(MT, true)

-- [[ ЦИКЛ ДЛЯ МОДИФИКАЦИИ ТЕКУЩЕГО ОРУЖИЯ ]]
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if CombatSettings.Enabled then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Прямое редактирование атрибутов (если мета-таблицы не хватило)
                    if tool:FindFirstChild("Configuration") then
                        local config = tool.Configuration
                        if CombatSettings.NoRecoil then
                            if config:FindFirstChild("Recoil") then config.Recoil.Value = 0 end
                        end
                        if CombatSettings.RapidFire then
                            if config:FindFirstChild("FireRate") then config.FireRate.Value = CombatSettings.FireRateValue end
                        end
                    end
                end
            end
        end)
    end
end)

print("Combat Module Loaded: No Recoil & No Reload Active")