--[[
	
	VERSION: 0.0.1
	LAST UPDATED: May 9th, 2026
	
	UPDATE LOG:
		1. Advanced Logger System
		2. Basic Features (Title, Button)
		3. Good config system
	
	Made by @RogueRousseau,
	    Github Repository: https://github.com/roguerousseau/Nord-0
		Documentation: https://rousseau.gitbook.io/nord-docs/
	    Changelogs: https://rousseau.gitbook.io/nord                                       
--]]

local lightningService = game:GetService("Lighting")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- Packages

local pkg = {}
pkg.Registry = { -- All existing packages
	["Motion"] = {
		Name = "Motion",
		Version = "0.0.1",
		Created = "2026-05-09",
		Author = "Vyntexed",
		Description = "The animation engine running Nord UI",
		Dependencies = {
			["Utilities"] = true
		}
	},
	["Debugger"] = {
		Name = "Debugger",
		Version = "0.0.1",
		Created = "2026-05-09",
		Author = "Vyntexed",
		Description = "Advanced debugger",
		Dependencies = {
			["Utilities"] = true,
		}
	},
	["Icons"] = {
		Name = "Icons",
		Version = "0.0.1",
		Created = "2026-05-09",
		Author = "Vyntexed",
		Description = "A library of icons that match the Nord UI library",
		Dependencies = {
			["Utilities"] = true,
		}
	}
}
pkg.Resolve = {} -- All packages that Orbit will need to load
pkg.Cache = {} -- Already loaded packages

pkg.Install = function(package)
	
end

local Motion = require(script.Motion) or {}
local Debugger = require(script.Debugger) or {}
local Icons = require(script.Icons) or {}

local utilities = require(script:WaitForChild("Preload",5).Utilities) or {}

-- other

local lib = {}
lib.__index = lib

-- parameters

lib.packages = {
	["Motion"] = "https://raw.githubusercontent.com/roguerousseau/Nord-0/refs/heads/main/Packages/Motion.lua",
	["Debugger"] = "https://raw.githubusercontent.com/roguerousseau/Nord-0/refs/heads/main/Packages/Debugger.lua",
	["Icons"] = "https://raw.githubusercontent.com/roguerousseau/Nord-0/refs/heads/main/Packages/Icons.lua",		
	
	["Utilities"] = "https://github.com/roguerousseau/Nord-0/raw/refs/heads/main/Packages/Preload/Utilities.lua"
}

lib.themes = {
	dark = {

		Font = "Inter",

		bg_primary = {11, 15, 26,0.2},
		bg_secondary = {24, 28, 45, 0.45},
		bg_tertiary = {30, 35, 55, 0.55},

		-- buttons

		button_primary = {0, 122, 255, 0.3},
		button_primary_text = {255,255,255,0},

		button_primary_hover = {0, 122, 255, 0.10},
		button_primary_pressed = {0, 102, 215, 0.05},

		button_primary_stroke = {255, 255, 255, 0.65},
		button_primary_highlight = {255, 255, 255, 0.7},

		-- btn secondary

		button_secondary = {255, 255, 255, 0.82},
		button_secondary_text = {255,255,255,0.08},
		button_secondary_stroke = {255,255,255,0.8},

		button_secondary_deselected = {255, 255, 255, 1},
		button_secondary_text_deselected = {255,255,255,0.55},
		button_secondary_stroke_deselected = {255,255,255,1},


		stroke_primary = {255, 255, 255, 0.88},

		-- text
		text_primary = {255, 255, 255, 0},
		text_secondary = {235, 235, 245, 0.4},
		text_tertiary = {235, 235, 245, 0.7},
		text_disabled = {235,235, 245, 0.82}

	},

	light = {

		Font = "Inter",

		bg_primary = {245, 247, 252,0.4},
		bg_secondary = {245, 247, 252, 0.75},
		bg_tertiary = {235, 238, 245, 0.85},

		-- buttons

		button_primary = {0, 122, 255, 0.25},
		button_primary_hover = {0, 122, 255, 0.18},
		button_primary_pressed = {0, 102, 215, 0.12},
		button_primary_text = {255,255,255,0},

		button_primary_stroke = {255, 255, 255, 0.4},
		button_primary_highlight = {255, 255, 255, 0.7},

		-- btn secondary

		button_secondary = {0, 0, 0, 0.88},
		button_secondary_text = {0, 0, 0, 0.08},
		button_secondary_stroke = {0, 0, 0, 0.82},
		button_secondary_deselected = {0, 0, 0, 1},
		button_secondary_text_deselected = {0, 0, 0, 0.55},
		button_secondary_stroke_deselected = {0, 0, 0, 1},

		stroke_primary = {60, 60, 67, 0.85},


		-- text
		text_primary = {0, 0, 0,0},
		text_secondary = {60, 60, 67,0.4},
		text_tertiary = {60, 60, 67, 0.7},
		text_disabled = {60, 60, 67, 0.82}
	}
}

lib.Enum = {}

-- flags always start with the number 1

lib.Enum.Flags = {
	["NoResize"] = 10,
	["NoDrag"] = 11,
	["NoAnimations"] = 12
}

-- styles always start with the number 2

lib.Enum.Style = {
	Dashboard = 20,
	Custom = 21
}

lib.Enum.Components = {
	Button = {
		Primary = "vBtnPrimary",
		Secondary = "vBtnSecondary"
	}
}


-- crypt

local crypt = {
	hash = function(str: string)
		local h = 2166136261

		for i = 1, #str do
			h = bit32.bxor(h, str:byte(i))
			h = (h * 16777619) % 2^32
		end

		return h
	end,
}

-- logger

local logger = {}
logger.__index = logger

function logger.new(title)
	local self = setmetatable({},logger)

	self.title = "Nord::"..title or "Nord::Unknown"

	return self
end

function logger:print(content)
	print(`[{self.title}] {content}`)
end


function logger:error(content)
	error(`[{self.title}] {content}`)
end


function logger:warn(content)
	warn(`[{self.title}] {content}`)
end

function logger:info(content)
	print(`[{self.title}] {content}`)
end



-- element creator

local ec = {}
ec.__index = ec

function ec.new(lib, parent)
	local self = setmetatable({},ec)

	self.lib = lib
	self.Parent = parent

	return self
end

function ec:Button(Text,Variant)
	local lib = self.lib
	local utilities = lib._internal.utilities

	local btn = utilities:Button()
	btn.Size = utilities:table_to_UDIM2({0.787, 0},{0.083, 0})

	Variant = Variant or lib.Enum.Components.Button.Primary

	btn.Text = Text or "Button"
	btn.Parent = self.Parent

	local rtrn = {}
	rtrn.structure = {btn=btn}

	if Variant == lib.Enum.Components.Button.Primary then
		btn.BackgroundColor3 = utilities:get_color(lib.theme.button_primary)[1]
		btn.BackgroundTransparency = utilities:get_color(lib.theme.button_primary)[2]
		btn.TextScaled = true

		btn.TextTransparency = utilities:get_color(lib.theme.button_primary_text)[2]
		btn.TextColor3 = utilities:get_color(lib.theme.button_primary_text)[1]

		local grad1 = utilities:UiGradient(btn)
		grad1.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
		grad1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,0)})

		local str = utilities:UiStroke(btn)
		str.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		str.Color = utilities:get_color(lib.theme.button_primary_stroke)[1]
		str.Transparency = utilities:get_color(lib.theme.button_primary_stroke)[2]
		str.Thickness = 1

		local fr = Instance.new("Frame",btn)
		fr.BackgroundColor3 = Color3.fromRGB(255,255,255)
		fr.Size = utilities:table_to_UDIM2({1,0},{1,0})
		fr.Position = UDim2.new(0,0,0,0)

		local uicorn = utilities:UiCorner({0.25,0},btn)
		uicorn:Clone().Parent = fr

		local cak = utilities:UiGradient(fr)
		cak.Color = ColorSequence.new(
			{
				ColorSequenceKeypoint.new(0,utilities:get_color(lib.theme.button_primary_highlight)[1]),
				ColorSequenceKeypoint.new(1,utilities:get_color(lib.theme.button_primary_highlight)[1])})
		cak.Rotation = 90
		cak.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,utilities:get_color(lib.theme.button_primary_highlight)[2]),NumberSequenceKeypoint.new(1,1)})

		-- return

		rtrn.structure.stroke = str
		rtrn.structure.outerGradient = grad1
		rtrn.structure.innerFrame = fr
		rtrn.structure.innerGradient = cak
	elseif Variant == lib.Enum.Components.Button.Secondary then
		btn.BackgroundColor3 = utilities:get_color(lib.theme.button_secondary)[1]
		btn.BackgroundTransparency = utilities:get_color(lib.theme.button_secondary)[2]
		btn.TextTransparency = utilities:get_color(lib.theme.button_secondary_text)[2]
		btn.TextColor3 = utilities:get_color(lib.theme.button_secondary_text)[1]
		btn.TextScaled = true

		utilities:UiCorner({0.25, 0},btn)

		local str = utilities:UiStroke(btn)
		str.Color = utilities:get_color(lib.theme.button_secondary_stroke)[1]
		str.Transparency = utilities:get_color(lib.theme.button_secondary_stroke)[2]
		str.Thickness = 1
		str.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		-- return	
		rtrn.structure.stroke = str

	else
		logger.error("Components","Unknown component variant "..tostring(Variant))
		return rtrn
	end

	return rtrn
end

function ec:Title(Text)
	local lib = self.lib
	local utilities = lib._internal.utilities

	local a = utilities:Label(Text)
	a.BackgroundTransparency = 1
	a.TextScaled = false
	a.TextSize = utilities:getTextSize(35)
	a.AutomaticSize = Enum.AutomaticSize.Y

	a.Size = utilities:table_to_UDIM2({0.9, 0},{0.08, 0})
	a.TextXAlignment = Enum.TextXAlignment.Left
	a.Parent = self.Parent
	a.FontFace = utilities:newFont(Enum.FontWeight.Bold,Enum.FontStyle.Normal)

	a.TextTransparency = utilities:get_color(lib.theme.text_primary)[2]
	a.TextColor3 = utilities:get_color(lib.theme.text_primary)[1]

	return {
		Set = function(c)
			a.Text = c
		end,
		Get = function(c)
			return a.Text
		end,

		Structure = {
			Label = a
		}
	}
end

function ec:Header(Text)
	local lib = self.lib
	local utilities = lib._internal.utilities
	
	local a = utilities:Label(Text)
	a.BackgroundTransparency = 1
	a.TextScaled = false
	a.AutomaticSize = Enum.AutomaticSize.Y
	a.TextSize = utilities:getTextSize(28)
	a.Parent = lib._internal.new_parent
	a.Size = utilities:table_to_UDIM2({0.9, 0},{0.072, 0})
	a.TextXAlignment = Enum.TextXAlignment.Left
	a.Parent = self.Parent

	a.FontFace = utilities:newFont(Enum.FontWeight.SemiBold,Enum.FontStyle.Normal)

	a.TextTransparency = utilities:get_color(lib.theme.text_primary)[2]
	a.TextColor3 = utilities:get_color(lib.theme.text_primary)[1]

	return {
		SetText = function(c)
			a.Text = c
		end,
		GetText = function(c)
			return a.Text
		end,
		structure = {
			label = a
		}
	}
end

function ec:Subheader(Text)
	local lib = self.lib
	local utilities = lib._internal.utilities
	
	local a = utilities:Label(Text)
	a.BackgroundTransparency = 1
	a.TextScaled = false
	a.TextSize = utilities:getTextSize(23)
	a.AutomaticSize = Enum.AutomaticSize.Y
	a.Parent = lib._internal.new_parent
	a.Size = utilities:table_to_UDIM2({0.9, 0},{0.068, 0})
	a.TextXAlignment = Enum.TextXAlignment.Left
	a.Parent = self.Parent

	a.FontFace = utilities:newFont(Enum.FontWeight.Medium,Enum.FontStyle.Normal)

	a.TextTransparency = utilities:get_color(lib.theme.text_primary)[2]
	a.TextColor3 = utilities:get_color(lib.theme.text_primary)[1]

	return {
		SetText = function(c)
			a.Text = c
		end,
		GetText = function(c)
			return a.Text
		end,
		structure = {
			label = a
		}
	}
end

function ec:Paragraph(Text)
	local lib = self.lib
	local utilities = lib._internal.utilities
	
	local a = utilities:Label(Text)
	a.BackgroundTransparency = 1
	a.TextScaled = false
	a.TextSize = utilities:getTextSize(20)
	a.AutomaticSize = Enum.AutomaticSize.Y
	
	a.Size = utilities:table_to_UDIM2({0.9, 0},{0.06, 0})
	a.TextXAlignment = Enum.TextXAlignment.Left
	a.Parent = self.Parent

	a.FontFace = utilities:newFont(Enum.FontWeight.Regular,Enum.FontStyle.Normal)

	a.TextTransparency = utilities:get_color(lib.theme.text_primary)[2]
	a.TextColor3 = utilities:get_color(lib.theme.text_primary)[1]

	return {
		SetText = function(c)
			a.Text = c
		end,
		GetText = function(c)
			return a.Text
		end,
		structure = {
			label = a
		}
	}
end

function ec:Page()
	local lib = self.lib
	local utilities = lib._internal.utilities

	local holder = utilities:Frame()
	holder.Position = UDim2.new(0,0,0,0)
	holder.Size = UDim2.new(1,0,1,0)
	holder.BackgroundTransparency = 1
	holder.Visible = true
	holder.Parent = lib._internal.style.contentHolder
	
	local dholder = utilities:ScrollingFrame()
	dholder.Parent = holder
	holder = dholder

	local ULL = utilities:UiListLayout(holder)
	ULL.SortOrder = Enum.SortOrder.LayoutOrder
	ULL.Padding = UDim.new(0.025,0)
	
	holder.Position = UDim2.new(0,0,0,0)
	holder.Size = UDim2.new(1,0,0.96,0)
	
	local UP = utilities:UiPadding(holder)
	UP.PaddingLeft = UDim.new(0.04,0)
	UP.PaddingTop = UDim.new(0.04,0)
	UP.PaddingBottom = UDim.new(0.04,0)
	UP.PaddingRight = UDim.new(0.04,0)

	lib._internal.style.content = holder

	self.Parent = holder

	local ecInstance = ec.new(lib,holder)

	ecInstance.Page = function()
		logger.new("ec"):warn("Method unavailable, this is because this ec instance is already inside a page or tab")
	end

	ecInstance.Tab = function()
		logger.new("ec"):warn("Method unavailable, this is because this ec instance is already inside a page or tab")
	end

	ecInstance.Visible = holder.Visible

	ecInstance.Show = function(self)
		holder.Visible = true
		ecInstance.Visible = true
	end

	ecInstance.Hide = function(self)
		holder.Visible = false
		ecInstance.Visible = false
	end

	ecInstance.Destroy = function(self)
		holder:Destroy()
	end

	return ecInstance
end

function ec:Tab(Title)
	local lib = self.lib
	local utilities = lib._internal.utilities


	if lib.Enum._lookup[lib.Enum.Style.Dashboard] == 1 then
		local sidebar = lib._internal.style.sidebar
		local tabHolder = lib._internal.style.tabHolder
		
		local pg = self:Page()
		
		local animationsEnabled = (lib._internal.flags == nil) or (lib._internal.flags[lib.Enum.Flags.NoAnimations] ~= true)

		if animationsEnabled then
			pg:Show()
			pg.Animation = Motion.Presets.FadeDescendants({
				Duration = 5,
				Object = pg.Parent,
				Type = Motion.Enum.AnimationType.Spring
			})
		end
		
		local a = self:Button(Title,lib.Enum.Components.Button.Secondary)
		a.structure.btn.Parent = sidebar
		a.structure.btn.Size = utilities:table_to_UDIM2({0.787, 0},{0.08, 0})

		local parentingT = utilities:Frame()
		utilities:UiListLayout(parentingT).Padding = UDim.new(0.025,0)
		local cab = utilities:UiPadding()
		cab.PaddingLeft = UDim.new(0.02)
		cab.PaddingTop = UDim.new(0.07)
		parentingT.Size = UDim2.new(1,0,1,0)
		parentingT.Position = UDim2.new(0,0,0,0)
		parentingT.Parent = tabHolder
		parentingT.BackgroundTransparency = 1
		
		if lib._internal.style.sidebar_opt == nil then
			lib._internal.style.sidebar_opt = {}
		end
		
		table.insert(lib._internal.style.sidebar_opt, {pg,a.structure})
	
		a.structure.btn.Activated:Connect(function()
			for i, v in pairs(lib._internal.style.sidebar_opt) do
				if v[1] == pg then
					pg:Show()
					
					if animationsEnabled then
						pg.Animation.FadeIn()
					end
					
					v[2].btn.BackgroundColor3 = utilities:get_color(lib.theme.button_secondary)[1]
					v[2].btn.BackgroundTransparency = utilities:get_color(lib.theme.button_secondary)[2]
					v[2].btn.TextTransparency = utilities:get_color(lib.theme.button_secondary_text)[2]
					v[2].btn.TextColor3 = utilities:get_color(lib.theme.button_secondary_text)[1]
					v[2].btn.TextScaled = true

					local str = v[2].stroke
					str.Color = utilities:get_color(lib.theme.button_secondary_stroke)[1]
					str.Transparency = utilities:get_color(lib.theme.button_secondary_stroke)[2]
					str.Thickness = 1
					str.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				else
					coroutine.wrap(function()
						if animationsEnabled and v[1].Visible then
							v[1]:Show()
							v[1].Animation.FadeOut().Wait()
						end
						v[1]:Hide()
						v[2].stroke.Enabled = false
						v[2].btn.BackgroundTransparency = utilities:get_color(lib.theme.button_secondary_deselected)[2]
						v[2].btn.BackgroundColor3 = utilities:get_color(lib.theme.button_secondary_deselected)[1]

						v[2].btn.TextTransparency = utilities:get_color(lib.theme.button_secondary_text_deselected)[2]
						v[2].btn.BackgroundColor3 = utilities:get_color(lib.theme.button_secondary_text_deselected)[1]

						v[2].stroke.Color = utilities:get_color(lib.theme.button_secondary_stroke_deselected)[1]
						v[2].stroke.Transparency = utilities:get_color(lib.theme.button_secondary_stroke_deselected)[2]
					end)()
				end
			end
		end)
	
		if lib._internal.style.sidebar_sel == nil then
			lib._internal.style.sidebar_sel = a.structure.btn
			pg:Show()
		else
			pg:Hide()
			a.structure.stroke.Enabled = false
			a.structure.btn.BackgroundTransparency = utilities:get_color(lib.theme.button_secondary_deselected)[2]
			a.structure.btn.BackgroundColor3 = utilities:get_color(lib.theme.button_secondary_deselected)[1]

			a.structure.btn.TextTransparency = utilities:get_color(lib.theme.button_secondary_text_deselected)[2]
			a.structure.btn.BackgroundColor3 = utilities:get_color(lib.theme.button_secondary_text_deselected)[1]

			a.structure.stroke.Color = utilities:get_color(lib.theme.button_secondary_stroke_deselected)[1]
			a.structure.stroke.Transparency = utilities:get_color(lib.theme.button_secondary_stroke_deselected)[2]
		end
		
		return pg
	else
		return self:Page()
	end
end

-- surface creator

local sc = {}
sc.__index = sc

function sc.new(lib)
	local self = setmetatable({},sc)

	self.lib = lib

	return self	
end

function sc:LWindow(conf, flags)
	local data = {
		t = tick()
	}

	local lib = self.lib
	local utilities = lib._internal.utilities

	local lW = utilities:Frame()
	data.w = lW
	lW.Visible = false
	lW.Parent = lib._internal.screen

	lW.Size = utilities:table_to_UDIM2({0.234, 0},{0.284, 0})
	lW.Position = UDim2.new(0.5,0,0.5,0)
	lW.AnchorPoint = Vector2.new(0.5,0.5)

	utilities:UiCorner({0.036, 0}).Parent = lW
	local winAR = utilities:UiAspectRatio(1.648)
	winAR.Parent = lW

	lW.BackgroundTransparency = utilities:get_color(lib.theme.bg_primary)[2]
	lW.BackgroundColor3 = utilities:get_color(lib.theme.bg_primary)[1]

	local win_dec = utilities:Frame()
	win_dec.Parent = lW
	win_dec.Size = utilities:table_to_UDIM2({1, 0},{1, 0})
	utilities:UiCorner({0.036,0},win_dec)
	local uigrad_dec = utilities:UiGradient(win_dec)
	uigrad_dec.Rotation = -90
	uigrad_dec.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
	uigrad_dec.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.75)})

	local TitleLabel = utilities:Label(conf.Title or "Nord 0",lW)

	TitleLabel.TextScaled = true
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.FontFace = utilities:newFont(Enum.FontWeight.Bold,Enum.FontStyle.Normal)
	TitleLabel.TextTransparency = utilities:get_color(lib.theme.text_primary)[2]
	TitleLabel.TextColor3 = utilities:get_color(lib.theme.text_primary)[1]

	TitleLabel.Size = utilities:table_to_UDIM2({0.576, 0},{0.204, 0})
	TitleLabel.Position = utilities:table_to_UDIM2({0.039, 0},{0.089, 0})

	local Subtitle = utilities:Label(conf.Subtitle or "UI Framework",lW)

	Subtitle.TextScaled = true
	Subtitle.BackgroundTransparency = 1
	Subtitle.TextXAlignment = Enum.TextXAlignment.Left

	Subtitle.TextTransparency = utilities:get_color(lib.theme.text_secondary)[2]
	Subtitle.TextColor3 = utilities:get_color(lib.theme.text_secondary)[1]

	Subtitle.Size = utilities:table_to_UDIM2({0.576, 0},{0.138, 0})
	Subtitle.Position = utilities:table_to_UDIM2({0.039, 0},{0.26, 0})

	local versionlabel = utilities:Label(conf.Version or "v1.0.0",lW)

	versionlabel.TextScaled = true
	versionlabel.BackgroundTransparency = 1
	versionlabel.TextXAlignment = Enum.TextXAlignment.Right

	versionlabel.TextTransparency = utilities:get_color(lib.theme.text_tertiary)[2]
	versionlabel.TextColor3 = utilities:get_color(lib.theme.text_tertiary)[1]

	versionlabel.Size = utilities:table_to_UDIM2({0.576, 0},{0.114, 0})
	versionlabel.Position = utilities:table_to_UDIM2({0.378, 0},{0.795, 0})

	return {
		show = function(self)
			if flags[lib.Enum.Flags.NoAnimations] == nil  then
				local vT = versionlabel.TextTransparency
				local sT = Subtitle.TextTransparency
				local tT = TitleLabel.TextTransparency
				local wT = lW.BackgroundTransparency
				local wdT = win_dec.BackgroundTransparency

				TitleLabel.TextTransparency = 1
				versionlabel.TextTransparency = 1
				Subtitle.TextTransparency = 1
				win_dec.BackgroundTransparency = 1
				lW.BackgroundTransparency = 1

				local t1 = tweenService:Create(versionlabel,TweenInfo.new(0.3,Enum.EasingStyle.Circular,Enum.EasingDirection.Out),{TextTransparency=vT})
				local t2 = tweenService:Create(Subtitle,t1.TweenInfo,{TextTransparency=sT})
				local t3 = tweenService:Create(TitleLabel,t1.TweenInfo,{TextTransparency=tT})

				local t4 = tweenService:Create(lW,t1.TweenInfo,{BackgroundTransparency=wT})
				local t5 = tweenService:Create(win_dec,t1.TweenInfo,{BackgroundTransparency=wdT})

				lW.Visible = true

				t1:Play(); t2:Play(); t3:Play(); t4:Play(); t5:Play()

			end

			data.bl = utilities:blur(lW)	
			lW.Visible = true
		end,

		hide = function(self, window) -- window: The actual interface, the main window where user interacts with the library
			local dur = conf.minLoadTime or  3

			if tick()-data.t <= dur then
				task.wait(math.clamp( ( dur - (tick()-data.t) ),0,dur+5))
			end

			if flags[lib.Enum.Flags.NoAnimations] == true then
				data.w.Visible = false
				window.Visible = true
			else
				local t1 = tweenService:Create(data.w,TweenInfo.new(0.3,Enum.EasingStyle.Circular,Enum.EasingDirection.Out),{Size=window.Size,Position=window.Position})
				local t2 = tweenService:Create(winAR,t1.TweenInfo,{AspectRatio=window:FindFirstChildWhichIsA("UIAspectRatioConstraint").AspectRatio})

				for i, v in pairs(data.w:GetDescendants()) do
					if v:IsA("TextLabel") then
						v.Transparency = 1
						--tweenService:Create(v,TweenInfo.new(t1.TweenInfo.Time*1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{TextTransparency=1}):Play()
					end
				end

				t1:Play()
				t2:Play()
				t1.Completed:Wait()
				window.Visible = true
				data.w.Visible = false
			end
		end,

		destroy = function()
			data.bl.Update()
			data.bl:Destroy()
			data.w:Destroy()
		end,

		data = {
			get = function(self)
				return data
			end,

			set = function(self,new)
				data = new
			end,
		}
	}
end

function sc:Window(conf, flags)
	local lib = self.lib
	local utilities = lib._internal.utilities

	local style = nil or lib.Enum.Style.Custom

	for i, v in pairs(lib.Enum.Style) do
		if flags[v] ~= nil then
			style = v
			break
		end
	end

	local loading_window = nil

	if conf ~= nil and conf.loadingWindow ~= nil and conf.loadingWindow.Enabled == true then
		loading_window = self:LWindow(conf.loadingWindow,flags)	
		loading_window:show()
	end

	local window = utilities:Frame()
	window.Visible = false
	window.Parent = lib._internal.screen

	window.Size = utilities:table_to_UDIM2({0.506, 0},{0.651, 0})
	window.Position = UDim2.new(0.5,0,0.5,0)
	window.AnchorPoint = Vector2.new(0.5,0.5)
	window.ZIndex = -2

	utilities:blur(window)
	utilities:UiCorner({0.036, 0})
	local winAR = utilities:UiAspectRatio(1.561)
	winAR.Parent = window

	local ustr = utilities:UiStroke(window)
	ustr.Color = utilities:get_color(lib.theme.stroke_primary)[1]
	ustr.Transparency = utilities:get_color(lib.theme.stroke_primary)[2]
	ustr.Thickness = 2

	window.BackgroundTransparency = utilities:get_color(lib.theme.bg_primary)[2]
	window.BackgroundColor3 = utilities:get_color(lib.theme.bg_primary)[1]
	lib._internal.latestWindow = window
	lib._internal.latestContainer = window

	local win_dec = utilities:Frame()
	win_dec.ZIndex = -1
	win_dec.Parent = window
	win_dec.Size = utilities:table_to_UDIM2({1, 0},{1, 0})
	utilities:UiCorner({0.036,0},win_dec)
	local uigrad_dec = utilities:UiGradient(win_dec)
	uigrad_dec.Rotation = -90
	uigrad_dec.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
	uigrad_dec.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0.75)})

	local topbar = utilities:Frame()

	topbar.ZIndex = 9999999

	topbar.Parent = window
	topbar.Size = utilities:table_to_UDIM2({1, 0},{0.071, 0})
	topbar.Position = utilities:table_to_UDIM2({0, 0},{0, 0})
	topbar.BackgroundTransparency = 1
	
	if flags[lib.Enum.Flags.NoDrag] ~= true then
		utilities:add_drag(topbar,window)
	end

	local topbar_button_holder = utilities:Frame()

	topbar_button_holder.ZIndex = 9999999
	topbar_button_holder.Parent = topbar
	topbar_button_holder.Size = utilities:table_to_UDIM2({0.194, 0},{1, 0})
	topbar_button_holder.BackgroundTransparency = 1

	local x_btn = utilities:Button(topbar_button_holder)
	x_btn.BackgroundColor3 = Color3.fromRGB(252, 82, 85)
	x_btn.Text = ""
	x_btn.ZIndex = 9999999
	x_btn.LayoutOrder = 1
	x_btn.Size = utilities:table_to_UDIM2({0.5, 0},{0.5, 0})
	utilities:UiAspectRatio(1,x_btn)
	utilities:UiCorner({1,0},x_btn)

	local fullscreen_btn = utilities:Button(topbar_button_holder)
	fullscreen_btn.BackgroundColor3 = Color3.fromRGB(44, 191, 77)
	fullscreen_btn.Text = ""
	fullscreen_btn.Size = utilities:table_to_UDIM2({0.5, 0},{0.5, 0})
	fullscreen_btn.LayoutOrder = 3
	fullscreen_btn.ZIndex = 9999999
	utilities:UiAspectRatio(1,fullscreen_btn)
	utilities:UiCorner({1,0},fullscreen_btn)

	local minimize_btn = utilities:Button(topbar_button_holder)
	minimize_btn.BackgroundColor3 = Color3.fromRGB(245, 193, 7)
	minimize_btn.LayoutOrder = 2
	minimize_btn.Text = ""
	minimize_btn.Size = utilities:table_to_UDIM2({0.5, 0},{0.5, 0})
	utilities:UiAspectRatio(1,minimize_btn)
	utilities:UiCorner({1,0},minimize_btn)
	minimize_btn.ZIndex = 9999999

	local padding = utilities:UiPadding(topbar_button_holder)
	padding.PaddingLeft = UDim.new(0.06, 0)
	padding.PaddingTop = UDim.new(0.1, 0)

	local ULL = utilities:UiListLayout(topbar_button_holder)
	ULL.VerticalAlignment = Enum.VerticalAlignment.Center
	ULL.Padding = UDim.new(0.06, 0)
	ULL.FillDirection = Enum.FillDirection.Horizontal
	ULL.SortOrder = Enum.SortOrder.LayoutOrder

	local ecInstance = ec.new(lib)

	if flags[lib.Enum.Style.Dashboard] == true then -- dashboard (style): generates sidebar and other stuff
		local sidebar = utilities:Frame()

		sidebar.BackgroundTransparency = utilities:get_color(lib.theme.bg_secondary)[2]
		sidebar.BackgroundColor3 = utilities:get_color(lib.theme.bg_secondary)[1]

		sidebar.Parent = window
		sidebar.Size = utilities:table_to_UDIM2({0.294, 0},{1.002, 0})
		sidebar.Position = utilities:table_to_UDIM2({0, 0},{0, 0})

		local gradUi = utilities:UiGradient(sidebar)
		gradUi.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))})
		gradUi.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.381),NumberSequenceKeypoint.new(1,0.681)})

		utilities:UiCorner({0.1,0},sidebar)

		utilities:UiAspectRatio(0.458,sidebar)

		utilities:UiPadding(sidebar).PaddingTop = UDim.new(0.1,0)

		local lsa = utilities:UiListLayout(sidebar)
		lsa.HorizontalAlignment = Enum.HorizontalAlignment.Center
		lsa.Padding = UDim.new(0.05,0)

		if conf.Logo ~= nil then
			local logo = utilities:Image(conf.Logo)
			logo.Size = utilities:table_to_UDIM2({0.45, 0},{0.45, 0})
			
			utilities:UiAspectRatio(1).Parent = logo
			
			logo.Parent = sidebar
		end

		lib._internal.style = {}
		lib._internal.style.sidebar = sidebar
		lib._internal.style.sidebar_sel = nil

		lib._internal.style.contentHolder = utilities:Frame()
		lib._internal.style.contentHolder.Parent = window
		lib._internal.style.contentHolder.Size = UDim2.new(1-sidebar.Size.X.Scale,0,1,0)
		lib._internal.style.contentHolder.Position = UDim2.new(sidebar.Size.X.Scale,0,0,0)
		lib._internal.style.contentHolder.BackgroundTransparency = 1
	else
		-- creates content holder

		lib._internal.style.contentHolder = utilities:Frame()
		lib._internal.style.contentHolder.Parent = window
		lib._internal.style.contentHolder.Size = UDim2.new(1,0,1,0)
		lib._internal.style.contentHolder.Position = UDim2.new(0,0,0,0)
		lib._internal.style.contentHolder.BackgroundTransparency = 1

		lib._internal.style.content = lib._internal.style.contentHolder

		ecInstance.Parent = window
	end

	if loading_window ~= nil then
		loading_window:hide(window)
		loading_window:destroy()
	end

	window.Visible = true	

	return ecInstance
end

-- lib management

function lib.init(data,...)
	local logger = logger.new("init")

	local arg_table = {...}
	local data = data or {}

	local self = setmetatable({},lib)
	self._internal = {}

	self.theme = lib.themes.dark

	self._internal.latestObject = nil
	self._internal.latestWindow = nil
	self._internal.latestContainer = nil
	self._internal.latestTab = nil
	self._internal.cache = {}
	self.Enum._lookup = {}

	self._internal.debug = data.debug or false

	-- sets up validation layer thingies

	for i, v in pairs(self.Enum.Flags) do
		self.Enum._lookup[v] = 0
	end

	for i, v in pairs(self.Enum.Style) do
		self.Enum._lookup[v] = 1
	end

	local cache = self._internal.cache
	cache.args = {}

	local function hasArg(arg)

		local has = crypt.hash(arg)

		if cache.args[has] ~= nil then
			return cache.args[has]
		end

		for i = 1,#arg_table do
			if arg_table[i] == arg then
				cache.args[has] = true
				return true
			end
		end

		cache.args[has] = false
		return false
	end

	self._internal.screen = Instance.new("ScreenGui")

	if data.secure == false then

		if self._internal.debug == true then
			local hasBeenParented = false
			xpcall(function()
				self._internal.screen.Parent = game:GetService("CoreGui")

				if self._internal.screen.Parent == nil then
					hasBeenParented = false
				else
					hasBeenParented = true
				end
			end, function()
				hasBeenParented = false
			end)

			self._internal.screen.Parent = game:GetService("Players").LocalPlayer.PlayerGui

			if hasBeenParented == false and runService:IsStudio() == false then
				logger:info("Debug enabled, unable to access CoreGui, placing the screen in LocalPlayer.PlayerGui")
			end
		else
			pcall(function()
				self._internal.screen.Parent = game:GetService("CoreGui")
			end)
		end

	else
		pcall(function()
			self._internal.screen.Parent = game:GetService("CoreGui")
		end)

		utilities.blur = function()
			return {
				Destroy = function() end,
				Update = function() end
			}	
		end
	end

	lib.init = function()
		logger.new("init"):warn("The library is already initialized")
		return self
	end

	self._internal.utilities = utilities.new(self)

	return self
end

function lib:Window(conf, ...)
	local other = {} -- flags & styles
	local args = {...}
	local logger = logger.new("Window")

	if typeof(conf) ~= "table" then
		table.insert(args,conf)
		conf = nil
	end

	local c = 0;

	for i, v in pairs(args) do
		if self.Enum._lookup[v] ~= nil then
			if self._internal.debug == true and self.Enum._lookup[v] == 1 then
				c += 1;
			end
			other[v] = true
		elseif self._internal.debug == true then
			logger:warn(`{tostring(v)} is not a valid Enum`)
		end
	end

	if c > 1 then
		logger:warn("Multiple styles detected, expect unexpected behavior")
	end

	self._internal.flags = other -- <-- ADD THIS

	return sc.new(self):Window(conf, other)
end

return lib
