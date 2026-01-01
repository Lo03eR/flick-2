local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Функция проверки видимости
local function IsVisible(targetPart)
    if not getgenv().TuffSettings.Aim.WallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    
    local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 500)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {char, targetPart.Parent})
    
    return hit == nil -- Если луч ни обо что не ударился, значит цель видна
end

local function GetTarget()
    local closest, dist = nil, getgenv().TuffSettings.Aim.Fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen and IsVisible(head) then -- ПРОВЕРКА СТЕНЫ
                    local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
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

RunService.Heartbeat:Connect(function()
    local settings = getgenv().TuffSettings.Aim
    if settings.Enabled then
        local target = GetTarget()
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            local my_hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if hrp and my_hrp then
                -- Предикт и Аим
                local pred = hrp.Position + (hrp.Velocity * settings.Prediction)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, pred), 0.2) -- Сглаживание
                
                -- БЕЗОПАСНЫЙ СТРЕЙФ (через Velocity)
                if settings.Strafe then
                    local t = tick() * settings.Speed
                    local offset = Vector3.new(math.cos(t) * settings.Radius, 2, math.sin(t) * settings.Radius)
                    local targetPos = hrp.Position + offset
                    -- Плавное движение вместо телепорта
                    my_hrp.Velocity = (targetPos - my_hrp.Position).Unit * 50
                end
            end
        end
    end
end)