local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

local ParentGui = (pcall(function() return gethui() end) and gethui()) or CoreGui

if ParentGui:FindFirstChild("foderHub") then
	ParentGui.foderHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "foderHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 420)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 204)
MainStroke.Transparency = 0.5
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local DragButton = Instance.new("TextButton")
DragButton.Size = UDim2.new(1, 0, 0, 50)
DragButton.BackgroundTransparency = 1
DragButton.Text = ""
DragButton.Parent = MainFrame

local dragging, dragInput, dragStart, startPos
DragButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		local delta = dragInput.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "foderHub"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 204)
TitleLabel.TextSize = 22
TitleLabel.Parent = Sidebar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 204)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(138, 43, 226))
}
TitleGradient.Parent = TitleLabel

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, -60)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.Parent = TabContainer

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -170, 1, -20)
ContentArea.Position = UDim2.new(0, 165, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Pages = {}
local TabButtons = {}
local CurrentTab = nil

local function CreateTab(name)
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.new(0, 140, 0, 36)
	TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
	TabButton.BackgroundTransparency = 0.5
	TabButton.BorderSizePixel = 0
	TabButton.Font = Enum.Font.GothamSemibold
	TabButton.Text = name
	TabButton.TextColor3 = Color3.fromRGB(180, 180, 200)
	TabButton.TextSize = 14
	TabButton.Parent = TabContainer

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 8)
	ButtonCorner.Parent = TabButton

	local Page = Instance.new("ScrollingFrame")
	Page.Name = name .. "Page"
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.CanvasSize = UDim2.new(0, 0, 0, 0)
	Page.ScrollBarThickness = 3
	Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 204)
	Page.Visible = false
	Page.Parent = ContentArea

	local PageLayout = Instance.new("UIListLayout")
	PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	PageLayout.Padding = UDim.new(0, 8)
	PageLayout.Parent = Page

	PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
	end)

	TabButton.MouseButton1Click:Connect(function()
		for _, p in pairs(Pages) do
			p.Visible = false
		end
		for _, b in pairs(TabButtons) do
			TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 42), TextColor3 = Color3.fromRGB(180, 180, 200)}):Play()
		end
		Page.Visible = true
		TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 204), TextColor3 = Color3.fromRGB(15, 15, 20)}):Play()
		CurrentTab = name
	end)

	table.insert(Pages, Page)
	table.insert(TabButtons, TabButton)

	if #Pages == 1 then
		Page.Visible = true
		TabButton.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
		TabButton.TextColor3 = Color3.fromRGB(15, 15, 20)
		CurrentTab = name
	end

	return Page
end

local function CreateToggle(parent, title, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(0, 460, 0, 40)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	ToggleFrame.BackgroundTransparency = 0.4
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = ToggleFrame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.Position = UDim2.new(0, 15, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.GothamMedium
	Label.Text = title
	Label.TextColor3 = Color3.fromRGB(220, 220, 240)
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ToggleFrame

	local SwitchBg = Instance.new("Frame")
	SwitchBg.Size = UDim2.new(0, 44, 0, 22)
	SwitchBg.Position = UDim2.new(1, -54, 0.5, -11)
	SwitchBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	SwitchBg.BorderSizePixel = 0
	SwitchBg.Parent = ToggleFrame

	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(1, 0)
	SwitchCorner.Parent = SwitchBg

	local SwitchKnob = Instance.new("Frame")
	SwitchKnob.Size = UDim2.new(0, 16, 0, 16)
	SwitchKnob.Position = UDim2.new(0, 3, 0.5, -8)
	SwitchKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
	SwitchKnob.BorderSizePixel = 0
	SwitchKnob.Parent = SwitchBg

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = SwitchKnob

	local state = false
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	Button.Parent = ToggleFrame

	Button.MouseButton1Click:Connect(function()
		state = not state
		local targetColor = state and Color3.fromRGB(0, 255, 204) or Color3.fromRGB(45, 45, 60)
		local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		local knobColor = state and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(200, 200, 220)

		TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(SwitchKnob, TweenInfo.new(0.2), {Position = targetPos, BackgroundColor3 = knobColor}):Play()

		pcall(function() callback(state) end)
	end)
end

local function CreateSlider(parent, title, min, max, default, callback)
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Size = UDim2.new(0, 460, 0, 55)
	SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	SliderFrame.BackgroundTransparency = 0.4
	SliderFrame.BorderSizePixel = 0
	SliderFrame.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = SliderFrame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -30, 0, 25)
	Label.Position = UDim2.new(0, 15, 0, 5)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.GothamMedium
	Label.Text = title
	Label.TextColor3 = Color3.fromRGB(220, 220, 240)
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = SliderFrame

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(0, 50, 0, 25)
	ValueLabel.Position = UDim2.new(1, -65, 0, 5)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.Text = tostring(default)
	ValueLabel.TextColor3 = Color3.fromRGB(0, 255, 204)
	ValueLabel.TextSize = 13
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = SliderFrame

	local Track = Instance.new("Frame")
	Track.Size = UDim2.new(1, -30, 0, 6)
	Track.Position = UDim2.new(0, 15, 0, 38)
	Track.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	Track.BorderSizePixel = 0
	Track.Parent = SliderFrame

	local TrackCorner = Instance.new("UICorner")
	TrackCorner.CornerRadius = UDim.new(1, 0)
	TrackCorner.Parent = Track

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
	Fill.BorderSizePixel = 0
	Fill.Parent = Track

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = Fill

	local Knob = Instance.new("Frame")
	Knob.Size = UDim2.new(0, 12, 0, 12)
	Knob.Position = UDim2.new(1, -6, 0.5, -6)
	Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Knob.BorderSizePixel = 0
	Knob.Parent = Fill

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	local draggingSlider = false
	local function UpdateInput(input)
		local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
		local val = min + (max - min) * pos
		if max - min > 10 then
			val = math.floor(val)
		else
			val = math.floor(val * 10 + 0.5) / 10
		end
		Fill.Size = UDim2.new(pos, 0, 1, 0)
		ValueLabel.Text = tostring(val)
		pcall(function() callback(val) end)
	end

	Track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			UpdateInput(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			UpdateInput(input)
		end
	end)
end

local function CreateDropdown(parent, title, options, callback)
	local DropdownFrame = Instance.new("Frame")
	DropdownFrame.Size = UDim2.new(0, 460, 0, 40)
	DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	DropdownFrame.BackgroundTransparency = 0.4
	DropdownFrame.BorderSizePixel = 0
	DropdownFrame.ClipsDescendants = true
	DropdownFrame.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = DropdownFrame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0, 200, 0, 40)
	Label.Position = UDim2.new(0, 15, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.GothamMedium
	Label.Text = title
	Label.TextColor3 = Color3.fromRGB(220, 220, 240)
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = DropdownFrame

	local SelectedLabel = Instance.new("TextLabel")
	SelectedLabel.Size = UDim2.new(0, 180, 0, 40)
	SelectedLabel.Position = UDim2.new(1, -210, 0, 0)
	SelectedLabel.BackgroundTransparency = 1
	SelectedLabel.Font = Enum.Font.GothamSemibold
	SelectedLabel.Text = options[1] or ""
	SelectedLabel.TextColor3 = Color3.fromRGB(0, 255, 204)
	SelectedLabel.TextSize = 13
	SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
	SelectedLabel.Parent = DropdownFrame

	local OpenBtn = Instance.new("TextButton")
	OpenBtn.Size = UDim2.new(1, 0, 0, 40)
	OpenBtn.BackgroundTransparency = 1
	OpenBtn.Text = ""
	OpenBtn.Parent = DropdownFrame

	local ListFrame = Instance.new("Frame")
	ListFrame.Size = UDim2.new(1, 0, 0, #options * 32)
	ListFrame.Position = UDim2.new(0, 0, 0, 40)
	ListFrame.BackgroundTransparency = 1
	ListFrame.Parent = DropdownFrame

	local ListLayout = Instance.new("UIListLayout")
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Parent = ListFrame

	local isOpen = false
	OpenBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		local targetHeight = isOpen and (40 + #options * 32) or 40
		TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 460, 0, targetHeight)}):Play()
	end)

	for _, opt in ipairs(options) do
		local OptBtn = Instance.new("TextButton")
		OptBtn.Size = UDim2.new(1, 0, 0, 32)
		OptBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		OptBtn.BackgroundTransparency = 0.5
		OptBtn.BorderSizePixel = 0
		OptBtn.Font = Enum.Font.Gotham
		OptBtn.Text = opt
		OptBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
		OptBtn.TextSize = 13
		OptBtn.Parent = ListFrame

		OptBtn.MouseButton1Click:Connect(function()
			SelectedLabel.Text = opt
			isOpen = false
			TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 460, 0, 40)}):Play()
			pcall(function() callback(opt) end)
		end)
	end
end

local function CreateButton(parent, title, callback)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(0, 460, 0, 40)
	Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 204)
	Btn.BackgroundTransparency = 0.8
	Btn.BorderSizePixel = 0
	Btn.Font = Enum.Font.GothamSemibold
	Btn.Text = title
	Btn.TextColor3 = Color3.fromRGB(0, 255, 204)
	Btn.TextSize = 14
	Btn.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Btn

	Btn.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

local WorldTab = CreateTab("World")
local GraphicsTab = CreateTab("Graphics")
local AtmosphereTab = CreateTab("Atmosphere")
local VisualsTab = CreateTab("Visuals")
local AuraTab = CreateTab("Auras")
local SettingsTab = CreateTab("Settings")

-- ====== РАДУГА НА СЕБЯ (Highlight) ======
local rainbowHighlight = nil
local rainbowConnection = nil
local hue = 0

CreateToggle(VisualsTab, "Радуга на себя", function(state)
	if state then
		local char = LocalPlayer.Character
		if char then
			if char:FindFirstChild("RainbowHighlight") then
				char.RainbowHighlight:Destroy()
			end
			
			rainbowHighlight = Instance.new("Highlight")
			rainbowHighlight.Name = "RainbowHighlight"
			rainbowHighlight.FillColor = Color3.fromHSV(0, 1, 1)
			rainbowHighlight.OutlineColor = Color3.fromHSV(0, 1, 1)
			rainbowHighlight.FillTransparency = 0.5
			rainbowHighlight.OutlineTransparency = 0
			rainbowHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			rainbowHighlight.Parent = char
			
			rainbowConnection = RunService.Heartbeat:Connect(function()
				hue = hue + 0.01
				if hue > 1 then hue = 0 end
				if rainbowHighlight then
					rainbowHighlight.FillColor = Color3.fromHSV(hue, 1, 1)
					rainbowHighlight.OutlineColor = Color3.fromHSV(hue, 1, 1)
				end
			end)
		end
	else
		if rainbowConnection then
			rainbowConnection:Disconnect()
			rainbowConnection = nil
		end
		if rainbowHighlight then
			rainbowHighlight:Destroy()
			rainbowHighlight = nil
		end
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	if rainbowHighlight and rainbowHighlight.Parent ~= char then
		rainbowHighlight:Destroy()
		rainbowHighlight = Instance.new("Highlight")
		rainbowHighlight.Name = "RainbowHighlight"
		rainbowHighlight.FillColor = Color3.fromHSV(hue, 1, 1)
		rainbowHighlight.OutlineColor = Color3.fromHSV(hue, 1, 1)
		rainbowHighlight.FillTransparency = 0.5
		rainbowHighlight.OutlineTransparency = 0
		rainbowHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		rainbowHighlight.Parent = char
	end
end)

-- ====== КИТАЙСКАЯ ШЛЯПА ======
local HatVariables = {
	enabled = false,
	transparency = 0.3,
	rainbow = false,
	rainbowSpeed = 5,
	color = Color3.fromRGB(0, 255, 255),
	radius = 2.4,
	height = 1.6,
	reflectance = 0,
	parts = {},
	connection = nil,
}

local function Hat_Remove()
	if LocalPlayer.Character and HatVariables.parts[LocalPlayer.Character] then 
		HatVariables.parts[LocalPlayer.Character]:Destroy()
		HatVariables.parts[LocalPlayer.Character] = nil 
	end
end

local function Hat_Add(char)
	task.wait(0.1)
	local head = char:WaitForChild("Head", 5)
	if not head then return end
	Hat_Remove()

	local hat = Instance.new("Part")
	hat.Name = "ChineseHat"
	hat.Transparency = HatVariables.transparency
	hat.Color = HatVariables.color
	hat.Material = Enum.Material.Neon
	hat.CanCollide = false
	hat.Reflectance = HatVariables.reflectance

	local mesh = Instance.new("SpecialMesh")
	mesh.MeshId = "rbxassetid://1033714"
	mesh.Scale = Vector3.new(HatVariables.radius, HatVariables.height, HatVariables.radius)
	mesh.Parent = hat

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = head
	weld.Part1 = hat
	weld.Parent = hat

	hat.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
	hat.Parent = char
	HatVariables.parts[char] = hat
end

local function Hat_Update()
	for char, hat in pairs(HatVariables.parts) do
		if hat and hat.Parent and char == LocalPlayer.Character then
			hat.Transparency = HatVariables.transparency
			hat.Reflectance = HatVariables.reflectance
			
			if HatVariables.rainbow then
				hat.Color = Color3.fromHSV(tick() % HatVariables.rainbowSpeed / HatVariables.rainbowSpeed, 1, 1)
			else
				hat.Color = HatVariables.color
			end
			
			local mesh = hat:FindFirstChildOfClass("SpecialMesh")
			if mesh then
				mesh.Scale = Vector3.new(HatVariables.radius, HatVariables.height, HatVariables.radius)
			end
		end
	end
end

local function Hat_Toggle(value)
	HatVariables.enabled = value
	
	if value then
		if LocalPlayer.Character then
			Hat_Add(LocalPlayer.Character)
		end
		
		if HatVariables.connection then HatVariables.connection:Disconnect() end
		HatVariables.connection = RunService.Heartbeat:Connect(Hat_Update)
	else
		Hat_Remove()
		if HatVariables.connection then 
			HatVariables.connection:Disconnect()
			HatVariables.connection = nil 
		end
	end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	if HatVariables.enabled then
		Hat_Add(char)
	end
end)

CreateToggle(VisualsTab, "Китайская шляпа", function(state)
	Hat_Toggle(state)
end)

CreateToggle(VisualsTab, "Радужная шляпа", function(state)
	HatVariables.rainbow = state
end)

CreateSlider(VisualsTab, "Прозрачность шляпы", 0, 1, HatVariables.transparency, function(val)
	HatVariables.transparency = val
end)

CreateSlider(VisualsTab, "Радиус шляпы", 1, 5, HatVariables.radius, function(val)
	HatVariables.radius = val
end)

CreateSlider(VisualsTab, "Высота шляпы", 0.5, 3, HatVariables.height, function(val)
	HatVariables.height = val
end)

CreateSlider(VisualsTab, "Отражаемость шляпы", 0, 1, HatVariables.reflectance, function(val)
	HatVariables.reflectance = val
end)

CreateSlider(VisualsTab, "Скорость радуги", 1, 10, HatVariables.rainbowSpeed, function(val)
	HatVariables.rainbowSpeed = val
end)

-- ====== АУРЫ ======
local AuraModels = {
	'Godly',
	'Super Sayien',
	'North Star',
	'Blue Lord',
	'Pink Aura',
	'Angel Wing',
	'Sweet Heart',
	'Ethereal Aura',
}

local AuraModelIDs = {
	['Godly'] = 'rbxassetid://16699750981',
	['Super Sayien'] = 'rbxassetid://116109508364297',
	['North Star'] = 'rbxassetid://83945069652732',
	['Blue Lord'] = 'rbxassetid://10974316799',
	['Pink Aura'] = 'rbxassetid://115980859615239',
	['Angel Wing'] = 'rbxassetid://90022969696073',
	['Sweet Heart'] = 'rbxassetid://91724768175470',
	['Ethereal Aura'] = 'rbxassetid://97041568674250',
}

local activeClassicAuras = {}
local selectedAura = "Godly"
local auraRainbowEnabled = false
local auraRainbowConnection = nil
local auraHue = 0

local function ClassicAura_LoadModel(id)
	local success, result = pcall(function() 
		return game:GetObjects(id)[1] 
	end)
	if not success then 
		warn("Failed to load aura model:", id)
		return nil 
	end
	return result
end

local function ClassicAura_DisableOne(auraName)
	if activeClassicAuras[auraName] then
		for _, v in pairs(activeClassicAuras[auraName]) do 
			if v and v.Parent then 
				pcall(function() v:Destroy() end)
			end 
		end
		activeClassicAuras[auraName] = nil
	end
end

local function ClassicAura_EnableOne(char, auraName)
	if not char or not char.Parent then return end
	
	ClassicAura_DisableOne(auraName)
	
	local id = AuraModelIDs[auraName]
	if not id then 
		warn("No ID found for aura:", auraName)
		return 
	end
	
	local model = ClassicAura_LoadModel(id)
	if not model then 
		warn("Failed to load model for:", auraName)
		return 
	end
	
	local effects = {}
	for _, obj in pairs(model:GetDescendants()) do
		if not obj:IsA('BasePart') then
			pcall(function()
				local clone = obj:Clone()
				local parentName = obj.Parent and obj.Parent.Name
				local target = char:FindFirstChild(parentName)
				if not target then 
					target = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA('BasePart')
				end
				if target then
					clone.Parent = target
					table.insert(effects, clone)
				end
			end)
		end
	end
	
	pcall(function() model:Destroy() end)
	
	if #effects > 0 then
		activeClassicAuras[auraName] = effects
		print("✅ Enabled Classic Aura:", auraName, "- Effects:", #effects)
	else
		warn("⚠️ No effects created for:", auraName)
	end
end

local function ClassicAura_DisableAll()
	for auraName in pairs(activeClassicAuras) do
		ClassicAura_DisableOne(auraName)
	end
end

local function AuraRainbow_Start()
	if auraRainbowConnection then
		auraRainbowConnection:Disconnect()
		auraRainbowConnection = nil
	end
	
	auraRainbowConnection = RunService.Heartbeat:Connect(function()
		auraHue = auraHue + 0.01
		if auraHue > 1 then auraHue = 0 end
		
		for auraName, effects in pairs(activeClassicAuras) do
			for _, v in pairs(effects) do
				if v and v.Parent then
					pcall(function()
						if v:IsA('ParticleEmitter') then
							v.Color = ColorSequence.new(Color3.fromHSV(auraHue, 1, 1))
						elseif v:IsA('Light') then
							v.Color = Color3.fromHSV(auraHue, 1, 1)
						elseif v:IsA('Beam') then
							v.Color = ColorSequence.new(Color3.fromHSV(auraHue, 1, 1))
						elseif v:IsA('Trail') then
							v.Color = ColorSequence.new(Color3.fromHSV(auraHue, 1, 1))
						elseif v:IsA('BillboardGui') then
							for _, child in pairs(v:GetDescendants()) do
								if child:IsA('TextLabel') then
									child.TextColor3 = Color3.fromHSV(auraHue, 1, 1)
								elseif child:IsA('ImageLabel') then
									child.ImageColor3 = Color3.fromHSV(auraHue, 1, 1)
								end
							end
						end
					end)
				end
			end
		end
	end)
end

local function AuraRainbow_Stop()
	if auraRainbowConnection then
		auraRainbowConnection:Disconnect()
		auraRainbowConnection = nil
	end
end

CreateDropdown(AuraTab, "Выбор ауры", AuraModels, function(opt)
	selectedAura = opt
	if LocalPlayer.Character then
		ClassicAura_DisableAll()
		ClassicAura_EnableOne(LocalPlayer.Character, opt)
	end
end)

CreateToggle(AuraTab, "Включить ауру", function(state)
	if state then
		if LocalPlayer.Character then
			ClassicAura_EnableOne(LocalPlayer.Character, selectedAura)
		end
	else
		ClassicAura_DisableAll()
	end
end)

CreateToggle(AuraTab, "Радужная аура", function(state)
	auraRainbowEnabled = state
	if state then
		AuraRainbow_Start()
	else
		AuraRainbow_Stop()
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	if LocalPlayer.Character then
		for auraName in pairs(activeClassicAuras) do
			ClassicAura_EnableOne(char, auraName)
		end
	end
end)

-- ====== WORLD ======
CreateToggle(WorldTab, "Remove Fog", function(state)
	if state then
		Lighting.FogEnd = 999999
		Lighting.FogStart = 999998
	else
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
	end
end)

CreateSlider(WorldTab, "Brightness", 0, 10, Lighting.Brightness, function(val)
	Lighting.Brightness = val
end)

CreateSlider(WorldTab, "Clock Time", 0, 24, Lighting.ClockTime, function(val)
	Lighting.ClockTime = val
end)

CreateDropdown(WorldTab, "Change Sky", {"Classic", "Nebula", "Midnight", "Dawn"}, function(opt)
	for _, child in pairs(Lighting:GetChildren()) do
		if child:IsA("Sky") then child:Destroy() end
	end
	local sky = Instance.new("Sky")
	if opt == "Nebula" then
		sky.SkyboxBk = "rbxassetid://159454299"
		sky.SkyboxDn = "rbxassetid://159454296"
		sky.SkyboxFt = "rbxassetid://159454293"
		sky.SkyboxLf = "rbxassetid://159454298"
		sky.SkyboxRt = "rbxassetid://159454300"
		sky.SkyboxUp = "rbxassetid://159454295"
	elseif opt == "Midnight" then
		sky.SkyboxBk = "rbxassetid://12064107"
		sky.SkyboxDn = "rbxassetid://12064151"
		sky.SkyboxFt = "rbxassetid://12064121"
		sky.SkyboxLf = "rbxassetid://12064131"
		sky.SkyboxRt = "rbxassetid://12064141"
		sky.SkyboxUp = "rbxassetid://12064162"
	elseif opt == "Dawn" then
		sky.SkyboxBk = "rbxassetid://145217112"
		sky.SkyboxDn = "rbxassetid://145217114"
		sky.SkyboxFt = "rbxassetid://145217116"
		sky.SkyboxLf = "rbxassetid://145217119"
		sky.SkyboxRt = "rbxassetid://145217122"
		sky.SkyboxUp = "rbxassetid://145217125"
	end
	if opt ~= "Classic" then
		sky.Parent = Lighting
	end
end)

CreateSlider(WorldTab, "Contrast", -5, 5, Lighting.ExposureCompensation, function(val)
	Lighting.ExposureCompensation = val
end)

local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
CreateSlider(WorldTab, "Saturation", -1, 1, cc.Saturation, function(val)
	cc.Saturation = val
end)

-- ====== GRAPHICS ======
CreateDropdown(GraphicsTab, "Graphics Quality", {"Low", "Medium", "High", "Ultra"}, function(opt)
	if opt == "Low" then
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	elseif opt == "Medium" then
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
	elseif opt == "High" then
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level16
	elseif opt == "Ultra" then
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
	end
end)

CreateToggle(GraphicsTab, "Shadows", function(state)
	Lighting.GlobalShadows = state
end)

local bloom = nil
CreateToggle(GraphicsTab, "Bloom", function(state)
	if state then
		bloom = Instance.new("BloomEffect", Lighting)
		bloom.Intensity = 2
	else
		if bloom then bloom:Destroy() bloom = nil end
	end
end)

CreateSlider(GraphicsTab, "Bloom Intensity", 0, 10, 2, function(val)
	if bloom then bloom.Intensity = val end
end)

local blur = nil
CreateToggle(GraphicsTab, "Blur", function(state)
	if state then
		blur = Instance.new("BlurEffect", Lighting)
		blur.Size = 16
	else
		if blur then blur:Destroy() blur = nil end
	end
end)

CreateSlider(GraphicsTab, "Blur Size", 0, 56, 16, function(val)
	if blur then blur.Size = val end
end)

CreateToggle(GraphicsTab, "Depth of Field", function(state)
	if state then
		local dof = Instance.new("DepthOfFieldEffect", Lighting)
		dof.Name = "HubDOF"
	else
		local d = Lighting:FindFirstChild("HubDOF")
		if d then d:Destroy() end
	end
end)

CreateToggle(GraphicsTab, "Color Correction", function(state)
	if state then
		local c = Instance.new("ColorCorrectionEffect", Lighting)
		c.Name = "HubCC"
	else
		local c = Lighting:FindFirstChild("HubCC")
		if c then c:Destroy() end
	end
end)

-- ====== ATMOSPHERE ======
local rainEmitter = nil
CreateToggle(AtmosphereTab, "Rain", function(state)
	if state then
		local cam = workspace.CurrentCamera
		local att = Instance.new("Attachment", cam)
		att.Name = "RainAtt"
		rainEmitter = Instance.new("ParticleEmitter", att)
		rainEmitter.Rate = 500
		rainEmitter.Speed = NumberRange.new(50, 60)
		rainEmitter.Texture = "rbxassetid://241696008"
		rainEmitter.Size = NumberSequence.new(0.5)
		rainEmitter.Lifetime = NumberRange.new(1, 1.5)
		rainEmitter.Transparency = NumberSequence.new(0.5)
	else
		if rainEmitter then
			local att = rainEmitter.Parent
			rainEmitter:Destroy()
			if att then att:Destroy() end
			rainEmitter = nil
		end
	end
end)

local snowEmitter = nil
CreateToggle(AtmosphereTab, "Snow", function(state)
	if state then
		local cam = workspace.CurrentCamera
		local att = Instance.new("Attachment", cam)
		att.Name = "SnowAtt"
		snowEmitter = Instance.new("ParticleEmitter", att)
		snowEmitter.Rate = 300
		snowEmitter.Speed = NumberRange.new(5, 10)
		snowEmitter.Texture = "rbxassetid://241696420"
		snowEmitter.Size = NumberSequence.new(0.3)
		snowEmitter.Lifetime = NumberRange.new(3, 4)
		snowEmitter.Transparency = NumberSequence.new(0.2)
	else
		if snowEmitter then
			local att = snowEmitter.Parent
			snowEmitter:Destroy()
			if att then att:Destroy() end
			snowEmitter = nil
		end
	end
end)

CreateToggle(AtmosphereTab, "Colored Fog", function(state)
	if state then
		Lighting.FogColor = Color3.fromRGB(138, 43, 226)
	else
		Lighting.FogColor = Color3.fromRGB(192, 192, 192)
	end
end)

local atmos = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
CreateSlider(AtmosphereTab, "Atmosphere Density", 0, 1, atmos.Density, function(val)
	atmos.Density = val
end)

-- ====== VISUALS ======
local trail = nil
CreateToggle(VisualsTab, "Player Trail", function(state)
	if state then
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local att0 = Instance.new("Attachment", hrp)
			att0.Name = "TrailAtt0"
			att0.Position = Vector3.new(0, -1, 0)
			local att1 = Instance.new("Attachment", hrp)
			att1.Name = "TrailAtt1"
			att1.Position = Vector3.new(0, 1, 0)
			trail = Instance.new("Trail", hrp)
			trail.Name = "HubTrail"
			trail.Attachment0 = att0
			trail.Attachment1 = att1
			trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 204))
			trail.Lifetime = 0.5
			trail.MinLength = 0.1
			trail.MaxLength = 15
		end
	else
		if trail then
			trail:Destroy()
			trail = nil
		end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			for _, c in pairs(hrp:GetChildren()) do
				if c.Name == "TrailAtt0" or c.Name == "TrailAtt1" then
					c:Destroy()
				end
			end
		end
	end
end)

local jumpRing = nil
local ringConnection = nil
CreateToggle(VisualsTab, "Jump Ring", function(state)
	if state then
		ringConnection = RunService.Heartbeat:Connect(function()
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp then
				if hum.FloorMaterial == Enum.Material.Air then
					if not jumpRing then
						jumpRing = Instance.new("Part")
						jumpRing.Size = Vector3.new(4, 0.1, 4)
						jumpRing.Shape = Enum.PartType.Cylinder
						jumpRing.Transparency = 0.4
						jumpRing.Color = Color3.fromRGB(0, 255, 204)
						jumpRing.Material = Enum.Material.Neon
						jumpRing.Anchored = false
						jumpRing.CanCollide = false
						jumpRing.Parent = workspace
						local weld = Instance.new("Weld")
						weld.Part0 = hrp
						weld.Part1 = jumpRing
						weld.C0 = CFrame.new(0, -3.2, 0) * CFrame.Angles(0, 0, math.rad(90))
						weld.Parent = jumpRing
					end
				else
					if jumpRing then
						jumpRing:Destroy()
						jumpRing = nil
					end
				end
			end
		end)
	else
		if ringConnection then ringConnection:Disconnect() ringConnection = nil end
		if jumpRing then jumpRing:Destroy() jumpRing = nil end
	end
end)

-- ====== SETTINGS ======
CreateButton(SettingsTab, "Reset Settings", function()
	Lighting.FogEnd = 100000
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.ExposureCompensation = 0
	Lighting.GlobalShadows = true
	if bloom then bloom:Destroy() bloom = nil end
	if blur then blur:Destroy() blur = nil end
	if trail then
		trail:Destroy()
		trail = nil
	end
	if rainbowConnection then
		rainbowConnection:Disconnect()
		rainbowConnection = nil
	end
	if rainbowHighlight then
		rainbowHighlight:Destroy()
		rainbowHighlight = nil
	end
	Hat_Toggle(false)
	ClassicAura_DisableAll()
	AuraRainbow_Stop()
	local char = LocalPlayer.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			for _, c in pairs(hrp:GetChildren()) do
				if c.Name == "TrailAtt0" or c.Name == "TrailAtt1" then
					c:Destroy()
				end
			end
		end
	end
	if ringConnection then ringConnection:Disconnect() ringConnection = nil end
	if jumpRing then jumpRing:Destroy() jumpRing = nil end
end)

CreateButton(SettingsTab, "Close Hub", function()
	ScreenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.RightShift then
		MainFrame.Visible = not MainFrame.Visible
	end
end)
