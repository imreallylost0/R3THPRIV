local HttpService = game:GetService("HttpService")

local Interface_Manager = {} do
	Interface_Manager.Folder = "R3TH PRIV"
    Interface_Manager.Settings = {
        Theme = "Darker",
        Acrylic = false,
        Transparency = false,
		Toggle_UI = true,
		Auto_Minimize = false,
        MenuKeybind = "LeftControl"
    }

    function Interface_Manager:SetFolder(Folder)
		self.Folder = Folder
		self:BuildFolderTree()
	end

    function Interface_Manager:SetLibrary(Library)
		self.Library = Library
	end

    function Interface_Manager:BuildFolderTree()
		local Paths = {}

		local Parts = self.Folder:split("/")
		for i = 1, #Parts do
			Paths[#Paths + 1] = table.concat(Parts, "/", 1, i)
		end

		table.insert(Paths, self.Folder)
		table.insert(Paths, self.Folder .. "/settings")

		for i = 1, #Paths do
			local String = Paths[i]
			if not isfolder(String) then
				makefolder(String)
			end
		end
	end

    function Interface_Manager:SaveSettings()
        writefile(self.Folder .. "/options.json", HttpService:JSONEncode(Interface_Manager.Settings))
    end

    function Interface_Manager:LoadSettings()
        local Path = self.Folder .. "/options.json"
        if isfile(Path) then
            local Success, Decoded = pcall(HttpService.JSONDecode, HttpService, readfile(Path))

            if Success then
                for i, v in next, Decoded do
                    Interface_Manager.Settings[i] = v
                end
            end
        end
    end

    function Interface_Manager:BuildInterfaceSection(Tab)
        assert(self.Library, "InterfaceManager.Library needs to be set.")
		local Library = self.Library
        local Settings = Interface_Manager.Settings

		function Toggle(Toggle)
			if Toggle then
				Toggle = Instance.new("ScreenGui")
				Toggle.Name = "Toggle"
				Toggle.Parent = game:GetService("CoreGui")
			
				local Button = Instance.new("TextButton")
				Button.TextTransparency = 1
				Button.BorderSizePixel = 0
				Button.Position = UDim2.new(0, 0, 0, 0)
				Button.Size = UDim2.new(0.031, 0, 0.06, 0)
				Button.Parent = Toggle
			
				local Image = Instance.new("ImageLabel")
				Image.Name = "ImageLabel"
				Image.BackgroundTransparency = 1
				Image.Size = UDim2.new(1, 0, 1, 0)
				Image.Image = "rbxassetid://8271342298"
				Image.Parent = Button
			
				local Corner = Instance.new("UICorner")
				Corner.CornerRadius = UDim.new(1, 0)
				Corner.Parent = Button
				Corner:Clone().Parent = Image

				local function Update(Input)
					local Delta = Input.Position - Start
					Button.Position = UDim2.new(Position.X.Scale, Position.X.Offset + Delta.X, Position.Y.Scale, Position.Y.Offset + Delta.Y)
				end
			
				local Toggle = false
				Button.InputBegan:Connect(function(input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = true
						Start = Input.Position
						Position = Button.Position
						Input.Changed:Connect(function()
							if Input.UserInputState == Enum.UserInputState.End then
								Dragging = false
							end
						end)
					end
				end)
			
				Button.InputChanged:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
						DragInput = Input
					end
				end)
			
				game:GetService("UserInputService").InputChanged:Connect(function(Input)
					if Input == DragInput and Dragging then
						Update(Input)
					end
				end)
			
				Button.MouseButton1Click:Connect(function()
					Toggle = not Toggle
					if Toggle then
						Library.Window:Minimize()
						Toggle = false
					end
				end)
			else
				if Toggle then
					Toggle:Destroy()
				end
			end
		end

        Interface_Manager:LoadSettings()

		local Section = Tab:AddSection("Interface")

		local InterfaceTheme = Section:AddDropdown("InterfaceTheme", {
			Title = "Theme",
			Values = Library.Themes,
			Default = Settings.Theme,
			Callback = function(Value)
				Library:SetTheme(Value)
                Settings.Theme = Value
                Interface_Manager:SaveSettings()
			end
		})

        InterfaceTheme:SetValue(Settings.Theme)
	
		if Library.UseAcrylic then
			Section:AddToggle("AcrylicToggle", {
				Title = "Acrylic",
				Description = "The blurred background requires graphic quality 8 or higher.",
				Default = Settings.Acrylic,
				Callback = function(Value)
					Library:ToggleAcrylic(Value)
                    Settings.Acrylic = Value
                    Interface_Manager:SaveSettings()
				end
			})
		end
	
		Section:AddToggle("Transparency", {
			Title = "Transparency",
			Description = "Makes the interface transparent.",
			Default = Settings.Transparency,
			Callback = function(Value)
				Library:ToggleTransparency(Value)
				Settings.Transparency = Value
                Interface_Manager:SaveSettings()
			end
		})

		Section:AddToggle("Toggle UI", {
			Title = "Toggle UI",
			Default = Settings.Toggle_UI,
			Callback = function(Value)
				Settings.Toggle_UI = Value
				Toggle(Settings.Toggle_UI)
                Interface_Manager:SaveSettings()
			end
		})

		Section:AddToggle("Auto Minimize", {
			Title = "Auto Minimize",
			Description = "After the script loads, it will minimize.",
			Default = Settings.Auto_Minimize,
			Callback = function(Value)
				Settings.Auto_Minimize = Value
                Interface_Manager:SaveSettings()
			end
		})

		if Settings.Auto_Minimize then
			Library.Window:Minimize()
		end
	
		local Minimize_Keybind = Section:AddKeybind("Minimize Keybind", { Title = "Minimize", Default = Settings.Keybind })
		Minimize_Keybind:OnChanged(function()
            if not Minimize_Keybind.Value or Minimize_Keybind.Value == "Unknown" then
                return
            end
			Settings.Minimize_Keybind = Minimize_Keybind.Value
            Interface_Manager:SaveSettings()
		end)
		Library.MinimizeKeybind = Minimize_Keybind
    end
end

return Interface_Manager
