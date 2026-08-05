-- 1. Memuat Library Kavo UI 🖼️
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rafael Xiter 🚀", "Midnight")

local mainFrame = nil

-- Mencari Frame Utama untuk Pengaturan UI & Draggable 🔀
task.spawn(function()
    local coreGui = game:GetService("CoreGui")
    for _, gui in pairs(coreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
            mainFrame = gui.Main
            mainFrame.Active = true
            mainFrame.Draggable = true
        end
    end
end)

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
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

-- Kontrol Buka/Tutup UI Menggunakan Properti Visible 👁️
ToggleButton.MouseButton1Click:Connect(function()
    if mainFrame then
        mainFrame.Visible = not mainFrame.Visible
    else
        local coreGui = game:GetService("CoreGui")
        for _, gui in pairs(coreGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
                mainFrame = gui.Main
                mainFrame.Visible = not mainFrame.Visible
            end
        end
    end
end)

-- Fungsi Memuat Nama Pemain 👥
local function getPlayerNames()
    local playerList = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    return playerList
end

-- 3. Tab Teleport Player 📁
local Tab1 = Window:NewTab("Teleport 📍")
local Section1 = Tab1:NewSection("Pilih Player / Auto")

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

Section1:NewSlider("Radius Teleport Terdekat", "Batas jarak pemain", 500, 10, function(value)
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

-- 5. Tab Fitur Troll Player & Mobil (Target Spesifik & Radius) 🎭
local Tab3 = Window:NewTab("Troll 🎭")
local Section3 = Tab3:NewSection("Pengaturan Target Troll")

local trollTarget = ""

local trollDropdown = Section3:NewDropdown("Pilih Target Spesifik", "Pilih pemain target", getPlayerNames(), function(option)
    trollTarget = option
end)

Section3:NewButton("Refresh Target", "Update daftar nama", function()
    trollDropdown:Refresh(getPlayerNames())
end)

Section3:NewButton("Blink Ke Target ⚡", "Teleport instan ke belakang target", function()
    if trollTarget ~= "" then
        local target = game.Players:FindFirstChild(trollTarget)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = target.Character.HumanoidRootPart
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

local SectionTarget = Tab3:NewSection("Troll Pemain Terpilih")

local spinSelectedPlayer = false
SectionTarget:NewToggle("Spin Player Terpilih 🌀", "Memutar target dari dropdown", function(state)
    spinSelectedPlayer = state
    task.spawn(function()
        while spinSelectedPlayer do
            if trollTarget ~= "" then
                local target = game.Players:FindFirstChild(trollTarget)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = target.Character.HumanoidRootPart
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
                end
            end
            task.wait(0.05)
        end
    end)
end)

local spinSelectedCar = false
SectionTarget:NewToggle("Spin Mobil Player Terpilih 🏎️", "Memutar mobil target dari dropdown", function(state)
    spinSelectedCar = state
    task.spawn(function()
        while spinSelectedCar do
            if trollTarget ~= "" then
                local target = game.Players:FindFirstChild(trollTarget)
                if target and target.Character then
                    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
                        local carPart = humanoid.SeatPart
                        carPart.CFrame = carPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

local SectionRadius = Tab3:NewSection("Troll Radius Area (Otomatis)")

local spinRadiusValue = 50

SectionRadius:NewSlider("Radius Area Troll 📏", "Jarak jangkauan area", 200, 10, function(value)
    spinRadiusValue = value
end)

local spinAllInRadius = false
SectionRadius:NewToggle("Auto Spin Pemain dalam Radius 🌀", "Memutar semua pemain di sekitar", function(state)
    spinAllInRadius = state
    task.spawn(function()
        while spinAllInRadius do
            local localPlayer = game.Players.LocalPlayer
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myPos = localPlayer.Character.HumanoidRootPart.Position
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = player.Character.HumanoidRootPart
                        if (myPos - targetHRP.Position).Magnitude <= spinRadiusValue then
                            targetHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.rad(45), 0)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

local spinCarsInRadius = false
SectionRadius:NewToggle("Auto Spin Mobil dalam Radius 🏎️", "Memutar semua mobil di sekitar", function(state)
    spinCarsInRadius = state
    task.spawn(function()
        while spinCarsInRadius do
            local localPlayer = game.Players.LocalPlayer
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myPos = localPlayer.Character.HumanoidRootPart.Position
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
                            local carPart = humanoid.SeatPart
                            if (myPos - carPart.Position).Magnitude <= spinRadiusValue then
                                carPart.CFrame = carPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

-- 6. Tab Setting UI (Tema Warna & Transparansi) ⚙️
local Tab4 = Window:NewTab("Setting ⚙️")
local SectionSetting = Tab4:NewSection("Kustomisasi Layar UI")

-- Transparansi Background 🪟
SectionSetting:NewSlider("Transparansi UI 🪟", "Atur tingkat transparan layar (0-100%)", 100, 0, function(value)
    if mainFrame then
        mainFrame.BackgroundTransparency = value / 100
    end
end)

-- Pilihan Warna Tema 🎨
SectionSetting:NewButton("Tema Hitam 🖤", "Mengubah background ke warna hitam", function()
    if mainFrame then
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end
end)

SectionSetting:NewButton("Tema Putih 🤍", "Mengubah background ke warna putih", function()
    if mainFrame then
        mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    end
end)

local rgbEnabled = false
SectionSetting:NewToggle("Tema Pelangi RGB 🌈", "Animasi warna pelangi berputar", function(state)
    rgbEnabled = state
    task.spawn(function()
        while rgbEnabled do
            if mainFrame then
                local hue = (tick() % 5) / 5
                mainFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.8)
            end
            task.wait(0.03)
        end
    end)
end)
