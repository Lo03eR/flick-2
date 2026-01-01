local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ ГЛОБАЛЬНЫЕ НАСТРОЙКИ ]]
getgenv().AimbotSettings = {
    Enabled = false,
    WallCheck = true,
    Smoothing = 0.15, -- Плавность (0.1 - 1)
    Prediction = 0.165, -- Для Flick идеально 0.165
    Fov = 150,
    TargetPart = "Head",
    Strafe = false
}

-- [[ ПЕРЕМЕННЫЕ СИСТЕМЫ ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ ЛОГИКА ПРОВЕРКИ СТЕН (ИЗ ТВОЕГО ПРИМЕРА) ]]
local function IsVisible(targetPart)
    if not getgenv().AimbotSettings.WallCheck then return true end
    local char = LocalPlayer.Character
    if not char then return false end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char, targetPart.Parent}
    
    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000, params)
    return result == nil
end

-- [[ ПОИСК БЛИЖАЙШЕЙ ЦЕЛИ К КУРСОРУ ]]
local function GetClosestPlayer()
    local target = nil
    local shortestDistance = getgenv().AimbotSettings.Fov
    local mouseLoc = UserInputService:GetMouseLocation()

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().AimbotSettings.TargetPart) then
            local hum = v.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and v.Team ~= LocalPlayer.Team then
                local part = v.Character[getgenv().AimbotSettings.TargetPart]
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                
                if onScreen and IsVisible(part) then
                    local distance = (Vector2.new(pos.X, pos.Y) - mouseLoc).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        target = v
                    end
                end
            end
        end
    end
    return target
end

-- [[ ОСНОВНОЙ ЦИКЛ ОБНОВЛЕНИЯ ]]
RunService.RenderStepped:Connect(function()
    if not getgenv().AimbotSettings.Enabled then return end
    
    local target = GetClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local settings = getgenv().AimbotSettings
        local targetPart = target.Character[settings.TargetPart]
        local velocity = target.Character.HumanoidRootPart.Velocity
        
        -- Расчет Предикта (как в твоем примере)
        local predictedPos = targetPart.Position + (velocity * settings.Prediction)
        
        -- Плавная наводка
        local lookAt = CFrame.lookAt(Camera.CFrame.Position, predictedPos)
        Camera.CFrame = Camera.CFrame:Lerp(lookAt, settings.Smoothing)
        
        -- Если включен стрейф
        if settings.Strafe and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myHrp = LocalPlayer.Character.HumanoidRootPart
            local t = tick() * 5
            local orbit = target.Character.HumanoidRootPart.Position + Vector3.new(math.cos(t) * 12, 4, math.sin(t) * 12)
            myHrp.Velocity = (orbit - myHrp.Position).Unit * 55
        end
    end
end)

-- [[ ИНТЕРФЕЙС RAYFIELD ]]
local Window = Rayfield:CreateWindow({
   Name = "UNX HUB | RAYFIELD EDITION",
   LoadingTitle = "Initializing Aim Engine...",
   LoadingSubtitle = "Based on Obsidian Logic",
})

local MainTab = Window:CreateTab("Combat", 4483362458)

MainTab:CreateSection("Aimbot Main")

MainTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Callback = function(Value) getgenv().AimbotSettings.Enabled = Value end,
})

MainTab:CreateToggle({
   Name = "Wall Check",
   CurrentValue = true,
   Callback = function(Value) getgenv().AimbotSettings.WallCheck = Value end,
})

MainTab:CreateDropdown({
   Name = "Target Part",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = "Head",
   Callback = function(Option) getgenv().AimbotSettings.TargetPart = Option[1] end,
})

MainTab:CreateSection("Aimbot Settings")

MainTab:CreateSlider({
   Name = "Field of View",
   Range = {0, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(Value) getgenv().AimbotSettings.Fov = Value end,
})

MainTab:CreateSlider({
   Name = "Prediction Amount",
   Range = {0, 1000},
   Increment = 1,
   CurrentValue = 165,
   Callback = function(Value) getgenv().AimbotSettings.Prediction = Value / 1000 end,
})

MainTab:CreateSlider({
   Name = "Smoothing (Lower is slower)",
   Range = {1, 100},
   Increment = 1,
   CurrentValue = 15,
   Callback = function(Value) getgenv().AimbotSettings.Smoothing = Value / 100 end,
})

MainTab:CreateSection("Misc")

MainTab:CreateToggle({
   Name = "Target Strafe",
   CurrentValue = false,
   Callback = function(Value) getgenv().AimbotSettings.Strafe = Value end,
})

Rayfield:Notify({Title = "Ready", Content = "Аимбот на логике Obsidian загружен!", Duration = 3})