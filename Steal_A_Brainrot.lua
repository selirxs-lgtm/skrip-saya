-- ========================================================
-- CUSTOM SCRIPT: Steal a Brainrot [Fixed & Overhauled]
-- ========================================================

-- 1. Bersihkan sisa script lama agar tidak bentrok
pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp and lp:FindFirstChild("PlayerGui") then
        if lp.PlayerGui:FindFirstChild("BrainrotProHub") then
            lp.PlayerGui.BrainrotProHub:Destroy()
        end
    end
    if _G.BrainrotLoop then
        task.cancel(_G.BrainrotLoop)
        _G.BrainrotLoop = nil
    end
    collectgarbage("collect")
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Notifikasi Berhasil Load
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Brainrot Hub [Fixed]",
    Text = "Menu berhasil dimuat dengan UI rapi & Tombol Close!",
    Duration = 3
})

-- ========================================================
-- 2. PEMBUATAN UI YANG RAPI & ADA TOMBOL CLOSE
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ContentContainer = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "BrainrotProHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Main Frame (Ukuran pas, tidak terlalu besar)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

-- Garis Sudut Melengkung Biar Estetik
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

-- Top Bar (Header)
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 8)
UICornerTop.Parent = TopBar

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Brainrot Pro Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close (Tutup UI)
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Position = UDim2.new(1, -32, 0.5, -12)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 4)
UICornerClose.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if _G.BrainrotLoop then
        task.cancel(_G.BrainrotLoop)
    end
end)

-- Container untuk daftar tombol fitur (Bisa di-scroll jika banyak)
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 10, 0, 50)
ContentContainer.Size = UDim2.new(1, -20, 1, -60)
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 300)
ContentContainer.ScrollBarThickness = 4

UIListLayout.Parent = ContentContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Fungsi Pembuat Tombol Fitur yang Rapi
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentContainer
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name .. " [ OFF ]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13

    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(0, 6)
    UICornerBtn.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = name .. " [ ON ]"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        else
            btn.Text = name .. " [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end
        callback(state)
    end)
end

-- ========================================================
-- 3. IMPLEMENTASI FITUR YANG DIPERBAIKI
-- ========================================================

-- Fitur 1: Auto Collect (Mencari koin/item berdasarkan nama umum di Workspace)
CreateButton("Auto Collect Items", function(enabled)
    if enabled then
        _G.BrainrotLoop = task.spawn(function()
            while true do
                pcall(function()
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        -- Deteksi objek yang memiliki sentuhan interaktif atau koin
                        if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("item") or obj.Name:lower():find("drop") or obj:FindFirstChild("TouchInterest")) then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                                task.wait()
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                            end
                        end
                    end
                end)
                task.wait(1) -- Jeda aman agar tidak memberatkan game
            end
        end)
    else
        if _G.BrainrotLoop then
            task.cancel(_G.BrainrotLoop)
            _G.BrainrotLoop = nil
        end
    end
end)

-- Fitur 2: Speed Hack Stabil (Menggunakan loop agar tidak ketimpa sistem game)
local speedConn
CreateButton("Speed Hack (50)", function(enabled)
    if enabled then
        speedConn = game:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 50
                end
            end)
        end)
    else
        if speedConn then
            speedConn:Disconnect()
            speedConn = nil
        end
        pcall(function()
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end)
    end
end)

-- Fitur 3: Infinite Jump Stabil (Menggunakan UserInputService murni agar tidak mati sendiri)
local infJumpConn
CreateButton("Infinite Jump", function(enabled)
    if enabled then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
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

-- Fitur 4: Anti AFK Otomatis
CreateButton("Anti AFK", function(enabled)
    if enabled then
        pcall(function()
            local vu = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end)
    end
end)
