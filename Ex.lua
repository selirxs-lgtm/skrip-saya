local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

pcall(function()
    local old = (gethui and gethui():FindFirstChild("RafaelXiter_Pure")) or CoreGui:FindFirstChild("RafaelXiter_Pure") or LocalPlayer.PlayerGui:FindFirstChild("RafaelXiter_Pure")
    if old then old:Destroy() end
end)

local godModeEnabled = false
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false
local autoTeleportEnabled = false
local autoKillEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RafaelXiter_Pure"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Title Text kecil ngambang di pojok kiri atas layar
local Title = Instance.new("TextLabel", ScreenGui)
Title.Size = UDim2.new(0, 160, 0, 25)
Title.Position = UDim2.new(0.03, 0, 0.22, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Rafael xiter ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold

local function makeFloatingBtn(index, text)
    local b = Instance.new("TextButton", ScreenGui)
    b.Size = UDim2.new(0, 160, 0, 32)
    b.Position = UDim2.new(0.03, 0, 0.22, (index * 36))
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    b.Text = text .. " : OFF"
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.TextSize = 10
    b.Font = Enum.Font.GothamBold
    b.Active = true
    b.Draggable = true

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 6)

    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(0, 255, 200)
    s.Thickness = 1
    return b
end

local BtnGod = makeFloatingBtn(1, "HEALTH")
local BtnTp = makeFloatingBtn(2, "TELEPORT")
local BtnKill = makeFloatingBtn(3, "AUTO KILL")
local BtnNoclip = makeFloatingBtn(4, "NOCLIP")
local BtnSpeed = makeFloatingBtn(5, "SPEED")
local BtnJump = makeFloatingBtn(6, "JUMP")

local function toggle(btn, name, callback)
    btn.MouseButton1Click:Connect(function()
        if btn.Text:find("OFF") then
            btn.Text = name .. " : ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            callback(true)
        else
            btn.Text = name .. " : OFF"
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
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
