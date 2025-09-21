-- LocalScript inside StarterPlayerScripts
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local mouse = player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TotemGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 200, 0, 40)
nameLabel.Position = UDim2.new(0.5, -100, 0.5, -20)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(128, 0, 255)
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextSize = 100
nameLabel.Text = "Aulizex"
nameLabel.Parent = ScreenGui

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

local function useTotem(totemName)
	local totem = backpack:FindFirstChild(totemName)
	if not totem then
		warn(totemName .. " ไม่พบในกระเป๋า!")
		return
	end
	player.Character.Humanoid:EquipTool(totem)
	local remote = totem:FindFirstChild("Activate") or totem:FindFirstChildWhichIsA("RemoteEvent")
	if remote then
		remote:FireServer()
	else
		mouse1click()
	end
end

spawn(function()
	while true do
		if running then
			useTotem("Sundial Totem")
			wait(18)
			useTotem("Aurora Totem")
			wait(18)
		else
			wait(1)
		end
	end
end)

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
