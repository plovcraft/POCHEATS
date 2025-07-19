local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Создаем круглый интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalLoader"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 250)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true

-- Делаем круглую форму
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MainFrame

-- Поле ввода
local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.8, 0, 0, 35)
InputBox.Position = UDim2.new(0.1, 0, 0.4, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputBox.TextColor3 = Color3.new(1, 1, 1)
InputBox.PlaceholderText = "Введите название игры"
InputBox.Font = Enum.Font.SourceSans
InputBox.TextSize = 14
InputBox.TextWrapped = true
InputBox.ClearTextOnFocus = false
InputBox.Parent = MainFrame

-- Стилизация поля ввода
local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0.2, 0)
InputCorner.Parent = InputBox

-- Текст инструкции
local HintText = Instance.new("TextLabel")
HintText.Size = UDim2.new(0.8, 0, 0, 50)
HintText.Position = UDim2.new(0.1, 0, 0.2, 0)
HintText.BackgroundTransparency = 1
HintText.Text = "Универсальный активатор читов\n(Brookhaven, Evade, и др.)"
HintText.TextColor3 = Color3.new(1, 1, 1)
HintText.Font = Enum.Font.SourceSansBold
HintText.TextSize = 16
HintText.TextWrapped = true
HintText.Parent = MainFrame

-- Список доступных читов
local CheatsList = {
    ["brookhaven"] = {
        url = "https://raw.githubusercontent.com/plovcraft/POCHEATS/main/Brookhaven.lua",
        message = "Чит для Brookhaven успешно загружен!"
    },
    ["evade"] = {
        url = "https://raw.githubusercontent.com/plovcraft/POCHEATS/main/Evade.lua",
        message = "Чит для Evade успешно загружен!"
    },
    ["mm2"] = {
        url = "https://raw.githubusercontent.com/plovcraft/POCHEATS/main/MurderMystery2.lua",
        message = "Чит для Murder Mystery 2 успешно загружен!"
    }
}

MainFrame.Parent = ScreenGui

-- Обработчик ввода
InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local input = string.lower(InputBox.Text)
        
        if CheatsList[input] then
            -- Запускаем соответствующий скрипт
            local cheat = CheatsList[input]
            loadstring(game:HttpGet(cheat.url, true))()
            
            -- Закрываем загрузчик
            ScreenGui:Destroy()
            
            -- Сообщение в консоль
            print(cheat.message)
        else
            -- Неправильный ввод
            InputBox.Text = ""
            InputBox.PlaceholderText = "Доступно: "..table.concat(table.keys(CheatsList), ", ")
            wait(1.5)
            InputBox.PlaceholderText = "Введите название игры"
        end
    end
end)

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(0.85, 0, 0.05, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame

-- Закругление кнопки
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0.5, 0)
ButtonCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Функция для получения ключей таблицы
function table.keys(t)
    local keys = {}
    for k in pairs(t) do table.insert(keys, k) end
    return keys
end
