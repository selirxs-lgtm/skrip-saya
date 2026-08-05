-- 1. Memuat Library Kavo UI 🖼️
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rafael Xiter 🚀", "Midnight")

-- Fitur Membuat Jendela Menu Utama Bisa Digeser (Draggable) 🔀
task.spawn(function()
    local coreGui = game:GetService("CoreGui")
    for _, gui in pairs(coreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
            gui.Main.Active = true
            gui.Main.Draggable = true
        end
    end
end)

-- 2. Membuat Tombol Bulat Melayang (Toggle UI Bebas Bug) 🔘
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

-- Perbaikan Tombol Toggle: Mengubah Visible secara langsung 👁️
ToggleButton.MouseButton1Click:Connect(function()
    local coreGui = game:GetService("CoreGui")
    for _, gui in pairs(coreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
            gui.Main.Visible = not gui.Main.Visible
        end
    end
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

-- 4. Tab Fitur Utama (ESP, Fly, Bypass) 📁
local Tab2 = Window:NewTab("Fitur 🛠️")
local Section2 = Tab2:NewSection("ESP, Fly & Bypass")

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

local noclipEnabled = false
Section2:NewToggle("Bypass Kunci/Penghalang Rumah", "Bisa menembus pintu & dinding rumah", function(state)
    noclipEnabled = state
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- 5. Tab Fitur Troll 🎭 (5 Fitur)
local Tab3 = Window:NewTab("Troll 🎭")
local Section3 = Tab3:NewSection("Fitur Troll Lucu")

-- Troll 1: Spin Karakter 🌀
local spinning = false
Section3:NewToggle("Spin Karakter 🌀", "Berputar sangat cepat", function(state)
    spinning = state
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if spinning and hrp then
        local spinVelocity = Instance.new("BodyAngularVelocity")
        spinVelocity.Name = "SpinVelocity"
        spinVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
        spinVelocity.AngularVelocity = Vector3.new(0, 50, 0)
        spinVelocity.Parent = hrp
    else
        if hrp and hrp:FindFirstChild("SpinVelocity") then
            hrp.SpinVelocity:Destroy()
        end
    end
end)

-- Troll 2: Kepala Raksasa 🗣️
local bigHead = false
Section3:NewToggle("Kepala Raksasa 🗣️", "Memperbesar ukuran kepala", function(state)
    bigHead = state
    local head = game.Players.LocalPlayer.Character:FindFirstChild("Head")
    if head then
        if bigHead then
            head.Size = Vector3.new(5, 5, 5)
        else
            head.Size = Vector3.new(2, 1, 1)
        end
    end
end)

-- Troll 3: Lompatan Super 🐇
Section3:NewToggle("Lompatan Super 🐇", "Melompat sangat tinggi", function(state)
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if state then
            humanoid.JumpPower = 150
        else
            humanoid.JumpPower = 50
        end
    end
end)

-- Troll 4: Mode Hantu 👻
local ghostMode = false
Section3:NewToggle("Mode Hantu 👻", "Menjadi kasat mata", function(state)
    ghostMode = state
    local char = game.Players.LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = ghostMode and 0.8 or 0
            end
        end
    end
end)

-- Troll 5: Gravitasi Rendah 🌌
Section3:NewToggle("Gravitasi Bulan 🌌", "Membuat efek melayang", function(state)
    if state then
        workspace.Gravity = 20
    else
        workspace.Gravity = 196.2
    end
end)
