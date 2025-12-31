-- Инициализируем настройки глобально
getgenv().TuffSettings = {
    Aim = {
        Enabled = false,
        Fov = 150,
        Prediction = 0.165,
        Strafe = false,
        Radius = 12,
        Speed = 4
    },
    Visuals = {
        Enabled = false,
        Chams = true,
        Names = true,
        Color = Color3.fromRGB(169, 112, 255)
    },
    Combat = {
        NoRecoil = false,
        NoReload = false
    }
}
print("UNX: Settings Initialized")