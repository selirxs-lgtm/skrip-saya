-- 1. Mengunggah Library UI Orion 🖼️
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Menu Teleport 🚀", HidePremium = false, SaveConfig = false})

-- 2. Membuat Tab Utama 📁
local Tab = Window:MakeTab({
    Name = "Teleport Player 📍",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Fungsi untuk mengambil semua nama pemain di server (kecuali diri sendiri) 📋
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

-- 3. Memasukkan Dropdown Pilihan Pemain 👥
local PlayerDropdown = Tab:AddDropdown({
    Name = "Pilih Pemain Target",
    Default = "",
    Options = getPlayerNames(),
    Callback = function(Value)
        selectedPlayer = Value
    end    
})

-- 4. Tombol Memperbarui Daftar Pemain (Refresh) 🔄
Tab:AddButton({
    Name = "Perbarui Daftar Pemain",
    Callback = function()
        PlayerDropdown:Refresh(getPlayerNames(), true)
        OrionLib:MakeNotification({
            Name = "Info ℹ️",
            Content = "Daftar pemain berhasil diperbarui!",
            Time = 2
        })
    end
})

-- 5. Tombol Eksekusi Teleport ⚡
Tab:AddButton({
    Name = "Teleport Ke Player Target",
    Callback = function()
        if selectedPlayer == "" then
            OrionLib:MakeNotification({
                Name = "Peringatan ⚠️",
                Content = "Silakan pilih nama pemain terlebih dahulu!",
                Time = 3
            })
            return
        end

        local targetPlayer = game.Players:FindFirstChild(selectedPlayer)
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Memindahkan posisi karakter ke target
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            
            OrionLib:MakeNotification({
                Name = "Berhasil 🎉",
                Content = "Berhasil teleport ke " .. targetPlayer.Name,
                Time = 3
            })
        else
            OrionLib:MakeNotification({
                Name = "Gagal ❌",
                Content = "Pemain tidak ditemukan atau karakternya belum memuat.",
                Time = 3
            })
        end
    end    
})

OrionLib:Init()
