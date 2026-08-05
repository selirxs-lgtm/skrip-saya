-- ========================================================
-- CUSTOM SCRIPT: Steal a Brainrot (Full Features + Anti-Ban)
-- ========================================================

-- 1. BAGIAN ANTI-NYANGKUT (CLEANUP CACHE LAMA)
pcall(function()
    if game.CoreGui:FindFirstChild("StealABrainrotHub") then
        game.CoreGui.StealABrainrotHub:Destroy()
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

-- 2. ANTI-CHEAT BYPASS & SAFETY
pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    local mt = getrawmetatable(game)
    if mt then
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                if self == LocalPlayer then
                    warn("Anti-Ban: Percobaan kick dari server diblokir!")
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

-- Variabel Utama
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Notifikasi Berhasil Load
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Steal A Brainrot [Pro Hub]",
    Text = "Script berhasil dimuat dengan fitur lengkap!",
    Duration = 4
})

-- ========================================================
-- 3. KUMPULAN FITUR UTAMA
-- ========================================================

-- Fitur 1: Auto Collect Item
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

-- Fitur 2: Anti AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- ========================================================
-- 4. PEMBUATAN USER INTERFACE (GUI MULTI-FITUR)
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "StealABrainrotHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

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
Title.Text = "Brainrot Hub [Pro Edition]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15

UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Fungsi Pembuat Tombol Toggle di GUI
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

-- ========================================================
-- 5. MENAMBAHKAN TOMBOL FITUR KE MENU GUI
-- ========================================================

-- Tombol Auto Collect
CreateToggleButton("Auto Collect", function(enabled)
    if enabled then
        _G.AutoCollectLoop = task.spawn(function()
            while true do
                AutoCollect()
                task.wait(0.5) -- Jeda aman agar tidak kena ban
            end
        end)
    else
        if _G.AutoCollectLoop then
            task.cancel(_G.AutoCollectLoop)
            _G.AutoCollectLoop = nil
        end
    end
end)

-- Tombol WalkSpeed Kencang (Contoh: Speed 50)
CreateToggleButton("Speed Hack (50)", function(enabled)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if enabled then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Normal
            end
        end
    end)
end)

-- Tombol Infinite Jump (Loncat Terus di Udara)
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
