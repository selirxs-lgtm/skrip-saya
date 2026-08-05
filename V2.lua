-- ==========================================
-- RAFAEL XITER 🚀 - 10 TABS + DROPDOWN TARGET SELECTOR
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
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -185)
MainFrame.Size = UDim2.new(0, 400, 0, 370)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false -- Biar dropdown list bisa keluar kotak kalau dibuka

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
TitleLabel.Text = "Rafael Xiter 🚀 [DROPDOWN SELECTOR]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ================= DROPDOWN SELECTOR PLAYER =================
local SelectedTarget = nil

local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Parent = MainFrame
DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DropdownBtn.Position = UDim2.new(0.04, 0, 0, 42)
DropdownBtn.Size = UDim2.new(0.92, 0, 0, 30)
DropdownBtn.Font = Enum.Font.SourceSansBold
DropdownBtn.Text = "🎯 Pilih Target: [Klik untuk Buka List]"
DropdownBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
DropdownBtn.TextSize = 11

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 5)
DropdownCorner.Parent = DropdownBtn

-- Container List Player (Dropdown Menu)
local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Parent = MainFrame
DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownList.Position = UDim2.new(0.04, 0, 0, 75)
DropdownList.Size = UDim2.new(0.92, 0, 0, 100)
DropdownList.Visible = false
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ScrollBarThickness = 4
DropdownList.ZIndex = 5

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = DropdownList
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 3)

local function refreshPlayerList()
    -- Hapus list lama
    for _, v in pairs(DropdownList:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local pBtn = Instance.new("TextButton")
            pBtn.Parent = DropdownList
            pBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            pBtn.Size = UDim2.new(1, 0, 0, 25)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.Text = "👤 " .. p.Name .. " (" .. p.DisplayName .. ")"
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.TextSize = 11
            pBtn.ZIndex = 6

            pBtn.MouseButton1Click:Connect(function()
                SelectedTarget = p
                DropdownBtn.Text = "🎯 Target Aktif: " .. p.Name
                DropdownList.Visible = false
            end)
        end
    end
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, count * 28)
end

DropdownBtn.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then
        refreshPlayerList()
    end
end)

Players.PlayerAdded:Connect(function() if DropdownList.Visible then refreshPlayerList() end end)
Players.PlayerRemoving:Connect(function(p) 
    if SelectedTarget == p then 
        SelectedTarget = nil 
        DropdownBtn.Text = "🎯 Target Keluar! Pilih Lagi" 
    end 
    if DropdownList.Visible then refreshPlayerList() end 
end)

local function getTargetPlayer()
    return SelectedTarget and SelectedTarget.Character and SelectedTarget.Character:FindFirstChild("HumanoidRootPart") and SelectedTarget
end

-- ================= TAB BAR & KONTEN =================
local TabBar = Instance.new("ScrollingFrame")
TabBar.Parent = MainFrame
TabBar.BackgroundTransparency = 1
TabBar.Position = UDim2.new(0, 0, 0, 80) -- Digeser sedikit ke bawah karena dropdown di atas
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.CanvasSize = UDim2.new(0, 550, 0, 0)
TabBar.ScrollBarThickness = 0

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 0, 0, 115)
ContentContainer.Size = UDim2.new(1, 0, 1, -115)

local tabs = {}

local function createTab(name, index)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabBar
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.Size = UDim2.new(0, 50, 1, 0)
    tabBtn.Position = UDim2.new(0, 52 * (index - 1), 0, 0)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.TextSize = 9

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
    btn.Size = UDim2.new(0.92, 0, 0, 30)
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

-- Membuat 10 Tab
local t1 = createTab("All 1", 1)
local t2 = createTab("All 2", 2)
local t3 = createTab("All 3", 3)
local t4 = createTab("All 4", 4)
local t5 = createTab("All 5", 5)
local t6 = createTab("Targ 1", 6)
local t7 = createTab("Targ 2", 7)
local t8 = createTab("Targ 3", 8)
local t9 = createTab("Targ 4", 9)
local t10 = createTab("Targ 5", 10)

-- ================= TAB 1: ALL (1-10) =================
addButton(t1, "1. Kirim Semua ke Bawah Map 🕳️", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame - Vector3.new(0, 400, 0) end end
end)
addButton(t1, "2. Lempar Semua ke Langit ☁️", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 500, 0) end end
end)
addButton(t1, "3. Bunuh Semua Player Lain 💥", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then p.Character:BreakJoints() end end
end)
addButton(t1, "4. Paksa Semua Karakter Duduk 🪑", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid.Sit = true end end
end)
addButton(t1, "5. Beri Kecepatan Lari 500 ke Semua ⚡", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid.WalkSpeed = 500 end end
end)
addButton(t1, "6. Lumpuhkan Semua (Speed 0) 🛑", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid.WalkSpeed = 0 end end
end)
addButton(t1, "7. Bikin Semua Lompat Tinggi (Jump 200) 🦘", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid.JumpPower = 200 end end
end)
addButton(t1, "8. Bikin Semua Raksasa (Scale 3x) 🦍", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then local h = p.Character:FindFirstChildOfClass("Humanoid") if h then for _,s in pairs(h:GetChildren()) do if s:IsA("NumberValue") then s.Value = 3 end end end end end
end)
addButton(t1, "9. Bikin Semua Jadi Kerdil (Scale 0.5) 🐜", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then local h = p.Character:FindFirstChildOfClass("Humanoid") if h then for _,s in pairs(h:GetChildren()) do if s:IsA("NumberValue") then s.Value = 0.5 end end end end end
end)
addButton(t1, "10. Hapus Tool/Item di Tangan Semua 🧹", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _,v in pairs(p.Character:GetChildren()) do if v:IsA("Tool") then v:Destroy() end end end end
end)

-- ================= TAB 2: ALL (11-20) =================
addButton(t2, "1. Spam Reset Semua Player 💀", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid.Health = 0 end end
end)
addButton(t2, "2. Set Health Semua Jadi 1 🩸", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid.Health = 1 end end
end)
addButton(t2, "3. Putar-putar Badan Semua (Spin) 🌀", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local bg = Instance.new("BodyGyros", p.Character.HumanoidRootPart) bg.MaxTorque = Vector3.new(0, math.huge, 0) end end
end)
addButton(t2, "4. Tarik Semua Player ke Posisiku 🧲", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then local pos = LocalPlayer.Character.HumanoidRootPart.CFrame for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = pos + Vector3.new(3,0,3) end end end
end)
addButton(t2, "5. Buat Semua Player Melayang 🎈", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Velocity = Vector3.new(0, 150, 0) end end
end)
addButton(t2, "6. Bikin Layar Semua Gelap Gulita 🕶️", function()
    for _, p in pairs(Players:GetPlayers()) do if p.PlayerGui then local g = Instance.new("ScreenGui", p.PlayerGui) local f = Instance.new("Frame", g) f.Size = UDim2.new(1,0,1,0) f.BackgroundColor3 = Color3.new(0,0,0) end end
end)
addButton(t2, "7. Matikan Animasi Semua Player 🧊", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then for _,a in pairs(p.Character.Humanoid:GetPlayingAnimationTracks()) do a:Stop() end end end
end)
addButton(t2, "8. Buat Semua Berdarah/Damage 50 💢", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid:TakeDamage(50) end end
end)
addButton(t2, "9. Beri Efek Terbakar ke Semua 🔥", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Torso") then Instance.new("Fire", p.Character.Torso) end end
end)
addButton(t2, "10. Beri Efek Sparkle ke Semua ✨", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Torso") then Instance.new("Sparkles", p.Character.Torso) end end
end)

-- ================= TAB 3: ALL (21-30) =================
addButton(t3, "1. Acak Posisi Teleport Semua Player 🎲", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-300,300), 50, math.random(-300,300)) end end
end)
addButton(t3, "2. Paksa Semua Player Lompat 🦘", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then p.Character.Humanoid.Jump = true end end
end)
addButton(t3, "3. Bikin Semua Transparan (Ghost) 👻", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _,part in pairs(p.Character:GetDescendants()) do if part:IsA("BasePart") then part.Transparency = 0.8 end end end end
end)
addButton(t3, "4. Kembalikan Transparansi Normal 👤", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _,part in pairs(p.Character:GetDescendants()) do if part:IsA("BasePart") then part.Transparency = 0 end end end end
end)
addButton(t3, "5. Beri Efek Asap ke Semua 💨", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Torso") then Instance.new("Smoke", p.Character.Torso) end end
end)
addButton(t3, "6. Hapus Aksesoris Kepala Semua 🧢", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _,v in pairs(p.Character:GetChildren()) do if v:IsA("Accessory") then v:Destroy() end end end end
end)
addButton(t3, "7. Ubah Kepala Semua Jadi Merah 🔴", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then p.Character.Head.Color = Color3.fromRGB(255,0,0) end end
end)
addButton(t3, "8. Ubah Kepala Semua Jadi Hijau 🟢", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then p.Character.Head.Color = Color3.fromRGB(0,255,0) end end
end)
addButton(t3, "9. Ubah Kepala Semua Jadi Biru 🔵", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then p.Character.Head.Color = Color3.fromRGB(0,0,255) end end
end)
addButton(t3, "10. Reset Warna Kepala Semua 🎨", function()
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then p.Character.Head.Color = Color3.fromRGB(248,217,184) end end
end)

-- ================= TAB 4: ALL (31-40) =================
addButton(t4, "1. Set Waktu Dunia Jadi Malam 🌙", function() Lighting.ClockTime = 0 end)
addButton(t4, "2. Set Waktu Dunia Jadi Siang ☀️", function() Lighting.ClockTime = 12 end)
addButton(t4, "3. Buat Grafik Dunia Jadi Sepia 🏜️", function() local cc = Instance.new("ColorCorrectionEffect", Lighting) cc.TintColor = Color3.fromRGB(255,220,150) end)
addButton(t4, "4. Buat Grafik Dunia Hitam Putih 📺", function() local cc = Instance.new("ColorCorrectionEffect", Lighting) cc.Saturation = -1 end)
addButton(t4, "5. Normalkan Efek Grafik Dunia ✨", function() for _,v in pairs(Lighting:GetChildren()) do if v:IsA("ColorCorrectionEffect") then v:Destroy() end end end)
addButton(t4, "6. Kabut Tebal Putih ke Map 🌫️", function() Lighting.FogEnd = 150 Lighting.FogColor = Color3.fromRGB(255,255,255) end)
addButton(t4, "7. Kabut Tebal Merah Darah 🩸", function() Lighting.FogEnd = 150 Lighting.FogColor = Color3.fromRGB(255,0,0) end)
addButton(t4, "8. Hapus Total Kabut Map 🌤️", function() Lighting.FogEnd = 999999 end)
addButton(t4, "9. Bikin Petir Sambar Terus ⚡", function() Lighting.Brightness = 10 task.wait(0.3) Lighting.Brightness = 1 end)
addButton(t4, "10. Matikan Bayangan Dunia 🌑", function() Lighting.GlobalShadows = false end)

-- ================= TAB 5: ALL (41-50) =================
addButton(t5, "1. Godmode Pribadi 🛡️", function() task.spawn(function() while true do if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth end task.wait(0.2) end end) end)
addButton(t5, "2. Super Speed Pribadi (120) ⚡", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 120 end end)
addButton(t5, "3. Lompat Tinggi Pribadi (150) 🦘", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 150 end end)
addButton(t5, "4. Reset Kecepatan Normal Pribadi 🚶", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 16 LocalPlayer.Character.Humanoid.JumpPower = 50 end end)
addButton(t5, "5. Teleport ke Spawn Asli 📍", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,10,0) end end)
addButton(t5, "6. Sembunyikan Nama Sendiri 🙈", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then for _,v in pairs(LocalPlayer.Character.Head:GetChildren()) do if v:IsA("BillboardGui") then v.Enabled = false end end end end)
addButton(t5, "7. Bunuh Diri Instan (Reset) 💀", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.Health = 0 end end)
addButton(t5, "8. FullBright Pribadi ☀️", function() Lighting.Brightness = 2 Lighting.ClockTime = 14 end)
addButton(t5, "9. Salin Posisi Player Terdekat 🎯", function() local t = nil local d = math.huge for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then local dist = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude if dist < d then d = dist t = p.Character.HumanoidRootPart end end end if t and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = t.CFrame + Vector3.new(2,0,2) end end)
addButton(t5, "10. Hancurkan GUI Ini ❌", function() if CoreGui:FindFirstChild("RafaelXiterUI") then CoreGui.RafaelXiterUI:Destroy() end end)


-- ==========================================
-- TAB 6-10: TARGET SELECTOR TROLL
-- ==========================================

-- ================= TAB 6: TARGET 1 (1-10) =================
addButton(t6, "1. Kirim Target ke Bawah Map 🕳️", function() local t = getTargetPlayer() if t then t.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame - Vector3.new(0, 400, 0) end end)
addButton(t6, "2. Lempar Target ke Langit ☁️", function() local t = getTargetPlayer() if t then t.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame + Vector3.new(0, 500, 0) end end)
addButton(t6, "3. Bunuh Target Saja 💥", function() local t = getTargetPlayer() if t and t.Character then t.Character:BreakJoints() end end)
addButton(t6, "4. Paksa Target Duduk 🪑", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.Sit = true end end)
addButton(t6, "5. Bikin Target Super Cepat (500) ⚡", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.WalkSpeed = 500 end end)
addButton(t6, "6. Lumpuhkan Target (Speed 0) 🛑", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.WalkSpeed = 0 end end)
addButton(t6, "7. Bikin Target Lompat Tinggi (200) 🦘", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.JumpPower = 200 end end)
addButton(t6, "8. Bikin Target Jadi Raksasa (3x) 🦍", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Humanoid") then local h = t.Character:FindFirstChildOfClass("Humanoid") if h then for _,s in pairs(h:GetChildren()) do if s:IsA("NumberValue") then s.Value = 3 end end end end end)
addButton(t6, "9. Bikin Target Jadi Kerdil (0.5) 🐜", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Humanoid") then local h = t.Character:FindFirstChildOfClass("Humanoid") if h then for _,s in pairs(h:GetChildren()) do if s:IsA("NumberValue") then s.Value = 0.5 end end end end end)
addButton(t6, "10. Hapus Tool di Tangan Target 🧹", function() local t = getTargetPlayer() if t and t.Character then for _,v in pairs(t.Character:GetChildren()) do if v:IsA("Tool") then v:Destroy() end end end end)

-- ================= TAB 7: TARGET 2 (11-20) =================
addButton(t7, "1. Spam Reset Target 💀", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.Health = 0 end end)
addButton(t7, "2. Set Health Target Jadi 1 🩸", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.Health = 1 end end)
addButton(t7, "3. Putar-putar Badan Target 🌀", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then Instance.new("BodyGyros", t.Character.HumanoidRootPart) end end)
addButton(t7, "4. Tarik Target ke Posisiku 🧲", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then t.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(3,0,3) end end)
addButton(t7, "5. Buat Target Melayang 🎈", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then t.Character.HumanoidRootPart.Velocity = Vector3.new(0, 150, 0) end end)
addButton(t7, "6. Gelapkan Layar Target Saja 🕶️", function() local t = getTargetPlayer() if t and t.PlayerGui then local g = Instance.new("ScreenGui", t.PlayerGui) local f = Instance.new("Frame", g) f.Size = UDim2.new(1,0,1,0) f.BackgroundColor3 = Color3.new(0,0,0) end end)
addButton(t7, "7. Matikan Animasi Target 🧊", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then for _,a in pairs(t.Character.Humanoid:GetPlayingAnimationTracks()) do a:Stop() end end end)
addButton(t7, "8. Beri Damage 50 ke Target 💢", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid:TakeDamage(50) end end)
addButton(t7, "9. Beri Efek Api ke Target 🔥", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Torso") then Instance.new("Fire", t.Character.Torso) end end)
addButton(t7, "10. Beri Efek Sparkle ke Target ✨", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Torso") then Instance.new("Sparkles", t.Character.Torso) end end)

-- ================= TAB 8: TARGET 3 (21-30) =================
addButton(t8, "1. Teleport Target ke Tempat Acak 🎲", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then t.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-300,300), 50, math.random(-300,300)) end end)
addButton(t8, "2. Paksa Target Lompat 🦘", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.Jump = true end end)
addButton(t8, "3. Bikin Target Transparan (Ghost) 👻", function() local t = getTargetPlayer() if t and t.Character then for _,p in pairs(t.Character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 0.8 end end end end)
addButton(t8, "4. Kembalikan Transparansi Target 👤", function() local t = getTargetPlayer() if t and t.Character then for _,p in pairs(t.Character:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 0 end end end end)
addButton(t8, "5. Beri Efek Asap ke Target 💨", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Torso") then Instance.new("Smoke", t.Character.Torso) end end)
addButton(t8, "6. Hapus Aksesoris Kepala Target 🧢", function() local t = getTargetPlayer() if t and t.Character then for _,v in pairs(t.Character:GetChildren()) do if v:IsA("Accessory") then v:Destroy() end end end end)
addButton(t8, "7. Ubah Kepala Target Jadi Merah 🔴", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Head") then t.Character.Head.Color = Color3.fromRGB(255,0,0) end end)
addButton(t8, "8. Ubah Kepala Target Jadi Hijau 🟢", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Head") then t.Character.Head.Color = Color3.fromRGB(0,255,0) end end)
addButton(t8, "9. Ubah Kepala Target Jadi Biru 🔵", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Head") then t.Character.Head.Color = Color3.fromRGB(0,0,255) end end)
addButton(t8, "10. Reset Warna Kepala Target 🎨", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Head") then t.Character.Head.Color = Color3.fromRGB(248,217,184) end end)

-- ================= TAB 9: TARGET 4 (31-40) =================
addButton(t9, "1. Teleport Aku ke Depan Target 📍", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,3) end end)
addButton(t9, "2. Lihat Layar Target (Spectate) 👁️", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then workspace.CurrentCamera.CameraSubject = t.Character.Humanoid end end)
addButton(t9, "3. Berhenti Spectate Target 👀", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid end end)
addButton(t9, "4. Kunci Posisi Target (Freeze) 🧊", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then t.Character.HumanoidRootPart.Anchored = true end end)
addButton(t9, "5. Lepas Kunci Posisi Target (Unfreeze) 🔥", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then t.Character.HumanoidRootPart.Anchored = false end end)
addButton(t9, "6. Beri Efek Sparkle Ungu ke Target 🔮", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Torso") then local s = Instance.new("Sparkles", t.Character.Torso) s.SparkleColor = Color3.fromRGB(255,0,255) end end)
addButton(t9, "7. Putar Badan Target 360 Derajat 💫", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then t.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(180), 0) end end)
addButton(t9, "8. Beri Efek Api Ungu ke Target ☄️", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Torso") then local f = Instance.new("Fire", t.Character.Torso) f.Color = Color3.fromRGB(255,0,255) end end)
addButton(t9, "9. Hapus Semua Efek (Fire/Smoke) Target 🧽", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Torso") then for _,v in pairs(t.Character.Torso:GetChildren()) do if v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then v:Destroy() end end end end)
addButton(t9, "10. Beri Pesan Chat Palsu dari Target 💬", function() local t = getTargetPlayer() if t then game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents", true):FindFirstChild("SayMessageRequest"):FireServer("Halo, aku dikerjain Rafael Xiter!", "All") end end)

-- ================= TAB 10: TARGET 5 (41-50) =================
addButton(t10, "1. Set Target Health ke Max Penuh ❤️", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.Health = t.Character.Humanoid.MaxHealth end end)
addButton(t10, "2. Bikin Target Bisa Tembus Tembok (Noclip) 👻", function() local t = getTargetPlayer() if t and t.Character then for _,p in pairs(t.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
addButton(t10, "3. Bikin Target Normal (Collide On) 🧱", function() local t = getTargetPlayer() if t and t.Character then for _,p in pairs(t.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end end)
addButton(t10, "4. Beri Efek Pusing/Spin Cepat ke Target 🌀", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then for i=1, 20 do t.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0) task.wait(0.05) end end end)
addButton(t10, "5. Buat Target Jatuh Tiba-tiba 📉", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then t.Character.HumanoidRootPart.Velocity = Vector3.new(0, -200, 0) end end)
addButton(t10, "6. Reset WalkSpeed Target ke Normal (16) 🚶", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.WalkSpeed = 16 end end)
addButton(t10, "7. Reset JumpPower Target ke Normal (50) 🦘", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChildOfClass("Humanoid") then t.Character.Humanoid.JumpPower = 50 end end)
addButton(t10, "8. Cek Posisi Target di Chat (Print) 📍", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then print("Posisi " .. t.Name .. ": " .. tostring(t.Character.HumanoidRootPart.Position)) end end)
addButton(t10, "9. Set Skala Tubuh Target ke Normal (1x) 👤", function() local t = getTargetPlayer() if t and t.Character and t.Character:FindFirstChild("Humanoid") then local h = t.Character:FindFirstChildOfClass("Humanoid") if h then for _,s in pairs(h:GetChildren()) do if s:IsA("NumberValue") then s.Value = 1 end end end end end)
addButton(t10, "10. Kirim Notifikasi Target Dipilih 🚀", function() local t = getTargetPlayer() if t then game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Rafael Xiter", Text = "Target Aktif: " .. t.Name, Duration = 3}) end end)
