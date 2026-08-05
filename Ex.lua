--[[ 
  SKRIP ESP DENGAN GARIS & NAMA 
  Petunjuk: Jalankan skrip ini di executor Roblox Anda.
  Skrip ini memiliki GUI untuk menyalakan/mematikan ESP.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local espEnabled = false
local ESP_FOLDER_NAME = "ESP_Storage"

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EspMenuWithTracers"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, -65)
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
Title.Text = "ESP + TRACERS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 180, 0, 45)
ToggleButton.Position = UDim2.new(0.5, -90, 0.5, -5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "ESP: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-----------------------------------------
-- ESP Logic using Roblox Instances
-----------------------------------------

-- Create a folder to manage ESP instances easily
local espFolder = workspace:FindFirstChild(ESP_FOLDER_NAME)
if espFolder then espFolder:Destroy() end
espFolder = Instance.new("Folder")
espFolder.Name = ESP_FOLDER_NAME
espFolder.Parent = workspace

-- Function to remove ESP from a specific player
local function removeESP(player)
    if not player or not player.Name then return end
    local tag = espFolder:FindFirstChild(player.Name .. "_ESP")
    if tag then
        tag:Destroy()
    end
end

-- Function to apply/update ESP (Lines and Names) for all players
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local character = player.Character
        local head = character and character:FindFirstChild("Head")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        -- If ESP is disabled or player invalid, ensure they have no ESP instances
        if not espEnabled or not character or not head or not rootPart then
            removeESP(player)
            continue
        end

        -- Check if ScreenPoint is on screen
        local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

        -- Get or create the container tag for this player
        local tag = espFolder:FindFirstChild(player.Name .. "_ESP")
        if not tag then
            tag = Instance.new("Model")
            tag.Name = player.Name .. "_ESP"
            tag.Parent = espFolder
        end

        -- --- 1. NAME ESP (BillboardGui) ---
        local billboard = tag:FindFirstChild("NameTag")
        if not billboard then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "NameTag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.ExtentsOffset = Vector3.new(0, 3, 0) -- Position above head
            billboard.AlwaysOnTop = true -- See through walls
            
            local label = Instance.new("TextLabel")
            label.Name = "PlayerName"
            label.Parent = billboard
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextColor3 = Color3.fromRGB(255, 255, 255) -- White
            label.TextStrokeTransparency = 0 -- Outline
            label.TextSize = 16
            label.Font = Enum.Font.SourceSansBold
        end
        billboard.Adornee = head
        billboard:FindFirstChild("PlayerName").Text = player.Name
        billboard.Parent = tag


        -- --- 2. TRACER (Beam/Attachment) ---
        -- Beams are efficient and don't require the Drawing API
        local att0 = tag:FindFirstChild("PlayerAtt")
        local att1 = tag:FindFirstChild("ScreenAtt")
        local beam = tag:FindFirstChild("TracerBeam")

        if not att0 then
            att0 = Instance.new("Attachment", workspace.Terrain) -- Needs static parent
            att0.Name = "PlayerAtt"
        end
        if not att1 then
            att1 = Instance.new("Attachment", workspace.Terrain) -- Needs static parent
            att1.Name = "ScreenAtt"
        end
        if not beam then
            beam = Instance.new("Beam")
            beam.Name = "TracerBeam"
            beam.Width0 = 0.05
            beam.Width1 = 0.05
            beam.FaceCamera = true
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)) -- Red
            beam.Transparency = NumberSequence.new(0)
        end

        -- Update Tracer Positions
        if onScreen then
            beam.Enabled = true
            -- Set Beam start/end
            beam.Attachment0 = att1
            beam.Attachment1 = att0
            beam.Parent = tag
            
            -- Point on the ground below the player
            local playerPos = rootPart.Position - Vector3.new(0, 3, 0)
            
            -- Determine screen origin (Middle-Bottom)
            local screenOrigin = Camera:ViewportPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            local groundPos = screenOrigin.Origin + (screenOrigin.Direction * 2)

            att0.Position = playerPos
            att1.Position = groundPos
        else
            beam.Enabled = false
        end
    end
end

-----------------------------------------
-- Connections & Events
-----------------------------------------

-- Update ESP every frame
RunService.RenderStepped:Connect(updateESP)

-- Remove ESP instances when players leave
Players.PlayerRemoving:Connect(removeESP)

-- Toggle Button Event
ToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ToggleButton.Text = "ESP: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "ESP: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        -- Clear ESP folder immediately when disabled
        espFolder:ClearAllChildren()
    end
end)
