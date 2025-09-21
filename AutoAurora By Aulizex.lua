local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TotemGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -60, 0.5, 30)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 20
ToggleButton.Text = "Totem: OFF"
ToggleButton.Parent = ScreenGui

local running = false
ToggleButton.MouseButton1Click:Connect(function()
	running = not running
	ToggleButton.Text = running and "Totem: ON" or "Totem: OFF"
end)

-- ชื่อกลางจอ Aulizex
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 200, 0, 40)
nameLabel.Position = UDim2.new(0.5, -100, 0.5, -20)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(128, 0, 255)
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextSize = 120
nameLabel.Text = "Aulizex"
nameLabel.Parent = ScreenGui
nameLabel.TextTransparency = 1

-- ฟังก์ชันใช้ Totem แบบเรียก Activate ของ Tool (เหมือนต้นฉบับ)
local function useTotem(totemName)
	local totem = backpack:FindFirstChild(totemName) or player.Character:FindFirstChild(totemName)
	if not totem then
		warn(totemName .. " ไม่พบ!")
		return
	end

	-- Equip Tool
	player.Character.Humanoid:EquipTool(totem)
	wait(0.2)

	-- เรียก RemoteEvent ของ Tool ตรง ๆ
	local remote = totem:FindFirstChild("Activate")
	if remote and remote:IsA("RemoteEvent") then
		for i = 1, math.random(3,5) do
			remote:FireServer()
			wait(math.random(100,500)/1000)
		end
	else
		-- fallback สำหรับเกมที่ใช้ LocalScript ของ Tool
		for i = 1, math.random(3,5) do
			totem:Activate() -- ใช้วิธีนี้เหมือนผู้เล่นกดใช้เอง
			wait(math.random(100,500)/1000)
		end
	end
end

-- Loop Totem แบบสลับ + ดีเลย์สุ่ม
spawn(function()
	local totems = {"Sundial Totem", "Aurora Totem"}
	local index = 1
	while true do
		if running then
			useTotem(totems[index])
			wait(math.random(1,5))
			index = index + 1
			if index > #totems then
				index = 1
			end
		else
			wait(1)
		end
	end
end)

-- ทำให้ลาก GUI ได้
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
	                                 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = ToggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

ToggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		update(dragInput)
	end
end)

-- เฟดชื่อกลางจอ
spawn(function()
	local transparency = 1
	local increment = -0.02
	while true do
		transparency = transparency + increment
		if transparency <= 0 then
			transparency = 0
			increment = 0.02
		elseif transparency >= 1 then
			transparency = 1
			increment = -0.02
		end
		nameLabel.TextTransparency = transparency
		wait(0.03)
	end
end)
