-- ========================================================
-- Template Custom Script: Steal a Brainrot (Roblox)
-- Dibuat untuk keperluan modifikasi dan pembuatan script sendiri
-- ========================================================

-- Cek apakah game sudah sepenuhnya dimuat
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Variabel Player Lokal
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Notifikasi Sederhana
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Custom Script Loaded",
    Text = "Berhasil memuat template dasar untuk Steal a Brainrot!",
    Duration = 5
})

-- ========================================================
-- CONTOH FITUR 1: Auto Collect / Teleport ke Item (Contoh)
-- ========================================================
local function AutoCollectItems()
    pcall(function()
        -- Sesuaikan folder/nama objek tempat item spawn di game ini
        for _, item in pairs(Workspace:GetChildren()) do
            if item.Name == "BrainrotItem" or item:FindFirstChild("TouchInterest") then
                -- Teleport karakter ke posisi item (atau gunakan firetouchinterest)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Contoh mengambil dengan menyentuh bagian item
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 0)
                    task.wait()
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 1)
                end
            end
        end
    end)
end

-- ========================================================
-- CONTOH FITUR 2: Anti AFK (Agar tidak ter-kick saat ditinggal)
-- ========================================================
local function EnableAntiAFK()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    print("Anti-AFK Aktif!")
end

-- Jalankan Anti AFK secara otomatis
EnableAntiAFK()

-- ========================================================
-- CONTOH PEMBUATAN UI SEDERHANA (GUI)
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

-- Setup ScreenGui
ScreenGui.Name = "CustomBrainrotScript"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Setup MainFrame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser-geser dalam game

-- Setup Title
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "My Custom Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Setup Toggle Button
ToggleButton.Name = "ToggleAutoCollect"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Auto Collect: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

-- Logika Tombol
local isRunning = false
ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleButton.Text = "Auto Collect: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
        
        -- Loop berjalan terus selama aktif
        task.spawn(function()
            while isRunning do
                AutoCollectItems()
                task.wait(0.5) -- Jeda antar eksekusi
            end
        end)
    else
        ToggleButton.Text = "Auto Collect: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)
