--[[
  🚀 Brookhaven RP Cheat Menu
  🔥 Features:
  - Player ESP (подсветка игроков)
  - Custom Speed/Jump (настройка скорости/прыжка)
  - Improved Noclip (улучшенный ноклип)
  - Invisible Mode (режим невидимости)
  - Minimize Window (сворачивание окна)
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- 🎨 Создание интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BHCheatMenu"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Закругленные углы
local corners = {
    {pos = UDim2.new(0, 0, 0, 0)},
    {pos = UDim2.new(1, -15, 0, 0)},
    {pos = UDim2.new(0, 0, 1, -15)},
    {pos = UDim2.new(1, -15, 1, -15)}
}

for _, corner in pairs(corners) do
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 15, 0, 15)
    frame.Position = corner.pos
    frame.BackgroundColor3 = MainFrame.BackgroundColor3
    frame.BorderSizePixel = 0
    frame.Parent = MainFrame
end

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Brookhaven Cheat"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Кнопка свернуть
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -25, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.new(0, 0, 0)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TitleBar

-- Контент
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -25)
ContentFrame.Position = UDim2.new(0, 0, 0, 25)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.Parent = ContentFrame

-- 🛠️ Функции
local function CreateButton(text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = ScrollFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateTextBox(placeholder, position)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 25)
    box.Position = position
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.PlaceholderText = placeholder
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    box.Parent = ScrollFrame
    return box
end

-- 🔥 ESP игроков (исправленный)
local ESPEnabled = false
local ESPHighlights = {}

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if ESPEnabled then
                if not ESPHighlights[player] then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = player.Character
                    ESPHighlights[player] = highlight
                end
            else
                if ESPHighlights[player] then
                    ESPHighlights[player]:Destroy()
                    ESPHighlights[player] = nil
                end
            end
        end
    end
end

CreateButton("Player ESP", UDim2.new(0.05, 0, 0, 10), function()
    ESPEnabled = not ESPEnabled
    UpdateESP()
end)

-- 🏃‍♂️ Настройка скорости/прыжка
local SpeedBox = CreateTextBox("Скорость (по умолчанию 16)", UDim2.new(0.05, 0, 0, 50))
local JumpBox = CreateTextBox("Прыжок (по умолчанию 50)", UDim2.new(0.05, 0, 0, 80))

CreateButton("Применить", UDim2.new(0.05, 0, 0, 110), function()
    local speed = tonumber(SpeedBox.Text) or 16
    local jump = tonumber(JumpBox.Text) or 50
    Humanoid.WalkSpeed = speed
    Humanoid.JumpPower = jump
end)

-- 🚫 Ноклип
local NoclipActive = false
CreateButton("Ноклип [V]", UDim2.new(0.05, 0, 0, 150), function()
    NoclipActive = not NoclipActive
end)

RunService.Stepped:Connect(function()
    if NoclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 👻 Режим невидимости
local Invisible = false
CreateButton("Невидимость", UDim2.new(0.05, 0, 0, 190), function()
    Invisible = not Invisible
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = Invisible and 1 or 0
            part.Size = Invisible and Vector3.new(0.1, 0.1, 0.1) or Vector3.new(1, 1, 1)
        end
    end
end)

-- Свернутое окно
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Size = UDim2.new(0, 100, 0, 30)
MinimizedFrame.Position = UDim2.new(0.5, -50, 0, 10)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizedFrame.Visible = false
MinimizedFrame.Parent = ScreenGui

local MinimizedTitle = Instance.new("TextLabel")
MinimizedTitle.Size = UDim2.new(1, 0, 1, 0)
MinimizedTitle.BackgroundTransparency = 1
MinimizedTitle.Text = "Меню"
MinimizedTitle.TextColor3 = Color3.new(1, 1, 1)
MinimizedTitle.Font = Enum.Font.SourceSans
MinimizedTitle.TextSize = 14
MinimizedTitle.Parent = MinimizedFrame

local MaximizeBtn = Instance.new("TextButton")
MaximizeBtn.Size = UDim2.new(0, 25, 0, 25)
MaximizeBtn.Position = UDim2.new(1, -25, 0, 0)
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
MaximizeBtn.Text = "+"
MaximizeBtn.TextColor3 = Color3.new(0, 0, 0)
MaximizeBtn.Font = Enum.Font.SourceSansBold
MaximizeBtn.TextSize = 18
MaximizeBtn.Parent = MinimizedFrame

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

MaximizeBtn.MouseButton1Click:Connect(function()
    MinimizedFrame.Visible = false
    MainFrame.Visible = true
end)

MinimizedFrame.Active = true
MinimizedFrame.Draggable = true

MainFrame.Parent = ScreenGui

-- Обновление ESP при появлении новых игроков
Players.PlayerAdded:Connect(UpdateESP)
Players.PlayerRemoving:Connect(function(player)
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
end)

-- Обновление при респавне
LocalPlayer.CharacterAdded:Connect(function(character)
    Character = character
    Humanoid = character:WaitForChild("Humanoid")
    Humanoid.WalkSpeed = tonumber(SpeedBox.Text) or 16
    Humanoid.JumpPower = tonumber(JumpBox.Text) or 50
    
    if Invisible then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.Size = Vector3.new(0.1, 0.1, 0.1)
            end
        end
    end
end)

print("Брукхейвен Чит Меню успешно загружен!")
