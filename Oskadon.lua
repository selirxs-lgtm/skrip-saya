local success, Rayfield = pcall(function()
   return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
   warn("Gagal memuat Rayfield!")
   return
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ====================== STATE ======================
local speed = 50
local jumpPower = 50
local flySpeed = 60
local gravity = 196.2

local speedEnabled = true
local jumpEnabled = true
local infiniteJump = false
local flying = false
local noclip = false
local sprinting = false
local forceApply = true

local character, humanoid, root
local flyBG, flyBV
local connections = {}

-- ====================== FUNCTIONS ======================
local function refreshCharacter(char)
   character = char
   humanoid = char:WaitForChild("Humanoid", 5)
   root = char:WaitForChild("HumanoidRootPart", 5)
   if humanoid then
      humanoid.UseJumpPower = true
   end
end

local function applySpeed()
   if humanoid and speedEnabled then
      humanoid.WalkSpeed = sprinting and speed * 1.75 or speed
   elseif humanoid then
      humanoid.WalkSpeed = 16
   end
end

local function applyJump()
   if humanoid then
      humanoid.JumpPower = jumpEnabled and jumpPower or 50
   end
end

local function setNoclip(state)
   noclip = state
end

local function stopFly()
   flying = false
   if flyBG then flyBG:Destroy() flyBG = nil end
   if flyBV then flyBV:Destroy() flyBV = nil end
   if humanoid then humanoid.PlatformStand = false end
end

local function startFly()
   if not root or not humanoid then return end
   stopFly()
   flying = true
   humanoid.PlatformStand = true

   flyBG = Instance.new("BodyGyro")
   flyBG.P = 9e4
   flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
   flyBG.Parent = root

   flyBV = Instance.new("BodyVelocity")
   flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
   flyBV.Velocity = Vector3.zero
   flyBV.Parent = root
end

-- Character handling
if player.Character then
   refreshCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
   stopFly()
   task.wait(0.3)
   refreshCharacter(char)
   applySpeed()
   applyJump()
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
   if infiniteJump and humanoid then
      humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
   -- Noclip
   if noclip and character then
      for _, part in ipairs(character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.CanCollide = false
         end
      end
   end

   -- Force Apply Speed
   if forceApply and humanoid and speedEnabled then
      local target = sprinting and speed * 1.75 or speed
      if humanoid.WalkSpeed \~= target then
         humanoid.WalkSpeed = target
      end
   end

   -- Fly
   if flying and root and humanoid and humanoid.Health > 0 then
      local cam = workspace.CurrentCamera
      local dir = Vector3.zero

      if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
      if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
      if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end

      if dir.Magnitude > 0 then
         dir = dir.Unit * flySpeed
      end

      flyBV.Velocity = dir
      flyBG.CFrame = cam.CFrame
   end
end)

-- ====================== UI ======================
local Window = Rayfield:CreateWindow({
   Name = "⚡ Speed Menu Ultra V5",
   LoadingTitle = "Speed Menu Ultra",
   LoadingSubtitle = "Stable Version",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SpeedMenuUltra",
      FileName = "Config"
   },
   KeySystem = false,
})

-- TAB SPEED
local SpeedTab = Window:CreateTab("Speed", 4483362458)

SpeedTab:CreateSection("Walk Speed")

SpeedTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 50,
   Flag = "WalkSpeed",
   Callback = function(Value)
      speed = Value
      applySpeed()
   end,
})

SpeedTab:CreateToggle({
   Name = "Enable Speed",
   CurrentValue = true,
   Flag = "SpeedEnabled",
   Callback = function(Value)
      speedEnabled = Value
      applySpeed()
   end,
})

SpeedTab:CreateToggle({
   Name = "Sprint (x1.75)",
   CurrentValue = false,
   Flag = "Sprint",
   Callback = function(Value)
      sprinting = Value
      applySpeed()
   end,
})

SpeedTab:CreateToggle({
   Name = "Force Apply (Anti Reset)",
   CurrentValue = true,
   Flag = "ForceApply",
   Callback = function(Value)
      forceApply = Value
   end,
})

-- TAB JUMP
local JumpTab = Window:CreateTab("Jump", 4483362458)

JumpTab:CreateSection("Jump Settings")

JumpTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 400},
   Increment = 5,
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      jumpPower = Value
      applyJump()
   end,
})

JumpTab:CreateToggle({
   Name = "Enable Jump",
   CurrentValue = true,
   Flag = "JumpEnabled",
   Callback = function(Value)
      jumpEnabled = Value
      applyJump()
   end,
})

JumpTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      infiniteJump = Value
   end,
})

-- TAB FLY & NOCLIP
local FlyTab = Window:CreateTab("Fly & Noclip", 4483362458)

FlyTab:CreateSection("Fly")

FlyTab:CreateSlider({
   Name = "Fly Speed",
   Range = {20, 300},
   Increment = 5,
   CurrentValue = 60,
   Flag = "FlySpeed",
   Callback = function(Value)
      flySpeed = Value
   end,
})

FlyTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
      if Value then
         startFly()
      else
         stopFly()
      end
   end,
})

FlyTab:CreateSection("Noclip")

FlyTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      setNoclip(Value)
   end,
})

-- TAB EXTRA
local ExtraTab = Window:CreateTab("Extra", 4483362458)

ExtraTab:CreateSection("World")

ExtraTab:CreateSlider({
   Name = "Gravity",
   Range = {0, 300},
   Increment = 1,
   CurrentValue = 196,
   Flag = "Gravity",
   Callback = function(Value)
      gravity = Value
      workspace.Gravity = Value
   end,
})

ExtraTab:CreateSection("Utility")

ExtraTab:CreateButton({
   Name = "Reset Semua ke Default",
   Callback = function()
      speed = 50
      jumpPower = 50
      flySpeed = 60
      gravity = 196.2
      speedEnabled = true
      jumpEnabled = true
      infiniteJump = false
      sprinting = false
      forceApply = true
      stopFly()
      setNoclip(false)
      workspace.Gravity = 196.2
      applySpeed()
      applyJump()

      Rayfield:Notify({
         Title = "Reset",
         Content = "Semua setting dikembalikan!",
         Duration = 3
      })
   end,
})

-- Notify
Rayfield:Notify({
   Title = "Speed Menu Ultra V5",
   Content = "Berhasil dimuat! Tekan RightControl untuk buka/tutup menu",
   Duration = 5
})

print("[Speed Menu Ultra V5] Loaded successfully!")
