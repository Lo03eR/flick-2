local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function GetTarget()
    local closest, dist = nil, getgenv().TuffSettings.Aim.Fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
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

RunService.RenderStepped:Connect(function()
    local settings = getgenv().TuffSettings.Aim
    if settings.Enabled then
        local target = GetTarget()
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            local my_hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if hrp and my_hrp then
                -- Наводка
                local pred = hrp.Position + (hrp.Velocity * settings.Prediction)
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, pred)
                
                -- Стрейф
                if settings.Strafe and (my_hrp.Position - hrp.Position).Magnitude < 50 then
                    local t = tick() * settings.Speed
                    local x, z = math.cos(t) * settings.Radius, math.sin(t) * settings.Radius
                    my_hrp.Velocity = Vector3.new(0,0,0)
                    my_hrp.CFrame = CFrame.lookAt(hrp.Position + Vector3.new(x, 2, z), hrp.Position)
                end
            end
        end
    end
end)