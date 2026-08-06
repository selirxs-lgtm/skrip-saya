-- ==========================================
-- HYBRID CUSTOM UI (Rayfield & Kavo Style Mix)
-- ==========================================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variabel Utama
local flying = false
local speed = 50
local heightOffset = 0
local selectedTargetName = ""
local isStunned = false

-- Membuat ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HybridProMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame (Gaya Kavo / Dark Clean)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Top Bar (Header)
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.03, 0, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ HYBRID PRO MENU | Fly & Chaos"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Tombol Open (Melayang saat ditutup)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
OpenBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
OpenBtn.Size = UDim2.new(0, 100, 0, 36)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Text = "OPEN MENU"
OpenBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.TextSize = 12
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 6)
OpenCorner.Parent = OpenBtn

CloseBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	OpenBtn.Visible = false
end)

-- Container / Content Area (Gaya Rayfield Tab View)
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 15, 0, 55)
ContentContainer.Size = UDim2.new(1, -30, 1, -65)
ContentContainer.CanvasSize = UDim2.new(0, 0, 1.8, 0)
ContentContainer.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = ContentContainer
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

-- Fungsi Helper untuk Membuat Toggle Keren
local function createToggle(name, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = ContentContainer
	btn.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.Font = Enum.Font.GothamMedium
	btn.Text = "  " .. name .. ": OFF"
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Left
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		if active then
			btn.BackgroundColor3 = Color3.fromRGB(0, 140, 70)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Text = "  " .. name .. ": ON"
		else
			btn.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
			btn.TextColor3 = Color3.fromRGB(200, 200, 200)
			btn.Text = "  " .. name .. ": OFF"
		end
		callback(active)
	end)
end

-- Fungsi Helper untuk Membuat Button Biasa
local function createButton(name, color, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = ContentContainer
	btn.BackgroundColor3 = color
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.Font = Enum.Font.GothamBold
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		callback()
	end)
end

-- Label Judul Kategori
local function createLabel(text)
	local lbl = Instance.new("TextLabel")
	lbl.Parent = ContentContainer
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(100, 150, 255)
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
end

-- 1. BAGIAN FLY
createLabel("--- FITUR FLY & GERAKAN ---")
createToggle("Aktifkan Fly", function(val)
	flying = val
end)

-- 2. BAGIAN TELEPORT & TROLL
createLabel("--- TELEPORT & TROLL PLAYER ---")

-- Dropdown Sederhana (List Player)
local DropdownBox = Instance.new("TextBox")
DropdownBox.Parent = ContentContainer
DropdownBox.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
DropdownBox.Size = UDim2.new(1, 0, 0, 35)
DropdownBox.Font = Enum.Font.Gotham
DropdownBox.PlaceholderText = "Ketik Nama Player Target..."
DropdownBox.Text = ""
DropdownBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownBox.TextSize = 12

local DropCorner = Instance.new("UICorner")
DropCorner.CornerRadius = UDim.new(0, 6)
DropCorner.Parent = DropDropdownBox

DropdownBox.FocusLost:Connect(function()
	selectedTargetName = Dropbox.Text
end)

local function getTargetPlayer()
	for _, p in ipairs(game.Players:GetPlayers()) do
		if string.sub(string.lower(p.Name), 1, #string.lower(DropdownBox.Text)) == string.lower(DropdownBox.Text) and p ~= player then
			return p
		end
	end
	return nil
end

createButton("Teleport ke Target", Color3.fromRGB(80, 50, 180), function()
	local target = getTargetPlayer()
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		humanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
	end
end)

createButton("Tarik Target ke Saya", Color3.fromRGB(180, 100, 0), function()
	local target = getTargetPlayer()
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		target.Character.HumanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 3, 0)
	end
end)

createToggle("Troll: Stun Target", function(val)
	isStunned = val
end)

-- 3. BAGIAN CHAOS / KILL ALL
createLabel("--- CHAOS / WORLD CONTROL ---")
createButton("💀 Buang Semua Player ke Void (Kill All)", Color3.fromRGB(180, 40, 40), function()
	for _, p in ipairs(game.Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -5000, 0)
		end
	end
end)


-- ==========================================
-- LOOP UTAMA (FISIKA FLY & STUN)
-- ==========================================
local bg = Instance.new("BodyGyro")
bg.P = 9e4
bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.Parent = humanoidRootPart

local bv = Instance.new("BodyVelocity")
bv.velocity = Vector3.new(0, 0, 0)
bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
bv.Parent = humanoidRootPart

local camera = workspace.CurrentCamera

game:GetService("RunService").RenderStepped:Connect(function()
	if isStunned and Dropbox.Text ~= "" then
		local target = getTargetPlayer()
		if target and target.Character then
			local tHum = target.Character:FindFirstChildOfClass("Humanoid")
			if tHum then
				tHum.WalkSpeed = 0
				tHum.JumpPower = 0
			end
		end
	end

	if flying and character and humanoidRootPart and humanoid and humanoid.Health > 0 then
		bg.Parent = humanoidRootPart
		bv.Parent = humanoidRootPart
		
		local moveDirection = humanoid.MoveDirection
		local camLook = camera.CFrame.LookVector
		local camRight = camera.CFrame.RightVector
		
		local velocity = Vector3.new(0, 0, 0)
		if moveDirection.Magnitude > 0 then
			velocity = (camLook * Vector3.new(1,0,1)).Unit * moveDirection.Z * speed 
				+ (camRight * Vector3.new(1,0,1)).Unit * moveDirection.X * speed
		end
		
		bv.velocity = velocity + Vector3.new(0, heightOffset, 0)
		bg.cframe = camera.CFrame
		humanoid.PlatformStand = true
	else
		bg.Parent = nil
		bv.Parent = nil
		if humanoid then
			humanoid.PlatformStand = false
		end
	end
end)

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
	humanoid = newChar:WaitForChild("Humanoid")
	bg.Parent = humanoidRootPart
	bv.Parent = humanoidRootPart
end)
