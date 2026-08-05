-- =====================================================================
-- RAFAEL XITER ULTIMATE TROLL & NGATROL EDITION 💀🚀
-- =====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("RafaelXiterUltimate") then
    CoreGui.RafaelXiterUltimate:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RafaelXiterUltimate"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Tombol Mengambang
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0, 20, 0.3, 0)
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "💀"
ToggleButton.TextColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextSize = 28
ToggleButton.Active = true
ToggleButton.Draggable = true

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = ToggleButton
ToggleStroke.Color = Color3.fromRGB(255, 0, 0)
ToggleStroke.Thickness = 2

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 1.5

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Size = UDim2.new(1, 0, 0, 35)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -30, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "RAFAEL XITER 💀 [MODE NGATROL BARBAR]"
TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.TextSize = 12
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Target Selector Dropdown
local SelectedTarget = nil

local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Parent = MainFrame
DropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownBtn.Position = UDim2.new(0.04, 0, 0, 42)
DropdownBtn.Size = UDim2.new(0.92, 0, 0, 30)
DropdownBtn.Font = Enum.Font.SourceSansBold
DropdownBtn.Text = "🎯 Target Ngatrol: [Klik Pilih Korban]"
DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownBtn.TextSize = 11

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 6)
DropdownCorner.Parent = DropdownBtn

local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Parent = MainFrame
DropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DropdownList.Position = UDim2.new(0.04, 0, 0, 75)
DropdownList.Size = UDim2.new(0.92, 0, 0, 100)
DropdownList.Visible = false
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ScrollBarThickness = 4
DropdownList.ZIndex = 15

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = DropdownList
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 3)

local function RefreshPlayerList()
    for _, v in pairs(DropdownList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    local count = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            count = count + 1
            local pBtn = Instance.new("TextButton")
            pBtn.Parent = DropdownList
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.Size = UDim2.new(1, 0, 0, 25)
            pBtn.Font = Enum.Font.SourceSans
            pBtn.Text = "👤 " .. p.Name
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.TextSize = 11
            pBtn.ZIndex = 16

            pBtn.MouseButton1Click:Connect(function()
                SelectedTarget = p
                DropdownBtn.Text = "🎯 Korban Dipilih: " .. p.Name
                DropdownList.Visible = false
            end)
        end
    end
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, count * 28)
end

DropdownBtn.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then RefreshPlayerList() end
end)

local function GetTargetRoot()
    if SelectedTarget and SelectedTarget.Character and SelectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        return SelectedTarget.Character.HumanoidRootPart
    end
    return nil
end

-- Tab Bar
local TabBar = Instance.new("ScrollingFrame")
TabBar.Parent = MainFrame
TabBar.BackgroundTransparency = 1
TabBar.Position = UDim2.new(0.04, 0, 0, 78)
TabBar.Size = UDim2.new(0.92, 0, 0, 30)
TabBar.CanvasSize = UDim2.new(0, 480, 0, 0)
TabBar.ScrollBarThickness = 0

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 0, 0, 112)
ContentContainer.Size = UDim2.new(1, 0, 1, -112)

local TabsRegistry = {}

local function CreateTab(name, index)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabBar
    tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabBtn.Size = UDim2.new(0, 44, 1, 0)
    tabBtn.Position = UDim2.new(0, 46 * (index - 1), 0, 0)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.TextSize = 9

    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = ContentContainer
    scroll.BackgroundTransparency = 1
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Visible = false
    scroll.CanvasSize = UDim2.new(0, 0, 0, 450)
    scroll.ScrollBarThickness = 4

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scroll
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 6)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(TabsRegistry) do
            t.Scroll.Visible = false
            t.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
        scroll.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    end)

    table.insert(TabsRegistry, {Button = tabBtn, Scroll = scroll})

    if index == 1 then
        scroll.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
    end

    return scroll
end

local function AddBtn(parentScroll, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 30)
    btn.Position = UDim2.new(0.04, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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

-- 10 Tab Dibuat Spesifik Fitur Ngatrol
local t1 = CreateTab("SelfOP", 1)
local t2 = CreateTab("B走了", 2) -- Movement / Speed
local t3 = CreateTab("World", 3)
local t4 = CreateTab("Visual", 4)
local t5 = CreateTab("Troll1", 5)
local t6 = CreateTab("TargTP", 6)
local t7 = CreateTab("TargKill", 7)
local t8 = CreateTab("TargSpin", 8)
local t9 = CreateTab("Server", 9)
local t10 = CreateTab("Misc", 10)

-- TAB 1: SELF OP (Godmode, Noclip, Fly)
AddBtn(t1, "1. Godmode HP Abadi 🛡️", function()
    task.spawn(function()
        while true do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
            task.wait(0.1)
        end
    end)
end)
AddBtn(t1, "2. Noclip Tembus Tembok 👻", function()
    RunService.Stepped:Connect(function()
        if LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)
AddBtn(t1, "3. Invisible (Menghilang) 🥷", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 1 end
        end
    end
end)

-- TAB 2: MOVEMENT (Speed & Jump Tinggi)
AddBtn(t2, "1. Super Speed (100) ⚡", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)
AddBtn(t2, "2. Extreme Speed (300) 🚀", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 300
    end
end)
AddBtn(t2, "3. Super High Jump (250) 🦘", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 250
    end
end)
AddBtn(t2, "4. Reset Kecepatan Normal 🚶", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

-- TAB 3: WORLD / ENVIRONMENT
AddBtn(t3, "1. Set Malam Gelap Gulita 🌙", function() Lighting.ClockTime = 0 end)
AddBtn(t3, "2. Set Siang Benderang ☀️", function() Lighting.ClockTime = 14 end)
AddBtn(t3, "3. Hapus Kabut (Full Clear) 🌤️", function() Lighting.FogEnd = 999999 end)

-- TAB 4: VISUAL ESP
AddBtn(t4, "1. Fullbright (Anti Gelap) 💡", function()
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
end)
AddBtn(t4, "2. ESP Nama Player Lain 👁️", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if not p.Character.Head:FindFirstChild("EspTag") then
                local bg = Instance.new("BillboardGui", p.Character.Head)
                bg.Name = "EspTag"
                bg.Size = UDim2.new(0, 100, 0, 40)
                bg.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", bg)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = p.Name
                txt.TextColor3 = Color3.fromRGB(255, 0, 0)
                txt.TextSize = 12
                txt.Font = Enum.Font.SourceSansBold
            end
        end
    end
end)

-- TAB 5: TROLL UMUM
AddBtn(t5, "1. Spawn Sound Spam (Ledakan Trolling) 💣", function()
    local p = Instance.new("Part", workspace)
    p.Position = LocalPlayer.Character.HumanoidRootPart.Position
    local s = Instance.new("Sound", p)
    s.SoundId = "rbxassetid://9114220763"
    s.Volume = 10
    s:Play()
end)

-- TAB 6: TARGET TELEPORT (Ke Target / Tarik Target)
AddBtn(t6, "1. TP ke Depan Target 📍", function()
    local root = GetTargetRoot()
    if root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 0, 3)
    end
end)
AddBtn(t6, "2. TP Target ke Posisi Gua 🧲", function()
    local root = GetTargetRoot()
    if root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        root.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 3)
    end
end)

-- TAB 7: TARGET KILL / DAMAGE
AddBtn(t7, "1. Bunuh Target (Void Teleport) 💀", function()
    local root = GetTargetRoot()
    if root then
        root.CFrame = CFrame.new(0, -500, 0) -- Masukin ke bawah map / void
    end
end)
AddBtn(t7, "2. Beri Efek Api ke Target 🔥", function()
    local root = GetTargetRoot()
    if root and root.Parent:FindFirstChild("Torso") then Instance.new("Fire", root.Parent.Torso)
    elseif root and root.Parent:FindFirstChild("UpperTorso") then Instance.new("Fire", root.Parent.UpperTorso) end
end)

-- TAB 8: TARGET SPIN / FLING (Biar Korban Pusing/Mental)
AddBtn(t8, "1. Putar/Spin Kepala Target 🌀", function()
    local root = GetTargetRoot()
    if root and root.Parent:FindFirstChild("Head") then
        task.spawn(function()
            for i = 1, 50 do
                root.Parent.Head.CFrame = root.Parent.Head.CFrame * CFrame.Angles(0, math.rad(45), 0)
                task.wait(0.05)
            end
        end)
    end
end)
AddBtn(t8, "2. Fling / Lempar Target Barbar 🌪️", function()
    local root = GetTargetRoot()
    if root then
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(50000, 100000, 50000)
        task.wait(0.2)
        bv:Destroy()
    end
end)

-- TAB 9: SERVER UTILS
AddBtn(t9, "1. Server Hop (Pindah Server Lain) 🌐", function()
    local TS = game:GetService("TeleportService")
    TS:Teleport(game.PlaceId, LocalPlayer)
end)

-- TAB 10: MISC / EXTRA
AddBtn(t10, "1. Rejoin Server Ini 🔄", function()
    local TS = game:GetService("TeleportService")
    TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

print("Rafael Xiter Troll Mode Loaded Successfully, Cok!")
