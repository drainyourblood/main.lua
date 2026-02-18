-- NEVERLOSE 1:1 GUI CLONE + AIMBOT + FOV + TELEPORT + GUI TOGGLE (J)

----------------------------------------------------
-- AUTO LIGHTING (PINK SKY)
----------------------------------------------------
local Lighting = game:GetService("Lighting")

for _, v in pairs(Lighting:GetChildren()) do
	if v:IsA("Sky") then
		v:Destroy()
	end
end

local Sky = Instance.new("Sky")
Sky.Name = "PinkSky"
Sky.SkyboxBk = "rbxassetid://271042516"
Sky.SkyboxDn = "rbxassetid://271042556"
Sky.SkyboxFt = "rbxassetid://271042467"
Sky.SkyboxLf = "rbxassetid://271042310"
Sky.SkyboxRt = "rbxassetid://271042352"
Sky.SkyboxUp = "rbxassetid://271042531"
Sky.SunAngularSize = 18
Sky.MoonAngularSize = 8
Sky.StarCount = 0
Sky.Parent = Lighting

Lighting.Ambient = Color3.fromRGB(255,180,200)
Lighting.OutdoorAmbient = Color3.fromRGB(255,150,190)
Lighting.Brightness = 3
Lighting.ClockTime = 14

----------------------------------------------------
-- SERVICES
----------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

----------------------------------------------------
-- SETTINGS
----------------------------------------------------
local Settings = { BindKey = Enum.KeyCode.Q }
local AimBotEnabled = false
local isClicking = false
local FovNumber = 120
local FovEnabled = false
local DefaultFov = 70

StarterGui:SetCore("SendNotification", {
	Title = "Загружено",
	Text = "AimBot & FOV доступны в меню"
})

----------------------------------------------------
-- AIMBOT LOGIC
----------------------------------------------------
local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = math.huge

	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return nil
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if dist < shortestDistance then
				shortestDistance = dist
				closestPlayer = plr
			end
		end
	end

	return closestPlayer
end

local function aimAt(target)
	if not AimBotEnabled then return end
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
		if not isClicking then
			isClicking = true
			mouse1click()
			isClicking = false
		end
	end
end

----------------------------------------------------
-- GUI
----------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "NeverloseClone"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(600,400)
main.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(300,200)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,15)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(120,0,255)
stroke.Thickness = 2
stroke.Transparency = 0.6

----------------------------------------------------
-- LEFT PANEL
----------------------------------------------------
local left = Instance.new("Frame", main)
left.Size = UDim2.fromOffset(140,400)
left.BackgroundColor3 = Color3.fromRGB(25,25,25)
left.BorderSizePixel = 0
Instance.new("UICorner", left).CornerRadius = UDim.new(0,15)

local title = Instance.new("TextLabel", left)
title.Text = "SOSI"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,0,0,50)

----------------------------------------------------
-- TABS
----------------------------------------------------
local tabNames = {"Aim","Visuals","Teleport"}
local contentFrames = {}

for i,name in ipairs(tabNames) do
	local button = Instance.new("TextButton", left)
	button.Size = UDim2.fromOffset(140,40)
	button.Position = UDim2.fromOffset(0,(i-1)*50 + 50)
	button.Text = name
	button.BackgroundColor3 = Color3.fromRGB(30,30,30)
	button.TextColor3 = Color3.new(1,1,1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 16
	button.BorderSizePixel = 0
	Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)

	local content = Instance.new("Frame", main)
	content.Size = UDim2.fromOffset(430,360)
	content.Position = UDim2.fromOffset(150,20)
	content.BackgroundTransparency = 1
	content.Visible = i == 1
	contentFrames[i] = content

	button.MouseButton1Click:Connect(function()
		for j,f in ipairs(contentFrames) do
			f.Visible = f == content
		end
	end)
end

----------------------------------------------------
-- TOGGLE CREATOR
----------------------------------------------------
local function CreateToggle(parent,text,y,callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.fromOffset(400,40)
	frame.Position = UDim2.fromOffset(0,y)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

	local label = Instance.new("TextLabel", frame)
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1,-60,1,0)
	label.Position = UDim2.fromOffset(10,0)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.fromOffset(40,20)
	btn.Position = UDim2.fromOffset(350,10)
	btn.Text = ""
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

	local enabled = false
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		TweenService:Create(btn,TweenInfo.new(0.2),{
			BackgroundColor3 = enabled and Color3.fromRGB(120,0,255) or Color3.fromRGB(60,60,60)
		}):Play()
		if callback then callback(enabled) end
	end)
end

----------------------------------------------------
-- AIM TAB
----------------------------------------------------
CreateToggle(contentFrames[1],"AimBot (Q)",0,function(state)
	AimBotEnabled = state
	StarterGui:SetCore("SendNotification",{
		Title="AimBot",
		Text=state and "Enabled" or "Disabled"
	})
end)

----------------------------------------------------
-- VISUALS TAB (FOV)
----------------------------------------------------
CreateToggle(contentFrames[2],"FOV-120",0,function(state)
	FovEnabled = state
	if state then
		Camera.FieldOfView = FovNumber
	else
		Camera.FieldOfView = DefaultFov
	end
	StarterGui:SetCore("SendNotification",{
		Title="FOV",
		Text=state and ("FOV set to "..FovNumber) or "FOV reset"
	})
end)

----------------------------------------------------
-- TELEPORT TAB
----------------------------------------------------
do
	local teleportFrame = contentFrames[3]

	local scroll = Instance.new("ScrollingFrame", teleportFrame)
	scroll.Size = UDim2.fromOffset(430,360)
	scroll.Position = UDim2.fromOffset(0,0)
	scroll.ScrollBarThickness = 8
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local uiList = Instance.new("UIListLayout", scroll)
	uiList.Padding = UDim.new(0,5)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local function updatePlayerList()
		for _, child in pairs(scroll:GetChildren()) do
			if not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				local btn = Instance.new("TextButton", scroll)
				btn.Size = UDim2.fromOffset(400,30)
				btn.Text = plr.Name
				btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
				btn.TextColor3 = Color3.new(1,1,1)
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 14
				btn.BorderSizePixel = 0
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

				btn.MouseButton1Click:Connect(function()
					if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
					   plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
						local targetPos = plr.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
						player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
					end
				end)
			end
		end
	end

	Players.PlayerAdded:Connect(updatePlayerList)
	Players.PlayerRemoving:Connect(updatePlayerList)
	updatePlayerList()
end

----------------------------------------------------
-- SHOW ANIMATION
----------------------------------------------------
main.Position = main.Position + UDim2.fromOffset(-600,0)
TweenService:Create(
	main,
	TweenInfo.new(0.5,Enum.EasingStyle.Quad),
	{Position=UDim2.fromScale(0.5,0.5)-UDim2.fromOffset(300,200)}
):Play()

----------------------------------------------------
-- INPUT HANDLING (AimBot + GUI Toggle)
----------------------------------------------------
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	
	-- AimBot Q
	if input.KeyCode == Settings.BindKey and AimBotEnabled then
		aimAt(getClosestPlayer())
	end
	
	-- Toggle GUI J
	if input.KeyCode == Enum.KeyCode.J then
		guiVisible = not guiVisible
		main.Visible = guiVisible
		StarterGui:SetCore("SendNotification", {
			Title = "GUI",
			Text = guiVisible and "Shown-J" or "Hidden-J"
		})
	end
end)
