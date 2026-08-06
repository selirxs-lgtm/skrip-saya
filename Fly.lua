-- Pastikan karakter sudah dimuat
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variabel Pengaturan (Default)
local flying = true
local speed = 50
local heightOffset = 0

-- Membuat GUI untuk Kontrol Fly
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local OpenButton = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")
local SpeedBox = Instance.new("TextBox")
local HeightLabel = Instance.new("TextLabel")
local HeightBox = Instance.new("TextBox")
local ToggleButton = Instance.new("TextButton")

-- Setup GUI Properties
ScreenGui.Name = "FlyGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 220, 0, 200)
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "  Roblox Fly Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close (X) di dalam Frame
CloseButton.Parent = Title
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

-- Tombol Open kecil yang melayang saat menu ditutup
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenButton.Position = UDim2.new(0.05, 0, 0.4, 0)
OpenButton.Size = UDim2.new(0, 80, 0, 30)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Text = "Open Menu"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 14
OpenButton.Visible = false
OpenButton.Active = true
OpenButton.Draggable = true

SpeedLabel.Parent = Frame
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.1, 0, 0.2, 0)
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 20)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.Text = "Kecepatan (Speed):"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

SpeedBox.Parent = Frame
SpeedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedBox.Position = UDim2.new(0.1, 0, 0.32, 0)
SpeedBox.Size = UDim2.new(0.8, 0, 0, 25)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.Text = tostring(speed)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextSize = 14

HeightLabel.Parent = Frame
HeightLabel.BackgroundTransparency = 1
HeightLabel.Position = UDim2.new(0.1, 0, 0.52, 0)
HeightLabel.Size = UDim2.new(0.8, 0, 0, 20)
HeightLabel.Font = Enum.Font.SourceSans
HeightLabel.Text = "Ketinggian (Height):"
HeightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightLabel.TextSize = 14
HeightLabel.TextXAlignment = Enum.TextXAlignment.Left

HeightBox.Parent = Frame
HeightBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
HeightBox.Position = UDim2.new(0.1, 0, 0.64, 0)
HeightBox.Size = UDim2.new(0.8, 0, 0, 25)
HeightBox.Font = Enum.Font.SourceSans
HeightBox.Text = tostring(heightOffset)
HeightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightBox.TextSize = 14

ToggleButton.Parent = Frame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleButton.Position = UDim2.new(0.1, 0, 0.8, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Status: ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

-- Fungsi Close dan Open Menu
CloseButton.MouseButton1Click:Connect(function()
	Frame.Visible = false
	OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
	Frame.Visible = true
	OpenButton.Visible = false
end)

-- Update Variabel dari Input GUI
SpeedBox.FocusLost:Connect(function()
	local newSpeed = tonumber(SpeedBox.Text)
	if newSpeed then
		speed = newSpeed
	else
		SpeedBox.Text = tostring(speed)
	end
end)

HeightBox.FocusLost:Connect(function()
	local newHeight = tonumber(HeightBox.Text)
	if newHeight then
		heightOffset = newHeight
	else
		HeightBox.Text = tostring(heightOffset)
	end
end)

-- Tombol On/Off Fly
ToggleButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		ToggleButton.Text = "Status: ON"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		ToggleButton.Text = "Status: OFF"
		ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	end
end)

-- Sistem Fisika Terbang (BodyVelocity & BodyGyro)
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
	if flying and character and humanoidRootPart and humanoid and humanoid.Health > 0 then
		bg.Parent = humanoidRootPart
		bv.Parent = humanoidRootPart
		
		local moveDirection = humanoid.MoveDirection
		local camLook = camera.CFrame.LookVector
		local camRight = camera.CFrame.RightVector
		
		local velocity = Vector3.new(0, 0, 0)
		
		if moveDirection.Magnitude > 0 then
			-- Perbaikan arah minus (-) agar sesuai dengan tombol W/S
			velocity = (camLook * Vector3.new(1,0,1)).Unit * (-moveDirection.Z) * speed 
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

-- Cleanup saat karakter mati/respawn
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
	humanoid = newChar:WaitForChild("Humanoid")
	bg.Parent = humanoidRootPart
	bv.Parent = humanoidRootPart
end)
