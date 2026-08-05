local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local godModeEnabled = false
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false
local autoTeleportEnabled = false
local autoKillEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RafaelXiter_Floating"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Buat Container Bar di Pinggir Layar biar gampang diakses
local MainContainer = Instance.new("ScrollingFrame", ScreenGui)
MainContainer.Size = UDim2.new(0, 180, 0, 320)
MainContainer.Position = UDim2.new(0.02, 0, 0.3, 0)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainContainer.BackgroundTransparency = 0.2
MainContainer.Active = true
MainContainer.Draggable = true
MainContainer.CanvasSize = UDim2.new(0, 0, 0, 280)
MainContainer.ScrollBarThickness = 4

local ContainerCorner = Instance.new("UICorner", MainContainer)
ContainerCorner.CornerRadius = UDim.new(0, 10)

local UIList = Instance.new("UIListLayout", MainContainer)
UIList.SortOrder = Enum.SortOrder.LayoutIndex
UIList.Padding = UDim.new(0, 6)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Title Header kecil
local Title = Instance.new("TextLabel", MainContainer)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Rafael xiter"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Title.LayoutOrder = 0

local function makeBtn(order, text)
    local b = Instance.new("TextButton", MainContainer)
    b.Size = UDim2.new(0, 165, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    b.Text = text .. " : OFF"
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.LayoutOrder = order
    
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 6)
    return b
end

local BtnGod = makeBtn(1, "HEALTH")
local BtnTp = makeBtn(2, "TELEPORT")
local BtnKill = makeBtn(3, "AUTO KILL")
local BtnNoclip = makeBtn(4, "NOCLIP")
local BtnSpeed = makeBtn(5, "SPEED")
local BtnJump = makeBtn(6, "JUMP")

local function toggle(btn, name, callback)
    btn.MouseButton1Click:Connect(function()
        if btn.Text:find("OFF") then
            btn.Text = name + " : ON" -- Diubah stringnya biar aman
            btn.Text = name .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            callback(true)
        else
            btn.Text = name .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            callback(false)
        end
    end)
end

toggle(BtnGod, "HEALTH", function(v) godModeEnabled = v end)
toggle(BtnTp, "TELEPORT", function(v) autoTeleportEnabled = v end)
toggle(BtnKill, "AUTO KILL", function(v) autoKillEnabled = v end)
toggle(BtnNoclip, "NOCLIP", function(v) noclipEnabled = v end)
toggle(BtnSpeed, "SPEED", function(v) speedEnabled = v end)
toggle(BtnJump, "JUMP", function(v) jumpEnabled = v end)

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
