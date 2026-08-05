-- 1. Mengunggah Library Kavo UI 🖼️
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rafael Xiter 🚀", "Midnight")

-- 2. Memuat Tombol Bulat Melayang (Toggle UI) 🔘
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
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)

-- 3. Tab Teleport Player 📁
local Tab1 = Window:NewTab("Teleport 📍")
local Section1 = Tab1:NewSection("Pilih Player / Auto")

local function getPlayerNames()
    local playerList = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

local selectedPlayer = ""

-- Dropdown Select Player 📜
local dropdown = Section1:NewDropdown("Pilih Pemain Target", "Pilih nama pemain", getPlayerNames(), function(option)
    selectedPlayer = option
end)

Section1:NewButton("Refresh Daftar Pemain", "Update nama pemain", function()
    dropdown:Refresh(getPlayerNames())
end)

Section1:NewButton("Teleport ke Player Pilihan", "Pindah ke pemain yang dipilih", function()
    if selectedPlayer ~= "" then
        local target = game.Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Fitur Auto Teleport Terdekat 📏
local autoTeleportEnabled = false
local maxRadius = 100

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

Section1:NewSlider("Radius Terdekat", "Batas jarak pemain", 500, 10, function(value)
    maxRadius = value
end)

Section1:NewToggle("Auto Teleport Terdekat", "Teleport otomatis ke yang terdekat", function(state)
    autoTeleportEnabled = state
    task.spawn(function()
        while autoTeleportEnabled do
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
            task.wait(0.5)
        end
    end)
end)

-- 4. Tab Fitur Utama (ESP & Fly) 📁
local Tab2 = Window:NewTab("Fitur 🛠️")
local Section2 = Tab2:NewSection("ESP & Movement")

-- Fitur ESP 👁️
local espEnabled = false
Section2:NewToggle("ESP Player", "Melihat posisi player lain", function(state)
    espEnabled = state
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            if espEnabled then
                if not player.Character:FindFirstChild("HighlightESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "HighlightESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = player.Character
                end
            else
                if player.Character:FindFirstChild("HighlightESP") then
                    player.Character.HighlightESP:Destroy()
                end
            end
        end
    end
end)

-- Fitur Fly 🕊️
local flying = false
local flySpeed = 50

Section2:NewSlider("Kecepatan Terbang", "Atur speed fly", 200, 10, function(value)
    flySpeed = value
end)

Section2:NewToggle("Fly (Terbang)", "Mengaktifkan mode terbang", function(state)
    flying = state
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")

    if flying and hrp then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp

        task.spawn(function()
            while flying and hrp:FindFirstChild("FlyVelocity") do
                local camCFrame = workspace.CurrentCamera.CFrame
                hrp.FlyVelocity.Velocity = camCFrame.LookVector * flySpeed
                task.wait()
            end
            if hrp:FindFirstChild("FlyVelocity") then
                hrp.FlyVelocity:Destroy()
            end
        end)
    else
        if hrp and hrp:FindFirstChild("FlyVelocity") then
            hrp.FlyVelocity:Destroy()
        end
    end
end)
