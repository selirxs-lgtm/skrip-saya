-- ========================================================
-- CUSTOM SCRIPT: Steal a Brainrot (Fixed UI & Safe)
-- ========================================================

-- 1. Bersihkan sisa script lama agar tidak bentrok
pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp and lp:FindFirstChild("PlayerGui") then
        if lp.PlayerGui:FindFirstChild("StealABrainrotHub") then
            lp.PlayerGui.StealABrainrotHub:Destroy()
        end
    end
    if _G.BrainrotLoopConnection then
        task.cancel(_G.BrainrotLoopConnection)
        _G.BrainrotLoopConnection = nil
    end
    collectgarbage("collect")
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Variabel Utama
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Notifikasi Tanda Berhasil
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Brainrot Hub",
    Text = "Script berhasil dimuat ke PlayerGui!",
    Duration = 3
})

-- ========================================================
-- FUNGSI FITUR
-- ========================================================
local function AutoCollect()
    pcall(function()
        for _, item in pairs(Workspace:GetChildren()) do
            if item:FindFirstChild("TouchInterest") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 0)
                task.wait()
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, item, 1)
            end
        end
    end)
end

-- ========================================================
-- PEMBUATAN UI (Dipindah ke PlayerGui agar pasti muncul)
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "StealABrainrotHub"
-- Menggunakan PlayerGui agar tembus di semua executor
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -140)
MainFrame.Size = UDim2.new(0, 240, 0, 260)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Brainrot Hub [Fixed]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15

UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Fungsi Tombol
local function CreateToggleButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = name .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 83)
        else
            btn.Text = name .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        end
        callback(state)
    end)
end

-- Tombol Auto Collect
CreateToggleButton("Auto Collect", function(enabled)
    if enabled then
        _G.AutoCollectLoop = task.spawn(function()
            while true do
                AutoCollect()
                task.wait(0.5)
            end
        end)
    else
        if _G.AutoCollectLoop then
            task.cancel(_G.AutoCollectLoop)
            _G.AutoCollectLoop = nil
        end
    end
end)

-- Tombol Speed Hack
CreateToggleButton("Speed Hack (50)", function(enabled)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if enabled then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end)
end)

-- Tombol Infinite Jump
local infJumpConn
CreateToggleButton("Infinite Jump", function(enabled)
    local UIS = game:GetService("UserInputService")
    if enabled then
        infJumpConn = UIS.JumpRequest:Connect(function()
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end)
    else
        if infJumpConn then
            infJumpConn:Disconnect()
            infJumpConn = nil
        end
    end
end)
