-- 1. Mengunggah Library UI yang Ringan 🖼️
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Menu Teleport Player 🚀", "Midnight")

-- 2. Membuat Tab Utama 📁
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

-- 3. Menu Dropdown Pemain 📜
local dropdown = Section:NewDropdown("Pilih Pemain Target", "Klik untuk memilih", getPlayerNames(), function(option)
    selectedPlayer = option
end)

-- 4. Tombol Refresh Daftar Pemain 🔄
Section:NewButton("Refresh Daftar Pemain", "Memperbarui daftar nama", function()
    dropdown:Refresh(getPlayerNames())
end)

-- 5. Tombol Teleport ⚡
Section:NewButton("Teleport Sekarang!", "Pindah ke lokasi pemain", function()
    if selectedPlayer ~= "" then
        local targetPlayer = game.Players:FindFirstChild(selectedPlayer)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)
