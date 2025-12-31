-- [[ UNX HUB: REBORN STABLE ]]
local Success, Error = pcall(function()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    -- 1. ГЛОБАЛЬНЫЕ НАСТРОЙКИ (Инициализируем ПЕРЕД всем)
    getgenv().Tuff = {
        Aim = {Enabled = false, Fov = 150, Prediction = 0.165, Strafe = false, Radius = 10, Speed = 5, Part = "Head"},
        Vis = {Enabled = false, Chams = false, Boxes = false, Names = true, Color = Color3.fromRGB(169, 112, 255)},
        Combat = {NoRecoil = false, NoReload = false}
    }

    local Window = Rayfield:CreateWindow({
        Name = "UNX HUB | FLICK",
        LoadingTitle = "Loading System...",
        LoadingSubtitle = "Stable Version",
        ConfigurationSaving = {Enabled = false},
        KeySystem = false
    })

    -- 2. ВКЛАДКИ
    local Tab1 = Window:CreateTab("Combat", 4483362458)
    local Tab2 = Window:CreateTab("Visuals", 4483345998)

    -- 3. КНОПКИ (COMBAT)
    Tab1:CreateSection("Aimbot")
    Tab1:CreateToggle({
        Name = "Flick Aimbot",
        CurrentValue = false,
        Callback = function(v) getgenv().Tuff.Aim.Enabled = v end
    })
    Tab1:CreateSlider({
        Name = "FOV",
        Range = {0, 500},
        Increment = 10,
        CurrentValue = 150,
        Callback = function(v) getgenv().Tuff.Aim.Fov = v end
    })
    Tab1:CreateSection("Target Strafe")
    Tab1:CreateToggle({
        Name = "Enable Strafe",
        CurrentValue = false,
        Callback = function(v) getgenv().Tuff.Aim.Strafe = v end
    })

    -- 4. КНОПКИ (VISUALS)
    Tab2:CreateSection("ESP")
    Tab2:CreateToggle({
        Name = "Master ESP",
        CurrentValue = false,
        Callback = function(v) getgenv().Tuff.Vis.Enabled = v end
    })
    Tab2:CreateToggle({
        Name = "Chams (Wallhack)",
        CurrentValue = false,
        Callback = function(v) getgenv().Tuff.Vis.Chams = v end
    })

    -- [[ ЛОГИКА АИМБОТА ]]
    local Camera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")

    local function GetTarget()
        local closest, dist = nil, getgenv().Tuff.Aim.Fov
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
        if getgenv().Tuff.Aim.Enabled then
            local target = GetTarget()
            if target and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local pred = target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * getgenv().Tuff.Aim.Prediction)
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, pred)
                
                -- Strafe logic
                if getgenv().Tuff.Aim.Strafe then
                    local t = tick() * getgenv().Tuff.Aim.Speed
                    local lp_hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if lp_hrp then
                        lp_hrp.CFrame = CFrame.lookAt(target.Character.HumanoidRootPart.Position + Vector3.new(math.cos(t)*10, 0, math.sin(t)*10), target.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end)
end)

if not Success then
    warn("HUB ERROR: " .. Error)
end