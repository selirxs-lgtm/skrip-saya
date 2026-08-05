-- 1. Mengunggah Library Kavo UI 🖼️
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rafael Xiter 🚀", "Midnight")

-- 2. Membuat Tombol Bulat Melayang (Toggle UI) 🔘
local ToggleScreen = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ToggleScreen.Name = "TeleportToggleUI"
ToggleScreen.Parent = game.CoreGui
ToggleScreen.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToggleScreen
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0, 10, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "🚀"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 25.000
ToggleButton.Active = true
ToggleButton.Draggable = true -- Memungkinkan tombol digeser di layar HP

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)

-- 3. Membuat Tab Utama & Label 📁
local Tab = Window:NewTab("Teleport Player 📍")
local Section = Tab:NewSection("Rafael Xiter Menu")

local autoTeleportEnabled = false
local maxRadius = 100

-- Fungsi mencari pemain terdekat berdasarkan radius 📏
local function getClosestPlayer()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local myPos = localPlayer.Character.HumanoidRootPart.Position
    local closestPlayer = nil
    local shortestDistance = maxRadius

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = player.Character.HumanoidRootPart.Position
            local distance = (myPos - targetPos).Magnitude
            
            if distance <= shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

-- 4. Slider Radius Jarak 📏
Section:NewSlider("Radius Terdekat", "Atur batas jarak pemain", 500, 10, function(value)
    maxRadius = value
end)

-- 5. Fitur Auto Teleport ke Pemain Terdekat 🔄
Section:NewToggle("Auto Teleport Player Terdekat", "Otomatis berpindah ke pemain terdekat", function(state)
    autoTeleportEnabled = state
    
    task.spawn(function()
        while autoTeleportEnabled do
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
            task.wait(0.5) -- Jeda waktu teleportasi
        end
    end)
end)

-- 6. Fitur Teleport Sekali Klik ⚡
Section:NewButton("Teleport Ke Pemain Terdekat (Sekali)", "Teleport 1 kali ke yang terdekat", function()
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)
