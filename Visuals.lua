local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function UpdateChams(player)
    local char = player.Character
    if char then
        local highlight = char:FindFirstChild("UNX_Highlight")
        if getgenv().TuffSettings.Visuals.Enabled and getgenv().TuffSettings.Visuals.Chams then
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "UNX_Highlight"
                highlight.Parent = char
            end
            highlight.FillColor = getgenv().TuffSettings.Visuals.Color
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        else
            if highlight then highlight:Destroy() end
        end
    end
end

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            UpdateChams(player)
        end
    end
end)