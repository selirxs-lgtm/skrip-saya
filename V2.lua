-- ==========================================
-- RAFAEL XITER 🚀 - FULL TROLL 5 TABS (50 FITUR)
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("RafaelXiterUI") then
    CoreGui.RafaelXiterUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RafaelXiterUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Tombol Bulat Mengambang
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.Position = UDim2.new(0, 15, 0.35, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "🚀"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 26
ToggleButton.Active = true
ToggleButton.Draggable = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.Size = UDim2.new(1, 0, 0, 35)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Size = UDim2.new(1, -24, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Rafael Xiter 🚀 [5 TROLL TABS]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.Size = UDim2.new(1, 0, 0, 30)

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 0, 0, 65)
ContentContainer.Size = UDim2.new(1, 0, 1, -65)

local tabs = {}

local function createTab(name, index)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabBar
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.Size = UDim2.new(0.2, -1, 1, 0)
    tabBtn.Position = UDim2.new(0.2 * (index - 1), 0, 0, 0)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.TextSize = 8

    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = ContentContainer
    scroll.BackgroundTransparency = 1
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Visible = false
    scroll.CanvasSize = UDim2.new(0, 0, 0, 480)
    scroll.ScrollBarThickness = 4

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scroll
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Scroll.Visible = false
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        scroll.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    table.insert(tabs, {Button = tabBtn, Scroll = scroll})

    if index == 1 then
        scroll.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    return scroll
end

local function addButton(parentScroll, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.Position = UDim2.new(0.04, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Parent = parentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- Membuat 5 Tab Troll
local t1 = createTab("Troll 1", 1)
local t2 = createTab("Troll 2", 2)
local t3 = createTab("Troll 3", 3)
local t4 = createTab("Troll 4", 4)
local t5 = createTab("Troll 5", 5)

-- ================= TAB 1 (10 FITUR) =================
addButton(t1, "1. Kirim Semua ke Bawah Map 🕳️", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame - Vector3.new(0, 400, 0)
        end
    end
end)
addButton(t1, "2. Lempar Semua ke Langit ☁️", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 500, 0)
        end
    end
end)
addButton(t1, "3. Bunuh Semua Player Lain 💥", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then p.Character:BreakJoints() end
    end
end)
addButton(t1, "4. Paksa Semua Karakter Duduk 🪑", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid.Sit = true
        end
    end
end)
addButton(t1, "5. Beri Kecepatan Lari 500 ke Semua ⚡", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid.WalkSpeed = 500
        end
    end
end)
addButton(t1, "6. Lumpuhkan Semua (Speed 0) 🛑", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid.WalkSpeed = 0
        end
    end
end)
addButton(t1, "7. Bikin Semua Lompat Tinggi (Jump 200) 🦘", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid.JumpPower = 200
        end
    end
end)
addButton(t1, "8. Bikin Semua Raksasa (Scale 3x) 🦍", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, scale in pairs(hum:GetChildren()) do
                    if scale:IsA("NumberValue") then scale.Value = 3 end
                end
            end
        end
    end
end)
addButton(t1, "9. Bikin Semua Jadi Kerdil (Scale 0.5) 🐜", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, scale in pairs(hum:GetChildren()) do
                    if scale:IsA("NumberValue") then scale.Value = 0.5 end
                end
            end
        end
    end
end)
addButton(t1, "10. Hapus Tool/Item di Tangan Semua 🧹", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _, v in pairs(p.Character:GetChildren()) do
                if v:IsA("Tool") then v:Destroy() end
            end
        end
    end
end)

-- ================= TAB 2 (10 FITUR) =================
addButton(t2, "1. Spam Reset Semua Player 💀", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
end)
addButton(t2, "2. Set Health Semua Jadi 1 🩸", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid.Health = 1
        end
    end
end)
addButton(t2, "3. Putar-putar Badan Semua (Spin) 🌀", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local bg = Instance.new("BodyGyros", p.Character.HumanoidRootPart)
            bg.MaxTorque = Vector3.new(0, math.huge, 0)
            bg.CFrame = bg.CFrame * CFrame.Angles(0, math.rad(9999), 0)
        end
    end
end)
addButton(t2, "4. Tarik Semua Player ke Posisiku 🧲", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.CFrame
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = pos + Vector3.new(3, 0, 3)
            end
        end
    end
end)
addButton(t2, "5. Buat Semua Player Melayang 🎈", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.Velocity = Vector3.new(0, 150, 0)
        end
    end
end)
addButton(t2, "6. Bikin Layar Semua Gelap Gulita 🕶️", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p.PlayerGui then
            local gui = Instance.new("ScreenGui", p.PlayerGui)
            local f = Instance.new("Frame", gui)
            f.Size = UDim2.new(1,0,1,0)
            f.BackgroundColor3 = Color3.new(0,0,0)
        end
    end
end)
addButton(t2, "7. Matikan Animasi Semua Player 🧊", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            for _, anim in pairs(p.Character.Humanoid:GetPlayingAnimationTracks()) do
                anim:Stop()
            end
        end
    end
end)
addButton(t2, "8. Buat Semua Berdarah/Kena Damage 💢", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid:TakeDamage(50)
        end
    end
end)
addButton(t2, "9. Beri Efek Terbakar (Mock Fire) 🔥", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Torso") then
            Instance.new("Fire", p.Character.Torso)
        end
    end
end)
addButton(t2, "10. Beri Efek Sparkle ke Semua ✨", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Torso") then
            Instance.new("Sparkles", p.Character.Torso)
        end
    end
end)

-- ================= TAB 3 (10 FITUR) =================
addButton(t3, "1. Acak Posisi Teleport Semua Player 🎲", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-500, 500), 50, math.random(-500, 500))
        end
    end
end)
addButton(t3, "2. Paksa Semua Player Lompat (Jump) 🦘", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character.Humanoid.Jump = true
        end
    end
end)
addButton(t3, "3. Bikin Semua Jadi Transparan (Ghost) 👻", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _, part in pairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 0.8 end
            end
        end
    end
end)
addButton(t3, "4. Kembalikan Transparansi Normal 👤", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _, part in pairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Transparency = 0 end
            end
        end
    end
end)
addButton(t3, "5. Beri Efek Asap ke Semua Player 💨", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Torso") then
            Instance.new("Smoke", p.Character.Torso)
        end
    end
end)
addButton(t3, "6. Hapus Aksesoris Kepala Semua 🧢", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            for _, v in pairs(p.Character:GetChildren()) do
                if v:IsA("Accessory") then v:Destroy() end
            end
        end
    end
end)
addButton(t3, "7. Ubah Warna Kepala Semua Jadi Merah 🔴", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            p.Character.Head.Color = Color3.fromRGB(255, 0, 0)
        end
    end
end)
addButton(t3, "8. Ubah Warna Kepala Semua Jadi Hijau 🟢", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            p.Character.Head.Color = Color3.fromRGB(0, 255, 0)
        end
    end
end)
addButton(t3, "9. Ubah Warna Kepala Semua Jadi Biru 🔵", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            p.Character.Head.Color = Color3.fromRGB(0, 0, 255)
        end
    end
end)
addButton(t3, "10. Reset Warna Kepala Jadi Normal 🎨", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            p.Character.Head.Color = Color3.fromRGB(248, 217, 184)
        end
    end
end)

-- ================= TAB 4 (10 FITUR) =================
addButton(t4, "1. Set Waktu Dunia Jadi Malam Pekat 🌙", function()
    Lighting.ClockTime = 0
end)
addButton(t4, "2. Set Waktu Dunia Jadi Siang Bolong ☀️", function()
    Lighting.ClockTime = 12
end)
addButton(t4, "3. Buat Grafik Dunia Jadi Kuning/Sepia 🏜️", function()
    local cc = Lighting:FindFirstChild("SepiaCC") or Instance.new("ColorCorrectionEffect", Lighting)
    cc.Name = "SepiaCC"
    cc.TintColor = Color3.fromRGB(255, 220, 150)
end)
addButton(t4, "4. Buat Grafik Dunia Jadi Hitam Putih 📺", function()
    local cc = Lighting:FindFirstChild("BWC") or Instance.new("ColorCorrectionEffect", Lighting)
    cc.Name = "BWC"
    cc.Saturation = -1
end)
addButton(t4, "5. Normalkan Efek Grafik Dunia ✨", function()
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") then v:Destroy() end
    end
end)
addButton(t4, "6. Beri Kabut Tebal Putih ke Map 🌫️", function()
    Lighting.FogEnd = 150
    Lighting.FogColor = Color3.fromRGB(255, 255, 255)
end)
addButton(t4, "7. Beri Kabut Tebal Merah Darah 🩸", function()
    Lighting.FogEnd = 150
    Lighting.FogColor = Color3.fromRGB(255, 0, 0)
end)
addButton(t4, "8. Hapus Total Kabut Map 🌤️", function()
    Lighting.FogEnd = 999999
end)
addButton(t4, "9. Bikin Petir Sambar Terus (Brightness Max) ⚡", function()
    Lighting.Brightness = 10
    task.wait(0.5)
    Lighting.Brightness = 1
end)
addButton(t4, "10. Matikan Semua Bayangan Dunia 🌑", function()
    Lighting.GlobalShadows = false
end)

-- ================= TAB 5 (10 FITUR) =================
addButton(t5, "1. Buat Karakterku Kebal (Godmode) 🛡️", function()
    task.spawn(function()
        while true do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
            task.wait(0.2)
        end
    end)
end)
addButton(t5, "2. Super Speed Pribadi (WalkSpeed 120) ⚡", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 120
    end
end)
addButton(t5, "3. Lompat Super Tinggi (JumpPower 150) 🦘", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 150
    end
end)
addButton(t5, "4. Reset Kecepatan Normal Pribadi 🚶", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)
addButton(t5, "5. Teleport ke Spawn Asli Map 📍", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    end
end)
addButton(t5, "6. Sembunyikan Nama Sendiri 🙈", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        for _, v in pairs(LocalPlayer.Character.Head:GetChildren()) do
            if v:IsA("BillboardGui") then v.Enabled = false end
        end
    end
end)
addButton(t5, "7. Bunuh Diri Instan (Reset) 💀", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)
addButton(t5, "8. FullBright Pribadi (Anti Gelap) ☀️", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
end)
addButton(t5, "9. Salin Posisi Player Lain Terdekat (Target) 🎯", function()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                target = p.Character.HumanoidRootPart
            end
        end
    end
    if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(2, 0, 2)
    end
end)
addButton(t5, "10. Hancurkan / Tutup GUI Ini ❌", function()
    if CoreGui:FindFirstChild("RafaelXiterUI") then
        CoreGui.RafaelXiterUI:Destroy()
    end
end)
