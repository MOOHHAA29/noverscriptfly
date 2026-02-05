do 
	local _G = (getfenv and getfenv()) or _ENV or _G
	local __services = {
		Players = game:GetService("Players"),
		UIS = game:GetService("UserInputService"),
		RunService = game:GetService("RunService"),
		Workspace = game:GetService("Workspace")
	}

	local __player = __services.Players.LocalPlayer
	local __playerGui = __player:WaitForChild("PlayerGui")

	if not __player.Character then
		__player.CharacterAdded:Wait()
	end

	local __screenGui = Instance.new("ScreenGui")
	__screenGui.Name = "BlandFlyUI"
	__screenGui.Parent = __playerGui
	__screenGui.ResetOnSpawn = false

	local __main = Instance.new("Frame")
	__main.Size = UDim2.new(0, 180, 0, 180)
	__main.Position = UDim2.new(0, 10, 0, 10)
	__main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	__main.BorderSizePixel = 0

	local __corner = Instance.new("UICorner")
	__corner.CornerRadius = UDim.new(0, 8)
	__corner.Parent = __main

	local __title = Instance.new("TextLabel")
	__title.Size = UDim2.new(1, 0, 0, 30)
	__title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	__title.Text = "Nover Fly Script"
	__title.TextColor3 = Color3.new(1, 1, 1)
	__title.TextSize = 14
	__title.Font = Enum.Font.GothamBold
	__title.Parent = __main

	local __titleCorner = Instance.new("UICorner")
	__titleCorner.CornerRadius = UDim.new(0, 8)
	__titleCorner.Parent = __title

	local __close = Instance.new("TextButton")
	__close.Size = UDim2.new(0, 20, 0, 20)
	__close.Position = UDim2.new(1, -25, 0, 5)
	__close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	__close.Text = "X"
	__close.TextColor3 = Color3.new(1, 1, 1)
	__close.TextSize = 12
	__close.Font = Enum.Font.GothamBold
	__close.Parent = __title
	__close.MouseButton1Click:Connect(function()
		__screenGui:Destroy()
	end)

	local __flyBtn = Instance.new("TextButton")
	__flyBtn.Size = UDim2.new(0.85, 0, 0, 35)
	__flyBtn.Position = UDim2.new(0.075, 0, 0, 40)
	__flyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	__flyBtn.Text = "FLIGHT: OFF"
	__flyBtn.TextColor3 = Color3.new(1, 1, 1)
	__flyBtn.TextSize = 13
	__flyBtn.Font = Enum.Font.GothamBold
	__flyBtn.Parent = __main

	local __flyCorner = Instance.new("UICorner")
	__flyCorner.CornerRadius = UDim.new(0, 6)
	__flyCorner.Parent = __flyBtn

	local __speedBox = Instance.new("TextBox")
	__speedBox.Size = UDim2.new(0.85, 0, 0, 30)
	__speedBox.Position = UDim2.new(0.075, 0, 0, 85)
	__speedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	__speedBox.Text = "50"
	__speedBox.TextColor3 = Color3.new(1, 1, 1)
	__speedBox.TextSize = 14
	__speedBox.Font = Enum.Font.Gotham
	__speedBox.PlaceholderText = "Speed (1-10000)"
	__speedBox.TextXAlignment = Enum.TextXAlignment.Center
	__speedBox.Parent = __main

	local __boxCorner = Instance.new("UICorner")
	__boxCorner.CornerRadius = UDim.new(0, 6)
	__boxCorner.Parent = __speedBox

	local __noclipBtn = Instance.new("TextButton")
	__noclipBtn.Size = UDim2.new(0.85, 0, 0, 35)
	__noclipBtn.Position = UDim2.new(0.075, 0, 0, 125)
	__noclipBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
	__noclipBtn.Text = "NOCLIP: OFF"
	__noclipBtn.TextColor3 = Color3.new(1, 1, 1)
	__noclipBtn.TextSize = 13
	__noclipBtn.Font = Enum.Font.GothamBold
	__noclipBtn.Parent = __main

	local __noclipCorner = Instance.new("UICorner")
	__noclipCorner.CornerRadius = UDim.new(0, 6)
	__noclipCorner.Parent = __noclipBtn

	local __flyState = false
	local __noclipState = false
	local __speedValue = 50
	local __flyLoop = nil
	local __noclipLoop = nil

	__speedBox:GetPropertyChangedSignal("Text"):Connect(function()
		local __text = __speedBox.Text
		if __text == "" then return end
		local __num = tonumber(__text)
		if __num and __num >= 1 then
			__speedValue = math.min(__num, 10000)
		end
	end)

	local function __toggleFlight()
		if __flyState then
			__flyState = false
			__flyBtn.Text = "FLIGHT: OFF"
			__flyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

			if __flyLoop then
				__flyLoop:Disconnect()
				__flyLoop = nil
			end

			local __char = __player.Character
			if __char then
				local __hum = __char:FindFirstChildOfClass("Humanoid")
				if __hum then
					__hum.PlatformStand = false
				end

				local __root = __char:FindFirstChild("HumanoidRootPart") or __char.PrimaryPart
				if __root then
					for _, __obj in pairs(__root:GetChildren()) do
						if __obj:IsA("BodyVelocity") or __obj:IsA("BodyGyro") then
							__obj:Destroy()
						end
					end
				end
			end
		else
			local __num = tonumber(__speedBox.Text)
			if __num and __num >= 1 then
				__speedValue = math.min(__num, 10000)
			end

			local __char = __player.Character
			if not __char then return end

			local __root = __char:FindFirstChild("HumanoidRootPart") or __char.PrimaryPart
			if not __root then return end

			__flyState = true
			__flyBtn.Text = "FLIGHT: ON"
			__flyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)

			local __hum = __char:FindFirstChildOfClass("Humanoid")
			if __hum then
				__hum.PlatformStand = true
			end

			local __bodyVel = Instance.new("BodyVelocity")
			__bodyVel.Velocity = Vector3.new(0, 0, 0)
			__bodyVel.MaxForce = Vector3.new(40000, 40000, 40000)
			__bodyVel.P = 1250
			__bodyVel.Parent = __root

			local __bodyGyro = Instance.new("BodyGyro")
			__bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
			__bodyGyro.CFrame = __root.CFrame
			__bodyGyro.P = 1000
			__bodyGyro.D = 50
			__bodyGyro.Parent = __root

			__flyLoop = __services.RunService.RenderStepped:Connect(function()
				if not __flyState or not __char or not __root then return end

				local __cam = __services.Workspace.CurrentCamera
				local __look = __cam.CFrame.LookVector
				local __right = __cam.CFrame.RightVector
				local __move = Vector3.new(0, 0, 0)

				if __services.UIS:IsKeyDown(Enum.KeyCode.W) then
					__move = __move + __look
				end
				if __services.UIS:IsKeyDown(Enum.KeyCode.S) then
					__move = __move - __look
				end
				if __services.UIS:IsKeyDown(Enum.KeyCode.A) then
					__move = __move - __right
				end
				if __services.UIS:IsKeyDown(Enum.KeyCode.D) then
					__move = __move + __right
				end
				if __services.UIS:IsKeyDown(Enum.KeyCode.Space) then
					__move = __move + Vector3.new(0, 1, 0)
				end
				if __services.UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
					__move = __move + Vector3.new(0, -1, 0)
				end

				if __move.Magnitude > 0 then
					__move = __move.Unit * __speedValue
					__bodyVel.Velocity = __move
				else
					__bodyVel.Velocity = Vector3.new(0, 0, 0)
				end

				__bodyGyro.CFrame = CFrame.new(__root.Position, __root.Position + __look)
			end)
		end
	end

	local function __toggleNoclip()
		if __noclipState then
			__noclipState = false
			__noclipBtn.Text = "NOCLIP: OFF"
			__noclipBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)

			if __noclipLoop then
				__noclipLoop:Disconnect()
				__noclipLoop = nil
			end

			local __char = __player.Character
			if __char then
				for _, __part in pairs(__char:GetDescendants()) do
					if __part:IsA("BasePart") then
						__part.CanCollide = true
					end
				end
			end
		else
			__noclipState = true
			__noclipBtn.Text = "NOCLIP: ON"
			__noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)

			__noclipLoop = __services.RunService.Stepped:Connect(function()
				if not __noclipState then return end

				local __char = __player.Character
				if __char then
					for _, __part in pairs(__char:GetDescendants()) do
						if __part:IsA("BasePart") then
							__part.CanCollide = false
						end
					end
				end
			end)
		end
	end
	__flyBtn.MouseButton1Click:Connect(__toggleFlight)
	__noclipBtn.MouseButton1Click:Connect(__toggleNoclip)

	__services.UIS.InputBegan:Connect(function(__input)
		if __input.KeyCode == Enum.KeyCode.F then
			__toggleFlight()
		elseif __input.KeyCode == Enum.KeyCode.N then
			__toggleNoclip()
		elseif __input.KeyCode == Enum.KeyCode.H then
			__main.Visible = not __main.Visible
		end
	end)
	local __dragging = false
	local __dragStart, __startPos
	__title.InputBegan:Connect(function(__input)
		if __input.UserInputType == Enum.UserInputType.MouseButton1 then
			__dragging = true
			__dragStart = __input.Position
			__startPos = __main.Position
		end
	end)
	__services.UIS.InputChanged:Connect(function(__input)
		if __dragging and __input.UserInputType == Enum.UserInputType.MouseMovement then
			local __delta = __input.Position - __dragStart
			__main.Position = UDim2.new(
				__startPos.X.Scale,
				__startPos.X.Offset + __delta.X,
				__startPos.Y.Scale,
				__startPos.Y.Offset + __delta.Y
			)
		end
	end)
	__services.UIS.InputEnded:Connect(function(__input)
		if __input.UserInputType == Enum.UserInputType.MouseButton1 then
			__dragging = false
		end
	end)
	__main.Parent = __screenGui
end
