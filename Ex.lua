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
local aiming = false
local aimbotSmooth = 0.25 
local fovRadius = 120    
local ESP_FOLDER_NAME = "ESP_Storage"

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedMenuV7_1"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Lingkaran FOV di Tengah Layar
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
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Parent = FOVCircle

-- Top Detector
local TopDetector = Instance.new("TextLabel")
TopDetector.Size = UDim2.new(0, 200, 0, 35)
TopDetector.Position = UDim2.new(0.5, -100, 0, 10)
TopDetector.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TopDetector.BackgroundTransparency = 0.3
TopDetector.Text = "Players Detected: 0"
TopDetector.TextColor3 = Color3.fromRGB(0, 255, 150)
TopDetector.TextSize = 14
TopDetector.Font = Enum.Font.SourceSansBold
TopDetector.Parent = ScreenGui

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 6)
TopCorner.Parent = TopDetector

-- Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 460)
MainFrame.Position = UDim2.new(0.5, -120, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ROBLOX MENU V7.1 (ULTRA GOD)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Close Button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Helper Function to Create Toggle Buttons
local function createButton(posY, defaultText)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 210, 0, 35)
    btn.Position = UDim2.new(0.5, -105, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Text = defaultText .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local ToggleESP = createButton(45, "ESP")
local ToggleAim = createButton(85, "AIMBOT (BODY/HEAD)")
local ToggleGod = createButton(125, "UNLIMITED HEALTH")
local ToggleFOV = createButton(165, "FOV CIRCLE") 
local ToggleSizeFOV = createButton(205, "FOV SIZE: 120") 
local ToggleNoclip = createButton(245, "WALLHACK (NOCLIP)")
local ToggleSpeed = createButton(285, "SUPER SPEED")
local ToggleJump = createButton(325, "SUPER JUMP")

-- Info Label
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, 0, 0, 25)
InfoText.Position = UDim2.new(0, 0, 0, 375)
InfoText.BackgroundTransparency = 1
InfoText.Text = "Hold Right-Click for Aimbot"
InfoText.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoText.TextSize = 12
InfoText.Font = Enum.Font.SourceSansItalic
InfoText.Parent = MainFrame

-- Open Button
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 100, 0, 30)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
OpenButton.Text = "OPEN MENU"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 12
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 6)
OpenCorner.Parent = OpenButton

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
-- Aimbot Logic: Mengunci ke Seluruh Bagian Tubuh
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
            label.TextSize = 14
            label.Font = Enum.Font.SourceSansBold
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
            beam.Width0 = 0.05
            beam.Width1 = 0.05
            beam.FaceCamera = true
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 50, 50))
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

    -- 2. Sticky Aimbot Execution
    if aimbotEnabled and aiming then
        local targetPart = getClosestPartInFOV()
        if targetPart then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.lookAt(currentCF.Position, targetPart.Position)
            Camera.CFrame = currentCF:Lerp(targetCF, aimbotSmooth)
        end
    end

    -- 3. Ultra God Mode Execution
    if godModeEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            pcall(function()
                hum.BreakJointsOnDeath = false
            end)
        end
    end

    -- 4. Noclip Execution
    if noclipEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- 5. Super Speed & Super Jump Execution
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if speedEnabled then
            hum.WalkSpeed = 100
        end
        if jumpEnabled then
            hum.JumpPower = 150
        end
    end
end)

-- Button Click Handlers
local function setupToggle(button, onText, offText, callback)
    button.MouseButton1Click:Connect(function()
        if button.Text:find("OFF") then
            button.Text = onText .. ": ON"
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            callback(true)
        else
            button.Text = offText .. ": OFF"
            button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            callback(false)
        end
    end)
end

setupToggle(ToggleESP, "ESP", "ESP", function(state) espEnabled = state if not state then espFolder:ClearAllChildren() end end)
setupToggle(ToggleAim, "AIMBOT (BODY/HEAD)", "AIMBOT (BODY/HEAD)", function(state) aimbotEnabled = state end)
setupToggle(ToggleGod, "UNLIMITED HEALTH", "UNLIMITED HEALTH", function(state) godModeEnabled = state end)

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

setupToggle(ToggleSpeed, "SUPER SPEED", "SUPER SPEED", function(state) 
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

-- Close / Open Menu Logic
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

Players.PlayerRemoving:Connect(removeESP)
