-- [[ UNX HUB CORE: AIM ENGINE ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки из UNX Hub (внутренние переменные для плавности)
local Smoothing = 0.1 -- Чем меньше, тем жестче наводка
local FOV_Circle = Drawing.new("Circle") -- Тот самый круг из UNX

-- Настройка круга FOV
FOV_Circle.Thickness = 1
FOV_Circle.Color = Color3.fromRGB(255, 255, 255)
FOV_Circle.Transparency = 0.7
FOV_Circle.Filled = false
FOV_Circle.Visible = false

-- Проверка стен (Wall Check по методу UNX)
local function VisibleCheck(part, ignore)
    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
    if hit and hit:IsDescendantOf(part.Parent) then
        return true
    end
    return false
end

-- Поиск цели как в оригинале
local function GetClosestPlayer()
    local target = nil
    local shortestDistance = getgenv().TuffSettings.Aim.Fov

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") then
            if v.Character.Humanoid.Health > 0 and v.Team ~= LocalPlayer.Team then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if distance < shortestDistance then
                        -- WallCheck из настроек
                        if getgenv().TuffSettings.Aim.WallCheck then
                            if VisibleCheck(v.Character.Head, {LocalPlayer.Character, v.Character}) then
                                shortestDistance = distance
                                target = v
                            end
                        else
                            shortestDistance = distance
                            target = v
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Основной цикл
RunService.RenderStepped:Connect(function()
    local settings = getgenv().TuffSettings.Aim
    
    -- Визуализация FOV
    FOV_Circle.Radius = settings.Fov
    FOV_Circle.Position = UserInputService:GetMouseLocation()
    FOV_Circle.Visible = settings.Enabled
    
    if settings.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local my_hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            -- Вычисление позиции с предиктом (Метод UNX)
            local targetPos = target.Character.Head.Position
            local velocity = hrp.Velocity
            local predictedPos = targetPos + (velocity * settings.Prediction)
            
            -- Наводка (Lerp для обхода античита)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, predictedPos), Smoothing)
            
            -- Механика Стрейфа (Velocity-based)
            if settings.Strafe and my_hrp then
                local t = tick() * settings.Speed
                local orbitPos = hrp.Position + Vector3.new(math.cos(t) * settings.Radius, 4, math.sin(t) * settings.Radius)
                my_hrp.Velocity = (orbitPos - my_hrp.Position).Unit * 55 -- Оптимальная скорость для Flick
            end
        end
    end
end)

print("UNX HUB: Aim Engine Loaded Successfully")