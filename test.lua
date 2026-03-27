local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Variables de Tema
local AccentColor = Color3.fromRGB(255, 215, 0) -- Amarillo
local BackgroundColor = Color3.fromRGB(25, 25, 25)
local SidebarColor = Color3.fromRGB(35, 35, 35)
local ElementColor = Color3.fromRGB(45, 45, 45)
local TextColor = Color3.fromRGB(255, 255, 255)
local SubTextColor = Color3.fromRGB(180, 180, 180)

local VelocityLib = {}

function VelocityLib:CreateWindow()
	local guiName = "VelocityUI"
	
	-- 1. Destruir la UI anterior si existe
	local oldGuiCore = pcall(function() return CoreGui:FindFirstChild(guiName) end) and CoreGui:FindFirstChild(guiName)
	local oldGuiPlayer = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName)
	if oldGuiCore then oldGuiCore:Destroy() end
	if oldGuiPlayer then oldGuiPlayer:Destroy() end

	local VelocityGui = Instance.new("ScreenGui")
	VelocityGui.Name = guiName
	VelocityGui.ResetOnSpawn = false
	
	local success, _ = pcall(function() VelocityGui.Parent = CoreGui end)
	if not success then VelocityGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

	-- Contenedor de Notificaciones (Abajo a la izquierda)
	local NotifyContainer = Instance.new("Frame")
	NotifyContainer.Name = "NotifyContainer"
	NotifyContainer.Size = UDim2.new(0, 300, 1, -20)
	NotifyContainer.Position = UDim2.new(0, 20, 0, 0)
	NotifyContainer.BackgroundTransparency = 1
	NotifyContainer.Parent = VelocityGui

	local NotifyLayout = Instance.new("UIListLayout")
	NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	NotifyLayout.Padding = UDim.new(0, 10)
	NotifyLayout.Parent = NotifyContainer

	-- Sistema de Notificaciones
	function VelocityLib:Notify(options)
		local NotifFrame = Instance.new("Frame")
		NotifFrame.Size = UDim2.new(1, 0, 0, 60)
		NotifFrame.BackgroundColor3 = SidebarColor
		NotifFrame.BackgroundTransparency = 1
		NotifFrame.Parent = NotifyContainer
		Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)

		local TitleL = Instance.new("TextLabel")
		TitleL.Size = UDim2.new(1, -20, 0, 20)
		TitleL.Position = UDim2.new(0, 10, 0, 5)
		TitleL.BackgroundTransparency = 1
		TitleL.Text = options.Title or "Notificación"
		TitleL.Font = Enum.Font.GothamBold
		TitleL.TextSize = 14
		TitleL.TextColor3 = AccentColor
		TitleL.TextXAlignment = Enum.TextXAlignment.Left
		TitleL.TextTransparency = 1
		TitleL.Parent = NotifFrame

		local DescL = Instance.new("TextLabel")
		DescL.Size = UDim2.new(1, -20, 0, 30)
		DescL.Position = UDim2.new(0, 10, 0, 25)
		DescL.BackgroundTransparency = 1
		DescL.Text = options.Description or ""
		DescL.Font = Enum.Font.Gotham
		DescL.TextSize = 12
		DescL.TextColor3 = TextColor
		DescL.TextXAlignment = Enum.TextXAlignment.Left
		DescL.TextWrapped = true
		DescL.TextTransparency = 1
		DescL.Parent = NotifFrame

		-- Animación de entrada
		TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
		TweenService:Create(TitleL, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
		TweenService:Create(DescL, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

		-- Destruir después del tiempo
		task.spawn(function()
			task.wait(options.Duration or 3)
			TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			TweenService:Create(TitleL, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			TweenService:Create(DescL, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			task.wait(0.3)
			NotifFrame:Destroy()
		end)
	end

	-- Frame Principal
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 600, 0, 400)
	MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
	MainFrame.BackgroundColor3 = BackgroundColor
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = VelocityGui
	Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

	-- Topbar & Draggable
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 40)
	Topbar.BackgroundTransparency = 1
	Topbar.Parent = MainFrame

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0, 100, 1, 0)
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = "VELOCITY"
	Title.Font = Enum.Font.GothamBlack
	Title.TextSize = 18
	Title.TextColor3 = AccentColor
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Topbar

	-- 2. Texto de Versión en Gris
	local VersionText = Instance.new("TextLabel")
	VersionText.Size = UDim2.new(0, 50, 1, 0)
	VersionText.Position = UDim2.new(0, 110, 0, 2) -- Al lado de VELOCITY
	VersionText.BackgroundTransparency = 1
	VersionText.Text = "v1.1"
	VersionText.Font = Enum.Font.GothamBold
	VersionText.TextSize = 12
	VersionText.TextColor3 = SubTextColor
	VersionText.TextXAlignment = Enum.TextXAlignment.Left
	VersionText.Parent = Topbar

	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 40, 0, 40)
	CloseBtn.Position = UDim2.new(1, -40, 0, 0)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "X"
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 16
	CloseBtn.TextColor3 = TextColor
	CloseBtn.Parent = Topbar

	CloseBtn.MouseButton1Click:Connect(function()
		VelocityGui:Destroy()
	end)

	-- Lógica Draggable
	local dragging, dragInput, dragStart, startPos
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
		end
	end)
	Topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	-- Sidebar (Tabs)
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0, 150, 1, -40)
	Sidebar.Position = UDim2.new(0, 0, 0, 40)
	Sidebar.BackgroundColor3 = SidebarColor
	Sidebar.Parent = MainFrame
	Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

	local SidebarLayout = Instance.new("UIListLayout")
	SidebarLayout.Padding = UDim.new(0, 5)
	SidebarLayout.Parent = Sidebar
	local SidebarPadding = Instance.new("UIPadding")
	SidebarPadding.PaddingTop = UDim.new(0, 10)
	SidebarPadding.PaddingLeft = UDim.new(0, 10)
	SidebarPadding.PaddingRight = UDim.new(0, 10)
	SidebarPadding.Parent = Sidebar

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Size = UDim2.new(1, -160, 1, -50)
	ContentContainer.Position = UDim2.new(0, 155, 0, 45)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = MainFrame

	local WindowOptions = {}
	local firstTab = true

	function WindowOptions:CreateTab(tabName)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 30)
		TabBtn.BackgroundColor3 = BackgroundColor
		TabBtn.BackgroundTransparency = 1
		TabBtn.Text = tabName
		TabBtn.Font = Enum.Font.GothamSemibold
		TabBtn.TextSize = 14
		TabBtn.TextColor3 = SubTextColor
		TabBtn.TextXAlignment = Enum.TextXAlignment.Left -- 3. Alineado a la izquierda
		TabBtn.Parent = Sidebar
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
		
		local TabBtnPadding = Instance.new("UIPadding")
		TabBtnPadding.PaddingLeft = UDim.new(0, 10)
		TabBtnPadding.Parent = TabBtn

		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.ScrollBarThickness = 4
		TabPage.Visible = false
		TabPage.Parent = ContentContainer

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 8)
		PageLayout.Parent = TabPage

		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
		end)

		if firstTab then
			TabPage.Visible = true
			TabBtn.BackgroundTransparency = 0
			TabBtn.TextColor3 = AccentColor
			firstTab = false
		end

		TabBtn.MouseButton1Click:Connect(function()
			for _, child in pairs(ContentContainer:GetChildren()) do
				if child:IsA("ScrollingFrame") then child.Visible = false end
			end
			for _, child in pairs(Sidebar:GetChildren()) do
				if child:IsA("TextButton") then 
					child.BackgroundTransparency = 1 
					child.TextColor3 = SubTextColor
				end
			end
			TabPage.Visible = true
			TabBtn.BackgroundTransparency = 0
			TabBtn.TextColor3 = AccentColor
		end)

		local TabElements = {}

		function TabElements:CreateSection(titleText)
			local Section = Instance.new("TextLabel")
			Section.Size = UDim2.new(1, 0, 0, 25)
			Section.BackgroundTransparency = 1
			Section.Text = titleText
			Section.Font = Enum.Font.GothamBold
			Section.TextSize = 14
			Section.TextColor3 = AccentColor
			Section.TextXAlignment = Enum.TextXAlignment.Left
			Section.Parent = TabPage
		end

		function TabElements:CreateButton(options)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -10, 0, 35)
			Btn.BackgroundColor3 = ElementColor
			Btn.Text = options.Name
			Btn.Font = Enum.Font.GothamSemibold
			Btn.TextSize = 14
			Btn.TextColor3 = TextColor
			Btn.Parent = TabPage
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

			Btn.MouseButton1Click:Connect(function()
				if options.Callback then options.Callback() end
				TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = AccentColor}):Play()
				task.wait(0.1)
				TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = ElementColor}):Play()
			end)
		end

		-- (Mantuve el Toggle y Label originales, omitidos aquí arriba para que no sea inmenso el snippet, los pongo completos)
		function TabElements:CreateToggle(options)
			local ToggleFrame = Instance.new("TextButton")
			ToggleFrame.Size = UDim2.new(1, -10, 0, options.Description and 50 or 35)
			ToggleFrame.BackgroundColor3 = ElementColor
			ToggleFrame.Text = ""
			ToggleFrame.Parent = TabPage
			Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

			local TextL = Instance.new("TextLabel")
			TextL.Size = UDim2.new(1, -60, 0, 20)
			TextL.Position = UDim2.new(0, 10, 0, options.Description and 5 or 7)
			TextL.BackgroundTransparency = 1
			TextL.Text = options.Name
			TextL.Font = Enum.Font.GothamSemibold
			TextL.TextSize = 14
			TextL.TextColor3 = TextColor
			TextL.TextXAlignment = Enum.TextXAlignment.Left
			TextL.Parent = ToggleFrame

			local Checkbox = Instance.new("Frame")
			Checkbox.Size = UDim2.new(0, 40, 0, 20)
			Checkbox.Position = UDim2.new(1, -50, 0.5, -10)
			Checkbox.BackgroundColor3 = BackgroundColor
			Checkbox.Parent = ToggleFrame
			Instance.new("UICorner", Checkbox).CornerRadius = UDim.new(1, 0)

			local Circle = Instance.new("Frame")
			Circle.Size = UDim2.new(0, 16, 0, 16)
			Circle.Position = UDim2.new(0, 2, 0.5, -8)
			Circle.BackgroundColor3 = SubTextColor
			Circle.Parent = Checkbox
			Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

			local state = options.Default or false
			local function UpdateVisuals()
				local goalPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
				local goalCol = state and AccentColor or SubTextColor
				TweenService:Create(Circle, TweenInfo.new(0.2), {Position = goalPos, BackgroundColor3 = goalCol}):Play()
				if options.Callback then options.Callback(state) end
			end

			ToggleFrame.MouseButton1Click:Connect(function()
				state = not state
				UpdateVisuals()
			end)
			UpdateVisuals()
			
			local ToggleFuncs = {}
			function ToggleFuncs:Set(bool) state = bool UpdateVisuals() end
			return ToggleFuncs
		end

		-- 4. Dropdown Original (Selección Única)
		function TabElements:CreateDropdown(options)
			local DropFrame = Instance.new("Frame")
			DropFrame.Size = UDim2.new(1, -10, 0, 35)
			DropFrame.BackgroundColor3 = ElementColor
			DropFrame.ClipsDescendants = true
			DropFrame.Parent = TabPage
			Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

			local DropBtn = Instance.new("TextButton")
			DropBtn.Size = UDim2.new(1, 0, 0, 35)
			DropBtn.BackgroundTransparency = 1
			DropBtn.Text = ""
			DropBtn.Parent = DropFrame

			local TextL = Instance.new("TextLabel")
			TextL.Size = UDim2.new(1, -40, 0, 35)
			TextL.Position = UDim2.new(0, 10, 0, 0)
			TextL.BackgroundTransparency = 1
			TextL.Text = options.Name .. " - Seleccionar"
			TextL.Font = Enum.Font.GothamSemibold
			TextL.TextSize = 14
			TextL.TextColor3 = TextColor
			TextL.TextXAlignment = Enum.TextXAlignment.Left
			TextL.Parent = DropFrame

			local ItemContainer = Instance.new("Frame")
			ItemContainer.Size = UDim2.new(1, 0, 0, 0)
			ItemContainer.Position = UDim2.new(0, 0, 0, 35)
			ItemContainer.BackgroundTransparency = 1
			ItemContainer.Parent = DropFrame
			
			local ItemLayout = Instance.new("UIListLayout")
			ItemLayout.Parent = ItemContainer

			local isDropped = false
			local function ToggleDrop()
				isDropped = not isDropped
				local targetHeight = isDropped and (35 + ItemLayout.AbsoluteContentSize.Y) or 35
				TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
			end

			DropBtn.MouseButton1Click:Connect(ToggleDrop)

			local DropFuncs = {}
			function DropFuncs:Refresh(newList)
				for _, child in pairs(ItemContainer:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				for _, item in pairs(newList) do
					local ItemBtn = Instance.new("TextButton")
					ItemBtn.Size = UDim2.new(1, 0, 0, 30)
					ItemBtn.BackgroundColor3 = BackgroundColor
					ItemBtn.Text = item
					ItemBtn.Font = Enum.Font.Gotham
					ItemBtn.TextSize = 13
					ItemBtn.TextColor3 = SubTextColor
					ItemBtn.Parent = ItemContainer

					ItemBtn.MouseButton1Click:Connect(function()
						TextL.Text = options.Name .. " - " .. item
						ToggleDrop()
						if options.Callback then options.Callback(item) end
					end)
				end
			end
			DropFuncs:Refresh(options.Items or {})
			return DropFuncs
		end

		-- 5. NUEVO: Multi-Dropdown (Selección Múltiple)
		function TabElements:CreateMultiDropdown(options)
			local DropFrame = Instance.new("Frame")
			DropFrame.Size = UDim2.new(1, -10, 0, 35)
			DropFrame.BackgroundColor3 = ElementColor
			DropFrame.ClipsDescendants = true
			DropFrame.Parent = TabPage
			Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

			local DropBtn = Instance.new("TextButton")
			DropBtn.Size = UDim2.new(1, 0, 0, 35)
			DropBtn.BackgroundTransparency = 1
			DropBtn.Text = ""
			DropBtn.Parent = DropFrame

			local TextL = Instance.new("TextLabel")
			TextL.Size = UDim2.new(1, -40, 0, 35)
			TextL.Position = UDim2.new(0, 10, 0, 0)
			TextL.BackgroundTransparency = 1
			TextL.Text = options.Name .. " - Multi-Selección"
			TextL.Font = Enum.Font.GothamSemibold
			TextL.TextSize = 14
			TextL.TextColor3 = TextColor
			TextL.TextXAlignment = Enum.TextXAlignment.Left
			TextL.Parent = DropFrame

			local ItemContainer = Instance.new("Frame")
			ItemContainer.Size = UDim2.new(1, 0, 0, 0)
			ItemContainer.Position = UDim2.new(0, 0, 0, 35)
			ItemContainer.BackgroundTransparency = 1
			ItemContainer.Parent = DropFrame
			
			local ItemLayout = Instance.new("UIListLayout")
			ItemLayout.Parent = ItemContainer

			local isDropped = false
			local selectedItems = {}

			local function UpdateMainText()
				local str = ""
				for item, _ in pairs(selectedItems) do str = str .. item .. ", " end
				if str == "" then TextL.Text = options.Name .. " - Ninguno"
				else TextL.Text = options.Name .. " - " .. string.sub(str, 1, -3) end
			end

			local function ToggleDrop()
				isDropped = not isDropped
				local targetHeight = isDropped and (35 + ItemLayout.AbsoluteContentSize.Y) or 35
				TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, targetHeight)}):Play()
			end

			DropBtn.MouseButton1Click:Connect(ToggleDrop)

			local MultiFuncs = {}
			function MultiFuncs:Refresh(newList)
				for _, child in pairs(ItemContainer:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				selectedItems = {}
				UpdateMainText()

				for _, item in pairs(newList) do
					local ItemBtn = Instance.new("TextButton")
					ItemBtn.Size = UDim2.new(1, 0, 0, 30)
					ItemBtn.BackgroundColor3 = BackgroundColor
					ItemBtn.Text = item
					ItemBtn.Font = Enum.Font.Gotham
					ItemBtn.TextSize = 13
					ItemBtn.TextColor3 = SubTextColor
					ItemBtn.Parent = ItemContainer

					ItemBtn.MouseButton1Click:Connect(function()
						if selectedItems[item] then
							selectedItems[item] = nil
							ItemBtn.TextColor3 = SubTextColor
						else
							selectedItems[item] = true
							ItemBtn.TextColor3 = AccentColor
						end
						UpdateMainText()
						if options.Callback then
							-- Convertir a array para pasarlo al callback
							local arr = {}
							for k, _ in pairs(selectedItems) do table.insert(arr, k) end
							options.Callback(arr) 
						end
					end)
				end
			end
			MultiFuncs:Refresh(options.Items or {})
			return MultiFuncs
		end

		-- 6. NUEVO: Slider
		function TabElements:CreateSlider(options)
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Size = UDim2.new(1, -10, 0, 50)
			SliderFrame.BackgroundColor3 = ElementColor
			SliderFrame.Parent = TabPage
			Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

			local TextL = Instance.new("TextLabel")
			TextL.Size = UDim2.new(1, -60, 0, 20)
			TextL.Position = UDim2.new(0, 10, 0, 5)
			TextL.BackgroundTransparency = 1
			TextL.Text = options.Name
			TextL.Font = Enum.Font.GothamSemibold
			TextL.TextSize = 14
			TextL.TextColor3 = TextColor
			TextL.TextXAlignment = Enum.TextXAlignment.Left
			TextL.Parent = SliderFrame

			local ValueL = Instance.new("TextLabel")
			ValueL.Size = UDim2.new(0, 40, 0, 20)
			ValueL.Position = UDim2.new(1, -50, 0, 5)
			ValueL.BackgroundTransparency = 1
			ValueL.Text = tostring(options.Default or options.Min)
			ValueL.Font = Enum.Font.GothamBold
			ValueL.TextSize = 14
			ValueL.TextColor3 = AccentColor
			ValueL.TextXAlignment = Enum.TextXAlignment.Right
			ValueL.Parent = SliderFrame

			local BarBg = Instance.new("Frame")
			BarBg.Size = UDim2.new(1, -20, 0, 6)
			BarBg.Position = UDim2.new(0, 10, 0, 35)
			BarBg.BackgroundColor3 = BackgroundColor
			BarBg.Parent = SliderFrame
			Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

			local Fill = Instance.new("Frame")
			local startPercent = ((options.Default or options.Min) - options.Min) / (options.Max - options.Min)
			Fill.Size = UDim2.new(startPercent, 0, 1, 0)
			Fill.BackgroundColor3 = AccentColor
			Fill.Parent = BarBg
			Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

			local Knob = Instance.new("TextButton")
			Knob.Size = UDim2.new(0, 14, 0, 14)
			Knob.Position = UDim2.new(1, -7, 0.5, -7)
			Knob.BackgroundColor3 = TextColor
			Knob.Text = ""
			Knob.Parent = Fill
			Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

			local dragging = false
			local function UpdateSlider(input)
				local percent = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
				local val = math.floor(options.Min + ((options.Max - options.Min) * percent))
				Fill.Size = UDim2.new(percent, 0, 1, 0)
				ValueL.Text = tostring(val)
				if options.Callback then options.Callback(val) end
			end

			Knob.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
			end)
			BarBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					UpdateSlider(input)
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					UpdateSlider(input)
				end
			end)
		end

		return TabElements
	end

	return WindowOptions
end

