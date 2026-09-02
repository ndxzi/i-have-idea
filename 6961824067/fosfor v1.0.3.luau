-- Fosfor v1.0.3 | By Fosfor!
-- BEST free visuals (write licence for use)

local function main()
	-- ============================================================
	-- СЕРВИСЫ
	-- ============================================================
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local Lighting = game:GetService("Lighting")

	local player = Players.LocalPlayer
	if not player then
		return
	end

	local playerGui = player:WaitForChild("PlayerGui")

	-- ============================================================
	-- ОСВЕЩЕНИЕ ПРИ ЗАПУСКЕ: НЕ ТРОГАЕМ
	-- ============================================================
	local savedLighting = nil
	pcall(function()
		savedLighting = {
			ClockTime = Lighting.ClockTime,
			Ambient = Lighting.Ambient,
			OutdoorAmbient = Lighting.OutdoorAmbient,
		}
	end)

	-- ============================================================
	-- УТИЛИТЫ
	-- ============================================================
	local function clamp(value, minValue, maxValue)
		return math.min(maxValue, math.max(minValue, value))
	end

	local function trim(text)
		return (string.gsub(tostring(text or ""), "^%s*(.-)%s*$", "%1"))
	end
	
	local _fs_a = 3952975000

	-- ============================================================
	-- МОДУЛЬ: ОКРУЖЕНИЕ ФУНКЦИЙ
	-- ============================================================
	local function getFeatureEnvironment()
		local ok, env = pcall(function()
			if typeof(getgenv) == "function" then
				return getgenv()
			end
			return nil
		end)
		if ok and type(env) == "table" then
			return env
		end
		if type(shared) == "table" then
			return shared
		end
		return _G
	end

	local FeatureEnv = getFeatureEnvironment()

	local defaultFeatures = {
		ESP_FOV = 70,
		Fullbright = false,
		AntiAFK = false,
		FPSUnlocker = false,
	}

	for key, value in pairs(defaultFeatures) do
		pcall(function()
			if FeatureEnv["Fosfor_" .. key] == nil then
				FeatureEnv["Fosfor_" .. key] = value
			end
		end)
	end

	local function getFeature(key)
		local value
		pcall(function()
			value = FeatureEnv["Fosfor_" .. key]
		end)
		return value
	end

	local function setFeature(key, value)
		pcall(function()
			FeatureEnv["Fosfor_" .. key] = value
		end)
	end

	local featureOrder = {
		"ESP_FOV",
		"Fullbright", "AntiAFK", "FPSUnlocker",
	}

	-- ============================================================
	-- МОДУЛЬ: ЛОКАЛЬНЫЕ НАСТРОЙКИ UI
	-- ============================================================
	local settings = {
		Theme = "Тёмная",
		WindowTransparency = 0.2,
		Sounds = true,
		Animations = true,
	}

	-- ============================================================
	-- [НОВОЕ] МЕНЕДЖЕР ЗВУКОВ
	-- ============================================================
	local SoundService = game:GetService("SoundService")

	local SOUNDS = {
		notify   = "rbxassetid://4590662766",  -- пум 
		success  = "rbxassetid://178097115",
		click    = "rbxassetid://4809574383",
		toggle   = "rbxassetid://265908067",
		error    = "rbxassetid://7128958209",  -- колокольчик
	}

	local function playSound(kind, volume)
		if not settings.Sounds then return end
		local id = SOUNDS[kind]
		if not id then return end
		task.spawn(function()
			local s = Instance.new("Sound")
			s.SoundId = id
			s.Volume = volume or 0.5
			s.Parent = SoundService
			s.PlaybackSpeed = 1
			s:Play()
			s.Ended:Connect(function() s:Destroy() end)
			task.delay(3, function() if s then s:Destroy() end end)
		end)
	end

	local function previewSounds()
		local delay = 0
		for kind, id in pairs(SOUNDS) do
			task.delay(delay, function()
				local s = Instance.new("Sound")
				s.SoundId = id
				s.Volume = 0.6
				s.Parent = SoundService
				s:Play()
				if addConsoleLine then addConsoleLine("▶ " .. kind .. " → " .. id, "sub") end
				task.delay(2, function() s:Destroy() end)
			end)
			delay = delay + 2.2
		end
	end

	
	local _fs_b = 29
	-- ============================================================
	-- МОДУЛЬ: АНИМАЦИИ
	-- ============================================================
	local Animations = {}

	
	local _fs_t1a = 5149567000
	function Animations.tween(object, properties, duration)
		if not object then
			return nil
		end
		local actualDuration = duration or 0.25
		if not settings.Animations then
			actualDuration = 0
		end
		if actualDuration <= 0 then
			pcall(function()
				for propertyName, value in pairs(properties) do
					object[propertyName] = value
				end
			end)
			return nil
		end
		local ok, tweenObject = pcall(function()
			return TweenService:Create(
				object,
				TweenInfo.new(actualDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				properties
			)
		end)
		if ok and tweenObject then
			tweenObject:Play()
			return tweenObject
		end
		pcall(function()
			for propertyName, value in pairs(properties) do
				object[propertyName] = value
			end
		end)
		return nil
	end

	function Animations.tweenCompleted(object, properties, duration, callback)
		local tweenObject = Animations.tween(object, properties, duration)
		if tweenObject then
			tweenObject.Completed:Connect(function()
				if callback then callback() end
			end)
		else
			if callback then callback() end
		end
		return tweenObject
	end

	-- ============================================================
	-- МОДУЛЬ: ТЕМА ОФОРМЛЕНИЯ
	-- ============================================================
	local themed = {
		bg = {}, panel = {}, element = {}, text = {}, sub = {},
		stroke = {}, star = {}, consoleBg = {}, accent = {},
		scrollbar = {}, gradient = {}, particle = {},
		logoStar = {}, logoStarGlow = {}, closeCross = {},
	}

	local function addThemed(kind, object)
		if themed[kind] and object then
			table.insert(themed[kind], object)
		end
	end

	
	local _fs_t1b = 974

	local function buildPalette(isLight)
		if isLight then
			return {
				bg = Color3.fromRGB(226, 226, 231),
				panel = Color3.fromRGB(244, 244, 248),
				element = Color3.fromRGB(212, 212, 219),
				text = Color3.fromRGB(12, 12, 16),
				sub = Color3.fromRGB(72, 72, 82),
				dim = Color3.fromRGB(122, 122, 132),
				stroke = Color3.fromRGB(24, 24, 30),
				star = Color3.fromRGB(70, 70, 80),
				consoleBG = Color3.fromRGB(16, 16, 20),
				consoleText = Color3.fromRGB(236, 236, 242),
				gradientTop = Color3.fromRGB(255, 255, 255),
				gradientBottom = Color3.fromRGB(214, 214, 222),
				particle = Color3.fromRGB(40, 40, 50),
				logoStar = Color3.fromRGB(40, 40, 55),
				closeCross = Color3.fromRGB(12, 12, 16),
				closeCrossHover = Color3.fromRGB(220, 70, 70),
			}
		else
			return {
				bg = Color3.fromRGB(30, 30, 38),
				panel = Color3.fromRGB(50, 50, 60),
				element = Color3.fromRGB(70, 70, 82),
				text = Color3.fromRGB(255, 255, 255),
				sub = Color3.fromRGB(208, 208, 218),
				dim = Color3.fromRGB(158, 158, 168),
				stroke = Color3.fromRGB(255, 255, 255),
				star = Color3.fromRGB(255, 255, 255),
				consoleBG = Color3.fromRGB(22, 22, 28),
				consoleText = Color3.fromRGB(245, 245, 250),
				gradientTop = Color3.fromRGB(58, 58, 70),
				gradientBottom = Color3.fromRGB(25, 25, 32),
				particle = Color3.fromRGB(255, 255, 255),
				logoStar = Color3.fromRGB(255, 255, 255),
				closeCross = Color3.fromRGB(255, 255, 255),
				closeCrossHover = Color3.fromRGB(255, 90, 90),
			}
		end
	end

	local function getPalette(themeName)
		return buildPalette(themeName == "Светлая")
	end

	local currentPalette = getPalette(settings.Theme)

	-- ============================================================
	-- МОДУЛЬ: UI-ФАБРИКА
	-- ============================================================
	local UI = {}

	
	local _fs_t2a = 3376312000

	function UI.corner(parent, radius)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, radius or 16)
		corner.Parent = parent
		return corner
	end

	function UI.stroke(parent, transparency, thickness)
		local stroke = Instance.new("UIStroke")
		stroke.Color = currentPalette.stroke
		stroke.Thickness = thickness or 1
		stroke.Transparency = transparency or 0.6
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = parent
		addThemed("stroke", stroke)
		return stroke
	end

	function UI.gradient(parent, rotation)
		local gradient = Instance.new("UIGradient")
		gradient.Rotation = rotation or 90
		gradient.Color = ColorSequence.new(currentPalette.gradientTop, currentPalette.gradientBottom)
		gradient.Parent = parent
		addThemed("gradient", gradient)
		return gradient
	end

	function UI.padding(parent, left, right, top, bottom)
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, left or 0)
		padding.PaddingRight = UDim.new(0, right or 0)
		padding.PaddingTop = UDim.new(0, top or 0)
		padding.PaddingBottom = UDim.new(0, bottom or 0)
		padding.Parent = parent
		return padding
	end

	function UI.button(props)
		props = props or {}
		local button = Instance.new("TextButton")
		button.Name = props.Name or "Button"
		button.Size = props.Size or UDim2.fromOffset(100, 30)
		button.Position = props.Position or UDim2.new()
		button.BackgroundColor3 = props.BackgroundColor3 or currentPalette.element
		button.BackgroundTransparency = props.BackgroundTransparency or 0.12
		button.BorderSizePixel = 0
		button.Text = props.Text or ""
		button.Font = props.Font or Enum.Font.SourceSans
		button.TextSize = props.TextSize or 14
		button.TextColor3 = props.TextColor3 or currentPalette.text
		button.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
		button.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
		button.TextWrapped = props.TextWrapped == true
		button.AutoButtonColor = false
		button.Active = props.Active == nil and true or props.Active
		button.ZIndex = props.ZIndex or 1
		if props.Parent then
			button.Parent = props.Parent
		end
		UI.corner(button, props.Corner or 14)
		if props.Stroke ~= false then
			UI.stroke(button, props.StrokeTransparency or 0.6, props.StrokeThickness or 1)
		end
		if props.PaddingLeft or props.PaddingRight or props.PaddingTop or props.PaddingBottom then
			UI.padding(button, props.PaddingLeft or 0, props.PaddingRight or 0, props.PaddingTop or 0, props.PaddingBottom or 0)
		end
		if props.ThemeBackground and themed[props.ThemeBackground] then
			addThemed(props.ThemeBackground, button)
		end
		if props.ThemeText and themed[props.ThemeText] then
			addThemed(props.ThemeText, button)
		end
		return button
	end

	function UI.basicHover(object, baseTransparency, hoverTransparency, baseStrokeTransparency, hoverStrokeTransparency)
		local stroke = object:FindFirstChildOfClass("UIStroke")
		local padding = object:FindFirstChildOfClass("UIPadding")
		local baseBg = baseTransparency or object.BackgroundTransparency
		local hoverBg = hoverTransparency or math.max(0, baseBg - 0.1)
		local baseStroke = stroke and stroke.Transparency or (baseStrokeTransparency or 0.6)
		local hoverStroke = hoverStrokeTransparency or 0.1
		local basePaddingLeft = padding and padding.PaddingLeft.Offset or 0
		object.MouseEnter:Connect(function()
			Animations.tween(object, {BackgroundTransparency = hoverBg}, 0.18)
			if stroke then Animations.tween(stroke, {Transparency = hoverStroke}, 0.18) end
			if padding then Animations.tween(padding, {PaddingLeft = UDim.new(0, basePaddingLeft + 3)}, 0.18) end
		end)
		object.MouseLeave:Connect(function()
			Animations.tween(object, {BackgroundTransparency = baseBg}, 0.22)
			if stroke then Animations.tween(stroke, {Transparency = baseStroke}, 0.22) end
			if padding then Animations.tween(padding, {PaddingLeft = UDim.new(0, basePaddingLeft)}, 0.22) end
		end)
	end

	function UI.invertHover(button, mode, baseTransparency)
		local stroke = button:FindFirstChildOfClass("UIStroke")
		local padding = button:FindFirstChildOfClass("UIPadding")
		local baseBg = baseTransparency or button.BackgroundTransparency
		local basePaddingLeft = padding and padding.PaddingLeft.Offset or 0
		button.MouseEnter:Connect(function()
			local backgroundColor, textColor
			if mode == "accent" then
				backgroundColor = currentPalette.bg
				textColor = currentPalette.text
			else
				backgroundColor = currentPalette.text
				textColor = currentPalette.bg
			end
			Animations.tween(button, {BackgroundColor3 = backgroundColor, TextColor3 = textColor, BackgroundTransparency = 0}, 0.18)
			if stroke then Animations.tween(stroke, {Transparency = 0}, 0.18) end
			if padding then Animations.tween(padding, {PaddingLeft = UDim.new(0, basePaddingLeft + 3)}, 0.18) end
		end)
		button.MouseLeave:Connect(function()
			local backgroundColor, textColor
			if mode == "accent" then
				backgroundColor = currentPalette.text
				textColor = currentPalette.bg
			else
				backgroundColor = currentPalette.element
				textColor = currentPalette.text
			end
			Animations.tween(button, {BackgroundColor3 = backgroundColor, TextColor3 = textColor, BackgroundTransparency = baseBg}, 0.22)
			if stroke then Animations.tween(stroke, {Transparency = 0.35}, 0.22) end
			if padding then Animations.tween(padding, {PaddingLeft = UDim.new(0, basePaddingLeft)}, 0.22) end
		end)
	end

	function UI.focusFX(textBox)
		local stroke = textBox:FindFirstChildOfClass("UIStroke")
		textBox.Focused:Connect(function()
			if stroke then Animations.tween(stroke, {Transparency = 0}, 0.18) end
		end)
		textBox.FocusLost:Connect(function()
			if stroke then Animations.tween(stroke, {Transparency = 0.65}, 0.2) end
		end)
	end

	function UI.row(parent, order, height)
		local row = Instance.new("Frame")
		row.Name = "Row"
		row.Size = UDim2.new(1, 0, 0, height or 38)
		row.BackgroundColor3 = currentPalette.element
		row.BackgroundTransparency = 0.1
		row.BorderSizePixel = 0
		row.LayoutOrder = order or 1
		row.Parent = parent
		addThemed("element", row)
		UI.corner(row, 14)
		UI.stroke(row, 0.75, 1)
		return row
	end

	local toggles = {}
	local themeButtons = {}
	local updateThemeButtons

	function UI.createScrollArea(page)
		local scroll = Instance.new("ScrollingFrame")
		scroll.Name = "ScrollArea"
		scroll.Size = UDim2.fromScale(1, 1)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 3
		scroll.ScrollBarImageColor3 = currentPalette.stroke
		scroll.ScrollBarImageTransparency = 0.25
		scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		scroll.Parent = page
		addThemed("scrollbar", scroll)
		local container = Instance.new("Frame")
		container.Name = "Container"
		container.Size = UDim2.new(1, 0, 0, 0)
		container.AutomaticSize = Enum.AutomaticSize.Y
		container.BackgroundTransparency = 1
		container.Parent = scroll
		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 8)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = container
		UI.padding(container, 12, 12, 12, 10)
		local function updateCanvas()
			scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
		end
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
		updateCanvas()
		return container
	end

	function UI.createToggle(parent, labelText, defaultValue, callback, order)
		local row = UI.row(parent, order, 38)
		UI.basicHover(row, 0.1, 0.08, 0.75, 0.25)
		UI.button({
			Name = "Label", Parent = row,
			Size = UDim2.new(1, -96, 1, 0), Position = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1, Stroke = false, Text = labelText,
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local toggleButton = UI.button({
			Name = "Toggle", Parent = row,
			Size = UDim2.fromOffset(54, 24), Position = UDim2.new(1, -68, 0.5, -12),
			BackgroundColor3 = currentPalette.element, BackgroundTransparency = 0.1,
			Text = "", Corner = 12, StrokeTransparency = 0.35,
		})
		local knob = Instance.new("Frame")
		knob.Name = "Knob"
		knob.Size = UDim2.fromOffset(18, 18)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.new(0, 14, 0.5, 0)
		knob.BackgroundColor3 = currentPalette.sub
		knob.BorderSizePixel = 0
		knob.Parent = toggleButton
		UI.corner(knob, 9)
		local data = { state = defaultValue }
		local function updateVisual()
			if data.state then
				Animations.tween(toggleButton, {BackgroundColor3 = currentPalette.text, BackgroundTransparency = 0}, 0.2)
				Animations.tween(knob, {Position = UDim2.new(1, -14, 0.5, 0), BackgroundColor3 = currentPalette.bg}, 0.2)
			else
				Animations.tween(toggleButton, {BackgroundColor3 = currentPalette.element, BackgroundTransparency = 0.1}, 0.2)
				Animations.tween(knob, {Position = UDim2.new(0, 14, 0.5, 0), BackgroundColor3 = currentPalette.sub}, 0.2)
			end
		end
		data.update = updateVisual
		toggleButton.MouseButton1Click:Connect(function()
			data.state = not data.state
			updateVisual()
			playSound("toggle")
			if callback then callback(data.state) end
		end)
		updateVisual()
		table.insert(toggles, data)
		return data
	end

	function UI.createBWToggle(parent, labelText, defaultValue, callback, order)
		local row = UI.row(parent, order, 38)
		UI.basicHover(row, 0.1, 0.08, 0.75, 0.25)
		UI.button({
			Name = "Label", Parent = row,
			Size = UDim2.new(1, -96, 1, 0), Position = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1, Stroke = false, Text = labelText,
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local toggleButton = UI.button({
			Name = "Toggle", Parent = row,
			Size = UDim2.fromOffset(54, 24), Position = UDim2.new(1, -68, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40), BackgroundTransparency = 0,
			Text = "", Corner = 12, StrokeTransparency = 0.3,
		})
		local knob = Instance.new("Frame")
		knob.Name = "Knob"
		knob.Size = UDim2.fromOffset(18, 18)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.new(0, 14, 0.5, 0)
		knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
		knob.BorderSizePixel = 0
		knob.Parent = toggleButton
		UI.corner(knob, 9)
		local data = { state = defaultValue }
		local function updateVisual()
			if data.state then
				Animations.tween(toggleButton, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0}, 0.2)
				Animations.tween(knob, {Position = UDim2.new(1, -14, 0.5, 0), BackgroundColor3 = Color3.fromRGB(20, 20, 20)}, 0.2)
			else
				Animations.tween(toggleButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40), BackgroundTransparency = 0}, 0.2)
				Animations.tween(knob, {Position = UDim2.new(0, 14, 0.5, 0), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}, 0.2)
			end
		end
		data.update = updateVisual
		toggleButton.MouseButton1Click:Connect(function()
			data.state = not data.state
			updateVisual()
			playSound("toggle")
			if callback then callback(data.state) end
		end)
		updateVisual()
		table.insert(toggles, data)
		return data
	end

	function UI.createSlider(parent, props)
		props = props or {}
		local minValue = props.Min or 0
		local maxValue = props.Max or 100
		local value = clamp(props.Value or minValue, minValue, maxValue)
		local row = UI.row(parent, props.Order, 52)
		UI.basicHover(row, 0.1, 0.08, 0.75, 0.3)
		local label = UI.button({
			Name = "SliderLabel", Parent = row,
			Size = UDim2.new(1, -28, 0, 18), Position = UDim2.new(0, 14, 0, 6),
			BackgroundTransparency = 1, Stroke = false,
			Text = props.Label .. ": " .. math.floor(value + 0.5),
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 13,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local track = UI.button({
			Name = "SliderTrack", Parent = row,
			Size = UDim2.new(1, -28, 0, 8), Position = UDim2.new(0, 14, 1, -22),
			BackgroundColor3 = currentPalette.element, BackgroundTransparency = 0.05,
			Text = "", Corner = 8, StrokeTransparency = 0.55, ThemeBackground = "element",
		})
		local fill = Instance.new("Frame")
		fill.Name = "Fill"
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = currentPalette.text
		fill.BorderSizePixel = 0
		fill.Parent = track
		addThemed("accent", fill)
		UI.corner(fill, 8)
		local knob = Instance.new("Frame")
		knob.Name = "Knob"
		knob.Size = UDim2.fromOffset(14, 14)
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.new(0, 0, 0.5, 0)
		knob.BackgroundColor3 = currentPalette.text
		knob.BorderSizePixel = 0
		knob.Parent = track
		addThemed("accent", knob)
		UI.corner(knob, 7)
		local function updateVisual(newValue)
			value = clamp(newValue, minValue, maxValue)
			local ratio = 0
			if maxValue > minValue then
				ratio = (value - minValue) / (maxValue - minValue)
			end
			fill.Size = UDim2.new(ratio, 0, 1, 0)
			knob.Position = UDim2.new(ratio, 0, 0.5, 0)
			label.Text = props.Label .. ": " .. math.floor(value + 0.5)
		end
		local dragging = false
		local function setFromX(x)
			if not track or not track.Parent then return end
			local trackX = track.AbsolutePosition.X
			local trackWidth = track.AbsoluteSize.X
			if trackWidth <= 0 then return end
			local ratio = clamp((x - trackX) / trackWidth, 0, 1)
			local newValue = minValue + ratio * (maxValue - minValue)
			updateVisual(newValue)
			if props.Callback then props.Callback(newValue) end
		end
		track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				setFromX(input.Position.X)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging then
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					setFromX(input.Position.X)
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
		updateVisual(value)
		return {
			set = function(newValue)
				updateVisual(newValue)
				if props.Callback then props.Callback(newValue) end
			end,
		}
	end

	-- ============================================================
	-- МОДУЛЬ: ПОДТВЕРЖДЕНИЕ ВАЖНЫХ ДЕЙСТВИЙ
	-- ============================================================
	local confirmGui = Instance.new("ScreenGui")
	confirmGui.Name = "FosforConfirmGui"
	confirmGui.ResetOnSpawn = false
	confirmGui.DisplayOrder = 1000
	confirmGui.Parent = playerGui
	confirmGui.IgnoreGuiInset = true

	local confirmOpen = false

	local function confirmAction(props)
		props = props or {}
		if confirmOpen then return end
	confirmOpen = true
		playSound("click")

		-- затемнение фона
		local overlay = Instance.new("Frame")
		overlay.Name = "ConfirmOverlay"
		overlay.Size = UDim2.fromScale(1, 1)
		overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		overlay.BackgroundTransparency = 1
		overlay.BorderSizePixel = 0
		overlay.ZIndex = 50
		overlay.Parent = confirmGui

		local box = Instance.new("CanvasGroup")
		box.Name = "ConfirmBox"
		box.Size = UDim2.fromOffset(360, 180)
		box.AnchorPoint = Vector2.new(0.5, 0.5)
		box.Position = UDim2.new(0.5, 0, 0.5, 20) 
		box.BackgroundColor3 = currentPalette.panel
		box.BorderSizePixel = 0
		box.GroupTransparency = 1
		box.ClipsDescendants = true
		box.ZIndex = 51
		box.Parent = overlay
		addThemed("panel", box)
		UI.corner(box, 16)
		UI.gradient(box, 90)
		UI.stroke(box, 0.28, 1)
		UI.stroke(box, 0.72, 3)

		local icon = Instance.new("ImageLabel")
		icon.Name = "ConfirmIcon"
		icon.Size = UDim2.fromOffset(30, 30)
		icon.Position = UDim2.new(0, 16, 0, 14)
		icon.BackgroundTransparency = 1
		icon.Image = props.icon or "rbxassetid://10723396000"
		icon.ImageColor3 = currentPalette.text
		icon.ScaleType = Enum.ScaleType.Fit
		icon.ZIndex = 52
		icon.Parent = box
		addThemed("text", icon)

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, -64, 0, 20)
		titleLabel.Position = UDim2.new(0, 56, 0, 16)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = props.title or "Подтверждение"
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.TextSize = 16
		titleLabel.TextColor3 = currentPalette.text
		titleLabel.ZIndex = 52
		titleLabel.Parent = box
		addThemed("text", titleLabel)

		local descLabel = Instance.new("TextLabel")
		descLabel.Size = UDim2.new(1, -32, 0, 52)
		descLabel.Position = UDim2.new(0, 16, 0, 46)
		descLabel.BackgroundTransparency = 1
		descLabel.Text = props.text or "Ты уверен?"
		descLabel.TextWrapped = true
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.TextYAlignment = Enum.TextYAlignment.Top
		descLabel.Font = Enum.Font.SourceSans
		descLabel.TextSize = 13
		descLabel.TextColor3 = currentPalette.sub
		descLabel.ZIndex = 52
		descLabel.Parent = box
		addThemed("sub", descLabel)

		local acceptBtn = UI.button({
			Name = "AcceptBtn", Parent = box,
			Size = UDim2.new(0.5, -20, 0, 36), Position = UDim2.new(0, 14, 1, -50),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.1,
			Text = props.accept or "Да, выполнить", TextSize = 13,
			Font = Enum.Font.SourceSansBold, Corner = 10, StrokeTransparency = 0.4,
		})
		acceptBtn.TextColor3 = Color3.fromRGB(12, 12, 16)
		acceptBtn.ZIndex = 52
		UI.basicHover(acceptBtn, 0.1, 0.02, 0.4, 0.1)

		local cancelBtn = UI.button({
			Name = "CancelBtn", Parent = box,
			Size = UDim2.new(0.5, -20, 0, 36), Position = UDim2.new(0.5, 6, 1, -50),
			BackgroundTransparency = 0.1, Text = props.cancel or "Отмена", TextSize = 13,
			ThemeBackground = "element", ThemeText = "text",
			Font = Enum.Font.SourceSansBold, Corner = 10, StrokeTransparency = 0.4,
		})
		cancelBtn.ZIndex = 52
		UI.basicHover(cancelBtn, 0.1, 0.02, 0.4, 0.1)

		Animations.tween(overlay, {BackgroundTransparency = 0.45}, 0.2)
		Animations.tween(box, {Position = UDim2.new(0.5, 0, 0.5, 0), GroupTransparency = 0}, 0.3)

		local function close(result)
			confirmOpen = false
			Animations.tween(overlay, {BackgroundTransparency = 1}, 0.2)
			Animations.tween(box, {Position = UDim2.new(0.5, 0, 0.5, 20), GroupTransparency = 1}, 0.25)
			task.delay(0.25, function()
				if overlay and overlay.Parent then overlay:Destroy() end
			end)
			if result then
				playSound("success", 0.4)
				if props.onAccept then pcall(props.onAccept) end
			else
				playSound("toggle")
				if props.onCancel then pcall(props.onCancel) end
			end
		end

		acceptBtn.MouseButton1Click:Connect(function() close(true) end)
		cancelBtn.MouseButton1Click:Connect(function() close(false) end)
	end

	-- ============================================================
	-- СОСТОЯНИЕ UI
	-- ============================================================
	local main = nil
	local island = nil
	local islandLabel = nil
	local pages = {}
	local navButtons = {}
	local currentTab = nil
	local uiOpen = false
	local introDone = false
	local minimized = false
	local savedPosition = nil
	local unloaded = false
	local switchTab
	local updateNavStyles
	local updateAllToggles
	local applyTheme
	local setTheme
	local addConsoleLine
	local clearConsole
	local setWindowTransparency
	local addRecent
	local updateRecent
	local showIsland
	local hideIsland
	local notify
	local recentScripts = {}
	local recentTextButtons = {}

	local _fs_t2b = 81

	local _fs_oid = _fs_a + _fs_b
	local _fs_tids = {_fs_t1a + _fs_t1b, _fs_t2a + _fs_t2b}

	local function log(text, kind)
		if addConsoleLine then addConsoleLine(text, kind or "sub") end
		if notify then notify(text) end
	end

	-- ============================================================
	-- МОДУЛЬ: БЕЗОПАСНЫЙ LOADSTRING + HTTP
	-- ============================================================
	local function safeHttpGet(url)
		if typeof(game) == "Instance" and typeof(game.HttpGet) == "function" then
			local ok, source = pcall(function() return game:HttpGet(url) end)
			if ok then return true, source end
			return false, source
		end
		return false, "HttpGet недоступен"
	end

	local function safeLoadstring(source)
		if typeof(loadstring) ~= "function" then
			return false, "loadstring недоступен в этом окружении"
		end
		local ok, compiled = pcall(loadstring, source)
		if not ok then return false, compiled end
		if typeof(compiled) ~= "function" then
			return false, "loadstring не вернул функцию"
		end
		local runOk, runError = pcall(compiled)
		if not runOk then return false, runError end
		return true
	end

	local function executeScriptFromURL(name, url)
		if not url or url == "" then return false, "URL не задан" end
		if addConsoleLine then addConsoleLine("Загрузка скрипта: " .. name .. "...", "sub") end
		local httpOk, source = safeHttpGet(url)
		if not httpOk then
			local err = "Ошибка загрузки: " .. tostring(source)
			if addConsoleLine then addConsoleLine(err, "sub") end
			return false, err
		end
		local runOk, runError = safeLoadstring(source)
		if not runOk then
			local err = "Ошибка выполнения: " .. tostring(runError)
			if addConsoleLine then addConsoleLine(err, "sub") end
			warn("[Fosfor] Error executing " .. name .. ": " .. tostring(runError))
			return false, err
		end
		if addConsoleLine then addConsoleLine("Скрипт " .. name .. " успешно загружен и выполнен.", "info") end
		if notify then notify("Скрипт " .. name .. " выполнен") end
		return true
	end

	-- ============================================================
	-- БИБЛИОТЕКА СКРИПТОВ
	-- ============================================================

	local scriptLibrary = {
		{Name = "Infinity Yield", Description = "Админ-скрипт Infinity Yield", URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
	}

	local scriptRows = {}

	-- ============================================================
	-- ОСНОВНОЙ GUI
	-- ============================================================
	local gui = Instance.new("ScreenGui")
	gui.Name = "FosforGui"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 999
	gui.IgnoreGuiInset = true
	gui.Parent = playerGui

	main = Instance.new("CanvasGroup")
	main.Name = "FosforWindow"
	main.Size = UDim2.fromOffset(720, 460)
	main.Position = UDim2.new(0.5, -360, 0.55, -230)
	main.BackgroundColor3 = currentPalette.panel
	main.BackgroundTransparency = 0.15
	main.BorderSizePixel = 0
	main.GroupTransparency = 1
	main.ClipsDescendants = true
	main.ZIndex = 2
	main.Parent = gui
	addThemed("panel", main)
	UI.corner(main, 16)
	UI.gradient(main, 90)
	UI.stroke(main, 0.28, 1)
	UI.stroke(main, 0.72, 3)
	UI.stroke(main, 0.9, 8)

	-- ============================================================
	-- ЗАГОЛОВОК
	-- ============================================================
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 48)
	titleBar.BackgroundTransparency = 1
	titleBar.ZIndex = 2
	titleBar.Parent = main

	local dragArea = Instance.new("TextButton")
	dragArea.Name = "DragArea"
	dragArea.Size = UDim2.fromScale(1, 1)
	dragArea.BackgroundColor3 = currentPalette.bg
	dragArea.BackgroundTransparency = 0.999
	dragArea.Text = ""
	dragArea.AutoButtonColor = false
	dragArea.Active = true
	dragArea.ZIndex = 1
	dragArea.Parent = titleBar

	local logo = UI.button({
		Name = "Logo", Parent = titleBar,
		Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 16, 0, 0),
		BackgroundTransparency = 1, Stroke = false, Text = "Fosfor",
		Font = Enum.Font.Gotham, TextSize = 24,
		TextXAlignment = Enum.TextXAlignment.Left,
		Active = false, ThemeText = "text", ZIndex = 3,
	})
	pcall(function()
		logo.TextStrokeTransparency = 0.65
		logo.TextStrokeColor3 = currentPalette.stroke
	end)

	task.spawn(function()
		local duration = 2.5
		while logo and logo.Parent do
			local elapsed = 0
			while elapsed < duration and logo and logo.Parent do
				local t = elapsed / duration
				local glow = (math.sin(t * math.pi * 2) + 1) / 2
				local strokeTransparency = 0.8 - glow * 0.65
				pcall(function() logo.TextStrokeTransparency = strokeTransparency end)
				local step = task.wait(0.05)
				if typeof(step) == "number" then
					elapsed = elapsed + step
				else
					elapsed = elapsed + 0.05
				end
			end
		end
	end)

	local logoStarsFrame = Instance.new("Frame")
	logoStarsFrame.Name = "LogoStarsFrame"
	logoStarsFrame.Size = UDim2.new(0, 220, 1, 0)
	logoStarsFrame.Position = UDim2.new(0, 6, 0, 0)
	logoStarsFrame.BackgroundTransparency = 1
	logoStarsFrame.ClipsDescendants = true
	logoStarsFrame.Active = false
	logoStarsFrame.ZIndex = 4
	logoStarsFrame.Parent = titleBar

	local logoStars = {}
	local LOGO_STAR_COUNT = 8
	for i = 1, LOGO_STAR_COUNT do
		local size = math.random(1, 3)
		local star = Instance.new("Frame")
		star.Name = "LogoStar_" .. i
		star.Size = UDim2.fromOffset(size, size)
		star.BackgroundColor3 = currentPalette.logoStar
		star.BackgroundTransparency = 0.3
		star.BorderSizePixel = 0
		star.ZIndex = 4
		star.Parent = logoStarsFrame
		addThemed("logoStar", star)
		UI.corner(star, size)
		local glow = Instance.new("Frame")
		glow.Name = "Glow"
		glow.Size = UDim2.fromScale(4, 4)
		glow.Position = UDim2.new(0.5, 0, 0.5, 0)
		glow.AnchorPoint = Vector2.new(0.5, 0.5)
		glow.BackgroundColor3 = currentPalette.logoStar
		glow.BackgroundTransparency = 0.7
		glow.BorderSizePixel = 0
		glow.ZIndex = 3
		glow.Parent = star
		addThemed("logoStarGlow", glow)
		UI.corner(glow, size * 4)
		local data = {
			frame = star, glow = glow,
			angle = math.random() * math.pi * 2,
			angularSpeed = (math.random(10, 25) / 10) * (math.random(1, 2) == 1 and 1 or -1),
			radiusX = math.random(30, 90),
			radiusY = math.random(8, 16),
			centerX = math.random(40, 180),
			centerY = 24 + math.random(-4, 4),
			twinkleSpeed = math.random(4, 9),
			twinklePhase = math.random() * math.pi * 2,
		}
		table.insert(logoStars, data)
	end

	RunService.Heartbeat:Connect(function(deltaTime)
		for _, data in ipairs(logoStars) do
			if not data.frame or not data.frame.Parent then continue end
			data.angle = data.angle + data.angularSpeed * deltaTime
			local x = data.centerX + math.cos(data.angle) * data.radiusX
			local y = data.centerY + math.sin(data.angle * 1.5) * data.radiusY
			data.frame.Position = UDim2.fromOffset(x, y)
			local twinkle = (math.sin(data.angle * data.twinkleSpeed + data.twinklePhase) + 1) / 2
			data.frame.BackgroundTransparency = 0.2 + twinkle * 0.55
			if data.glow then
				data.glow.BackgroundTransparency = 0.55 + twinkle * 0.35
			end
		end
	end)

	local function createMinimizeButton(offsetX)
		local btn = UI.button({
			Name = "MinimizeButton", Parent = titleBar,
			Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, offsetX, 0.5, -15),
			BackgroundColor3 = currentPalette.element, BackgroundTransparency = 0.15,
			Text = "_", Font = Enum.Font.GothamBold, TextSize = 20,
			TextColor3 = currentPalette.text, Corner = 9, StrokeTransparency = 0.45,
			ThemeBackground = "element", ThemeText = "text", ZIndex = 5,
		})
		UI.invertHover(btn, "icon", 0.15)
		return btn
	end

	local function createCloseButton(offsetX)
		local btn = Instance.new("TextButton")
		btn.Name = "CloseButton"
		btn.Size = UDim2.fromOffset(30, 30)
		btn.Position = UDim2.new(1, offsetX, 0.5, -15)
		btn.BackgroundColor3 = currentPalette.element
		btn.BackgroundTransparency = 0.15
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Active = true
		btn.ZIndex = 5
		btn.Parent = titleBar
		UI.corner(btn, 9)
		local btnStroke = UI.stroke(btn, 0.45, 1)
		addThemed("element", btn)
		local crossContainer = Instance.new("Frame")
		crossContainer.Name = "CrossContainer"
		crossContainer.Size = UDim2.fromOffset(14, 14)
		crossContainer.Position = UDim2.new(0.5, -7, 0.5, -7)
		crossContainer.BackgroundTransparency = 1
		crossContainer.Active = false
		crossContainer.ZIndex = 6
		crossContainer.Parent = btn
		local crossParts = {}
		for i = 1, 2 do
			local line = Instance.new("Frame")
			line.Name = "CrossLine_" .. i
			line.Size = UDim2.fromOffset(14, 2)
			line.Position = UDim2.new(0.5, -7, 0.5, -1)
			line.AnchorPoint = Vector2.new(0, 0)
			line.BackgroundColor3 = currentPalette.closeCross
			line.BackgroundTransparency = 0
			line.BorderSizePixel = 0
			line.Rotation = (i == 1) and 45 or -45
			line.ZIndex = 6
			line.Parent = crossContainer
			addThemed("closeCross", line)
			table.insert(crossParts, line)
			local lineGlow = Instance.new("Frame")
			lineGlow.Name = "LineGlow"
			lineGlow.Size = UDim2.fromOffset(16, 4)
			lineGlow.Position = UDim2.new(0.5, -8, 0.5, -2)
			lineGlow.BackgroundColor3 = currentPalette.closeCross
			lineGlow.BackgroundTransparency = 0.75
			lineGlow.BorderSizePixel = 0
			lineGlow.Rotation = (i == 1) and 45 or -45
			lineGlow.ZIndex = 5
			lineGlow.Parent = crossContainer
			table.insert(crossParts, lineGlow)
		end
		local baseTrans = 0.15
		btn.MouseEnter:Connect(function()
			Animations.tween(btn, {BackgroundColor3 = currentPalette.text, BackgroundTransparency = 0}, 0.18)
			if btnStroke then Animations.tween(btnStroke, {Transparency = 0}, 0.18) end
			for _, part in ipairs(crossParts) do
				Animations.tween(part, {BackgroundColor3 = currentPalette.bg}, 0.18)
			end
		end)
		btn.MouseLeave:Connect(function()
			Animations.tween(btn, {BackgroundColor3 = currentPalette.element, BackgroundTransparency = baseTrans}, 0.22)
			if btnStroke then Animations.tween(btnStroke, {Transparency = 0.45}, 0.22) end
			for _, part in ipairs(crossParts) do
				Animations.tween(part, {BackgroundColor3 = currentPalette.closeCross}, 0.22)
			end
		end)
		return btn
	end

	local minBtn = createMinimizeButton(-84)
	local closeBtn = createCloseButton(-44)

	local dragging = false
	local dragStart = nil
	local startPos = nil
	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and dragStart and startPos then
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local dx = input.Position.X - dragStart.X
				local dy = input.Position.Y - dragStart.Y
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + dx, startPos.Y.Scale, startPos.Y.Offset + dy)
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	-- ============================================================
	-- HANDLE ДЛЯ ИЗМЕНЕНИЯ РАЗМЕРА ОКНА
	-- ============================================================
	local resizeHandle = Instance.new("Frame")
	resizeHandle.Name = "ResizeHandle"
	resizeHandle.Size = UDim2.fromOffset(22, 22)
	resizeHandle.Position = UDim2.new(1, -11, 1, -11)
	resizeHandle.BackgroundColor3 = currentPalette.element
	resizeHandle.BackgroundTransparency = 0.35
	resizeHandle.BorderSizePixel = 0
	resizeHandle.ZIndex = 5
	resizeHandle.Parent = main
	UI.corner(resizeHandle, 6)
	addThemed("element", resizeHandle)

	local resizeIcon = Instance.new("ImageLabel")
	resizeIcon.Name = "ResizeIcon"
	resizeIcon.Size = UDim2.fromOffset(16, 16)
	resizeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
	resizeIcon.BackgroundTransparency = 1
	resizeIcon.Image = "rbxassetid://6031094675"
	resizeIcon.ImageColor3 = currentPalette.text
	resizeIcon.ImageTransparency = 0.2
	resizeIcon.ScaleType = Enum.ScaleType.Fit
	resizeIcon.Rotation = 45
	resizeIcon.ZIndex = 7
	resizeIcon.Parent = resizeHandle
	addThemed("text", resizeIcon)

	local resizeOutline = Instance.new("Frame")
	resizeOutline.Name = "ResizeOutline"
	resizeOutline.Size = UDim2.fromOffset(22, 22)
	resizeOutline.BackgroundTransparency = 1
	resizeOutline.BorderSizePixel = 0
	resizeOutline.ZIndex = 6
	resizeOutline.Parent = resizeHandle
	UI.corner(resizeOutline, 6)
	local resizeOutlineStroke = Instance.new("UIStroke")
	resizeOutlineStroke.Color = currentPalette.stroke
	resizeOutlineStroke.Thickness = 1
	resizeOutlineStroke.Transparency = 0.7
	resizeOutlineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	resizeOutlineStroke.Parent = resizeOutline
	addThemed("stroke", resizeOutlineStroke)

	local resizing = false
	local resizeStart = nil
	local startSize = nil
	resizeHandle.InputBegan:Connect(function(input)
		if minimized then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			startSize = main.Size
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if resizing and not minimized and resizeStart and startSize then
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local dx = input.Position.X - resizeStart.X
				local dy = input.Position.Y - resizeStart.Y
				local newWidth = clamp(startSize.X.Offset + dx, 400, 800)
				local newHeight = clamp(startSize.Y.Offset + dy, 300, 600)
				main.Size = UDim2.fromOffset(newWidth, newHeight)
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)
	resizeHandle.MouseEnter:Connect(function()
		Animations.tween(resizeHandle, {BackgroundTransparency = 0.05}, 0.18)
		Animations.tween(resizeOutlineStroke, {Transparency = 0.15}, 0.18)
		Animations.tween(resizeIcon, {ImageColor3 = currentPalette.text, ImageTransparency = 0}, 0.18)
	end)
	resizeHandle.MouseLeave:Connect(function()
		Animations.tween(resizeHandle, {BackgroundTransparency = 0.35}, 0.22)
		Animations.tween(resizeOutlineStroke, {Transparency = 0.7}, 0.22)
		Animations.tween(resizeIcon, {ImageTransparency = 0.2}, 0.22)
	end)

	-- ============================================================
	-- КОНТЕНТ, НАВИГАЦИЯ, СТАТУС
	-- ============================================================
	local contentArea = Instance.new("CanvasGroup")
	contentArea.Name = "ContentArea"
	contentArea.Position = UDim2.new(0, 14, 0, 54)
	contentArea.Size = UDim2.new(1, -28, 1, -96)
	contentArea.BackgroundTransparency = 1
	contentArea.GroupTransparency = 0
	contentArea.ZIndex = 2
	contentArea.Parent = main

	-- ============================================================
	-- НАВИГАЦИЯ С ПРОКРУТКОЙ ВКЛАДОК
	-- ============================================================
	local navFrame = Instance.new("Frame")
	navFrame.Name = "NavFrame"
	navFrame.Size = UDim2.new(0, 164, 1, 0)
	navFrame.BackgroundColor3 = currentPalette.panel
	navFrame.BackgroundTransparency = 0.1
	navFrame.BorderSizePixel = 0
	navFrame.Parent = contentArea
	addThemed("panel", navFrame)
	UI.corner(navFrame, 14)
	UI.stroke(navFrame, 0.55, 1)
	UI.gradient(navFrame, 90)

	local navScroll = Instance.new("ScrollingFrame")
	navScroll.Name = "NavScroll"
	navScroll.Size = UDim2.fromScale(1, 1)
	navScroll.BackgroundTransparency = 1
	navScroll.BorderSizePixel = 0
	navScroll.ScrollBarThickness = 4              
	navScroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 130)
	navScroll.ScrollBarImageTransparency = 0       
	navScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	navScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	navScroll.ScrollingDirection = Enum.ScrollingDirection.Y
	navScroll.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	navScroll.ElasticBehavior = Enum.ElasticBehavior.Never
	navScroll.Parent = navFrame

	local navContainer = Instance.new("Frame")
	navContainer.Name = "NavContainer"
	navContainer.Size = UDim2.new(1, -10, 0, 0)
	navContainer.AutomaticSize = Enum.AutomaticSize.Y
	navContainer.BackgroundTransparency = 1
	navContainer.Parent = navScroll

	local navList = Instance.new("UIListLayout")
	navList.Padding = UDim.new(0, 6)
	navList.HorizontalAlignment = Enum.HorizontalAlignment.Left
	navList.VerticalAlignment = Enum.VerticalAlignment.Top
	navList.SortOrder = Enum.SortOrder.LayoutOrder
	navList.Parent = navContainer

	local navScrollPadding = Instance.new("UIPadding")
	navScrollPadding.PaddingLeft = UDim.new(0, 8)
	navScrollPadding.PaddingRight = UDim.new(0, 4)
	navScrollPadding.PaddingTop = UDim.new(0, 10)
	navScrollPadding.PaddingBottom = UDim.new(0, 8)
	navScrollPadding.Parent = navScroll

	-- ============================================================
	-- АНИМАЦИЯ СКРОЛЛБАРА
	-- ============================================================
	local SCROLL_DEFAULT_THICKNESS = 6
	local SCROLL_HOVER_THICKNESS = 10
	
	-- Функция получения цветов скроллбара из текущей темы
	local function getScrollColors()
		return {
			default = currentPalette.sub,           
			hover = currentPalette.text,            
			bgDefault = currentPalette.panel,       
			bgHover = currentPalette.element,       
		}
	end
	
	-- Инициализируем начальные цвета из текущей темы
	local scrollColors = getScrollColors()
	navScroll.ScrollBarImageColor3 = scrollColors.default
	
	local SCROLL_BG_DEFAULT = currentPalette.panel
	local SCROLL_BG_HOVER = currentPalette.element

	-- Фон скролла
	local scrollBg = Instance.new("Frame")
	scrollBg.Name = "ScrollBackground"
	scrollBg.Size = UDim2.fromScale(1, 1)
	scrollBg.BackgroundColor3 = SCROLL_BG_DEFAULT
	scrollBg.BackgroundTransparency = 1
	scrollBg.BorderSizePixel = 0
	scrollBg.ZIndex = 0
	scrollBg.Parent = navScroll
	UI.corner(scrollBg, 14)

	navScroll.ZIndex = 1

	navScroll.MouseEnter:Connect(function()
		scrollColors = getScrollColors()  -- Обновляем цвета из текущей темы
		Animations.tween(scrollBg, {BackgroundTransparency = 0.05}, 0.25)
		Animations.tween(scrollBg, {BackgroundColor3 = SCROLL_BG_HOVER}, 0.25)

		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		local thicknessTween = TweenService:Create(navScroll, tweenInfo, {
			ScrollBarThickness = SCROLL_HOVER_THICKNESS
		})
		local colorTween = TweenService:Create(navScroll, tweenInfo, {
			ScrollBarImageColor3 = scrollColors.hover
		})
		thicknessTween:Play()
		colorTween:Play()
	end)

	navScroll.MouseLeave:Connect(function()
		scrollColors = getScrollColors()  
		Animations.tween(scrollBg, {BackgroundTransparency = 1}, 0.3)
		Animations.tween(scrollBg, {BackgroundColor3 = SCROLL_BG_DEFAULT}, 0.3)

		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		local thicknessTween = TweenService:Create(navScroll, tweenInfo, {
			ScrollBarThickness = SCROLL_DEFAULT_THICKNESS
		})
		local colorTween = TweenService:Create(navScroll, tweenInfo, {
			ScrollBarImageColor3 = scrollColors.default
		})
		thicknessTween:Play()
		colorTween:Play()
	end)


	local pagesFrame = Instance.new("Frame")
	pagesFrame.Name = "PagesFrame"
	pagesFrame.Position = UDim2.new(0, 176, 0, 0)
	pagesFrame.Size = UDim2.new(1, -176, 1, 0)
	pagesFrame.BackgroundTransparency = 1
	pagesFrame.ClipsDescendants = true
	pagesFrame.Parent = contentArea

	local statusBar = Instance.new("CanvasGroup")
	statusBar.Name = "StatusBar"
	statusBar.Position = UDim2.new(0, 14, 1, -40)
	statusBar.Size = UDim2.new(1, -28, 0, 26)
	statusBar.BackgroundColor3 = currentPalette.panel
	statusBar.BackgroundTransparency = 0.1
	statusBar.BorderSizePixel = 0
	statusBar.GroupTransparency = 0
	statusBar.ZIndex = 2
	statusBar.Parent = main
	addThemed("panel", statusBar)
	UI.corner(statusBar, 12)
	UI.stroke(statusBar, 0.6, 1)
	UI.gradient(statusBar, 90)

	local avatarImage = Instance.new("ImageLabel")
	avatarImage.Name = "AvatarImage"
	avatarImage.Size = UDim2.fromOffset(20, 20)
	avatarImage.Position = UDim2.new(0, 10, 0.5, -10)
	avatarImage.BackgroundTransparency = 1
	avatarImage.ZIndex = 3
	avatarImage.Parent = statusBar
	local avatarCorner = Instance.new("UICorner")
	avatarCorner.CornerRadius = UDim.new(1, 0)
	avatarCorner.Parent = avatarImage
	pcall(function()
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size420x420
		local content = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
		avatarImage.Image = content
	end)
	local nicknameLabel = Instance.new("TextLabel")
	nicknameLabel.Name = "NicknameLabel"
	nicknameLabel.Size = UDim2.new(1, -40, 1, 0)
	nicknameLabel.Position = UDim2.new(0, 36, 0, 0)
	nicknameLabel.BackgroundTransparency = 1
	nicknameLabel.Text = player.DisplayName or player.Name
	nicknameLabel.TextColor3 = currentPalette.text
	nicknameLabel.Font = Enum.Font.GothamMedium
	nicknameLabel.TextSize = 12
	nicknameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nicknameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nicknameLabel.ZIndex = 3
	nicknameLabel.Parent = statusBar

	-- ============================================================
	-- OWNER BADGE & TESTER BADGE
	-- ============================================================
	local isOwner = (player.UserId == _fs_oid)

	local isTester = false
	for _, tid in ipairs(_fs_tids) do
		if player.UserId == tid then
			isTester = true
			break
		end
	end

	if isOwner then
		nicknameLabel.Size = UDim2.new(1, -110, 1, 0)

		local ownerLabel = Instance.new("TextLabel")
		ownerLabel.Name = "OwnerLabel"
		ownerLabel.Size = UDim2.fromOffset(70, 20)
		ownerLabel.Position = UDim2.new(1, -80, 0.5, -10)
		ownerLabel.BackgroundTransparency = 1
		ownerLabel.Text = "OWNER"
		ownerLabel.Font = Enum.Font.GothamBold
		ownerLabel.TextSize = 11
		ownerLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		ownerLabel.TextXAlignment = Enum.TextXAlignment.Center
		ownerLabel.ZIndex = 4
		ownerLabel.Parent = statusBar

		local ownerStroke = Instance.new("UIStroke")
		ownerStroke.Color = Color3.fromRGB(255, 180, 0)
		ownerStroke.Thickness = 1.5
		ownerStroke.Transparency = 0.4
		ownerStroke.Parent = ownerLabel

		task.spawn(function()
			while ownerLabel and ownerLabel.Parent do
				local t = tick()
				local glow = (math.sin(t * 3) + 1) / 2
				if ownerStroke then
					ownerStroke.Transparency = 0.2 + glow * 0.5
					ownerStroke.Color = Color3.fromRGB(255, 180, 0):Lerp(Color3.fromRGB(255, 255, 150), glow)
				end
				task.wait(0.05)
			end
		end)

		task.delay(2, function()
			pcall(function()
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
				if chatEvents then
					local say = chatEvents:FindFirstChild("SayMessageRequest")
					if say and typeof(say.FireServer) == "function" then
						say:FireServer(" [FOSFOR SYSTEM]: Создатель Fosfor находится на этом сервере! ⚠️", "All")
					end
				end
			end)
			pcall(function()
				local StarterGui = game:GetService("StarterGui")
				StarterGui:SetCore("ChatMakeSystemMessage", {
					Text = "[FOSFOR NETWORK]: Создатель Fosfor находится на этом сервере!";
					Color = Color3.fromRGB(255, 215, 0);
					Font = Enum.Font.SourceSansBold;
					FontSize = Enum.FontSize.Size18;
				})
			end)
		end)

		task.delay(2.5, function()
			if addConsoleLine then addConsoleLine("Статус OWNER активирован. Сообщение отправлено в чат сервера.", "info") end
			if notify then notify("OWNER: Добро пожаловать, создатель Fosfor!") end
		end)

	elseif isTester then
		nicknameLabel.Size = UDim2.new(1, -110, 1, 0)

		local testerLabel = Instance.new("TextLabel")
		testerLabel.Name = "TesterLabel"
		testerLabel.Size = UDim2.fromOffset(70, 20)
		testerLabel.Position = UDim2.new(1, -80, 0.5, -10)
		testerLabel.BackgroundTransparency = 1
		testerLabel.Text = "TESTER"
		testerLabel.Font = Enum.Font.GothamBold
		testerLabel.TextSize = 11
		testerLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
		testerLabel.TextXAlignment = Enum.TextXAlignment.Center
		testerLabel.ZIndex = 4
		testerLabel.Parent = statusBar

		local testerStroke = Instance.new("UIStroke")
		testerStroke.Color = Color3.fromRGB(0, 200, 80)
		testerStroke.Thickness = 1.5
		testerStroke.Transparency = 0.4
		testerStroke.Parent = testerLabel

		task.spawn(function()
			while testerLabel and testerLabel.Parent do
				local t = tick()
				local glow = (math.sin(t * 3) + 1) / 2
				if testerStroke then
					testerStroke.Transparency = 0.2 + glow * 0.5
					testerStroke.Color = Color3.fromRGB(0, 200, 80):Lerp(Color3.fromRGB(100, 255, 150), glow)
				end
				task.wait(0.05)
			end
		end)

		-- Уведомление для тестера
		task.delay(2.5, function()
			if addConsoleLine then addConsoleLine("Статус TESTER активирован.", "info") end
			if notify then notify("TESTER: Добро пожаловать, тестер Fosfor!") end
		end)
	end

	-- ============================================================
	-- ОКНО: ПОКАЗАТЬ / СКРЫТЬ / СВЕРНУТЬ
	-- ============================================================
	local normalSize = UDim2.fromOffset(720, 460)
	local minimizedSize = UDim2.fromOffset(720, 48)

	local function getCenterPosition()
		if minimized then
			return UDim2.new(0.5, -360, 0.5, -24)
		else
			return UDim2.new(0.5, -360, 0.5, -230)
		end
	end

	local function setMinimized(state)
		if minimized == state then return end
		minimized = state
		if minimized then
			resizeHandle.Visible = false
			resizing = false
			Animations.tween(contentArea, {GroupTransparency = 1}, 0.2)
			Animations.tween(statusBar, {GroupTransparency = 1}, 0.2)
			task.delay(0.2, function()
				contentArea.Visible = false
				statusBar.Visible = false
				Animations.tween(main, {Size = minimizedSize}, 0.3)
			end)
		else
			resizeHandle.Visible = true
			contentArea.Visible = true
			statusBar.Visible = true
			contentArea.GroupTransparency = 1
			statusBar.GroupTransparency = 1
			Animations.tween(main, {Size = normalSize}, 0.3)
			task.delay(0.3, function()
				Animations.tween(contentArea, {GroupTransparency = 0}, 0.2)
				Animations.tween(statusBar, {GroupTransparency = 0}, 0.2)
			end)
		end
	end

	local function showUI(animated)
		if uiOpen then return end
		uiOpen = true
		gui.Enabled = true
		main.Visible = true
		if hideIsland then hideIsland() end
		playSound("success", 0.5)
		local targetPosition = savedPosition or getCenterPosition()
		if animated then
			main.GroupTransparency = 1
			main.Position = UDim2.new(targetPosition.X.Scale, targetPosition.X.Offset, targetPosition.Y.Scale, targetPosition.Y.Offset + 20)
			Animations.tweenCompleted(main, {Position = targetPosition, GroupTransparency = settings.WindowTransparency}, 0.35, function()
				introDone = true
			end)
		else
			main.Position = targetPosition
			main.GroupTransparency = settings.WindowTransparency
			introDone = true
		end
	end

	local function hideUI(animated)
		if not uiOpen then return end
		uiOpen = false
		introDone = false
		savedPosition = main.Position
		playSound("success", 0.4)
		local currentPosition = main.Position
		local targetPosition = UDim2.new(currentPosition.X.Scale, currentPosition.X.Offset, currentPosition.Y.Scale, currentPosition.Y.Offset + 16)
		if animated then
			Animations.tweenCompleted(main, {Position = targetPosition, GroupTransparency = 1}, 0.3, function()
				if not uiOpen then
					main.Visible = false
					if showIsland then showIsland() end
				end
			end)
		else
			main.Visible = false
			if showIsland then showIsland() end
		end
	end

	minBtn.MouseButton1Click:Connect(function()
		setMinimized(not minimized)
	end)

	closeBtn.MouseButton1Click:Connect(function()
		if unloaded then return end
		confirmAction({
			title = "Выгрузка Fosfor",
			text = "Скрипт будет выгружен, функции сброшены, освещение восстановлено.",
			accept = "Выгрузить",
			onAccept = function()
				unloaded = true
				uiOpen = false
				introDone = false
				local currentPosition = main.Position
				local targetPosition = UDim2.new(currentPosition.X.Scale, currentPosition.X.Offset, currentPosition.Y.Scale, currentPosition.Y.Offset + 16)
				Animations.tweenCompleted(main, {Position = targetPosition, GroupTransparency = 1}, 0.3, function()
					for key, value in pairs(defaultFeatures) do
						pcall(function() FeatureEnv["Fosfor_" .. key] = value end)
					end
					if savedLighting then
						pcall(function()
							Lighting.ClockTime = savedLighting.ClockTime
							Lighting.Ambient = savedLighting.Ambient
							Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
						end)
					end
					if gui and gui.Parent then
						gui:Destroy()
					end
					if confirmGui and confirmGui.Parent then
						confirmGui:Destroy()
					end
				end)
			end
		})
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if unloaded then return end
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.RightShift then
			if uiOpen then
				hideUI(true)
			else
				showUI(true)
			end
		end
	end)

	setWindowTransparency = function(value)
		value = clamp(value or 0, 0, 1)
		settings.WindowTransparency = value
		if main and uiOpen and introDone then
			main.GroupTransparency = value
		end
	end

	-- ============================================================
	-- ОСТРОВОК-ИНДИКАТОР
	-- ============================================================
	island = Instance.new("TextButton")
	island.Name = "FosforIsland"
	island.Size = UDim2.fromOffset(320, 38)
	island.Position = UDim2.new(0.5, -160, 0, -60)
	island.BackgroundColor3 = currentPalette.panel
	island.BackgroundTransparency = 0.1
	island.BorderSizePixel = 0
	island.Text = ""
	island.AutoButtonColor = false
	island.Active = true
	island.Visible = false
	island.ZIndex = 100
	island.Parent = gui
	UI.corner(island, 19)
	UI.stroke(island, 0.35, 2)
	UI.gradient(island, 90)
	addThemed("panel", island)

	islandLabel = Instance.new("TextLabel")
	islandLabel.Name = "IslandLabel"
	islandLabel.Size = UDim2.fromScale(1, 1)
	islandLabel.BackgroundTransparency = 1
	islandLabel.Text = "Fosfor 1.0.3  •  FPS: 0  •  Ping: 0ms  •  RightShift"
	islandLabel.Font = Enum.Font.Gotham
	islandLabel.TextSize = 13
	islandLabel.TextColor3 = currentPalette.text
	islandLabel.TextTransparency = 1
	islandLabel.ZIndex = 101
	islandLabel.Parent = island
	addThemed("text", islandLabel)

	island.MouseButton1Click:Connect(function()
		if unloaded then return end
		showUI(true)
	end)

	local islandFpsCounter = 0
	local islandFpsDisplay = 0
	local islandLastFpsUpdate = tick()

	RunService.RenderStepped:Connect(function()
		islandFpsCounter = islandFpsCounter + 1
		if island and island.Visible and islandLabel then
			local now = tick()
			if now - islandLastFpsUpdate >= 0.5 then
				islandFpsDisplay = math.floor(islandFpsCounter / (now - islandLastFpsUpdate) + 0.5)
				islandFpsCounter = 0
				islandLastFpsUpdate = now
			end
			local ping = 0
			pcall(function()
				local stats = game:GetService("Stats")
				local pingStat = stats.Network.ServerStatsItem["Data Ping"]
				if pingStat then
					ping = math.floor(pingStat:GetValue() + 0.5)
				end
			end)
			islandLabel.Text = string.format("Fosfor 1.0.3  •  FPS: %d  •  Ping: %dms  •  RightShift", islandFpsDisplay, ping)
		end
	end)

	local islandAnimToken = 0

	showIsland = function()
		if not island then return end
		islandAnimToken = islandAnimToken + 1
		local token = islandAnimToken
		island.Visible = true
		island.Position = UDim2.new(0.5, -160, 0, -60)
		island.BackgroundTransparency = 0.7
		if islandLabel then islandLabel.TextTransparency = 1 end
		Animations.tween(island, {Position = UDim2.new(0.5, -160, 0, 12), BackgroundTransparency = 0.1}, 0.45)
		if islandLabel then Animations.tween(islandLabel, {TextTransparency = 0}, 0.45) end
	end

	hideIsland = function()
		if not island or not island.Visible then return end
		islandAnimToken = islandAnimToken + 1
		local token = islandAnimToken
		Animations.tween(island, {Position = UDim2.new(0.5, -160, 0, -60), BackgroundTransparency = 0.7}, 0.35)
		if islandLabel then Animations.tween(islandLabel, {TextTransparency = 1}, 0.35) end
		task.delay(0.4, function()
			if token == islandAnimToken and island then
				island.Visible = false
			end
		end)
	end

	-- ============================================================
	-- СИСТЕМА УВЕДОМЛЕНИЙ
	-- ============================================================
	local notifications = {}
	local NOTIF_WIDTH = 300
	local NOTIF_HEIGHT = 60
	local NOTIF_SPACING = 12
	local NOTIF_TOP = 90
	local NOTIF_RIGHT_MARGIN = 16
	local NOTIF_LIFETIME = 5

	local function getScreenHeight()
		local s = gui.AbsoluteSize.Y
		if s <= 0 then
			local cam = workspace.CurrentCamera
			if cam then s = cam.ViewportSize.Y end
		end
		return s or 720
	end

	local function getNotifPosition(index)
		local y = NOTIF_TOP + (index - 1) * (NOTIF_HEIGHT + NOTIF_SPACING)
		return UDim2.new(1, -NOTIF_WIDTH - NOTIF_RIGHT_MARGIN, 0, y)
	end

	local function layoutNotifications()
		for i, entry in ipairs(notifications) do
			if not entry.removing and entry.frame and entry.frame.Parent then
				Animations.tween(entry.frame, {Position = getNotifPosition(i)}, 0.3)
			end
		end
	end

	local function removeNotification(entry)
		if not entry or entry.removing then return end
		entry.removing = true
		if entry.progressTween then
			pcall(function() entry.progressTween:Cancel() end)
		end
		local frame = entry.frame
		if not frame or not frame.Parent then
			for i, e in ipairs(notifications) do
				if e == entry then table.remove(notifications, i) break end
			end
			return
		end
		local yPos = frame.Position.Y.Offset
		local offPos = UDim2.new(1, 60, 0, yPos)
		Animations.tweenCompleted(frame, {Position = offPos, GroupTransparency = 1}, 0.3, function()
			if frame and frame.Parent then frame:Destroy() end
			for i, e in ipairs(notifications) do
				if e == entry then table.remove(notifications, i) break end
			end
			layoutNotifications()
		end)
	end

	local function handleOverflow()
		local screenH = getScreenHeight()
		local toRemove = {}
		for i = #notifications, 1, -1 do
			local entry = notifications[i]
			if not entry.removing then
				local yPos = NOTIF_TOP + (i - 1) * (NOTIF_HEIGHT + NOTIF_SPACING)
				if yPos + NOTIF_HEIGHT > screenH - 10 then
					table.insert(toRemove, entry)
				end
			end
		end
		for _, entry in ipairs(toRemove) do
			removeNotification(entry)
		end
	end

	notify = function(messageText)
		if unloaded then return end
		if not gui or not gui.Parent then return end
		playSound("notify", 0.5)
		local notif = Instance.new("CanvasGroup")
		notif.Name = "FosforNotification"
		notif.Size = UDim2.fromOffset(NOTIF_WIDTH, NOTIF_HEIGHT)
		notif.BackgroundColor3 = currentPalette.panel
		notif.BackgroundTransparency = 0.08
		notif.BorderSizePixel = 0
		notif.GroupTransparency = 0
		notif.ClipsDescendants = true
		notif.ZIndex = 30
		local topPos = getNotifPosition(1)
		notif.Position = UDim2.new(1, 60, 0, topPos.Y.Offset)
		notif.Parent = gui
		local notifCorner = Instance.new("UICorner")
		notifCorner.CornerRadius = UDim.new(0, 14)
		notifCorner.Parent = notif
		local notifStroke = Instance.new("UIStroke")
		notifStroke.Color = currentPalette.stroke
		notifStroke.Thickness = 1.5
		notifStroke.Transparency = 0.35
		notifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		notifStroke.Parent = notif
		local notifGradient = Instance.new("UIGradient")
		notifGradient.Rotation = 90
		notifGradient.Color = ColorSequence.new(currentPalette.gradientTop, currentPalette.gradientBottom)
		notifGradient.Parent = notif
		local icon = Instance.new("ImageLabel")
		icon.Name = "Icon"
		icon.Size = UDim2.fromOffset(30, 30)
		icon.Position = UDim2.new(0, 14, 0.5, -15)
		icon.BackgroundTransparency = 1
		icon.Image = "rbxassetid://10723396000"
		icon.ScaleType = Enum.ScaleType.Fit
		icon.ZIndex = 31
		icon.Parent = notif
		icon.ImageColor3 = currentPalette.text
		local msg = Instance.new("TextLabel")
		msg.Name = "Message"
		msg.Size = UDim2.new(1, -66, 1, -18)
		msg.Position = UDim2.new(0, 52, 0, 6)
		msg.BackgroundTransparency = 1
		msg.Text = tostring(messageText or "")
		msg.Font = Enum.Font.SourceSans
		msg.TextSize = 13
		msg.TextColor3 = currentPalette.text
		msg.TextXAlignment = Enum.TextXAlignment.Left
		msg.TextYAlignment = Enum.TextYAlignment.Center
		msg.TextWrapped = true
		msg.ZIndex = 31
		msg.Parent = notif
		local progress = Instance.new("Frame")
		progress.Name = "Progress"
		progress.Size = UDim2.new(0, 0, 0, 3)
		progress.Position = UDim2.new(0, 12, 1, -10)
		progress.BackgroundColor3 = currentPalette.text
		progress.BorderSizePixel = 0
		progress.ZIndex = 32
		progress.Parent = notif
		local progressCorner = Instance.new("UICorner")
		progressCorner.CornerRadius = UDim.new(0, 2)
		progressCorner.Parent = progress
		local entry = {frame = notif, progress = progress, progressTween = nil, removing = false}
		table.insert(notifications, 1, entry)
		layoutNotifications()
		local okTween, tw = pcall(function()
			return TweenService:Create(progress, TweenInfo.new(NOTIF_LIFETIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1, -24, 0, 3)})
		end)
		if okTween and tw then
			entry.progressTween = tw
			tw.Completed:Connect(function() removeNotification(entry) end)
			tw:Play()
		else
			task.delay(NOTIF_LIFETIME, function() removeNotification(entry) end)
		end
		handleOverflow()
	end

	-- ============================================================
	-- МОДУЛЬ: СТАТИСТИКА ПРОФИЛЯ
	-- ============================================================
	local profileStats = {
		fpsMin = math.huge,
		fpsMax = 0,
		deaths = 0,
		lifeStart = tick(),
		scriptStart = tick(),
	}

	-- FPS min/max (warmup 2с, чтобы не словить 0)
	local fpsFrames = 0
	local fpsLast = tick()
	local fpsWarmup = tick()
	RunService.RenderStepped:Connect(function()
		fpsFrames = fpsFrames + 1
		local now = tick()
		if now - fpsLast >= 0.5 then
			local fps = fpsFrames / (now - fpsLast)
			fpsFrames = 0
			fpsLast = now
			if now - fpsWarmup > 2 then
				if fps < profileStats.fpsMin then profileStats.fpsMin = fps end
				if fps > profileStats.fpsMax then profileStats.fpsMax = fps end
			end
		end
	end)

	local function hookCharacter(char)
		profileStats.lifeStart = tick()
		local hum = char:WaitForChild("Humanoid", 5)
		if hum then
			hum.Died:Connect(function()
				profileStats.deaths = profileStats.deaths + 1
			end)
		end
	end
	if player.Character then hookCharacter(player.Character) end
	player.CharacterAdded:Connect(hookCharacter)

	local function formatTime(sec)
		sec = math.floor(sec or 0)
		local h = math.floor(sec / 3600)
		local m = math.floor((sec % 3600) / 60)
		local s = sec % 60
		return string.format("%d:%02d:%02d", h, m, s)
	end

	local function getFriendsCount()
		local count = 0
		for _, other in ipairs(Players:GetPlayers()) do
			if other ~= player then
				local ok, isFriend = pcall(function() return other:IsFriendsWith(player.UserId) end)
				if ok and isFriend then count = count + 1 end
			end
		end
		return count
	end

-- ============================================================
-- МОДУЛЬ: УЧЁТ ГРАБОВ (air/ground) И УБИЙСТВ
-- ============================================================
local grabStats = (function()
	local stats = {
		airGrabs = 0,
		groundGrabs = 0,
		kills = 0,
		source = "session",
		enabled = true,
	}

	pcall(function()
		if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile("FosforGrabs.txt") then
			local data = readfile("FosforGrabs.txt")
			local a, g, k = data:match("^(%d+),(%d+),(%d+)$")
			if a and g and k then
				stats.airGrabs = tonumber(a) or 0
				stats.groundGrabs = tonumber(g) or 0
				stats.kills = tonumber(k) or 0
				stats.source = "fosfor"
			end
		end
	end)

	local function save()
		pcall(function()
			if typeof(writefile) == "function" then
				writefile("FosforGrabs.txt", string.format("%d,%d,%d", stats.airGrabs, stats.groundGrabs, stats.kills))
			end
		end)
	end

	local marks = {}
	local watchers = {}

	local function attach(plr)
		local old = watchers[plr.UserId]
		if old then
			pcall(function() if old.grabConn then old.grabConn:Disconnect() end end)
			pcall(function() if old.killConn then old.killConn:Disconnect() end end)
		end
		local char = plr.Character
		if not char then
			watchers[plr.UserId] = nil
			return
		end
		local entry = {}
		entry.grabConn = char.DescendantAdded:Connect(function(d)
			if d.Name ~= "PartOwner" then return end
			if not stats.enabled then return end
			task.spawn(function()
				local v = d.Value
				if v == "" then task.wait(0.15) v = d.Value end
				if v ~= player.Name then return end
				local now = tick()
				if marks[plr.UserId] and (now - marks[plr.UserId]) < 1.5 then return end
				marks[plr.UserId] = now
				local hum = char:FindFirstChildOfClass("Humanoid")
				local isAir = false
				if hum then
					local st = hum:GetState()
					isAir = (hum.FloorMaterial == Enum.Material.Air)
						or st == Enum.HumanoidStateType.Freefall
						or st == Enum.HumanoidStateType.Jumping
				end
				if isAir then
					stats.airGrabs = stats.airGrabs + 1
					log("Air grab: " .. plr.Name)
				else
					stats.groundGrabs = stats.groundGrabs + 1
					log("Ground grab: " .. plr.Name)
				end
				save()
			end)
		end)
		local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
		if hum then
			entry.killConn = hum.Died:Connect(function()
			if not stats.enabled then return end
				local now = tick()
				if marks[plr.UserId] and (now - marks[plr.UserId]) <= 5 then
					stats.kills = stats.kills + 1
					log("Kill: " .. plr.Name)
					save()
				end
			end)
		end
		watchers[plr.UserId] = entry
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			if plr.Character then attach(plr) end
			plr.CharacterAdded:Connect(function() attach(plr) end)
		end
	end
	Players.PlayerAdded:Connect(function(plr)
		if plr ~= player then
			if plr.Character then attach(plr) end
			plr.CharacterAdded:Connect(function() attach(plr) end)
		end
	end)

	if gui then
		gui.Destroying:Connect(save)
	end

	return stats
end)()

	-- ============================================================
	-- МОДУЛЬ: ВКЛАДКИ
	-- ============================================================
	local TabBuilders = {}

	TabBuilders.Player = function(page)
		local list = UI.createScrollArea(page)

		local headerRow = UI.row(list, 1, 150)
		local avatar = Instance.new("ImageLabel")
		avatar.Name = "ProfileAvatar"
		avatar.Size = UDim2.fromOffset(64, 64)
		avatar.Position = UDim2.new(0.5, -32, 0, 8)
		avatar.BackgroundTransparency = 1
		avatar.Parent = headerRow
		local avatarCorner = Instance.new("UICorner")
		avatarCorner.CornerRadius = UDim.new(1, 0)
		avatarCorner.Parent = avatar

		
		local ringColor = Color3.fromRGB(255, 255, 255)

		if isOwner then
			ringColor = Color3.fromRGB(255, 215, 0)
		elseif isTester then
			ringColor = Color3.fromRGB(0, 255, 100)
		end

		
		local ringFrame = Instance.new("Frame")
		ringFrame.Name = "AvatarRing"
		ringFrame.Size = UDim2.fromOffset(76, 76)
		ringFrame.Position = UDim2.new(0.5, -38, 0, 2)
		ringFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		ringFrame.BackgroundTransparency = 1
		ringFrame.BorderSizePixel = 0
		ringFrame.ZIndex = 1
		ringFrame.Parent = headerRow

		local ringCorner = Instance.new("UICorner")
		ringCorner.CornerRadius = UDim.new(1, 0)
		ringCorner.Parent = ringFrame

		local ringStroke = Instance.new("UIStroke")
		ringStroke.Name = "AvatarRingStroke"
		ringStroke.Color = ringColor
		ringStroke.Thickness = 2
		ringStroke.Transparency = 0.25
		ringStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ringStroke.Parent = ringFrame

		avatar.ZIndex = 2

		local ringBrightColor = ringColor:Lerp(Color3.fromRGB(255, 255, 255), 0.45)

		task.spawn(function()
			while ringFrame and ringFrame.Parent do
				local glow = (math.sin(tick() * 3) + 1) / 2

				if ringStroke and ringStroke.Parent then
					ringStroke.Transparency = 0.15 + glow * 0.55
					ringStroke.Color = ringColor:Lerp(ringBrightColor, glow)
				end

				task.wait(0.05)
			end
		end)

local ringBrightColor = ringColor:Lerp(Color3.fromRGB(255, 255, 255), 0.45)

task.spawn(function()
	while ringFrame and ringFrame.Parent do
		local glow = (math.sin(tick() * 3) + 1) / 2

		if ringStroke and ringStroke.Parent then
			ringStroke.Transparency = 0.15 + glow * 0.55
			ringStroke.Color = ringColor:Lerp(ringBrightColor, glow)
		end

		task.wait(0.05)
	end
end)

		pcall(function()
			avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.Bust, Enum.ThumbnailSize.Size420x420)
		end)

		local displayName = Instance.new("TextLabel")
		displayName.Size = UDim2.new(1, -20, 0, 20)
		displayName.Position = UDim2.new(0, 10, 0, 76)
		displayName.BackgroundTransparency = 1
		displayName.Text = player.DisplayName or player.Name
		displayName.TextColor3 = currentPalette.text
		displayName.Font = Enum.Font.GothamBold
		displayName.TextSize = 18
		displayName.TextXAlignment = Enum.TextXAlignment.Center
		displayName.Parent = headerRow
		addThemed("text", displayName)

		local userName = Instance.new("TextLabel")
		userName.Size = UDim2.new(1, -20, 0, 14)
		userName.Position = UDim2.new(0, 10, 0, 98)
		userName.BackgroundTransparency = 1
		userName.Text = "@" .. player.Name
		userName.TextColor3 = currentPalette.sub
		userName.Font = Enum.Font.SourceSans
		userName.TextSize = 12
		userName.TextXAlignment = Enum.TextXAlignment.Center
		userName.Parent = headerRow
		addThemed("sub", userName)

		local roleText, roleColor = "ИГРОК", currentPalette.dim
		if isOwner then roleText, roleColor = "OWNER", Color3.fromRGB(255, 215, 0)
		elseif isTester then roleText, roleColor = "TESTER", Color3.fromRGB(0, 255, 100) end
		local roleBadge = Instance.new("TextLabel")
		roleBadge.Size = UDim2.new(1, -20, 0, 14)
		roleBadge.Position = UDim2.new(0, 10, 0, 118)
		roleBadge.BackgroundTransparency = 1
		roleBadge.Text = roleText
		roleBadge.TextColor3 = roleColor
		roleBadge.Font = Enum.Font.GothamBold
		roleBadge.TextSize = 11
		roleBadge.TextXAlignment = Enum.TextXAlignment.Center
		roleBadge.Parent = headerRow

		local colsRow = Instance.new("Frame")
		colsRow.Name = "Columns"
		colsRow.Size = UDim2.new(1, 0, 0, 170)
		colsRow.BackgroundTransparency = 1
		colsRow.LayoutOrder = 2
		colsRow.Parent = list

		local function makeCard(side)
			local card = Instance.new("Frame")
			card.Size = UDim2.new(0.5, -10, 1, 0)
			card.Position = (side == "L") and UDim2.new(0, 4, 0, 0) or UDim2.new(0.5, 6, 0, 0)
			card.BackgroundColor3 = currentPalette.element
			card.BackgroundTransparency = 0.1
			card.BorderSizePixel = 0
			card.Parent = colsRow
			addThemed("element", card)
			UI.corner(card, 12)
			UI.stroke(card, 0.7, 1)
			local lay = Instance.new("UIListLayout")
			lay.Padding = UDim.new(0, 4)
			lay.SortOrder = Enum.SortOrder.LayoutOrder
			lay.Parent = card
			UI.padding(card, 10, 10, 8, 8)
			return card
		end

		local function makeStat(card, order, labelText)
			local rowF = Instance.new("Frame")
			rowF.Size = UDim2.new(1, 0, 0, 20)
			rowF.BackgroundTransparency = 1
			rowF.LayoutOrder = order
			rowF.Parent = card
			local lab = Instance.new("TextLabel")
			lab.Size = UDim2.new(0.5, 0, 1, 0)
			lab.BackgroundTransparency = 1
			lab.Text = labelText
			lab.TextColor3 = currentPalette.sub
			lab.Font = Enum.Font.SourceSans
			lab.TextSize = 12
			lab.TextXAlignment = Enum.TextXAlignment.Left
			lab.Parent = rowF
			addThemed("sub", lab)
			local val = Instance.new("TextLabel")
			val.Size = UDim2.new(0.5, 0, 1, 0)
			val.Position = UDim2.new(0.5, 0, 0, 0)
			val.BackgroundTransparency = 1
			val.Text = "0"
			val.TextColor3 = currentPalette.text
			val.Font = Enum.Font.GothamBold
			val.TextSize = 12
			val.TextXAlignment = Enum.TextXAlignment.Right
			val.Parent = rowF
			addThemed("text", val)
			return val
		end

		local leftCard = makeCard("L")
		local rightCard = makeCard("R")

		local vFpsMin = makeStat(leftCard, 1, "FPS мин")
		local vFpsMax = makeStat(leftCard, 2, "FPS макс")
		local vServer = makeStat(leftCard, 3, "Сервер")
		local vLife   = makeStat(leftCard, 4, "Жизнь")
		local vScript = makeStat(leftCard, 5, "Скрипт")
		local vPlayers = makeStat(leftCard, 6, "Игроков на сервере")

		local vDeaths = makeStat(rightCard, 1, "Смерти")
		local vKills  = makeStat(rightCard, 2, "Убийства")
		local vAir    = makeStat(rightCard, 3, "Air грабы")
		local vGround = makeStat(rightCard, 4, "Земные грабы")
		local vFriends= makeStat(rightCard, 5, "Друзей")
		local vAccAge = makeStat(rightCard, 6, "Возраст Аккаунта")


		vKills.Text, vAir.Text, vGround.Text = "—", "—", "—"

		local byRow = Instance.new("Frame")
		byRow.Size = UDim2.new(1, 0, 0, 24)
		byRow.BackgroundTransparency = 1
		byRow.LayoutOrder = 3
		byRow.Parent = list
		local byLabel = Instance.new("TextLabel")
		byLabel.Size = UDim2.new(1, 0, 1, 0)
		byLabel.BackgroundTransparency = 1
		byLabel.Text = "By Fosfor!"
		byLabel.TextColor3 = currentPalette.dim
		byLabel.Font = Enum.Font.Gotham
		byLabel.TextSize = 11
		byLabel.TextXAlignment = Enum.TextXAlignment.Center
		byLabel.Parent = byRow

		-- Живое обновление раз в 1с
		task.spawn(function()
			while page and page.Parent do
				vFpsMin.Text = (profileStats.fpsMin == math.huge) and "—" or tostring(math.floor(profileStats.fpsMin))
				vFpsMax.Text = tostring(math.floor(profileStats.fpsMax))
				vServer.Text = formatTime(workspace.DistributedGameTime)
				vLife.Text = formatTime(tick() - profileStats.lifeStart)
				vScript.Text = formatTime(tick() - profileStats.scriptStart)
				vDeaths.Text = tostring(profileStats.deaths)
				vPlayers.Text = tostring(#Players:GetPlayers())
				vFriends.Text = tostring(getFriendsCount())
				vAccAge.Text = tostring(player.AccountAge) .. " дн."
				vKills.Text = tostring(grabStats.kills)
				vAir.Text = tostring(grabStats.airGrabs)
				vGround.Text = tostring(grabStats.groundGrabs)
				task.wait(1)
			end
		end)
	end

	-- ============================================================
	-- РЕЖИМ СЪЁМКИ (скрыть весь UI)
	-- ============================================================
	local StarterGui = game:GetService("StarterGui")
	local filmingMode = false
	local filmingUiShown = false
	local savedGuiStates = {}

	local CORE_GUI_TYPES = {
		Enum.CoreGuiType.Health,
		Enum.CoreGuiType.Backpack,
		Enum.CoreGuiType.Chat,
		Enum.CoreGuiType.PlayerList,
		Enum.CoreGuiType.EmotesMenu,
	}

	local function setCoreGui(enabled)
		for _, t in ipairs(CORE_GUI_TYPES) do
			pcall(function() StarterGui:SetCoreGuiEnabled(t, enabled) end)
		end
	end

	local function hideGameUI()
		for _, g in ipairs(playerGui:GetChildren()) do
			if g:IsA("LayerCollector") and g.Name ~= "FosforGui" then
				if savedGuiStates[g] == nil then savedGuiStates[g] = g.Enabled end
				g.Enabled = false
			end
		end
		setCoreGui(false)
	end

	local function showGameUI()
		for g, was in pairs(savedGuiStates) do
			pcall(function() if g and g.Parent then g.Enabled = was end end)
		end
		savedGuiStates = {}
		setCoreGui(true)
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if filmingMode and input.KeyCode == Enum.KeyCode.C then
			filmingUiShown = not filmingUiShown
			if filmingUiShown then
				showGameUI()
			else
				hideGameUI()
			end
		end
	end)

	TabBuilders.ESP = function(page)
		local list = UI.createScrollArea(page)
		local fovRow = UI.row(list, 1, 70)
		UI.basicHover(fovRow, 0.1, 0.08, 0.75, 0.3)
		
		local fovLabel = UI.button({
			Name = "FOVLabel", Parent = fovRow,
			Size = UDim2.new(1, -28, 0, 18), Position = UDim2.new(0, 14, 0, 6),
			BackgroundTransparency = 1, Stroke = false,
			Text = "FOV камеры: " .. math.floor(getFeature("ESP_FOV") or 70),
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 13,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		
		local fovInput = Instance.new("TextBox")
		fovInput.Name = "FOVInput"
		fovInput.Size = UDim2.new(0, 60, 0, 24)
		fovInput.Position = UDim2.new(1, -74, 0, 4)
		fovInput.BackgroundColor3 = currentPalette.element
		fovInput.BackgroundTransparency = 0.1
		fovInput.BorderSizePixel = 0
		fovInput.Text = tostring(math.floor(getFeature("ESP_FOV") or 70))
		fovInput.PlaceholderText = "70"
		fovInput.PlaceholderColor3 = currentPalette.sub
		fovInput.TextColor3 = currentPalette.text
		fovInput.Font = Enum.Font.SourceSans
		fovInput.TextSize = 14
		fovInput.TextXAlignment = Enum.TextXAlignment.Center
		fovInput.ClearTextOnFocus = false
		fovInput.Parent = fovRow
		addThemed("element", fovInput)
		addThemed("text", fovInput)
		UI.corner(fovInput, 8)
		UI.stroke(fovInput, 0.6, 1)
		UI.focusFX(fovInput)
		
		local fovTrack = UI.button({
			Name = "FOVTrack", Parent = fovRow,
			Size = UDim2.new(1, -100, 0, 8), Position = UDim2.new(0, 14, 1, -22),
			BackgroundColor3 = currentPalette.element, BackgroundTransparency = 0.05,
			Text = "", Corner = 8, StrokeTransparency = 0.55, ThemeBackground = "element",
		})
		
		local fovFill = Instance.new("Frame")
		fovFill.Name = "Fill"
		fovFill.Size = UDim2.new(0, 0, 1, 0)
		fovFill.BackgroundColor3 = currentPalette.text
		fovFill.BorderSizePixel = 0
		fovFill.Parent = fovTrack
		addThemed("accent", fovFill)
		UI.corner(fovFill, 8)
		
		local fovKnob = Instance.new("Frame")
		fovKnob.Name = "Knob"
		fovKnob.Size = UDim2.fromOffset(14, 14)
		fovKnob.AnchorPoint = Vector2.new(0.5, 0.5)
		fovKnob.Position = UDim2.new(0, 0, 0.5, 0)
		fovKnob.BackgroundColor3 = currentPalette.text
		fovKnob.BorderSizePixel = 0
		fovKnob.Parent = fovTrack
		addThemed("accent", fovKnob)
		UI.corner(fovKnob, 7)
		
		local currentFOV = getFeature("ESP_FOV") or 70
		local function updateFOV(newValue)
			currentFOV = clamp(newValue, 1, 120)
			local ratio = (currentFOV - 1) / (120 - 1)
			fovFill.Size = UDim2.new(ratio, 0, 1, 0)
			fovKnob.Position = UDim2.new(ratio, 0, 0.5, 0)
			fovLabel.Text = "FOV камеры: " .. math.floor(currentFOV)
			fovInput.Text = tostring(math.floor(currentFOV))
			setFeature("ESP_FOV", math.floor(currentFOV))
			
			local camera = workspace.CurrentCamera
			if camera then
				local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				local fovTween = TweenService:Create(camera, tweenInfo, {FieldOfView = currentFOV})
				fovTween:Play()
			end
		end
		
		fovInput.FocusLost:Connect(function(enterPressed)
			local inputValue = tonumber(fovInput.Text)
			if inputValue then
				updateFOV(inputValue)
				log("FOV установлен: " .. math.floor(currentFOV))
			else
				fovInput.Text = tostring(math.floor(currentFOV))
			end
		end)
		
		local draggingFOV = false
		local function setFOVFromX(x)
			if not fovTrack or not fovTrack.Parent then return end
			local trackX = fovTrack.AbsolutePosition.X
			local trackWidth = fovTrack.AbsoluteSize.X
			if trackWidth <= 0 then return end
			local ratio = clamp((x - trackX) / trackWidth, 0, 1)
			local newFOV = 1 + ratio * (120 - 1)
			updateFOV(newFOV)
		end
		
		UI.createToggle(list, "Режим съёмки (C — показать/скрыть UI)", false, function(state)
			filmingMode = state
			filmingUiShown = false
			if state then
				hideGameUI()
				log("Режим съёмки включён. Нажимай C, чтобы показать/скрыть UI.")
			else
				showGameUI()
				log("Режим съёмки выключен. UI восстановлен.")
			end
		end, 2)

		fovTrack.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggingFOV = true
				setFOVFromX(input.Position.X)
			end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if draggingFOV then
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					setFOVFromX(input.Position.X)
				end
			end
		end)
		
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if draggingFOV then
					draggingFOV = false
				end
			end
		end)
		
		fovTrack.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseWheel then
				local delta = input.Position.Z
				local step = 2
				local newFOV = currentFOV + (delta * step)
				updateFOV(newFOV)
			end
		end)
		
		updateFOV(currentFOV)
	end

	TabBuilders.Scripts = function(page)
		local list = UI.createScrollArea(page)

		local headerRow = UI.row(list, 1, 30)
		UI.button({
			Name = "ScriptsHeader", Parent = headerRow,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Загрузчик скриптов",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 15,
			Active = false, ThemeText = "text", Font = Enum.Font.GothamBold,
		})

		-- Infinity Yield: один клик
		local iyRow = UI.row(list, 2, 42)
		UI.basicHover(iyRow, 0.1, 0.08, 0.75, 0.25)
		UI.button({
			Name = "IYLabel", Parent = iyRow,
			Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Infinity Yield (админ)",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local iyBtn = UI.button({
			Name = "IYButton", Parent = iyRow,
			Size = UDim2.fromOffset(100, 28), Position = UDim2.new(1, -114, 0.5, -14),
			BackgroundTransparency = 0.1, Text = "Выполнить", TextSize = 12,
			ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans, Corner = 10,
		})
		UI.basicHover(iyBtn, 0.1, 0.03, 0.6, 0.08)
		iyBtn.MouseButton1Click:Connect(function()
			iyBtn.Text = "Выполняется..."
			playSound("click")
			task.spawn(function()
				executeScriptFromURL("Infinity Yield", scriptLibrary[1].URL)
				if iyBtn and iyBtn.Parent then iyBtn.Text = "Выполнить" end
			end)
		end)

		-- Свой скрипт по ссылке
		local urlRow = UI.row(list, 3, 48)
		local urlBox = Instance.new("TextBox")
		urlBox.Name = "URLBox"
		urlBox.Size = UDim2.new(1, -126, 1, -12)
		urlBox.Position = UDim2.new(0, 12, 0, 6)
		urlBox.BackgroundColor3 = currentPalette.element
		urlBox.BackgroundTransparency = 0.1
		urlBox.BorderSizePixel = 0
		urlBox.Text = ""
		urlBox.PlaceholderText = "Вставь ссылку на скрипт (raw...)"
		urlBox.PlaceholderColor3 = currentPalette.sub
		urlBox.TextColor3 = currentPalette.text
		urlBox.Font = Enum.Font.Code
		urlBox.TextSize = 12
		urlBox.TextXAlignment = Enum.TextXAlignment.Left
		urlBox.ClearTextOnFocus = false
		urlBox.Parent = urlRow
		addThemed("element", urlBox)
		addThemed("text", urlBox)
		UI.corner(urlBox, 10)
		UI.stroke(urlBox, 0.6, 1)
		UI.padding(urlBox, 10, 8, 0, 0)
		UI.focusFX(urlBox)

		local loadBtn = UI.button({
			Name = "LoadButton", Parent = urlRow,
			Size = UDim2.fromOffset(100, 28), Position = UDim2.new(1, -114, 0.5, -14),
			BackgroundTransparency = 0.1, Text = "Загрузить", TextSize = 12,
			ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans, Corner = 10,
		})
		UI.basicHover(loadBtn, 0.1, 0.03, 0.6, 0.08)
		loadBtn.MouseButton1Click:Connect(function()
			local url = trim(urlBox.Text)
			if url == "" then
				log("Вставь ссылку на скрипт.")
				return
			end
			loadBtn.Text = "Загрузка..."
			playSound("click")
			task.spawn(function()
				executeScriptFromURL("Свой скрипт", url)
				if loadBtn and loadBtn.Parent then loadBtn.Text = "Загрузить" end
			end)
		end)

		-- Подсказка
		local hintRow = UI.row(list, 4, 30)
		UI.button({
			Name = "HintLabel", Parent = hintRow,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Ссылка должна быть прямой (raw). Пример: raw.githubusercontent.com/.../source",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 11,
			Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans,
		})
	end

	TabBuilders.Teleports = function(page)
		local list = UI.createScrollArea(page)
		local lookTeleportEnabled = false

		-- Точки по умолчанию
		local teleportPoints = {
			{Name = "Спавн", Position = Vector3.new(1, -8, 0)},
			{Name = "Ферма", Position = Vector3.new(-182, 59, -271)},
			{Name = "Синий дом", Position = Vector3.new(494, 83, -351)},
			{Name = "Жёлтый дом", Position = Vector3.new(536, 123, -93)},
			{Name = "Остров", Position = Vector3.new(82, 346, 355)},
			{Name = "Большой дом", Position = Vector3.new(-273, 80, 307)},
			{Name = "Зелёный дом", Position = Vector3.new(-539, -8, 75)},
			{Name = "Розовый дом", Position = Vector3.new(-483, -8, -150)},
			{Name = "Заброшенный дом", Position = Vector3.new(271, -8, 444)},
			{Name = "Клиф", Position = Vector3.new(355, -8, -473)},
			{Name = "Малый Клиф", Position = Vector3.new(386, -8, 335)},
			{Name = "Пляж", Position = Vector3.new(-659, -8, -57)},
			{Name = "Малая пещера", Position = Vector3.new(-5, 19, -281)},
			{Name = "Шахта", Position = Vector3.new(-370, -8, 181)},
			{Name = "Вершина горы", Position = Vector3.new(-436, 230, 529)},
			{Name = "Большая пещера", Position = Vector3.new(-96, -8, 563)},
			{Name = "Пещера 3", Position = Vector3.new(579, 101, -178)},
		}

		local function teleportTo(pos)
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
				playSound("success", 0.4)
			end
		end

		local function teleportToLook()
			local cam = workspace.CurrentCamera
			local rp = RaycastParams.new()
			rp.FilterDescendantsInstances = {player.Character}
			rp.FilterType = Enum.RaycastFilterType.Exclude
			local res = workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * 500, rp)
			if res then
				teleportTo(res.Position)
			else
				log("Смотри на поверхность.")
			end
		end

		UserInputService.InputBegan:Connect(function(input, gp)
			if gp then return end
			if lookTeleportEnabled and input.KeyCode == Enum.KeyCode.V then
				teleportToLook()
			end
		end)

		-- Заголовок
		local headerRow = UI.row(list, 1, 30)
		UI.button({
			Name = "TPHeader", Parent = headerRow,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Телепорты",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 15,
			Active = false, ThemeText = "text", Font = Enum.Font.GothamBold,
		})

		-- Запись своей точки
		local recRow = UI.row(list, 2, 48)
		local nameBox = Instance.new("TextBox")
		nameBox.Name = "TPNameBox"
		nameBox.Size = UDim2.new(1, -126, 1, -12)
		nameBox.Position = UDim2.new(0, 12, 0, 6)
		nameBox.BackgroundColor3 = currentPalette.element
		nameBox.BackgroundTransparency = 0.1
		nameBox.BorderSizePixel = 0
		nameBox.Text = ""
		nameBox.PlaceholderText = "Имя точки..."
		nameBox.PlaceholderColor3 = currentPalette.sub
		nameBox.TextColor3 = currentPalette.text
		nameBox.Font = Enum.Font.SourceSans
		nameBox.TextSize = 13
		nameBox.TextXAlignment = Enum.TextXAlignment.Left
		nameBox.ClearTextOnFocus = false
		nameBox.Parent = recRow
		addThemed("element", nameBox)
		addThemed("text", nameBox)
		UI.corner(nameBox, 10)
		UI.stroke(nameBox, 0.6, 1)
		UI.padding(nameBox, 10, 8, 0, 0)
		UI.focusFX(nameBox)

		local recBtn = UI.button({
			Name = "RecordButton", Parent = recRow,
			Size = UDim2.fromOffset(100, 28), Position = UDim2.new(1, -114, 0.5, -14),
			BackgroundTransparency = 0.1, Text = "📍 Записать", TextSize = 12,
			ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans, Corner = 10,
		})
		UI.basicHover(recBtn, 0.1, 0.03, 0.6, 0.08)

		-- Тумблер: телепорт по взгляду
		UI.createToggle(list, "Телепорт куда смотришь (бинд V)", false, function(state)
			lookTeleportEnabled = state
			log("Телепорт по взгляду: " .. (state and "включён" or "выключен"))
		end, 3)

		-- Заголовок списка точек
		local pointsHeader = UI.row(list, 4, 24)
		UI.button({
			Name = "PointsHeader", Parent = pointsHeader,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Точки:",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12,
			Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans,
		})

		-- Строка точки
		local orderCounter = 10
		local function makePointRow(p)
			local row = UI.row(list, orderCounter, 42)
			orderCounter = orderCounter + 1
			UI.basicHover(row, 0.1, 0.08, 0.75, 0.25)
			UI.button({
				Name = "TPLabel", Parent = row,
				Size = UDim2.new(1, -110, 1, 0), Position = UDim2.new(0, 14, 0, 0),
				BackgroundTransparency = 1, Stroke = false,
				Text = string.format("%s  •  %.0f, %.0f, %.0f", p.Name, p.Position.X, p.Position.Y, p.Position.Z),
				TextXAlignment = Enum.TextXAlignment.Left, TextSize = 13,
				Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
			})
			local tpBtn = UI.button({
				Name = "TPButton", Parent = row,
				Size = UDim2.fromOffset(84, 26), Position = UDim2.new(1, -96, 0.5, -13),
				BackgroundTransparency = 0.1, Text = "Телепорт", TextSize = 12,
				ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans, Corner = 10,
			})
			UI.basicHover(tpBtn, 0.1, 0.03, 0.6, 0.08)
			tpBtn.MouseButton1Click:Connect(function()
				teleportTo(p.Position)
				log("Телепорт: " .. p.Name)
			end)
			return row
		end

		-- Кнопка «Записать»: сохраняет свою точку
		recBtn.MouseButton1Click:Connect(function()
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not root then
				log("Нет персонажа!")
				return
			end
			local nm = trim(nameBox.Text)
			if nm == "" then nm = "Точка " .. (#teleportPoints + 1) end
			local p = {Name = nm, Position = root.Position}
			table.insert(teleportPoints, p)
			makePointRow(p)
			nameBox.Text = ""
			log("Точка записана: " .. nm)
			playSound("success", 0.4)
		end)

		-- Точки по умолчанию (17)
		for _, p in ipairs(teleportPoints) do
			makePointRow(p)
		end
	end

	-- ============================================================
	-- МОДУЛЬ: ПРИЦЕЛ + КАСТОМНЫЙ КУРСОР
	-- ============================================================
	local aimState = {
		crosshairEnabled = getFeature("Crosshair") == true,
		crosshairDot = getFeature("CrosshairDot") ~= false,
		crosshairCircle = getFeature("CrosshairCircle") == true,
		crosshairSize = getFeature("CrosshairSize") or 26,
		crosshairTransparency = (getFeature("CrosshairTransparency") or 15) / 100,
	}

	-- ---------- ПРИЦЕЛ (центр экрана) ----------
	local crosshairGui = Instance.new("ScreenGui")
	crosshairGui.Name = "FosforCrosshairGui"
	crosshairGui.ResetOnSpawn = false
	crosshairGui.IgnoreGuiInset = true
	crosshairGui.DisplayOrder = 997 -- выше игры, но ниже окна Fosfor (999)
	crosshairGui.Enabled = false
	crosshairGui.Parent = playerGui

	local crossParts = {}

	local function newCrossPart(name, isCircle)
		local f = Instance.new("Frame")
		f.Name = name
		f.AnchorPoint = Vector2.new(0.5, 0.5)
		f.Position = UDim2.new(0.5, 0, 0.5, 0)
		f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		f.BorderSizePixel = 0
		f.ZIndex = 1
		f.Parent = crosshairGui
		if isCircle then
			f.BackgroundTransparency = 1
			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(1, 0)
			c.Parent = f
			local st = Instance.new("UIStroke")
			st.Thickness = 1.5
			st.Color = Color3.fromRGB(255, 255, 255)
			st.Parent = f
			crossParts[name] = {frame = f, stroke = st}
		else
			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(0, 2)
			c.Parent = f
			crossParts[name] = {frame = f}
		end
		return f
	end

	newCrossPart("Dot", false)
	newCrossPart("LineTop", false)
	newCrossPart("LineBottom", false)
	newCrossPart("LineLeft", false)
	newCrossPart("LineRight", false)
	newCrossPart("Circle", true)

	local function applyCrosshair()
		crosshairGui.Enabled = aimState.crosshairEnabled
		if not aimState.crosshairEnabled then return end
		local s = aimState.crosshairSize
		local tr = aimState.crosshairTransparency
		local thick = 2
		local len = math.max(4, math.floor(s * 0.38))
		local gap = math.max(3, math.floor(s * 0.16))
		local off = gap + len / 2

		crossParts.Dot.frame.Size = UDim2.fromOffset(4, 4)
		crossParts.Dot.frame.Visible = aimState.crosshairDot
		crossParts.Dot.frame.BackgroundTransparency = tr

		crossParts.LineTop.frame.Size = UDim2.fromOffset(thick, len)
		crossParts.LineTop.frame.Position = UDim2.new(0.5, 0, 0.5, -off)
		crossParts.LineTop.frame.BackgroundTransparency = tr
		crossParts.LineBottom.frame.Size = UDim2.fromOffset(thick, len)
		crossParts.LineBottom.frame.Position = UDim2.new(0.5, 0, 0.5, off)
		crossParts.LineBottom.frame.BackgroundTransparency = tr
		crossParts.LineLeft.frame.Size = UDim2.fromOffset(len, thick)
		crossParts.LineLeft.frame.Position = UDim2.new(0.5, -off, 0.5, 0)
		crossParts.LineLeft.frame.BackgroundTransparency = tr
		crossParts.LineRight.frame.Size = UDim2.fromOffset(len, thick)
		crossParts.LineRight.frame.Position = UDim2.new(0.5, off, 0.5, 0)
		crossParts.LineRight.frame.BackgroundTransparency = tr

		crossParts.Circle.frame.Size = UDim2.fromOffset(s, s)
		crossParts.Circle.frame.Visible = aimState.crosshairCircle
		crossParts.Circle.stroke.Transparency = tr
	end

	-- очистка при выгрузке скрипта
	if gui then
		gui.Destroying:Connect(function()
			pcall(function() crosshairGui:Destroy() end)
		end)
	end

	applyCrosshair()

	-- ============================================================
	-- МОДУЛЬ: PVP (матч + засчитывание + HUD)
	-- ============================================================
	local PVP = {}
	do
	PVP.state = "idle"
	PVP.opponent = nil
	PVP.locationLabel = ""
	PVP.targetScore = 5
	PVP.countSS, PVP.countAS, PVP.countDB = true, true, true
	PVP.scoreMe, PVP.scoreOpp = 0, 0
	PVP.startTime, PVP.endTime = 0, 0
	PVP.ssY = -50
	PVP.myGrabOnOpp, PVP.oppGrabOnMe = -999, -999
	PVP.recentKillMe, PVP.recentKillOpp = -999, -999
	PVP.deathMe, PVP.deathOpp = -999, -999
	PVP.agMe, PVP.agOpp = 0, 0
	PVP.asCdMe, PVP.asCdOpp = -999, -999

	local KILL_WINDOW, DB_WINDOW, SIM_WINDOW, OWN_RECENT = 5, 3, 1, 3

	local function pvpLog(msg)
		if addConsoleLine then addConsoleLine("⚔️ PVP: " .. msg, "info") end
	end

	-- ---------- HUD ----------
	local hud = {built = false, shown = false}

	local function hudShow()
		if not hud.root then return end
		hud.root.Visible = true
		hud.root.GroupTransparency = 1
		hud.root.Position = UDim2.new(0.5, -280, 0, -140)
		Animations.tween(hud.root, {Position = UDim2.new(0.5, -280, 0, 54), GroupTransparency = 0}, 0.45)
	end

	local function hudHide(instant)
		if not hud.root then return end
		if instant then hud.root.Visible = false return end
		Animations.tweenCompleted(hud.root, {Position = UDim2.new(0.5, -280, 0, -140), GroupTransparency = 1}, 0.35, function()
			hud.root.Visible = false
		end)
	end

	local function hudScore(side)
		local p = (side == "me") and hud.me or hud.opp
		if not p then return end
		p.lbl.Text = tostring((side == "me") and PVP.scoreMe or PVP.scoreOpp)
		p.scale.Scale = 1.3
		Animations.tween(p.scale, {Scale = 1}, 0.25)
	end

	local function hudFinish(winner)
		if hud.time then hud.time.Text = formatTime(PVP.endTime - PVP.startTime) end
		if hud.result then
			hud.result.Text = (winner == "me") and "Вы выиграли" or "Вы проиграли"
			hud.result.TextColor3 = (winner == "me") and Color3.fromRGB(90, 255, 120) or Color3.fromRGB(255, 90, 90)
			Animations.tween(hud.result, {TextTransparency = 0}, 0.4)
			task.delay(4, function()
				if hud.result then Animations.tween(hud.result, {TextTransparency = 1}, 0.6) end
			end)
		end
		local wp = (winner == "me") and hud.me or hud.opp
		if wp then
			task.spawn(function()
				local t0 = tick()
				while PVP.state == "finished" and tick() - t0 < 6 and wp.stroke and wp.stroke.Parent do
					Animations.tween(wp.stroke, {Transparency = 0, Color = Color3.fromRGB(90, 255, 120)}, 0.4)
					task.wait(0.45)
					Animations.tween(wp.stroke, {Transparency = 0.55, Color = Color3.fromRGB(90, 255, 120)}, 0.4)
					task.wait(0.45)
				end
			end)
		end
	end

	local function hudBuild()
		if hud.built then return end
		hud.built = true
		local root = Instance.new("CanvasGroup")
		root.Name = "PvpHud"
		root.Size = UDim2.fromOffset(560, 130)
		root.Position = UDim2.new(0.5, -280, 0, -140)
		root.BackgroundTransparency = 1
		root.GroupTransparency = 1
		root.Visible = false
		root.ZIndex = 400
		root.Parent = gui
		hud.root = root

		local function mkLabel(name, w, h, x, y, size, font, anchorX)
			local l = Instance.new("TextLabel")
			l.Name = name
			l.Size = UDim2.fromOffset(w, h)
			l.Position = UDim2.new(0.5, x, 0, y)
			l.AnchorPoint = Vector2.new(anchorX or 0.5, 0)
			l.BackgroundTransparency = 1
			l.TextColor3 = currentPalette.text
			l.Font = font or Enum.Font.GothamBold
			l.TextSize = size or 14
			l.ZIndex = 401
			l.Parent = root
			return l
		end

		hud.time = mkLabel("Time", 140, 16, 0, 0, 13, Enum.Font.SourceSans)
		hud.dash = mkLabel("Dash", 140, 26, 0, 18, 20)
		hud.dash.Text = "—"
		hud.loc = mkLabel("Loc", 300, 14, 0, 46, 11, Enum.Font.SourceSans)
		hud.loc.TextColor3 = currentPalette.sub
		hud.result = mkLabel("Result", 300, 22, 0, 102, 16)
		hud.result.TextTransparency = 1

		local function makePlate(side)
			local right = (side == "opp")
			local plate = Instance.new("Frame")
			plate.Name = "Plate_" .. side
			plate.AnchorPoint = Vector2.new(right and 0 or 1, 0)
			plate.Position = UDim2.new(0.5, right and 150 or -150, 0, 12)
			plate.Size = UDim2.new(0, 90, 0, 52)
			plate.AutomaticSize = Enum.AutomaticSize.X
			plate.BackgroundColor3 = currentPalette.panel
			plate.BackgroundTransparency = 0.1
			plate.BorderSizePixel = 0
			plate.ZIndex = 401
			plate.Parent = root
			UI.corner(plate, 12)
			local st = UI.stroke(plate, 0.35, 2)
			local pad = Instance.new("UIPadding")
			pad.PaddingLeft = UDim.new(0, 18)
			pad.PaddingRight = UDim.new(0, 18)
			pad.Parent = plate
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0, 0, 1, 0)
			lbl.AutomaticSize = Enum.AutomaticSize.X
			lbl.BackgroundTransparency = 1
			lbl.Text = "0"
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 28
			lbl.TextColor3 = currentPalette.text
			lbl.Parent = plate
			local sc = Instance.new("UIScale")
			sc.Parent = plate
			return {plate = plate, lbl = lbl, stroke = st, scale = sc}
		end
		hud.me = makePlate("me")
		hud.opp = makePlate("opp")

		local function makeAvatar(side)
			local right = (side == "opp")
			local a = Instance.new("ImageLabel")
			a.Name = "Avatar_" .. side
			a.Size = UDim2.fromOffset(48, 48)
			a.AnchorPoint = Vector2.new(right and 0 or 1, 0)
			a.Position = UDim2.new(0.5, right and 252 or -252, 0, 14)
			a.BackgroundTransparency = 1
			a.ZIndex = 401
			a.Parent = root
			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(1, 0)
			c.Parent = a
			return a
		end
		hud.avMe = makeAvatar("me")
		hud.avOpp = makeAvatar("opp")

		hud.nameMe = mkLabel("NameMe", 220, 30, -150, 68, 11, Enum.Font.SourceSans, 1)
		hud.nameMe.TextXAlignment = Enum.TextXAlignment.Right
		hud.nameMe.TextColor3 = currentPalette.sub
		hud.nameOpp = mkLabel("NameOpp", 220, 30, 150, 68, 11, Enum.Font.SourceSans, 0)
		hud.nameOpp.TextXAlignment = Enum.TextXAlignment.Left
		hud.nameOpp.TextColor3 = currentPalette.sub
	end

	-- видимость: только когда окно ЗАКРЫТО
	task.spawn(function()
		while true do
			task.wait(0.2)
			local should = hud.built and (PVP.state == "live" or PVP.state == "finished") and not uiOpen
			if should and not hud.shown then hud.shown = true hudShow() end
			if not should and hud.shown then hud.shown = false hudHide(false) end
		end
	end)

	local function pvpDetectSea(loc)
		PVP.ssY = -50
		if not loc or typeof(loc) ~= "Vector3" then
			pvpLog("море: координаты недоступны, СС при Y ≤ -50")
			return
		end
		pcall(function()
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			local filterList = {}
			if player and player.Character then
				table.insert(filterList, player.Character)
			end
			if PVP.opponent and PVP.opponent.Character then
				table.insert(filterList, PVP.opponent.Character)
			end
			params.FilterDescendantsInstances = filterList
			local res = workspace:Raycast(Vector3.new(loc.X, 400, loc.Z), Vector3.new(0, -900, 0), params)
			if res then
				PVP.ssY = math.min(res.Position.Y - 8, -20)
				pvpLog(string.format("море рядом: (%.0f, %.0f, %.0f) → СС при Y ≤ %.0f", res.Position.X, res.Position.Y, res.Position.Z, PVP.ssY))
			else
				pvpLog("море: не найдено, СС при Y ≤ -50")
			end
		end)
	end

	-- ---------- владение (PartOwner) ----------
	local pvpConns = {}
	local function pvpClearConns()
		for _, c in ipairs(pvpConns) do pcall(function() c:Disconnect() end) end
		pvpConns = {}
	end

	local function pvpWatchChar(char, isMe)
		local c = char.DescendantAdded:Connect(function(d)
			if d.Name ~= "PartOwner" then return end
			task.spawn(function()
				local v = d.Value
				if v == "" then task.wait(0.2) v = d.Value end
				local now = tick()
				if isMe and PVP.opponent and v == PVP.opponent.Name then
					PVP.oppGrabOnMe = now
				elseif not isMe and v == player.Name then
					PVP.myGrabOnOpp = now
				end
			end)
		end)
		table.insert(pvpConns, c)
	end

	-- ---------- начисление ----------
	function PVP.award(side, reason)
		if PVP.state ~= "live" then return end
		if reason == "ss" and not PVP.countSS then return end
		if reason == "as" and not PVP.countAS then return end
		if reason == "db" and not PVP.countDB then return end
		if side == "me" then
			PVP.scoreMe = PVP.scoreMe + 1
		else
			PVP.scoreOpp = PVP.scoreOpp + 1
		end
		if reason == "kill" then
			if side == "me" then
				PVP.recentKillMe = tick()
				playSound("error", 0.5) -- колокольчик
				if notify then notify("🎯 Килл: +1") end
			else
				PVP.recentKillOpp = tick()
			end
		end
		pvpLog(string.format("%s +1 (%s) → %d:%d", side == "me" and "ТЕБЕ" or "СОПЕРНИКУ", reason, PVP.scoreMe, PVP.scoreOpp))
		hudScore(side)
		if PVP.scoreMe >= PVP.targetScore then
			PVP.finish("me")
		elseif PVP.scoreOpp >= PVP.targetScore then
			PVP.finish("opp")
		end
	end

	-- ---------- смерти ----------
	local function pvpOnDeath(who, root)
		if PVP.state ~= "live" then return end
		local now = tick()
		local other = (who == "me") and "opp" or "me"
		local pos = root and root.Position or Vector3.new(0, -999, 0)
		local ownedByOther = (who == "me") and (now - PVP.oppGrabOnMe <= KILL_WINDOW)
			or (who == "opp") and (now - PVP.myGrabOnOpp <= KILL_WINDOW)
		local killed = false
		if ownedByOther then
			killed = true
			PVP.award(other, "kill")
		end
		if PVP.countDB then
			local selfRecent = (who == "me") and (now - PVP.recentKillMe <= DB_WINDOW)
				or (who == "opp") and (now - PVP.recentKillOpp <= DB_WINDOW)
			local otherDeath = (other == "me") and PVP.deathMe or PVP.deathOpp
			local simultaneous = (now - otherDeath) <= SIM_WINDOW
			if selfRecent or simultaneous then
				PVP.award("me", "db")
				PVP.award("opp", "db")
			end
		end
		if not killed and PVP.countSS then
			local markOnWho = (who == "me") and PVP.oppGrabOnMe or PVP.myGrabOnOpp
			local ownedRecently = (now - markOnWho) <= OWN_RECENT
			if pos.Y <= PVP.ssY and not ownedRecently then
				PVP.award(other, "ss")
			end
		end
		if who == "me" then PVP.deathMe = now else PVP.deathOpp = now end
	end

	local function pvpHookDeaths()
		local function hookChar(char, who)
			local hum = char:WaitForChild("Humanoid", 5)
			if not hum then return end
			local c = hum.Died:Connect(function()
				pvpOnDeath(who, char:FindFirstChild("HumanoidRootPart"))
			end)
			table.insert(pvpConns, c)
			pvpWatchChar(char, who == "me")
		end
		if player.Character then hookChar(player.Character, "me") end
		table.insert(pvpConns, player.CharacterAdded:Connect(function(ch) hookChar(ch, "me") end))
		if PVP.opponent then
			if PVP.opponent.Character then hookChar(PVP.opponent.Character, "opp") end
			table.insert(pvpConns, PVP.opponent.CharacterAdded:Connect(function(ch) hookChar(ch, "opp") end))
		end
	end

	-- ---------- АС (хаотичный полёт после владения) ----------
	local asConn = nil
	local asSamples = {me = 0, opp = 0}
	local function startASsampler()
		if asConn then return end
		asConn = RunService.Heartbeat:Connect(function()
			if PVP.state ~= "live" then return end
			local now = tick()
			local sides = {
				{who = "me", char = player.Character, mark = PVP.oppGrabOnMe, cd = PVP.asCdMe, setcd = function(v) PVP.asCdMe = v end},
				{who = "opp", char = PVP.opponent and PVP.opponent.Character, mark = PVP.myGrabOnOpp, cd = PVP.asCdOpp, setcd = function(v) PVP.asCdOpp = v end},
			}
			for _, s in ipairs(sides) do
				local root = s.char and s.char:FindFirstChild("HumanoidRootPart")
				local hum = s.char and s.char:FindFirstChildOfClass("Humanoid")
				if root and hum and not hum.SeatPart then
					local v = root.AssemblyLinearVelocity.Magnitude
					local chaotic = v > 200 or (hum:GetState() == Enum.HumanoidStateType.Freefall and v > 120)
					asSamples[s.who] = chaotic and (asSamples[s.who] + 1) or 0
					if asSamples[s.who] >= 60 and (now - s.mark) <= 5 and (now - s.cd) > 5 then
						s.setcd(now)
						asSamples[s.who] = 0
						PVP.award(s.who == "me" and "opp" or "me", "as")
					end
				else
					asSamples[s.who] = 0
				end
			end
		end)
	end

	-- ---------- АГ (отцепы, статистика) ----------
	local function startAGwatcher()
		local c = workspace.ChildAdded:Connect(function(child)
			if child.Name ~= "GrabParts" or PVP.state ~= "live" then return end
			task.spawn(function()
				local t0 = tick()
				local drag = child:FindFirstChild("DragPart")
				local mine = false
				pcall(function()
					local cam = workspace.CurrentCamera
					if drag and cam and drag:IsA("BasePart") then
						mine = (drag.Position - cam.CFrame.Position).Magnitude < 20
					end
				end)
				local gp = child:WaitForChild("GrabPart", 2)
				local weld = gp and gp:FindFirstChild("WeldConstraint")
				local part = weld and weld.Part1
				local myChar = player.Character
				local opChar = PVP.opponent and PVP.opponent.Character
				local involves = part and ((myChar and part:IsDescendantOf(myChar)) or (opChar and part:IsDescendantOf(opChar)))
				if not involves then return end
				while child.Parent do task.wait(0.05) end
				if tick() - t0 < 0.5 then
					if mine then PVP.agMe = PVP.agMe + 1 else PVP.agOpp = PVP.agOpp + 1 end
					pvpLog("АГ (отцеп): " .. (mine and "ты" or "соперник"))
				end
			end)
		end)
		table.insert(pvpConns, c)
	end

	-- ---------- финиш ----------
	function PVP.finish(winner, byLeave)
		if PVP.state ~= "live" then return end
		PVP.state = "finished"
		PVP.endTime = tick()
		hudFinish(winner)
		pvpLog(string.format("МАТЧ ОКОНЧЕН: %s • счёт %d:%d • время %s • АГ ты/он: %d/%d%s",
			winner == "me" and "ТЫ ВЫИГРАЛ" or "ТЫ ПРОИГРАЛ",
			PVP.scoreMe, PVP.scoreOpp,
			formatTime(PVP.endTime - PVP.startTime),
			PVP.agMe, PVP.agOpp,
			byLeave and " • соперник вышел" or ""))
		task.delay(6, function()
			PVP.state = "idle"
			hudHide(true)
			pvpClearConns()
		end)
	end

	-- авто-вин, если соперник вышел
	Players.PlayerRemoving:Connect(function(pl)
		if PVP.state == "live" and PVP.opponent and pl == PVP.opponent then
			pvpLog("соперник вышел с сервера")
			PVP.finish("me", true)
		end
	end)

	-- ---------- старт ----------
	function PVP.start(cfg)
		if PVP.state == "live" then pvpLog("матч уже идёт") return end
		PVP.state = "live"
		PVP.opponent = cfg.opponent
		PVP.locationLabel = cfg.locationLabel
		PVP.targetScore = cfg.targetScore
		PVP.countSS, PVP.countAS, PVP.countDB = cfg.countSS, cfg.countAS, cfg.countDB
		PVP.scoreMe, PVP.scoreOpp = 0, 0
		PVP.startTime, PVP.endTime = tick(), 0
		PVP.myGrabOnOpp, PVP.oppGrabOnMe = -999, -999
		PVP.recentKillMe, PVP.recentKillOpp = -999, -999
		PVP.deathMe, PVP.deathOpp = -999, -999
		PVP.agMe, PVP.agOpp = 0, 0
		pvpClearConns()
		local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		local basePos = cfg.teleportPos or (myRoot and myRoot.Position) or Vector3.new(0, 0, 0)
		pvpDetectSea(basePos)
		if cfg.teleportPos then
			local currentRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if currentRoot then
				pcall(function()
					currentRoot.CFrame = CFrame.new(cfg.teleportPos + Vector3.new(0, 3, 0))
				end)
			else
				pvpLog("телепорт пропущен: нет персонажа")
			end
		end
		pvpHookDeaths()
		startAGwatcher()
		startASsampler()
		hudBuild()
		if hud.me then hud.me.lbl.Text = "0" hud.me.scale.Scale = 1 end
		if hud.opp then hud.opp.lbl.Text = "0" hud.opp.scale.Scale = 1 end
		if hud.loc then hud.loc.Text = PVP.locationLabel end
		if hud.nameMe then hud.nameMe.Text = player.DisplayName .. "\n@" .. player.Name end
		if hud.nameOpp then hud.nameOpp.Text = PVP.opponent.DisplayName .. "\n@" .. PVP.opponent.Name end
		pcall(function()
			hud.avMe.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		end)
		pcall(function()
			hud.avOpp.Image = Players:GetUserThumbnailAsync(PVP.opponent.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		end)
		task.spawn(function()
			while PVP.state == "live" do
				if hud.time then hud.time.Text = formatTime(tick() - PVP.startTime) end
				task.wait(0.25)
			end
		end)
		pvpLog(string.format("матч начат: против %s • %s • до %d", PVP.opponent.Name, PVP.locationLabel, PVP.targetScore))
		if notify then notify("⚔️ PVP против " .. PVP.opponent.Name .. " начат") end
	end


	end
	-- ============================================================
	-- ВКЛАДКА PVP 
	-- ============================================================
	TabBuilders.PVP = function(page)
		local list = UI.createScrollArea(page)

		local headerRow = UI.row(list, 1, 30)
		UI.button({
			Name = "PvpHeader", Parent = headerRow,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "PVP Матч",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 15,
			Active = false, ThemeText = "text", Font = Enum.Font.GothamBold,
		})

		local cfg = {
			opponent = nil,
			locKey = nil,
			locLabel = "",
			teleportPos = nil,
			targetScore = 5,
			countSS = true, countAS = true, countDB = true,
			ready = false,
		}

		-- ---------- кнопка регистрации ----------
		local regRow = UI.row(list, 2, 42)
		local regBtn = UI.button({
			Name = "RegisterBtn", Parent = regRow,
			Size = UDim2.new(1, -24, 1, -10), Position = UDim2.new(0, 12, 0.5, -14),
			BackgroundTransparency = 0.1, Text = "🏟 Зарегистрировать PVP", TextSize = 13,
			ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSansBold, Corner = 10,
		})
		UI.basicHover(regBtn, 0.1, 0.03, 0.6, 0.08)

		-- ---------- контейнер настройки ----------
		local setupFrame = Instance.new("Frame")
		setupFrame.Name = "Setup"
		setupFrame.Size = UDim2.new(1, 0, 0, 0)
		setupFrame.AutomaticSize = Enum.AutomaticSize.Y
		setupFrame.BackgroundTransparency = 1
		setupFrame.LayoutOrder = 3
		setupFrame.Visible = false
		setupFrame.Parent = list
		local setupLayout = Instance.new("UIListLayout")
		setupLayout.Padding = UDim.new(0, 8)
		setupLayout.SortOrder = Enum.SortOrder.LayoutOrder
		setupLayout.Parent = setupFrame

		local function sRow(order, height)
			local r = Instance.new("Frame")
			r.Size = UDim2.new(1, 0, 0, height or 38)
			r.BackgroundColor3 = currentPalette.element
			r.BackgroundTransparency = 0.1
			r.BorderSizePixel = 0
			r.LayoutOrder = order
			r.Parent = setupFrame
			addThemed("element", r)
			UI.corner(r, 14)
			UI.stroke(r, 0.75, 1)
			return r
		end

		local function highlight(btn, on)
			local st = btn:FindFirstChildOfClass("UIStroke")
			if st then st.Transparency = on and 0.1 or 0.7 end
			btn.BackgroundTransparency = on and 0 and 0 or (on and 0.02 or 0.15)
		end

		-- ---------- выбор противника ----------
		local oppHeader = sRow(1, 26)
		UI.button({
			Name = "OppHeader", Parent = oppHeader,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "👥 Противник (выбери одного)",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12,
			Active = false, ThemeText = "sub", Font = Enum.Font.SourceSansBold,
		})

		local oppScroll = Instance.new("ScrollingFrame")
		oppScroll.Name = "OppScroll"
		oppScroll.Size = UDim2.new(1, 0, 0, 150)
		oppScroll.BackgroundTransparency = 1
		oppScroll.BorderSizePixel = 0
		oppScroll.ScrollBarThickness = 3
		oppScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		oppScroll.LayoutOrder = 2
		oppScroll.Parent = setupFrame
		local oppList = Instance.new("Frame")
		oppList.Size = UDim2.new(1, 0, 0, 0)
		oppList.AutomaticSize = Enum.AutomaticSize.Y
		oppList.BackgroundTransparency = 1
		oppList.Parent = oppScroll
		local oppLayout = Instance.new("UIListLayout")
		oppLayout.Padding = UDim.new(0, 4)
		oppLayout.SortOrder = Enum.SortOrder.LayoutOrder
		oppLayout.Parent = oppList
		local oppPad = Instance.new("UIPadding")
		oppPad.PaddingLeft = UDim.new(0, 4)
		oppPad.PaddingRight = UDim.new(0, 4)
		oppPad.PaddingTop = UDim.new(0, 4)
		oppPad.PaddingBottom = UDim.new(0, 4)
		oppPad.Parent = oppScroll
		oppLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			oppScroll.CanvasSize = UDim2.new(0, 0, 0, oppLayout.AbsoluteContentSize.Y + 8)
		end)

		local oppSelBtn = nil
		local function rebuildOpponents()
			for _, c in ipairs(oppList:GetChildren()) do
				if c:IsA("TextButton") then c:Destroy() end
			end
			oppSelBtn = nil
			local i = 0
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= player then
					i = i + 1
					local row = Instance.new("TextButton")
					row.Name = "Opp_" .. plr.Name
					row.Size = UDim2.new(1, 0, 0, 34)
					row.BackgroundColor3 = currentPalette.element
					row.BackgroundTransparency = 0.15
					row.BorderSizePixel = 0
					row.Text = ""
					row.AutoButtonColor = false
					row.LayoutOrder = i
					row.Parent = oppList
					UI.corner(row, 10)
					UI.stroke(row, 0.7, 1)
					local n1 = Instance.new("TextLabel")
					n1.Size = UDim2.new(1, -16, 0, 18)
					n1.Position = UDim2.new(0, 10, 0, 3)
					n1.BackgroundTransparency = 1
					n1.Text = plr.DisplayName
					n1.TextXAlignment = Enum.TextXAlignment.Left
					n1.TextSize = 13
					n1.Font = Enum.Font.SourceSansBold
					n1.TextColor3 = currentPalette.text
					n1.Parent = row
					local n2 = Instance.new("TextLabel")
					n2.Size = UDim2.new(1, -16, 0, 13)
					n2.Position = UDim2.new(0, 10, 0, 19)
					n2.BackgroundTransparency = 1
					n2.Text = "@" .. plr.Name
					n2.TextXAlignment = Enum.TextXAlignment.Left
					n2.TextSize = 10
					n2.Font = Enum.Font.SourceSans
					n2.TextColor3 = currentPalette.sub
					n2.Parent = row
					row.MouseButton1Click:Connect(function()
						cfg.opponent = plr
						cfg.ready = false
						if oppSelBtn then highlight(oppSelBtn, false) end
						oppSelBtn = row
						highlight(row, true)
						playSound("click")
					end)
				end
			end
		end

		-- ---------- выбор места ----------
		local locHeader = sRow(3, 26)
		UI.button({
			Name = "LocHeader", Parent = locHeader,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "🗺 Место матча",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12,
			Active = false, ThemeText = "sub", Font = Enum.Font.SourceSansBold,
		})

		local locRowF = sRow(4, 40)
		local locLayout = Instance.new("UIListLayout")
		locLayout.FillDirection = Enum.FillDirection.Horizontal
		locLayout.Padding = UDim.new(0, 6)
		locLayout.SortOrder = Enum.SortOrder.LayoutOrder
		locLayout.Parent = locRowF
		local locPad = Instance.new("UIPadding")
		locPad.PaddingLeft = UDim.new(0, 8)
		locPad.PaddingRight = UDim.new(0, 8)
		locPad.PaddingTop = UDim.new(0, 6)
		locPad.PaddingBottom = UDim.new(0, 6)
		locPad.Parent = locRowF

		local LOCATIONS = {
			{key = "Beach", label = "Пляж", pos = Vector3.new(-659, -8, -57)},
			{key = "Cliff", label = "Клиф", pos = Vector3.new(355, -8, -473)},
			{key = "SmallCliff", label = "Малый клиф", pos = Vector3.new(386, -8, 335)},
			{key = "Map", label = "Вся карта", pos = Vector3.new(1, -8, 0)},
			{key = "Other", label = "Другое", pos = nil},
		}
		local locSelBtn = nil
		for idx, loc in ipairs(LOCATIONS) do
			local b = UI.button({
				Name = "Loc_" .. loc.key, Parent = locRowF,
				Size = UDim2.new(1 / 5, -6, 1, 0),
				BackgroundTransparency = 0.15, Text = loc.label, TextSize = 11,
				ThemeBackground = "element", ThemeText = "text",
				Font = Enum.Font.SourceSans, Corner = 9,
			})
			b.LayoutOrder = idx
			b.MouseButton1Click:Connect(function()
				cfg.locKey = loc.key
				cfg.locLabel = (loc.key == "Other") and "Своё место" or loc.label
				cfg.teleportPos = loc.pos
				cfg.ready = false
				if locSelBtn then highlight(locSelBtn, false) end
				locSelBtn = b
				highlight(b, true)
				playSound("click")
			end)
		end

		-- ---------- правила ----------
		UI.createSlider(setupFrame, {
			Label = "До скольки баллов", Min = 1, Max = 15, Value = 5, Order = 5,
			Callback = function(v)
				cfg.targetScore = math.floor(v + 0.5)
				cfg.ready = false
			end,
		})
		UI.createToggle(setupFrame, "Считается СС (себя убил → балл сопернику)", true, function(s) cfg.countSS = s cfg.ready = false end, 6)
		UI.createToggle(setupFrame, "Считается АС (лаг/флинг → балл сопернику)", true, function(s) cfg.countAS = s cfg.ready = false end, 7)
		UI.createToggle(setupFrame, "Считается ДБ (дабл → балл каждому)", true, function(s) cfg.countDB = s cfg.ready = false end, 8)

		-- ---------- готово / начать ----------
		local actRow = sRow(9, 42)
		local readyBtn = UI.button({
			Name = "ReadyBtn", Parent = actRow,
			Size = UDim2.new(0.5, -18, 1, -10), Position = UDim2.new(0, 12, 0.5, -14),
			BackgroundTransparency = 0.1, Text = "✔ Готово", TextSize = 13,
			ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSansBold, Corner = 10,
		})
		UI.basicHover(readyBtn, 0.1, 0.03, 0.6, 0.08)
		local startBtn = UI.button({
			Name = "StartBtn", Parent = actRow,
			Size = UDim2.new(0.5, -18, 1, -10), Position = UDim2.new(0.5, 6, 0.5, -14),
			BackgroundColor3 = Color3.fromRGB(70, 140, 80), BackgroundTransparency = 0.3,
			Text = "▶ Начать", TextSize = 13,
			ThemeText = "text", Font = Enum.Font.SourceSansBold, Corner = 10,
		})
		UI.basicHover(startBtn, 0.1, 0.03, 0.6, 0.08)

		readyBtn.MouseButton1Click:Connect(function()
			if not cfg.opponent then
				log("Выбери противника") playSound("error", 0.4) return
			end
			if not cfg.locKey then
				log("Выбери место матча") playSound("error", 0.4) return
			end
			cfg.ready = true
			startBtn.BackgroundTransparency = 0.05
			playSound("success", 0.4)
			log(string.format("Готово: против %s • %s • до %d", cfg.opponent.Name, cfg.locLabel, cfg.targetScore))
		end)

		startBtn.MouseButton1Click:Connect(function()
			if not cfg.ready then
				log("Сначала нажми Готово") playSound("error", 0.4) return
			end
			if not cfg.opponent or not Players:FindFirstChild(cfg.opponent.Name) then
				log("Соперник недоступен — выбери другого") cfg.ready = false return
			end
			playSound("success", 0.5)
			PVP.start({
				opponent = cfg.opponent,
				locationLabel = cfg.locLabel,
				teleportPos = cfg.teleportPos,
				targetScore = cfg.targetScore,
				countSS = cfg.countSS,
				countAS = cfg.countAS,
				countDB = cfg.countDB,
			})
			cfg.ready = false
			startBtn.BackgroundTransparency = 0.3
		end)

		-- ---------- открытие настройки + обновление списка ----------
		regBtn.MouseButton1Click:Connect(function()
			setupFrame.Visible = not setupFrame.Visible
			if setupFrame.Visible then rebuildOpponents() end
			playSound("click")
		end)

		Players.PlayerAdded:Connect(function()
			if setupFrame.Visible then rebuildOpponents() end
		end)
		Players.PlayerRemoving:Connect(function(pl)
			if cfg.opponent == pl then
				cfg.opponent = nil
				cfg.ready = false
				startBtn.BackgroundTransparency = 0.3
				log("Соперник вышел — выбери другого")
			end
			if setupFrame.Visible then rebuildOpponents() end
		end)
	end

	TabBuilders.Target = function(page)
		local list = UI.createScrollArea(page)

		local headerRow = UI.row(list, 1, 30)
		UI.button({
			Name = "TargetHeader", Parent = headerRow,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Прицел",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 15,
			Active = false, ThemeText = "text", Font = Enum.Font.GothamBold,
		})

		UI.createToggle(list, "Прицел (центр экрана)", aimState.crosshairEnabled, function(state)
			aimState.crosshairEnabled = state
			setFeature("Crosshair", state)
			applyCrosshair()
			log("Прицел: " .. (state and "включён" or "выключен"))
		end, 2)

		UI.createToggle(list, "Точка в центре", aimState.crosshairDot, function(state)
			aimState.crosshairDot = state
			setFeature("CrosshairDot", state)
			applyCrosshair()
		end, 3)

		UI.createToggle(list, "Круг вокруг", aimState.crosshairCircle, function(state)
			aimState.crosshairCircle = state
			setFeature("CrosshairCircle", state)
			applyCrosshair()
		end, 4)

		UI.createSlider(list, {Label = "Размер прицела", Min = 12, Max = 64, Value = aimState.crosshairSize, Order = 5, Callback = function(value)
			aimState.crosshairSize = math.floor(value + 0.5)
			setFeature("CrosshairSize", aimState.crosshairSize)
			applyCrosshair()
		end})

		UI.createSlider(list, {Label = "Прозрачность прицела %", Min = 0, Max = 90, Value = math.floor(aimState.crosshairTransparency * 100), Order = 6, Callback = function(value)
			aimState.crosshairTransparency = value / 100
			setFeature("CrosshairTransparency", value)
			applyCrosshair()
		end})
	end

-- ============================================================
-- МОДУЛЬ: РАБОЧИЕ ФУНКЦИИ ВКЛАДКИ РАЗНОЕ
-- ============================================================
local Misc = {}

Misc.state = {
	fullbrightSaved = nil,
	antiAFKConnection = nil,
	fpsUnlockerActive = false,
}

local VirtualUser = nil
pcall(function()
	VirtualUser = game:GetService("VirtualUser")
end)

local function miscTrySetFpsCap(value)
	local success = false

	pcall(function()
		if typeof(setfpscap) == "function" then
			setfpscap(value)
			success = true
			return
		end

		if FeatureEnv and typeof(FeatureEnv.setfpscap) == "function" then
			FeatureEnv.setfpscap(value)
			success = true
			return
		end

		if _G and typeof(_G.setfpscap) == "function" then
			_G.setfpscap(value)
			success = true
			return
		end
	end)

	if success then return true end

	local targetCap = nil
	pcall(function()
		targetCap = Enum.FramerateCap.Fixed60
		if value >= 240 then
			targetCap = Enum.FramerateCap.Fixed240
		end
	end)

	if not targetCap then
		return false
	end

	pcall(function()
		if settings then
			local render = settings().Rendering
			if render then
				render.FrameRateCap = targetCap
				success = true
			end
		end
	end)

	if success then return true end

	pcall(function()
		if settings then
			local render = settings().Rendering
			if render then
				render.FramerateCap = targetCap
				success = true
			end
		end
	end)

	return success
end

function Misc.applyFullbright(state)
	if state then
		if not Misc.state.fullbrightSaved then
			Misc.state.fullbrightSaved = {
				Brightness = Lighting.Brightness,
				ClockTime = Lighting.ClockTime,
				Ambient = Lighting.Ambient,
				OutdoorAmbient = Lighting.OutdoorAmbient,
				FogEnd = Lighting.FogEnd,
				GlobalShadows = Lighting.GlobalShadows,
				ExposureCompensation = Lighting.ExposureCompensation,
			}
		end

		pcall(function()
			Lighting.Brightness = 3
			Lighting.ClockTime = 14
			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			Lighting.FogEnd = 1000000
			Lighting.GlobalShadows = false
			Lighting.ExposureCompensation = 0.25
		end)

		log("Fullbright включён")
	else
		if Misc.state.fullbrightSaved then
			for prop, value in pairs(Misc.state.fullbrightSaved) do
				pcall(function()
					Lighting[prop] = value
				end)
			end

			Misc.state.fullbrightSaved = nil
		end

		log("Fullbright выключен")
	end
end

function Misc.applyAntiAFK(state)
	if state then
		if not Misc.state.antiAFKConnection then
			pcall(function()
				Misc.state.antiAFKConnection = player.Idled:Connect(function(idleTime)
					if VirtualUser then
						pcall(function()
							VirtualUser:CaptureController()
							VirtualUser:ClickButton2(Vector2.new())
						end)
					end
				end)
			end)
		end

		log("Anti-AFK включён")
	else
		if Misc.state.antiAFKConnection then
			pcall(function()
				Misc.state.antiAFKConnection:Disconnect()
			end)

			Misc.state.antiAFKConnection = nil
		end

		log("Anti-AFK выключен")
	end
end

function Misc.applyFPSUnlocker(state)
	if state then
		local unlocked = miscTrySetFpsCap(999)
		Misc.state.fpsUnlockerActive = unlocked

		if unlocked then
			log("FPS Unlocker включён")
		else
			log("FPS Unlocker: функция недоступна в этой среде")
		end
	else
		miscTrySetFpsCap(60)
		Misc.state.fpsUnlockerActive = false
		log("FPS Unlocker выключен")
	end
end

-- Если после перезапуска скрипта функции остались включёнными, применяем их сразу
if getFeature("Fullbright") then
	Misc.applyFullbright(true)
end

if getFeature("AntiAFK") then
	Misc.applyAntiAFK(true)
end

if getFeature("FPSUnlocker") then
	Misc.applyFPSUnlocker(true)
end

	-- ============================================================
	-- МОДУЛЬ: МОТИВАЦИЯ ПРИ СМЕРТИ
	-- ============================================================
	local DEATH_PHRASES = {
		"Ты упал. Никто не поднимет тебя, кроме тебя самого.",
		"Смерть не унижает. Она просто показывает цену ошибки.",
		"Ты был медленнее. Это не обида — это факт. Стань быстрее.",
		"Земля холодная. Память долгая. Выводы — твои.",
		"Слабые остаются лежать. Сильные возвращаются.",
		"Ты не проиграл войну. Ты проиграл три секунды.",
		"Боль — это плата за опыт. Ты только что заплатил.",
		"Не оправдывайся. Оправдания не поднимают с земли.",
		"Соперник не был сильнее. Ты был невнимательнее.",
		"Каждое падение — урок, который ты не хотел учить.",
		"Ты умер. Мир не остановился. Поднимайся.",
		"Смерть — пауза, а не финал.",
		"Лежать легко. Вставать — вот что делает сильнее.",
		"Ошибка стоит жизни только тогда, когда ты её повторяешь.",
		"Ты заплатил за невнимательность самой дорогой ценой. Запомни её.",
		"Холодная земля учит лучше тёплых слов.",
		"Сегодня упал ты. В следующий раз упадёт тот, кто убил тебя.",
		"Смерть не спрашивает, готов ли ты. Будь готов.",
		"Ты не жертва обстоятельств. Ты их автор.",
		"Проигран бой, но не игра.",
		"Ты отдохнул. Хватит. Возвращайся и забери своё.",
		"Каждый, кто наверху, когда-то лежал там, где сейчас ты.",
		"Смерть — не позор. Позор — не встать.",
		"Ты проиграл один момент, а не всё.",
		"Смерть показала твою слабость. Теперь ты знаешь, где работать.",
		"Сильный не тот, кто не падает, а тот, кто встаёт быстрее.",
		"Не ной. Проанализируй. Вернись.",
		"Гравитация победила в этот раз. Счёт открыт.",
		"Ты умер с оружием в руках — значит, жил правильно.",
		"Соперник запомнил твоё имя. Сделай так, чтобы начал бояться.",
		"Ты не первый, кто упал. Стань тем, кто встал.",
		"Смерть — зеркало. Оно показало ошибку. Смотри и запоминай.",
		"Виноват не тот, кто убил, а тот, кто позволил.",
		"Ты не слабый. Ты просто ещё не сильный.",
		"Падение — не приговор. Это разминка.",
		"Смерть проверяет не тело. Она проверяет волю.",
		"Ты узнал, где твоя слабость. Это дороже одной жизни.",
		"Встань. Отряхнись. Вернись. Другого пути нет.",
		"Тот, кто боится смерти, уже проиграл. Ты — нет.",
		"Смерть — это дверь. Ты просто вошёл не с той стороны.",
	}

	local deathMotivation = {
		enabled = getFeature("DeathMotivation") == true,         
		particles = getFeature("DeathParticles") ~= false,       
		overlayFrame = nil,
		particlesFrame = nil,
		textLabel = nil,
		spawnToken = 0,
		lastPhrase = nil,
		visible = false,
	}

	local function buildDeathOverlay()
		if deathMotivation.overlayFrame then return end

		local frame = Instance.new("Frame")
		frame.Name = "DeathOverlay"
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Visible = false
		frame.ZIndex = 500
		frame.Parent = gui 

		local particles = Instance.new("Frame")
		particles.Name = "Particles"
		particles.Size = UDim2.fromScale(1, 1)
		particles.BackgroundTransparency = 1
		particles.ClipsDescendants = true
		particles.ZIndex = 501
		particles.Parent = frame

		local label = Instance.new("TextLabel")
		label.Name = "Phrase"
		label.Size = UDim2.new(0.8, 0, 0.3, 0)
		label.Position = UDim2.new(0.1, 0, 0.35, 0)
		label.BackgroundTransparency = 1
		label.Text = ""
		label.TextColor3 = Color3.fromRGB(235, 235, 235)
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 26
		label.TextWrapped = true
		label.TextTransparency = 1
		label.ZIndex = 502
		label.Parent = frame

		deathMotivation.overlayFrame = frame
		deathMotivation.particlesFrame = particles
		deathMotivation.textLabel = label
	end

	local function startDeathParticles()
		deathMotivation.spawnToken = deathMotivation.spawnToken + 1
		local token = deathMotivation.spawnToken
		local container = deathMotivation.particlesFrame
		task.spawn(function()
			while token == deathMotivation.spawnToken and deathMotivation.visible do
				local w = container.AbsoluteSize.X
				local h = container.AbsoluteSize.Y
				if w > 0 and h > 0 then
					local size = math.random(2, 5)
					local p = Instance.new("Frame")
					p.Name = "Snow"
					p.Size = UDim2.fromOffset(size, size)
					local startY = math.random(-20, math.max(h, 1))
					p.Position = UDim2.fromOffset(-10, startY)
					p.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					p.BackgroundTransparency = math.random(30, 80) / 100
					p.BorderSizePixel = 0
					p.ZIndex = 501
					local corner = Instance.new("UICorner")
					corner.CornerRadius = UDim.new(1, 0)
					corner.Parent = p
					p.Parent = container
					local drift = math.random(-160, 160) 
					local duration = math.random(45, 95) / 10 
					local tween = TweenService:Create(p, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
						Position = UDim2.fromOffset(w + 10, startY + drift),
					})
					tween.Completed:Connect(function()
						if p and p.Parent then p:Destroy() end
					end)
					tween:Play()
				end
				task.wait(0.12)
			end
		end)
	end

	local function stopDeathParticles()
		deathMotivation.spawnToken = deathMotivation.spawnToken + 1
		local container = deathMotivation.particlesFrame
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Frame") then child:Destroy() end
			end
		end
	end

	local function pickPhrase()
		local phrase
		repeat
			phrase = DEATH_PHRASES[math.random(1, #DEATH_PHRASES)]
		until phrase ~= deathMotivation.lastPhrase
		deathMotivation.lastPhrase = phrase
		return phrase
	end

	local function showDeathOverlay()
		buildDeathOverlay()
		local frame = deathMotivation.overlayFrame
		local label = deathMotivation.textLabel
		deathMotivation.visible = true
		frame.Visible = true
		frame.BackgroundTransparency = 1
		label.TextTransparency = 1
		label.Text = pickPhrase()
		Animations.tween(frame, {BackgroundTransparency = 0}, 0.5)   
		Animations.tween(label, {TextTransparency = 0.05}, 0.9)
		if deathMotivation.particles then
			startDeathParticles()
		end
	end

	local function hideDeathOverlay(fast)
		deathMotivation.visible = false
		stopDeathParticles()
		local frame = deathMotivation.overlayFrame
		local label = deathMotivation.textLabel
		if not frame then return end
		if label then label.TextTransparency = 1 end
		Animations.tweenCompleted(frame, {BackgroundTransparency = 1}, fast and 0 or 0.4, function()
			frame.Visible = false
		end)
	end

	local function hookDeathMotivation(char)
		local hum = char:WaitForChild("Humanoid", 5)
		if not hum then return end
		hum.Died:Connect(function()
			if not deathMotivation.enabled then return end
			showDeathOverlay()
		end)
	end

	if player.Character then hookDeathMotivation(player.Character) end
	player.CharacterAdded:Connect(function(char)
		hideDeathOverlay(false) -- респаун → плавно убираем экран
		hookDeathMotivation(char)
	end)

	-- ============================================================
	-- МОДУЛЬ: АВТО-СПАВН ПАЛЕТКИ ПО БИНДУ
	-- ============================================================
	local palletBind = {
		key = nil,
		listening = false,
	}

	local savedBind = getFeature("PalletSpawnBind")
	if type(savedBind) == "string" and savedBind ~= "" then
		pcall(function() palletBind.key = Enum.KeyCode[savedBind] end)
	end

	local function spawnPalletInstant()
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not root then
			log("Нет персонажа — палетка не заспавнена")
			return
		end
		local rs = game:GetService("ReplicatedStorage")
		local mt = rs:FindFirstChild("MenuToys")
		local spawnRF = mt and mt:FindFirstChild("SpawnToyRemoteFunction")
		if not spawnRF then
			log("SpawnToyRemoteFunction не найден")
			return
		end
		playSound("click")
		task.spawn(function()
			pcall(function()
				spawnRF:InvokeServer(
					"PalletLightBrown",
					root.CFrame * CFrame.new(0, 2, 0),
					Vector3.zero
				)
			end)
		end)
		log("Палетка заспавнена")
	end

	-- глобальный хук: работает даже при скрытом окне
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if palletBind.listening then return end
		if gameProcessed then return end
		if UserInputService:GetFocusedTextBox() then return end -- не срабатывает при вводе текста
		if palletBind.key and input.KeyCode == palletBind.key then
			spawnPalletInstant()
		end
	end)

	-- ============================================================
	-- HUD-ПЛАШКИ (время ИРЛ / время сервера)
	-- ============================================================
	local hudPlaques = {
		enabled = false,
		built = false,
		container = nil,
		panels = {},
	}

	local function updateHudPlaques()
	if not hudPlaques.container then return end
	local p = hudPlaques.panels
	if p.irl then p.irl.label.Text = os.date("%H:%M:%S") end
	if p.server then p.server.label.Text = formatTime(workspace.DistributedGameTime) end
end

	local function buildHudPlaques()
		if hudPlaques.built then return end
		hudPlaques.built = true

		local container = Instance.new("Frame")
		container.Name = "HudPlaques"
		container.AnchorPoint = Vector2.new(0.5, 1)
		container.Position = UDim2.new(0.5, 0, 1, 60)
		container.Size = UDim2.new(0, 0, 0, 40)
		container.AutomaticSize = Enum.AutomaticSize.X
		container.BackgroundTransparency = 1
		container.ZIndex = 100
		container.Active = false
		container.Parent = gui

		local layout = Instance.new("UIListLayout")
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.Padding = UDim.new(0, 8)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.Parent = container

		local items = {
			{key = "irl", order = 1},   
			{key = "server", order = 2}, 
		}
	for _, item in ipairs(items) do
		local panel = Instance.new("Frame")
		panel.Name = item.key
		panel.Size = UDim2.new(0, 0, 1, 0)
		panel.AutomaticSize = Enum.AutomaticSize.X
		panel.BackgroundColor3 = currentPalette.panel
		panel.BackgroundTransparency = 0.1
		panel.BorderSizePixel = 0
		panel.LayoutOrder = item.order
		panel.ZIndex = 100
		panel.Parent = container
		UI.corner(panel, 14)
		UI.stroke(panel, 0.35, 1.5)
		UI.gradient(panel, 90)
		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 16)
		pad.PaddingRight = UDim.new(0, 16)
		pad.Parent = panel
		addThemed("panel", panel)

		local lbl = Instance.new("TextLabel")
		lbl.Name = "Text"
		lbl.Size = UDim2.fromScale(1, 1)
		lbl.BackgroundTransparency = 1
		lbl.Text = "--:--:--"
		lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 16
		lbl.TextColor3 = currentPalette.text
		lbl.ZIndex = 101
		lbl.Parent = panel
		addThemed("text", lbl)

		hudPlaques.panels[item.key] = {frame = panel, label = lbl}
	end

		hudPlaques.container = container
	end

	local function showHudPlaques()
		buildHudPlaques()
		if not hudPlaques.container then return end
		updateHudPlaques()
		local c = hudPlaques.container
		c.Visible = true
		c.Position = UDim2.new(0.5, 0, 1, 60)
		for _, p in pairs(hudPlaques.panels) do
			p.frame.BackgroundTransparency = 0.7
			p.label.TextTransparency = 1
		end
		Animations.tween(c, {Position = UDim2.new(0.5, 0, 1, -16)}, 0.45)
		for _, p in pairs(hudPlaques.panels) do
			Animations.tween(p.frame, {BackgroundTransparency = 0.1}, 0.45)
			Animations.tween(p.label, {TextTransparency = 0}, 0.45)
		end
	end

	local function hideHudPlaques()
	if not hudPlaques.container then return end
	local c = hudPlaques.container
	Animations.tween(c, {Position = UDim2.new(0.5, 0, 1, 60)}, 0.35)
	for _, p in pairs(hudPlaques.panels) do
		Animations.tween(p, {BackgroundTransparency = 0.7, TextTransparency = 1}, 0.35)
	end
	task.delay(0.4, function()
		if hudPlaques.container and not hudPlaques.enabled then
			hudPlaques.container.Visible = false
		end
	end)
end
	-- обновление раз в секунду
	task.spawn(function()
		while true do
			task.wait(1)
			if hudPlaques.enabled and hudPlaques.container and hudPlaques.container.Visible then
				updateHudPlaques()
			end
		end
	end)

TabBuilders.Misc = function(page)
	local list = UI.createScrollArea(page)

	UI.createToggle(list, "Fullbright", getFeature("Fullbright"), function(state)
		setFeature("Fullbright", state)
		Misc.applyFullbright(state)
	end, 1)

	UI.createToggle(list, "Anti-AFK", getFeature("AntiAFK"), function(state)
		setFeature("AntiAFK", state)
		Misc.applyAntiAFK(state)
	end, 2)

	UI.createToggle(list, "FPS Unlocker", getFeature("FPSUnlocker"), function(state)
		setFeature("FPSUnlocker", state)
		Misc.applyFPSUnlocker(state)
	end, 3)

    UI.createToggle(list, "Мотивация при смерти", deathMotivation.enabled, function(state)
	deathMotivation.enabled = state
	setFeature("DeathMotivation", state)
	log("Мотивация при смерти: " .. (state and "включена" or "выключена"))
	if not state then hideDeathOverlay(true) end
	end, 4)

	UI.createToggle(list, "Снежные частицы на экране смерти", deathMotivation.particles, function(state)
		deathMotivation.particles = state
		setFeature("DeathParticles", state)
		log("Частицы на экране смерти: " .. (state and "включены" or "выключены"))
	end, 5)
	UI.createToggle(list, "Учёт грабов и убийств", grabStats.enabled, function(state)
		grabStats.enabled = state
		log("Учёт грабов: " .. (state and "включён" or "выключен"))
	end, 6)
	--  авто-спавн палетки по бинду
	local palletRow = UI.row(list, 10, 42)
	UI.button({
		Name = "PalletLabel", Parent = palletRow,
		Size = UDim2.new(1, -160, 1, 0), Position = UDim2.new(0, 14, 0, 0),
		BackgroundTransparency = 1, Stroke = false,
		Text = "Авто-спавн палетки (бинд)",
		TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
		Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
	})
	local palletBindBtn = UI.button({
		Name = "PalletBindBtn", Parent = palletRow,
		Size = UDim2.fromOffset(90, 28), Position = UDim2.new(1, -144, 0.5, -14),
		BackgroundTransparency = 0.1,
		Text = palletBind.key and palletBind.key.Name or "Нет клавиши",
		TextSize = 12, ThemeBackground = "element", ThemeText = "text",
		Font = Enum.Font.SourceSans, Corner = 10,
	})
	UI.basicHover(palletBindBtn, 0.1, 0.03, 0.6, 0.08)
	local palletClearBtn = UI.button({
		Name = "PalletClearBtn", Parent = palletRow,
		Size = UDim2.fromOffset(40, 28), Position = UDim2.new(1, -50, 0.5, -14),
		BackgroundTransparency = 0.1, Text = "✖", TextSize = 12,
		ThemeBackground = "element", ThemeText = "text",
		Font = Enum.Font.SourceSans, Corner = 10,
	})
	UI.basicHover(palletClearBtn, 0.1, 0.03, 0.6, 0.08)

	local palletListenConn = nil
	palletBindBtn.MouseButton1Click:Connect(function()
		if palletBind.listening then return end
		palletBind.listening = true
		palletBindBtn.Text = "Нажми клавишу…"
		playSound("click")
		palletListenConn = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if input.KeyCode == Enum.KeyCode.Escape then -- Escape = отмена
				palletBind.listening = false
				palletBindBtn.Text = palletBind.key and palletBind.key.Name or "Нет клавиши"
				if palletListenConn then palletListenConn:Disconnect() palletListenConn = nil end
				return
			end
			palletBind.key = input.KeyCode
			setFeature("PalletSpawnBind", input.KeyCode.Name)
			palletBindBtn.Text = input.KeyCode.Name
			palletBind.listening = false
			if palletListenConn then palletListenConn:Disconnect() palletListenConn = nil end
			playSound("success", 0.4)
			log("Бинд палетки: " .. input.KeyCode.Name)
		end)
		-- таймаут 5 сек, если клавишу не нажали
		task.delay(5, function()
			if palletBind.listening then
				palletBind.listening = false
				palletBindBtn.Text = palletBind.key and palletBind.key.Name or "Нет клавиши"
				if palletListenConn then palletListenConn:Disconnect() palletListenConn = nil end
			end
		end)
	end)

	palletClearBtn.MouseButton1Click:Connect(function()
		palletBind.key = nil
		setFeature("PalletSpawnBind", "")
		palletBindBtn.Text = "Нет клавиши"
		playSound("toggle")
		log("Бинд палетки сброшен")
	end)

	UI.createToggle(list, "HUD-плашки (время/сервер)", false, function(state)
		hudPlaques.enabled = state
		if state then
			showHudPlaques()
			log("HUD-плашки включены")
		else
			hideHudPlaques()
			log("HUD-плашки выключены")
		end
	end, 11)
end
	-- ============================================================
	-- ВКЛАДКА "???" — ПОИСК АНОМАЛИЙ
	-- ============================================================
	local phantomState = {
		active = false,
		connection = nil,
		lastFound = {},
		scanCount = 0,
		lastClockTime = nil,
		clockTimeChangeCount = 0,
	}

	local framePositions = {}
	local teleportFlags = {}

	local function trackTeleports()
		for _, plr in ipairs(Players:GetPlayers()) do
			local char = plr.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				local prev = framePositions[plr.UserId]
				if prev and prev.char == char then
					local delta = (root.Position - prev.pos).Magnitude
					if delta > 100 then
						teleportFlags[plr.UserId] = {
							yJump = math.abs(root.Position.Y - prev.pos.Y),
							time = tick()
						}
					end
				end
				framePositions[plr.UserId] = {pos = root.Position, char = char}
			else
				framePositions[plr.UserId] = nil
			end
		end
	end

	local function checkForPhantom(plr)
		if plr == Players.LocalPlayer then return false end
		local character = plr.Character
		if not character then return false end
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not rootPart or not humanoid then return false end

		local reasons = {}
		local currentPos = rootPart.Position

		local isSuspiciousName = false
		local suspiciousNames = {
			"__blackout__", "phantom", "observer", "watcher", "spectator",
			"anomaly", "glitch", "null", "void", "ghost", "shadow",
			"admin_watcher", "mod_spectate", "hidden_eye"
		}
		local lowerName = string.lower(plr.Name)
		for _, suspicious in ipairs(suspiciousNames) do
			if string.find(lowerName, suspicious, 1, true) then
				isSuspiciousName = true
				table.insert(reasons, "подозрительное имя")
				break
			end
		end

		local tf = teleportFlags[plr.UserId]
		local teleported = tf and (tick() - tf.time) < 10
		if teleported then
			table.insert(reasons, string.format("мгновенный телепорт (+%.0f Y)", tf.yJump))
			teleportFlags[plr.UserId] = nil
		end

		local highAlt = currentPos.Y > 500
		if highAlt then
			table.insert(reasons, "аномальная высота: " .. math.floor(currentPos.Y))
		end

		local airHang = (currentPos.Y > 20)
			and rootPart.AssemblyLinearVelocity.Magnitude < 0.5
			and not humanoid.PlatformStand
			and not humanoid.SeatPart
			and humanoid.Health > 0
		if airHang then
			table.insert(reasons, "висит в воздухе без ragdoll")
		end

		local isPhantom = isSuspiciousName
			or (teleported and highAlt)
			or (teleported and airHang)

		return isPhantom, #reasons, reasons
	end

	local phantomMarkers = {}

	local function visualizePhantom(plr, position)
		local markers = {}

		local ok1, highlight = pcall(function()
			local h = Instance.new("Highlight")
			h.Name = "FosforPhantomMarker"
			h.FillColor = Color3.fromRGB(255, 50, 50)
			h.OutlineColor = Color3.fromRGB(255, 0, 0)
			h.FillTransparency = 0.7
			h.OutlineTransparency = 0
			h.Parent = plr.Character
			return h
		end)
		if ok1 and highlight then table.insert(markers, highlight) end

		local head = plr.Character and (plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart"))
		if head then
			local ok2, billboard = pcall(function()
				local bg = Instance.new("BillboardGui")
				bg.Name = "FosforPhantomTag"
				bg.Size = UDim2.fromOffset(120, 24)
				bg.StudsOffset = Vector3.new(0, 3, 0)
				bg.AlwaysOnTop = true
				bg.Parent = head
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.fromScale(1, 1)
				lbl.BackgroundTransparency = 1
				lbl.Text = "⚠️ АНОМАЛИЯ"
				lbl.TextColor3 = Color3.fromRGB(255, 50, 50)
				lbl.TextStrokeTransparency = 0
				lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
				lbl.Font = Enum.Font.GothamBold
				lbl.TextSize = 14
				lbl.Parent = bg
				return bg
			end)
			if ok2 and billboard then table.insert(markers, billboard) end
		end

		local ok3, markerPart = pcall(function()
			local mp = Instance.new("Part")
			mp.Name = "FosforPhantomPoint"
			mp.Size = Vector3.new(2, 2, 2)
			mp.Position = position
			mp.Anchored = true
			mp.CanCollide = false
			mp.Material = Enum.Material.Neon
			mp.Color = Color3.fromRGB(255, 50, 50)
			mp.Transparency = 0.3
			mp.Shape = Enum.PartType.Ball
			mp.Parent = workspace
			return mp
		end)
		if ok3 and markerPart then table.insert(markers, markerPart) end

		for _, m in ipairs(markers) do
			table.insert(phantomMarkers, m)
		end

		task.delay(30, function()
			for _, m in ipairs(markers) do
				pcall(function() if m and m.Parent then m:Destroy() end end)
			end
		end)
	end

	local function clearPhantomMarkers()
		for _, marker in ipairs(phantomMarkers) do
			pcall(function() if marker and marker.Parent then marker:Destroy() end end)
		end
		phantomMarkers = {}
	end

	local function trackTimeChanges()
		local currentClock = Lighting.ClockTime
		if phantomState.lastClockTime ~= nil then
			local delta = math.abs(currentClock - phantomState.lastClockTime)
			if delta > 2 then
				phantomState.clockTimeChangeCount = phantomState.clockTimeChangeCount + 1
				if addConsoleLine then
					addConsoleLine("🕒 Время изменилось на " .. string.format("%.1f", delta) .. " ч", "info")
				end
				if notify then notify("⚠️ Время изменилось!") end
				if playSound then playSound("error", 0.45) end
			end
		end
		phantomState.lastClockTime = currentClock
	end

	local function scanForPhantoms()
		phantomState.scanCount = phantomState.scanCount + 1
		local found = 0
		for _, plr in ipairs(Players:GetPlayers()) do
			local isPhantom, score, reasons = checkForPhantom(plr)
			if isPhantom and not phantomState.lastFound[plr.UserId] then
				phantomState.lastFound[plr.UserId] = tick()
				found = found + 1

				local pos = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.HumanoidRootPart.Position
				local posText = pos and string.format("(%.0f, %.0f, %.0f)", pos.X, pos.Y, pos.Z) or "?"

				local msg = string.format("🔍 Аномалия: %s [%d] %s — %s", plr.Name, score, posText, table.concat(reasons, ", "))
				if addConsoleLine then addConsoleLine(msg, "info") end
				if notify then notify("⚠️ " .. plr.Name .. " — " .. posText) end
				if playSound then playSound("error", 0.45) end

				if pos then
					visualizePhantom(plr, pos)
				end
			end
		end

		if found == 0 and phantomState.scanCount % 6 == 0 then
			if addConsoleLine then addConsoleLine("🔍 Сканирование... (" .. #Players:GetPlayers() .. " игроков)", "sub") end
		end

		local now = tick()
		for uid, lastTime in pairs(phantomState.lastFound) do
			if now - lastTime > 120 then
				phantomState.lastFound[uid] = nil
			end
		end
	end

	local function startPhantomSearch()
		if phantomState.connection then return end
		phantomState.active = true
		phantomState.scanCount = 0
		phantomState.lastFound = {}
		phantomState.lastClockTime = Lighting.ClockTime
		phantomState.clockTimeChangeCount = 0
		framePositions = {}
		teleportFlags = {}

		if addConsoleLine then addConsoleLine("🔍 Поиск аномалий запущен...", "info") end
		if notify then notify("Поиск аномалий активирован") end
		if playSound then playSound("success", 0.5) end

		local lastScanTime = 0
		phantomState.connection = RunService.Heartbeat:Connect(function()
			if not phantomState.active then return end
			trackTeleports()
			trackTimeChanges()
			local now = tick()
			if now - lastScanTime >= 5 then
				lastScanTime = now
				task.spawn(scanForPhantoms)
			end
		end)
	end

	local function stopPhantomSearch()
		phantomState.active = false
		if phantomState.connection then
			phantomState.connection:Disconnect()
			phantomState.connection = nil
		end
		clearPhantomMarkers()
		if addConsoleLine then addConsoleLine("🔍 Поиск аномалий остановлен", "sub") end
		if notify then notify("Поиск остановлен") end
	end

	TabBuilders.Phantom = function(page)
		local list = UI.createScrollArea(page)

		local headerRow = UI.row(list, 1, 30)
		UI.button({
			Name = "Header", Parent = headerRow,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "🔍 Поиск Наблюдателей",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 15,
			Active = false, ThemeText = "text", Font = Enum.Font.GothamBold,
		})

		local searchToggle = UI.createToggle(list, "Начать поиск", false, function(state)
			if state then
				startPhantomSearch()
			else
				stopPhantomSearch()
			end
		end, 2)

		local statusRow = UI.row(list, 3, 42)
		local statusLabel = UI.button({
			Name = "StatusLabel", Parent = statusRow,
			Size = UDim2.new(1, -28, 0, 18), Position = UDim2.new(0, 14, 0, 6),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Статус: Ожидание...",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 13,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local statusValue = UI.button({
			Name = "StatusValue", Parent = statusRow,
			Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, 24),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Сканирований: 0  •  Найдено: 0  •  Смен времени: 0",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 11,
			Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans,
		})

		task.spawn(function()
			while page and page.Parent do
				if phantomState.active then
					statusLabel.Text = "Статус: 🔍 Активен"
					local foundCount = 0
					for _ in pairs(phantomState.lastFound) do foundCount = foundCount + 1 end
					statusValue.Text = string.format("Сканирований: %d  •  Найдено: %d  •  Смен времени: %d",
						phantomState.scanCount, foundCount, phantomState.clockTimeChangeCount)
				else
					statusLabel.Text = "Статус: Ожидание..."
				end
				task.wait(1)
			end
		end)

		local manualRow = UI.row(list, 4, 42)
		UI.button({
			Name = "ManualLabel", Parent = manualRow,
			Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "🎯 Ручное сканирование",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local manualBtn = UI.button({
			Name = "ManualButton", Parent = manualRow,
			Size = UDim2.fromOffset(100, 28), Position = UDim2.new(1, -114, 0.5, -14),
			BackgroundTransparency = 0.1, Text = "Сканировать", TextSize = 12,
			ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans, Corner = 10,
		})
		UI.basicHover(manualBtn, 0.1, 0.03, 0.6, 0.08)
		manualBtn.MouseButton1Click:Connect(function()
			scanForPhantoms()
			log("Ручное сканирование выполнено")
		end)

		local testRow = UI.row(list, 5, 42)
		UI.button({
			Name = "TestLabel", Parent = testRow,
			Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "🧪 Тест детектора (симуляция)",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local testBtn = UI.button({
			Name = "TestButton", Parent = testRow,
			Size = UDim2.fromOffset(100, 28), Position = UDim2.new(1, -114, 0.5, -14),
			BackgroundTransparency = 0.1, Text = "Тест", TextSize = 12,
			ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans, Corner = 10,
		})
		UI.basicHover(testBtn, 0.1, 0.03, 0.6, 0.08)
		testBtn.MouseButton1Click:Connect(function()
			local me = Players.LocalPlayer
			local root = me.Character and me.Character:FindFirstChild("HumanoidRootPart")
			local pos = root and root.Position or Vector3.new(0, 0, 0)
			if addConsoleLine then addConsoleLine("🧪 ТЕСТ: симуляция обнаружения", "info") end
			if notify then notify("⚠️ ТЕСТ: " .. me.Name) end
			if playSound then playSound("error", 0.45) end
			visualizePhantom(me, pos)
		end)

		local hintRow = UI.row(list, 6, 36)
		UI.button({
			Name = "HintIcon", Parent = hintRow,
			Size = UDim2.fromOffset(22, 22), Position = UDim2.new(0, 10, 0.5, -11),
			BackgroundTransparency = 0.15, Text = "?",
			Font = Enum.Font.GothamBold, TextSize = 14,
			ThemeBackground = "element", ThemeText = "text", Corner = 11,
		})
		local hintLabel = UI.button({
			Name = "HintLabel", Parent = hintRow,
			Size = UDim2.new(1, -44, 1, 0), Position = UDim2.new(0, 40, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Ищет фантомов: не падают, телепортируются, меняют время",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12,
			Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans,
		})
		hintLabel.TextTransparency = 1
		hintRow.MouseEnter:Connect(function()
			Animations.tween(hintLabel, {TextTransparency = 0}, 0.2)
		end)
		hintRow.MouseLeave:Connect(function()
			Animations.tween(hintLabel, {TextTransparency = 1}, 0.25)
		end)
	end

	-- ============================================================
	-- МОДУЛЬ: ВРЕМЯ В ИГРЕ
	-- ============================================================
	local playtimeState = {
		start = tick(),
		saved = 0,
		source = "session",
	}

	local function playtimeFormat(sec)
		sec = math.floor(sec or 0)
		local h = math.floor(sec / 3600)
		local m = math.floor((sec % 3600) / 60)
		if h > 0 then
			return h .. " ч " .. m .. " мин"
		end
		return m .. " мин " .. (sec % 60) .. " сек"
	end

	local function playtimeTotal()
		return playtimeState.saved + (tick() - playtimeState.start)
	end

	do
		local got = nil
		pcall(function()
			local ls = player:FindFirstChild("leaderstats")
			if ls then
				for _, stat in ipairs(ls:GetChildren()) do
					local lower = string.lower(stat.Name)
					if (lower:find("time") or lower:find("play") or lower:find("час")) and typeof(stat.Value) == "number" then
						got = stat.Value
					end
				end
			end
			if not got then
				for name, value in pairs(player:GetAttributes()) do
					local lower = string.lower(tostring(name))
					if type(value) == "number" and (lower:find("time") or lower:find("play")) then
						got = value
					end
				end
			end
		end)
		if got then
			playtimeState.saved = got
			playtimeState.source = "game"
		else
			pcall(function()
				if typeof(readfile) == "function" and typeof(isfile) == "function" and isfile("FosforPlaytime.txt") then
					playtimeState.saved = tonumber(readfile("FosforPlaytime.txt")) or 0
					playtimeState.source = "fosfor"
				end
			end)
		end
	end

	local function playtimeSave()
		if playtimeState.source == "game" then return end
		pcall(function()
			if typeof(writefile) == "function" then
				writefile("FosforPlaytime.txt", tostring(math.floor(playtimeTotal())))
			end
		end)
	end

	task.spawn(function()
		while task.wait(30) do
			playtimeSave()
		end
	end)
	if gui then
		gui.Destroying:Connect(playtimeSave)
	end

	-- ============================================================
	-- МОДУЛЬ: ОЦЕНКА ВРЕМЕНИ ПО БАЛАНСУ МОНЕТ
	-- ============================================================

	local function estimateHoursFromCoins(coins)
		return coins / 400
	end

	local function formatEstimate(hours)
		if hours >= 1 then
			return math.floor(hours) .. " ч " .. math.floor((hours % 1) * 60) .. " мин"
		end
		return math.floor(hours * 60) .. " мин"
	end

	TabBuilders.Settings = function(page)
		local list = UI.createScrollArea(page)
		local themeRow = UI.row(list, 1, 38)
		UI.basicHover(themeRow, 0.1, 0.08, 0.75, 0.3)
		UI.button({Name = "ThemeLabel", Parent = themeRow, Size = UDim2.new(1, -220, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1, Stroke = false, Text = "Тема оформления", TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14, Active = false, ThemeText = "text", Font = Enum.Font.SourceSans})
		local darkThemeButton = UI.button({Name = "DarkThemeButton", Parent = themeRow, Size = UDim2.fromOffset(84, 26), Position = UDim2.new(1, -190, 0.5, -13), Text = "Тёмная", TextSize = 13, BackgroundTransparency = 0.1, ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans})
		local lightThemeButton = UI.button({Name = "LightThemeButton", Parent = themeRow, Size = UDim2.fromOffset(84, 26), Position = UDim2.new(1, -98, 0.5, -13), Text = "Светлая", TextSize = 13, BackgroundTransparency = 0.1, ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans})
		themeButtons = {["Тёмная"] = darkThemeButton, ["Светлая"] = lightThemeButton}
		updateThemeButtons = function()
			for themeName, button in pairs(themeButtons) do
				if settings.Theme == themeName then
					button.BackgroundColor3 = currentPalette.text
					button.TextColor3 = currentPalette.bg
					button.BackgroundTransparency = 0
				else
					button.BackgroundColor3 = currentPalette.element
					button.TextColor3 = currentPalette.text
					button.BackgroundTransparency = 0.1
				end
			end
		end
		darkThemeButton.MouseButton1Click:Connect(function() if setTheme then setTheme("Тёмная") end end)
		lightThemeButton.MouseButton1Click:Connect(function() if setTheme then setTheme("Светлая") end end)
		updateThemeButtons()
		UI.createSlider(list, {Label = "Прозрачность окна", Min = 0, Max = 100, Value = math.floor(settings.WindowTransparency * 100), Order = 2, Callback = function(value) setWindowTransparency(value / 100) end})
		UI.createToggle(list, "Звуки", settings.Sounds, function(state) settings.Sounds = state log("Звуки: " .. (state and "включены" or "выключены")) end, 3)
		UI.createToggle(list, "Анимации", settings.Animations, function(state) settings.Animations = state log("Анимации: " .. (state and "включены" or "выключены")) end, 4)
		local playtimeRow = UI.row(list, 10, 36)
		local playtimeLabel = UI.button({
			Name = "PlaytimeLabel", Parent = playtimeRow,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Считаем время...",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12,
			Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans,
		})
		task.spawn(function()
			while page and page.Parent do
				local src = ""
				if playtimeState.source == "game" then
					src = "  •  данные игры"
				elseif playtimeState.source == "fosfor" then
					src = "  •  учёт Fosfor"
				else
					src = "  •  эта сессия"
				end
				playtimeLabel.Text = "В игре проведено: " .. playtimeFormat(playtimeTotal()) .. src
				task.wait(1)
			end
		end)
		local coinsRow = UI.row(list, 11, 36)
		local coinsLabel = UI.button({
			Name = "CoinsEstimateLabel", Parent = coinsRow,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "Считаем баланс...",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12,
			Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans,
		})
		task.spawn(function()
			task.wait(1)
			local coins = getCoinsBalance()
			coinsLabel.Text = string.format("Баланс: %d  •  ≈ %s в игре (слоты раз в 15 мин, АФК)",
				coins, formatEstimate(estimateHoursFromCoins(coins)))
		end)
	end

	-- ============================================================
	-- ВКЛАДКА ШЕЙДЕРОВ (v1.0.3)
	-- ============================================================
	local shaderState = {
		activeShader = nil,
		savedLighting = nil,
		effects = {},
		dayNightMode = false,
		eveningMorning = false,
	}

	local function shaderSaveLighting()
		shaderState.savedLighting = {
			ClockTime = Lighting.ClockTime,
			Ambient = Lighting.Ambient,
			OutdoorAmbient = Lighting.OutdoorAmbient,
			Brightness = Lighting.Brightness,
			FogColor = Lighting.FogColor,
			FogStart = Lighting.FogStart,
			FogEnd = Lighting.FogEnd,
			ExposureCompensation = Lighting.ExposureCompensation,
			ColorShift_Top = Lighting.ColorShift_Top,
			ColorShift_Bottom = Lighting.ColorShift_Bottom,
			EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
			EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
			GeographicLatitude = Lighting.GeographicLatitude,
			GlobalShadows = Lighting.GlobalShadows,
			ShadowSoftness = Lighting.ShadowSoftness,
		}
	end

	local function shaderRestoreLighting()
		if not shaderState.savedLighting then return end
		for prop, value in pairs(shaderState.savedLighting) do
			pcall(function() Lighting[prop] = value end)
		end
	end

	local function shaderRemoveEffects()
		for _, effect in ipairs(shaderState.effects) do
			pcall(function()
				if effect and effect.Parent then effect:Destroy() end
			end)
		end
		shaderState.effects = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Character then
				local hl = plr.Character:FindFirstChild("FosforVibeHighlight")
				if hl then pcall(function() hl:Destroy() end) end
			end
		end
	end

	local function shaderDeactivateAll()
		shaderRemoveEffects()
		shaderRestoreLighting()
		shaderState.activeShader = nil
	end

	local shaderPresets = {}

	shaderPresets.Desert = function()
		Lighting.ClockTime = 6.7
		Lighting.ColorShift_Bottom = Color3.new(0.043137, 0, 0.078431)
		Lighting.FogColor = Color3.new(0.368627, 0.298039, 0.415686)
		Lighting.FogEnd = 1000
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.GlobalShadows = true
		Lighting.EnvironmentSpecularScale = 0.25
		Lighting.FogStart = 0
		Lighting.GeographicLatitude = 41.735
		Lighting.Ambient = Color3.new(0.231373, 0.129412, 0.105882)
		Lighting.OutdoorAmbient = Color3.new(0.133333, 0, 0.192157)
		Lighting.ExposureCompensation = 0.24
		Lighting.Brightness = 3.5
		Lighting.ColorShift_Top = Color3.new(0.941176, 0.498039, 0.054902)
		Lighting.ShadowSoftness = 0
		local bloom = Instance.new("BloomEffect")
		bloom.Name = "FosforShader_Bloom"
		bloom.Enabled = true
		bloom.Threshold = 0
		bloom.Intensity = 0.1
		bloom.Size = 100
		bloom.Parent = Lighting
		table.insert(shaderState.effects, bloom)
		local blur = Instance.new("BlurEffect")
		blur.Name = "FosforShader_Blur"
		blur.Enabled = true
		blur.Size = 2
		blur.Parent = Lighting
		table.insert(shaderState.effects, blur)
		local cc = Instance.new("ColorCorrectionEffect")
		cc.Name = "FosforShader_CC"
		cc.Enabled = true
		cc.Saturation = 0.05
		cc.Contrast = 0
		cc.TintColor = Color3.new(1, 0.878431, 0.858824)
		cc.Brightness = 0
		cc.Parent = Lighting
		table.insert(shaderState.effects, cc)
		local sunRays = Instance.new("SunRaysEffect")
		sunRays.Name = "FosforShader_SunRays"
		sunRays.Enabled = true
		sunRays.Intensity = 0.05
		sunRays.Spread = 1
		sunRays.Parent = Lighting
		table.insert(shaderState.effects, sunRays)
		local sky = Instance.new("Sky")
		sky.Name = "FosforShader_Sky"
		sky.StarCount = 3000
		sky.SkyboxUp = "rbxassetid://323493360"
		sky.MoonTextureId = "rbxasset://sky/moon.jpg"
		sky.SkyboxDn = "rbxassetid://323494368"
		sky.SkyboxBk = "rbxassetid://323494035"
		sky.SkyboxFt = "rbxassetid://323494130"
		sky.SunTextureId = "rbxasset://sky/sun.jpg"
		sky.SunAngularSize = 14
		sky.SkyboxLf = "rbxassetid://323494252"
		sky.SkyboxRt = "rbxassetid://323494067"
		sky.MoonAngularSize = 11
		sky.Parent = Lighting
		table.insert(shaderState.effects, sky)
	end

	shaderPresets.Rainy = function()
		Lighting.ClockTime = 10
		Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
		Lighting.FogColor = Color3.new(1, 1, 1)
		Lighting.FogEnd = 100000
		Lighting.EnvironmentDiffuseScale = 0.403
		Lighting.GlobalShadows = true
		Lighting.EnvironmentSpecularScale = 0.25
		Lighting.FogStart = 0
		Lighting.GeographicLatitude = -45
		Lighting.Ambient = Color3.new(0.949, 0.953, 0.953)
		Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
		Lighting.ExposureCompensation = 0.2
		Lighting.Brightness = -0.1
		Lighting.ColorShift_Top = Color3.new(0, 0, 0)
		Lighting.ShadowSoftness = 0.2
		local sky = Instance.new("Sky")
		sky.Name = "FosforShader_Sky"
		sky.StarCount = 3000
		sky.SkyboxUp = "rbxassetid://8995814929"
		sky.MoonTextureId = "rbxasset://sky/moon.jpg"
		sky.SkyboxDn = "rbxassetid://8995686153"
		sky.SkyboxBk = "rbxassetid://8995816670"
		sky.SkyboxFt = "rbxassetid://8995816670"
		sky.SunTextureId = "rbxassetid://8923082571"
		sky.SunAngularSize = 30
		sky.SkyboxLf = "rbxassetid://8995816670"
		sky.SkyboxRt = "rbxassetid://8995816670"
		sky.MoonAngularSize = 0
		sky.Parent = Lighting
		table.insert(shaderState.effects, sky)
		local cc = Instance.new("ColorCorrectionEffect")
		cc.Name = "FosforShader_CC"
		cc.Enabled = true
		cc.Saturation = -0.3
		cc.Contrast = 0.2
		cc.TintColor = Color3.new(0.784314, 0.784314, 1)
		cc.Brightness = -0.1
		cc.Parent = Lighting
		table.insert(shaderState.effects, cc)
		local atm = Instance.new("Atmosphere")
		atm.Name = "FosforShader_Atmo"
		atm.Density = 0.564
		atm.Haze = 1.72
		atm.Color = Color3.new(0.631373, 0.647059, 0.635294)
		atm.Decay = Color3.new(0.949, 0.953, 0.953)
		atm.Glare = 0.36
		atm.Offset = 0.556
		atm.Parent = Lighting
		table.insert(shaderState.effects, atm)
		local bloom = Instance.new("BloomEffect")
		bloom.Name = "FosforShader_Bloom"
		bloom.Enabled = true
		bloom.Threshold = 0.8
		bloom.Intensity = 0.3
		bloom.Size = 10
		bloom.Parent = Lighting
		table.insert(shaderState.effects, bloom)
		local dof = Instance.new("DepthOfFieldEffect")
		dof.Name = "FosforShader_DOF"
		dof.Enabled = true
		dof.FarIntensity = 0.217
		dof.FocusDistance = 11.54
		dof.InFocusRadius = 16.77
		dof.NearIntensity = 0.277
		dof.Parent = Lighting
		table.insert(shaderState.effects, dof)
	end

	shaderPresets.Sunset = function()
		Lighting.ClockTime = 6.7
		Lighting.ColorShift_Bottom = Color3.new(0.043137, 0, 0.078431)
		Lighting.FogColor = Color3.new(0.368627, 0.298039, 0.415686)
		Lighting.FogEnd = 1000
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.GlobalShadows = true
		Lighting.EnvironmentSpecularScale = 0.25
		Lighting.FogStart = 0
		Lighting.GeographicLatitude = 41.735
		Lighting.Ambient = Color3.new(0.231373, 0.129412, 0.105882)
		Lighting.OutdoorAmbient = Color3.new(0.133333, 0, 0.192157)
		Lighting.ExposureCompensation = 0.24
		Lighting.Brightness = 3.5
		Lighting.ColorShift_Top = Color3.new(0.941176, 0.498039, 0.054902)
		Lighting.ShadowSoftness = 0
		local bloom = Instance.new("BloomEffect")
		bloom.Name = "FosforShader_Bloom"
		bloom.Enabled = true
		bloom.Threshold = 0
		bloom.Intensity = 0.1
		bloom.Size = 100
		bloom.Parent = Lighting
		table.insert(shaderState.effects, bloom)
		local blur = Instance.new("BlurEffect")
		blur.Name = "FosforShader_Blur"
		blur.Enabled = true
		blur.Size = 2
		blur.Parent = Lighting
		table.insert(shaderState.effects, blur)
		local cc = Instance.new("ColorCorrectionEffect")
		cc.Name = "FosforShader_CC"
		cc.Enabled = true
		cc.Saturation = 0.05
		cc.Contrast = 0
		cc.TintColor = Color3.new(1, 0.878431, 0.858824)
		cc.Brightness = 0
		cc.Parent = Lighting
		table.insert(shaderState.effects, cc)
		local sunRays = Instance.new("SunRaysEffect")
		sunRays.Name = "FosforShader_SunRays"
		sunRays.Enabled = true
		sunRays.Intensity = 0.05
		sunRays.Spread = 1
		sunRays.Parent = Lighting
		table.insert(shaderState.effects, sunRays)
		local sky = Instance.new("Sky")
		sky.Name = "FosforShader_Sky"
		sky.StarCount = 3000
		sky.SkyboxUp = "rbxassetid://323493360"
		sky.MoonTextureId = "rbxasset://sky/moon.jpg"
		sky.SkyboxDn = "rbxassetid://323494368"
		sky.SkyboxBk = "rbxassetid://323494035"
		sky.SkyboxFt = "rbxassetid://323494130"
		sky.SunTextureId = "rbxasset://sky/sun.jpg"
		sky.SunAngularSize = 14
		sky.SkyboxLf = "rbxassetid://323494252"
		sky.SkyboxRt = "rbxassetid://323494067"
		sky.MoonAngularSize = 11
		sky.Parent = Lighting
		table.insert(shaderState.effects, sky)
	end

	shaderPresets.Dreamy = function()
		Lighting.ClockTime = 14
		Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
		Lighting.FogColor = Color3.new(0.752941, 0.752941, 0.752941)
		Lighting.FogEnd = 100000
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.GlobalShadows = true
		Lighting.EnvironmentSpecularScale = 0.25
		Lighting.FogStart = 0
		Lighting.GeographicLatitude = 41.735
		Lighting.Ambient = Color3.new(0.470588, 0.470588, 0.470588)
		Lighting.OutdoorAmbient = Color3.new(0.784314, 0.784314, 0.784314)
		Lighting.ExposureCompensation = 0
		Lighting.Brightness = 2
		Lighting.ColorShift_Top = Color3.new(0, 0, 0)
		Lighting.ShadowSoftness = 0.2
		local sky = Instance.new("Sky")
		sky.Name = "FosforShader_Sky"
		sky.StarCount = 3000
		sky.SkyboxUp = "rbxassetid://8995814929"
		sky.MoonTextureId = "rbxasset://sky/moon.jpg"
		sky.SkyboxDn = "rbxassetid://8995686153"
		sky.SkyboxBk = "rbxassetid://8995816670"
		sky.SkyboxFt = "rbxassetid://8995816670"
		sky.SunTextureId = "rbxassetid://8923082571"
		sky.SunAngularSize = 30
		sky.SkyboxLf = "rbxassetid://8995816670"
		sky.SkyboxRt = "rbxassetid://8995816670"
		sky.MoonAngularSize = 0
		sky.Parent = Lighting
		table.insert(shaderState.effects, sky)
		local cc = Instance.new("ColorCorrectionEffect")
		cc.Name = "FosforShader_CC"
		cc.Enabled = true
		cc.Saturation = 0.5
		cc.Contrast = 0.3
		cc.TintColor = Color3.new(0.941176, 0.862745, 1)
		cc.Brightness = 0
		cc.Parent = Lighting
		table.insert(shaderState.effects, cc)
		local bloom = Instance.new("BloomEffect")
		bloom.Name = "FosforShader_Bloom"
		bloom.Enabled = true
		bloom.Threshold = 0.8
		bloom.Intensity = 0.3
		bloom.Size = 24
		bloom.Parent = Lighting
		table.insert(shaderState.effects, bloom)
		local atm = Instance.new("Atmosphere")
		atm.Name = "FosforShader_Atmo"
		atm.Density = 0.3
		atm.Haze = 0
		atm.Color = Color3.new(0.678, 0.847, 0.902)
		atm.Decay = Color3.new(0.678, 0.847, 0.902)
		atm.Glare = 0
		atm.Offset = 0
		atm.Parent = Lighting
		table.insert(shaderState.effects, atm)
	end

	shaderPresets.Purple = function()
		Lighting.ClockTime = 18.5
		Lighting.Brightness = 2.8
		Lighting.FogColor = Color3.fromRGB(138, 43, 226)
		Lighting.Ambient = Color3.fromRGB(138, 43, 226)
		Lighting.OutdoorAmbient = Color3.fromRGB(100, 90, 110)
		Lighting.FogStart = 50
		Lighting.FogEnd = 500
		-- цветокоррекция: тёплый фиолетовый оттенок
		local cc = Instance.new("ColorCorrectionEffect")
		cc.Name = "FosforShader_CC"
		cc.Enabled = true
		cc.TintColor = Color3.fromRGB(230, 210, 255)
		cc.Saturation = 0.2
		cc.Contrast = 0.05
		cc.Brightness = 0
		cc.Parent = Lighting
		table.insert(shaderState.effects, cc)
	end

	local shaderToggleData = {}

	local function activateShader(shaderName)
	shaderDeactivateAll()
	shaderSaveLighting()
	if shaderPresets[shaderName] then
		shaderState.activeShader = shaderName
		shaderPresets[shaderName]()
		log("Шейдер " .. shaderName .. " активирован")
	end
end

	local function deactivateShader()
		shaderDeactivateAll()
		log("Все шейдеры сброшены")
	end

	local eveningMorningRow = nil

	local function applyDayNight()
		if shaderState.dayNightMode then
			if shaderState.eveningMorning then
				Lighting.ClockTime = 7
				log("Режим: День (Утро)")
			else
				Lighting.ClockTime = 17
				log("Режим: День (Вечер)")
			end
		else
			Lighting.ClockTime = 0
			log("Режим: Ночь")
		end
	end

	TabBuilders.Shaders = function(page)
		local list = UI.createScrollArea(page)

		local shaderHeader = UI.row(list, 1, 30)
		UI.button({
			Name = "ShaderHeader", Parent = shaderHeader,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "🎨 Шейдеры окружения",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 15,
			Active = false, ThemeText = "text", Font = Enum.Font.GothamBold,
		})

		local shaderNames = {
			{Key = "Desert", Label = "🏜️ Desert Shader"},
			{Key = "Rainy", Label = "🌧️ Rainy Shader"},
			{Key = "Sunset", Label = "🌅 Sunset Shader"},
			{Key = "Dreamy", Label = "✨ Dreamy Shader"},
			{Key = "Purple", Label = "🟣 Purple Map"},
		}

		local orderCounter = 2
		for _, shaderInfo in ipairs(shaderNames) do
			local toggleData = UI.createBWToggle(list, shaderInfo.Label, false, function(state)
				if state then
					for key, td in pairs(shaderToggleData) do
						if key ~= shaderInfo.Key and td.state then
							td.state = false
							td.update()
						end
					end
					activateShader(shaderInfo.Key)
				else
					if shaderState.activeShader == shaderInfo.Key then
						deactivateShader()
					end
				end
			end, orderCounter)
			shaderToggleData[shaderInfo.Key] = toggleData
			orderCounter = orderCounter + 1
		end

		orderCounter = orderCounter + 1
		local resetRow = UI.row(list, orderCounter, 42)
		UI.basicHover(resetRow, 0.1, 0.08, 0.75, 0.25)
		UI.button({
			Name = "ResetLabel", Parent = resetRow,
			Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "🔄 Сбросить все шейдеры",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local resetButton = UI.button({
			Name = "ResetButton", Parent = resetRow,
			Size = UDim2.fromOffset(80, 28), Position = UDim2.new(1, -94, 0.5, -14),
			BackgroundColor3 = currentPalette.element, BackgroundTransparency = 0.1,
			Text = "Сброс", TextSize = 13,
			ThemeBackground = "element", ThemeText = "text",
			Font = Enum.Font.SourceSans, Corner = 10,
		})
		UI.basicHover(resetButton, 0.1, 0.03, 0.6, 0.08)
		resetButton.MouseButton1Click:Connect(function()
			confirmAction({
				title = "Сброс шейдеров",
				text = "Все шейдеры и эффекты освещения будут сброшены к исходным.",
				accept = "Сбросить",
				onAccept = function()
					deactivateShader()
					for _, td in pairs(shaderToggleData) do
						if td.state then
							td.state = false
							td.update()
						end
					end
				end
			})
		end)

		orderCounter = orderCounter + 1
		local dayNightHeader = UI.row(list, orderCounter, 30)
		UI.button({
			Name = "DayNightHeader", Parent = dayNightHeader,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "🌗 Ночь / День",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 15,
			Active = false, ThemeText = "text", Font = Enum.Font.GothamBold,
		})

		orderCounter = orderCounter + 1
		local dayNightToggle = UI.createBWToggle(list, "🌙 Ночь / ☀️ День", false, function(state)
			shaderState.dayNightMode = state
			applyDayNight()
			if eveningMorningRow then
				if state then
					eveningMorningRow.Visible = true
					eveningMorningRow.Size = UDim2.new(1, 0, 0, 38)
				else
					eveningMorningRow.Visible = false
					eveningMorningRow.Size = UDim2.new(1, 0, 0, 0)
				end
			end
		end, orderCounter)

		orderCounter = orderCounter + 1
		eveningMorningRow = UI.row(list, orderCounter, 0)
		eveningMorningRow.Visible = false
		eveningMorningRow.Size = UDim2.new(1, 0, 0, 0)
		UI.button({
			Name = "EveningMorningLabel", Parent = eveningMorningRow,
			Size = UDim2.new(1, -96, 1, 0), Position = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = "🌆 Вечер / 🌄 Утро",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
			Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
		})
		local eveningMorningToggleBtn = UI.button({
			Name = "EveningMorningToggle", Parent = eveningMorningRow,
			Size = UDim2.fromOffset(54, 24), Position = UDim2.new(1, -68, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(40, 40, 40), BackgroundTransparency = 0,
			Text = "", Corner = 12, StrokeTransparency = 0.3,
		})
		local emKnob = Instance.new("Frame")
		emKnob.Name = "Knob"
		emKnob.Size = UDim2.fromOffset(18, 18)
		emKnob.AnchorPoint = Vector2.new(0.5, 0.5)
		emKnob.Position = UDim2.new(0, 14, 0.5, 0)
		emKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
		emKnob.BorderSizePixel = 0
		emKnob.Parent = eveningMorningToggleBtn
		UI.corner(emKnob, 9)

		local emState = false
		local function updateEMVisual()
			if emState then
				Animations.tween(eveningMorningToggleBtn, {
					BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0,
				}, 0.2)
				Animations.tween(emKnob, {
					Position = UDim2.new(1, -14, 0.5, 0), BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				}, 0.2)
			else
				Animations.tween(eveningMorningToggleBtn, {
					BackgroundColor3 = Color3.fromRGB(40, 40, 40), BackgroundTransparency = 0,
				}, 0.2)
				Animations.tween(emKnob, {
					Position = UDim2.new(0, 14, 0.5, 0), BackgroundColor3 = Color3.fromRGB(200, 200, 200),
				}, 0.2)
			end
		end

		eveningMorningToggleBtn.MouseButton1Click:Connect(function()
			emState = not emState
			shaderState.eveningMorning = emState
			updateEMVisual()
			applyDayNight()
		end)

		orderCounter = orderCounter + 1
		UI.createSlider(list, {
			Label = "Время суток",
			Min = 0,
			Max = 24,
			Value = Lighting.ClockTime,
			Order = orderCounter,
			Callback = function(value)
				Lighting.ClockTime = value
				if shaderState.dayNightMode then
					shaderState.dayNightMode = false
					log("Ручное время: режим День/Ночь отключён")
				end
			end
		})

		-- ============================================================
		-- СЕКЦИЯ ОКЕАНА
		-- ============================================================
		local oceanPart = nil
		pcall(function()
			local map = workspace:FindFirstChild("Map")
			if map then
				local tweened = map:FindFirstChild("AlwaysHereTweenedObjects")
				if tweened then
					oceanPart = tweened:FindFirstChild("Ocean")
				end
			end
		end)

		local oceanOriginal = nil
		local function findSamplePart(obj)
			if obj:IsA("BasePart") then return obj end
			for _, child in ipairs(obj:GetDescendants()) do
				if child:IsA("BasePart") then return child end
			end
			return nil
		end
		if oceanPart then
			local sample = findSamplePart(oceanPart)
			if sample then
				oceanOriginal = {
					Color = sample.Color,
					Material = sample.Material,
					Transparency = sample.Transparency,
				}
			end
		end

		local function applyToOcean(fn)
			if not oceanPart then return end
			if oceanPart:IsA("BasePart") then
				fn(oceanPart)
			else
				-- Folder, Model и прочие контейнеры — применяем ко всем BasePart внутри
				for _, child in ipairs(oceanPart:GetDescendants()) do
					if child:IsA("BasePart") then fn(child) end
				end
			end
		end

		local function setOceanColor(color)
			applyToOcean(function(part) part.Color = color end)
		end

		local function setOceanMaterial(mat)
			applyToOcean(function(part) part.Material = mat end)
		end

		local function setOceanTexture(assetId)
			applyToOcean(function(part)
				for _, child in ipairs(part:GetChildren()) do
					if child.Name == "FosforOceanTexture" then child:Destroy() end
				end
				local tex = Instance.new("Texture")
				tex.Name = "FosforOceanTexture"
				tex.Texture = "rbxassetid://" .. assetId
				tex.Face = Enum.NormalId.Top
				tex.StudsPerTileU = 8
				tex.StudsPerTileV = 8
				tex.Transparency = 0
				tex.Parent = part
			end)
		end

		local function resetOcean()
			if not oceanOriginal then return end
			applyToOcean(function(part)
				part.Color = oceanOriginal.Color
				part.Material = oceanOriginal.Material
				part.Transparency = oceanOriginal.Transparency
				for _, child in ipairs(part:GetChildren()) do
					if child.Name == "FosforOceanTexture" then child:Destroy() end
				end
			end)
		end

		orderCounter = orderCounter + 1
		local oceanHeader = UI.row(list, orderCounter, 30)
		UI.button({
			Name = "OceanHeader", Parent = oceanHeader,
			Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1, Stroke = false,
			Text = oceanPart and "🌊 Океан" or "🌊 Океан не найден",
			TextXAlignment = Enum.TextXAlignment.Left, TextSize = 15,
			Active = false, ThemeText = oceanPart and "text" or "dim", Font = Enum.Font.GothamBold,
		})

		if oceanPart then
			-- Тумблер: скрыть океан
			orderCounter = orderCounter + 1
			UI.createToggle(list, "Скрыть океан", false, function(state)
				applyToOcean(function(part) part.Transparency = state and 1 or oceanOriginal.Transparency end)
				log("Океан: " .. (state and "скрыт" or "показан"))
				playSound("toggle")
			end, orderCounter)

			-- Слайдер прозрачности
			orderCounter = orderCounter + 1
			UI.createSlider(list, {
				Label = "Прозрачность океана %",
				Min = 0, Max = 95,
				Value = math.floor(oceanOriginal.Transparency * 100),
				Order = orderCounter,
				Callback = function(value)
					applyToOcean(function(part) part.Transparency = value / 100 end)
				end,
			})

			-- Цвет океана (палитра)
			orderCounter = orderCounter + 1
			local colorRow = UI.row(list, orderCounter, 52)
			UI.button({
				Name = "ColorLabel", Parent = colorRow,
				Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 14, 0, 4),
				BackgroundTransparency = 1, Stroke = false,
				Text = "Цвет океана",
				TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12,
				Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans,
			})
			local oceanColors = {
				{Name = "Синий",   Color = Color3.fromRGB(0, 100, 200)},
				{Name = "Бирюза",  Color = Color3.fromRGB(0, 180, 200)},
				{Name = "Изумруд", Color = Color3.fromRGB(0, 180, 120)},
				{Name = "Фиолет",  Color = Color3.fromRGB(120, 60, 200)},
				{Name = "Розовый", Color = Color3.fromRGB(200, 100, 150)},
				{Name = "Красный", Color = Color3.fromRGB(180, 40, 40)},
				{Name = "Ночь",    Color = Color3.fromRGB(10, 10, 30)},
				{Name = "Луна",    Color = Color3.fromRGB(200, 210, 230)},
			}
			for i, colorData in ipairs(oceanColors) do
				local btn = UI.button({
					Name = "Color_" .. colorData.Name, Parent = colorRow,
					Size = UDim2.fromOffset(26, 26),
					Position = UDim2.new(0, 14 + (i-1) * 32, 1, -32),
					BackgroundColor3 = colorData.Color,
					BackgroundTransparency = 0,
					Text = "", Corner = 7,
					StrokeTransparency = 0.5,
				})
				btn.MouseButton1Click:Connect(function()
					setOceanColor(colorData.Color)
					playSound("click")
					log("Цвет океана: " .. colorData.Name)
				end)
			end

			-- Материал океана
			orderCounter = orderCounter + 1
			local matRow = UI.row(list, orderCounter, 56)
			UI.button({
				Name = "MatLabel", Parent = matRow,
				Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 14, 0, 4),
				BackgroundTransparency = 1, Stroke = false,
				Text = "Материал океана",
				TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12,
				Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans,
			})
			local oceanMaterials = {
				{Name = "Вода",    Mat = Enum.Material.Water},
				{Name = "Стекло",  Mat = Enum.Material.Glass},
				{Name = "Неон",    Mat = Enum.Material.Neon},
				{Name = "Лёд",     Mat = Enum.Material.Ice},
				{Name = "Мрамор",  Mat = Enum.Material.Marble},
				{Name = "Пластик", Mat = Enum.Material.SmoothPlastic},
				{Name = "Фольга",  Mat = Enum.Material.Foil},
				{Name = "Металл",  Mat = Enum.Material.Metal},
			}
			for i, matData in ipairs(oceanMaterials) do
				local row = math.floor((i-1) / 4)
				local col = (i-1) % 4
				local btn = UI.button({
					Name = "Mat_" .. matData.Name, Parent = matRow,
					Size = UDim2.fromOffset(90, 20),
					Position = UDim2.new(0, 14 + col * 96, 1, -26 - row * 22),
					BackgroundTransparency = 0.1, Text = matData.Name, TextSize = 11,
					ThemeBackground = "element", ThemeText = "text",
					Font = Enum.Font.SourceSans, Corner = 6,
					StrokeTransparency = 0.6,
				})
				btn.MouseButton1Click:Connect(function()
					setOceanMaterial(matData.Mat)
					playSound("click")
					log("Материал океана: " .. matData.Name)
				end)
			end

			-- Своя текстура
			orderCounter = orderCounter + 1
			local texRow = UI.row(list, orderCounter, 48)
			local texInput = Instance.new("TextBox")
			texInput.Name = "TexInput"
			texInput.Size = UDim2.new(1, -130, 1, -12)
			texInput.Position = UDim2.new(0, 12, 0, 6)
			texInput.BackgroundColor3 = currentPalette.element
			texInput.BackgroundTransparency = 0.1
			texInput.BorderSizePixel = 0
			texInput.Text = ""
			texInput.PlaceholderText = "rbxassetid своей текстуры (число)"
			texInput.PlaceholderColor3 = currentPalette.sub
			texInput.TextColor3 = currentPalette.text
			texInput.Font = Enum.Font.Code
			texInput.TextSize = 12
			texInput.TextXAlignment = Enum.TextXAlignment.Left
			texInput.ClearTextOnFocus = false
			texInput.Parent = texRow
			addThemed("element", texInput)
			addThemed("text", texInput)
			UI.corner(texInput, 10)
			UI.stroke(texInput, 0.6, 1)
			UI.padding(texInput, 10, 8, 0, 0)
			UI.focusFX(texInput)
			local applyTexBtn = UI.button({
				Name = "ApplyTexBtn", Parent = texRow,
				Size = UDim2.fromOffset(100, 28), Position = UDim2.new(1, -114, 0.5, -14),
				BackgroundTransparency = 0.1, Text = "Применить", TextSize = 12,
				ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans, Corner = 10,
			})
			UI.basicHover(applyTexBtn, 0.1, 0.03, 0.6, 0.08)
			applyTexBtn.MouseButton1Click:Connect(function()
				local assetId = trim(texInput.Text)
				if assetId == "" then
					log("Вставь rbxassetid текстуры")
					playSound("error", 0.4)
					return
				end
				local num = tonumber(assetId)
				if not num then
					log("Введи только число (id текстуры)")
					playSound("error", 0.4)
					return
				end
				setOceanTexture(num)
				log("Текстура океана применена")
				playSound("success", 0.4)
			end)

			-- Сброс океана
			orderCounter = orderCounter + 1
			local resetOceanRow = UI.row(list, orderCounter, 42)
			UI.basicHover(resetOceanRow, 0.1, 0.08, 0.75, 0.25)
			UI.button({
				Name = "ResetOceanLabel", Parent = resetOceanRow,
				Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 14, 0, 0),
				BackgroundTransparency = 1, Stroke = false,
				Text = "🔄 Сбросить океан",
				TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14,
				Active = false, ThemeText = "text", Font = Enum.Font.SourceSans,
			})
			local resetOceanBtn = UI.button({
				Name = "ResetOceanBtn", Parent = resetOceanRow,
				Size = UDim2.fromOffset(100, 28), Position = UDim2.new(1, -114, 0.5, -14),
				BackgroundTransparency = 0.1, Text = "Сброс", TextSize = 13,
				ThemeBackground = "element", ThemeText = "text",
				Font = Enum.Font.SourceSans, Corner = 10,
			})
			UI.basicHover(resetOceanBtn, 0.1, 0.03, 0.6, 0.08)
			resetOceanBtn.MouseButton1Click:Connect(function()
				resetOcean()
				log("Океан сброшен к оригиналу")
				playSound("success", 0.4)
			end)
		end
	end

	TabBuilders.Console = function(page)
		local consoleScroll = Instance.new("ScrollingFrame")
		consoleScroll.Name = "ConsoleScroll"
		consoleScroll.Position = UDim2.new(0, 12, 0, 12)
		consoleScroll.Size = UDim2.new(1, -24, 1, -64)
		consoleScroll.BackgroundColor3 = currentPalette.consoleBG
		consoleScroll.BackgroundTransparency = 0.04
		consoleScroll.BorderSizePixel = 0
		consoleScroll.ScrollBarThickness = 3
		consoleScroll.ScrollBarImageColor3 = currentPalette.stroke
		consoleScroll.ScrollBarImageTransparency = 0.2
		consoleScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		consoleScroll.Parent = page
		addThemed("consoleBg", consoleScroll)
		addThemed("scrollbar", consoleScroll)
		UI.corner(consoleScroll, 14)
		UI.stroke(consoleScroll, 0.35, 1)
		local consoleList = Instance.new("Frame")
		consoleList.Name = "ConsoleList"
		consoleList.Size = UDim2.new(1, 0, 0, 0)
		consoleList.AutomaticSize = Enum.AutomaticSize.Y
		consoleList.BackgroundTransparency = 1
		consoleList.Parent = consoleScroll
		local consoleListLayout = Instance.new("UIListLayout")
		consoleListLayout.Padding = UDim.new(0, 3)
		consoleListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		consoleListLayout.Parent = consoleList
		UI.padding(consoleList, 10, 10, 8, 8)
		local function updateConsoleCanvas()
			consoleScroll.CanvasSize = UDim2.new(0, 0, 0, consoleListLayout.AbsoluteContentSize.Y + 10)
		end
		consoleListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateConsoleCanvas)
		local consoleLineOrder = 0
		addConsoleLine = function(text, kind)
			if not consoleList then return end
			consoleLineOrder += 1
			local line = Instance.new("TextButton")
			line.Name = "ConsoleLine"
			line.BackgroundTransparency = 1
			line.Size = UDim2.new(1, 0, 0, 0)
			line.AutomaticSize = Enum.AutomaticSize.Y
			line.Font = Enum.Font.Code
			line.TextSize = 13
			line.TextXAlignment = Enum.TextXAlignment.Left
			line.TextYAlignment = Enum.TextYAlignment.Top
			line.TextWrapped = true
			line.Text = tostring(text)
			line.AutoButtonColor = false
			line.Active = false
			line.LayoutOrder = consoleLineOrder
			if kind == "user" then
				line.TextColor3 = currentPalette.text
			elseif kind == "sub" then
				line.TextColor3 = currentPalette.sub
			else
				line.TextColor3 = currentPalette.consoleText
			end
			line.Parent = consoleList
			if consoleLineOrder > 220 then
				local oldest = nil
				local oldestOrder = nil
				for _, child in ipairs(consoleList:GetChildren()) do
					if child:IsA("TextButton") then
						if not oldestOrder or child.LayoutOrder < oldestOrder then
							oldest = child
							oldestOrder = child.LayoutOrder
						end
					end
				end
				if oldest then oldest:Destroy() end
			end
			task.defer(function()
				updateConsoleCanvas()
				consoleScroll.CanvasPosition = Vector2.new(0, consoleListLayout.AbsoluteContentSize.Y)
			end)
		end
		clearConsole = function()
			if not consoleList then return end
			for _, child in ipairs(consoleList:GetChildren()) do
				if child:IsA("TextButton") then child:Destroy() end
			end
			consoleLineOrder = 0
			updateConsoleCanvas()
		end
		local recentFrame = Instance.new("Frame")
		recentFrame.Name = "RecentFrame"
		recentFrame.Position = UDim2.new(0, 12, 1, -118)
		recentFrame.Size = UDim2.new(1, -24, 0, 64)
		recentFrame.BackgroundColor3 = currentPalette.element
		recentFrame.BackgroundTransparency = 0.1
		recentFrame.BorderSizePixel = 0
		recentFrame.Parent = page
		addThemed("element", recentFrame)
		UI.corner(recentFrame, 14)
		UI.stroke(recentFrame, 0.75, 1)
		UI.button({Name = "RecentTitle", Parent = recentFrame, Size = UDim2.new(1, -24, 0, 18), Position = UDim2.new(0, 12, 0, 6), BackgroundTransparency = 1, Stroke = false, Text = "Последние скрипты", TextXAlignment = Enum.TextXAlignment.Left, TextSize = 12, Active = false, ThemeText = "sub", Font = Enum.Font.SourceSans})
		for i = 1, 3 do
			local recentButton = UI.button({Name = "RecentSlot_" .. i, Parent = recentFrame, Size = UDim2.new(1 / 3 - 0.02, 0, 0, 28), Position = UDim2.new((i - 1) / 3 + 0.01, 0, 1, -36), BackgroundTransparency = 0.25, Text = "Пусто", TextSize = 11, ThemeBackground = "element", ThemeText = "dim", Font = Enum.Font.SourceSans})
			table.insert(recentTextButtons, recentButton)
		end
		addRecent = function(scriptName)
			if not scriptName or scriptName == "" then return end
			if recentScripts[1] == scriptName then return end
			table.insert(recentScripts, 1, scriptName)
			while #recentScripts > 3 do table.remove(recentScripts) end
			updateRecent()
		end
		updateRecent = function()
			for index, button in ipairs(recentTextButtons) do
				local scriptName = recentScripts[index]
				if scriptName then
					button.Text = scriptName
					button.TextColor3 = currentPalette.text
					button.BackgroundTransparency = 0.1
				else
					button.Text = "Пусто"
					button.TextColor3 = currentPalette.dim
					button.BackgroundTransparency = 0.25
				end
			end
		end
		local inputRow = Instance.new("Frame")
		inputRow.Name = "InputRow"
		inputRow.Position = UDim2.new(0, 12, 1, -44)
		inputRow.Size = UDim2.new(1, -24, 0, 32)
		inputRow.BackgroundTransparency = 1
		inputRow.Parent = page
		local consoleInput = Instance.new("TextBox")
		consoleInput.Name = "ConsoleInput"
		consoleInput.Size = UDim2.new(1, -112, 1, 0)
		consoleInput.BackgroundColor3 = currentPalette.element
		consoleInput.BackgroundTransparency = 0.1
		consoleInput.BorderSizePixel = 0
		consoleInput.Text = ""
		consoleInput.PlaceholderText = "Введите команду..."
		consoleInput.PlaceholderColor3 = currentPalette.sub
		consoleInput.TextColor3 = currentPalette.text
		consoleInput.Font = Enum.Font.Code
		consoleInput.TextSize = 13
		consoleInput.TextXAlignment = Enum.TextXAlignment.Left
		consoleInput.ClearTextOnFocus = true
		consoleInput.Parent = inputRow
		addThemed("element", consoleInput)
		addThemed("text", consoleInput)
		UI.corner(consoleInput, 12)
		UI.stroke(consoleInput, 0.6, 1)
		UI.padding(consoleInput, 10, 8, 0, 0)
		UI.focusFX(consoleInput)
		local clearButton = UI.button({Name = "ClearButton", Parent = inputRow, Size = UDim2.new(0, 96, 1, 0), Position = UDim2.new(1, -96, 0, 0), BackgroundTransparency = 0.1, Text = "Очистить", TextSize = 13, ThemeBackground = "element", ThemeText = "text", Font = Enum.Font.SourceSans})
		UI.basicHover(clearButton, 0.1, 0.03, 0.6, 0.08)
		local executeScriptByName = function(scriptName)
			if not scriptName or scriptName == "" then return end
			local found = nil
			for _, scriptData in ipairs(scriptLibrary) do
				if string.lower(scriptData.Name) == string.lower(scriptName) then
					found = scriptData
					break
				end
			end
			if found then
				if found.URL then
					task.spawn(function()
						executeScriptFromURL(found.Name, found.URL)
						if addRecent then addRecent(found.Name) end
					end)
				else
					if addConsoleLine then addConsoleLine("Скрипт " .. found.Name .. " (без URL, имитация)", "sub") end
					print("[Fosfor] Fake execute:", found.Name)
					if notify then notify("Скрипт " .. found.Name .. " (имитация)") end
					if addRecent then addRecent(found.Name) end
				end
			else
				if addConsoleLine then addConsoleLine("Скрипт не найден: " .. scriptName, "sub") end
			end
		end
		local function processConsoleInput(rawText)
			local text = trim(rawText)
			if text == "" then return end
			local lower = string.lower(text)
			if lower == "clear" or lower == "cls" then
				clearConsole()
				addConsoleLine("Консоль очищена.", "sub")
				return
			end
			addConsoleLine("> " .. text, "user")
			if lower == "help" then
				addConsoleLine("Команды:", "sub")
				addConsoleLine("help, clear, features", "sub")
				addConsoleLine("theme dark / theme light", "sub")
				addConsoleLine("transparency 0-100", "sub")
				addConsoleLine("run <имя скрипта>", "sub")
				addConsoleLine("lua <код> (через безопасный loadstring)", "sub")
			elseif lower == "features" then
				for _, key in ipairs(featureOrder) do
					addConsoleLine(key .. " = " .. tostring(getFeature(key)), "sub")
				end
			elseif lower == "theme dark" or lower == "тема тёмная" then
				if setTheme then setTheme("Тёмная") end
			elseif lower == "theme light" or lower == "тема светлая" then
				if setTheme then setTheme("Светлая") end
			else
				local transparencyValue = string.match(lower, "^transparency%s+(%d+)$")
				if transparencyValue then
					local percent = clamp(tonumber(transparencyValue) or 0, 0, 100)
					setWindowTransparency(percent / 100)
					addConsoleLine("Прозрачность окна: " .. math.floor(percent) .. "%", "sub")
					return
				end
				local runValue = string.match(text, "^run%s+(.+)$")
				if runValue then
					local scriptName = trim(runValue)
					if executeScriptByName then executeScriptByName(scriptName) end
					return
				end
				local luaValue = string.match(text, "^lua%s+(.+)$")
				if luaValue then
					local source = trim(luaValue)
					local ok, result = safeLoadstring(source)
					if ok then
						addConsoleLine("Код выполнен.", "sub")
						if notify then notify("Lua-код выполнен") end
					else
						addConsoleLine("Ошибка: " .. tostring(result), "sub")
					end
					return
				end
				addConsoleLine("Неизвестная команда. Введите help.", "sub")
			end
		end
		consoleInput.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				local text = consoleInput.Text
				consoleInput.Text = ""
				processConsoleInput(text)
			end
		end)
		clearButton.MouseButton1Click:Connect(function()
			clearConsole()
			addConsoleLine("Консоль очищена.", "sub")
		end)
		updateRecent()
	end

	-- ============================================================
	-- СОЗДАНИЕ НАВИГАЦИИ И СТРАНИЦ
	-- ============================================================
	local function createPage(key)
		local page = Instance.new("CanvasGroup")
		page.Name = key
		page.Size = UDim2.fromScale(1, 1)
		page.Position = UDim2.new(0, 0, 0, 0)
		page.BackgroundTransparency = 1
		page.GroupTransparency = 1
		page.Visible = false
		page.ZIndex = 2
		page.Parent = pagesFrame
		pages[key] = page
		return page
	end

	local tabDefinitions = {
		{Key = "Player",    Label = "Профиль",     Icon = "rbxassetid://10747373176", Builder = TabBuilders.Player,    Font = Enum.Font.SourceSans},
		{Key = "Scripts",   Label = "Скрипты",   Icon = "rbxassetid://10709810463", Builder = TabBuilders.Scripts,   Font = Enum.Font.SourceSans},
		{Key = "Teleports", Label = "Телепорты", Icon = "rbxassetid://10734886202", Builder = TabBuilders.Teleports, Font = Enum.Font.SourceSans},
		{Key = "ESP",       Label = "ESP",       Icon = "rbxassetid://10723346959", Builder = TabBuilders.ESP,       Font = Enum.Font.SourceSans},
		{Key = "Target",    Label = "Target",    Icon = "rbxassetid://10709818534", Builder = TabBuilders.Target,    Font = Enum.Font.SourceSans},
		{Key = "PVP",       Label = "PVP",       Icon = "rbxassetid://10723376114", Builder = TabBuilders.PVP,     Font = Enum.Font.GothamBold},
		{Key = "Misc",      Label = "Разное",    Icon = "rbxassetid://10747383470", Builder = TabBuilders.Misc,      Font = Enum.Font.SourceSans},
		{Key = "Phantom", Label = "???", Icon = "rbxassetid://10709761813", Builder = TabBuilders.Phantom, Font = Enum.Font.GothamBold},
		{Key = "Shaders",   Label = "Шейдеры",   Icon = "rbxassetid://10723396000", Builder = TabBuilders.Shaders,   Font = Enum.Font.SourceSans}, -- 💎 кристалл
		{Key = "Settings",  Label = "Настройки", Icon = "rbxassetid://10734950309", Builder = TabBuilders.Settings,  Font = Enum.Font.SourceSans},
		{Key = "Console",   Label = "Консоль",   Icon = "rbxassetid://10723367244", Builder = TabBuilders.Console,   Font = Enum.Font.SourceSans},
	}

	for index, definition in ipairs(tabDefinitions) do
		local page = createPage(definition.Key)
		if definition.Builder then
			definition.Builder(page)
		end

		local navButton = UI.button({
			Name = "Nav_" .. definition.Key,
			Parent = navContainer,
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = currentPalette.element,
			BackgroundTransparency = 1,
			Text = "",
			Corner = 10,
			StrokeTransparency = 1,
			ZIndex = 3,
		})

		if definition.Icon then
			local navIcon = Instance.new("ImageLabel")
			navIcon.Name = "NavIcon"
			navIcon.Size = UDim2.fromOffset(18, 18)
			navIcon.Position = UDim2.new(0, 10, 0.5, -9)
			navIcon.BackgroundTransparency = 1
			navIcon.Image = definition.Icon
			navIcon.ImageColor3 = currentPalette.sub
			navIcon.ScaleType = Enum.ScaleType.Fit
			navIcon.ZIndex = 4
			navIcon.Parent = navButton
			addThemed("text", navIcon)
		end

		local navLabel = Instance.new("TextLabel")
		navLabel.Name = "NavLabel"
		navLabel.Size = UDim2.new(1, -44, 1, 0)
		navLabel.Position = UDim2.new(0, 38, 0, 0)
		navLabel.BackgroundTransparency = 1
		navLabel.Text = definition.Label
		navLabel.TextColor3 = currentPalette.sub
		navLabel.Font = definition.Font or Enum.Font.SourceSans
		navLabel.TextSize = 15
		navLabel.TextXAlignment = Enum.TextXAlignment.Left
		navLabel.ZIndex = 4
		navLabel.Parent = navButton
		addThemed("text", navLabel)

		navButton.LayoutOrder = index
		navButton:SetAttribute("TabKey", definition.Key)
		table.insert(navButtons, navButton)

		navButton.MouseButton1Click:Connect(function()
			playSound("click")
			if switchTab then switchTab(definition.Key) end
		end)
		navButton.MouseEnter:Connect(function()
			if currentTab ~= definition.Key then
				Animations.tween(navButton, {BackgroundTransparency = 0.55}, 0.15)
			end
		end)
		navButton.MouseLeave:Connect(function()
			if updateNavStyles then updateNavStyles() end
		end)
	end

	updateNavStyles = function()
		for _, button in ipairs(navButtons) do
			local key = button:GetAttribute("TabKey")
			local stroke = button:FindFirstChildOfClass("UIStroke")
			local icon = button:FindFirstChild("NavIcon")
			local label = button:FindFirstChild("NavLabel")

			if key == currentTab then
				button.BackgroundTransparency = 0.12
				if label then label.TextColor3 = currentPalette.text end
				if icon then icon.ImageColor3 = currentPalette.text end
				if stroke then stroke.Transparency = 0.25 end
			else
				button.BackgroundTransparency = 1
				if label then label.TextColor3 = currentPalette.sub end
				if icon then icon.ImageColor3 = currentPalette.sub end
				if stroke then stroke.Transparency = 1 end
			end
		end
	end

	switchTab = function(key)
		if not pages[key] or currentTab == key then return end
		local oldPage = pages[currentTab]
		currentTab = key
		if updateNavStyles then updateNavStyles() end
		local targetPage = pages[key]
		if oldPage and oldPage ~= targetPage then
			oldPage.Visible = true
			Animations.tweenCompleted(oldPage, {GroupTransparency = 1, Position = UDim2.new(0, -18, 0, 0)}, 0.22, function()
				if currentTab ~= oldPage.Name then
					oldPage.Visible = false
					oldPage.GroupTransparency = 1
					oldPage.Position = UDim2.new(0, 0, 0, 0)
				end
			end)
		end
		targetPage.Visible = true
		targetPage.Position = UDim2.new(0, 18, 0, 0)
		targetPage.GroupTransparency = 1
		task.defer(function()
			Animations.tween(targetPage, {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}, 0.3)
		end)
	end

	updateAllToggles = function()
		for _, toggleData in ipairs(toggles) do
			if toggleData.update then toggleData.update() end
		end
	end

	applyTheme = function(themeName)
		local palette = getPalette(themeName or settings.Theme)
		currentPalette = palette
		for _, list in pairs(themed) do
			for i = #list, 1, -1 do
				local object = list[i]
				if not object or not object.Parent then
					table.remove(list, i)
				end
			end
		end
		for _, object in ipairs(themed.bg) do
			if object.Parent then object.BackgroundColor3 = palette.bg end
		end
		for _, object in ipairs(themed.panel) do
			if object.Parent then object.BackgroundColor3 = palette.panel end
		end
		for _, object in ipairs(themed.element) do
			if object.Parent then object.BackgroundColor3 = palette.element end
		end
		for _, object in ipairs(themed.text) do
			if object.Parent then
				if object:IsA("TextBox") then
					object.TextColor3 = palette.text
					object.PlaceholderColor3 = palette.sub
				elseif object:IsA("TextButton") then
					object.TextColor3 = palette.text
				elseif object:IsA("TextLabel") then
					object.TextColor3 = palette.text
				elseif object:IsA("ImageLabel") then
					object.ImageColor3 = palette.text
				elseif object:IsA("Frame") then
					object.BackgroundColor3 = palette.text
				elseif object:IsA("ImageButton") then
					object.ImageColor3 = palette.text
				end
			end
		end
		for _, object in ipairs(themed.sub) do
			if object.Parent and (object:IsA("TextButton") or object:IsA("TextBox") or object:IsA("TextLabel")) then
				object.TextColor3 = palette.sub
			end
		end
		for _, object in ipairs(themed.star) do
			if object.Parent then object.BackgroundColor3 = palette.star end
		end
		for _, object in ipairs(themed.consoleBg) do
			if object.Parent then object.BackgroundColor3 = palette.consoleBG end
		end
		for _, object in ipairs(themed.stroke) do
			if object.Parent then object.Color = palette.stroke end
		end
		for _, object in ipairs(themed.accent) do
			if object.Parent then
				if object:IsA("GuiObject") then object.BackgroundColor3 = palette.text end
				if object:IsA("TextButton") then object.TextColor3 = palette.bg end
			end
		end
		for _, object in ipairs(themed.scrollbar) do
			if object.Parent and object:IsA("ScrollingFrame") then
				object.ScrollBarImageColor3 = palette.stroke
			end
		end
		for _, object in ipairs(themed.gradient) do
			if object.Parent then
				object.Color = ColorSequence.new(palette.gradientTop, palette.gradientBottom)
			end
		end
		for _, object in ipairs(themed.particle) do
			if object.Parent then object.BackgroundColor3 = palette.particle end
		end
		for _, object in ipairs(themed.logoStar) do
			if object.Parent then object.BackgroundColor3 = palette.logoStar end
		end
		for _, object in ipairs(themed.logoStarGlow) do
			if object.Parent then object.BackgroundColor3 = palette.logoStar end
		end
		for _, object in ipairs(themed.closeCross) do
			if object.Parent then object.BackgroundColor3 = palette.closeCross end
		end
		if updateNavStyles then updateNavStyles() end
		if updateAllToggles then updateAllToggles() end
		if updateThemeButtons then updateThemeButtons() end
		if updateRecent then updateRecent() end
	end

	setTheme = function(themeName)
		if themeName ~= "Тёмная" and themeName ~= "Светлая" then return end
		settings.Theme = themeName
		if applyTheme then applyTheme(themeName) end
		log("Тема оформления: " .. themeName)
	end

	-- ============================================================
	-- СТАРТ
	-- ============================================================
	currentTab = tabDefinitions[1].Key
	pages[currentTab].Visible = true
	pages[currentTab].GroupTransparency = 0
	pages[currentTab].Position = UDim2.new(0, 0, 0, 0)
	updateNavStyles()
	if applyTheme then applyTheme(settings.Theme) end
	if addConsoleLine then
		addConsoleLine("Fosfor v1.0.3 | Loaded", "info")
		addConsoleLine("Введите help для списка команд.", "sub")
		addConsoleLine("RightShift — показать или скрыть окно.", "sub")
		addConsoleLine("Потяните за правый нижний угол для изменения размера.", "sub")
		addConsoleLine("Добавлена вкладка Шейдеры с Day/Night.", "sub")
	end
	if notify then notify("Fosfor v1.0.3 загружен") end
	task.delay(0.5, function()
		showUI(true)
	end)
end

local ok, errorMessage = pcall(main)
if not ok then
warn("[Fosfor] Ошибка инициализации UI:", errorMessage)
end