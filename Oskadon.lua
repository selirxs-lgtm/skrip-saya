--[[
    SPEED MENU ULTRA V4
    Made to beat ChatGPT's version
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ====================== CONFIG ======================
local DEFAULT_SPEED   = 16
local DEFAULT_JUMP    = 50
local DEFAULT_FLY     = 60
local DEFAULT_GRAVITY = 196.2
local DEFAULT_HIP     = 2

local MIN_SPEED, MAX_SPEED     = 16, 1500
local MIN_JUMP, MAX_JUMP       = 50, 600
local MIN_FLY, MAX_FLY         = 10, 600
local MIN_GRAVITY, MAX_GRAVITY = 0, 500
local MIN_HIP, MAX_HIP         = 0, 10

local SPRINT_MULTIPLIER = 1.75

-- State
local speed, jumpPower, flySpeed = DEFAULT_SPEED, DEFAULT_JUMP, DEFAULT_FLY
local gravity, hipHeight = DEFAULT_GRAVITY, DEFAULT_HIP
local speedEnabled, jumpEnabled = true, true
local infiniteJump, flying, noclip, sprinting, forceApply = false, false, false, false, true

local character, humanoid, root
local connections = {}
local flyVelocity, flyOrientation, flyAttachment
local customPresets = {}
local savedConfig = nil

-- ====================== UTILS ======================
local function disconnect(name)
    if connections[name] then
        connections[name]:Disconnect()
        connections[name] = nil
    end
end

local function cleanupAll()
    for name in pairs(connections) do
        disconnect(name)
    end
end

local function refreshCharacter(char)
    character = char
    humanoid = char:WaitForChild("Humanoid", 8)
    root = char:WaitForChild("HumanoidRootPart", 8)
    if humanoid then
        humanoid.UseJumpPower = true
    end
end

local function targetSpeed()
    if not speedEnabled then return DEFAULT_SPEED end
    if sprinting then
        return math.clamp(speed * SPRINT_MULTIPLIER, MIN_SPEED, MAX_SPEED)
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

local function updateNoclip()
    if not character then return end
    for _, obj in ipairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanCollide = not noclip
        end
    end
end

local function setNoclip(state)
    noclip = state
    disconnect("noclip")
    if noclip then
        updateNoclip()
        connections.noclip = RunService.Stepped:Connect(function()
            if character then
                for _, obj in ipairs(character:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.CanCollide = false
                    end
                end
            end
        end)
    else
        updateNoclip()
    end
end

local function stopFly()
    flying = false
    disconnect("fly")
    if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
    if flyOrientation then flyOrientation:Destroy() flyOrientation = nil end
    if flyAttachment then flyAttachment:Destroy() flyAttachment = nil end
    if humanoid then humanoid.PlatformStand = false end
end

local function startFly()
    if not humanoid or not root then return false end
    stopFly()
    flying = true
    humanoid.PlatformStand = true

    flyAttachment = Instance.new("Attachment")
    flyAttachment.Name = "UltraFlyAtt"
    flyAttachment.Parent = root

    flyVelocity = Instance.new("LinearVelocity")
    flyVelocity.Name = "UltraFlyVel"
    flyVelocity.Attachment0 = flyAttachment
    flyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    flyVelocity.MaxForce = math.huge
    flyVelocity.VectorVelocity = Vector3.zero
    flyVelocity.Parent = root

    flyOrientation = Instance.new("AlignOrientation")
    flyOrientation.Name = "UltraFlyOri"
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
connections.jumpRequest = UserInputService.JumpRequest:Connect(function()
    if infiniteJump and jumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Force Apply (biar susah di-reset game)
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
    task.wait(0.25)
    refreshCharacter(char)
    applySpeed()
    applyJump()
    applyHip()
    if noclip then
        task.wait(0.1)
        updateNoclip()
    end
end)

if player.Character then
    refreshCharacter(player.Character)
end

-- ====================== GUI ======================
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedMenuUltraV4"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(380, 620)
main.Position = UDim2.new(0.5, -190, 0.5, -310)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(60, 60, 90)
stroke.Thickness = 1.8

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 20)
titleFix.Position = UDim2.new(0, 0, 1, -20)
titleFix.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 1, 0)
title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ SPEED MENU ULTRA V4"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(34, 34)
closeBtn.Position = UDim2.new(1, -42, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.fromOffset(34, 34)
miniBtn.Position = UDim2.new(1, -82, 0, 8)
miniBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
miniBtn.Text = "—"
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.TextSize = 18
miniBtn.Font = Enum.Font.GothamBold
miniBtn.Parent = titleBar
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)

-- Dragging
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -62)
content.Position = UDim2.fromOffset(10, 56)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = Color3.fromRGB(90, 90, 140)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 9)
list.SortOrder = Enum.SortOrder.LayoutOrder

local pad = Instance.new("UIPadding", content)
pad.PaddingBottom = UDim.new(0, 16)
pad.PaddingTop = UDim.new(0, 4)

-- Helpers
local function section(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 22)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(140, 140, 190)
    l.TextSize = 13
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = content
    return l
end

local function button(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    return b
end

local function inputBox(placeholder, default)
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.PlaceholderColor3 = Color3.fromRGB(120, 120, 145)
    b.PlaceholderText = placeholder
    b.Text = tostring(default)
    b.TextSize = 15
    b.Font = Enum.Font.Gotham
    b.ClearTextOnFocus = false
    b.Parent = content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
    return b
end

local function statusButton(offText, onText)
    local b = button(offText, Color3.fromRGB(55, 55, 75))
    local function setState(state)
        b.Text = state and onText or offText
        b.BackgroundColor3 = state and Color3.fromRGB(35, 165, 70) or Color3.fromRGB(55, 55, 75)
    end
    return b, setState
end

local function createSlider(min, max, current, onChanged)
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 26)
    slider.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    slider.Text = ""
    slider.AutoButtonColor = false
    slider.Parent = content
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 8)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(55, 130, 255)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    fill.Parent = slider
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 8)

    local function update(val)
        val = math.clamp(math.floor(val), min, max)
        fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        onChanged(val)
    end

    local draggingSlider = false
    local function calc(input)
        local ratio = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        update(min + ratio * (max - min))
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            calc(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            calc(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    return update
end

-- ====================== SECTIONS ======================

-- WALK SPEED
section("WALK SPEED")
local speedInput = inputBox("Speed (16 - 1500)", speed)
speedInput.FocusLost:Connect(function()
    local n = tonumber(speedInput.Text)
    if n then
        speed = math.clamp(math.floor(n), MIN_SPEED, MAX_SPEED)
        speedInput.Text = tostring(speed)
        applySpeed()
    else
        speedInput.Text = tostring(speed)
    end
end)

local updateSpeedSlider = createSlider(MIN_SPEED, MAX_SPEED, speed, function(val)
    speed = val
    speedInput.Text = tostring(speed)
    applySpeed()
end)

local speedToggle, setSpeedToggle = statusButton("● SPEED: OFF", "● SPEED: ON")
setSpeedToggle(true)
speedToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    setSpeedToggle(speedEnabled)
    applySpeed()
end)

-- JUMP
section("JUMP")
local jumpInput = inputBox("Jump Power (50 - 600)", jumpPower)
jumpInput.FocusLost:Connect(function()
    local n = tonumber(jumpInput.Text)
    if n then
        jumpPower = math.clamp(math.floor(n), MIN_JUMP, MAX_JUMP)
        jumpInput.Text = tostring(jumpPower)
        applyJump()
    else
        jumpInput.Text = tostring(jumpPower)
    end
end)

local updateJumpSlider = createSlider(MIN_JUMP, MAX_JUMP, jumpPower, function(val)
    jumpPower = val
    jumpInput.Text = tostring(jumpPower)
    applyJump()
end)

local jumpToggle, setJumpToggle = statusButton("Jump: OFF", "Jump: ON")
setJumpToggle(true)
jumpToggle.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    setJumpToggle(jumpEnabled)
    applyJump()
end)

local infBtn, setInf = statusButton("Infinite Jump: OFF", "Infinite Jump: ON")
infBtn.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    setInf(infiniteJump)
end)

-- FLY
section("FLY")
local flyInput = inputBox("Fly Speed (10 - 600)", flySpeed)
flyInput.FocusLost:Connect(function()
    local n = tonumber(flyInput.Text)
    if n then
        flySpeed = math.clamp(math.floor(n), MIN_FLY, MAX_FLY)
        flyInput.Text = tostring(flySpeed)
    else
        flyInput.Text = tostring(flySpeed)
    end
end)

local updateFlySlider = createSlider(MIN_FLY, MAX_FLY, flySpeed, function(val)
    flySpeed = val
    flyInput.Text = tostring(flySpeed)
end)

local flyBtn, setFly = statusButton("Fly: OFF", "Fly: ON")
flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        setFly(false)
    else
        setFly(startFly())
    end
end)

-- MOVEMENT
section("MOVEMENT")
local sprintBtn, setSprint = statusButton("Sprint: OFF", "Sprint: ON")
sprintBtn.MouseButton1Click:Connect(function()
    sprinting = not sprinting
    setSprint(sprinting)
    applySpeed()
end)

local noclipBtn, setNoclipBtn = statusButton("Noclip: OFF", "Noclip: ON")
noclipBtn.MouseButton1Click:Connect(function()
    setNoclip(not noclip)
    setNoclipBtn(noclip)
end)

local forceBtn, setForce = statusButton("Force Apply: OFF", "Force Apply: ON")
setForce(true)
forceBtn.MouseButton1Click:Connect(function()
    forceApply = not forceApply
    setForce(forceApply)
end)

-- EXTRA
section("EXTRA")
local gravInput = inputBox("Gravity (0 - 500)", gravity)
gravInput.FocusLost:Connect(function()
    local n = tonumber(gravInput.Text)
    if n then
        gravity = math.clamp(n, MIN_GRAVITY, MAX_GRAVITY)
        gravInput.Text = tostring(gravity)
        applyGravity()
    else
        gravInput.Text = tostring(gravity)
    end
end)

local hipInput = inputBox("Hip Height (0 - 10)", hipHeight)
hipInput.FocusLost:Connect(function()
    local n = tonumber(hipInput.Text)
    if n then
        hipHeight = math.clamp(n, MIN_HIP, MAX_HIP)
        hipInput.Text = tostring(hipHeight)
        applyHip()
    else
        hipInput.Text = tostring(hipHeight)
    end
end)

-- PRESETS
section("CUSTOM PRESETS (5 SLOT)")
for i = 1, 5 do
    local b = button("Preset " .. i .. " — Empty", Color3.fromRGB(40, 85, 170))
    b.MouseButton1Click:Connect(function()
        if customPresets[i] then
            local p = customPresets[i]
            speed = p.speed
            jumpPower = p.jump
            flySpeed = p.fly
            gravity = p.grav or DEFAULT_GRAVITY
            hipHeight = p.hip or DEFAULT_HIP

            speedInput.Text = tostring(speed)
            jumpInput.Text = tostring(jumpPower)
            flyInput.Text = tostring(flySpeed)
            gravInput.Text = tostring(gravity)
            hipInput.Text = tostring(hipHeight)

            updateSpeedSlider(speed)
            updateJumpSlider(jumpPower)
            updateFlySlider(flySpeed)

            applySpeed()
            applyJump()
            applyGravity()
            applyHip()

            b.Text = "Preset " .. i .. " — Loaded"
            task.delay(1.1, function()
                if b.Parent then b.Text = "Preset " .. i .. " — Save" end
            end)
        else
            customPresets[i] = {
                speed = speed,
                jump = jumpPower,
                fly = flySpeed,
                grav = gravity,
                hip = hipHeight
            }
            b.Text = "Preset " .. i .. " — Saved"
            task.delay(1.1, function()
                if b.Parent then b.Text = "Preset " .. i .. " — Save" end
            end)
        end
    end)
end

-- CONFIG
section("CONFIG")
local saveBtn = button("💾 SAVE CONFIG", Color3.fromRGB(40, 115, 165))
saveBtn.MouseButton1Click:Connect(function()
    savedConfig = {
        speed = speed,
        jump = jumpPower,
        fly = flySpeed,
        gravity = gravity,
        hip = hipHeight,
        speedEnabled = speedEnabled,
        jumpEnabled = jumpEnabled,
        infiniteJump = infiniteJump,
        forceApply = forceApply
    }
    saveBtn.Text = "✓ CONFIG SAVED"
    task.delay(1.2, function()
        if saveBtn.Parent then saveBtn.Text = "💾 SAVE CONFIG" end
    end)
end)

local loadBtn = button("↥ LOAD CONFIG", Color3.fromRGB(40, 115, 165))
loadBtn.MouseButton1Click:Connect(function()
    if not savedConfig then
        loadBtn.Text = "No saved config"
        task.delay(1.2, function()
            if loadBtn.Parent then loadBtn.Text = "↥ LOAD CONFIG" end
        end)
        return
    end
    local c = savedConfig
    speed = c.speed
    jumpPower = c.jump
    flySpeed = c.fly
    gravity = c.gravity or DEFAULT_GRAVITY
    hipHeight = c.hip or DEFAULT_HIP
    speedEnabled = c.speedEnabled
    jumpEnabled = c.jumpEnabled
    infiniteJump = c.infiniteJump
    forceApply = c.forceApply

    speedInput.Text = tostring(speed)
    jumpInput.Text = tostring(jumpPower)
    flyInput.Text = tostring(flySpeed)
    gravInput.Text = tostring(gravity)
    hipInput.Text = tostring(hipHeight)

    updateSpeedSlider(speed)
    updateJumpSlider(jumpPower)
    updateFlySlider(flySpeed)

    setSpeedToggle(speedEnabled)
    setJumpToggle(jumpEnabled)
    setInf(infiniteJump)
    setForce(forceApply)

    applySpeed()
    applyJump()
    applyGravity()
    applyHip()

    loadBtn.Text = "✓ CONFIG LOADED"
    task.delay(1.2, function()
        if loadBtn.Parent then loadBtn.Text = "↥ LOAD CONFIG" end
    end)
end)

local resetBtn = button("↻ RESET ALL", Color3.fromRGB(175, 70, 40))
resetBtn.MouseButton1Click:Connect(function()
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

    speedInput.Text = tostring(speed)
    jumpInput.Text = tostring(jumpPower)
    flyInput.Text = tostring(flySpeed)
    gravInput.Text = tostring(gravity)
    hipInput.Text = tostring(hipHeight)

    updateSpeedSlider(speed)
    updateJumpSlider(jumpPower)
    updateFlySlider(flySpeed)

    setSpeedToggle(true)
    setJumpToggle(true)
    setInf(false)
    setSprint(false)
    setFly(false)
    setNoclipBtn(false)
    setForce(true)

    applySpeed()
    applyJump()
    applyGravity()
    applyHip()
end)

-- Minimize / Close
local minimized = false
miniBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(380, 50) or UDim2.fromOffset(380, 620)
    miniBtn.Text = minimized and "+" or "—"
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- Keybind
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Initial
applySpeed()
applyJump()
applyGravity()
applyHip()

print("[Speed Menu Ultra V4] Loaded successfully.")
print("RightShift = Toggle Menu")
