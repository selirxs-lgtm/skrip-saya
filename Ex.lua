local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local espEnabled = false
local aimbotEnabled = false
local godModeEnabled = false
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false
local autoTeleportEnabled = false
local autoKillEnabled = false
local fovRadius = 120
local aiming = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RafaelXiter_Gui"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 42)

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Rafael xiter"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton", Header)
CloseButton.Size = UDim2.new(0, 50, 0, 24)
CloseButton.Position = UDim2.new(1, -58, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Text = "TUTUP"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 10
CloseButton.Font = Enum.Font.GothamBold

local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(0, 6)

-- Ubah pakai List biasa biar gak ketutup ScrollingFrame yang bug
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -12, 1, -50)
Container.Position = UDim2.new(0, 6, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 480)
Container.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout", Container)
UIList.SortOrder = Enum.SortOrder.LayoutIndex
UIList.Padding = UDim.new(0, 6)

local function makeBtn(order, text)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, -4, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    b.Text = text .. " : OFF"
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.LayoutOrder = order
    
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 6)
    return b
end

local BtnESP = makeBtn(1, "ESP")
local BtnAim = makeBtn(2, "AIMBOT")
local BtnGod = makeBtn(3, "UNLIMITED HEALTH")
local BtnTp = makeBtn(4, "AUTO TELEPORT")
local BtnKill = makeBtn(5, "AUTO KILL")
local BtnNoclip = makeBtn(6, "NOCLIP")
local BtnSpeed = makeBtn(7, "SUPER SPEED")
local BtnJump = makeBtn(8, "SUPER JUMP")

local OpenButton = Instance.new("TextButton", ScreenGui)
OpenButton.Size = UDim2.new(0, 110, 0, 36)
OpenButton.Position = UDim2.new(0, 15, 0, 15)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
OpenButton.Text = "⚡ BUKA MENU"
OpenButton.TextColor3 = Color3.fromRGB(15, 15, 20)
OpenButton.TextSize = 11
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false

local OpenCorner = Instance.new("UICorner", OpenButton)
OpenCorner.CornerRadius = UDim.new(0, 8)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

local function toggle(btn, name, callback)
    btn.MouseButton1Click:Connect(function()
        if btn.Text:find("OFF") then
            btn.Text = name .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            callback(true)
        else
            btn.Text = name .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            callback(false)
        end
    end)
end

toggle(BtnESP, "ESP", function(v) espEnabled = v end)
toggle(BtnGod, "UNLIMITED HEALTH", function(v) godModeEnabled = v end)
toggle(BtnTp, "AUTO TELEPORT", function(v) autoTeleportEnabled = v end)
toggle(BtnKill, "AUTO KILL", function(v) autoKillEnabled = v end)
toggle(BtnNoclip, "NOCLIP", function(v) noclipEnabled = v end)
toggle(BtnSpeed, "SUPER SPEED", function(v) speedEnabled = v end)
toggle(BtnJump, "SUPER JUMP", function(v) jumpEnabled = v end)

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
