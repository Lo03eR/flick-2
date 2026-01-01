local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().TuffSettings.Misc.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- WalkSpeed
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().TuffSettings.Misc.WalkSpeed
    end
end)