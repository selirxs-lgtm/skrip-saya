local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local espEnabled = false
local aimbotEnabled = false
local fovCircleVisible = false 
local godModeEnabled = false
local noclipEnabled = false
local speedEnabled = false
local jumpEnabled = false
local autoTeleportEnabled = false
local autoKillEnabled = false

local aiming = false
local aimbotSmooth = 0.25 
local fovRadius = 120    
local ESP_FOLDER_NAME = "ESP_Storage"

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedMenuV8"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Lingkaran FOV
local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = ScreenGui

local UICircle = Instance.new("UICorner")
UICircle.CornerRadius = UDim.new(1, 0)
UICircle.Parent = FOVCircle

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(0, 255, 200)
UIStroke.Parent = FOVCircle

-- Top Detector
local TopDetector = Instance.new("TextLabel")
TopDetector.Size = UDim2.new(0, 220, 0, 32)
TopDetector.Position = UDim2.new(0.5, -110, 0, 12)
TopDetector.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
TopDetector.BackgroundTransparency = 0.2
TopDetector.Text = "Players Detected: 0"
TopDetector.TextColor3 = Color3.fromRGB(0, 255, 150)
TopDetector.TextSize = 13
TopDetector.Font = Enum.Font.GothamBold
TopDetector.Parent = ScreenGui

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopDetector

local TopStroke = Instance.new("UIStroke")
TopStroke.Color = Color3.fromRGB(50, 50, 70)
TopStroke.Parent = TopDetector

-- Menu Frame (Modern UI Style)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 530)
MainFrame.Position = UDim2.new(0.5, -130, 0.18, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 80)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Bar / Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ROBLOX MENU V8"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

-- Close Button (Modern Minimalist X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -36, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Scrollable Content Area
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -95)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 430)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutIndex
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollingFrame

-- Helper Function for Modern Buttons
local function createButton(order, defaultText)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Text = defaultText .. " : OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.Parent = ScrollingFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 55, 70)
    stroke.Thickness = 1
    stroke.Parent = btn

    return btn
end

local ToggleESP = createButton(1, "ESP")
local ToggleAim = createButton(2, "AIMBOT (BODY/HEAD)")
local ToggleGod = createButton(3, "UNLIMITED HEALTH")
local ToggleTeleport = createButton(4, "AUTO TELEPORT TO ENEMY")
local ToggleKill = createButton(5, "AUTO KILL (INSTANT)")
local ToggleFOV = createButton(6, "FOV CIRCLE") 
local ToggleSizeFOV = createButton(7, "FOV SIZE: 120") 
local ToggleNoclip = createButton(8, "WALLHACK (NOCLIP)")
local ToggleSpeed = createButton(9, "SUPER SPEED (EXTREME)")
local ToggleJump = createButton(10, "SUPER JUMP")

-- Footer Info
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 35)
Footer.Position = UDim2.new(0, 0, 1, -38)
Footer.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
Footer.Parent = MainFrame

local FooterCorner = Instance.new("UICorner")
FooterCorner.CornerRadius = UDim.new(0, 12)
FooterCorner.Parent = Footer

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, 0, 1, 0)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Hold Right-Click for Aimbot"
InfoText.TextColor3 = Color3.fromRGB(130, 130, 150)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.GothamItalic
InfoText.Parent = Footer

-- Open Menu Floating Button (Modern Circular/Rounded Pill Style)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 120, 0, 38)
OpenButton.Position = UDim2.new(0, 15, 0, 15)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
OpenButton.Text = "⚡ OPEN MENU"
OpenButton.TextColor3 = Color3.fromRGB(15, 15, 20)
OpenButton.TextSize = 12
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 255, 255)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton

-----------------------------------------
-- ESP Storage Setup
-----------------------------------------
local espFolder = workspace:FindFirstChild(ESP_FOLDER_NAME)
if espFolder then espFolder:Destroy() end
espFolder = Instance.new("Folder")
espFolder.Name = ESP_FOLDER_NAME
espFolder.Parent = workspace

local function removeESP(player)
    if not player or not player.Name then return end
    local tag = espFolder:FindFirstChild(player.Name .. "_ESP")
    if tag then tag:Destroy() end
end

-----------------------------------------
-- Aimbot Target Logic
-----------------------------------------
local function getClosestPartInFOV()
    local closestPart = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                            local distanceToMouse = (screenVector - mousePos).Magnitude
                            
                            if distanceToMouse <= fovRadius and distanceToMouse < shortestDistance then
                                shortestDistance = distanceToMouse
                                closestPart = part
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPart
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = false
    end
end)

-----------------------------------------
-- Main Render Loop
-----------------------------------------
RunService.RenderStepped:Connect(function()
    local detectedCount = 0

    -- 1. ESP & Player Counter
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local character = player.Character
        local head = character and character:FindFirstChild("Head")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if not espEnabled or not character or not head or (humanoid and humanoid.Health <= 0) then
            removeESP(player)
            continue
        end

        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        local tag = espFolder:FindFirstChild(player.Name .. "_ESP")

        if not tag then
            tag = Instance.new("Model")
            tag.Name = player.Name .. "_ESP"
            tag.Parent = espFolder
        end

        local billboard = tag:FindFirstChild("NameTag")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "NameTag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            
            local label = Instance.new("TextLabel")
            label.Name = "PlayerName"
            label.Parent = billboard
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextStrokeTransparency = 0
            label.TextSize = 13
            label.Font = Enum.Font.GothamBold
        end
        billboard.Adornee = head
        billboard:FindFirstChild("PlayerName").Text = player.Name
        billboard.Parent = tag

        local att0 = tag:FindFirstChild("PlayerAtt")
        local att1 = tag:FindFirstChild("ScreenAtt")
        local beam = tag:FindFirstChild("TracerBeam")

        if not att0 then
            att0 = Instance.new("Attachment", workspace.Terrain)
            att0.Name = "PlayerAtt"
        end
        if not att1 then
            att1 = Instance.new("Attachment", workspace.Terrain)
            att1.Name = "ScreenAtt"
        end
        if not beam then
            beam = Instance.new("Beam")
            beam.Name = "TracerBeam"
            beam.Width0 = 0.04
            beam.Width1 = 0.04
            beam.FaceCamera = true
            beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 150))
            beam.Transparency = NumberSequence.new(0)
        end

        if onScreen then
            detectedCount = detectedCount + 1
            beam.Enabled = true
            beam.Attachment0 = att1
            beam.Attachment1 = att0
            beam.Parent = tag
            
            local headTopPos = head.Position + Vector3.new(0, 0.8, 0)
            local screenOrigin = Camera:ViewportPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            local groundPos = screenOrigin.Origin + (screenOrigin.Direction * 2)

            att0.Position = headTopPos
            att1.Position = groundPos
        else
            beam.Enabled = false
        end
    end

    if espEnabled then
        TopDetector.Text = "Players Detected: " .. tostring(detectedCount)
    else
        TopDetector.Text = "Players Detected: 0"
    end

    -- 2. Aimbot Execution
    if aimbotEnabled and aiming then
        local targetPart = getClosestPartInFOV()
        if targetPart then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.lookAt(currentCF.Position, targetPart.Position)
            Camera.CFrame = currentCF:Lerp(targetCF, aimbotSmooth)
        end
    end

    -- 3. God Mode (Anti-Death & Anti-Damage Loop)
    if godModeEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            pcall(function()
                hum.BreakJointsOnDeath = false
                hum.RequiresNeck = false
            end)
        end
    end

    -- 4. Auto Teleport to Enemy (Teleport instan di belakang musuh terdekat)
    if autoTeleportEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LocalPlayer.Character.HumanoidRootPart
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
                if enemyHum and enemyHum.Health > 0 then
                    myRoot.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    break
                end
            end
        end
    end

    -- 5. Auto Kill (Membuat HP musuh langsung jadi 0 secara otomatis)
    if autoKillEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
                if enemyHum and enemyHum.Health > 0 then
                    pcall(function()
                        enemyHum.Health = 0
                    end)
                end
            end
        end
    end

    -- 6. Noclip Execution
    if noclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- 7. Super Speed Extreme & Super Jump
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if speedEnabled then
            hum.WalkSpeed = 250 -- Jauh lebih kencang gila
        end
        if jumpEnabled then
            hum.JumpPower = 200
        end
    end
end)

-- Button State Manager
local function setupToggle(button, onText, offText, callback)
    button.MouseButton1Click:Connect(function()
        if button.Text:find("OFF") then
            button.Text = onText .. " : ON"
            button.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            callback(true)
        else
            button.Text = offText .. " : OFF"
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
            callback(false)
        end
    end)
end

setupToggle(ToggleESP, "ESP", "ESP", function(state) espEnabled = state if not state then espFolder:ClearAllChildren() end end)
setupToggle(ToggleAim, "AIMBOT (BODY/HEAD)", "AIMBOT (BODY/HEAD)", function(state) aimbotEnabled = state end)
setupToggle(ToggleGod, "UNLIMITED HEALTH", "UNLIMITED HEALTH", function(state) godModeEnabled = state end)
setupToggle(ToggleTeleport, "AUTO TELEPORT TO ENEMY", "AUTO TELEPORT TO ENEMY", function(state) autoTeleportEnabled = state end)
setupToggle(ToggleKill, "AUTO KILL (INSTANT)", "AUTO KILL (INSTANT)", function(state) autoKillEnabled = state end)

setupToggle(ToggleFOV, "FOV CIRCLE", "FOV CIRCLE", function(state) 
    fovCircleVisible = state 
    FOVCircle.Visible = state 
end)

ToggleSizeFOV.MouseButton1Click:Connect(function()
    if fovRadius == 120 then
        fovRadius = 180
    elseif fovRadius == 180 then
        fovRadius = 240
    elseif fovRadius == 240 then
        fovRadius = 300
    elseif fovRadius == 300 then
        fovRadius = 80
    else
        fovRadius = 120
    end
    FOVCircle.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
    ToggleSizeFOV.Text = "FOV SIZE: " .. tostring(fovRadius)
end)

setupToggle(ToggleNoclip, "WALLHACK (NOCLIP)", "WALLHACK (NOCLIP)", function(state) noclipEnabled = state end)

setupToggle(ToggleSpeed, "SUPER SPEED (EXTREME)", "SUPER SPEED (EXTREME)", function(state) 
    speedEnabled = state 
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)

setupToggle(ToggleJump, "SUPER JUMP", "SUPER JUMP", function(state) 
    jumpEnabled = state 
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)

-- Smooth Close/Open UI Toggle
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

Players.PlayerRemoving:Connect(removeESP)
