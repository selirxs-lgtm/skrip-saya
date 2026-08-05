-- ========================================================
-- CUSTOM SCRIPT: Steal a Brainrot [Ultimate Bypass & Noclip Edition]
-- ========================================================

pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp and lp:FindFirstChild("PlayerGui") then
        if lp.PlayerGui:FindFirstChild("BrainrotGodHub") then
            lp.PlayerGui.BrainrotGodHub:Destroy()
        end
    end
    if _G.StealLoop then task.cancel(_G.StealLoop) end
    if _G.SpeedLoop then task.cancel(_G.SpeedLoop) end
    if _G.NoclipConn then _G.NoclipConn:Disconnect() end
    collectgarbage("collect")
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Notifikasi
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Brainrot God Hub",
    Text = "Mode Noclip & Steal Aktif!",
    Duration = 3
})

-- ========================================================
-- UI UTAMA
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ContentContainer = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "BrainrotGodHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.Size = UDim2.new(1, 0, 0, 45)

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 10)
UICornerTop.Parent = TopBar

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Steal a Brainrot [God Mode]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
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
    if _G.StealLoop then task.cancel(_G.StealLoop) end
    if _G.SpeedLoop then task.cancel(_G.SpeedLoop) end
    if _G.NoclipConn then _G.NoclipConn:Disconnect() end
end)

ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 10, 0, 55)
ContentContainer.Size = UDim2.new(1, -20, 1, -65)
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 450)
ContentContainer.ScrollBarThickness = 4

UIListLayout.Parent = ContentContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentContainer
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
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
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
        else
            btn.Text = name .. " [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        end
        callback(state)
    end)
end

-- ========================================================
-- FITUR SAKTI
-- ========================================================

-- 1. FITUR WALLHACK / NOCLIP (Tembus Tembok Markas Orang)
CreateButton("Wallhack / Noclip (Tembus Markas)", function(enabled)
    if enabled then
        _G.NoclipConn = RunService.Stepped:Connect(function()
            pcall(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)
    else
        if _G.NoclipConn then
            _G.NoclipConn:Disconnect()
            _G.NoclipConn = nil
        end
    end
end)

-- 2. FITUR TELEPORT / TARIK ANOMALI & BRAINROT (Auto Steal)
CreateButton("Auto Steal / Teleport Item", function(enabled)
    if enabled then
        _G.StealLoop = task.spawn(function()
            while true do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        -- Menyisir seluruh map untuk mencari objek/anomali/brainrot
                        for _, obj in pairs(Workspace:GetDescendants()) do
                            if obj:IsA("Model") and (obj.Name:lower():find("brainrot") or obj.Name:lower():find("anomali") or obj.Name:lower():find("item") or obj:FindFirstChild("PrimaryPart")) then
                                local targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                                if targetPart then
                                    -- Teleportasi posisi objek ke depan kita atau sentuh paksa
                                    firetouchinterest(hrp, targetPart, 0)
                                    task.wait(0.02)
                                    firetouchinterest(hrp, targetPart, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        if _G.StealLoop then
            task.cancel(_G.StealLoop)
            _G.StealLoop = nil
        end
    end
end)

-- 3. SPEED HACK BYPASS (CFrame Based - Dijamin Jalan)
CreateButton("Speed Hack (CFrame Speed)", function(enabled)
    if enabled then
        _G.SpeedLoop = RunService.RenderStepped:Connect(function(dt)
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local hum = char.Humanoid
                    if hum.MoveDirection.Magnitude > 0 then
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (hum.MoveDirection * 0.8)
                    end
                end
            end)
        end)
    else
        if _G.SpeedLoop then
            _G.SpeedLoop:Disconnect()
            _G.SpeedLoop = nil
        end
    end
end)

-- 4. INFINITE JUMP
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

-- 5. FULLBRIGHT
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
