--[[
    ╔══════════════════════════════════════╗
    ║   RanZx Fly GUI V2.0 POLISHED        ║
    ║   Gaming Edition by RanZx            ║
    ║   Features:                          ║
    ║   • Ultra Speed (Max 300)            ║
    ║   • Gaming Red/Black Theme           ║
    ║   • Glow Effects & Gradients         ║
    ║   • Smooth Animations                ║
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
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Add Corner to Main Frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Add Glow Border
local GlowBorder = Instance.new("UIStroke")
GlowBorder.Color = Color3.fromRGB(255, 50, 50)
GlowBorder.Thickness = 2
GlowBorder.Transparency = 0.3
GlowBorder.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title Gradient
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 30, 30))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

-- Fix bottom corners
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleFixGradient = Instance.new("UIGradient")
TitleFixGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 30, 30))
}
TitleFixGradient.Rotation = 90
TitleFixGradient.Parent = TitleFix

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "✈️ RanZx Fly GUI"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.TextStrokeTransparency = 0.8
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -45, 0, 7.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = Color3.fromRGB(255, 70, 70)
CloseStroke.Thickness = 1.5
CloseStroke.Parent = CloseButton

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
StatusLabel.TextStrokeTransparency = 0.5
StatusLabel.Parent = ContentFrame

-- Fly Toggle Button
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Size = UDim2.new(1, 0, 0, 50)
FlyButton.Position = UDim2.new(0, 0, 0, 40)
FlyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
FlyButton.Text = "TERBANG"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 18
FlyButton.Font = Enum.Font.GothamBold
FlyButton.BorderSizePixel = 0
FlyButton.Parent = ContentFrame

local FlyButtonCorner = Instance.new("UICorner")
FlyButtonCorner.CornerRadius = UDim.new(0, 10)
FlyButtonCorner.Parent = FlyButton

local FlyButtonStroke = Instance.new("UIStroke")
FlyButtonStroke.Color = Color3.fromRGB(255, 50, 50)
FlyButtonStroke.Thickness = 2
FlyButtonStroke.Transparency = 0.5
FlyButtonStroke.Parent = FlyButton

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0, 0, 0, 100)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 100"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
SpeedLabel.TextSize = 15
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Parent = ContentFrame

-- Speed Slider Background
local SliderBG = Instance.new("Frame")
SliderBG.Name = "SliderBG"
SliderBG.Size = UDim2.new(1, 0, 0, 10)
SliderBG.Position = UDim2.new(0, 0, 0, 135)
SliderBG.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SliderBG.BorderSizePixel = 0
SliderBG.Parent = ContentFrame

local SliderBGCorner = Instance.new("UICorner")
SliderBGCorner.CornerRadius = UDim.new(0, 5)
SliderBGCorner.Parent = SliderBG

local SliderBGStroke = Instance.new("UIStroke")
SliderBGStroke.Color = Color3.fromRGB(50, 50, 55)
SliderBGStroke.Thickness = 1
SliderBGStroke.Parent = SliderBG

-- Speed Slider Fill
local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(0.33, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(0, 5)
SliderFillCorner.Parent = SliderFill

-- Slider Fill Gradient
local SliderGradient = Instance.new("UIGradient")
SliderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
}
SliderGradient.Parent = SliderFill

-- Slider Draggable Button
local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 22, 0, 22)
SliderButton.Position = UDim2.new(0.33, -11, 0.5, -11)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderBG

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(1, 0)
SliderButtonCorner.Parent = SliderButton

local SliderButtonStroke = Instance.new("UIStroke")
SliderButtonStroke.Color = Color3.fromRGB(255, 50, 50)
SliderButtonStroke.Thickness = 2
SliderButtonStroke.Parent = SliderButton

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
UpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
UpButton.Text = "▲ ATAS"
UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpButton.TextSize = 14
UpButton.Font = Enum.Font.GothamBold
UpButton.BorderSizePixel = 0
UpButton.Parent = ControlFrame

local UpButtonCorner = Instance.new("UICorner")
UpButtonCorner.CornerRadius = UDim.new(0, 8)
UpButtonCorner.Parent = UpButton

local UpButtonStroke = Instance.new("UIStroke")
UpButtonStroke.Color = Color3.fromRGB(255, 50, 50)
UpButtonStroke.Thickness = 1.5
UpButtonStroke.Transparency = 0.5
UpButtonStroke.Parent = UpButton

-- DOWN Button
local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(0, 80, 0, 35)
DownButton.Position = UDim2.new(0.5, -40, 0, 45)
DownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
DownButton.Text = "▼ TURUN"
DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DownButton.TextSize = 14
DownButton.Font = Enum.Font.GothamBold
DownButton.BorderSizePixel = 0
DownButton.Parent = ControlFrame

local DownButtonCorner = Instance.new("UICorner")
DownButtonCorner.CornerRadius = UDim.new(0, 8)
DownButtonCorner.Parent = DownButton

local DownButtonStroke = Instance.new("UIStroke")
DownButtonStroke.Color = Color3.fromRGB(255, 50, 50)
DownButtonStroke.Thickness = 1.5
DownButtonStroke.Transparency = 0.5
DownButtonStroke.Parent = DownButton

-- Keybind Label
local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Name = "KeybindLabel"
KeybindLabel.Size = UDim2.new(1, 0, 0, 20)
KeybindLabel.Position = UDim2.new(0, 0, 1, -25)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "Press [E] to toggle fly"
KeybindLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
KeybindLabel.TextSize = 11
KeybindLabel.Font = Enum.Font.Gotham
KeybindLabel.Parent = ContentFrame

-- Credit Label
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Position = UDim2.new(0, 0, 1, -5)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "by RanZx"
CreditLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
CreditLabel.TextSize = 12
CreditLabel.Font = Enum.Font.GothamBold
CreditLabel.Parent = ContentFrame

-- Functions
local function UpdateStatus(active)
    if active then
        StatusLabel.Text = "🟢 Fly: ACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        TweenService:Create(FlyButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        }):Play()
        
        TweenService:Create(FlyButtonStroke, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(100, 255, 100),
            Transparency = 0
        }):Play()
        
        TweenService:Create(GlowBorder, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(100, 255, 100),
            Transparency = 0
        }):Play()
    else
        StatusLabel.Text = "🔴 Fly: INACTIVE"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
        
        TweenService:Create(FlyButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        }):Play()
        
        TweenService:Create(FlyButtonStroke, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(255, 50, 50),
            Transparency = 0.5
        }):Play()
        
        TweenService:Create(GlowBorder, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(255, 50, 50),
            Transparency = 0.3
        }):Play()
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
    TweenService:Create(SliderButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 26, 0, 26)
    }):Play()
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        TweenService:Create(SliderButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = SliderBG.AbsolutePosition
        local sliderSize = SliderBG.AbsoluteSize
        
        local relativePos = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        
        SliderButton.Position = UDim2.new(relativePos, -11, 0.5, -11)
        SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        
        FlySpeed = math.floor(relativePos * MaxSpeed)
        if FlySpeed < 10 then FlySpeed = 10 end
        SpeedLabel.Text = "Speed: " .. FlySpeed
        
        -- Update color based on speed
        if FlySpeed < 100 then
            SpeedLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
        elseif FlySpeed < 200 then
            SpeedLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
        else
            SpeedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

-- Button Animations
local function ButtonAnimation(button, stroke)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        }):Play()
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Transparency = 0.2
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button == FlyButton and FlyEnabled then return end
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        }):Play()
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Transparency = 0.5
            }):Play()
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        }):Play()
    end)
end

-- Close Button Special Animation
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    }):Play()
end)

-- Apply Animations
ButtonAnimation(FlyButton, FlyButtonStroke)
ButtonAnimation(UpButton, UpButtonStroke)
ButtonAnimation(DownButton, DownButtonStroke)

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

CloseButton.MouseButton1Click:Connect(function()
    -- Exit animation
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    task.wait(0.3)
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
    TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {
        Size = UDim2.new(0, 280, 0, 320),
        Position = UDim2.new(0.5, -140, 0.5, -160)
    }
)
entranceTween:Play()

-- Breathing glow effect
spawn(function()
    while MainFrame.Parent do
        for i = 1, 20 do
            GlowBorder.Transparency = 0.3 + (i * 0.02)
            task.wait(0.05)
        end
        for i = 1, 20 do
            GlowBorder.Transparency = 0.7 - (i * 0.02)
            task.wait(0.05)
        end
    end
end)

-- Console Output
print("════════════════════════════════════")
print("🔥 RanZx Fly GUI V2.0 POLISHED")
print("════════════════════════════════════")
print("Features:")
print("• Max Speed: 300 (Ultra Fast!)")
print("• Red/Black Gaming Theme")
print("• Glow Effects & Gradients")
print("════════════════════════════════════")
print("Controls:")
print("• [E] = Toggle Fly")
print("• WASD = Move")
print("• Space/Shift = Up/Down")
print("• Drag Slider = Change Speed")
print("════════════════════════════════════")
print("Created by RanZx 🚀")
print("════════════════════════════════════")
