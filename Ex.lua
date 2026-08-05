local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local espEnabled = false
local aimbotEnabled = false
local aiming = false
local ESP_FOLDER_NAME = "ESP_Storage"

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedEspAimbotMenu"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Menu Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 220)
MainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "ESP & AIMBOT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Toggle ESP Button
local ToggleESP = Instance.new("TextButton")
ToggleESP.Size = UDim2.new(0, 180, 0, 40)
ToggleESP.Position = UDim2.new(0.5, -90, 0, 40)
ToggleESP.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleESP.Text = "ESP: OFF"
ToggleESP.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleESP.TextSize = 14
ToggleESP.Font = Enum.Font.SourceSansBold
ToggleESP.Parent = MainFrame

local Corner1 = Instance.new("UICorner")
Corner1.CornerRadius = UDim.new(0, 6)
Corner1.Parent = ToggleESP

-- Toggle Aimbot Button
local ToggleAim = Instance.new("TextButton")
ToggleAim.Size = UDim2.new(0, 180, 0, 40)
ToggleAim.Position = UDim2.new(0.5, -90, 0, 90)
ToggleAim.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleAim.Text = "AIMBOT HEAD: OFF"
ToggleAim.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAim.TextSize = 14
ToggleAim.Font = Enum.Font.SourceSansBold
ToggleAim.Parent = MainFrame

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 6)
Corner2.Parent = ToggleAim

-- Player Detector Display
local DetectorText = Instance.new("TextLabel")
DetectorText.Size = UDim2.new(0, 180, 0, 30)
DetectorText.Position = UDim2.new(0.5, -90, 0, 170)
DetectorText.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
DetectorText.Text = "Players Detected: 0"
DetectorText.TextColor3 = Color3.fromRGB(0, 255, 150)
DetectorText.TextSize = 13
DetectorText.Font = Enum.Font.SourceSansBold
DetectorText.Parent = MainFrame

local Corner3 = Instance.new("UICorner")
Corner3.CornerRadius = UDim.new(0, 6)
Corner3.Parent = DetectorText

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
-- Aimbot Logic (Auto Aim Head)
-----------------------------------------
local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Mouse hold listener (Right Click to Aim)
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

        -- Name Tag above head
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

        -- Tracer Line attached directly to HEAD
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
            
            -- Position at top of the head
            local headTopPos = head.Position + Vector3.new(0, 0.8, 0)
            local screenOrigin = Camera:ViewportPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            local groundPos = screenOrigin.Origin + (screenOrigin.Direction * 2)

            att0.Position = headTopPos
            att1.Position = groundPos
        else
            beam.Enabled = false
        end
    end

    -- Update Detector Counter
    if espEnabled then
        DetectorText.Text = "Players Detected: " .. tostring(detectedCount)
    else
        DetectorText.Text = "Players Detected: 0"
    end

    -- 2. Aimbot Execution
    if aimbotEnabled and aiming then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- Button Listeners
ToggleESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ToggleESP.Text = "ESP: ON"
        ToggleESP.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleESP.Text = "ESP: OFF"
        ToggleESP.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        espFolder:ClearAllChildren()
    end
end)

ToggleAim.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        ToggleAim.Text = "AIMBOT HEAD: ON"
        ToggleAim.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleAim.Text = "AIMBOT HEAD: OFF"
        ToggleAim.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

Players.PlayerRemoving:Connect(removeESP)
