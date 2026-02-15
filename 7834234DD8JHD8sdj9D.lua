-- ============================================================
-- Modern Draggable UI - Full Featured
-- Key System + Aimbot, Visuals, Misc, Config
-- Color Wheel, Trigger Bot, Visible Check, Skeleton ESP
-- Health Bars, Infinite Jump, Jump Power
-- Toast Notifications System
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- REMOVE OLD UI
-- ============================================================
pcall(function()
	if game:GetService("CoreGui"):FindFirstChild("ModernUI_KeySystem") then
		game:GetService("CoreGui"):FindFirstChild("ModernUI_KeySystem"):Destroy()
	end
	if game:GetService("CoreGui"):FindFirstChild("ModernUI_Main") then
		game:GetService("CoreGui"):FindFirstChild("ModernUI_Main"):Destroy()
	end
end)

-- ============================================================
-- KEY SYSTEM
-- ============================================================
local KeyScreenGui = Instance.new("ScreenGui")
KeyScreenGui.Name = "ModernUI_KeySystem"
KeyScreenGui.ResetOnSpawn = false
KeyScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyScreenGui.DisplayOrder = 9999999
KeyScreenGui.IgnoreGuiInset = true

pcall(function() if syn and syn.protect_gui then syn.protect_gui(KeyScreenGui) end end)
pcall(function() KeyScreenGui.Parent = game:GetService("CoreGui") end)
if not KeyScreenGui.Parent then KeyScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Key UI Colors
local KeyColors = {
	Bg = Color3.fromRGB(12, 12, 18),
	Card = Color3.fromRGB(18, 18, 26),
	Input = Color3.fromRGB(24, 24, 36),
	Accent = Color3.fromRGB(90, 70, 235),
	AccentHover = Color3.fromRGB(110, 90, 255),
	Text = Color3.fromRGB(220, 220, 235),
	TextDim = Color3.fromRGB(120, 120, 145),
	Error = Color3.fromRGB(255, 70, 70),
	Success = Color3.fromRGB(80, 220, 120),
	Border = Color3.fromRGB(35, 35, 50),
}

-- Background overlay
local keyBg = Instance.new("Frame")
keyBg.Size = UDim2.new(1, 0, 1, 0)
keyBg.BackgroundColor3 = KeyColors.Bg
keyBg.BackgroundTransparency = 0.3
keyBg.ZIndex = 1
keyBg.Parent = KeyScreenGui

-- Card
local keyCard = Instance.new("Frame")
keyCard.Size = UDim2.new(0, 380, 0, 0)
keyCard.Position = UDim2.new(0.5, -190, 0.5, -140)
keyCard.BackgroundColor3 = KeyColors.Card
keyCard.BorderSizePixel = 0
keyCard.ZIndex = 10
keyCard.ClipsDescendants = true
keyCard.Parent = KeyScreenGui

Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 12)
local kcStroke = Instance.new("UIStroke", keyCard)
kcStroke.Color = KeyColors.Border
kcStroke.Thickness = 1

-- Animate card in
task.defer(function()
	TweenService:Create(keyCard, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 380, 0, 280)
	}):Play()
end)

-- Lock icon
local lockIcon = Instance.new("TextLabel")
lockIcon.Size = UDim2.new(0, 50, 0, 50)
lockIcon.Position = UDim2.new(0.5, -25, 0, 20)
lockIcon.BackgroundTransparency = 1
lockIcon.Text = "🔒"
lockIcon.TextSize = 36
lockIcon.ZIndex = 11
lockIcon.Parent = keyCard

-- Title
local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 24)
keyTitle.Position = UDim2.new(0, 0, 0, 72)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "Authentication Required"
keyTitle.TextColor3 = KeyColors.Text
keyTitle.TextSize = 16
keyTitle.Font = Enum.Font.GothamBold
keyTitle.ZIndex = 11
keyTitle.Parent = keyCard

-- Subtitle
local keySub = Instance.new("TextLabel")
keySub.Size = UDim2.new(1, -40, 0, 18)
keySub.Position = UDim2.new(0, 20, 0, 98)
keySub.BackgroundTransparency = 1
keySub.Text = "Enter your license key to continue"
keySub.TextColor3 = KeyColors.TextDim
keySub.TextSize = 12
keySub.Font = Enum.Font.GothamSemibold
keySub.ZIndex = 11
keySub.Parent = keyCard

-- Input frame
local keyInputFrame = Instance.new("Frame")
keyInputFrame.Size = UDim2.new(1, -40, 0, 42)
keyInputFrame.Position = UDim2.new(0, 20, 0, 128)
keyInputFrame.BackgroundColor3 = KeyColors.Input
keyInputFrame.BorderSizePixel = 0
keyInputFrame.ZIndex = 11
keyInputFrame.Parent = keyCard

Instance.new("UICorner", keyInputFrame).CornerRadius = UDim.new(0, 8)
local kiStroke = Instance.new("UIStroke", keyInputFrame)
kiStroke.Color = KeyColors.Border
kiStroke.Thickness = 1

local keyInputBox = Instance.new("TextBox")
keyInputBox.Size = UDim2.new(1, -16, 1, 0)
keyInputBox.Position = UDim2.new(0, 8, 0, 0)
keyInputBox.BackgroundTransparency = 1
keyInputBox.Text = ""
keyInputBox.PlaceholderText = "Enter key here..."
keyInputBox.PlaceholderColor3 = KeyColors.TextDim
keyInputBox.TextColor3 = KeyColors.Text
keyInputBox.TextSize = 13
keyInputBox.Font = Enum.Font.GothamSemibold
keyInputBox.TextXAlignment = Enum.TextXAlignment.Left
keyInputBox.ClearTextOnFocus = false
keyInputBox.ZIndex = 12
keyInputBox.Parent = keyInputFrame

-- Focus highlight
keyInputBox.Focused:Connect(function()
	TweenService:Create(kiStroke, TweenInfo.new(0.15), {Color = KeyColors.Accent}):Play()
end)
keyInputBox.FocusLost:Connect(function()
	TweenService:Create(kiStroke, TweenInfo.new(0.15), {Color = KeyColors.Border}):Play()
end)

-- Submit button
local keySubmitBtn = Instance.new("TextButton")
keySubmitBtn.Size = UDim2.new(1, -40, 0, 40)
keySubmitBtn.Position = UDim2.new(0, 20, 0, 182)
keySubmitBtn.BackgroundColor3 = KeyColors.Accent
keySubmitBtn.BorderSizePixel = 0
keySubmitBtn.Text = "🔓 Authenticate"
keySubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmitBtn.TextSize = 13
keySubmitBtn.Font = Enum.Font.GothamBold
keySubmitBtn.ZIndex = 11
keySubmitBtn.AutoButtonColor = false
keySubmitBtn.Parent = keyCard

Instance.new("UICorner", keySubmitBtn).CornerRadius = UDim.new(0, 8)

keySubmitBtn.MouseEnter:Connect(function()
	TweenService:Create(keySubmitBtn, TweenInfo.new(0.12), {BackgroundColor3 = KeyColors.AccentHover}):Play()
end)
keySubmitBtn.MouseLeave:Connect(function()
	TweenService:Create(keySubmitBtn, TweenInfo.new(0.12), {BackgroundColor3 = KeyColors.Accent}):Play()
end)

-- Status label
local keyStatusLbl = Instance.new("TextLabel")
keyStatusLbl.Size = UDim2.new(1, -40, 0, 20)
keyStatusLbl.Position = UDim2.new(0, 20, 0, 232)
keyStatusLbl.BackgroundTransparency = 1
keyStatusLbl.Text = ""
keyStatusLbl.TextColor3 = KeyColors.Error
keyStatusLbl.TextSize = 11
keyStatusLbl.Font = Enum.Font.GothamSemibold
keyStatusLbl.ZIndex = 11
keyStatusLbl.Parent = keyCard

-- Get key button
local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0, 100, 0, 20)
getKeyBtn.Position = UDim2.new(0.5, -50, 0, 254)
getKeyBtn.BackgroundTransparency = 1
getKeyBtn.Text = "Get a Key →"
getKeyBtn.TextColor3 = KeyColors.Accent
getKeyBtn.TextSize = 11
getKeyBtn.Font = Enum.Font.GothamSemibold
getKeyBtn.ZIndex = 11
getKeyBtn.Parent = keyCard

getKeyBtn.MouseEnter:Connect(function() getKeyBtn.TextColor3 = KeyColors.AccentHover end)
getKeyBtn.MouseLeave:Connect(function() getKeyBtn.TextColor3 = KeyColors.Accent end)
getKeyBtn.MouseButton1Click:Connect(function()
	pcall(function()
		setclipboard("https://raw.githubusercontent.com/tristan16144/83NSD9SJDFBhjsas8efdGsdf4dHs/refs/heads/main/keys")
	end)
	keyStatusLbl.Text = "Link copied to clipboard!"
	keyStatusLbl.TextColor3 = KeyColors.Accent
	task.delay(2, function() if keyStatusLbl.Text == "Link copied to clipboard!" then keyStatusLbl.Text = "" end end)
end)

-- ============================================================
-- KEY VALIDATION
-- ============================================================
local keyValidated = false
local validKeys = {}

-- Fetch valid keys from GitHub
local function FetchKeys()
	local success, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/tristan16144/83NSD9SJDFBhjsas8efdGsdf4dHs/refs/heads/main/keys")
	end)
	if success and result then
		validKeys = {}
		for line in result:gmatch("[^\r\n]+") do
			local trimmed = line:match("^%s*(.-)%s*$")
			if trimmed and trimmed ~= "" then
				validKeys[trimmed] = true
			end
		end
		return true
	end
	return false
end

local function ValidateKey(inputKey)
	local trimmed = inputKey:match("^%s*(.-)%s*$")
	if trimmed and validKeys[trimmed] then
		return true
	end
	return false
end

-- Fetch keys on load
local fetchSuccess = FetchKeys()

local function OnKeySubmit()
	local inputKey = keyInputBox.Text

	if inputKey == "" then
		keyStatusLbl.Text = "✕ Please enter a key"
		keyStatusLbl.TextColor3 = KeyColors.Error
		return
	end

	-- Show loading state
	keySubmitBtn.Text = "⏳ Verifying..."
	keySubmitBtn.BackgroundColor3 = KeyColors.TextDim

	task.delay(0.5, function()
		-- Re-fetch keys to get latest
		FetchKeys()

		if ValidateKey(inputKey) then
			keyValidated = true
			keyStatusLbl.Text = "✓ Key validated successfully!"
			keyStatusLbl.TextColor3 = KeyColors.Success
			lockIcon.Text = "🔓"
			keySubmitBtn.Text = "✓ Authenticated"
			keySubmitBtn.BackgroundColor3 = KeyColors.Success

			-- Animate out
			task.delay(0.8, function()
				local fadeOut = TweenService:Create(keyCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0, 380, 0, 0),
					Position = UDim2.new(0.5, -190, 0.5, -10)
				})
				TweenService:Create(keyBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
				fadeOut:Play()
				fadeOut.Completed:Connect(function()
					KeyScreenGui:Destroy()
					-- Load main UI
					LoadMainUI()
				end)
			end)
		else
			keyStatusLbl.Text = "✕ Invalid key! Please try again."
			keyStatusLbl.TextColor3 = KeyColors.Error
			keySubmitBtn.Text = "🔓 Authenticate"
			keySubmitBtn.BackgroundColor3 = KeyColors.Accent

			-- Shake animation
			local origPos = keyInputFrame.Position
			for i = 1, 4 do
				TweenService:Create(keyInputFrame, TweenInfo.new(0.05), {Position = origPos + UDim2.new(0, (i % 2 == 0) and 6 or -6, 0, 0)}):Play()
				task.wait(0.05)
			end
			TweenService:Create(keyInputFrame, TweenInfo.new(0.05), {Position = origPos}):Play()

			TweenService:Create(kiStroke, TweenInfo.new(0.3), {Color = KeyColors.Error}):Play()
			task.delay(1, function()
				TweenService:Create(kiStroke, TweenInfo.new(0.3), {Color = KeyColors.Border}):Play()
			end)
		end
	end)
end

keySubmitBtn.MouseButton1Click:Connect(OnKeySubmit)
keyInputBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then OnKeySubmit() end
end)

-- ============================================================
-- MAIN UI FUNCTION (called after key validation)
-- ============================================================
function LoadMainUI()

-- ============================================================
-- STATE
-- ============================================================
local State = {
	AimbotEnabled = false,
	FOVCircleEnabled = false,
	FOVCircleColor = Color3.fromRGB(100, 80, 255),
	AimSmoothness = 5,
	FOVRadius = 100,
	TeamCheck = false,
	TeamCheckColor = Color3.fromRGB(255, 200, 50),
	VisibleCheck = false,
	VisibleCheckColor = Color3.fromRGB(0, 255, 150),
	TriggerBot = false,
	TriggerBotColor = Color3.fromRGB(255, 130, 0),
	TriggerDelay = 100,

	BoxESP = false,
	BoxESPColor = Color3.fromRGB(100, 255, 100),
	HealthBar = false,
	HealthBarColor = Color3.fromRGB(0, 255, 0),
	Chams = false,
	ChamsColor = Color3.fromRGB(100, 80, 255),
	SkeletonESP = false,
	SkeletonESPColor = Color3.fromRGB(255, 255, 255),
	Tracers = false,
	TracersColor = Color3.fromRGB(100, 200, 255),
	NameESP = false,
	NameESPColor = Color3.fromRGB(255, 255, 255),
	DistanceESP = false,
	DistanceESPColor = Color3.fromRGB(200, 200, 200),

	SpeedEnabled = false,
	SpeedAmount = 16,
	FlyEnabled = false,
	FlySpeed = 50,
	NoclipEnabled = false,
	InfJump = false,
	JumpPower = false,
	JumpPowerAmount = 50,
}

local Connections = {}
local ESPObjects = {}
local SkeletonObjects = {}
local HealthBarObjects = {}
local ChamObjects = {}
local FOVCircle = nil
local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local CharacterConnections = {}
local ToggleReferences = {}
local SliderReferences = {}
local ColorPreviewReferences = {}

local function AddConnection(name, connection)
	if Connections[name] then pcall(function() Connections[name]:Disconnect() end) end
	Connections[name] = connection
end

local function CleanupPlayerESP(player)
	if ESPObjects[player] then
		for _, obj in pairs(ESPObjects[player]) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end
		ESPObjects[player] = nil
	end
end

local function CleanupPlayerSkeleton(player)
	if SkeletonObjects[player] then
		for _, obj in pairs(SkeletonObjects[player]) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end
		SkeletonObjects[player] = nil
	end
end

local function CleanupPlayerHealthBar(player)
	if HealthBarObjects[player] then
		for _, obj in pairs(HealthBarObjects[player]) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end
		HealthBarObjects[player] = nil
	end
end

local function CleanupAllESP()
	for p, o in pairs(ESPObjects) do for _, obj in pairs(o) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end end
	ESPObjects = {}
end

local function CleanupAllSkeleton()
	for p, o in pairs(SkeletonObjects) do for _, obj in pairs(o) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end end
	SkeletonObjects = {}
end

local function CleanupAllHealthBars()
	for p, o in pairs(HealthBarObjects) do for _, obj in pairs(o) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end end
	HealthBarObjects = {}
end

local function CleanupPlayerChams(player)
	if ChamObjects[player] then pcall(function() if ChamObjects[player] and ChamObjects[player].Parent then ChamObjects[player]:Destroy() end end); ChamObjects[player] = nil end
end

local function CleanupAllChams()
	for _, h in pairs(ChamObjects) do pcall(function() if h and h.Parent then h:Destroy() end end) end
	ChamObjects = {}
end

local function CleanupAll()
	for _, conn in pairs(Connections) do pcall(function() conn:Disconnect() end) end
	Connections = {}
	for _, conns in pairs(CharacterConnections) do for _, conn in pairs(conns) do pcall(function() conn:Disconnect() end) end end
	CharacterConnections = {}
end

local ConfigFolder = "ModernUIConfigs"
pcall(function() if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end end)

pcall(function() if game:GetService("CoreGui"):FindFirstChild("ModernUI_Main") then game:GetService("CoreGui"):FindFirstChild("ModernUI_Main"):Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI_Main"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

pcall(function() if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end end)
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Colors = {
	Background = Color3.fromRGB(15, 15, 22),
	NavBar = Color3.fromRGB(20, 20, 30),
	ButtonDefault = Color3.fromRGB(28, 28, 40),
	ButtonHover = Color3.fromRGB(38, 38, 55),
	ButtonActive = Color3.fromRGB(90, 70, 235),
	Panel = Color3.fromRGB(18, 18, 28),
	Text = Color3.fromRGB(220, 220, 235),
	TextDim = Color3.fromRGB(130, 130, 155),
	ToggleOff = Color3.fromRGB(50, 50, 68),
	ToggleOn = Color3.fromRGB(90, 70, 235),
	SliderBg = Color3.fromRGB(35, 35, 50),
	SliderFill = Color3.fromRGB(90, 70, 235),
	Accent = Color3.fromRGB(90, 70, 235),
	Border = Color3.fromRGB(35, 35, 50),
	ColorPickerBg = Color3.fromRGB(22, 22, 34),
	NotifBg = Color3.fromRGB(20, 20, 30),
	NotifOn = Color3.fromRGB(80, 220, 120),
	NotifOff = Color3.fromRGB(255, 80, 80),
}

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 260, 1, -20)
NotifContainer.Position = UDim2.new(1, -270, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.ZIndex = 100
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

local notifCounter = 0

local function SendNotification(title, enabled)
	notifCounter += 1
	local order = notifCounter
	local nf = Instance.new("Frame")
	nf.Size = UDim2.new(0, 250, 0, 0)
	nf.BackgroundColor3 = Colors.NotifBg
	nf.BorderSizePixel = 0
	nf.LayoutOrder = order
	nf.ZIndex = 101
	nf.ClipsDescendants = true
	nf.Parent = NotifContainer
	Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 8)
	local ns = Instance.new("UIStroke", nf)
	ns.Color = enabled and Colors.NotifOn or Colors.NotifOff
	ns.Thickness = 1; ns.Transparency = 0.3

	local ab = Instance.new("Frame")
	ab.Size = UDim2.new(0, 3, 1, 0)
	ab.BackgroundColor3 = enabled and Colors.NotifOn or Colors.NotifOff
	ab.BorderSizePixel = 0; ab.ZIndex = 102; ab.Parent = nf
	Instance.new("UICorner", ab).CornerRadius = UDim.new(0, 2)

	local ic = Instance.new("TextLabel")
	ic.Size = UDim2.new(0, 24, 0, 24)
	ic.Position = UDim2.new(0, 10, 0.5, -12)
	ic.BackgroundTransparency = 1
	ic.Text = enabled and "✓" or "✕"
	ic.TextColor3 = enabled and Colors.NotifOn or Colors.NotifOff
	ic.TextSize = 16; ic.Font = Enum.Font.GothamBold; ic.ZIndex = 102; ic.Parent = nf

	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.new(1, -70, 0, 16)
	tl.Position = UDim2.new(0, 38, 0, 6)
	tl.BackgroundTransparency = 1; tl.Text = title; tl.TextColor3 = Colors.Text
	tl.TextSize = 12; tl.Font = Enum.Font.GothamBold; tl.TextXAlignment = Enum.TextXAlignment.Left
	tl.TextTruncate = Enum.TextTruncate.AtEnd; tl.ZIndex = 102; tl.Parent = nf

	local sl = Instance.new("TextLabel")
	sl.Size = UDim2.new(1, -70, 0, 14)
	sl.Position = UDim2.new(0, 38, 0, 22)
	sl.BackgroundTransparency = 1
	sl.Text = enabled and "Enabled" or "Disabled"
	sl.TextColor3 = enabled and Colors.NotifOn or Colors.NotifOff
	sl.TextSize = 10; sl.Font = Enum.Font.GothamSemibold; sl.TextXAlignment = Enum.TextXAlignment.Left
	sl.ZIndex = 102; sl.Parent = nf

	local pbg = Instance.new("Frame")
	pbg.Size = UDim2.new(1, -8, 0, 2)
	pbg.Position = UDim2.new(0, 4, 1, -5)
	pbg.BackgroundColor3 = Colors.SliderBg; pbg.BorderSizePixel = 0; pbg.ZIndex = 102; pbg.Parent = nf
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)

	local pf = Instance.new("Frame")
	pf.Size = UDim2.new(1, 0, 1, 0)
	pf.BackgroundColor3 = enabled and Colors.NotifOn or Colors.NotifOff
	pf.BorderSizePixel = 0; pf.ZIndex = 103; pf.Parent = pbg
	Instance.new("UICorner", pf).CornerRadius = UDim.new(1, 0)

	TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 44)}):Play()
	TweenService:Create(pf, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

	task.delay(2.5, function()
		if nf and nf.Parent then
			local fo = TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 250, 0, 0), BackgroundTransparency = 1})
			fo:Play(); fo.Completed:Connect(function() if nf and nf.Parent then nf:Destroy() end end)
		end
	end)
end

local function SendInfoNotification(text)
	notifCounter += 1
	local order = notifCounter
	local nf = Instance.new("Frame")
	nf.Size = UDim2.new(0, 250, 0, 0)
	nf.BackgroundColor3 = Colors.NotifBg; nf.BorderSizePixel = 0; nf.LayoutOrder = order
	nf.ZIndex = 101; nf.ClipsDescendants = true; nf.Parent = NotifContainer
	Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 8)
	local ns2 = Instance.new("UIStroke", nf); ns2.Color = Colors.Accent; ns2.Thickness = 1; ns2.Transparency = 0.3

	local ab2 = Instance.new("Frame"); ab2.Size = UDim2.new(0, 3, 1, 0); ab2.BackgroundColor3 = Colors.Accent; ab2.BorderSizePixel = 0; ab2.ZIndex = 102; ab2.Parent = nf
	Instance.new("UICorner", ab2).CornerRadius = UDim.new(0, 2)

	local ic2 = Instance.new("TextLabel"); ic2.Size = UDim2.new(0, 24, 0, 24); ic2.Position = UDim2.new(0, 10, 0.5, -12); ic2.BackgroundTransparency = 1
	ic2.Text = "ℹ"; ic2.TextColor3 = Colors.Accent; ic2.TextSize = 16; ic2.Font = Enum.Font.GothamBold; ic2.ZIndex = 102; ic2.Parent = nf

	local tl2 = Instance.new("TextLabel"); tl2.Size = UDim2.new(1, -50, 1, 0); tl2.Position = UDim2.new(0, 38, 0, 0); tl2.BackgroundTransparency = 1
	tl2.Text = text; tl2.TextColor3 = Colors.Text; tl2.TextSize = 11; tl2.Font = Enum.Font.GothamSemibold; tl2.TextXAlignment = Enum.TextXAlignment.Left
	tl2.TextWrapped = true; tl2.ZIndex = 102; tl2.Parent = nf

	local pbg2 = Instance.new("Frame"); pbg2.Size = UDim2.new(1, -8, 0, 2); pbg2.Position = UDim2.new(0, 4, 1, -5)
	pbg2.BackgroundColor3 = Colors.SliderBg; pbg2.BorderSizePixel = 0; pbg2.ZIndex = 102; pbg2.Parent = nf
	Instance.new("UICorner", pbg2).CornerRadius = UDim.new(1, 0)

	local pf2 = Instance.new("Frame"); pf2.Size = UDim2.new(1, 0, 1, 0); pf2.BackgroundColor3 = Colors.Accent; pf2.BorderSizePixel = 0; pf2.ZIndex = 103; pf2.Parent = pbg2
	Instance.new("UICorner", pf2).CornerRadius = UDim.new(1, 0)

	TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 40)}):Play()
	TweenService:Create(pf2, TweenInfo.new(3, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

	task.delay(3, function()
		if nf and nf.Parent then
			local fo2 = TweenService:Create(nf, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 250, 0, 0), BackgroundTransparency = 1})
			fo2:Play(); fo2.Completed:Connect(function() if nf and nf.Parent then nf:Destroy() end end)
		end
	end)
end

-- ============================================================
-- MAIN FRAME
-- ============================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 440)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -220)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0; MainFrame.ClipsDescendants = true; MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Colors.Border

local Dragging, DragStart, StartPos = false, nil, nil

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 34); TitleBar.BackgroundColor3 = Colors.NavBar; TitleBar.BorderSizePixel = 0; TitleBar.ZIndex = 5; TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)
local tc = Instance.new("Frame"); tc.Size = UDim2.new(1, 0, 0, 12); tc.Position = UDim2.new(0, 0, 1, -12); tc.BackgroundColor3 = Colors.NavBar; tc.BorderSizePixel = 0; tc.ZIndex = 5; tc.Parent = TitleBar

local tl3 = Instance.new("TextLabel"); tl3.Size = UDim2.new(0, 300, 1, 0); tl3.Position = UDim2.new(0, 14, 0, 0); tl3.BackgroundTransparency = 1
tl3.Text = "🎮 Modern UI"; tl3.TextColor3 = Colors.Text; tl3.TextSize = 14; tl3.Font = Enum.Font.GothamBold; tl3.TextXAlignment = Enum.TextXAlignment.Left; tl3.ZIndex = 6; tl3.Parent = TitleBar

local cb = Instance.new("TextButton"); cb.Size = UDim2.new(0, 28, 0, 28); cb.Position = UDim2.new(1, -32, 0, 3); cb.BackgroundTransparency = 1
cb.Text = "✕"; cb.TextColor3 = Colors.TextDim; cb.TextSize = 14; cb.Font = Enum.Font.GothamBold; cb.ZIndex = 6; cb.Parent = TitleBar
cb.MouseEnter:Connect(function() cb.TextColor3 = Color3.fromRGB(255, 70, 70) end)
cb.MouseLeave:Connect(function() cb.TextColor3 = Colors.TextDim end)
cb.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local mb = Instance.new("TextButton"); mb.Size = UDim2.new(0, 28, 0, 28); mb.Position = UDim2.new(1, -58, 0, 3); mb.BackgroundTransparency = 1
mb.Text = "—"; mb.TextColor3 = Colors.TextDim; mb.TextSize = 14; mb.Font = Enum.Font.GothamBold; mb.ZIndex = 6; mb.Parent = TitleBar
mb.MouseEnter:Connect(function() mb.TextColor3 = Colors.Accent end)
mb.MouseLeave:Connect(function() mb.TextColor3 = Colors.TextDim end)

local UIVisible = true
mb.MouseButton1Click:Connect(function()
	UIVisible = false
	local t = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 540, 0, 0)})
	t:Play(); t.Completed:Connect(function() if not UIVisible then MainFrame.Visible = false end end)
end)

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Dragging = true; DragStart = input.Position; StartPos = MainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - DragStart; MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + d.X, StartPos.Y.Scale, StartPos.Y.Offset + d.Y)
	end
end)

-- NavBar
local NavBar = Instance.new("Frame"); NavBar.Size = UDim2.new(1, -16, 0, 36); NavBar.Position = UDim2.new(0, 8, 0, 38)
NavBar.BackgroundColor3 = Colors.NavBar; NavBar.BorderSizePixel = 0; NavBar.ZIndex = 3; NavBar.Parent = MainFrame
Instance.new("UICorner", NavBar).CornerRadius = UDim.new(0, 8)
local nl = Instance.new("UIListLayout", NavBar); nl.FillDirection = Enum.FillDirection.Horizontal; nl.HorizontalAlignment = Enum.HorizontalAlignment.Center
nl.VerticalAlignment = Enum.VerticalAlignment.Center; nl.Padding = UDim.new(0, 4)
local np = Instance.new("UIPadding", NavBar); np.PaddingLeft = UDim.new(0, 4); np.PaddingRight = UDim.new(0, 4)

local TabButtons = {}
local TabNames = {"Aimbot", "Visuals", "Misc", "Config"}
local TabIcons = {Aimbot="🎯", Visuals="👁", Misc="⚡", Config="💾"}
local ActiveTab = "Aimbot"

for i, name in ipairs(TabNames) do
	local btn = Instance.new("TextButton"); btn.Size = UDim2.new(0, 124, 0, 28); btn.BackgroundColor3 = Colors.ButtonDefault; btn.BorderSizePixel = 0
	btn.Text = TabIcons[name].." "..name; btn.TextColor3 = Colors.TextDim; btn.TextSize = 12; btn.Font = Enum.Font.GothamSemibold
	btn.ZIndex = 4; btn.AutoButtonColor = false; btn.LayoutOrder = i; btn.Parent = NavBar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	TabButtons[name] = btn
	btn.MouseEnter:Connect(function() if ActiveTab ~= name then TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Colors.ButtonHover}):Play() end end)
	btn.MouseLeave:Connect(function() if ActiveTab ~= name then TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Colors.ButtonDefault}):Play() end end)
end

local ContentContainer = Instance.new("Frame"); ContentContainer.Size = UDim2.new(1, -16, 1, -82); ContentContainer.Position = UDim2.new(0, 8, 0, 78)
ContentContainer.BackgroundColor3 = Colors.Panel; ContentContainer.BorderSizePixel = 0; ContentContainer.ClipsDescendants = true; ContentContainer.ZIndex = 2; ContentContainer.Parent = MainFrame
Instance.new("UICorner", ContentContainer).CornerRadius = UDim.new(0, 8)

-- ============================================================
-- COLOR PICKER
-- ============================================================
local CPOverlay = Instance.new("Frame"); CPOverlay.Size = UDim2.new(1,0,1,0); CPOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0); CPOverlay.BackgroundTransparency = 0.5
CPOverlay.ZIndex = 50; CPOverlay.Visible = false; CPOverlay.Parent = ScreenGui

local CPFrame = Instance.new("Frame"); CPFrame.Size = UDim2.new(0,280,0,360); CPFrame.Position = UDim2.new(0.5,-140,0.5,-180)
CPFrame.BackgroundColor3 = Colors.ColorPickerBg; CPFrame.BorderSizePixel = 0; CPFrame.ZIndex = 51; CPFrame.Parent = CPOverlay
Instance.new("UICorner", CPFrame).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", CPFrame).Color = Colors.Border

local cpt = Instance.new("TextLabel"); cpt.Size = UDim2.new(1,0,0,32); cpt.BackgroundTransparency = 1; cpt.Text = "🎨 Color Picker"
cpt.TextColor3 = Colors.Text; cpt.TextSize = 13; cpt.Font = Enum.Font.GothamBold; cpt.ZIndex = 52; cpt.Parent = CPFrame

local HSF = Instance.new("Frame"); HSF.Size = UDim2.new(0,240,0,180); HSF.Position = UDim2.new(0.5,-120,0,36)
HSF.BackgroundColor3 = Color3.fromRGB(255,0,0); HSF.BorderSizePixel = 0; HSF.ZIndex = 52; HSF.Parent = CPFrame
Instance.new("UICorner", HSF).CornerRadius = UDim.new(0, 6)

local wo = Instance.new("Frame"); wo.Size = UDim2.new(1,0,1,0); wo.BackgroundColor3 = Color3.fromRGB(255,255,255); wo.BorderSizePixel = 0; wo.ZIndex = 53; wo.Parent = HSF
Instance.new("UICorner", wo).CornerRadius = UDim.new(0, 6)
local wg = Instance.new("UIGradient", wo); wg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})

local bo = Instance.new("Frame"); bo.Size = UDim2.new(1,0,1,0); bo.BackgroundColor3 = Color3.fromRGB(0,0,0); bo.BorderSizePixel = 0; bo.ZIndex = 54; bo.Parent = HSF
Instance.new("UICorner", bo).CornerRadius = UDim.new(0, 6)
local bg2 = Instance.new("UIGradient", bo); bg2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)}); bg2.Rotation = 90

local svc = Instance.new("Frame"); svc.Size = UDim2.new(0,14,0,14); svc.BackgroundTransparency = 1; svc.ZIndex = 56; svc.Parent = HSF
local svi = Instance.new("Frame", svc); svi.Size = UDim2.new(1,0,1,0); svi.BackgroundTransparency = 1; svi.ZIndex = 57
Instance.new("UICorner", svi).CornerRadius = UDim.new(1,0); local svs = Instance.new("UIStroke", svi); svs.Color = Color3.fromRGB(255,255,255); svs.Thickness = 2

local svb = Instance.new("TextButton"); svb.Size = UDim2.new(1,0,1,0); svb.BackgroundTransparency = 1; svb.Text = ""; svb.ZIndex = 58; svb.Parent = HSF

local hb = Instance.new("Frame"); hb.Size = UDim2.new(0,240,0,18); hb.Position = UDim2.new(0.5,-120,0,224); hb.BackgroundColor3 = Color3.fromRGB(255,255,255)
hb.BorderSizePixel = 0; hb.ZIndex = 52; hb.Parent = CPFrame; Instance.new("UICorner", hb).CornerRadius = UDim.new(1,0)
local hgr = Instance.new("UIGradient", hb)
hgr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),ColorSequenceKeypoint.new(0.167,Color3.fromHSV(0.167,1,1)),
ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromHSV(0.5,1,1)),
ColorSequenceKeypoint.new(0.667,Color3.fromHSV(0.667,1,1)),ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),ColorSequenceKeypoint.new(1,Color3.fromHSV(0.999,1,1))})

local hc = Instance.new("Frame"); hc.Size = UDim2.new(0,6,0,24); hc.Position = UDim2.new(0,-3,0.5,-12); hc.BackgroundColor3 = Color3.fromRGB(255,255,255)
hc.BorderSizePixel = 0; hc.ZIndex = 55; hc.Parent = hb; Instance.new("UICorner", hc).CornerRadius = UDim.new(1,0)

local hbb = Instance.new("TextButton"); hbb.Size = UDim2.new(1,0,1,8); hbb.Position = UDim2.new(0,0,0,-4); hbb.BackgroundTransparency = 1; hbb.Text = ""; hbb.ZIndex = 57; hbb.Parent = hb

local pf3 = Instance.new("Frame"); pf3.Size = UDim2.new(0,50,0,36); pf3.Position = UDim2.new(0,20,0,254); pf3.BackgroundColor3 = Color3.fromRGB(255,0,0)
pf3.BorderSizePixel = 0; pf3.ZIndex = 52; pf3.Parent = CPFrame; Instance.new("UICorner", pf3).CornerRadius = UDim.new(0,6); Instance.new("UIStroke", pf3).Color = Colors.Border

local hi = Instance.new("TextBox"); hi.Size = UDim2.new(0,170,0,36); hi.Position = UDim2.new(0,80,0,254); hi.BackgroundColor3 = Colors.ButtonDefault
hi.BorderSizePixel = 0; hi.Text = "#FF0000"; hi.TextColor3 = Colors.Text; hi.PlaceholderText = "#RRGGBB"; hi.PlaceholderColor3 = Colors.TextDim
hi.TextSize = 13; hi.Font = Enum.Font.GothamSemibold; hi.ZIndex = 52; hi.ClearTextOnFocus = false; hi.Parent = CPFrame
Instance.new("UICorner", hi).CornerRadius = UDim.new(0, 6)

local rl = Instance.new("TextLabel"); rl.Size = UDim2.new(0,240,0,20); rl.Position = UDim2.new(0.5,-120,0,296); rl.BackgroundTransparency = 1
rl.Text = "R: 255  G: 0  B: 0"; rl.TextColor3 = Colors.TextDim; rl.TextSize = 11; rl.Font = Enum.Font.GothamSemibold; rl.ZIndex = 52; rl.Parent = CPFrame

local cfb = Instance.new("TextButton"); cfb.Size = UDim2.new(0,112,0,32); cfb.Position = UDim2.new(0,20,1,-44); cfb.BackgroundColor3 = Colors.Accent
cfb.BorderSizePixel = 0; cfb.Text = "✓ Apply"; cfb.TextColor3 = Color3.fromRGB(255,255,255); cfb.TextSize = 12; cfb.Font = Enum.Font.GothamBold
cfb.ZIndex = 52; cfb.AutoButtonColor = false; cfb.Parent = CPFrame; Instance.new("UICorner", cfb).CornerRadius = UDim.new(0, 6)

local cnb = Instance.new("TextButton"); cnb.Size = UDim2.new(0,112,0,32); cnb.Position = UDim2.new(1,-132,1,-44); cnb.BackgroundColor3 = Colors.ButtonDefault
cnb.BorderSizePixel = 0; cnb.Text = "✕ Cancel"; cnb.TextColor3 = Colors.Text; cnb.TextSize = 12; cnb.Font = Enum.Font.GothamBold
cnb.ZIndex = 52; cnb.AutoButtonColor = false; cnb.Parent = CPFrame; Instance.new("UICorner", cnb).CornerRadius = UDim.new(0, 6)

cfb.MouseEnter:Connect(function() TweenService:Create(cfb, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(110,90,255)}):Play() end)
cfb.MouseLeave:Connect(function() TweenService:Create(cfb, TweenInfo.new(0.12), {BackgroundColor3 = Colors.Accent}):Play() end)
cnb.MouseEnter:Connect(function() TweenService:Create(cnb, TweenInfo.new(0.12), {BackgroundColor3 = Colors.ButtonHover}):Play() end)
cnb.MouseLeave:Connect(function() TweenService:Create(cnb, TweenInfo.new(0.12), {BackgroundColor3 = Colors.ButtonDefault}):Play() end)

local cpH2, cpS2, cpV2 = 0, 1, 1
local cpDSV, cpDH = false, false
local cpSK, cpPV = nil, nil

local function UCP()
	local c = Color3.fromHSV(cpH2, cpS2, cpV2)
	HSF.BackgroundColor3 = Color3.fromHSV(cpH2, 1, 1); pf3.BackgroundColor3 = c
	local r,g,b2 = math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)
	hi.Text = string.format("#%02X%02X%02X", r, g, b2); rl.Text = string.format("R: %d  G: %d  B: %d", r, g, b2)
	svc.Position = UDim2.new(cpS2, -7, 1-cpV2, -7); hc.Position = UDim2.new(cpH2, -3, 0.5, -12)
end

local function OCP(cur, sk, pv) cpH2, cpS2, cpV2 = Color3.toHSV(cur); cpSK = sk; cpPV = pv; UCP(); CPOverlay.Visible = true end
local function CCP() CPOverlay.Visible = false; cpDSV = false; cpDH = false; cpSK = nil; cpPV = nil end

svb.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		cpDSV = true; local p,s = HSF.AbsolutePosition, HSF.AbsoluteSize
		cpS2 = math.clamp((input.Position.X-p.X)/s.X,0,1); cpV2 = math.clamp(1-(input.Position.Y-p.Y)/s.Y,0,1); UCP()
	end
end)
svb.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then cpDSV = false end end)

hbb.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		cpDH = true; local p,s = hb.AbsolutePosition, hb.AbsoluteSize; cpH2 = math.clamp((input.Position.X-p.X)/s.X,0,0.999); UCP()
	end
end)
hbb.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then cpDH = false end end)

UserInputService.InputChanged:Connect(function(input)
	if not CPOverlay.Visible then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
	if cpDSV then local p,s = HSF.AbsolutePosition, HSF.AbsoluteSize; cpS2 = math.clamp((input.Position.X-p.X)/s.X,0,1); cpV2 = math.clamp(1-(input.Position.Y-p.Y)/s.Y,0,1); UCP()
	elseif cpDH then local p,s = hb.AbsolutePosition, hb.AbsoluteSize; cpH2 = math.clamp((input.Position.X-p.X)/s.X,0,0.999); UCP() end
end)

hi.FocusLost:Connect(function()
	local hex = hi.Text:gsub("#",""); if #hex == 6 then
		local r2,g2,b3 = tonumber(hex:sub(1,2),16), tonumber(hex:sub(3,4),16), tonumber(hex:sub(5,6),16)
		if r2 and g2 and b3 then cpH2,cpS2,cpV2 = Color3.toHSV(Color3.fromRGB(r2,g2,b3)); UCP() end
	end
end)

cfb.MouseButton1Click:Connect(function()
	local color = Color3.fromHSV(cpH2, cpS2, cpV2)
	if cpSK then State[cpSK] = color end; if cpPV then cpPV.BackgroundColor3 = color end
	if cpSK == "ChamsColor" then for _, h in pairs(ChamObjects) do pcall(function() if h and h.Parent then h.FillColor = color end end) end
	elseif cpSK == "FOVCircleColor" then if FOVCircle then FOVCircle.Color = color end end
	CCP()
end)
cnb.MouseButton1Click:Connect(CCP)

local cpBg2 = Instance.new("TextButton"); cpBg2.Size = UDim2.new(1,0,1,0); cpBg2.BackgroundTransparency = 1; cpBg2.Text = ""; cpBg2.ZIndex = 50; cpBg2.Parent = CPOverlay
cpBg2.MouseButton1Click:Connect(function()
	local m = UserInputService:GetMouseLocation(); local cp2, cs2 = CPFrame.AbsolutePosition, CPFrame.AbsoluteSize
	if m.X < cp2.X or m.X > cp2.X+cs2.X or m.Y < cp2.Y or m.Y > cp2.Y+cs2.Y then CCP() end
end)

-- ============================================================
-- UI BUILDERS
-- ============================================================
local function CreatePanel(name)
	local s = Instance.new("ScrollingFrame"); s.Name = name.."Panel"; s.Size = UDim2.new(1,0,1,0); s.BackgroundTransparency = 1; s.BorderSizePixel = 0
	s.ScrollBarThickness = 3; s.ScrollBarImageColor3 = Colors.Accent; s.CanvasSize = UDim2.new(0,0,0,0); s.AutomaticCanvasSize = Enum.AutomaticSize.Y
	s.Visible = false; s.ZIndex = 3; s.Parent = ContentContainer
	local l = Instance.new("UIListLayout", s); l.Padding = UDim.new(0,5); l.SortOrder = Enum.SortOrder.LayoutOrder
	local p = Instance.new("UIPadding", s); p.PaddingTop = UDim.new(0,8); p.PaddingBottom = UDim.new(0,8); p.PaddingLeft = UDim.new(0,10); p.PaddingRight = UDim.new(0,10)
	return s
end

local function CreateSectionHeader(parent, text, order)
	local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,0,0,22); l.BackgroundTransparency = 1; l.Text = string.upper(text)
	l.TextColor3 = Colors.Accent; l.TextSize = 10; l.Font = Enum.Font.GothamBold; l.TextXAlignment = Enum.TextXAlignment.Left; l.LayoutOrder = order; l.ZIndex = 4; l.Parent = parent
end

local function CreateToggle(parent, text, stateKey, order, callback, colorStateKey)
	local frame = Instance.new("Frame"); frame.Size = UDim2.new(1,0,0,34); frame.BackgroundColor3 = Colors.ButtonDefault; frame.BorderSizePixel = 0
	frame.LayoutOrder = order; frame.ZIndex = 4; frame.Parent = parent; Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

	local txp = colorStateKey and UDim2.new(1,-82,0.5,-9) or UDim2.new(1,-48,0.5,-9)
	local tbg = Instance.new("Frame"); tbg.Size = UDim2.new(0,38,0,18); tbg.Position = txp
	tbg.BackgroundColor3 = State[stateKey] and Colors.ToggleOn or Colors.ToggleOff; tbg.BorderSizePixel = 0; tbg.ZIndex = 5; tbg.Parent = frame
	Instance.new("UICorner", tbg).CornerRadius = UDim.new(1,0)

	local cir = Instance.new("Frame"); cir.Size = UDim2.new(0,14,0,14)
	cir.Position = State[stateKey] and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
	cir.BackgroundColor3 = Color3.fromRGB(255,255,255); cir.BorderSizePixel = 0; cir.ZIndex = 6; cir.Parent = tbg
	Instance.new("UICorner", cir).CornerRadius = UDim.new(1,0)

	local cpv = nil
	if colorStateKey then
		cpv = Instance.new("TextButton"); cpv.Size = UDim2.new(0,22,0,22); cpv.Position = UDim2.new(1,-32,0.5,-11)
		cpv.BackgroundColor3 = State[colorStateKey]; cpv.BorderSizePixel = 0; cpv.Text = ""; cpv.ZIndex = 8; cpv.AutoButtonColor = false; cpv.Parent = frame
		Instance.new("UICorner", cpv).CornerRadius = UDim.new(0,4)
		local cs3 = Instance.new("UIStroke", cpv); cs3.Color = Color3.fromRGB(55,55,70); cs3.Thickness = 1.5
		cpv.MouseEnter:Connect(function() TweenService:Create(cs3, TweenInfo.new(0.12), {Color = Color3.fromRGB(255,255,255)}):Play() end)
		cpv.MouseLeave:Connect(function() TweenService:Create(cs3, TweenInfo.new(0.12), {Color = Color3.fromRGB(55,55,70)}):Play() end)
		cpv.MouseButton1Click:Connect(function() OCP(State[colorStateKey], colorStateKey, cpv) end)
		ColorPreviewReferences[colorStateKey] = cpv
	end

	local lr = colorStateKey and -90 or -56
	local lb = Instance.new("TextLabel"); lb.Size = UDim2.new(1,lr,1,0); lb.Position = UDim2.new(0,10,0,0); lb.BackgroundTransparency = 1
	lb.Text = text; lb.TextColor3 = Colors.Text; lb.TextSize = 12; lb.Font = Enum.Font.GothamSemibold; lb.TextXAlignment = Enum.TextXAlignment.Left; lb.ZIndex = 5; lb.Parent = frame

	local function sv(enabled)
		TweenService:Create(tbg, TweenInfo.new(0.18), {BackgroundColor3 = enabled and Colors.ToggleOn or Colors.ToggleOff}):Play()
		TweenService:Create(cir, TweenInfo.new(0.18, Enum.EasingStyle.Back), {Position = enabled and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
	end
	ToggleReferences[stateKey] = {setVisual = sv, callback = callback}

	local ca = Instance.new("TextButton"); ca.Size = UDim2.new(1, colorStateKey and -40 or 0, 1, 0); ca.BackgroundTransparency = 1; ca.Text = ""; ca.ZIndex = 7; ca.Parent = frame
	ca.MouseEnter:Connect(function() TweenService:Create(frame, TweenInfo.new(0.12), {BackgroundColor3 = Colors.ButtonHover}):Play() end)
	ca.MouseLeave:Connect(function() TweenService:Create(frame, TweenInfo.new(0.12), {BackgroundColor3 = Colors.ButtonDefault}):Play() end)
	ca.MouseButton1Click:Connect(function()
		State[stateKey] = not State[stateKey]; sv(State[stateKey])
		if callback then callback(State[stateKey]) end; SendNotification(text, State[stateKey])
	end)
	return frame
end

local function CreateSlider(parent, text, min, max, stateKey, order, callback)
	local frame = Instance.new("Frame"); frame.Size = UDim2.new(1,0,0,48); frame.BackgroundColor3 = Colors.ButtonDefault; frame.BorderSizePixel = 0
	frame.LayoutOrder = order; frame.ZIndex = 4; frame.Parent = parent; Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

	local lb2 = Instance.new("TextLabel"); lb2.Size = UDim2.new(1,-55,0,20); lb2.Position = UDim2.new(0,10,0,3); lb2.BackgroundTransparency = 1
	lb2.Text = text; lb2.TextColor3 = Colors.Text; lb2.TextSize = 12; lb2.Font = Enum.Font.GothamSemibold; lb2.TextXAlignment = Enum.TextXAlignment.Left; lb2.ZIndex = 5; lb2.Parent = frame

	local vl2 = Instance.new("TextLabel"); vl2.Size = UDim2.new(0,45,0,20); vl2.Position = UDim2.new(1,-52,0,3); vl2.BackgroundTransparency = 1
	vl2.Text = tostring(State[stateKey]); vl2.TextColor3 = Colors.Accent; vl2.TextSize = 12; vl2.Font = Enum.Font.GothamBold; vl2.TextXAlignment = Enum.TextXAlignment.Right; vl2.ZIndex = 5; vl2.Parent = frame

	local sbg2 = Instance.new("Frame"); sbg2.Size = UDim2.new(1,-20,0,5); sbg2.Position = UDim2.new(0,10,0,30); sbg2.BackgroundColor3 = Colors.SliderBg
	sbg2.BorderSizePixel = 0; sbg2.ZIndex = 5; sbg2.Parent = frame; Instance.new("UICorner", sbg2).CornerRadius = UDim.new(1,0)

	local fp2 = (State[stateKey]-min)/(max-min)
	local sf2 = Instance.new("Frame"); sf2.Size = UDim2.new(fp2,0,1,0); sf2.BackgroundColor3 = Colors.SliderFill; sf2.BorderSizePixel = 0; sf2.ZIndex = 6; sf2.Parent = sbg2
	Instance.new("UICorner", sf2).CornerRadius = UDim.new(1,0)

	local kb2 = Instance.new("Frame"); kb2.Size = UDim2.new(0,12,0,12); kb2.Position = UDim2.new(fp2,-6,0.5,-6); kb2.BackgroundColor3 = Color3.fromRGB(255,255,255)
	kb2.BorderSizePixel = 0; kb2.ZIndex = 7; kb2.Parent = sbg2; Instance.new("UICorner", kb2).CornerRadius = UDim.new(1,0)

	local function sv2(value) local p2 = (value-min)/(max-min); sf2.Size = UDim2.new(p2,0,1,0); kb2.Position = UDim2.new(p2,-6,0.5,-6); vl2.Text = tostring(value) end
	SliderReferences[stateKey] = {setVisual = sv2, callback = callback, min = min, max = max}

	local sliding = false
	local function upd(pos) local aP,aS = sbg2.AbsolutePosition, sbg2.AbsoluteSize; local rX = math.clamp((pos.X-aP.X)/aS.X,0,1)
		local val = math.floor(min+(max-min)*rX+0.5); State[stateKey] = val; sv2(val); if callback then callback(val) end end

	local ib2 = Instance.new("TextButton"); ib2.Size = UDim2.new(1,10,0,22); ib2.Position = UDim2.new(0,-5,0,22); ib2.BackgroundTransparency = 1; ib2.Text = ""; ib2.ZIndex = 8; ib2.Parent = frame
	ib2.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true; upd(input.Position) end end)
	ib2.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end end)
	UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then upd(input.Position) end end)
	return frame
end

-- Forward declarations
local UpdateAllESP, CreateESPForPlayer, UpdateAllChams, CreateChamsForPlayer, ApplySpeed, ApplyFly
local CreateSkeletonForPlayer, UpdateAllSkeleton, CreateHealthBarForPlayer, UpdateAllHealthBars

-- ============================================================
-- PANELS
-- ============================================================
local AimbotPanel = CreatePanel("Aimbot")
CreateSectionHeader(AimbotPanel, "Targeting", 1)
CreateToggle(AimbotPanel, "Enable Aimbot", "AimbotEnabled", 2, function() end)
CreateToggle(AimbotPanel, "FOV Circle", "FOVCircleEnabled", 3, function(e) if FOVCircle then FOVCircle.Visible = e end end, "FOVCircleColor")
CreateToggle(AimbotPanel, "Team Check", "TeamCheck", 4, function() end, "TeamCheckColor")
CreateToggle(AimbotPanel, "Visible Check", "VisibleCheck", 5, function() end, "VisibleCheckColor")
CreateSectionHeader(AimbotPanel, "Trigger Bot", 6)
CreateToggle(AimbotPanel, "Trigger Bot", "TriggerBot", 7, function() end, "TriggerBotColor")
CreateSlider(AimbotPanel, "Trigger Delay (ms)", 0, 500, "TriggerDelay", 8, function() end)
CreateSectionHeader(AimbotPanel, "Settings", 9)
CreateSlider(AimbotPanel, "Aim Smoothness", 1, 20, "AimSmoothness", 10, function() end)
CreateSlider(AimbotPanel, "FOV Radius", 30, 500, "FOVRadius", 11, function(v) if FOVCircle then FOVCircle.Radius = v end end)

local VisualsPanel = CreatePanel("Visuals")
CreateSectionHeader(VisualsPanel, "Player ESP", 1)
CreateToggle(VisualsPanel, "Box ESP", "BoxESP", 2, function() UpdateAllESP() end, "BoxESPColor")
CreateToggle(VisualsPanel, "Health Bar", "HealthBar", 3, function() UpdateAllHealthBars() end, "HealthBarColor")
CreateToggle(VisualsPanel, "Skeleton ESP", "SkeletonESP", 4, function() UpdateAllSkeleton() end, "SkeletonESPColor")
CreateToggle(VisualsPanel, "Chams", "Chams", 5, function() UpdateAllChams() end, "ChamsColor")
CreateToggle(VisualsPanel, "Tracers", "Tracers", 6, function() UpdateAllESP() end, "TracersColor")
CreateToggle(VisualsPanel, "Player Names", "NameESP", 7, function() UpdateAllESP() end, "NameESPColor")
CreateToggle(VisualsPanel, "Distance Display", "DistanceESP", 8, function() UpdateAllESP() end, "DistanceESPColor")

local MiscPanel = CreatePanel("Misc")
CreateSectionHeader(MiscPanel, "Movement", 1)
CreateToggle(MiscPanel, "Speed Hack", "SpeedEnabled", 2, function() ApplySpeed() end)
CreateSlider(MiscPanel, "Speed Amount", 16, 200, "SpeedAmount", 3, function() ApplySpeed() end)
CreateToggle(MiscPanel, "Fly", "FlyEnabled", 4, function() ApplyFly() end)
CreateSlider(MiscPanel, "Fly Speed", 10, 200, "FlySpeed", 5, function() end)
CreateToggle(MiscPanel, "Noclip", "NoclipEnabled", 6, function() end)
CreateSectionHeader(MiscPanel, "Jumping", 7)
CreateToggle(MiscPanel, "Infinite Jump", "InfJump", 8, function() end)
CreateToggle(MiscPanel, "Jump Power", "JumpPower", 9, function()
	local c = LocalPlayer.Character; if c then local h = c:FindFirstChildOfClass("Humanoid")
		if h then h.JumpPower = State.JumpPower and State.JumpPowerAmount or 50; h.UseJumpPower = true end end
end)
CreateSlider(MiscPanel, "Jump Power Amount", 50, 500, "JumpPowerAmount", 10, function(v)
	if State.JumpPower then local c = LocalPlayer.Character; if c then local h = c:FindFirstChildOfClass("Humanoid")
		if h then h.JumpPower = v; h.UseJumpPower = true end end end
end)

-- ============================================================
-- CONFIG PANEL
-- ============================================================
local ConfigPanel = CreatePanel("Config")
CreateSectionHeader(ConfigPanel, "Save Configuration", 1)

local cnf = Instance.new("Frame"); cnf.Size = UDim2.new(1,0,0,34); cnf.BackgroundColor3 = Colors.ButtonDefault; cnf.BorderSizePixel = 0
cnf.LayoutOrder = 2; cnf.ZIndex = 4; cnf.Parent = ConfigPanel; Instance.new("UICorner", cnf).CornerRadius = UDim.new(0,6)

local cni = Instance.new("TextBox"); cni.Size = UDim2.new(1,-16,1,-6); cni.Position = UDim2.new(0,8,0,3); cni.BackgroundTransparency = 1; cni.Text = ""
cni.PlaceholderText = "Enter config name..."; cni.PlaceholderColor3 = Colors.TextDim; cni.TextColor3 = Colors.Text; cni.TextSize = 12
cni.Font = Enum.Font.GothamSemibold; cni.TextXAlignment = Enum.TextXAlignment.Left; cni.ClearTextOnFocus = false; cni.ZIndex = 5; cni.Parent = cnf

local sb2 = Instance.new("TextButton"); sb2.Size = UDim2.new(1,0,0,34); sb2.BackgroundColor3 = Colors.Accent; sb2.BorderSizePixel = 0
sb2.Text = "💾 Save Config"; sb2.TextColor3 = Color3.fromRGB(255,255,255); sb2.TextSize = 12; sb2.Font = Enum.Font.GothamBold
sb2.LayoutOrder = 3; sb2.ZIndex = 4; sb2.AutoButtonColor = false; sb2.Parent = ConfigPanel; Instance.new("UICorner", sb2).CornerRadius = UDim.new(0,6)
sb2.MouseEnter:Connect(function() TweenService:Create(sb2, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(110,90,255)}):Play() end)
sb2.MouseLeave:Connect(function() TweenService:Create(sb2, TweenInfo.new(0.12), {BackgroundColor3 = Colors.Accent}):Play() end)

CreateSectionHeader(ConfigPanel, "Load Configuration", 4)

local clf = Instance.new("Frame"); clf.Size = UDim2.new(1,0,0,10); clf.BackgroundTransparency = 1; clf.LayoutOrder = 5; clf.ZIndex = 4
clf.AutomaticSize = Enum.AutomaticSize.Y; clf.Parent = ConfigPanel
local cll2 = Instance.new("UIListLayout", clf); cll2.Padding = UDim.new(0,4); cll2.SortOrder = Enum.SortOrder.LayoutOrder

local csl = Instance.new("TextLabel"); csl.Size = UDim2.new(1,0,0,22); csl.BackgroundTransparency = 1; csl.Text = ""
csl.TextColor3 = Colors.Accent; csl.TextSize = 11; csl.Font = Enum.Font.GothamSemibold; csl.LayoutOrder = 100; csl.ZIndex = 4; csl.Parent = ConfigPanel

local function SS(msg, col) csl.Text = msg; csl.TextColor3 = col or Colors.Accent; task.delay(3, function() if csl.Text == msg then csl.Text = "" end end) end

local function SrS() local d = {}; for k,v in pairs(State) do
	if typeof(v)=="Color3" then d[k]={T="C",R=v.R,G=v.G,B=v.B} elseif typeof(v)=="boolean" then d[k]={T="B",V=v} elseif typeof(v)=="number" then d[k]={T="N",V=v} end end; return d end

local function DsS(data) for k,info in pairs(data) do if State[k]~=nil then
	if info.T=="C" then State[k]=Color3.new(info.R,info.G,info.B) elseif info.T=="B" then State[k]=info.V elseif info.T=="N" then State[k]=info.V end end end end

local function ASTUI()
	for sk,ref in pairs(ToggleReferences) do ref.setVisual(State[sk]); if ref.callback then ref.callback(State[sk]) end end
	for sk,ref in pairs(SliderReferences) do local v=math.clamp(State[sk],ref.min,ref.max); State[sk]=v; ref.setVisual(v); if ref.callback then ref.callback(v) end end
	for sk,pv in pairs(ColorPreviewReferences) do if pv and State[sk] then pv.BackgroundColor3=State[sk] end end
	for _,h in pairs(ChamObjects) do pcall(function() if h and h.Parent then h.FillColor=State.ChamsColor end end) end
	if FOVCircle then FOVCircle.Color=State.FOVCircleColor; FOVCircle.Radius=State.FOVRadius; FOVCircle.Visible=State.FOVCircleEnabled end
	SendInfoNotification("Config loaded successfully")
end

local function RCL()
	for _,child in ipairs(clf:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
	local configs = {}; pcall(function() if isfolder(ConfigFolder) then configs = listfiles(ConfigFolder) end end)
	if #configs == 0 then
		local nl2 = Instance.new("TextLabel"); nl2.Size = UDim2.new(1,0,0,28); nl2.BackgroundTransparency = 1; nl2.Text = "No saved configs"
		nl2.TextColor3 = Colors.TextDim; nl2.TextSize = 11; nl2.Font = Enum.Font.GothamSemibold; nl2.ZIndex = 5; nl2.Parent = clf; return
	end
	for i,fp in ipairs(configs) do
		local fn = fp:match("([^/\\]+)$") or fp; local cn2 = fn:gsub("%.json$","")
		local en = Instance.new("Frame"); en.Size = UDim2.new(1,0,0,32); en.BackgroundColor3 = Colors.ButtonDefault; en.BorderSizePixel = 0
		en.LayoutOrder = i; en.ZIndex = 4; en.Parent = clf; Instance.new("UICorner", en).CornerRadius = UDim.new(0,6)

		local nl3 = Instance.new("TextLabel"); nl3.Size = UDim2.new(1,-120,1,0); nl3.Position = UDim2.new(0,10,0,0); nl3.BackgroundTransparency = 1
		nl3.Text = "📄 "..cn2; nl3.TextColor3 = Colors.Text; nl3.TextSize = 11; nl3.Font = Enum.Font.GothamSemibold; nl3.TextXAlignment = Enum.TextXAlignment.Left; nl3.ZIndex = 5; nl3.Parent = en

		local lb3 = Instance.new("TextButton"); lb3.Size = UDim2.new(0,50,0,24); lb3.Position = UDim2.new(1,-112,0.5,-12); lb3.BackgroundColor3 = Colors.Accent
		lb3.BorderSizePixel = 0; lb3.Text = "Load"; lb3.TextColor3 = Color3.fromRGB(255,255,255); lb3.TextSize = 10; lb3.Font = Enum.Font.GothamBold; lb3.ZIndex = 6; lb3.AutoButtonColor = false; lb3.Parent = en
		Instance.new("UICorner", lb3).CornerRadius = UDim.new(0,4)
		lb3.MouseEnter:Connect(function() TweenService:Create(lb3, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(110,90,255)}):Play() end)
		lb3.MouseLeave:Connect(function() TweenService:Create(lb3, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Accent}):Play() end)
		lb3.MouseButton1Click:Connect(function() local ok=pcall(function() DsS(HttpService:JSONDecode(readfile(fp))); ASTUI() end)
			SS(ok and ("✓ Loaded: "..cn2) or "✕ Failed", ok and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,80,80)) end)

		local db = Instance.new("TextButton"); db.Size = UDim2.new(0,50,0,24); db.Position = UDim2.new(1,-56,0.5,-12); db.BackgroundColor3 = Color3.fromRGB(180,40,40)
		db.BorderSizePixel = 0; db.Text = "Delete"; db.TextColor3 = Color3.fromRGB(255,255,255); db.TextSize = 10; db.Font = Enum.Font.GothamBold; db.ZIndex = 6; db.AutoButtonColor = false; db.Parent = en
		Instance.new("UICorner", db).CornerRadius = UDim.new(0,4)
		db.MouseEnter:Connect(function() TweenService:Create(db, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220,50,50)}):Play() end)
		db.MouseLeave:Connect(function() TweenService:Create(db, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180,40,40)}):Play() end)
		db.MouseButton1Click:Connect(function() pcall(function() delfile(fp) end); SS("🗑 Deleted: "..cn2, Color3.fromRGB(255,150,50)); RCL() end)

		en.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseMovement then TweenService:Create(en, TweenInfo.new(0.1), {BackgroundColor3=Colors.ButtonHover}):Play() end end)
		en.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseMovement then TweenService:Create(en, TweenInfo.new(0.1), {BackgroundColor3=Colors.ButtonDefault}):Play() end end)
	end
end

sb2.MouseButton1Click:Connect(function()
	local name = cni.Text; if name=="" or name:match("^%s*$") then SS("✕ Enter a name!", Color3.fromRGB(255,80,80)); return end
	name = name:gsub("[^%w%s_%-]",""):gsub("^%s+",""):gsub("%s+$",""); if name=="" then SS("✕ Invalid!", Color3.fromRGB(255,80,80)); return end
	local ok=pcall(function() writefile(ConfigFolder.."/"..name..".json", HttpService:JSONEncode(SrS())) end)
	SS(ok and ("✓ Saved: "..name) or "✕ Failed", ok and Color3.fromRGB(100,255,100) or Color3.fromRGB(255,80,80))
	if ok then cni.Text=""; RCL(); SendInfoNotification("Config saved: "..name) end
end)

CreateSectionHeader(ConfigPanel, "Actions", 6)
local rb2 = Instance.new("TextButton"); rb2.Size = UDim2.new(1,0,0,32); rb2.BackgroundColor3 = Colors.ButtonDefault; rb2.BorderSizePixel = 0
rb2.Text = "🔄 Refresh"; rb2.TextColor3 = Colors.Text; rb2.TextSize = 12; rb2.Font = Enum.Font.GothamSemibold; rb2.LayoutOrder = 7; rb2.ZIndex = 4; rb2.AutoButtonColor = false; rb2.Parent = ConfigPanel
Instance.new("UICorner", rb2).CornerRadius = UDim.new(0,6)
rb2.MouseEnter:Connect(function() TweenService:Create(rb2, TweenInfo.new(0.12), {BackgroundColor3 = Colors.ButtonHover}):Play() end)
rb2.MouseLeave:Connect(function() TweenService:Create(rb2, TweenInfo.new(0.12), {BackgroundColor3 = Colors.ButtonDefault}):Play() end)
rb2.MouseButton1Click:Connect(function() RCL(); SS("🔄 Refreshed", Colors.Accent) end)

task.defer(RCL)

-- Panels + Tab Switching
local Panels = {Aimbot=AimbotPanel, Visuals=VisualsPanel, Misc=MiscPanel, Config=ConfigPanel}

local function SwitchTab(tn)
	if ActiveTab==tn then return end
	if Panels[ActiveTab] then Panels[ActiveTab].Visible=false end
	if TabButtons[ActiveTab] then TweenService:Create(TabButtons[ActiveTab], TweenInfo.new(0.15), {BackgroundColor3=Colors.ButtonDefault, TextColor3=Colors.TextDim}):Play() end
	ActiveTab=tn
	if TabButtons[tn] then TweenService:Create(TabButtons[tn], TweenInfo.new(0.15), {BackgroundColor3=Colors.ButtonActive, TextColor3=Color3.fromRGB(255,255,255)}):Play() end
	if Panels[tn] then Panels[tn].CanvasPosition=Vector2.zero; Panels[tn].Visible=true end
	if tn=="Config" then RCL() end
end

for name,btn in pairs(TabButtons) do btn.MouseButton1Click:Connect(function() SwitchTab(name) end) end
AimbotPanel.Visible=true; TabButtons["Aimbot"].BackgroundColor3=Colors.ButtonActive; TabButtons["Aimbot"].TextColor3=Color3.fromRGB(255,255,255)

-- Toggle UI
AddConnection("ToggleUI", UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode==Enum.KeyCode.RightShift then
		UIVisible = not UIVisible
		if UIVisible then MainFrame.Visible=true; MainFrame.Size=UDim2.new(0,540,0,0)
			TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size=UDim2.new(0,540,0,440)}):Play()
		else if CPOverlay.Visible then CCP() end
			local t=TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size=UDim2.new(0,540,0,0)})
			t:Play(); t.Completed:Connect(function() if not UIVisible then MainFrame.Visible=false end end)
		end
	end
end))

-- ============================================================
-- FOV CIRCLE
-- ============================================================
pcall(function() if Drawing then
	FOVCircle = Drawing.new("Circle"); FOVCircle.Radius=State.FOVRadius; FOVCircle.Color=State.FOVCircleColor
	FOVCircle.Thickness=1.5; FOVCircle.Filled=false; FOVCircle.Transparency=0.7; FOVCircle.Visible=false; FOVCircle.NumSides=64
end end)

AddConnection("FOV", RunService.RenderStepped:Connect(function()
	if FOVCircle then local m=UserInputService:GetMouseLocation(); FOVCircle.Position=Vector2.new(m.X,m.Y)
		FOVCircle.Color=State.FOVCircleColor; FOVCircle.Radius=State.FOVRadius; FOVCircle.Visible=State.FOVCircleEnabled end
end))

-- Visible check
local RP = RaycastParams.new(); RP.FilterType = Enum.RaycastFilterType.Blacklist
local function IPV(tc2) local lc=LocalPlayer.Character; if not lc or not tc2 then return false end
	local lh,th=lc:FindFirstChild("Head"),tc2:FindFirstChild("Head"); if not lh or not th then return false end
	RP.FilterDescendantsInstances={lc,tc2}; return workspace:Raycast(lh.Position,(th.Position-lh.Position),RP)==nil end

-- Aimbot
local function GCP()
	local cl,cd=nil,State.FOVRadius; local mp=UserInputService:GetMouseLocation()
	for _,p in ipairs(Players:GetPlayers()) do if p==LocalPlayer then continue end
		local c=p.Character; if not c or not c:FindFirstChild("HumanoidRootPart") then continue end
		local h=c:FindFirstChild("Humanoid"); if not h or h.Health<=0 then continue end
		if State.TeamCheck and p.Team and LocalPlayer.Team and p.Team==LocalPlayer.Team then continue end
		if State.VisibleCheck and not IPV(c) then continue end
		local sp,on=Camera:WorldToViewportPoint(c.HumanoidRootPart.Position)
		if on then local d=(Vector2.new(sp.X,sp.Y)-mp).Magnitude; if d<cd then cd=d; cl=p end end
	end; return cl
end

AddConnection("Aimbot", RunService.RenderStepped:Connect(function()
	if not State.AimbotEnabled or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
	local t=GCP(); if not t or not t.Character then return end; local head=t.Character:FindFirstChild("Head"); if not head then return end
	local tp=Camera:WorldToViewportPoint(head.Position); local mp=UserInputService:GetMouseLocation(); local sm=math.max(State.AimSmoothness,1)
	pcall(function() mousemoverel((tp.X-mp.X)/sm,(tp.Y-mp.Y)/sm) end)
end))

-- Trigger Bot
local tCD=false
AddConnection("Trigger", RunService.RenderStepped:Connect(function()
	if not State.TriggerBot or tCD then return end
	local mp=UserInputService:GetMouseLocation(); local ray=Camera:ViewportPointToRay(mp.X,mp.Y)
	local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Blacklist; params.FilterDescendantsInstances={LocalPlayer.Character}
	local result=workspace:Raycast(ray.Origin,ray.Direction*1000,params)
	if result and result.Instance then local hm=result.Instance:FindFirstAncestorOfClass("Model")
		if hm then local hp=Players:GetPlayerFromCharacter(hm)
			if hp and hp~=LocalPlayer then
				if State.TeamCheck and hp.Team and LocalPlayer.Team and hp.Team==LocalPlayer.Team then return end
				if State.VisibleCheck and not IPV(hm) then return end
				local hum=hm:FindFirstChild("Humanoid"); if hum and hum.Health>0 then tCD=true
					task.delay(State.TriggerDelay/1000, function() pcall(function() mouse1click() end); task.delay(0.05, function() tCD=false end) end)
				end
			end
		end
	end
end))

-- ============================================================
-- ESP
-- ============================================================
function CreateESPForPlayer(player)
	if not Drawing then return end; CleanupPlayerESP(player); local objects={}
	if State.BoxESP then local b=Drawing.new("Square"); b.Color=State.BoxESPColor; b.Thickness=1.5; b.Filled=false; b.Visible=false; objects.Box=b end
	if State.Tracers then local t=Drawing.new("Line"); t.Color=State.TracersColor; t.Thickness=1; t.Visible=false; objects.Tracer=t end
	if State.NameESP then local n=Drawing.new("Text"); n.Color=State.NameESPColor; n.Size=14; n.Center=true; n.Outline=true; n.OutlineColor=Color3.fromRGB(0,0,0); n.Font=2; n.Visible=false; n.Text=player.Name; objects.Name=n end
	if State.DistanceESP then local d=Drawing.new("Text"); d.Color=State.DistanceESPColor; d.Size=12; d.Center=true; d.Outline=true; d.OutlineColor=Color3.fromRGB(0,0,0); d.Font=2; d.Visible=false; objects.Distance=d end
	ESPObjects[player]=objects
end

function UpdateAllESP() CleanupAllESP()
	if not (State.BoxESP or State.Tracers or State.NameESP or State.DistanceESP) then return end
	for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then CreateESPForPlayer(p) end end
end

AddConnection("ESP", RunService.RenderStepped:Connect(function()
	local vs=Camera.ViewportSize; local any=State.BoxESP or State.Tracers or State.NameESP or State.DistanceESP
	for player,objects in pairs(ESPObjects) do
		if not player or not player.Parent then for _,obj in pairs(objects) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end; ESPObjects[player]=nil; continue end
		if not any then for _,obj in pairs(objects) do pcall(function() if obj then obj.Visible=false end end) end; continue end
		local char=player.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
			for _,obj in pairs(objects) do pcall(function() if obj then obj.Visible=false end end) end; continue end
		if char.Humanoid.Health<=0 then for _,obj in pairs(objects) do pcall(function() if obj then obj.Visible=false end end) end; continue end
		local hrp=char.HumanoidRootPart; local rp,on=Camera:WorldToViewportPoint(hrp.Position)
		local tp2=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3,0)); local bp=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,4.5,0))
		if not on then for _,obj in pairs(objects) do pcall(function() if obj then obj.Visible=false end end) end; continue end
		local bH=math.abs(tp2.Y-bp.Y); local bW=bH*0.6
		if objects.Box then objects.Box.Size=Vector2.new(bW,bH); objects.Box.Position=Vector2.new(rp.X-bW/2,tp2.Y); objects.Box.Color=State.BoxESPColor; objects.Box.Visible=State.BoxESP end
		if objects.Tracer then objects.Tracer.From=Vector2.new(vs.X/2,vs.Y); objects.Tracer.To=Vector2.new(rp.X,bp.Y); objects.Tracer.Color=State.TracersColor; objects.Tracer.Visible=State.Tracers end
		if objects.Name then objects.Name.Position=Vector2.new(rp.X,tp2.Y-18); objects.Name.Text=player.Name; objects.Name.Color=State.NameESPColor; objects.Name.Visible=State.NameESP end
		if objects.Distance then local lh=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if lh then objects.Distance.Text=math.floor((lh.Position-hrp.Position).Magnitude).."m"; objects.Distance.Position=Vector2.new(rp.X,bp.Y+4); objects.Distance.Color=State.DistanceESPColor; objects.Distance.Visible=State.DistanceESP
			else objects.Distance.Visible=false end end
	end
end))

-- ============================================================
-- HEALTH BAR ESP
-- ============================================================
function CreateHealthBarForPlayer(player)
	if not Drawing then return end; CleanupPlayerHealthBar(player)
	local objects = {}
	local bgBar = Drawing.new("Line"); bgBar.Color = Color3.fromRGB(30,30,30); bgBar.Thickness = 4; bgBar.Visible = false; objects.BgBar = bgBar
	local fgBar = Drawing.new("Line"); fgBar.Color = State.HealthBarColor; fgBar.Thickness = 2; fgBar.Visible = false; objects.FgBar = fgBar
	local outline1 = Drawing.new("Line"); outline1.Color = Color3.fromRGB(0,0,0); outline1.Thickness = 6; outline1.Visible = false; objects.Outline = outline1
	HealthBarObjects[player] = objects
end

function UpdateAllHealthBars() CleanupAllHealthBars()
	if not State.HealthBar then return end
	for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then CreateHealthBarForPlayer(p) end end
end

AddConnection("HealthBar", RunService.RenderStepped:Connect(function()
	for player,objects in pairs(HealthBarObjects) do
		if not player or not player.Parent then
			for _,obj in pairs(objects) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end
			HealthBarObjects[player]=nil; continue
		end
		if not State.HealthBar then
			for _,obj in pairs(objects) do pcall(function() if obj then obj.Visible=false end end) end; continue
		end
		local char=player.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
			for _,obj in pairs(objects) do pcall(function() if obj then obj.Visible=false end end) end; continue
		end
		local hum = char.Humanoid
		if hum.Health<=0 then for _,obj in pairs(objects) do pcall(function() if obj then obj.Visible=false end end) end; continue end

		local hrp=char.HumanoidRootPart
		local rp,on=Camera:WorldToViewportPoint(hrp.Position)
		local tp2=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3,0))
		local bp=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,4.5,0))

		if not on then for _,obj in pairs(objects) do pcall(function() if obj then obj.Visible=false end end) end; continue end

		local bH=math.abs(tp2.Y-bp.Y); local bW=bH*0.6
		local barX = rp.X - bW/2 - 6
		local barTop = tp2.Y
		local barBot = bp.Y
		local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
		local filledBot = barBot - (barBot - barTop) * healthPct

		-- Color based on health: green -> yellow -> red
		local hColor
		if healthPct > 0.5 then
			hColor = Color3.fromRGB(math.floor((1-healthPct)*2*255), 255, 0)
		else
			hColor = Color3.fromRGB(255, math.floor(healthPct*2*255), 0)
		end

		if objects.Outline then
			objects.Outline.From = Vector2.new(barX, barTop)
			objects.Outline.To = Vector2.new(barX, barBot)
			objects.Outline.Visible = true
		end
		if objects.BgBar then
			objects.BgBar.From = Vector2.new(barX, barTop)
			objects.BgBar.To = Vector2.new(barX, barBot)
			objects.BgBar.Visible = true
		end
		if objects.FgBar then
			objects.FgBar.From = Vector2.new(barX, filledBot)
			objects.FgBar.To = Vector2.new(barX, barBot)
			objects.FgBar.Color = hColor
			objects.FgBar.Visible = true
		end
	end
end))

-- ============================================================
-- SKELETON ESP
-- ============================================================
local SkBones = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}
local SkBonesR6 = {{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}

function CreateSkeletonForPlayer(player)
	if not Drawing then return end; CleanupPlayerSkeleton(player); local lines={}
	for i=1,#SkBones do local l=Drawing.new("Line"); l.Color=State.SkeletonESPColor; l.Thickness=1.5; l.Visible=false; lines[i]=l end
	SkeletonObjects[player]=lines
end

function UpdateAllSkeleton() CleanupAllSkeleton()
	if not State.SkeletonESP then return end
	for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then CreateSkeletonForPlayer(p) end end
end

AddConnection("Skeleton", RunService.RenderStepped:Connect(function()
	if not State.SkeletonESP then for _,lines in pairs(SkeletonObjects) do for _,l in pairs(lines) do pcall(function() l.Visible=false end) end end; return end
	for player,lines in pairs(SkeletonObjects) do
		if not player or not player.Parent then for _,l in pairs(lines) do pcall(function() if l and l.Remove then l:Remove() end end) end; SkeletonObjects[player]=nil; continue end
		local char=player.Character
		if not char or not char:FindFirstChild("Humanoid") then for _,l in pairs(lines) do pcall(function() l.Visible=false end) end; continue end
		if char.Humanoid.Health<=0 then for _,l in pairs(lines) do pcall(function() l.Visible=false end) end; continue end
		local isR15=char:FindFirstChild("UpperTorso")~=nil; local bones=isR15 and SkBones or SkBonesR6
		for i,l in ipairs(lines) do
			if i>#bones then pcall(function() l.Visible=false end); continue end
			local pA=char:FindFirstChild(bones[i][1]); local pB=char:FindFirstChild(bones[i][2])
			if pA and pB then local a,oA=Camera:WorldToViewportPoint(pA.Position); local b2,oB=Camera:WorldToViewportPoint(pB.Position)
				if oA and oB then l.From=Vector2.new(a.X,a.Y); l.To=Vector2.new(b2.X,b2.Y); l.Color=State.SkeletonESPColor; l.Visible=true
				else l.Visible=false end
			else l.Visible=false end
		end
	end
end))

-- Chams
function CreateChamsForPlayer(player) if not State.Chams or not player.Character then return end; CleanupPlayerChams(player)
	local h=Instance.new("Highlight"); h.FillColor=State.ChamsColor; h.FillTransparency=0.5; h.OutlineColor=Color3.fromRGB(255,255,255); h.OutlineTransparency=0.3
	h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Adornee=player.Character; h.Parent=player.Character; ChamObjects[player]=h end

function UpdateAllChams() CleanupAllChams(); if not State.Chams then return end
	for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then CreateChamsForPlayer(p) end end end

-- Speed
function ApplySpeed() local c=LocalPlayer.Character; if not c then return end; local h=c:FindFirstChildOfClass("Humanoid")
	if h then h.WalkSpeed=State.SpeedEnabled and State.SpeedAmount or 16 end end

-- Fly
function ApplyFly() local c=LocalPlayer.Character; if not c then return end; local hrp=c:FindFirstChild("HumanoidRootPart"); local hum=c:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end
	if State.FlyEnabled then
		if FlyBodyVelocity and FlyBodyVelocity.Parent then FlyBodyVelocity:Destroy() end; if FlyBodyGyro and FlyBodyGyro.Parent then FlyBodyGyro:Destroy() end
		FlyBodyVelocity=Instance.new("BodyVelocity"); FlyBodyVelocity.MaxForce=Vector3.new(math.huge,math.huge,math.huge); FlyBodyVelocity.Velocity=Vector3.zero; FlyBodyVelocity.Parent=hrp
		FlyBodyGyro=Instance.new("BodyGyro"); FlyBodyGyro.MaxTorque=Vector3.new(math.huge,math.huge,math.huge); FlyBodyGyro.P=9e4; FlyBodyGyro.Parent=hrp; hum.PlatformStand=true
		AddConnection("FlyLoop", RunService.RenderStepped:Connect(function()
			if not State.FlyEnabled or not FlyBodyVelocity or not FlyBodyVelocity.Parent then return end
			local dir=Vector3.zero; local cf=Camera.CFrame
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=cf.LookVector end; if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=cf.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=cf.RightVector end; if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=cf.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.yAxis end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir-=Vector3.yAxis end
			if dir.Magnitude>0 then dir=dir.Unit end; FlyBodyVelocity.Velocity=dir*State.FlySpeed; FlyBodyGyro.CFrame=cf
		end))
	else
		if Connections["FlyLoop"] then Connections["FlyLoop"]:Disconnect(); Connections["FlyLoop"]=nil end
		if FlyBodyVelocity and FlyBodyVelocity.Parent then FlyBodyVelocity:Destroy() end; if FlyBodyGyro and FlyBodyGyro.Parent then FlyBodyGyro:Destroy() end
		FlyBodyVelocity,FlyBodyGyro=nil,nil; if hum then hum.PlatformStand=false end
	end
end

-- Noclip
AddConnection("Noclip", RunService.Stepped:Connect(function()
	if not State.NoclipEnabled then return end; local c=LocalPlayer.Character; if not c then return end
	for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
end))

-- Infinite Jump
AddConnection("InfJump", UserInputService.JumpRequest:Connect(function()
	if not State.InfJump then return end
	local c = LocalPlayer.Character; if not c then return end
	local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
	h:ChangeState(Enum.HumanoidStateType.Jumping)
end))

-- Player Tracking
local function SetupTracking(player)
	if player==LocalPlayer then return end
	if CharacterConnections[player] then for _,conn in pairs(CharacterConnections[player]) do pcall(function() conn:Disconnect() end) end end
	CharacterConnections[player]={}
	table.insert(CharacterConnections[player], player.CharacterAdded:Connect(function()
		task.wait(1); if not player or not player.Parent then return end
		if State.BoxESP or State.Tracers or State.NameESP or State.DistanceESP then CreateESPForPlayer(player) end
		if State.SkeletonESP then CreateSkeletonForPlayer(player) end
		if State.HealthBar then CreateHealthBarForPlayer(player) end
		if State.Chams then CreateChamsForPlayer(player) end
	end))
	if player.Character then
		if State.BoxESP or State.Tracers or State.NameESP or State.DistanceESP then CreateESPForPlayer(player) end
		if State.SkeletonESP then CreateSkeletonForPlayer(player) end
		if State.HealthBar then CreateHealthBarForPlayer(player) end
		if State.Chams then CreateChamsForPlayer(player) end
	end
end

AddConnection("PA", Players.PlayerAdded:Connect(function(p) SetupTracking(p) end))
AddConnection("PR", Players.PlayerRemoving:Connect(function(p)
	CleanupPlayerESP(p); CleanupPlayerSkeleton(p); CleanupPlayerHealthBar(p); CleanupPlayerChams(p)
	if CharacterConnections[p] then for _,conn in pairs(CharacterConnections[p]) do pcall(function() conn:Disconnect() end) end; CharacterConnections[p]=nil end
end))

for _,p in ipairs(Players:GetPlayers()) do SetupTracking(p) end

AddConnection("LR", LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)
	if State.SpeedEnabled then ApplySpeed() end
	if State.FlyEnabled then FlyBodyVelocity,FlyBodyGyro=nil,nil; ApplyFly() end
	if State.JumpPower then local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid")
		if h then h.JumpPower=State.JumpPowerAmount; h.UseJumpPower=true end end end
	if State.Chams then task.wait(0.5); UpdateAllChams() end
end))

-- Periodic Cleanup
AddConnection("Cleanup", RunService.Heartbeat:Connect(function()
	for player,objects in pairs(ESPObjects) do if not player or not player.Parent then
		for _,obj in pairs(objects) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end; ESPObjects[player]=nil end end
	for player,lines in pairs(SkeletonObjects) do if not player or not player.Parent then
		for _,l in pairs(lines) do pcall(function() if l and l.Remove then l:Remove() end end) end; SkeletonObjects[player]=nil end end
	for player,objects in pairs(HealthBarObjects) do if not player or not player.Parent then
		for _,obj in pairs(objects) do pcall(function() if obj and obj.Remove then obj:Remove() end end) end; HealthBarObjects[player]=nil end end
	for player,h in pairs(ChamObjects) do if not player or not player.Parent then
		pcall(function() if h and h.Parent then h:Destroy() end end); ChamObjects[player]=nil end end
end))

-- Cleanup on Destroy
ScreenGui.Destroying:Connect(function()
	CleanupAll(); CleanupAllESP(); CleanupAllSkeleton(); CleanupAllHealthBars(); CleanupAllChams()
	if FOVCircle then pcall(function() FOVCircle:Remove() end) end
	if FlyBodyVelocity and FlyBodyVelocity.Parent then FlyBodyVelocity:Destroy() end
	if FlyBodyGyro and FlyBodyGyro.Parent then FlyBodyGyro:Destroy() end
	local c=LocalPlayer.Character; if c then local h=c:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed=16; h.PlatformStand=false; h.JumpPower=50; h.UseJumpPower=true end
		for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
end)

SendInfoNotification("✓ Authenticated! UI loaded.")
print("[Modern UI] ✓ Loaded! Press Right Shift to toggle.")

end -- end of LoadMainUI
