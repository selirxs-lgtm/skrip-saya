-- ========================================================
-- CUSTOM SCRIPT: Steal a Brainrot [Overhauled & Pro Features]
-- ========================================================

-- 1. Bersihkan sisa script lama agar tidak bentrok
pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp and lp:FindFirstChild("PlayerGui") then
        if lp.PlayerGui:FindFirstChild("BrainrotUltimateHub") then
            lp.PlayerGui.BrainrotUltimateHub:Destroy()
        end
    end
    if _G.AutoCollectThread then task.cancel(_G.AutoCollectThread) end
    if _G.ESPThread then task.cancel(_G.ESPThread) end
    collectgarbage("collect")
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Notifikasi Berhasil Load
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Brainrot Ultimate Hub",
    Text = "Script berhasil diperbarui dengan Auto Collect Pintar!",
    Duration = 3
})

-- ========================================================
-- 2. PEMBUATAN UI PROFESIONAL & TOMBOL CLOSE
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ContentContainer = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "BrainrotUltimateHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -180)
MainFrame.Size = UDim2.new(0, 300, 0, 360)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

-- Top Bar
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TopBar.Size = UDim2.new(1, 0, 0, 45)

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 10)
UICornerTop.Parent = TopBar

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Steal a Brainrot [Ultimate]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close (X)
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
CloseButton.Position = UDim2.new(1, -35, 0.5, -12)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 6)
UICornerClose.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if _G.AutoCollectThread then task.cancel(_G.AutoCollectThread) end
    if _G.ESPThread then task.cancel(_G.ESPThread) end
end)

-- Container Scrollable untuk Tombol
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 10, 0, 55)
ContentContainer.Size = UDim2.new(1, -20, 1, -65)
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 420)
ContentContainer.ScrollBarThickness = 4

UIListLayout.Parent = ContentContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Fungsi Pembuat Tombol Universal
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentContainer
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name .. " [ OFF ]"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
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
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        else
            btn.Text = name .. " [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        end
        callback(state)
    end)
end

-- ========================================================
-- 3. FITUR-FITUR UTAMA BARU (DIPERKUAT)
-- ========================================================

-- FITUR 1: Auto Collect Pintar (Teleport ke item atau Paksa Ambil)
CreateButton("Auto Collect (Smart)", function(enabled)
    if enabled then
        _G.AutoCollectThread = task.spawn(function()
            while true do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        
                        -- Cari semua objek di Workspace yang berpotensi item/koin/drop
                        for _, obj in pairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") then
                                local name = obj.Name:lower()
                                -- Cek apakah part tersebut adalah item, koin, gift, atau memiliki touch interest
                                if name:find("coin") or name:find("item") or name:find("drop") or name:find("cash") or obj:FindFirstChild("TouchInterest") then
                                    -- Cara paksa 1: Pindahkan posisi karakter sebentar ke item (Magnet-like) atau sentuh langsung
                                    firetouchinterest(hrp, obj, 0)
                                    task.wait(0.05)
                                    firetouchinterest(hrp, hrp, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.3) -- Jeda cepat tapi aman
            end
        end)
    else
        if _G.AutoCollectThread then
            task.cancel(_G.AutoCollectThread)
            _G.AutoCollectThread = nil
        end
    end
end)

-- FITUR 2: Speed Hack (Lari Cepat 50)
local speedConn
CreateButton("Speed Hack (50)", function(enabled)
    if enabled then
        speedConn = RunService.RenderStepped:Connect(function()
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = 50
                end
            end)
        end)
    else
        if speedConn then speedConn:Disconnect() end
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
    end
end)

-- FITUR 3: Jump Power Tinggi (Loncat Tinggi)
local jumpConn
CreateButton("Super Jump", function(enabled)
    if enabled then
        jumpConn = RunService.RenderStepped:Connect(function()
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.JumpPower = 100
                end
            end)
        end)
    else
        if jumpConn then jumpConn:Disconnect() end
        pcall(function() LocalPlayer.Character.Humanoid.JumpPower = 50 end)
    end
end)

-- FITUR 4: Infinite Jump (Loncat Terus di Udara)
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
        if infJumpConn then infJumpConn:Disconnect() end
    end
end)

-- FITUR 5: Anti AFK (Supaya Gak Ke-Kick Idle)
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

-- FITUR 6: Fullbright (Terangi Seluruh Map Malam Hari)
CreateButton("Fullbright (Anti Gelap)", function(enabled)
    pcall(function()
        local Lighting = game:GetService("Lighting")
        if enabled then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = true
        end
    end)
end)
