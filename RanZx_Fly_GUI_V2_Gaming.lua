--[[
    ╔══════════════════════════════════════╗
    ║   RanZx Fly GUI V2.0                 ║
    ║   Gaming Style Edition               ║
    ║   Created by RanZx                   ║
    ║   Features:                          ║
    ║   • Ultra Speed Flying (Max 300)     ║
    ║   • Gaming Red/Black Theme           ║
    ║   • Box Layout Design                ║
    ║   • Keybind Toggle (E)               ║
    ║   • Mobile Support                   ║
    ╚══════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Settings
local FlyEnabled = false
local FlySpeed = 100
local MaxSpeed = 300
local ToggleKey = Enum.KeyCode.E

-- Fly System Variables
local BodyVelocity
local BodyGyro
local FlyConnection

-- Colors (Gaming Red/Black Theme)
local MainColor = Color3.fromRGB(20, 20, 25)
local AccentColor = Color3.fromRGB(255, 50, 50)
local ButtonColor = Color3.fromRGB(35, 35, 40)
local TextColor = Color3.fromRGB(255, 255, 255)
local ActiveColor = Color3.fromRGB(255, 70, 70)

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RanZxFlyGUI_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Remove old GUI if exists
if LocalPlayer.PlayerGui:FindFirstChild("RanZxFlyGUI_V2") then
    LocalPlayer.PlayerGui:FindFirstChild("RanZxFlyGUI_V2"):Destroy()
end

ScreenGui.Parent = LocalPlayer.PlayerGui

-- Main Frame (Smaller & Box Style)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 280)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -140)
MainFrame.BackgroundColor3 = MainColor
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = AccentColor
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Top Border Line (Red)
local TopBorder = Instance.new("Frame")
TopBorder.Name = "TopBorder"
TopBorder.Size = UDim2.new(1, 0, 0, 3)
TopBorder.BackgroundColor3 = AccentColor
TopBorder.BorderSizePixel = 0
TopBorder.Parent = MainFrame

-- Title Section
local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Size = UDim2.new(1, 0, 0, 45)
TitleFrame.Position = UDim2.new(0, 0, 0, 3)
TitleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
TitleFrame.BorderSizePixel = 0
TitleFrame.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "GUI OLEH"
TitleText.TextColor3 = Color3.fromRGB(180, 180, 180)
TitleText.TextSize = 12
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleFrame

local CreatorText = Instance.new("TextLabel")
CreatorText.Size = UDim2.new(1, -20, 0, 20)
CreatorText.Position = UDim2.new(0, 10, 0, 18)
CreatorText.BackgroundTransparency = 1
CreatorText.Text = "RanZx"
CreatorText.TextColor3 = AccentColor
CreatorText.TextSize = 16
CreatorText.Font = Enum.Font.GothamBold
CreatorText.TextXAlignment = Enum.TextXAlignment.Left
CreatorText.Parent = TitleFrame

-- Speed Display Box (Center Big Number)
local SpeedBox = Instance.new("Frame")
SpeedBox.Name = "SpeedBox"
SpeedBox.Size = UDim2.new(0, 100, 0, 100)
SpeedBox.Position = UDim2.new(0.5, -50, 0, 60)
SpeedBox.BackgroundColor3 = ButtonColor
SpeedBox.BorderSizePixel = 2
SpeedBox.BorderColor3 = AccentColor
SpeedBox.Parent = MainFrame

local SpeedNumber = Instance.new("TextLabel")
SpeedNumber.Size = UDim2.new(1, 0, 1, 0)
SpeedNumber.BackgroundTransparency = 1
SpeedNumber.Text = "100"
SpeedNumber.TextColor3 = AccentColor
SpeedNumber.TextSize = 48
SpeedNumber.Font = Enum.Font.GothamBold
SpeedNumber.Parent = SpeedBox

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 15)
SpeedLabel.Position = UDim2.new(0, 0, 1, 5)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "SPEED"
SpeedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
SpeedLabel.TextSize = 10
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Parent = SpeedBox

-- Control Buttons Frame
local ControlFrame = Instance.new("Frame")
ControlFrame.Name = "ControlFrame"
ControlFrame.Size = UDim2.new(1, -30, 0, 100)
ControlFrame.Position = UDim2.new(0, 15, 0, 175)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

-- ATAS Button (UP)
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Size = UDim2.new(0, 90, 0, 40)
UpButton.Position = UDim2.new(0, 0, 0, 0)
UpButton.BackgroundColor3 = ButtonColor
UpButton.BorderSizePixel = 2
UpButton.BorderColor3 = AccentColor
UpButton.Text = "ATAS"
UpButton.TextColor3 = TextColor
UpButton.TextSize = 16
UpButton.Font = Enum.Font.GothamBold
UpButton.Parent = ControlFrame

local UpIcon = Instance.new("TextLabel")
UpIcon.Size = UDim2.new(1, 0, 0, 15)
UpIcon.Position = UDim2.new(0, 0, 0, -18)
UpIcon.BackgroundTransparency = 1
UpIcon.Text = "▲"
UpIcon.TextColor3 = AccentColor
UpIcon.TextSize = 14
UpIcon.Font = Enum.Font.GothamBold
UpIcon.Parent = UpButton

-- TURUN Button (DOWN)
local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(0, 90, 0, 40)
DownButton.Position = UDim2.new(1, -90, 0, 0)
DownButton.BackgroundColor3 = ButtonColor
DownButton.BorderSizePixel = 2
DownButton.BorderColor3 = AccentColor
DownButton.Text = "TURUN"
DownButton.TextColor3 = TextColor
DownButton.TextSize = 16
DownButton.Font = Enum.Font.GothamBold
DownButton.Parent = ControlFrame

local DownIcon = Instance.new("TextLabel")
DownIcon.Size = UDim2.new(1, 0, 0, 15)
DownIcon.Position = UDim2.new(0, 0, 0, -18)
DownIcon.BackgroundTransparency = 1
DownIcon.Text = "▼"
DownIcon.TextColor3 = AccentColor
DownIcon.TextSize = 14
DownIcon.Font = Enum.Font.GothamBold
DownIcon.Parent = DownButton

-- TERBANG Button (Main Toggle)
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Size = UDim2.new(1, 0, 0, 40)
FlyButton.Position = UDim2.new(0, 0, 0, 50)
FlyButton.BackgroundColor3 = ButtonColor
FlyButton.BorderSizePixel = 2
FlyButton.BorderColor3 = AccentColor
FlyButton.Text = "TERBANG"
FlyButton.TextColor3 = TextColor
FlyButton.TextSize = 18
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Parent = ControlFrame

-- Speed Control Frame
local SpeedControlFrame = Instance.new("Frame")
SpeedControlFrame.Name = "SpeedControlFrame"
SpeedControlFrame.Size = UDim2.new(1, -30, 0, 35)
SpeedControlFrame.Position = UDim2.new(0, 15, 1, -50)
SpeedControlFrame.BackgroundTransparency = 1
SpeedControlFrame.Parent = MainFrame

-- Speed - Button
local SpeedMinusBtn = Instance.new("TextButton")
SpeedMinusBtn.Name = "SpeedMinusBtn"
SpeedMinusBtn.Size = UDim2.new(0, 35, 0, 35)
SpeedMinusBtn.Position = UDim2.new(0, 0, 0, 0)
SpeedMinusBtn.BackgroundColor3 = ButtonColor
SpeedMinusBtn.BorderSizePixel = 2
SpeedMinusBtn.BorderColor3 = AccentColor
SpeedMinusBtn.Text = "-"
SpeedMinusBtn.TextColor3 = TextColor
SpeedMinusBtn.TextSize = 24
SpeedMinusBtn.Font = Enum.Font.GothamBold
SpeedMinusBtn.Parent = SpeedControlFrame

-- Speed + Button
local SpeedPlusBtn = Instance.new("TextButton")
SpeedPlusBtn.Name = "SpeedPlusBtn"
SpeedPlusBtn.Size = UDim2.new(0, 35, 0, 35)
SpeedPlusBtn.Position = UDim2.new(1, -35, 0, 0)
SpeedPlusBtn.BackgroundColor3 = ButtonColor
SpeedPlusBtn.BorderSizePixel = 2
SpeedPlusBtn.BorderColor3 = AccentColor
SpeedPlusBtn.Text = "+"
SpeedPlusBtn.TextColor3 = TextColor
SpeedPlusBtn.TextSize = 24
SpeedPlusBtn.Font = Enum.Font.GothamBold
SpeedPlusBtn.Parent = SpeedControlFrame

-- Speed Bar
local SpeedBar = Instance.new("Frame")
SpeedBar.Name = "SpeedBar"
SpeedBar.Size = UDim2.new(1, -80, 0, 8)
SpeedBar.Position = UDim2.new(0, 42, 0, 13)
SpeedBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpeedBar.BorderSizePixel = 1
SpeedBar.BorderColor3 = Color3.fromRGB(60, 60, 65)
SpeedBar.Parent = SpeedControlFrame

local SpeedFill = Instance.new("Frame")
SpeedFill.Name = "SpeedFill"
SpeedFill.Size = UDim2.new(0.33, 0, 1, 0)
SpeedFill.BackgroundColor3 = AccentColor
SpeedFill.BorderSizePixel = 0
SpeedFill.Parent = SpeedBar

-- Bottom Info
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 15)
InfoLabel.Position = UDim2.new(0, 0, 1, -18)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Press [E] to Toggle"
InfoLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
InfoLabel.TextSize = 10
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Parent = MainFrame

-- Functions
local function UpdateSpeedDisplay()
    SpeedNumber.Text = tostring(FlySpeed)
    local percent = FlySpeed / MaxSpeed
    SpeedFill.Size = UDim2.new(percent, 0, 1, 0)
    
    -- Color change based on speed
    if FlySpeed < 100 then
        SpeedNumber.TextColor3 = Color3.fromRGB(100, 200, 100)
    elseif FlySpeed < 200 then
        SpeedNumber.TextColor3 = Color3.fromRGB(255, 200, 50)
    else
        SpeedNumber.TextColor3 = AccentColor
    end
end

local function StartFlying()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Create BodyVelocity
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = humanoidRootPart
    
    -- Create BodyGyro
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.P = 9000
    BodyGyro.CFrame = humanoidRootPart.CFrame
    BodyGyro.Parent = humanoidRootPart
    
    -- Fly Loop
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not FlyEnabled then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- WASD Controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (camera.CFrame.LookVector * FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (camera.CFrame.LookVector * FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - (camera.CFrame.RightVector * FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + (camera.CFrame.RightVector * FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, FlySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, FlySpeed, 0)
        end
        
        if BodyVelocity then
            BodyVelocity.Velocity = moveDirection
        end
        
        if BodyGyro then
            BodyGyro.CFrame = camera.CFrame
        end
    end)
end

local function StopFlying()
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
end

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    
    if FlyEnabled then
        -- Active State
        FlyButton.BackgroundColor3 = ActiveColor
        FlyButton.Text = "TERBANG ✓"
        TopBorder.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        StartFlying()
    else
        -- Inactive State
        FlyButton.BackgroundColor3 = ButtonColor
        FlyButton.Text = "TERBANG"
        TopBorder.BackgroundColor3 = AccentColor
        StopFlying()
    end
end

local function ChangeSpeed(amount)
    FlySpeed = math.clamp(FlySpeed + amount, 10, MaxSpeed)
    UpdateSpeedDisplay()
end

-- Button Hover Effects
local function AddHoverEffect(button)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(
                math.min(originalColor.R * 255 + 20, 255),
                math.min(originalColor.G * 255 + 20, 255),
                math.min(originalColor.B * 255 + 20, 255)
            )
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if button ~= FlyButton or not FlyEnabled then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = originalColor
            }):Play()
        end
    end)
end

AddHoverEffect(UpButton)
AddHoverEffect(DownButton)
AddHoverEffect(FlyButton)
AddHoverEffect(SpeedMinusBtn)
AddHoverEffect(SpeedPlusBtn)

-- Button Events
FlyButton.MouseButton1Click:Connect(ToggleFly)

UpButton.MouseButton1Down:Connect(function()
    local character = LocalPlayer.Character
    if not character or not FlyEnabled then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = hrp.Velocity + Vector3.new(0, FlySpeed * 0.8, 0)
    end
end)

DownButton.MouseButton1Down:Connect(function()
    local character = LocalPlayer.Character
    if not character or not FlyEnabled then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = hrp.Velocity - Vector3.new(0, FlySpeed * 0.8, 0)
    end
end)

SpeedPlusBtn.MouseButton1Click:Connect(function()
    ChangeSpeed(10)
end)

SpeedMinusBtn.MouseButton1Click:Connect(function()
    ChangeSpeed(-10)
end)

-- Hold to change speed faster
local speedChangeConnection
SpeedPlusBtn.MouseButton1Down:Connect(function()
    task.wait(0.3)
    speedChangeConnection = RunService.Heartbeat:Connect(function()
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            ChangeSpeed(2)
        else
            if speedChangeConnection then
                speedChangeConnection:Disconnect()
            end
        end
    end)
end)

SpeedMinusBtn.MouseButton1Down:Connect(function()
    task.wait(0.3)
    speedChangeConnection = RunService.Heartbeat:Connect(function()
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            ChangeSpeed(-2)
        else
            if speedChangeConnection then
                speedChangeConnection:Disconnect()
            end
        end
    end)
end)

-- Keybind Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == ToggleKey then
        ToggleFly()
    end
end)

-- Initialize
UpdateSpeedDisplay()

-- Entrance Animation
MainFrame.Position = UDim2.new(0.5, -130, -0.5, 0)

local entranceTween = TweenService:Create(
    MainFrame,
    TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Position = UDim2.new(0.5, -130, 0.5, -140)}
)
entranceTween:Play()

-- Pulsing Border Effect
spawn(function()
    while MainFrame.Parent do
        if FlyEnabled then
            for i = 1, 10 do
                TopBorder.BackgroundColor3 = Color3.fromRGB(100, 255 - (i * 15), 100)
                task.wait(0.05)
            end
            for i = 1, 10 do
                TopBorder.BackgroundColor3 = Color3.fromRGB(100, 100 + (i * 15), 100)
                task.wait(0.05)
            end
        else
            task.wait(0.1)
        end
    end
end)

-- Console Output
print("════════════════════════════════════")
print("🔥 RanZx Fly GUI V2.0 Gaming Edition")
print("════════════════════════════════════")
print("Speed: 10-300 (Ultra Fast!)")
print("Theme: Red/Black Gaming Style")
print("════════════════════════════════════")
print("Controls:")
print("• [E] = Toggle Fly")
print("• WASD = Move")
print("• Space/Shift = Up/Down")
print("• +/- Buttons = Change Speed")
print("════════════════════════════════════")
print("Created by RanZx 🚀")
print("════════════════════════════════════")
