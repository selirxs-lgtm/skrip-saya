local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Buat Window Utama
local Window = Library.CreateLib("Rafael Xiter 🚀", "DarkTheme")

-- Buat Tab Menu
local Tab = Window:NewTab("Fitur Utama")
local Section = Tab:NewSection("Pilih Fitur Cheat")

local godModeEnabled = false
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false
local autoTeleportEnabled = false
local autoKillEnabled = false

-- Tombol Toggle Kavo UI
Section:NewToggle("Unlimited Health", "Membuat darah penuh terus", function(state)
    godModeEnabled = state
end)

Section:NewToggle("Auto Teleport", "Teleport otomatis ke target", function(state)
    autoTeleportEnabled = state
end)

Section:NewToggle("Auto Kill", "Membunuh musuh otomatis", function(state)
    autoKillEnabled = state
end)

Section:NewToggle("Noclip", "Menembus tembok dan objek", function(state)
    noclipEnabled = state
end)

Section:NewToggle("Super Speed", "Kecepatan lari super kencang", function(state)
    speedEnabled = state
end)

Section:NewToggle("Super Jump", "Loncat tinggi banget", function(state)
    jumpEnabled = state
end)

-- Eksekusi Fitur di Background (RenderStepped)
RunService.RenderStepped:Connect(function()
    if godModeEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end
    if noclipEnabled and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if speedEnabled then hum.WalkSpeed = 250 end
        if jumpEnabled then hum.JumpPower = 200 end
    end
end)
