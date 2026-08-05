-- 1. Mengunggah Library Kavo UI 🖼️
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Menu Teleport Player 🚀", "Midnight")

-- 2. Membuat Tombol Bulat Melayang (Toggle Button) untuk HP 🔘
local ToggleScreen = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ToggleScreen.Name = "TeleportToggleUI"
ToggleScreen.Parent = game.CoreGui
ToggleScreen.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToggleScreen
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0, 10, 0.4, 0) -- Posisi di pinggir kiri layar
ToggleButton.Size = UDim2.new(0, 50, 0, 50) -- Ukuran tombol bulat (50x50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "🚀"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 25.000
ToggleButton.Active = true
ToggleButton.Draggable = true -- Bisa digeser/didrag di layar HP 📱

-- Membuat bentuk tombol menjadi bulat sempurna
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

-- Fungsi saat tombol bulat ditekan: Buka / Tutup UI
ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleUI()
end)

-- 3. Membuat Tab Utama 📁
local Tab = Window:NewTab("Teleport 📍")
local Section = Tab:NewSection("Pilih Player")

-- Fungsi mengambil daftar pemain 👥
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

-- 4. Menu Dropdown Pemain 📜
local dropdown = Section:NewDropdown("Pilih Pemain Target", "Klik untuk memilih", getPlayerNames(), function(option)
    selectedPlayer = option
end)

-- 5. Tombol Refresh Daftar Pemain 🔄
Section:NewButton("Refresh Daftar Pemain", "Memperbarui daftar nama", function()
    dropdown:Refresh(getPlayerNames())
end)

-- 6. Tombol Teleport ⚡
Section:NewButton("Teleport Sekarang!", "Pindah ke lokasi pemain", function()
    if selectedPlayer ~= "" then
        local targetPlayer = game.Players:FindFirstChild(selectedPlayer)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)
