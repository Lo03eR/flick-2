local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

RunService.RenderStepped:Connect(function()
    local cfg = getgenv().TuffConfig.Visuals
    local mcfg = getgenv().TuffConfig.Misc
    
    -- FullBright логика
    if cfg.FullBright then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1,1,1)
    end
    
    -- ESP Logic (через Highlight для скорости)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            local high = p.Character:FindFirstChild("TuffHigh") or Instance.new("Highlight", p.Character)
            high.Name = "TuffHigh"
            high.Enabled = cfg.Outline
            high.FillTransparency = 0.5
            high.OutlineColor = cfg.RainbowESP and Color3.fromHSV(tick()%5/5, 1, 1) or Color3.new(1,1,1)
        end
    end
end)