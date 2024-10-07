local Nofitication = {}

function Nofitication:Notify(Information, Settings)
    local Ambient_Shadow = Instance.new("ImageLabel")
    local Window = Instance.new("Frame")
    local Outline = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Description = Instance.new("TextLabel")
    
    Ambient_Shadow.Name = "Ambient Shadow"
    Ambient_Shadow.Parent = game:GetService("CoreGui"):FindFirstChild("Nofitication")
    Ambient_Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Ambient_Shadow.BackgroundTransparency = 1
    Ambient_Shadow.BorderSizePixel = 0
    Ambient_Shadow.Position = UDim2.new(0.91525954, 0, 0.936809778, 0)
    Ambient_Shadow.Size = UDim2.new(0, 0, 0, 0)
    Ambient_Shadow.Image = "rbxassetid://1316045217"
    Ambient_Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Ambient_Shadow.ImageTransparency = 0.4
    Ambient_Shadow.ScaleType = Enum.ScaleType.Slice
    Ambient_Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    
    Window.Name = "Window"
    Window.Parent = Ambient_Shadow
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0, 5, 0, 5)
    Window.Size = UDim2.new(0, 230, 0, 80)
    Window.ZIndex = 2
    
    Outline.Name = "Outline"
    Outline.Parent = Window
    Outline.BackgroundColor3 = Settings.OutlineColor
    Outline.BorderSizePixel = 0
    Outline.Position = UDim2.new(0, 0, 0, 25)
    Outline.Size = UDim2.new(0, 230, 0, 2)
    Outline.ZIndex = 5
    
    Title.Name = "Title"
    Title.Parent = Window
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0, 8, 0, 2)
    Title.Size = UDim2.new(0, 222, 0, 22)
    Title.ZIndex = 4
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = Information.Title
    Title.TextColor3 = Color3.fromRGB(220, 220, 220)
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    Description.Name = "Description"
    Description.Parent = Window
    Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Description.BackgroundTransparency = 1
    Description.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Description.BorderSizePixel = 0
    Description.Position = UDim2.new(0, 8, 0, 34)
    Description.Size = UDim2.new(0, 216, 0, 40)
    Description.ZIndex = 4
    Description.Font = Enum.Font.GothamSemibold
    Description.Text = Information.Description
    Description.TextColor3 = Color3.fromRGB(180, 180, 180)
    Description.TextSize = 12
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.TextYAlignment = Enum.TextYAlignment.Top

    local function LocalScript()
        local Script = Instance.new('LocalScript', Ambient_Shadow)
    
        Ambient_Shadow:TweenSize(UDim2.new(0, 240, 0, 90), "Out", "Linear", 0.2)
        Window.Size = UDim2.new(0, 230, 0, 80)
        Outline:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", Settings.Time)

        Wait(Settings.Time)
    
        Ambient_Shadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
        
        Wait(0.2)
        Ambient_Shadow:Destroy()
    end
    coroutine.wrap(LocalScript)()
end

return Nofitication
