-- Pastikan karakter sudah dimuat
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variabel Pengaturan
local flying = true
local speed = 50
local heightOffset = 0
local targetPlayerName = ""

-- Membuat GUI Utama
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local OpenButton = Instance.new("TextButton")

-- Setup GUI Properties
ScreenGui.Name = "AdvancedFlyGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 240, 0, 330)
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "  Roblox Control Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Parent = Title
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenButton.Position = UDim2.new(0.05, 0, 0.3, 0)
OpenButton.Size = UDim2.new(0, 90, 0, 30)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Text = "Open Menu"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 14
OpenButton.Visible = false
OpenButton.Active = true
OpenButton.Draggable = true

-- Fungsi Helper untuk Membuat Label & Input
local function createInput(name, placeholder, posY)
	local lbl = Instance.new("TextLabel")
	lbl.Parent = Frame
	lbl.BackgroundTransparency = 1
	lbl.Position = UDim2.new(0.1, 0, posY, 0)
	lbl.Size = UDim2.new(0.8, 0, 0, 18)
	lbl.Font = Enum.Font.SourceSans
	lbl.Text = name
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local box = Instance.new("TextBox")
	box.Parent = Frame
	box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	box.Position = UDim2.new(0.1, 0, posY + 0.05, 0)
	box.Size = UDim2.new(0.8, 0, 0, 24)
	box.Font = Enum.Font.SourceSans
	box.PlaceholderText = placeholder
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.TextSize = 13
	return box
end

local SpeedBox = createInput("Kecepatan (Speed):", "50", 0.1)
SpeedBox.Text = tostring(speed)

local HeightBox = createInput("Ketinggian (Height):", "0", 0.25)
HeightBox.Text = tostring(heightOffset)

local TargetBox = createInput("Nama Target Player:", "Ketik nama player...", 0.4)

-- Tombol Toggle Fly
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleButton.Position = UDim2.new(0.1, 0, 0.58, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 26)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Fly Status: ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13

-- Tombol Teleport ke Target
local TpToBtn = Instance.new("TextButton")
TpToBtn.Parent = Frame
TpToBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
TpToBtn.Position = UDim2.new(0.1, 0, 0.70, 0)
TpToBtn.Size = UDim2.new(0.38, 0, 0, 26)
TpToBtn.Font = Enum.Font.SourceSansBold
TpToBtn.Text = "TP Ke Target"
TpToBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TpToBtn.TextSize = 12

-- Tombol Tarik Target ke Kita
local TpBringBtn = Instance.new("TextButton")
TpBringBtn.Parent = Frame
TpBringBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
TpBringBtn.Position = UDim2.new(0.52, 0, 0.70, 0)
TpBringBtn.Size = UDim2.new(0.38, 0, 0, 26)
TpBringBtn.Font = Enum.Font.SourceSansBold
TpBringBtn.Text = "Tarik Target"
TpBringBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TpBringBtn.TextSize = 12

-- Tombol Troll (Stun Target)
local TrollBtn = Instance.new("TextButton")
TrollBtn.Parent = Frame
TrollBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
TrollBtn.Position = UDim2.new(0.1, 0, 0.83, 0)
TrollBtn.Size = UDim2.new(0.8, 0, 0, 28)
TrollBtn.Font = Enum.Font.SourceSansBold
TrollBtn.Text = "Troll: Stun Target (OFF)"
TrollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TrollBtn.TextSize = 12

-- Fungsi Mencari Player Berdasarkan Nama (Mendukung Partial Name)
local function getTargetPlayer()
	local inputName = string.lower(TargetBox.Text)
	if inputName == "" then return nil end
	for _, p in ipairs(game.Players:GetPlayers()) do
		if p ~= player then
			if string.sub(string.lower(p.Name), 1, #inputName) == inputName or string.sub(string.lower(p.DisplayName), 1, #inputName) == inputName then
				return p
			end
		end
	end
	return nil
end

-- Event Tombol Close/Open
CloseButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
	OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
	Frame.Visible = true
	OpenButton.Visible = false
end)

-- Input Update
SpeedBox.FocusLost:Connect(function()
	speed = tonumber(SpeedBox.Text) or speed
	SpeedBox.Text = tostring(speed)
end)

HeightBox.FocusLost:Connect(function()
	heightOffset = tonumber(HeightBox.Text) or heightOffset
	HeightBox.Text = tostring(heightOffset)
end)

ToggleButton.MouseButton1Click:Connect(function()
	flying = not flying
	ToggleButton.Text = flying and "Fly Status: ON" or "Fly Status: OFF"
	ToggleButton.BackgroundColor3 = flying and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

-- Fitur Teleport ke Player
TpToBtn.MouseButton1Click:Connect(function()
	local target = getTargetPlayer()
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		humanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
	end
end)

-- Fitur Tarik Player ke Kita
TpBringBtn.MouseButton1Click:Connect(function()
	local target = getTargetPlayer()
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		target.Character.HumanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 3, 0)
	end
end)

-- Fitur Troll (Stun Target Mengunci HumanoidWalkSpeed & PlatformStand)
local isStunned = false
TrollBtn.MouseButton1Click:Connect(function()
	isStunned = not isStunned
	if isStunned then
		TrollBtn.Text = "Troll: Stun Target (ON)"
		TrollBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		TrollBtn.Text = "Troll: Stun Target (OFF)"
		TrollBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	end
end)

-- Sistem Loop Utama (Fly + Troll Stun + Kontrol Anti-Error)
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
	-- Eksekusi Fitur Troll Stun ke Target
	if isStunned then
		local target = getTargetPlayer()
		if target and target.Character then
			local tHum = target.Character:FindFirstChildOfClass("Humanoid")
			if tHum then
				tHum.WalkSpeed = 0
				tHum.JumpPower = 0
				tHum.PlatformStand = true
			end
		end
	end

	-- Eksekusi Sistem Fly (Kontrol Diperbaiki Agar Sesuai Arah W/S)
	if flying and character and humanoidRootPart and humanoid and humanoid.Health > 0 then
		bg.Parent = humanoidRootPart
		bv.Parent = humanoidRootPart
		
		local moveDirection = humanoid.MoveDirection
		local camLook = camera.CFrame.LookVector
		local camRight = camera.CFrame.RightVector
		
		local velocity = Vector3.new(0, 0, 0)
		
		if moveDirection.Magnitude > 0 then
			-- Perhitungan arah vektor diperbaiki agar maju tetap maju (tidak terbalik ke belakang)
			velocity = (camLook * Vector3.new(1,0,1)).Unit * moveDirection.Z * speed 
				+ (camRight * Vector3.new(1,0,1)).Unit * moveDirection.X * speed
		else
			velocity = Vector3.new(0, 0, 0)
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

-- Auto-Reconnection saat Karakter Reset/Respawn
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
	humanoid = newChar:WaitForChild("Humanoid")
	bg.Parent = humanoidRootPart
	bv.Parent = humanoidRootPart
end)
