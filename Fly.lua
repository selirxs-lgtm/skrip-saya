local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Roblox Pro Menu | Ultimate Troll Edition",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "by AI Collaborator",
   ConfigurationSaving = { Enabled = false },
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
local isSlowNoJump = false -- Fitur pengganti Stone
local rifleLevel = 0

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
   Callback = function(Value)
      flying = Value
   end,
})

MainTab:CreateSlider({
   Name = "Kecepatan (Speed)",
   Range = {10, 300},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value)
      speed = Value
   end,
})

MainTab:CreateSlider({
   Name = "Ketinggian (Height Offset)",
   Range = {-50, 50},
   Increment = 1,
   CurrentValue = 0,
   Callback = function(Value)
      heightOffset = Value
   end,
})

--------------------------------------------------
-- TAB 2: TELEPORT, SLOW & RIFLE TROLL
--------------------------------------------------

local function getPlayerList()
   local list = {}
   for _, p in ipairs(game.Players:GetPlayers()) do
      if p ~= player then
         table.insert(list, p.Name)
      end
   end
   if #list == 0 then
      table.insert(list, "Tidak ada player lain")
   end
   return list
end

local PlayerDropdown = TrollTab:CreateDropdown({
   Name = "Pilih Target Player",
   Options = getPlayerList(),
   CurrentOption = "",
   Flag = "PlayerDropdownFlag",
   Callback = function(Option)
      if type(Option) == "table" then
         selectedTargetName = Option[1] or ""
      else
         selectedTargetName = Option or ""
      end
   end,
})

TrollTab:CreateButton({
   Name = "🔄 Refresh List Player",
   Callback = function()
      PlayerDropdown:Refresh(getPlayerList(), true)
      Rayfield:Notify({Title = "Success", Content = "Daftar player diperbarui!", Duration = 2})
   end,
})

local function getTargetPlayer()
   if selectedTargetName == "" or selectedTargetName == "Tidak ada player lain" then return nil end
   return game.Players:FindFirstChild(selectedTargetName)
end

TrollTab:CreateButton({
   Name = "Teleport Ke Target",
   Callback = function()
      local target = getTargetPlayer()
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         humanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
         Rayfield:Notify({Title = "Berhasil", Content = "Teleport ke " .. target.Name, Duration = 2})
      else
         Rayfield:Notify({Title = "Gagal", Content = "Pilih target dengan benar di dropdown!", Duration = 2})
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
         Rayfield:Notify({Title = "Gagal", Content = "Pilih target dengan benar di dropdown!", Duration = 2})
      end
   end,
})

-- FITUR BARU PENGGANTI STONE: SLOW & NO JUMP
TrollTab:CreateToggle({
   Name = "Troll: Slow & No Jump (Jalan Siput & Gak Bisa Loncat)",
   CurrentValue = false,
   Callback = function(Value)
      isSlowNoJump = Value
      if not isSlowNoJump then
         local target = getTargetPlayer()
         if target and target.Character then
            local tHum = target.Character:FindFirstChildOfClass("Humanoid")
            if tHum then
               tHum.WalkSpeed = 16
               tHum.JumpPower = 50
               tHum.JumpHeight = 7.2
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
-- SISTEM FISIKA (FLY, SLOW/NO JUMP, & RIFLE TROLL LOOP)
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
   -- Logika Slow & No Jump Target (Pengganti Stone)
   if isSlowNoJump and selectedTargetName ~= "" then
      local target = getTargetPlayer()
      if target and target.Character then
         local tHum = target.Character:FindFirstChildOfClass("Humanoid")
         if tHum then
            tHum.WalkSpeed = 4 -- Jalan sangat lambat (seperti siput)
            tHum.JumpPower = 0 -- Tidak bisa loncat sama sekali
            tHum.JumpHeight = 0
         end
      end
   end

   -- Logika Rifle Jumpscare
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
