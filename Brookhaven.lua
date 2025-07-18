--[[
    BrookCheat - Cheat Menu for BrookHaven RP
    Features:
    - Noclip (сквозь стены)
    - Fly (полет)
    - Anti-Ban (снимает бан в доме)
    - Teleport (телепорт по клику)
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local Gui = nil
local Minimized = false

local Features = {
    Noclip = false,
    Fly = false,
    AntiBan = false,
    FlySpeed = 50,
    FlyKeybind = Enum.KeyCode.E,
}

-- **NOCLIP**
local function NoclipLoop()
    if Features.Noclip and Character then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end

local function ToggleNoclip(State)
    Features.Noclip = State
    if State then
        RunService.Stepped:Connect(NoclipLoop)
    else
        if Character then
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end

-- **FLY**
local FlyConnection
local function StartFlying()
    if not RootPart then return end
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    BodyVelocity.Parent = RootPart

    FlyConnection = UIS.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if Input.KeyCode == Features.FlyKeybind then
            local Camera = workspace.CurrentCamera
            local Direction = Camera.CFrame.LookVector
            BodyVelocity.Velocity = Direction * Features.FlySpeed + Vector3.new(0, 5, 0)
        end
    end)
end

local function StopFlying()
    if FlyConnection then FlyConnection:Disconnect() end
    if RootPart and RootPart:FindFirstChild("BodyVelocity") then
        RootPart.BodyVelocity:Destroy()
    end
end

local function ToggleFly(State)
    Features.Fly = State
    if State then
        StartFlying()
    else
        StopFlying()
    end
end

-- **ANTI-BAN (снимает бан в доме)**
local function AntiBan()
    while Features.AntiBan and task.wait(1) do
        pcall(function()
            local HouseBanned = LocalPlayer:FindFirstChild("HouseBanned")
            if HouseBanned then
                HouseBanned:Destroy()
            end
        end)
    end
end

-- **TELEPORT (по клику)**
local function TeleportToPosition(Position)
    if not RootPart then return end
    local Tween = TweenService:Create(
        RootPart,
        TweenInfo.new(0.5, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(Position)}
    )
    Tween:Play()
end

Mouse.Button1Down:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        TeleportToPosition(Mouse.Hit.Position)
    end
end)

-- **GUI**
local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BrookCheat"
    ScreenGui.Parent = game.CoreGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.Text = "BrookCheat"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.Parent = MainFrame

    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Position = UDim2.new(1, -25, 0, 5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.new(0, 0, 0)
    MinimizeBtn.Font = Enum.Font.SourceSansBold
    MinimizeBtn.TextSize = 14
    MinimizeBtn.Parent = Title

    -- Minimized Frame
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
    MinimizedFrame.Position = UDim2.new(0.5, -25, 1, -60)
    MinimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.Parent = ScreenGui

    local MinimizedTitle = Instance.new("TextLabel")
    MinimizedTitle.Name = "MinimizedTitle"
    MinimizedTitle.Size = UDim2.new(1, 0, 0, 20)
    MinimizedTitle.Position = UDim2.new(0, 0, 0, 0)
    MinimizedTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MinimizedTitle.Text = "BC"
    MinimizedTitle.TextColor3 = Color3.new(1, 1, 1)
    MinimizedTitle.Font = Enum.Font.SourceSans
    MinimizedTitle.TextSize = 14
    MinimizedTitle.Parent = MinimizedFrame

    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Name = "MaximizeBtn"
    MaximizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MaximizeBtn.Position = UDim2.new(1, -25, 0, 5)
    MaximizeBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    MaximizeBtn.Text = "+"
    MaximizeBtn.TextColor3 = Color3.new(0, 0, 0)
    MaximizeBtn.Font = Enum.Font.SourceSansBold
    MaximizeBtn.TextSize = 14
    MaximizeBtn.Parent = MinimizedTitle

    -- Buttons
    local NoclipBtn = Instance.new("TextButton")
    NoclipBtn.Name = "NoclipBtn"
    NoclipBtn.Size = UDim2.new(1, -10, 0, 30)
    NoclipBtn.Position = UDim2.new(0, 5, 0, 35)
    NoclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    NoclipBtn.Text = "Noclip: OFF"
    NoclipBtn.TextColor3 = Color3.new(1, 1, 1)
    NoclipBtn.Font = Enum.Font.SourceSans
    NoclipBtn.TextSize = 16
    NoclipBtn.Parent = MainFrame

    local FlyBtn = Instance.new("TextButton")
    FlyBtn.Name = "FlyBtn"
    FlyBtn.Size = UDim2.new(1, -10, 0, 30)
    FlyBtn.Position = UDim2.new(0, 5, 0, 70)
    FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    FlyBtn.Text = "Fly (E): OFF"
    FlyBtn.TextColor3 = Color3.new(1, 1, 1)
    FlyBtn.Font = Enum.Font.SourceSans
    FlyBtn.TextSize = 16
    FlyBtn.Parent = MainFrame

    local AntiBanBtn = Instance.new("TextButton")
    AntiBanBtn.Name = "AntiBanBtn"
    AntiBanBtn.Size = UDim2.new(1, -10, 0, 30)
    AntiBanBtn.Position = UDim2.new(0, 5, 0, 105)
    AntiBanBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    AntiBanBtn.Text = "Anti-Ban: OFF"
    AntiBanBtn.TextColor3 = Color3.new(1, 1, 1)
    AntiBanBtn.Font = Enum.Font.SourceSans
    AntiBanBtn.TextSize = 16
    AntiBanBtn.Parent = MainFrame

    local TeleportInfo = Instance.new("TextLabel")
    TeleportInfo.Name = "TeleportInfo"
    TeleportInfo.Size = UDim2.new(1, -10, 0, 50)
    TeleportInfo.Position = UDim2.new(0, 5, 0, 140)
    TeleportInfo.BackgroundTransparency = 1
    TeleportInfo.Text = "Teleport: Hold CTRL + Click"
    TeleportInfo.TextColor3 = Color3.new(1, 1, 1)
    TeleportInfo.Font = Enum.Font.SourceSans
    TeleportInfo.TextSize = 14
    TeleportInfo.TextWrapped = true
    TeleportInfo.Parent = MainFrame

    -- Button Functions
    NoclipBtn.MouseButton1Click:Connect(function()
        Features.Noclip = not Features.Noclip
        ToggleNoclip(Features.Noclip)
        NoclipBtn.Text = Features.Noclip and "Noclip: ON" or "Noclip: OFF"
        NoclipBtn.BackgroundColor3 = Features.Noclip and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
    end)

    FlyBtn.MouseButton1Click:Connect(function()
        Features.Fly = not Features.Fly
        ToggleFly(Features.Fly)
        FlyBtn.Text = Features.Fly and "Fly (E): ON" or "Fly (E): OFF"
        FlyBtn.BackgroundColor3 = Features.Fly and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
    end)

    AntiBanBtn.MouseButton1Click:Connect(function()
        Features.AntiBan = not Features.AntiBan
        AntiBanBtn.Text = Features.AntiBan and "Anti-Ban: ON" or "Anti-Ban: OFF"
        AntiBanBtn.BackgroundColor3 = Features.AntiBan and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
        if Features.AntiBan then
            coroutine.wrap(AntiBan)()
        end
    end)

    -- Minimize/Maximize Logic
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
        Minimized = true
    end)

    MaximizeBtn.MouseButton1Click:Connect(function()
        MinimizedFrame.Visible = false
        MainFrame.Visible = true
        Minimized = false
    end)

    MinimizedTitle.Active = true
    MinimizedTitle.Draggable = true

    Gui = ScreenGui
end

-- Initialize
CreateUI()