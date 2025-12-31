local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- [[ НАСТРОЙКИ ВИЗУАЛА ]]
getgenv().VisualSettings = {
    Enabled = true,
    Boxes = true,
    Names = true,
    Tracers = true,
    Health = true,
    Chams = true, -- Та самая заливка
    TeamCheck = false,
    AliveColor = Color3.fromRGB(169, 112, 255), -- Фиолетовый (твой стиль)
    DeadColor = Color3.fromRGB(255, 0, 0),     -- Красный (труп)
    Thickness = 1.5
}

local Cache = {}

-- [[ ФУНКЦИИ ОТРИСОВКИ ]]
local function CreateDrawing(type, props)
    local d = Drawing.new(type)
    for i, v in pairs(props) do d[i] = v end
    return d
end

local function ApplyChams(char, color)
    local highlight = char:FindFirstChild("UNX_Chams") or Instance.new("Highlight")
    highlight.Name = "UNX_Chams"
    highlight.Parent = char
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Видно сквозь стены!
    return highlight
end

local function AddPlayer(player)
    if player == LocalPlayer then return end
    Cache[player] = {
        Box = CreateDrawing("Square", {Thickness = VisualSettings.Thickness, Filled = false, Visible = false}),
        Name = CreateDrawing("Text", {Size = 14, Center = true, Outline = true, Visible = false}),
        Tracer = CreateDrawing("Line", {Thickness = VisualSettings.Thickness, Visible = false}),
        HealthBar = CreateDrawing("Line", {Thickness = 2, Color = Color3.new(0, 1, 0), Visible = false})
    }
end

-- [[ ОСНОВНОЙ ЦИКЛ ]]
RunService.RenderStepped:Connect(function()
    if not VisualSettings.Enabled then
        for _, obj in pairs(Cache) do for _, d in pairs(obj) do d.Visible = false end end
        return
    end

    for player, drawings in pairs(Cache) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if char and hrp and hum then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
            
            -- Проверка: мертв или жив
            local isDead = hum.Health <= 0
            local renderColor = isDead and VisualSettings.DeadColor or VisualSettings.AliveColor

            -- Обновляем Chams
            if VisualSettings.Chams then
                ApplyChams(char, renderColor)
            elseif char:FindFirstChild("UNX_Chams") then
                char.UNX_Chams:Destroy()
            end

            if onScreen then
                local sizeX = 2500 / dist
                local sizeY = 3500 / dist
                local xPos = pos.X - sizeX / 2
                local yPos = pos.Y - sizeY / 2

                -- BOX
                if VisualSettings.Boxes then
                    drawings.Box.Visible = true
                    drawings.Box.Size = Vector2.new(sizeX, sizeY)
                    drawings.Box.Position = Vector2.new(xPos, yPos)
                    drawings.Box.Color = renderColor
                else drawings.Box.Visible = false end

                -- NAME & DIST
                if VisualSettings.Names then
                    drawings.Name.Visible = true
                    drawings.Name.Text = string.format("%s [%dm]", player.Name, math.floor(dist))
                    drawings.Name.Position = Vector2.new(pos.X, yPos - 15)
                    drawings.Name.Color = Color3.new(1, 1, 1)
                else drawings.Name.Visible = false end

                -- TRACER
                if VisualSettings.Tracers then
                    drawings.Tracer.Visible = true
                    drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    drawings.Tracer.To = Vector2.new(pos.X, yPos + sizeY)
                    drawings.Tracer.Color = renderColor
                else drawings.Tracer.Visible = false end

                -- HEALTH
                if VisualSettings.Health and not isDead then
                    drawings.HealthBar.Visible = true
                    drawings.HealthBar.From = Vector2.new(xPos - 5, yPos + sizeY)
                    drawings.HealthBar.To = Vector2.new(xPos - 5, yPos + sizeY - (sizeY * (hum.Health / hum.MaxHealth)))
                else drawings.HealthBar.Visible = false end
            else
                for _, d in pairs(drawings) do d.Visible = false end
            end
        else
            -- Если игрока нет (удалился из игры), всё скрываем
            for _, d in pairs(drawings) do d.Visible = false end
        end
    end
end)

-- Регистрация игроков
Players.PlayerAdded:Connect(AddPlayer)
Players.PlayerRemoving:Connect(function(p)
    if Cache[p] then
        for _, d in pairs(Cache[p]) do d:Remove() end
        Cache[p] = nil
    end
end)
for _, p in pairs(Players:GetPlayers()) do AddPlayer(p) end