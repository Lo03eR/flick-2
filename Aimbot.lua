local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Логика FOV Circle (как в твоем примере)
local FOV_Ring = Drawing.new("Circle")
FOV_Ring.Thickness = 1.5
FOV_Ring.Filled = false
FOV_Ring.Transparency = 0.8

local function IsVisible(targetPart, char)
    if not getgenv().TuffConfig.Aim.WallCheck then return true end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000, params)
    return result == nil or result.Instance:IsDescendantOf(char)
end

local function GetTarget()
    local target, dist = nil, getgenv().TuffConfig.Aim.Fov
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen and IsVisible(head, p.Character) then
                local mDist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mDist < dist then dist = mDist; target = p end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local cfg = getgenv().TuffConfig.Aim
    FOV_Ring.Visible = cfg.ShowFov
    FOV_Ring.Radius = cfg.Fov
    FOV_Ring.Position = UserInputService:GetMouseLocation()
    FOV_Ring.Color = cfg.RainbowFov and Color3.fromHSV(tick()%5/5, 1, 1) or Color3.new(1,1,1)

    if cfg.Enabled then
        local t = GetTarget()
        if t and t.Character then
            local aimPart = t.Character:FindFirstChild(cfg.Part)
            local vel = t.Character.HumanoidRootPart.Velocity
            local predicted = aimPart.Position + (vel * cfg.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, predicted), cfg.Smooth)
            
            -- AutoFire (из твоей логики Flick)
            if cfg.AutoFire then
                local rem = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                if rem and rem:FindFirstChild("CheckFire") then rem.CheckFire:FireServer() end
            end
        end
    end
end)