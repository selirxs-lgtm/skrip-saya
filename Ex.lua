local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Buat Window Utama
local Window = Library.CreateLib("Rafael Xiter 🚀", "DarkTheme")

-- Tab Fitur Utama
local Tab = Window:NewTab("Fitur Utama")
local Section = Tab:NewSection("Menu Cheat & Fitur")

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

-- --- TAMBAHAN TOMBOL FLOATING ON/OFF YG BISA DIGESER ---
pcall(function()
    local old = CoreGui:FindFirstChild("RafaelXiter_FloatToggle")
    if old then old:Destroy() end
end)

local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "RafaelXiter_FloatToggle"
FloatGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
FloatGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton", FloatGui)
ToggleBtn.Size = UDim2.new(0, 110, 0, 36)
ToggleBtn.Position = UDim2.new(0, 20, 0, 150)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
ToggleBtn.Text = "⚡ MENU ON/OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.TextSize = 10
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- Biar tombolnya bisa digeser-geser di layar HP!

local BtnCorner = Instance.new("UICorner", ToggleBtn)
BtnCorner.CornerRadius = UDim.new(0, 8)

local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    Library:ToggleUI() -- Perintah bawaan Kavo buat sembunyikan/tampilkan menu
end)
--------------------------------------------------------

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
