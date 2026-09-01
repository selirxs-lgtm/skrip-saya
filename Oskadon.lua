local Players = game:GetService("Players")
local player = Players.LocalPlayer

local SPEED_MIN = 16
local SPEED_MAX = 100
local speed = 50
local enabled = true

local function applySpeed()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.WalkSpeed = enabled and speed or 16
    end
end

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    applySpeed()
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(280, 180) -- Diperbesar sedikit untuk tombol Toggle
frame.Position = UDim2.new(0.5, -140, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Active = true
frame.Draggable = true -- Bikin GUI bisa digeser
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "SPEED MENU"
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

local value = Instance.new("TextLabel")
value.Size = UDim2.new(1, 0, 0, 25)
value.Position = UDim2.fromOffset(0, 35)
value.Text = "Speed: " .. speed
value.TextSize = 18
value.TextColor3 = Color3.new(1, 1, 1)
value.BackgroundTransparency = 1
value.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(240, 30)
toggleBtn.Position = UDim2.fromOffset(20, 65)
toggleBtn.Text = "Status: ON"
toggleBtn.TextSize = 16
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Parent = frame

local minus = Instance.new("TextButton")
minus.Size = UDim2.fromOffset(110, 40)
minus.Position = UDim2.fromOffset(20, 110)
minus.Text = "-"
minus.TextSize = 25
minus.Parent = frame

local plus = Instance.new("TextButton")
plus.Size = UDim2.fromOffset(110, 40)
plus.Position = UDim2.fromOffset(150, 110)
plus.Text = "+"
plus.TextSize = 25
plus.Parent = frame

toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggleBtn.Text = enabled and "Status: ON" or "Status: OFF"
    toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(40, 160, 60) or Color3.fromRGB(180, 40, 40)
    applySpeed()
end)

minus.MouseButton1Click:Connect(function()
    speed = math.max(SPEED_MIN, speed - 5)
    value.Text = "Speed: " .. speed
    applySpeed()
end)

plus.MouseButton1Click:Connect(function()
    speed = math.min(SPEED_MAX, speed + 5)
    value.Text = "Speed: " .. speed
    applySpeed()
end)

applySpeed()
