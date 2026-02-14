--[[
    ╔══════════════════════════════════════╗
    ║   RanZx Modern Fly GUI V1.0          ║
    ║   Created by RanZx                   ║
    ║   Features:                          ║
    ║   • Smooth Flying System             ║
    ║   • Speed Control Slider             ║
    ║   • Keybind Toggle (E)               ║
    ║   • Mobile Support                   ║
    ║   • Modern UI Design                 ║
    ╚══════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Settings
local FlyEnabled = false
local FlySpeed = 50
local MaxSpeed = 200
local ToggleKey = Enum.KeyCode.E

-- Fly System Variables
local BodyVelocity
local BodyGyro
local FlyConnection

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RanZxFlyGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Check if GUI already exists
if LocalPlayer.PlayerGui:FindFirstChild("RanZxFlyGUI") then
    LocalPlayer.PlayerGui:FindFirstChild("RanZxFlyGUI"):Destroy()
end

ScreenGui.Parent = LocalPlayer.PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 320)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Add Corner to Main Frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Add Shadow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 10, 10)
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

-- Fix bottom corners
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 15)
TitleFix.Position = UDim2.new(0, 0, 1, -15)
TitleFix.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "✈️ RanZx Fly GUI"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -45, 0, 7.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔴 Fly: INACTIVE"
StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Parent = ContentFrame

-- Fly Toggle Button
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Size = UDim2.new(1, 0, 0, 50)
FlyButton.Position = UDim2.new(0, 0, 0, 40)
FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
FlyButton.Text = "TERBANG"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 18
FlyButton.Font = Enum.Font.GothamBold
FlyButton.BorderSizePixel = 0
FlyButton.Parent = ContentFrame

local FlyButtonCorner = Instance.new("UICorner")
FlyButtonCorner.CornerRadius = UDim.new(0, 10)
FlyButtonCorner.Parent = FlyButton

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0, 0, 0, 100)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize = 14
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = ContentFrame

-- Speed Slider Background
local SliderBG = Instance.new("Frame")
SliderBG.Name = "SliderBG"
SliderBG.Size = UDim2.new(1, 0, 0, 8)
SliderBG.Position = UDim2.new(0, 0, 0, 135)
SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SliderBG.BorderSizePixel = 0
SliderBG.Parent = ContentFrame

local SliderBGCorner = Instance.new("UICorner")
SliderBGCorner.CornerRadius = UDim.new(0, 4)
SliderBGCorner.Parent = SliderBG

-- Speed Slider Fill
local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(0.25, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(0, 4)
SliderFillCorner.Parent = SliderFill

-- Slider Draggable Button
local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0.25, -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderBG

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(1, 0)
SliderButtonCorner.Parent = SliderButton

-- Control Buttons Frame
local ControlFrame = Instance.new("Frame")
ControlFrame.Name = "ControlFrame"
ControlFrame.Size = UDim2.new(1, 0, 0, 80)
ControlFrame.Position = UDim2.new(0, 0, 0, 160)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = ContentFrame

-- UP Button
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Size = UDim2.new(0, 80, 0, 35)
UpButton.Position = UDim2.new(0.5, -40, 0, 0)
UpButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
UpButton.Text = "▲ ATAS"
UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpButton.TextSize = 14
UpButton.Font = Enum.Font.GothamBold
UpButton.BorderSizePixel = 0
UpButton.Parent = ControlFrame

local UpButtonCorner = Instance.new("UICorner")
UpButtonCorner.CornerRadius = UDim.new(0, 8)
UpButtonCorner.Parent = UpButton

-- DOWN Button
local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(0, 80, 0, 35)
DownButton.Position = UDim2.new(0.5, -40, 0, 45)
DownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
DownButton.Text = "▼ TURUN"
DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DownButton.TextSize = 14
DownButton.Font = Enum.Font.GothamBold
DownButton.BorderSizePixel = 0
DownButton.Parent = ControlFrame

local DownButtonCorner = Instance.new("UICorner")
DownButtonCorner.CornerRadius = UDim.new(0, 8)
DownButtonCorner.Parent = DownButton

-- Keybind Label
local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Name = "KeybindLabel"
KeybindLabel.Size = UDim2.new(1, 0, 0, 20)
KeybindLabel.Position = UDim2.new(0, 0, 1, -25)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "Press [E] to toggle fly"
KeybindLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
KeybindLabel.TextSize = 12
KeybindLabel.Font = Enum.Font.Gotham
KeybindLabel.Parent = ContentFrame

-- Credit Label
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Position = UDim2.new(0, 0, 1, -5)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "by RanZx"
CreditLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
CreditLabel.TextSize = 12
CreditLabel.Font = Enum.Font.GothamBold
CreditLabel.Parent = ContentFrame

-- Functions
local function UpdateStatus(active)
    if active then
        StatusLabel.Text = "🟢 Fly: ACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(70, 255, 70)
        FlyButton.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        FlyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    else
        StatusLabel.Text = "🔴 Fly: INACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
        FlyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

local function StartFlying()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Create BodyVelocity
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = humanoidRootPart
    
    -- Create BodyGyro
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    BodyGyro.P = 3000
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
    UpdateStatus(FlyEnabled)
    
    if FlyEnabled then
        StartFlying()
    else
        StopFlying()
    end
end

-- Slider Function
local dragging = false

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = SliderBG.AbsolutePosition
        local sliderSize = SliderBG.AbsoluteSize
        
        local relativePos = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        
        SliderButton.Position = UDim2.new(relativePos, -10, 0.5, -10)
        SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        
        FlySpeed = math.floor(relativePos * MaxSpeed)
        if FlySpeed < 10 then FlySpeed = 10 end
        SpeedLabel.Text = "Speed: " .. FlySpeed
    end
end)

-- Button Animations
local function ButtonAnimation(button, hoverColor, clickColor, normalColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = clickColor}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = hoverColor}):Play()
    end)
end

-- Apply Animations
ButtonAnimation(FlyButton, Color3.fromRGB(50, 50, 55), Color3.fromRGB(30, 30, 35), Color3.fromRGB(40, 40, 45))
ButtonAnimation(UpButton, Color3.fromRGB(50, 50, 55), Color3.fromRGB(30, 30, 35), Color3.fromRGB(40, 40, 45))
ButtonAnimation(DownButton, Color3.fromRGB(50, 50, 55), Color3.fromRGB(30, 30, 35), Color3.fromRGB(40, 40, 45))
ButtonAnimation(CloseButton, Color3.fromRGB(255, 90, 90), Color3.fromRGB(255, 50, 50), Color3.fromRGB(255, 70, 70))

-- Button Events
FlyButton.MouseButton1Click:Connect(ToggleFly)

UpButton.MouseButton1Down:Connect(function()
    local character = LocalPlayer.Character
    if not character or not FlyEnabled then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = hrp.Velocity + Vector3.new(0, FlySpeed * 0.5, 0)
    end
end)

DownButton.MouseButton1Down:Connect(function()
    local character = LocalPlayer.Character
    if not character or not FlyEnabled then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = hrp.Velocity - Vector3.new(0, FlySpeed * 0.5, 0)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    StopFlying()
    ScreenGui:Destroy()
end)

-- Keybind Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == ToggleKey then
        ToggleFly()
    end
end)

-- Entrance Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local entranceTween = TweenService:Create(
    MainFrame,
    TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 280, 0, 320),
        Position = UDim2.new(0.5, -140, 0.5, -160)
    }
)
entranceTween:Play()

-- Console Output
print("════════════════════════════════════")
print("✈️ RanZx Fly GUI V1.0 Loaded!")
print("════════════════════════════════════")
print("Controls:")
print("• Press [E] to toggle fly")
print("• WASD to move")
print("• Space/Shift to go up/down")
print("• Drag slider to change speed")
print("════════════════════════════════════")
print("Created by RanZx 🚀")
print("════════════════════════════════════")
