local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- [[ НАСТРОЙКИ АИМБОТА ]]
getgenv().AimSettings = {
    Enabled = true,
    FlickMode = true,      -- Резкий прыжок вместо плавного ведения
    TargetPart = "Head",   -- Куда целимся (Head, UpperTorso, HumanoidRootPart)
    Prediction = 0.165,    -- Коэффициент упреждения (подбери под пинг)
    Fov = 150,             -- Радиус захвата
    ShowFov = true,        -- Визуальный круг
    StrafeEnabled = true,  -- Тот самый Target Strafe
    StrafeRadius = 10,     -- Дистанция кружения вокруг врага
    StrafeSpeed = 5        -- Скорость вращения
}

local FovCircle = Drawing.new("Circle")
FovCircle.Thickness = 1
FovCircle.NumSides = 100
FovCircle.Radius = AimSettings.Fov
FovCircle.Filled = false
FovCircle.Visible = AimSettings.ShowFov
FovCircle.Color = Color3.fromRGB(169, 112, 255)

-- [[ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ]]
local function GetClosestPlayer()
    local target = nil
    local dist = AimSettings.Fov
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimSettings.TargetPart) then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then -- Целимся только в живых
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character[AimSettings.TargetPart].Position)
                if onScreen then
                    local magnitude = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if magnitude < dist then
                        dist = magnitude
                        target = player
                    end
                end
            end
        end
    end
    return target
end

-- [[ ЛОГИКА ТАРГЕТ-СТРЕЙФА ]]
local function DoTargetStrafe(target)
    if not AimSettings.StrafeEnabled or not target or not target.Character then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
    
    if hrp and targetHrp then
        local t = tick() * AimSettings.StrafeSpeed
        local x = math.cos(t) * AimSettings.StrafeRadius
        local z = math.sin(t) * AimSettings.StrafeRadius
        
        -- Вычисляем позицию вокруг врага
        local strafePos = targetHrp.Position + Vector3.new(x, 0, z)
        hrp.CFrame = CFrame.lookAt(strafePos, targetHrp.Position)
    end
end

-- [[ ОСНОВНОЙ ЦИКЛ ]]
RunService.RenderStepped:Connect(function()
    FovCircle.Visible = AimSettings.ShowFov
    FovCircle.Radius = AimSettings.Fov
    FovCircle.Position = UserInputService:GetMouseLocation()

    if AimSettings.Enabled then
        local target = GetClosestPlayer()
        
        if target and target.Character then
            -- 1. ЛОГИКА ПРЕДИКШЕНА (Расчет на опережение)
            local targetPart = target.Character[AimSettings.TargetPart]
            local velocity = target.Character.HumanoidRootPart.Velocity
            local predictedPosition = targetPart.Position + (velocity * AimSettings.Prediction)
            
            -- 2. FLICK / AIM
            local screenPos, _ = Camera:WorldToViewportPoint(predictedPosition)
            
            -- Если нажат ПКМ (или любая кнопка, которую ты выберешь)
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                if AimSettings.FlickMode then
                    -- Резкий Flick через прямое управление камерой
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPosition)
                end
                
                -- 3. ВКЛЮЧАЕМ СТРЕЙФ ПРИ ЗАХВАТЕ
                DoTargetStrafe(target)
            end
        end
    end
end)