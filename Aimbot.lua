-- [[ UNX AIMBOT & STRAFE MODULE ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Функция проверки стен (WallCheck)
local function IsVisible(targetPart)
    if not getgenv().TuffSettings.Aim.WallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char, targetPart.Parent}
    
    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 500, params)
    return result == nil
end

-- Поиск ближайшей цели
local function GetTarget()
    local closest, dist = nil, getgenv().TuffSettings.Aim.Fov
    local mouseLoc = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local head = p.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen and IsVisible(head) then
                    local mag = (Vector2.new(pos.X, pos.Y) - mouseLoc).Magnitude
                    if mag < dist then
                        dist = mag
                        closest = p
                    end
                end
            end
        end
    end
    return closest
end

-- ГЛАВНЫЙ ЦИКЛ (RenderStepped)
RunService.RenderStepped:Connect(function()
    -- Проверяем, созданы ли настройки, чтобы не было ошибок
    if not getgenv().TuffSettings or not getgenv().TuffSettings.Aim then return end
    
    local settings = getgenv().TuffSettings.Aim
    if not settings.Enabled then return end

    local target = GetTarget()
    if target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        local my_hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if hrp and my_hrp then
            -- 1. АИМБОТ (Lerp для плавности, чтобы не дергало)
            local prediction = hrp.Position + (hrp.Velocity * settings.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, prediction), 0.2)
            
            -- 2. СТРЕЙФ (Через Velocity, чтобы не банило)
            if settings.Strafe then
                local t = tick() * settings.Speed
                local x = math.cos(t) * settings.Radius
                local z = math.sin(t) * settings.Radius
                local targetPos = hrp.Position + Vector3.new(x, 3, z)
                
                -- Двигаем персонажа импульсом
                my_hrp.Velocity = (targetPos - my_hrp.Position).Unit * 60
            end
        end
    end
end)

print("UNX: Aimbot & Strafe Module Loaded!")