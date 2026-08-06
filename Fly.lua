local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Roblox Pro Menu | Rayfield Edition",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "by AI Collaborator",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false,
})

-- Variabel Utama
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local speed = 50
local heightOffset = 0
local selectedTargetName = ""
local isStunned = false
local rifleLevel = 0 -- 0: OFF, 1: Mild, 2: Fast, 3: Brutal Spam

-- Tab Utama
local MainTab = Window:CreateTab("Fly & Movement", 4483362458)
local TrollTab = Window:CreateTab("Teleport & Troll", 4483362458)
local ChaosTab = Window:CreateTab("Chaos / World", 4483362458)

--------------------------------------------------
-- TAB 1: FLY SETTINGS
--------------------------------------------------
MainTab:CreateToggle({
   Name = "Aktifkan Fly",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flying = Value
   end,
})

MainTab:CreateSlider({
   Name = "Kecepatan (Speed)",
   Range = {10, 300},
   Increment = 5,
   CurrentValue = 50,
   Flag = "SpeedSlider",
   Callback = function(Value)
      speed = Value
   end,
})

MainTab:CreateSlider({
   Name = "Ketinggian (Height Offset)",
   Range = {-50, 50},
   Increment = 1,
   CurrentValue = 0,
   Flag = "HeightSlider",
   Callback = function(Value)
      heightOffset = Value
   end,
})

--------------------------------------------------
-- TAB 2: TELEPORT & RIFLE TROLL
--------------------------------------------------
TrollTab:CreateInput({
   Name = "Nama Target Player",
   PlaceholderText = "Ketik sebagian nama player...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      selectedTargetName = string.lower(Text)
   end,
})

local function getTargetPlayer()
   if selectedTargetName == "" then return nil end
   for _, p in ipairs(game.Players:GetPlayers()) do
      if p ~= player then
         if string.find(string.lower(p.Name), selectedTargetName) or string.find(string.lower(p.DisplayName), selectedTargetName) then
            return p
         end
      end
   end
   return nil
end

TrollTab:CreateButton({
   Name = "Teleport Ke Target",
   Callback = function()
      local target = getTargetPlayer()
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         humanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
         Rayfield:Notify({Title = "Berhasil", Content = "Teleport ke " .. target.Name, Duration = 2})
      else
         Rayfield:Notify({Title = "Gagal", Content = "Player tidak ditemukan!", Duration = 2})
      end
   end,
})

TrollTab:CreateButton({
   Name = "Tarik Target Ke Saya",
   Callback = function()
      local target = getTargetPlayer()
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         target.Character.HumanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 3, 0)
         Rayfield:Notify({Title = "Berhasil", Content = "Menarik " .. target.Name, Duration = 2})
      else
         Rayfield:Notify({Title = "Gagal", Content = "Player tidak ditemukan!", Duration = 2})
      end
   end,
})

TrollTab:CreateToggle({
   Name = "Troll: Stun Target (Tidak Bisa Gerak)",
   CurrentValue = false,
   Callback = function(Value)
      isStunned = Value
      if not isStunned then
         local target = getTargetPlayer()
         if target and target.Character then
            local tHum = target.Character:FindFirstChildOfClass("Humanoid")
            if tHum then
               tHum.WalkSpeed = 16
               tHum.JumpPower = 50
            end
         end
      end
   end,
})

-- Fitur Rifle Jumpscare Levels
TrollTab:CreateToggle({
   Name = "Rifle 1 (Pelan - Tutup Muka)",
   CurrentValue = false,
   Callback = function(Value)
      rifleLevel = Value and 1 or 0
   end,
})

TrollTab:CreateToggle({
   Name = "Rifle 2 (Cepat - Nutupin Pandangan)",
   CurrentValue = false,
   Callback = function(Value)
      rifleLevel = Value and 2 or 0
   end,
})

TrollTab:CreateToggle({
   Name = "Rifle 3 (Brutal - Spam Gempa Muka)",
   CurrentValue = false,
   Callback = function(Value)
      rifleLevel = Value and 3 or 0
   end,
})

--------------------------------------------------
-- TAB 3: CHAOS / WORLD
--------------------------------------------------
ChaosTab:CreateButton({
   Name = "💀 Buang Semua Player ke Void (Kill All)",
   Callback = function()
      local count = 0
      for _, p in ipairs(game.Players:GetPlayers()) do
         if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -5000, 0)
            count = count + 1
         end
      end
      Rayfield:Notify({Title = "Chaos Berhasil", Content = count .. " player dibuang ke void!", Duration = 3})
   end,
})

--------------------------------------------------
-- SISTEM FISIKA (FLY, STUN, & RIFLE TROLL LOOP)
--------------------------------------------------
local bg = Instance.new("BodyGyro")
bg.P = 9e4
bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.Parent = humanoidRootPart

local bv = Instance.new("BodyVelocity")
bv.velocity = Vector3.new(0, 0, 0)
bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
bv.Parent = humanoidRootPart

local camera = workspace.CurrentCamera
local tickCounter = 0

game:GetService("RunService").RenderStepped:Connect(function()
   -- Logika Stun Target
   if isStunned and selectedTargetName ~= "" then
      local target = getTargetPlayer()
      if target and target.Character then
         local tHum = target.Character:FindFirstChildOfClass("Humanoid")
         if tHum then
            tHum.WalkSpeed = 0
            tHum.JumpPower = 0
         end
      end
   end

   -- Logika Rifle Jumpscare (Menempel di depan muka target menghadap langsung)
   if rifleLevel > 0 and selectedTargetName ~= "" then
      local target = getTargetPlayer()
      if target and target.Character and target.Character:FindFirstChild("Head") then
         tickCounter = tickCounter + 1
         local headCFrame = target.Character.Head.CFrame
         
         if rifleLevel == 1 and tickCounter % 30 == 0 then
            humanoidRootPart.CFrame = CFrame.new(headCFrame.Position + (headCFrame.LookVector * 0.4), headCFrame.Position)
         elseif rifleLevel == 2 and tickCounter % 10 == 0 then
            humanoidRootPart.CFrame = CFrame.new(headCFrame.Position + (headCFrame.LookVector * 0.3), headCFrame.Position)
         elseif rifleLevel == 3 then
            humanoidRootPart.CFrame = CFrame.new(headCFrame.Position + (headCFrame.LookVector * 0.2) + Vector3.new(math.random(-1,1)*0.1, math.random(-1,1)*0.1, math.random(-1,1)*0.1), headCFrame.Position)
         end
      end
   end

   -- Logika Fly
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
      if rifleLevel == 0 then
         bg.Parent = nil
         bv.Parent = nil
         if humanoid then
            humanoid.PlatformStand = false
         end
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
