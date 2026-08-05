local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local MAX_RADIUS = 50 -- 📏 Jarak radius maksimal (dalam satuan Studs)

-- Fungsi untuk memperbarui efek ESP pada semua pemain
local function updateESP()
    local myCharacter = localPlayer.Character
    if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then return end
    
    local myPos = myCharacter.HumanoidRootPart.Position

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        -- Memastikan tidak memeriksa diri sendiri
        if targetPlayer ~= localPlayer and targetPlayer.Character then
            local targetChar = targetPlayer.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            
            if targetRoot then
                -- 📐 Menghitung jarak lurus antara posisi kita dan pemain lain
                local distance = (myPos - targetRoot.Position).Magnitude
                
                local highlight = targetChar:FindFirstChild("ESPHighlight")
                
                -- Memeriksa apakah pemain berada di dalam radius
                if distance <= MAX_RADIUS then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Warna merah 🔴
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Warna putih ⚪
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = targetChar
                    end
                else
                    -- Jika berada di luar radius, hapus efek highlight
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end
end

-- 🔄 Menjalankan fungsi pemeriksaan secara terus-menerus setiap frame
RunService.RenderStepped:Connect(updateESP)
