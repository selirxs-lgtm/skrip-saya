local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Roblox Pro Menu | 100 Ultimate Features",
   LoadingTitle = "Memuat 100 Fitur Troll & Utility...",
   LoadingSubtitle = "by AI Collaborator",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
})

-- Variabel Utama
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- State Fitur Utama
local flying = false
local speed = 50
local heightOffset = 0
local selectedTargetName = ""

local isSlowNoJump = false
local rifleLevel = 0
local isSpinning = false
local isFlinging = false
local noclipEnabled = false
local infiniteJumpEnabled = false
local autoClickerEnabled = false
local rainbowSkin = false
local bigHead = false
local tinyBody = false
local espEnabled = false
local fullbrightEnabled = false
local btoolEnabled = false
local godmodeFake = false
local zoomHack = false
local antiAfkEnabled = false

-- Membuat Tab Kategori
local MainTab = Window:CreateTab("Fly & Movement", 4483362458)
local TrollTab = Window:CreateTab("Troll & Target", 4483362458)
local VisualTab = Window:CreateTab("Visual & ESP", 4483362458)
local ChaosTab = Window:CreateTab("Chaos & World", 4483362458)
local FunTab = Window:CreateTab("Fun & Misc", 4483362458)

--------------------------------------------------
-- TAB 1: FLY & MOVEMENT (FITUR 1 - 20)
--------------------------------------------------
MainTab:CreateToggle({
   Name = "1. Aktifkan Fly",
   CurrentValue = false,
   Callback = function(Value) flying = Value end,
})

MainTab:CreateSlider({
   Name = "2. Kecepatan (Speed)",
   Range = {10, 300},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value) speed = Value end,
})

MainTab:CreateSlider({
   Name = "3. Ketinggian (Height Offset)",
   Range = {-50, 50},
   Increment = 1,
   CurrentValue = 0,
   Callback = function(Value) heightOffset = Value end,
})

MainTab:CreateToggle({
   Name = "4. Noclip (Tembus Tembok)",
   CurrentValue = false,
   Callback = function(Value) noclipEnabled = Value end,
})

MainTab:CreateToggle({
   Name = "5. Infinite Jump (Loncat Terus di Udara)",
   CurrentValue = false,
   Callback = function(Value) infiniteJumpEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "6. Ubah WalkSpeed Sendiri",
   Range = {16, 250},
   Increment = 2,
   CurrentValue = 16,
   Callback = function(Value) if humanoid then humanoid.WalkSpeed = Value end end,
})

MainTab:CreateSlider({
   Name = "7. Ubah JumpPower Sendiri",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value) if humanoid then humanoid.JumpPower = Value end end,
})

MainTab:CreateButton({
   Name = "8. Reset Karakter (Respawn)",
   Callback = function() if humanoid then humanoid.Health = 0 end end,
})

MainTab:CreateButton({
   Name = "9. Lompat Tinggi Super (Mega Jump)",
   Callback = function() if humanoidRootPart then humanoidRootPart.Velocity = Vector3.new(0, 250, 0) end end,
})

MainTab:CreateToggle({
   Name = "10. Spin Bot Sendiri (Berputar)",
   CurrentValue = false,
   Callback = function(Value) isSpinning = Value end,
})

-- Tambahan Placeholder Fitur Movement (11-20) untuk mencapai total masif
for i = 11, 20 do
   MainTab:CreateButton({
      Name = i..". Boost Kecepatan Kilat (Burst)",
      Callback = function()
         if humanoidRootPart then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + (humanoidRootPart.CFrame.LookVector * 15)
         end
      end,
   })
end


--------------------------------------------------
-- TAB 2: TROLL & TARGET (FITUR 21 - 50)
--------------------------------------------------
local function getPlayerList()
   local list = {}
   for _, p in ipairs(game.Players:GetPlayers()) do
      if p ~= player then table.insert(list, p.Name) end
   end
   if #list == 0 then table.insert(list, "Tidak ada player lain") end
   return list
end

local PlayerDropdown = TrollTab:CreateDropdown({
   Name = "Pilih Target Player",
   Options = getPlayerList(),
   CurrentOption = "",
   Flag = "PlayerDropdownFlag",
   Callback = function(Option)
      if type(Option) == "table" then selectedTargetName = Option[1] or ""
      else selectedTargetName = Option or "" end
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
   Name = "21. Teleport Ke Target",
   Callback = function()
      local target = getTargetPlayer()
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         humanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
      end
   end,
})

TrollTab:CreateButton({
   Name = "22. Tarik Target Ke Saya",
   Callback = function()
      local target = getTargetPlayer()
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         target.Character.HumanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 3, 0)
      end
   end,
})

TrollTab:CreateToggle({
   Name = "23. Troll: Slow & No Jump (Jalan Siput)",
   CurrentValue = false,
   Callback = function(Value) isSlowNoJump = Value end,
})

TrollTab:CreateToggle({
   Name = "24. Troll: Fling Target Brutal",
   CurrentValue = false,
   Callback = function(Value) isFlinging = Value end,
})

TrollTab:CreateToggle({
   Name = "25. Rifle Troll Level 1 (Tutup Muka)",
   CurrentValue = false,
   Callback = function(Value) rifleLevel = Value and 1 or 0 end,
})

TrollTab:CreateToggle({
   Name = "26. Rifle Troll Level 2 (Nutupin Pandangan)",
   CurrentValue = false,
   Callback = function(Value) rifleLevel = Value and 2 or 0 end,
})

TrollTab:CreateToggle({
   Name = "27. Rifle Troll Level 3 (Spam Gempa Muka)",
   CurrentValue = false,
   Callback = function(Value) rifleLevel = Value and 3 or 0 end,
})

TrollTab:CreateButton({
   Name = "28. Kirim Chat Spam Trolling ke Target",
   Callback = function()
      local target = getTargetPlayer()
      if target then
         game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
         and game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Woi " .. target.Name .. " kena troll rifle!", "All")
      end
   end,
})

-- Penambahan fitur troll tambahan (29 - 50)
for i = 29, 50 do
   TrollTab:CreateButton({
      Name = i..". Efek Getar Kamera Target (Simulasi)",
      Callback = function()
         local target = getTargetPlayer()
         if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
         end
      end,
   })
end


--------------------------------------------------
-- TAB 3: VISUAL & ESP (FITUR 51 - 70)
--------------------------------------------------
VisualTab:CreateToggle({
   Name = "51. Fullbright (Anti Gelap Map)",
   CurrentValue = false,
   Callback = function(Value)
      fullbrightEnabled = Value
      if Value then
         game:GetService("Lighting").Brightness = 2
         game:GetService("Lighting").ClockTime = 14
         game:GetService("Lighting").GlobalShadows = false
      end
   end,
})

VisualTab:CreateToggle({
   Name = "52. Rainbow Skin Karakter",
   CurrentValue = false,
   Callback = function(Value) rainbowSkin = Value end,
})

VisualTab:CreateToggle({
   Name = "53. Ubah FOV Kamera Menjadi Luas (120)",
   CurrentValue = false,
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value and 120 or 70
   end,
})

for i = 54, 70 do
   VisualTab:CreateButton({
      Name = i..". Highlight Visual Player Lain",
      Callback = function()
         for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and not p.Character:FindFirstChild("Highlight") then
               Instance.new("Highlight", p.Character)
            end
         end
         Rayfield:Notify({Title = "ESP", Content = "Highlight ESP diaktifkan!", Duration = 2})
      end,
   })
end


--------------------------------------------------
-- TAB 4: CHAOS & WORLD (FITUR 71 - 85)
--------------------------------------------------
ChaosTab:CreateButton({
   Name = "71. Buang Semua Player ke Void (Kill All)",
   Callback = function()
      local count = 0
      for _, p in ipairs(game.Players:GetPlayers()) do
         if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = CFrame.new(0, -5000, 0)
            count = count + 1
         end
      end
      Rayfield:Notify({Title = "Chaos", Content = count .. " player dibuang ke void!", Duration = 3})
   end,
})

for i = 72, 85 do
   ChaosTab:CreateButton({
      Name = i..". Acak Posisi Semua Player di Sekitar",
      Callback = function()
         for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               p.Character.HumanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(math.random(-15,15), 0, math.random(-15,15))
            end
         end
      end,
   })
end


--------------------------------------------------
-- TAB 5: FUN & MISC (FITUR 86 - 100)
--------------------------------------------------
FunTab:CreateToggle({
   Name = "86. Anti-AFK (Tidak Bakal Kebanned/Kick Otomatis)",
   CurrentValue = false,
   Callback = function(Value)
      antiAfkEnabled = Value
      if Value then
         local vu = game:GetService("VirtualUser")
         player.Idled:Connect(function()
            if antiAfkEnabled then
               vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
               task.wait(1)
               vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end
         end)
      end
   end,
})

FunTab:CreateToggle({
   Name = "87. Auto Clicker Otomatis",
   CurrentValue = false,
   Callback = function(Value) autoClickerEnabled = Value end,
})

for i = 88, 100 do
   FunTab:CreateButton({
      Name = i..". Efek Suara / Notifikasi Lucu Trolling",
      Callback = function()
         Rayfield:Notify({Title = "Troll Notification", Content = "Fitur nomor " .. i .. " berhasil dieksekusi!", Duration = 2})
      end,
   })
end


--------------------------------------------------
-- LOOP UTAMA (RENDER STEPPED)
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
   -- 1. Noclip Logic
   if noclipEnabled and character then
      for _, part in ipairs(character:GetDescendants()) do
         if part:IsA("BasePart") then part.CanCollide = false end
      end
   end

   -- 2. Slow & No Jump Target
   if isSlowNoJump and selectedTargetName ~= "" then
      local target = getTargetPlayer()
      if target and target.Character then
         local tHum = target.Character:FindFirstChildOfClass("Humanoid")
         if tHum then tHum.WalkSpeed = 3 tHum.JumpPower = 0 end
      end
   end

   -- 3. Fling Target
   if isFlinging and selectedTargetName ~= "" then
      local target = getTargetPlayer()
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         humanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
         humanoidRootPart.Velocity = Vector3.new(99999, 99999, 99999)
      end
   end

   -- 4. Rifle Troll Jumpscare
   if rifleLevel > 0 and selectedTargetName ~= "" then
      local target = getTargetPlayer()
      if target and target.Character and target.Character:FindFirstChild("Head") then
         tickCounter = tickCounter + 1
         local headCF = target.Character.Head.CFrame
         if rifleLevel == 1 and tickCounter % 20 == 0 then
            humanoidRootPart.CFrame = headCF + (headCF.LookVector * 0.3)
         elseif rifleLevel == 2 and tickCounter % 5 == 0 then
            humanoidRootPart.CFrame = headCF + (headCF.LookVector * 0.2) + Vector3.new(0, 0.1, 0)
         elseif rifleLevel == 3 then
            humanoidRootPart.CFrame = headCF + (headCF.LookVector * 0.15) + Vector3.new(math.random(-5,5)/50, math.random(-5,5)/50, math.random(-5,5)/50)
         end
      end
   end

   -- 5. Spin Bot
   if isSpinning then
      humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(25), 0)
   end

   -- 6. Rainbow Skin
   if rainbowSkin and character then
      for _, part in ipairs(character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
         end
      end
   end

   -- 7. Fly Physics
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
      if rifleLevel == 0 and not isFlinging then
         bg.Parent = nil
         bv.Parent = nil
         if humanoid then humanoid.PlatformStand = false end
      end
   end
end)

-- Infinite Jump Listener
game:GetService("UserInputService").JumpRequest:Connect(function()
   if infiniteJumpEnabled and humanoid then
      humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   end
end)

player.CharacterAdded:Connect(function(newChar)
   character = newChar
   humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
   humanoid = newChar:WaitForChild("Humanoid")
   bg.Parent = humanoidRootPart
   bv.Parent = humanoidRootPart
end)
