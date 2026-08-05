-- ========================================================
-- CUSTOM SCRIPT: Steal a Brainrot [Colorful Rainbow Edition]
-- ========================================================

pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp and lp:FindFirstChild("PlayerGui") then
        if lp.PlayerGui:FindFirstChild("BrainrotRainbowHub") then
            lp.PlayerGui.BrainrotRainbowHub:Destroy()
        end
    end
    if _G.StealLoop then task.cancel(_G.StealLoop) end
    if _G.SpeedLoop then _G.SpeedLoop:Disconnect() end
    if _G.NoclipConn then _G.NoclipConn:Disconnect() end
    if _G.RainbowConn then _G.RainbowConn:Disconnect() end
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

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Brainrot Rainbow Hub",
    Text = "Menu berhasil dimuat dengan tema warna gaming!",
    Duration = 3
})

-- ========================================================
-- UI UTAMA (COLORFUL & GAMING STYLE)
-- ========================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ContentContainer = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "BrainrotRainbowHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- Border Pinggiran Neon UI
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(138, 43, 226) -- Ungu Neon
UIStroke.Thickness = 2

TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
TopBar.Size = UDim2.new(1, 0, 0, 45)

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 12)
UICornerTop.Parent = TopBar

Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "✨ Brainrot Gaming Hub ✨"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Efek Warna Pelangi (RGB) otomatis bergerak di Judul & Border
_G.RainbowConn = RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    local rainbowColor = Color3.fromHSV(hue, 1, 1)
    pcall(function()
        UIStroke.Color = rainbowColor
        Title.TextColor3 = rainbowColor
    end)
end)

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
CloseButton.Position = UDim2.new(1, -35, 0.5, -12)
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "-"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 6)
UICornerClose.Parent = CloseButton

local isMinimized = false
CloseButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentContainer.Visible = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 45)
        CloseButton.Text = "+"
        CloseButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 380)
        CloseButton.Text = "-"
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    end
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
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 52)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name .. " [ OFF ]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 13

    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(0, 8)
    UICornerBtn.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = name .. " [ ON ]"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 110) -- Hijau Neon Terang
        else
            btn.Text = name .. " [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 52) -- Gelap Elegan
        end
        callback(state)
    end)
end

-- ========================================================
-- FITUR SAKTI
-- ========================================================

-- 1. Wallhack / Noclip Aman
CreateButton("Wallhack / Noclip (Aman)", function(enabled)
    if enabled then
        _G.NoclipConn = RunService.Stepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
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

-- 2. Auto Steal / Tarik Item Terdekat
CreateButton("Auto Steal / Tarik Item Terdekat", function(enabled)
    if enabled then
        _G.StealLoop = task.spawn(function()
            while true do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        for _, obj in pairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name:lower():find("brainrot") or obj.Name:lower():find("anomali") or obj.Name:lower():find("item") or obj:FindFirstChild("TouchInterest")) then
                                local dist = (hrp.Position - obj.Position).Magnitude
                                if dist < 35 then
                                    obj.CFrame = hrp.CFrame
                                    firetouchinterest(hrp, obj, 0)
                                    task.wait(0.05)
                                    firetouchinterest(hrp, obj, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    else
        if _G.StealLoop then
            task.cancel(_G.StealLoop)
            _G.StealLoop = nil
        end
    end
end)

-- 3. Speed Hack Aman (Anti Mati / Anti Void)
CreateButton("Speed Hack (Aman)", function(enabled)
    if enabled then
        _G.SpeedLoop = RunService.RenderStepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    local hum = char.Humanoid
                    if hum.MoveDirection.Magnitude > 0 then
                        local currentPos = char.HumanoidRootPart.Position
                        local moveDir = hum.MoveDirection
                        char.HumanoidRootPart.CFrame = CFrame.new(currentPos + (moveDir * 0.7)) * CFrame.Angles(0, select(2, char.HumanoidRootPart.CFrame:ToOrientation()), 0)
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

-- 4. Infinite Jump
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

-- 5. Fullbright
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
