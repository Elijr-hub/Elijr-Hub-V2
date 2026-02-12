-- Elijr hub Booster – Jump & Speed Edition
local fenv = getfenv()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local VelocityConnection
local Enabled = false
local Speed = 25
local JumpPower = 50 -- Default Roblox jump is 50

fenv.StartVelocityMove = function()
    if VelocityConnection then return end

    VelocityConnection = RunService.Heartbeat:Connect(function()
        local Character = LocalPlayer.Character
        if not Character then return end

        local HRP = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not HRP or not Humanoid then return end

        -- Apply Jump Power
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = JumpPower

        local MoveDir = Humanoid.MoveDirection
        if MoveDir.Magnitude == 0 then return end

        local FlatDir = Vector3.new(MoveDir.X, 0, MoveDir.Z).Unit
        local Boost = FlatDir * Speed

        HRP.Velocity = Vector3.new(
            Boost.X,
            HRP.Velocity.Y,
            Boost.Z
        )
    end)
end

fenv.StopVelocityMove = function()
    if VelocityConnection then
        VelocityConnection:Disconnect()
        VelocityConnection = nil
    end
    -- Reset Jump to default when off
    if LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then Humanoid.JumpPower = 50 end
    end
end

-- ────────────────────────────────────────────────────────────────
--                           GUI
-- ────────────────────────────────────────────────────────────────

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ElijrHubBooster"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size       = UDim2.new(0, 180, 0, 200) -- Increased height for Jump input
MainFrame.Position   = UDim2.new(1, -200, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active     = true
MainFrame.Draggable  = true
MainFrame.Parent     = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Color = Color3.fromRGB(255, 215, 0)
Stroke.Thickness = 2.5
Stroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size            = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text            = "Elijr hub Booster"
Title.TextColor3      = Color3.fromRGB(255, 255, 0)
Title.TextSize        = 16
Title.Font            = Enum.Font.GothamBlack
Title.Parent          = MainFrame

-- Speed Input Section
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size            = UDim2.new(1, -20, 0, 20)
SpeedLabel.Position        = UDim2.new(0, 10, 0, 35)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text            = "Speed"
SpeedLabel.TextColor3      = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextSize        = 12
SpeedLabel.Font            = Enum.Font.GothamSemibold
SpeedLabel.TextXAlignment  = Enum.TextXAlignment.Left
SpeedLabel.Parent          = MainFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size               = UDim2.new(1, -20, 0, 28)
SpeedBox.Position           = UDim2.new(0, 10, 0, 55)
SpeedBox.BackgroundColor3   = Color3.fromRGB(25, 25, 25)
SpeedBox.Text               = tostring(Speed)
SpeedBox.TextColor3         = Color3.fromRGB(255, 255, 255)
SpeedBox.Font               = Enum.Font.Gotham
SpeedBox.Parent             = MainFrame
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 6)

-- Jump Input Section
local JumpLabel = Instance.new("TextLabel")
JumpLabel.Size            = UDim2.new(1, -20, 0, 20)
JumpLabel.Position        = UDim2.new(0, 10, 0, 85)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text            = "Jump Power"
JumpLabel.TextColor3      = Color3.fromRGB(200, 200, 200)
JumpLabel.TextSize        = 12
JumpLabel.Font            = Enum.Font.GothamSemibold
JumpLabel.TextXAlignment  = Enum.TextXAlignment.Left
JumpLabel.Parent          = MainFrame

local JumpBox = Instance.new("TextBox")
JumpBox.Size               = UDim2.new(1, -20, 0, 28)
JumpBox.Position           = UDim2.new(0, 10, 0, 105)
JumpBox.BackgroundColor3   = Color3.fromRGB(25, 25, 25)
JumpBox.Text               = tostring(JumpPower)
JumpBox.TextColor3         = Color3.fromRGB(255, 255, 255)
JumpBox.Font               = Enum.Font.Gotham
JumpBox.Parent             = MainFrame
Instance.new("UICorner", JumpBox).CornerRadius = UDim.new(0, 6)

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size            = UDim2.new(1, -20, 0, 35)
ToggleButton.Position        = UDim2.new(0, 10, 1, -45)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text            = "BOOST → OFF"
ToggleButton.TextColor3      = Color3.fromRGB(255, 255, 255)
ToggleButton.Font            = Enum.Font.GothamBold
ToggleButton.Parent          = MainFrame
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)
local btnStroke = Instance.new("UIStroke", ToggleButton)
btnStroke.Color = Color3.fromRGB(255, 215, 0)

-- ────────────────────────────────────────────────────────────────
--                         Logic
-- ────────────────────────────────────────────────────────────────

local function updateToggleVisuals()
    if Enabled then
        ToggleButton.Text = "BOOST → ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        Title.Text = "BOOST ACTIVE"
    else
        ToggleButton.Text = "BOOST → OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Text = "Elijr hub Booster"
    end
end

SpeedBox.FocusLost:Connect(function()
    Speed = tonumber(SpeedBox.Text) or 25
    SpeedBox.Text = tostring(Speed)
end)

JumpBox.FocusLost:Connect(function()
    JumpPower = tonumber(JumpBox.Text) or 50
    JumpBox.Text = tostring(JumpPower)
    if Enabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = JumpPower end
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        fenv.StartVelocityMove()
    else
        fenv.StopVelocityMove()
    end
    updateToggleVisuals()
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.6)
    if Enabled then fenv.StartVelocityMove() end
end)

updateToggleVisuals()
print("Elijr hub Booster (Speed & Jump) loaded!")
