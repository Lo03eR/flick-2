local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Функция очистки
local function ClearESP(char)
    if char:FindFirstChild("UNX_Highlight") then char.UNX_Highlight:Destroy() end
    if char:FindFirstChild("UNX_Tag") then char.UNX_Tag:Destroy() end
end

-- Логика отрисовки
RunService.RenderStepped:Connect(function()
    if not getgenv().TuffSettings.Visuals.Enabled then 
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then ClearESP(p.Character) end
        end
        return 
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            
            -- Chams (Highlight)
            local highlight = char:FindFirstChild("UNX_Highlight") or Instance.new("Highlight")
            highlight.Name = "UNX_Highlight"
            highlight.Parent = char
            highlight.FillColor = getgenv().TuffSettings.Visuals.Color
            highlight.OutlineTransparency = 0
            highlight.FillTransparency = 0.5
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            
            -- Name Tags (Если нужно как в UNX)
            if getgenv().TuffSettings.Visuals.Names and not char:FindFirstChild("UNX_Tag") then
                local billboard = Instance.new("BillboardGui", char)
                billboard.Name = "UNX_Tag"
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.ExtentsOffset = Vector3.new(0, 3, 0)
                
                local label = Instance.new("TextLabel", billboard)
                label.Text = p.Name
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextStrokeTransparency = 0
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
            end
        end
    end
end)