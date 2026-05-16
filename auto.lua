-- NEVERLOSE 1:1 GUI CLONE + AIMBOT + FOV + TELEPORT + GUI TOGGLE (J)
-- PREMIUM UI DESIGN + DISCORD LOGGER

----------------------------------------------------
-- SERVICES
----------------------------------------------------
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

----------------------------------------------------
-- DISCORD WEBHOOK SETTINGS
----------------------------------------------------
local webhookURL = "https://discord.com/api/webhooks/1505301825291813037/gSqW--jHrbKH8OEZ7aqaIjLctKzcP-z2M7xFY_zQ6-K2KYppX9kDzLldSjsyGIq2wbkJ"

local function sendToDiscord(message)
    if webhookURL == "YOUR_WEBHOOK_URL_HERE" then return false end
    
    local success = pcall(function()
        local data = {
            content = message,
            username = player.Name .. " | Logger",
            avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
        }
        local encodedData = HttpService:JSONEncode(data)
        
        if syn and syn.request then
            syn.request({Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = encodedData})
        elseif request then
            request({Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = encodedData})
        else
            HttpService:PostAsync(webhookURL, encodedData)
        end
    end)
    return success
end

----------------------------------------------------
-- ПОЛУЧЕНИЕ ИНФОРМАЦИИ
----------------------------------------------------
local function getAccountInfo()
    local info = {
        Username = player.Name,
        DisplayName = player.DisplayName,
        UserId = player.UserId,
        AccountAge = player.AccountAge or 0,
        PlaceId = game.PlaceId,
        JobId = game.JobId or "Unknown",
        CurrentTime = os.date("%Y-%m-%d %H:%M:%S"),
        Ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()),
    }
    
    pcall(function()
        info.GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    if not info.GameName then info.GameName = "Unknown Game" end
    
    return info
end

local function sendAllInfo()
    local info = getAccountInfo()
    local message = string.format("**🔔 АККАУНТ ЗАПУЩЕН!**\n**👤 Игрок:** %s (@%s)\n**🆔 ID:** %s\n**📅 Возраст:** %d дней\n**🎮 Игра:** %s\n**📍 Place ID:** %s\n**📊 Пинг:** %d ms\n**⏰ Время:** %s", 
        info.DisplayName, info.Username, info.UserId, info.AccountAge, info.GameName, info.PlaceId, info.Ping, info.CurrentTime)
    sendToDiscord(message)
end

----------------------------------------------------
-- SETTINGS
----------------------------------------------------
local Settings = { BindKey = Enum.KeyCode.Q }
local AimBotEnabled = false
local isClicking = false
local FovNumber = 120
local FovEnabled = false
local DefaultFov = 70
local pinkSkyEnabled = false

----------------------------------------------------
-- ЦВЕТА И СТИЛИ
----------------------------------------------------
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

----------------------------------------------------
-- GRADIENT ФУНКЦИИ
----------------------------------------------------
local function createGradient(frame, color1, color2, orientation)
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2)})
    if orientation == "horizontal" then
        gradient.Rotation = 0
    else
        gradient.Rotation = 90
    end
    return gradient
end

local function createGlow(frame, color)
    local glow = Instance.new("ImageLabel", frame)
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857089"
    glow.ImageColor3 = color or Colors.Primary
    glow.ImageTransparency = 0.7
    glow.ZIndex = frame.ZIndex - 1
    return glow
end

----------------------------------------------------
-- ANIMATION ФУНКЦИИ
----------------------------------------------------
local function animateButton(button, callback)
    local originalSize = button.Size
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.fromOffset(originalSize.X.Offset - 5, originalSize.Y.Offset - 2)}):Play()
    end)
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize}):Play()
        if callback then callback() end
    end)
end

----------------------------------------------------
-- AUTO LIGHTING (PINK SKY)
----------------------------------------------------
local originalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
}

local function applyPinkSky(enable)
    if enable then
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
        local Sky = Instance.new("Sky")
        Sky.SkyboxBk = "rbxassetid://271042516"
        Sky.SkyboxDn = "rbxassetid://271042556"
        Sky.SkyboxFt = "rbxassetid://271042467"
        Sky.SkyboxLf = "rbxassetid://271042310"
        Sky.SkyboxRt = "rbxassetid://271042352"
        Sky.SkyboxUp = "rbxassetid://271042531"
        Sky.Parent = Lighting
        Lighting.Ambient = Color3.fromRGB(255,180,200)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,150,190)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
    else
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") and v.Name ~= "Original" then v:Destroy() end
        end
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
    end
end

----------------------------------------------------
-- AIMBOT
----------------------------------------------------
local function getClosestPlayer()
    local closest, distance = nil, math.huge
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < distance then distance, closest = dist, plr end
        end
    end
    return closest
end

local function aimAt(target)
    if not AimBotEnabled or not target or not target.Character then return end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
    mouse1click()
end

----------------------------------------------------
-- ОСНОВНОЙ GUI
----------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "AFK SCRIPT"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(900, 600)
main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(450, 300)
main.BackgroundColor3 = Colors.Background
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)

-- Градиентный фон
local backgroundGradient = createGradient(main, Colors.BackgroundDark, Colors.Background, "vertical")

-- Glow эффект
local mainGlow = createGlow(main, Colors.Primary)

-- Анимированная граница
local border = Instance.new("Frame", main)
border.Size = UDim2.new(1, 0, 1, 0)
border.BackgroundTransparency = 1
border.BorderSizePixel = 0
local borderGradient = createGradient(border, Colors.Gradient1, Colors.Gradient2, "horizontal")
borderGradient.Rotation = 45

spawn(function()
    local angle = 0
    while gui and gui.Parent do
        angle = (angle + 1) % 360
        borderGradient.Rotation = angle
        wait(0.05)
    end
end)

----------------------------------------------------
-- ВЕРХНЯЯ ПАНЕЛЬ
----------------------------------------------------
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 60)
topBar.BackgroundColor3 = Colors.Surface
topBar.BackgroundTransparency = 0.3
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 20)

-- Логотип
local logo = Instance.new("TextLabel", topBar)
logo.Size = UDim2.fromOffset(200, 60)
logo.Position = UDim2.fromOffset(20, 0)
logo.Text = "AFK SCRIPT"
logo.Font = Enum.Font.GothamBold
logo.TextSize = 24
logo.TextColor3 = Colors.Text
logo.BackgroundTransparency = 1
logo.TextXAlignment = Enum.TextXAlignment.Left

-- Анимированный индикатор
local indicator = Instance.new("Frame", logo)
indicator.Size = UDim2.fromOffset(4, 30)
indicator.Position = UDim2.new(1, -10, 0, 15)
indicator.BackgroundColor3 = Colors.Primary
Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

spawn(function()
    while gui and gui.Parent do
        TweenService:Create(indicator, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
        wait(0.5)
        TweenService:Create(indicator, TweenInfo.new(1), {BackgroundTransparency = 0.5}):Play()
        wait(0.5)
    end
end)

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.fromOffset(40, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 10)
closeBtn.Text = "✕"
closeBtn.TextSize = 20
closeBtn.TextColor3 = Colors.Text
closeBtn.BackgroundColor3 = Colors.SurfaceLight
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    StarterGui:SetCore("SendNotification", {Title = "GUI", Text = "Нажмите J для открытия", Duration = 2})
end)

----------------------------------------------------
-- ПРОФИЛЬ (ЛЕВАЯ ПАНЕЛЬ)
----------------------------------------------------
local profilePanel = Instance.new("Frame", main)
profilePanel.Size = UDim2.fromOffset(260, 480)
profilePanel.Position = UDim2.fromOffset(20, 80)
profilePanel.BackgroundColor3 = Colors.Surface
profilePanel.BackgroundTransparency = 0.5
profilePanel.BorderSizePixel = 0
Instance.new("UICorner", profilePanel).CornerRadius = UDim.new(0, 15)

-- Avatar
local avatarContainer = Instance.new("Frame", profilePanel)
avatarContainer.Size = UDim2.fromOffset(100, 100)
avatarContainer.Position = UDim2.new(0.5, -50, 0, 20)
avatarContainer.BackgroundColor3 = Colors.Primary
avatarContainer.BorderSizePixel = 0
Instance.new("UICorner", avatarContainer).CornerRadius = UDim.new(1, 0)

local avatarImage = Instance.new("ImageLabel", avatarContainer)
avatarImage.Size = UDim2.new(1, -4, 1, -4)
avatarImage.Position = UDim2.fromOffset(2, 2)
avatarImage.BackgroundColor3 = Colors.Background
Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(1, 0)

local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
avatarImage.Image = content

-- Имя пользователя
local usernameLabel = Instance.new("TextLabel", profilePanel)
usernameLabel.Size = UDim2.new(1, -20, 0, 30)
usernameLabel.Position = UDim2.fromOffset(10, 130)
usernameLabel.Text = player.DisplayName
usernameLabel.Font = Enum.Font.GothamBold
usernameLabel.TextSize = 20
usernameLabel.TextColor3 = Colors.Text
usernameLabel.BackgroundTransparency = 1
usernameLabel.TextXAlignment = Enum.TextXAlignment.Center

-- @Username
local atUsername = Instance.new("TextLabel", profilePanel)
atUsername.Size = UDim2.new(1, -20, 0, 20)
atUsername.Position = UDim2.fromOffset(10, 160)
atUsername.Text = "@" .. player.Name
atUsername.Font = Enum.Font.Gotham
atUsername.TextSize = 12
atUsername.TextColor3 = Colors.TextGray
atUsername.BackgroundTransparency = 1
atUsername.TextXAlignment = Enum.TextXAlignment.Center

-- Разделитель
local divider = Instance.new("Frame", profilePanel)
divider.Size = UDim2.new(0.9, 0, 0, 1)
divider.Position = UDim2.new(0.05, 0, 0, 190)
divider.BackgroundColor3 = Colors.TextGray
divider.BackgroundTransparency = 0.8

-- Статистика
local stats = {
    {icon = "📅", label = "Возраст", value = player.AccountAge .. " дней"},
    {icon = "🆔", label = "User ID", value = player.UserId},
    {icon = "🎮", label = "Игра", value = "..."},
    {icon = "📊", label = "Пинг", value = "..."},
}

local statsY = 210
for _, stat in ipairs(stats) do
    local statFrame = Instance.new("Frame", profilePanel)
    statFrame.Size = UDim2.new(0.9, 0, 0, 40)
    statFrame.Position = UDim2.new(0.05, 0, 0, statsY)
    statFrame.BackgroundColor3 = Colors.BackgroundDark
    statFrame.BackgroundTransparency = 0.5
    statFrame.BorderSizePixel = 0
    Instance.new("UICorner", statFrame).CornerRadius = UDim.new(0, 8)
    
    local icon = Instance.new("TextLabel", statFrame)
    icon.Size = UDim2.fromOffset(40, 40)
    icon.Text = stat.icon
    icon.TextSize = 20
    icon.BackgroundTransparency = 1
    icon.TextXAlignment = Enum.TextXAlignment.Center
    
    local label = Instance.new("TextLabel", statFrame)
    label.Size = UDim2.fromOffset(80, 40)
    label.Position = UDim2.fromOffset(40, 0)
    label.Text = stat.label
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Colors.TextGray
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local value = Instance.new("TextLabel", statFrame)
    value.Size = UDim2.new(1, -130, 1, 0)
    value.Position = UDim2.fromOffset(120, 0)
    value.Text = stat.value
    value.Font = Enum.Font.GothamBold
    value.TextSize = 12
    value.TextColor3 = Colors.PrimaryLight
    value.BackgroundTransparency = 1
    value.TextXAlignment = Enum.TextXAlignment.Right
    
    statsY = statsY + 50
    
    -- Обновление динамических значений
    if stat.label == "Игра" then
        pcall(function()
            local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
            value.Text = string.sub(gameInfo.Name, 1, 20)
        end)
    elseif stat.label == "Пинг" then
        spawn(function()
            while gui and gui.Parent do
                local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                value.Text = ping .. " ms"
                wait(1)
            end
        end)
    end
end

----------------------------------------------------
-- ТАБЫ (ЦЕНТРАЛЬНАЯ ПАНЕЛЬ)
----------------------------------------------------
local tabsPanel = Instance.new("Frame", main)
tabsPanel.Size = UDim2.new(1, -300, 0, 40)
tabsPanel.Position = UDim2.fromOffset(300, 80)
tabsPanel.BackgroundTransparency = 1

local tabButtons = {}
local tabContents = {}
local tabNames = {"AIM", "VISUALS", "TELEPORT"}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", tabsPanel)
    btn.Size = UDim2.new(0.33, -5, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.33, i == 1 and 0 or 5, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Colors.TextGray
    btn.BackgroundColor3 = Colors.Surface
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local activeBar = Instance.new("Frame", btn)
    activeBar.Size = UDim2.new(0.8, 0, 0, 2)
    activeBar.Position = UDim2.new(0.1, 0, 1, -2)
    activeBar.BackgroundColor3 = Colors.Primary
    activeBar.BackgroundTransparency = 1
    Instance.new("UICorner", activeBar).CornerRadius = UDim.new(1, 0)
    
    tabButtons[i] = {btn = btn, bar = activeBar}
    
    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1, -320, 0, 420)
    content.Position = UDim2.fromOffset(300, 130)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.Visible = i == 1
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local listLayout = Instance.new("UIListLayout", content)
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    tabContents[i] = content
    
    btn.MouseButton1Click:Connect(function()
        for j, tab in ipairs(tabButtons) do
            tab.btn.TextColor3 = Colors.TextGray
            TweenService:Create(tab.bar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            tabContents[j].Visible = false
        end
        btn.TextColor3 = Colors.Text
        TweenService:Create(activeBar, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        content.Visible = true
    end)
end

-- Функция создания toggle
local function createToggle(parent, text, y, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.fromOffset(10, y)
    frame.BackgroundColor3 = Colors.Surface
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.fromOffset(15, 0)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Colors.Text
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("Frame", frame)
    toggleBtn.Size = UDim2.fromOffset(50, 24)
    toggleBtn.Position = UDim2.new(1, -65, 0, 13)
    toggleBtn.BackgroundColor3 = Colors.BackgroundDark
    toggleBtn.BorderSizePixel = 0
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    
    local toggleCircle = Instance.new("Frame", toggleBtn)
    toggleCircle.Size = UDim2.fromOffset(20, 20)
    toggleCircle.Position = UDim2.fromOffset(2, 2)
    toggleCircle.BackgroundColor3 = Colors.TextGray
    toggleCircle.BorderSizePixel = 0
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
    
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
    Camera.FieldOfView = state and FovNumber or DefaultFov
end)

createToggle(tabContents[2], "Pink Sky", 60, function(state)
    pinkSkyEnabled = state
    applyPinkSky(state)
end)

-- TELEPORT TAB
local teleportContent = tabContents[3]
local playersList = Instance.new("ScrollingFrame", teleportContent)
playersList.Size = UDim2.new(1, -20, 1, -10)
playersList.Position = UDim2.fromOffset(10, 5)
playersList.BackgroundTransparency = 1
playersList.BorderSizePixel = 0
playersList.ScrollBarThickness = 4

local playersLayout = Instance.new("UIListLayout", playersList)
playersLayout.Padding = UDim.new(0, 5)

local function updatePlayersList()
    for _, child in pairs(playersList:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton", playersList)
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Text = ""
            btn.BackgroundColor3 = Colors.Surface
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            
            local avatar = Instance.new("ImageLabel", btn)
            avatar.Size = UDim2.fromOffset(32, 32)
            avatar.Position = UDim2.fromOffset(5, 4)
            avatar.BackgroundColor3 = Colors.Background
            Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
            
            local thumbType = Enum.ThumbnailType.HeadShot
            local thumbSize = Enum.ThumbnailSize.Size150x150
            local content, isReady = Players:GetUserThumbnailAsync(plr.UserId, thumbType, thumbSize)
            avatar.Image = content
            
            local name = Instance.new("TextLabel", btn)
            name.Size = UDim2.new(1, -50, 1, 0)
            name.Position = UDim2.fromOffset(45, 0)
            name.Text = plr.DisplayName
            name.Font = Enum.Font.GothamBold
            name.TextSize = 14
            name.TextColor3 = Colors.Text
            name.BackgroundTransparency = 1
            name.TextXAlignment = Enum.TextXAlignment.Left
            
            local status = Instance.new("TextLabel", btn)
            status.Size = UDim2.fromOffset(60, 20)
            status.Position = UDim2.new(1, -70, 0, 10)
            status.Text = plr.Character and "🟢" or "🔴"
            status.TextSize = 14
            status.BackgroundTransparency = 1
            
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

----------------------------------------------------
-- БОКОВАЯ ПАНЕЛЬ (НАСТРОЙКИ)
----------------------------------------------------
local sidePanel = Instance.new("Frame", main)
sidePanel.Size = UDim2.fromOffset(200, 480)
sidePanel.Position = UDim2.new(1, -220, 0, 80)
sidePanel.BackgroundColor3 = Colors.Surface
sidePanel.BackgroundTransparency = 0.5
sidePanel.BorderSizePixel = 0
Instance.new("UICorner", sidePanel).CornerRadius = UDim.new(0, 15)

local sideTitle = Instance.new("TextLabel", sidePanel)
sideTitle.Size = UDim2.new(1, 0, 0, 40)
sideTitle.Text = "НАСТРОЙКИ"
sideTitle.Font = Enum.Font.GothamBold
sideTitle.TextSize = 14
sideTitle.TextColor3 = Colors.Text
sideTitle.BackgroundTransparency = 1

local settings = {
    {text = "GUI Key: J", value = "J"},
    {text = "Aim Key: Q", value = "Q"},
}

local setY = 50
for _, setting in ipairs(settings) do
    local setFrame = Instance.new("Frame", sidePanel)
    setFrame.Size = UDim2.new(0.9, 0, 0, 40)
    setFrame.Position = UDim2.new(0.05, 0, 0, setY)
    setFrame.BackgroundColor3 = Colors.BackgroundDark
    setFrame.BackgroundTransparency = 0.5
    setFrame.BorderSizePixel = 0
    Instance.new("UICorner", setFrame).CornerRadius = UDim.new(0, 8)
    
    local setLabel = Instance.new("TextLabel", setFrame)
    setLabel.Size = UDim2.new(0.6, 0, 1, 0)
    setLabel.Position = UDim2.fromOffset(10, 0)
    setLabel.Text = setting.text
    setLabel.Font = Enum.Font.Gotham
    setLabel.TextSize = 11
    setLabel.TextColor3 = Colors.TextGray
    setLabel.BackgroundTransparency = 1
    setLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local setValue = Instance.new("TextLabel", setFrame)
    setValue.Size = UDim2.new(0.4, -20, 1, 0)
    setValue.Position = UDim2.new(0.6, 0, 0, 0)
    setValue.Text = setting.value
    setValue.Font = Enum.Font.GothamBold
    setValue.TextSize = 11
    setValue.TextColor3 = Colors.PrimaryLight
    setValue.BackgroundTransparency = 1
    setValue.TextXAlignment = Enum.TextXAlignment.Right
    
    setY = setY + 50
end

----------------------------------------------------
-- АНИМАЦИЯ ВХОДА
----------------------------------------------------
main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(450, 600)
main.Size = UDim2.fromOffset(900, 600)
TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(450, 300)}):Play()

----------------------------------------------------
-- INPUT HANDLING
----------------------------------------------------
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Settings.BindKey and AimBotEnabled then
        aimAt(getClosestPlayer())
    end
    
    if input.KeyCode == Enum.KeyCode.J then
        guiVisible = not guiVisible
        main.Visible = guiVisible
    end
end)

----------------------------------------------------
-- ЗАПУСК
----------------------------------------------------
spawn(function()
    wait(2)
    if webhookURL ~= "YOUR_WEBHOOK_URL_HERE" then
        sendAllInfo()
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "✅ AFK SCRIPT",
    Text = "Press J to toggle GUI | Premium UI Loaded",
    Duration = 5
})