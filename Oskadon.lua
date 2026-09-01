--[[
    SPEED MENU ULTRA V5 - Rayfield Edition
    Lebih stabil, jarang error, UI modern
]]

local success, err = pcall(function()
    -- Load Rayfield
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer

    -- ====================== SETTINGS ======================
    local DEFAULT_SPEED = 16
    local DEFAULT_JUMP = 50
    local DEFAULT_FLY = 60
    local DEFAULT_GRAVITY = 196.2
    local DEFAULT_HIP = 2

    local speed = DEFAULT_SPEED
    local jumpPower = DEFAULT_JUMP
    local flySpeed = DEFAULT_FLY
    local gravity = DEFAULT_GRAVITY
    local hipHeight = DEFAULT_HIP

    local speedEnabled = true
    local jumpEnabled = true
    local infiniteJump = false
    local flying = false
    local noclip = false
    local sprinting = false
    local forceApply = true

    local character, humanoid, root
    local connections = {}
    local flyVelocity, flyOrientation, flyAttachment

    -- ====================== FUNCTIONS ======================
    local function disconnect(name)
        if connections[name] then
            connections[name]:Disconnect()
            connections[name] = nil
        end
    end

    local function refreshCharacter(char)
        character = char
        humanoid = char:WaitForChild("Humanoid", 5)
        root = char:WaitForChild("HumanoidRootPart", 5)
        if humanoid then
            humanoid.UseJumpPower = true
        end
    end

    local function targetSpeed()
        if not speedEnabled then return DEFAULT_SPEED end
        if sprinting then
            return math.clamp(speed * 1.75, 16, 1500)
        end
        return speed
    end

    local function applySpeed()
        if humanoid then
            humanoid.WalkSpeed = targetSpeed()
        end
    end

    local function applyJump()
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = jumpEnabled and jumpPower or 0
        end
    end

    local function applyGravity()
        workspace.Gravity = gravity
    end

    local function applyHip()
        if humanoid then
            humanoid.HipHeight = hipHeight
        end
    end

    local function setNoclip(state)
        noclip = state
        disconnect("noclip")
        if noclip then
            connections.noclip = RunService.Stepped:Connect(function()
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    local function stopFly()
        flying = false
        disconnect("fly")
        if flyVelocity then pcall(function() flyVelocity:Destroy() end) end
        if flyOrientation then pcall(function() flyOrientation:Destroy() end) end
        if flyAttachment then pcall(function() flyAttachment:Destroy() end) end
        flyVelocity, flyOrientation, flyAttachment = nil, nil, nil
        if humanoid then humanoid.PlatformStand = false end
    end

    local function startFly()
        if not humanoid or not root then return false end
        stopFly()
        flying = true
        humanoid.PlatformStand = true

        flyAttachment = Instance.new("Attachment")
        flyAttachment.Parent = root

        flyVelocity = Instance.new("LinearVelocity")
        flyVelocity.Attachment0 = flyAttachment
        flyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
        flyVelocity.MaxForce = math.huge
        flyVelocity.VectorVelocity = Vector3.zero
        flyVelocity.Parent = root

        flyOrientation = Instance.new("AlignOrientation")
        flyOrientation.Attachment0 = flyAttachment
        flyOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        flyOrientation.MaxTorque = math.huge
        flyOrientation.Responsiveness = 40
        flyOrientation.Parent = root

        connections.fly = RunService.RenderStepped:Connect(function()
            if not flying or not root or not root.Parent then
                stopFly()
                return
            end
            local cam = workspace.CurrentCamera
            if not cam then return end

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

            flyVelocity.VectorVelocity = dir
            flyOrientation.CFrame = CFrame.lookAt(Vector3.zero, cam.CFrame.LookVector)
        end)
        return true
    end

    -- Infinite Jump
    connections.jump = UserInputService.JumpRequest:Connect(function()
        if infiniteJump and jumpEnabled and humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Force Apply
    connections.force = RunService.Heartbeat:Connect(function()
        if forceApply and humanoid then
            if speedEnabled and humanoid.WalkSpeed \~= targetSpeed() then
                humanoid.WalkSpeed = targetSpeed()
            end
            if jumpEnabled and humanoid.JumpPower \~= jumpPower then
                humanoid.JumpPower = jumpPower
            end
        end
    end)

    -- Character Handling
    player.CharacterAdded:Connect(function(char)
        stopFly()
        task.wait(0.3)
        refreshCharacter(char)
        applySpeed()
        applyJump()
        applyHip()
        if noclip then
            task.wait(0.1)
            setNoclip(true)
        end
    end)

    if player.Character then
        refreshCharacter(player.Character)
    end

    -- ====================== RAYFIELD UI ======================
    local Window = Rayfield:CreateWindow({
        Name = "⚡ Speed Menu Ultra V5",
        LoadingTitle = "Speed Menu Ultra",
        LoadingSubtitle = "by Grok",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "SpeedMenuUltra",
            FileName = "Config"
        },
        KeySystem = false
    })

    -- Tab Speed
    local SpeedTab = Window:CreateTab("Speed", 4483362458)

    SpeedTab:CreateSection("Walk Speed")

    SpeedTab:CreateSlider({
        Name = "Walk Speed",
        Range = {16, 1500},
        Increment = 1,
        CurrentValue = 16,
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

    -- Tab Jump
    local JumpTab = Window:CreateTab("Jump", 4483362458)

    JumpTab:CreateSection("Jump Settings")

    JumpTab:CreateSlider({
        Name = "Jump Power",
        Range = {50, 600},
        Increment = 1,
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

    -- Tab Fly
    local FlyTab = Window:CreateTab("Fly & Noclip", 4483362458)

    FlyTab:CreateSection("Fly")

    FlyTab:CreateSlider({
        Name = "Fly Speed",
        Range = {10, 600},
        Increment = 1,
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

    -- Tab Extra
    local ExtraTab = Window:CreateTab("Extra", 4483362458)

    ExtraTab:CreateSection("World")

    ExtraTab:CreateSlider({
        Name = "Gravity",
        Range = {0, 500},
        Increment = 1,
        CurrentValue = 196,
        Flag = "Gravity",
        Callback = function(Value)
            gravity = Value
            applyGravity()
        end,
    })

    ExtraTab:CreateSlider({
        Name = "Hip Height",
        Range = {0, 10},
        Increment = 0.1,
        CurrentValue = 2,
        Flag = "HipHeight",
        Callback = function(Value)
            hipHeight = Value
            applyHip()
        end,
    })

    ExtraTab:CreateSection("Utility")

    ExtraTab:CreateButton({
        Name = "Reset All to Default",
        Callback = function()
            speed = DEFAULT_SPEED
            jumpPower = DEFAULT_JUMP
            flySpeed = DEFAULT_FLY
            gravity = DEFAULT_GRAVITY
            hipHeight = DEFAULT_HIP
            speedEnabled = true
            jumpEnabled = true
            infiniteJump = false
            sprinting = false
            forceApply = true
            stopFly()
            setNoclip(false)

            applySpeed()
            applyJump()
            applyGravity()
            applyHip()

            Rayfield:Notify({
                Title = "Reset",
                Content = "Semua setting dikembalikan ke default",
                Duration = 3
            })
        end,
    })

    -- Notify sukses
    Rayfield:Notify({
        Title = "Speed Menu Ultra V5",
        Content = "Berhasil dimuat! Tekan RightControl untuk buka/tutup",
        Duration = 6
    })

    print("[Speed Menu Ultra V5 - Rayfield] Loaded!")
end)

if not success then
    warn("Error loading Speed Menu:", err)
end
