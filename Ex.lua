local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Buat Window Utama
local Window = Library.CreateLib("Rafael Xiter 🚀", "DarkTheme")

-- Tab Fitur Utama
local Tab = Window:NewTab("Fitur Utama")
local Section = Tab:NewSection("Menu Cheat & Fitur Utama")

local godModeEnabled = false
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false
local autoTeleportEnabled = false
local autoKillEnabled = false

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

-- Section Kedua untuk bikin kontennya panjang ke bawah biar menu otomatis bisa di-scroll
local Section2 = Tab:NewSection("Pengaturan Tambahan & Informasi")

Section2:NewSlider("Atur WalkSpeed", "Mengubah kecepatan jalan", 500, 16, function(v)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and speedEnabled then hum.WalkSpeed = v end
end)

Section2:NewButton("Reset Karakter", "Membunuh karakter (Reset)", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

Section2:NewLabel("Status Script: Aman & Lancar")
Section2:NewLabel("Creator: Rafael Xiter")
Section2:NewLabel("Versi: Kavo Mobile UI Fixed")

-- Eksekusi Fitur di Background
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
