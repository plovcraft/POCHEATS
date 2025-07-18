local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- Список читов и их GitHub-ссылок
local CheatScripts = {
    ["брукхевен"] = "loadstring(game:HttpGet("https://raw.githubusercontent.com/plovcraft/POCHEATS/main/Brookhaven.lua"))()",
    ["Hydrogen"] = "https://raw.githubusercontent.com/ваш_ник/репозиторий/main/hydrogen.lua",
    ["VapeV4"] = "https://raw.githubusercontent.com/ваш_ник/репозиторий/main/vapev4.lua",
    ["Pocheaters"] = "https://raw.githubusercontent.com/ваш_ник/репозиторий/main/pocheaters.lua"
}

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatLoaderUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Начальный размер (для анимации)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.2
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.5, 0) -- Делаем круглую форму
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.8, 0, 0, 30)
Title.Position = UDim2.new(0.1, 0, 0.1, 0)
Title.Text = "⚡ Введите название чита"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local CheatNameBox = Instance.new("TextBox")
CheatNameBox.Name = "CheatNameBox"
CheatNameBox.Size = UDim2.new(0.8, 0, 0, 35)
CheatNameBox.Position = UDim2.new(0.1, 0, 0.4, 0)
CheatNameBox.PlaceholderText = "Например: Pocheaters"
CheatNameBox.Text = ""
CheatNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CheatNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CheatNameBox.Font = Enum.Font.SourceSans
CheatNameBox.TextSize = 16
CheatNameBox.Parent = MainFrame

local SubmitButton = Instance.new("TextButton")
SubmitButton.Name = "SubmitButton"
SubmitButton.Size = UDim2.new(0.6, 0, 0, 30)
SubmitButton.Position = UDim2.new(0.2, 0, 0.6, 0)
SubmitButton.Text = "Активировать"
SubmitButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.Font = Enum.Font.SourceSansBold
SubmitButton.TextSize = 16
SubmitButton.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0.8, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 14
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = MainFrame

-- Анимация открытия (круг расширяется)
local function OpenUI()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    local Tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 250, 0, 200)}
    )
    Tween:Play()
end

-- Анимация закрытия (круг сжимается)
local function CloseUI()
    local Tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)}
    )
    Tween:Play()
    Tween.Completed:Wait()
    MainFrame.Visible = false
end

-- Проверка и загрузка чита
local function LoadCheat()
    local CheatName = CheatNameBox.Text
    local CheatURL = CheatScripts[CheatName]
    
    if CheatURL then
        StatusLabel.Text = "Загрузка "..CheatName.."..."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Пытаемся загрузить скрипт
        local success, err = pcall(function()
            loadstring(game:HttpGet(CheatURL))()
        end)
        
        if success then
            StatusLabel.Text = CheatName.." активирован!"
            task.delay(1.5, CloseUI)
        else
            StatusLabel.Text = "Ошибка загрузки!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            print("Ошибка:", err)
        end
    else
        StatusLabel.Text = "Чит не найден!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.delay(1.5, CloseUI)
    end
end

-- Обработчики кнопок
SubmitButton.MouseButton1Click:Connect(LoadCheat)

-- Открываем интерфейс при запуске
OpenUI()
