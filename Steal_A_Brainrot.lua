-- ========================================================
-- CUSTOM SCRIPT: Steal a Brainrot (Full Complete)
-- ========================================================

-- 1. BAGIAN PEMBERSIH CACHE / SCRIPT LAMA (Biar gak "lengket" pas di-update)
pcall(function()
    -- Hapus GUI lama jika ada di CoreGui
    if game.CoreGui:FindFirstChild("StealABrainrotHub") then
        game.CoreGui.StealABrainrotHub:Destroy()
    end
    
    -- Putus koneksi loop global lama agar tidak berjalan dobel
    if _G.BrainrotLoopConnection then
        _G.BrainrotLoopConnection:Disconnect()
        _G.BrainrotLoopConnection = nil
    end
    
    -- Bersihkan sampah memori Lua
    collectgarbage("collect")
end)

-- Cek apakah game sudah termuat sempurna
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Variabel Utama
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Notifikasi Berhasil Load
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Steal A Brainrot Hub",
    Text = "Script berhasil dimuat dengan bersih tanpa cache lama!",
    Duration = 4
})

-- ========================================================
-- 2. FUNGSI UTAMA SCRIPT (Silakan kembangkan di sini)
-- ========================================================
local function DoAutoFeature()
    pcall(function()
        -- Masukkan logika script utama kamu di sini
        -- Contoh: Mengambil item atau interaksi game
    end)
end

-- ========================================================
-- 3. PEMBUATAN USER INTERFACE (GUI)
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

-- Berikan nama unik agar mudah dideteksi untuk dibersihkan nanti
ScreenGui.Name = "StealABrainrotHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Setup MainFrame (Menu Utama)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -90)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser pakai mouse/jari

-- Setup Title Bar
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Brainrot Hub [Updated]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Setup Tombol Toggle Fitur
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
ToggleButton.Position = UDim2.new(0.1, 0, 0.35, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 45)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Status: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

-- Logika Tombol On/Off
local isRunning = false
ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleButton.Text = "Status: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 83)
        
        -- Jalankan loop menggunakan pointer global agar bisa diputus nanti
        _G.BrainrotLoopConnection = task.spawn(function()
            while isRunning do
                DoAutoFeature()
                task.wait(0.5)
            end
        end)
    else
        ToggleButton.Text = "Status: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        
        if _G.BrainrotLoopConnection then
            -- Hentikan proses
            isRunning = false
        end
    end
end)
