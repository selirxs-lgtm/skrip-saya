-- ==========================================
-- RAFAEL XITER 🚀 - ULTIMATE MOBILE GUI
-- ==========================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Hapus UI lama jika ada
if CoreGui:FindFirstChild("RafaelXiterUI") then
    CoreGui.RafaelXiterUI:Destroy()
end

-- ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RafaelXiterUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Variabel RGB & UI Tracking
local rgbElements = {}
local isRgbActive = false
local activeSlider = nil

-- ------------------------------------------
-- 1. TOMBOL TOGGLE BULAT (FLOATING BUTTON) 🔘
-- ------------------------------------------
local ToggleButton = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")

ToggleButton.Name = "ToggleButton"
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
ToggleButton.ZIndex = 10

ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- ------------------------------------------
-- 2. MAIN FRAME (LAYAR UTAMA UI) 🖼️
-- ------------------------------------------
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local Header = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 1

MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

table.insert(rgbElements, MainFrame)

-- Header Bar
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.ZIndex = 2

TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Size = UDim2.new(1, -24, 1, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Rafael Xiter 🚀"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3

table.insert(rgbElements, Header)

-- Event Buka / Tutup UI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ------------------------------------------
-- 3. KONTROL TAB & CONTAINER 📁
-- ------------------------------------------
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabBar.Position = UDim2.new(0, 0, 0, 35)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.ZIndex = 2

table.insert(rgbElements, TabBar)

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 0, 0, 65)
ContentContainer.Size = UDim2.new(1, 0, 1, -65)
ContentContainer.ZIndex = 2

local tabs = {}

local function createTab(name)
    local tabCount = #tabs
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabBar
    tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBtn.Size = UDim2.new(0.25, -2, 1, 0)
    tabBtn.Position = UDim2.new(0.25 * tabCount, 1, 0, 0)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabBtn.TextSize = 12
    tabBtn.ZIndex = 3

    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = ContentContainer
    scroll.BackgroundTransparency = 1
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.Visible = false
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 4
    scroll.ZIndex = 3

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scroll
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)

    table.insert(rgbElements, tabBtn)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Scroll.Visible = false
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        scroll.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    local tabData = {Button = tabBtn, Scroll = scroll}
    table.insert(tabs, tabData)

    if #tabs == 1 then
        scroll.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    return scroll
end

-- ------------------------------------------
-- 4. LOGIKA SLIDER BEBAS BUG 📱
-- ------------------------------------------
local sliderIdCounter = 0

local function addSlider(parentScroll, text, min, max, default, callback)
    sliderIdCounter = sliderIdCounter + 1
    local mySliderId = "Slider_" .. sliderIdCounter

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 45)
    frame.Position = UDim2.new(0.04, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Parent = parentScroll
    frame.ZIndex = 4

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    table.insert(rgbElements, frame)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 4)
    label.Size = UDim2.new(1, -20, 0, 18)
    label.Font = Enum.Font.SourceSans
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5

    local bar = Instance.new("Frame")
    bar.Parent = frame
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bar.Position = UDim2.new(0, 10, 0, 26)
    bar.Size = UDim2.new(1, -20, 0, 10)
    bar.ZIndex = 5

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Parent = bar
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    local initScale = math.clamp((default - min) / (max - min), 0, 1)
    fill.Size = UDim2.new(initScale, 0, 1, 0)
    fill.ZIndex = 6

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local function updateValue(inputX)
        local barX = bar.AbsolutePosition.X
        local barWidth = bar.AbsoluteSize.X
        if barWidth <= 0 then return end

        local scale = math.clamp((inputX - barX) / barWidth, 0, 1)
        fill.Size = UDim2.new(scale, 0, 1, 0)

        local val = math.floor(min + (max - min) * scale)
        label.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            activeSlider = mySliderId
            MainFrame.Draggable = false
            updateValue(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if activeSlider == mySliderId and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if activeSlider == mySliderId and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            activeSlider = nil
            MainFrame.Draggable = true
        end
    end)
end

-- Helper Komponen UI Lainnya
local function addButton(parentScroll, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.Position = UDim2.new(0.04, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.ZIndex = 4
    btn.Parent = parentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

local function addToggle(parentScroll, text, defaultState, callback)
    local state = defaultState or false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.92, 0, 0, 32)
    btn.Position = UDim2.new(0.04, 0, 0, 0)
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 75) or Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text .. (state and " [ON]" or " [OFF]")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.ZIndex = 4
    btn.Parent = parentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 75) or Color3.fromRGB(45, 45, 45)
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

local function addDropdown(parentScroll, text, getOptionsFunc, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.92, 0, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.Parent = parentScroll
    frame.ClipsDescendants = true
    frame.ZIndex = 4

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    table.insert(rgbElements, frame)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text .. " 🔽"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.ZIndex = 5
    btn.Parent = frame

    local optContainer = Instance.new("Frame")
    optContainer.Position = UDim2.new(0, 0, 0, 32)
    optContainer.Size = UDim2.new(1, 0, 0, 0)
    optContainer.BackgroundTransparency = 1
    optContainer.Parent = frame
    optContainer.ZIndex = 5

    local optLayout = Instance.new("UIListLayout")
    optLayout.Parent = optContainer

    local expanded = false
    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            for _, child in pairs(optContainer:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            local opts = getOptionsFunc()
            local totalHeight = 0
            for _, optName in pairs(opts) do
                local oBtn = Instance.new("TextButton")
                oBtn.Size = UDim2.new(1, 0, 0, 25)
                oBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                oBtn.Font = Enum.Font.SourceSans
                oBtn.Text = optName
                oBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                oBtn.TextSize = 12
                oBtn.ZIndex = 6
                oBtn.Parent = optContainer
                totalHeight = totalHeight + 25

                oBtn.MouseButton1Click:Connect(function()
                    btn.Text = text .. ": " .. optName
                    expanded = false
                    frame.Size = UDim2.new(0.92, 0, 0, 32)
                    callback(optName)
                end)
            end
            frame.Size = UDim2.new(0.92, 0, 0, 32 + totalHeight)
        else
            frame.Size = UDim2.new(0.92, 0, 0, 32)
        end
    end)
end

-- Helper Pemain
local function getPlayerNames()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- ==========================================
-- 5. MEMBUAT TAB & FITUR-FITUR
-- ==========================================

-- TAB 1: TELEPORT 📍
local tab1 = createTab("Teleport 📍")
local selectedTeleportPlayer = ""

addDropdown(tab1, "Pilih Player", getPlayerNames, function(name)
    selectedTeleportPlayer = name
end)

addButton(tab1, "Teleport ke Target 📍", function()
    if selectedTeleportPlayer ~= "" then
        local target = Players:FindFirstChild(selectedTeleportPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
end)

local autoTpRadius = 100
addSlider(tab1, "Radius Auto TP", 10, 500, 100, function(val)
    autoTpRadius = val
end)

local autoTpActive = false
addToggle(tab1, "Auto Teleport Terdekat", false, function(state)
    autoTpActive = state
    task.spawn(function()
        while autoTpActive do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                local closest = nil
                local dist = autoTpRadius

                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (myPos - p.Character.HumanoidRootPart.Position).Magnitude
                        if d <= dist then
                            dist = d
                            closest = p
                        end
                    end
                end

                if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- TAB 2: FITUR 🛠️
local tab2 = createTab("Fitur 🛠️")

local espActive = false
addToggle(tab2, "ESP Highlight Player", false, function(state)
    espActive = state
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if espActive then
                if not p.Character:FindFirstChild("ESP_Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_Highlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("ESP_Highlight") then
                    p.Character.ESP_Highlight:Destroy()
                end
            end
        end
    end
end)

local flySpeed = 50
addSlider(tab2, "Kecepatan Fly", 10, 200, 50, function(val)
    flySpeed = val
end)

local flyActive = false
addToggle(tab2, "Fly (Terbang)", false, function(state)
    flyActive = state
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if flyActive and hrp then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp

        task.spawn(function()
            while flyActive and hrp:FindFirstChild("FlyBV") do
                local camCFrame = workspace.CurrentCamera.CFrame
                hrp.FlyBV.Velocity = camCFrame.LookVector * flySpeed
                task.wait()
            end
            if hrp:FindFirstChild("FlyBV") then
                hrp.FlyBV:Destroy()
            end
        end)
    else
        if hrp and hrp:FindFirstChild("FlyBV") then
            hrp.FlyBV:Destroy()
        end
    end
end)

local noclipActive = false
addToggle(tab2, "Bypass Noclip (Penghalang)", false, function(state)
    noclipActive = state
end)

RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- TAB 3: TROLL 🎭
local tab3 = createTab("Troll 🎭")
local selectedTrollTarget = ""

addDropdown(tab3, "Pilih Target Troll", getPlayerNames, function(name)
    selectedTrollTarget = name
end)

addButton(tab3, "Blink ke Target ⚡", function()
    if selectedTrollTarget ~= "" then
        local target = Players:FindFirstChild(selectedTrollTarget)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

local spinTargetActive = false
addToggle(tab3, "Spin Player Terpilih 🌀", false, function(state)
    spinTargetActive = state
    task.spawn(function()
        while spinTargetActive do
            if selectedTrollTarget ~= "" then
                local target = Players:FindFirstChild(selectedTrollTarget)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    target.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
                end
            end
            task.wait(0.05)
        end
    end)
end)

local spinCarActive = false
addToggle(tab3, "Spin Mobil Target 🏎️", false, function(state)
    spinCarActive = state
    task.spawn(function()
        while spinCarActive do
            if selectedTrollTarget ~= "" then
                local target = Players:FindFirstChild(selectedTrollTarget)
                if target and target.Character then
                    local hum = target.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
                        hum.SeatPart.CFrame = hum.SeatPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

local trollRadius = 50
addSlider(tab3, "Radius Troll Area", 10, 200, 50, function(val)
    trollRadius = val
end)

local radiusSpinActive = false
addToggle(tab3, "Auto Spin Radius Player 🌀", false, function(state)
    radiusSpinActive = state
    task.spawn(function()
        while radiusSpinActive do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        if (myPos - hrp.Position).Magnitude <= trollRadius then
                            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

-- TAB 4: SETTING ⚙️
local tab4 = createTab("Setting ⚙️")

addSlider(tab4, "Transparansi UI", 0, 100, 0, function(val)
    local alpha = val / 100
    MainFrame.BackgroundTransparency = alpha
    Header.BackgroundTransparency = alpha
    TabBar.BackgroundTransparency = alpha
end)

addButton(tab4, "Tema Hitam 🖤", function()
    isRgbActive = false
    for _, elem in pairs(rgbElements) do
        if elem:IsA("GuiObject") then
            elem.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
    end
end)

addButton(tab4, "Tema Putih 🤍", function()
    isRgbActive = false
    for _, elem in pairs(rgbElements) do
        if elem:IsA("GuiObject") then
            elem.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        end
    end
end)

addToggle(tab4, "Tema Pelangi RGB Penuh 🌈", false, function(state)
    isRgbActive = state
    task.spawn(function()
        while isRgbActive do
            local hue = (tick() % 4) / 4
            local rainbowColor = Color3.fromHSV(hue, 0.75, 0.8)
            for _, elem in pairs(rgbElements) do
                if elem and elem:IsA("GuiObject") then
                    elem.BackgroundColor3 = rainbowColor
                end
            end
            task.wait(0.03)
        end
    end)
end)
