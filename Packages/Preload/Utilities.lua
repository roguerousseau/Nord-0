local userInputService = game:GetService("UserInputService")
local lightningService = game:GetService("Lighting")

local utilities = {}
utilities.__index = utilities

function utilities.new(lib)
	local self = setmetatable({},utilities)

	self.lib = lib

	return self
end

function utilities:Image(Asset)
	local d = Instance.new("ImageLabel")

	if string.lower(string.sub(Asset,1,8)) ~= "rbxasset" then
		Asset = "rbxassetid://"..Asset
	end

	d.Image = Asset
	d.BackgroundTransparency = 1

	return d
end

function utilities:getTextSize(baseSize)
	baseSize = math.floor(baseSize*1.5)
	return math.round(baseSize*(game:GetService("Workspace").CurrentCamera.ViewportSize.Y/1080))
end

function utilities:newFont(Weight,Style)

	local lib = self.lib

	if lib.theme.Font == "Inter" then
		return Font.new(Font.fromId(12187365364).Family,Weight,Style)	
	end

	return Font.new(Font.fromEnum(lib.theme.Font),Weight,Style)
end

function utilities:Frame()

	local lib = self.lib

	local a = Instance.new("Frame", lib._internal.latestObject)
	lib._internal.latestObject = a
	return a	
end

function utilities:Label(Text,Parent)
	local lib = self.lib

	local a = Instance.new("TextLabel",Parent or lib._internal.latestObject)
	lib._internal.latestObject = a

	a.Text = Text or "Placeholder"
	a.FontFace = self:newFont(Enum.FontWeight.Medium,Enum.FontStyle.Normal)
	a.RichText = true
	a.TextWrapped = true

	return a
end

function utilities:UiGradient(Parent)

	local lib = self.lib

	local a = Instance.new("UIGradient",Parent or lib._internal.latestObject)
	return a		
end

function utilities:UiAspectRatio(ratio,parent)

	local lib = self.lib

	local parent = parent or lib._internal.latestObject
	local d = Instance.new("UIAspectRatioConstraint",parent)
	d.AspectRatio = ratio

	return d
end

function utilities:UiCorner(t1,parent)

	local lib = self.lib

	local parent = parent or lib._internal.latestObject
	local d = Instance.new("UICorner",parent)
	d.CornerRadius = UDim.new(t1[1],t1[2])

	return d
end

function utilities:Button(parent)

	local lib = self.lib

	local parent = parent or lib._internal.latestObject

	local d = Instance.new("TextButton",parent)
	d.TextScaled = true
	d.FontFace = self:newFont(Enum.FontWeight.Medium,Enum.FontStyle.Normal)
	d.AutoButtonColor = false

	return d
end

function utilities:UiListLayout(Parent)

	local lib = self.lib

	local d = Instance.new("UIListLayout",Parent or lib._internal.latestObject)
	return d
end

function utilities:UiPadding(Parent)

	local lib = self.lib

	local d = Instance.new("UIPadding",Parent or lib._internal.latestObject)

	return d	
end

function utilities:UiStroke(Parent)

	local lib = self.lib

	local d = Instance.new("UIStroke",Parent or lib._internal.latestObject)
	return d
end

function utilities:ScrollingFrame(Parent)

	local lib = self.lib

	local d = Instance.new("ScrollingFrame",Parent or lib._internal.latestObject)
	d.AutomaticCanvasSize = Enum.AutomaticSize.Y
	d.CanvasSize = UDim2.new(1,0,1.1,0)
	d.BackgroundTransparency = 1
	d.ScrollingDirection = Enum.ScrollingDirection.Y
	d.ScrollBarImageTransparency = 1
	return d
end

-- other utilities

function utilities:add_drag(activator,target)

	local dragging = false
	local offset = Vector2.new()

	local function mouseScale(parent)
		local m = userInputService:GetMouseLocation()
		local p, s = parent.AbsolutePosition, parent.AbsoluteSize
		return Vector2.new(
			(m.X - p.X) / s.X,
			(m.Y - p.Y) / s.Y
		)
	end

	activator.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true

			local parent = target.Parent
			local mouse = mouseScale(parent)

			offset = mouse - Vector2.new(
				target.Position.X.Scale,
				target.Position.Y.Scale
			)
		end
	end)

	activator.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	userInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

		local parent = target.Parent
		local mouse = mouseScale(parent)

		local pos = mouse - offset

		target.Position = UDim2.new(pos.X, 0, pos.Y, 0)
	end)

end

function utilities:table_to_UDIM2(t1,t2)
	return UDim2.new(t1[1],t1[2],t2[1],t2[2])
end

function utilities:get_color(tbl)
	return {Color3.fromRGB(tbl[1],tbl[2],tbl[3]),tbl[4] or 0}
end

function utilities:blur(to_blur)
	local camera			= workspace.CurrentCamera

	local BLUR_SIZE         = Vector2.new(10, 10)
	local PART_SIZE         = 0.01
	local PART_TRANSPARENCY = 1 - 1e-7
	local START_INTENSITY	= 1

	local BLUR_OBJ          = Instance.new("DepthOfFieldEffect")
	BLUR_OBJ.FarIntensity   = 0
	BLUR_OBJ.NearIntensity  = START_INTENSITY
	BLUR_OBJ.FocusDistance  = 0.25
	BLUR_OBJ.InFocusRadius  = 0
	BLUR_OBJ.Parent         = lightningService

	local PartsList         = {}
	local BlursList         = {}
	local BlurObjects       = {}
	local BlurredGui        = {}

	BlurredGui.__index      = BlurredGui

	local function rayPlaneIntersect(planePos, planeNormal, rayOrigin, rayDirection)
		local n = planeNormal
		local d = rayDirection
		local v = rayOrigin - planePos

		local num = n.x*v.x + n.y*v.y + n.z*v.z
		local den = n.x*d.x + n.y*d.y + n.z*d.z
		local a = -num / den

		return rayOrigin + a * rayDirection, a
	end

	local function rebuildPartsList()
		PartsList = {}
		BlursList = {}
		for blurObj, part in pairs(BlurObjects) do
			table.insert(PartsList, part)
			table.insert(BlursList, blurObj)
		end
	end

	function BlurredGui.new(frame, shape)
		local blurPart        = Instance.new("Part")
		blurPart.Size         = Vector3.new(1, 1, 1) * 0.01
		blurPart.Anchored     = true
		blurPart.CanCollide   = false
		blurPart.CanTouch     = false
		blurPart.Material     = Enum.Material.Glass
		blurPart.Transparency = PART_TRANSPARENCY
		blurPart.Parent       = workspace.CurrentCamera

		local mesh
		if (shape == "Rectangle") then
			mesh        = Instance.new("BlockMesh")
			mesh.Parent = blurPart
		elseif (shape == "Oval") then
			mesh          = Instance.new("SpecialMesh")
			mesh.MeshType = Enum.MeshType.Sphere
			mesh.Parent   = blurPart
		end

		local ignoreInset = false
		local currentObj  = frame

		while true do
			currentObj = currentObj.Parent

			if (currentObj and currentObj:IsA("ScreenGui")) then
				ignoreInset = currentObj.IgnoreGuiInset
				break
			elseif (currentObj == nil) then
				break
			end
		end

		local new = setmetatable({
			Frame          = frame;
			Part           = blurPart;
			Mesh           = mesh;
			IgnoreGuiInset = ignoreInset;
		}, BlurredGui)

		BlurObjects[new] = blurPart
		rebuildPartsList()

		game:GetService("RunService"):BindToRenderStep("...", Enum.RenderPriority.Camera.Value + 1, function()
			blurPart.CFrame = camera.CFrame * CFrame.new(0,0,0)
			BlurredGui.updateAll()
		end)
		return new
	end

	local function updateGui(blurObj)
		if (not blurObj.Frame.Visible) then
			blurObj.Part.Transparency = 1
			return
		end

		local camera = workspace.CurrentCamera
		local frame  = blurObj.Frame
		local part   = blurObj.Part
		local mesh   = blurObj.Mesh

		part.Transparency = PART_TRANSPARENCY

		local corner0 = frame.AbsolutePosition + BLUR_SIZE
		local corner1 = corner0 + frame.AbsoluteSize - BLUR_SIZE*2
		local ray0, ray1

		if (blurObj.IgnoreGuiInset) then
			ray0 = camera:ViewportPointToRay(corner0.X, corner0.Y, 1)
			ray1 = camera:ViewportPointToRay(corner1.X, corner1.Y, 1)
		else
			ray0 = camera:ScreenPointToRay(corner0.X, corner0.Y, 1)
			ray1 = camera:ScreenPointToRay(corner1.X, corner1.Y, 1)
		end

		local planeOrigin = camera.CFrame.Position + camera.CFrame.LookVector * (0.05 - camera.NearPlaneZ)
		local planeNormal = camera.CFrame.LookVector
		local pos0 = rayPlaneIntersect(planeOrigin, planeNormal, ray0.Origin, ray0.Direction)
		local pos1 = rayPlaneIntersect(planeOrigin, planeNormal, ray1.Origin, ray1.Direction)

		local pos0 = camera.CFrame:PointToObjectSpace(pos0)
		local pos1 = camera.CFrame:PointToObjectSpace(pos1)

		local size   = pos1 - pos0
		local center = (pos0 + pos1)/2

		mesh.Offset = center
		mesh.Scale  = size / PART_SIZE
	end

	function BlurredGui.updateAll()

		for i = 1, #BlursList do
			updateGui(BlursList[i])
		end

		local cframes = table.create(#BlursList, workspace.CurrentCamera.CFrame)
		workspace:BulkMoveTo(PartsList, cframes, Enum.BulkMoveMode.FireCFrameChanged)

		BLUR_OBJ.FocusDistance = 0.25 - camera.NearPlaneZ
	end

	function BlurredGui:Destroy()
		self.Part:Destroy()
		BlurObjects[self] = nil
		rebuildPartsList()
	end

	local self = BlurredGui.new(to_blur, "Rectangle")

	BlurredGui.updateAll()

	return {
		Destroy = function()
			BlurredGui.Destroy(self)
		end,
		Update = function()
			BlurredGui.updateAll()
		end,
	}
end

return utilities
