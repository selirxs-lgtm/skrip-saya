local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Roblox Pro Menu | Fly & Troll",
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

-- Tab Utama
local MainTab = Window:CreateTab("Fly & Movement", 4483362458)
local TrollTab = Window:CreateTab("Teleport & Troll", 4483362458)

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
-- TAB 2: TELEPORT & TROLL (DENGAN DROPDOWN)
--------------------------------------------------

-- Fungsi Mengambil Daftar Nama Player (Kecuali Diri Sendiri)
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
   Flag = "PlayerDropdown",
   Callback = function(Option)
      -- Rayfield Dropdown callback bisa berupa string atau tabel string tergantung versi, kita amankan:
      if type(Option) == "table" then
         selectedTargetName = Option[1] or ""
      else
         selectedTargetName = tostring(Option)
      end
   end,
})

-- Tombol untuk Refresh / Perbarui Daftar Player di Dropdown
TrollTab:CreateButton({
   Name = "🔄 Refresh Daftar Player",
   Callback = function()
      PlayerDropdown:Refresh(getPlayerList())
      Rayfield:Notify({Title = "Refresh", Content = "Daftar player diperbarui!", Duration = 2})
   end,
})

-- Fungsi Mendapatkan Objek Player dari Nama yang Dipilih
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
         Rayfield:Notify({Title = "Gagal", Content = "Pilih target player yang valid dulu!", Duration = 2})
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
         Rayfield:Notify({Title = "Gagal", Content = "Pilih target player yang valid dulu!", Duration = 2})
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
               tHum.PlatformStand = false
            end
         end
      end
   end,
})

--------------------------------------------------
-- SISTEM FISIKA (FLY & STUN LOOP)
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

game:GetService("RunService").RenderStepped:Connect(function()
   -- Logika Stun Target
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
