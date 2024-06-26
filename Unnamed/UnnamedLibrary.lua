getgenv().Unnamed = true

local library = {
    Flags = {},
    Signals = {},
    SectionsOpened = false,
    Theme = "Dark"
}
library.flags = library.Flags
library.theme = library.Theme
library.signals = library.Signals

local Themes = {
    ["Dark"] = {
        Topbar = Color3.fromRGB(30, 30, 35),
        TabContainer = Color3.fromRGB(25, 25, 30),
        Lines = Color3.fromRGB(50, 50, 55),
        HoverTabFrame = Color3.fromRGB(53, 53, 57),
        ItemUIStroke = Color3.fromRGB(41, 41, 50),
        TabFrame = Color3.fromRGB(35, 35, 40),
        SectionFrame = Color3.fromRGB(30, 30, 35),
        TabText = Color3.fromRGB(237, 237, 237),
        ItemText = Color3.fromRGB(237, 237, 237),
        ItemUIStrokeSelected = Color3.fromRGB(80, 201, 206),
        SectionText = Color3.fromRGB(237, 237, 237),
        SelectedTabFrame = Color3.fromRGB(65, 65, 70),
        ItemFrame = Color3.fromRGB(35, 35, 40),
        HoverItemFrame = Color3.fromRGB(53, 53, 57),
        SectionUIStroke = Color3.fromRGB(37, 37, 44),
        MainUIStroke = Color3.fromRGB(54, 54, 63),
        Main = Color3.fromRGB(20, 20, 25),
        Shadow = Color3.fromRGB(20, 20, 25),
        TabUIStroke = Color3.fromRGB(39, 39, 47),
        ToggleOuter = Color3.fromRGB(35, 35, 40),
        ToggleOuterEnabled = Color3.fromRGB(53, 53, 61),
        ToggleOuterUIStroke = Color3.fromRGB(54, 54, 62),
        ToggleOuterUIStrokeEnabled = Color3.fromRGB(67, 67, 77),
        ToggleInner = Color3.fromRGB(66, 66, 76),
        ToggleInnerEnabled = Color3.fromRGB(80, 201, 206),
        ContainerHolder = Color3.fromRGB(26, 26, 31),
        HighlightUIStroke = Color3.fromRGB(79, 79, 86),
        Highlight = Color3.fromRGB(80, 201, 206)
    },
    ["Tokyo Night"] = {
        Topbar = Color3.fromRGB(39, 40, 57),
        TabContainer = Color3.fromRGB(31, 32, 45),
        Lines = Color3.fromRGB(62, 63, 90),
        HoverTabFrame = Color3.fromRGB(52, 53, 76),
        ItemUIStroke = Color3.fromRGB(51, 53, 75),
        TabFrame = Color3.fromRGB(39, 40, 57),
        SectionFrame = Color3.fromRGB(31, 32, 45),
        TabText = Color3.fromRGB(237, 237, 237),
        ItemText = Color3.fromRGB(237, 237, 237),
        SectionText = Color3.fromRGB(237, 237, 237),
        ItemUIStrokeSelected = Color3.fromRGB(255, 183, 38),
        SelectedTabFrame = Color3.fromRGB(70, 72, 102),
        ItemFrame = Color3.fromRGB(39, 40, 57),
        HoverItemFrame = Color3.fromRGB(50, 52, 74),
        SectionUIStroke = Color3.fromRGB(45, 46, 66),
        MainUIStroke = Color3.fromRGB(64, 67, 100),
        Main = Color3.fromRGB(26, 27, 38),
        Shadow = Color3.fromRGB(26, 27, 38),
        TabUIStroke = Color3.fromRGB(55, 56, 80),
        ToggleOuter = Color3.fromRGB(56, 59, 83),
        ToggleOuterEnabled = Color3.fromRGB(77, 82, 115),
        ToggleOuterUIStroke = Color3.fromRGB(76, 79, 112),
        ToggleOuterUIStrokeEnabled = Color3.fromRGB(255, 183, 38),
        ToggleInner = Color3.fromRGB(76, 79, 112),
        ToggleInnerEnabled = Color3.fromRGB(255, 183, 38),
        ContainerHolder = Color3.fromRGB(32, 32, 47),
        HighlightUIStroke = Color3.fromRGB(86, 89, 127),
        Highlight = Color3.fromRGB(115, 213, 239)
    }
}

local HttpService = cloneref(game:GetService("HttpService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))

local Blacklist = {Enum.KeyCode.Unknown, Enum.KeyCode.CapsLock, Enum.KeyCode.Escape, Enum.KeyCode.Tab, Enum.KeyCode.Return, Enum.KeyCode.Backspace, Enum.KeyCode.Space, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}

local function Disconnect()
    for _,v in next, library.Signals do
        v:Disconnect()
    end
end

local request = http and http.request or http_request or request or httprequest
local getcustomasset = getcustomasset
local isfolder = isfolder or is_folder
local makefolder = makefolder or make_folder or createfolder or create_folder

if not isfolder("Unnamed") then
makefolder("Unnamed")
    
local Shadow = request({Url = "https://raw.githubusercontent.com/Rain-Design/Unnamed/main/Icons/UnnamedShadow.png", Method = "GET"})
writefile("Unnamed/Shadow.png", Shadow.Body)

local Chevron = request({Url = "https://raw.githubusercontent.com/Rain-Design/Unnamed/main/Icons/Chevron.png", Method = "GET"})
writefile("Unnamed/Chevron.png", Chevron.Body)

local Circle = request({Url = "https://raw.githubusercontent.com/Rain-Design/Unnamed/main/Icons/Circle.png", Method = "GET"})
writefile("Unnamed/Circle.png", Circle.Body)
end

local SelectedTab = nil

function library:Window(Info)
Info.Text = Info.Text or "Window"

local Theme = Themes[library.Theme]

if Theme == nil then
    getgenv().Unnamed = false
    error("There's no theme called: "..library.Theme, 0)
end

local window = {}

local unnamed = Instance.new("ScreenGui")
unnamed.Name = HttpService:GenerateGUID(true)
unnamed.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
unnamed.Parent = CoreGui

local shadow = Instance.new("ScreenGui")
shadow.Name = HttpService:GenerateGUID(true)
shadow.DisplayOrder = -1
shadow.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
shadow.Parent = CoreGui

local mainShadow = Instance.new("ImageLabel")
mainShadow.Name = "MainShadow"
mainShadow.Image = getcustomasset("Unnamed/Shadow.png")
mainShadow.ImageColor3 = Theme.Shadow
mainShadow.ImageTransparency = 0.2
mainShadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainShadow.BackgroundTransparency = 1
mainShadow.Position = UDim2.new(0.339, 0, 0.279, 0)
mainShadow.Size = UDim2.new(0, 520, 0, 370)
mainShadow.Parent = shadow

local main = Instance.new("Frame")
main.Name = "Main"
main.BackgroundColor3 = Theme.Main
main.BorderSizePixel = 0
main.Position = UDim2.new(0.345, 0, 0.291, 0)
main.Size = UDim2.new(0, 500, 0, 350)
main.Parent = unnamed
main.ClipsDescendants = true

local uICorner = Instance.new("UICorner")
uICorner.Name = "UICorner"
uICorner.CornerRadius = UDim.new(0, 3)
uICorner.Parent = main

local topbar = Instance.new("Frame")
topbar.Name = "Topbar"
topbar.BackgroundColor3 = Theme.Topbar
topbar.BorderSizePixel = 0
topbar.Size = UDim2.new(0, 500, 0, 34)
topbar.Parent = main

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    mainShadow.Position = UDim2.new(startPos.X.Scale, (startPos.X.Offset + delta.X) - 10, startPos.Y.Scale, (startPos.Y.Offset + delta.Y) - 10)
end

library.Signals[#library.Signals + 1] = topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        library.Signals[#library.Signals + 1] = input.Changed:Connect(function()
        	if input.UserInputState == Enum.UserInputState.End then
        		dragging = false
        	end
        end)
    end
end)

library.Signals[#library.Signals + 1] = topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

library.Signals[#library.Signals + 1] = UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local uICorner1 = Instance.new("UICorner")
uICorner1.Name = "UICorner"
uICorner1.CornerRadius = UDim.new(0, 3)
uICorner1.Parent = topbar

local topbarLine = Instance.new("Frame")
topbarLine.Name = "TopbarLine"
topbarLine.AnchorPoint = Vector2.new(0.5, 1)
topbarLine.BackgroundColor3 = Theme.Lines
topbarLine.BorderSizePixel = 0
topbarLine.Position = UDim2.new(0.5, 0, 1, 0)
topbarLine.Size = UDim2.new(0, 500, 0, 1)
topbarLine.ZIndex = 0
topbarLine.Parent = topbar

local windowName = Instance.new("TextLabel")
windowName.Name = "WindowName"
windowName.Font = Enum.Font.GothamBold
windowName.Text = Info.Text
windowName.TextColor3 = Color3.fromRGB(255, 255, 255)
windowName.TextSize = 13
windowName.TextTransparency = 0.1
windowName.TextXAlignment = Enum.TextXAlignment.Left
windowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
windowName.BackgroundTransparency = 1
windowName.Position = UDim2.new(0, 6, 0, 0)
windowName.Size = UDim2.new(0, 418, 0, 34)
windowName.Parent = topbar

local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Image = "rbxassetid://10738425363"
closeButton.ImageTransparency = 0.1
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(0.954, 3, 0.235, 0)
closeButton.Size = UDim2.new(0, 17, 0, 17)
closeButton.Parent = topbar

library.Signals[#library.Signals + 1] = closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {ImageColor3 = Color3.fromRGB(255, 66, 66)}):Play()
end)

library.Signals[#library.Signals + 1] = closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

library.Signals[#library.Signals + 1] = closeButton.MouseButton1Click:Connect(function()
    unnamed:Destroy()
    shadow:Destroy()
    Disconnect()
    getgenv().Unnamed = false
end)

local minimizeButton = Instance.new("ImageButton")
minimizeButton.Name = "ImageButton"
minimizeButton.Image = "rbxassetid://10664064072"
minimizeButton.ImageTransparency = 0.1
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Position = UDim2.new(0.954, -18, 0.235, 0)
minimizeButton.Size = UDim2.new(0, 17, 0, 17)
minimizeButton.Parent = topbar

library.Signals[#library.Signals + 1] = minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {ImageColor3 = Theme.Highlight}):Play()
end)

library.Signals[#library.Signals + 1] = minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

local Minimized = false

library.Signals[#library.Signals + 1] = minimizeButton.MouseButton1Click:Connect(function()
    Minimized = not Minimized
   
    if Minimized then
        topbar.TopbarLine.Visible = false
        mainShadow.Visible = false
    end
    TweenService:Create(main, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = Minimized and UDim2.new(0, 500,0, 34) or UDim2.new(0, 500,0, 350)}):Play()
    if not Minimized then
        wait(.125)
        mainShadow.Visible = true
        topbar.TopbarLine.Visible = true
    end
    for _,v in next, main:GetChildren() do
        if v.Name ~= "Topbar" and v.ClassName == "Frame" or v.ClassName == "ScrollingFrame" then
            v.Visible = not Minimized
        end
    end
end)

local uIStroke = Instance.new("UIStroke")
uIStroke.Name = "UIStroke"
uIStroke.Color = Theme.MainUIStroke
uIStroke.Parent = main

local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.BackgroundColor3 = Theme.TabContainer
tabContainer.BorderSizePixel = 0
tabContainer.Position = UDim2.new(-0.012, 6, 0.0971, 0)
tabContainer.Size = UDim2.new(0, 131, 0, 316)
tabContainer.Parent = main

local tabContainerLine = Instance.new("Frame")
tabContainerLine.Name = "TabContainerLine"
tabContainerLine.AnchorPoint = Vector2.new(1, 0)
tabContainerLine.BackgroundColor3 = Theme.Lines
tabContainerLine.BorderSizePixel = 0
tabContainerLine.Position = UDim2.new(1, 0, 0, 0)
tabContainerLine.Size = UDim2.new(0, 1, 0, 316)
tabContainerLine.ZIndex = 0
tabContainerLine.Parent = tabContainer

local tabContainerScrolling = Instance.new("ScrollingFrame")
tabContainerScrolling.Name = "TabContainerScrolling"
tabContainerScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabContainerScrolling.CanvasSize = UDim2.new()
tabContainerScrolling.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
tabContainerScrolling.ScrollBarThickness = 0
tabContainerScrolling.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabContainerScrolling.BackgroundTransparency = 1
tabContainerScrolling.BorderSizePixel = 0
tabContainerScrolling.Position = UDim2.new(0, 0, 0, 6)
tabContainerScrolling.Size = UDim2.new(0, 128, 0, 304)
tabContainerScrolling.Parent = tabContainer

local uIListLayout = Instance.new("UIListLayout")
uIListLayout.Name = "UIListLayout"
uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uIListLayout.Parent = tabContainerScrolling

local containers = Instance.new("ScrollingFrame")
containers.Name = "Containers"
containers.AutomaticCanvasSize = Enum.AutomaticSize.Y
containers.CanvasSize = UDim2.new()
containers.ScrollBarThickness = 0
containers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
containers.BackgroundTransparency = 1
containers.BorderSizePixel = 0
containers.Position = UDim2.new(0.262, 1, 0.097, 0)
containers.Selectable = false
containers.Size = UDim2.new(0, 368, 0, 310)
containers.Parent = main

function window:Tab(Info)
Info.Text = Info.Text or "Tab"

local tabtable = {}

local tab = Instance.new("Frame")
tab.Name = "Tab"
tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tab.BackgroundTransparency = 1
tab.BorderSizePixel = 0
tab.Size = UDim2.new(0, 118, 0, 29)
tab.Parent = tabContainerScrolling

local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.AnchorPoint = Vector2.new(.5, .5)
tabFrame.Position = UDim2.new(.5, 0, .5, 0)
tabFrame.BackgroundColor3 = Theme.TabFrame
tabFrame.BorderSizePixel = 0
tabFrame.Size = UDim2.new(0, 118, 0, 25)
tabFrame.Parent = tab

local uICorner2 = Instance.new("UICorner")
uICorner2.Name = "UICorner"
uICorner2.CornerRadius = UDim.new(0, 2)
uICorner2.Parent = tabFrame

local tabuIStroke = Instance.new("UIStroke")
tabuIStroke.Name = "UIStroke"
tabuIStroke.Color = Theme.TabUIStroke
tabuIStroke.Parent = tabFrame

local tabButton = Instance.new("TextButton")
tabButton.Name = "TabButton"
tabButton.Font = Enum.Font.SourceSans
tabButton.Text = ""
tabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
tabButton.TextSize = 14
tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabButton.BackgroundTransparency = 1
tabButton.Size = UDim2.new(0, 118, 0, 25)
tabButton.Parent = tabFrame

local tabName = Instance.new("TextLabel")
tabName.Name = "TabName"
tabName.Font = Enum.Font.GothamBold
tabName.Text = Info.Text
tabName.TextColor3 = Theme.TabText
tabName.TextSize = 12
tabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
tabName.BackgroundTransparency = 1
tabName.Size = UDim2.new(0, 118, 0, 25)
tabName.Parent = tabFrame

library.Signals[#library.Signals + 1] = tabFrame.MouseEnter:Connect(function()
    if SelectedTab == nil or SelectedTab ~= tab then
        TweenService:Create(tabFrame, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Theme.HoverTabFrame}):Play()
        TweenService:Create(tabName, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 122,0, 25)}):Play()
        TweenService:Create(tabFrame, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 122,0, 25)}):Play()
    end
end)

library.Signals[#library.Signals + 1] = tabFrame.MouseLeave:Connect(function()
    if SelectedTab == nil or SelectedTab ~= tab then
        TweenService:Create(tabFrame, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Theme.TabFrame}):Play()
        TweenService:Create(tabFrame, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 118,0, 25)}):Play()
        TweenService:Create(tabName, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 118,0, 25)}):Play()
    end
end)

local uIPadding = Instance.new("UIPadding")
uIPadding.Name = "UIPadding"
uIPadding.PaddingBottom = UDim.new(1, 0)
uIPadding.PaddingLeft = UDim.new(0, 6)
uIPadding.Parent = tabContainerScrolling

local Left = Instance.new("ScrollingFrame")
Left.Name = "Left"
Left.AutomaticCanvasSize = Enum.AutomaticSize.Y
Left.CanvasSize = UDim2.new()
Left.ScrollBarThickness = 0
Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Left.BackgroundTransparency = 1
Left.Visible = false
Left.BorderSizePixel = 0
Left.Position = UDim2.new(0, 0, 0.0195, 0)
Left.Selectable = false
Left.Size = UDim2.new(0, 182, 0, 306)
Left.Parent = containers

local leftPadding = Instance.new("UIPadding")
leftPadding.Name = "UIPadding"
leftPadding.PaddingLeft = UDim.new(0, 6)
leftPadding.PaddingTop = UDim.new(0, 1)
leftPadding.Parent = Left

local uIListLayout1 = Instance.new("UIListLayout")
uIListLayout1.Name = "UIListLayout"
uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
uIListLayout1.Parent = Left

local Right = Instance.new("ScrollingFrame")
Right.Name = "Right"
Right.AutomaticCanvasSize = Enum.AutomaticSize.Y
Right.CanvasSize = UDim2.new()
Right.ScrollBarThickness = 0
Right.AnchorPoint = Vector2.new(1, 0)
Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Right.BackgroundTransparency = 1
Right.BorderSizePixel = 0
Right.Visible = false
Right.Position = UDim2.new(1, 0, 0.0194, 0)
Right.Selectable = false
Right.Size = UDim2.new(0, 182, 0, 306)
Right.Parent = containers

local uIListLayout2 = Instance.new("UIListLayout")
uIListLayout2.Name = "UIListLayout"
uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
uIListLayout2.Parent = Right

local rightPadding = Instance.new("UIPadding")
rightPadding.Name = "UIPadding"
rightPadding.PaddingLeft = UDim.new(0, 1)
rightPadding.PaddingTop = UDim.new(0, 1)
rightPadding.Parent = Right

function tabtable:Section(Info)
Info.Text = Info.Text or "Section"
Info.Side = Info.Side or "Left"
Info.Opened = Info.Opened or library.SectionsOpened

local sectiontable = {}

local section = Instance.new("Frame")
section.Name = "Section"
section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
section.BackgroundTransparency = 1
section.Size = UDim2.new(0, 175, 0, 33)

if Info.Side == "Left" then
    section.Parent = Left
else
    section.Parent = Right
end

local sectionFrame = Instance.new("Frame")
sectionFrame.Name = "SectionFrame"
sectionFrame.BackgroundColor3 = Theme.SectionFrame
sectionFrame.BorderSizePixel = 0
sectionFrame.Size = UDim2.new(0, 175, 0, 28)
sectionFrame.Parent = section

local sectionUICorner = Instance.new("UICorner")
sectionUICorner.Name = "SectionUICorner"
sectionUICorner.CornerRadius = UDim.new(0, 2)
sectionUICorner.Parent = sectionFrame

local sectionName = Instance.new("TextLabel")
sectionName.Name = "SectionName"
sectionName.Font = Enum.Font.GothamBold
sectionName.Text = Info.Text
sectionName.TextColor3 = Theme.SectionText
sectionName.TextSize = 12
sectionName.TextXAlignment = Enum.TextXAlignment.Left
sectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sectionName.BackgroundTransparency = 1
sectionName.Position = UDim2.new(0.0343, 0, 0, 0)
sectionName.Size = UDim2.new(0, 138, 0, 28)
sectionName.Parent = sectionFrame

local sectionButton = Instance.new("TextButton")
sectionButton.Name = "SectionButton"
sectionButton.Font = Enum.Font.GothamBold
sectionButton.Text = ""
sectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sectionButton.BackgroundTransparency = 1
sectionButton.Size = UDim2.new(0, 175, 0, 28)
sectionButton.Parent = sectionFrame

local sectionIcon = Instance.new("ImageLabel")
sectionIcon.Name = "SectionIcon"
sectionIcon.Image = getcustomasset("Unnamed/Chevron.png")
sectionIcon.ImageTransparency = 0.14
sectionIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sectionIcon.BackgroundTransparency = 1
sectionIcon.Position = UDim2.new(0, 155, 0, 5)
sectionIcon.Rotation = 90
sectionIcon.Selectable = false
sectionIcon.Size = UDim2.new(0, 17, 0, 17)
sectionIcon.Parent = sectionFrame

local containerHolder = Instance.new("Frame")
containerHolder.Name = "ContainerHolder"
containerHolder.BackgroundColor3 = Theme.ContainerHolder
containerHolder.BackgroundTransparency = 0
containerHolder.BorderSizePixel = 0
containerHolder.Position = UDim2.new(0, 0, 0, 28)
containerHolder.Size = UDim2.new(0, 175, 0, 0)
containerHolder.Parent = sectionFrame

local itemContainer = Instance.new("Frame")
itemContainer.Name = "ItemContainer"
itemContainer.BackgroundColor3 = Theme.ContainerHolder
itemContainer.BorderSizePixel = 0
itemContainer.Size = UDim2.new(0, 175, 0, 0)
itemContainer.ClipsDescendants = true
itemContainer.Parent = containerHolder

local SectionY = 28
local ContainerY = 0

library.Signals[#library.Signals + 1] = itemContainer.ChildAdded:Connect(function(v)
    if v.ClassName ~= "UIListLayout" then
        SectionY = SectionY + 28
        ContainerY = ContainerY + 28
    end
end)


local OpenedSec = false

function sectiontable:Select()
    OpenedSec = not OpenedSec
    section.Size = OpenedSec and UDim2.new(0, 175, 0, SectionY + 5) or UDim2.new(0, 175, 0, 33)
    sectionFrame.Size = OpenedSec and UDim2.new(0, 175, 0, SectionY) or UDim2.new(0, 175, 0, 28)
    containerHolder.Position = OpenedSec and UDim2.new(0, 0, 0, 28) or UDim2.new(0, 0, 0, 0)
    containerHolder.Size = OpenedSec and UDim2.new(0, 175, 0, ContainerY) or UDim2.new(0, 175, 0, 0)
    itemContainer.Size = OpenedSec and UDim2.new(0, 175, 0, ContainerY) or UDim2.new(0, 175, 0, 0)
    itemContainer.Visible = OpenedSec
    sectionIcon.Rotation = OpenedSec and -90 or 90
    sectionIcon.Position = OpenedSec and UDim2.new(0, 156, 0, 5) or UDim2.new(0, 155, 0, 5)
end

task.spawn(function()
if Info.Opened then
    for i = 1,3 do
        sectiontable:Select()
        wait()
    end
end
end)

library.Signals[#library.Signals + 1] = sectionButton.MouseButton1Click:Connect(function()
    sectiontable:Select()
end)

local itemUIListLayout = Instance.new("UIListLayout")
itemUIListLayout.Name = "ItemUIListLayout"
itemUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
itemUIListLayout.Parent = itemContainer

local sectionUIStroke = Instance.new("UIStroke")
sectionUIStroke.Name = "SectionUIStroke"
sectionUIStroke.Color = Theme.SectionUIStroke
sectionUIStroke.Parent = sectionFrame

function sectiontable:Keybind(Info)
Info.Text = Info.Text or "Keybind"
Info.Default = Info.Default or Enum.KeyCode.Alt
Info.Callback = Info.Callback or function() end

local PressKey = Info.Default

local keybind = Instance.new("Frame")
keybind.Name = "Keybind"
keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keybind.BackgroundTransparency = 1
keybind.Size = UDim2.new(0, 175, 0, 28)
keybind.Parent = itemContainer

local keybindFrame = Instance.new("Frame")
keybindFrame.Name = "KeybindFrame"
keybindFrame.AnchorPoint = Vector2.new(0.5, 0.5)
keybindFrame.BackgroundColor3 = Theme.ItemFrame
keybindFrame.BorderSizePixel = 0
keybindFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
keybindFrame.Size = UDim2.new(0, 171, 0, 24)
keybindFrame.Parent = keybind

local keybindText = Instance.new("TextLabel")
keybindText.Name = "KeybindText"
keybindText.Font = Enum.Font.GothamBold
keybindText.Text = Info.Text
keybindText.TextColor3 = Theme.ItemText
keybindText.TextSize = 12
keybindText.TextXAlignment = Enum.TextXAlignment.Left
keybindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keybindText.BackgroundTransparency = 1
keybindText.Position = UDim2.new(0.0234, 0, 0, 0)
keybindText.Size = UDim2.new(0, 167, 0, 24)
keybindText.Parent = keybindFrame

local keybindTextButton = Instance.new("TextButton")
keybindTextButton.Name = "keybindTextButton"
keybindTextButton.Font = Enum.Font.SourceSans
keybindTextButton.Text = ""
keybindTextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
keybindTextButton.TextSize = 14
keybindTextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keybindTextButton.BackgroundTransparency = 1
keybindTextButton.Size = UDim2.new(0, 171, 0, 24)
keybindTextButton.Parent = keybindFrame

local keybindUIStroke = Instance.new("UIStroke")
keybindUIStroke.Name = "keybindUIStroke"
keybindUIStroke.Color = Theme.ItemUIStroke
keybindUIStroke.Parent = keybindFrame

local keybindOuter = Instance.new("Frame")
keybindOuter.Name = "KeybindOuter"
keybindOuter.AnchorPoint = Vector2.new(1, 0)
keybindOuter.BackgroundColor3 = Theme.ToggleOuter
keybindOuter.Position = UDim2.new(0.152, 139, 0.125, 2)
keybindOuter.Size = UDim2.new(0, 30, 0, 14)
keybindOuter.Parent = keybindFrame

local keybindOuterUIStroke = Instance.new("UIStroke")
keybindOuterUIStroke.Name = "keybindOuterUIStroke"
keybindOuterUIStroke.Color = Theme.ToggleOuterUIStroke
keybindOuterUIStroke.Parent = keybindOuter

local keybindUICorner = Instance.new("UICorner")
keybindUICorner.Name = "keybindUICorner"
keybindUICorner.CornerRadius = UDim.new(0, 2)
keybindUICorner.Parent = keybindOuter

local keybindOuterText = Instance.new("TextLabel")
keybindOuterText.Name = "KeybindOuterText"
keybindOuterText.Font = Enum.Font.GothamBold
keybindOuterText.Text = PressKey.Name
keybindOuterText.TextColor3 = Color3.fromRGB(232, 232, 232)
keybindOuterText.TextSize = 12
keybindOuterText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keybindOuterText.BackgroundTransparency = 1
keybindOuterText.Size = UDim2.new(1, 0, 0, 14)
keybindOuterText.Parent = keybindOuter

local TextBounds = keybindOuterText.TextBounds

keybindOuter.Size = UDim2.new(0, TextBounds.X + 10, 0, 14)

keybindOuterText:GetPropertyChangedSignal("Text"):Connect(function()
    TextBounds = keybindOuterText.TextBounds
    
    keybindOuter.Size = UDim2.new(0, TextBounds.X + 10, 0, 14)
end)

local KeybindConnection
local Changing = false

keybindTextButton.MouseButton1Click:Connect(function()
    if KeybindConnection then KeybindConnection:Disconnect() end
    Changing = true
    keybindOuterText.Text = "..."
    keybindOuterUIStroke.Color = Theme.ItemUIStrokeSelected
    KeybindConnection = UserInputService.InputBegan:Connect(function(Key, gameProcessed)
        if not table.find(Blacklist, Key.KeyCode) and not gameProcessed then
            KeybindConnection:Disconnect()
            keybindOuterText.Text = Key.KeyCode.Name
            keybindOuterUIStroke.Color = Theme.ToggleOuterUIStroke
            PressKey = Key.KeyCode
            wait(.1)
            Changing = false
        end
    end)
end)

UserInputService.InputBegan:Connect(function(Key, gameProcessed)
    if not Changing and Key.KeyCode == PressKey and not gameProcessed then
        task.spawn(function()
            pcall(Info.Callback)
        end)
    end
end)
end

function sectiontable:Toggle(Info)
Info.Text = Info.Text or "Toggle"
Info.Default = Info.Default or false
Info.Flag = Info.Flag or nil
Info.Callback = Info.Callback or function() end

local toggletable = {}

if Info.Flag ~= nil then
    library.Flags[Info.Flag] = Info.Default
end

local Enabled = false

local toggle = Instance.new("Frame")
toggle.Name = "Toggle"
toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle.BackgroundTransparency = 1
toggle.Size = UDim2.new(0, 175, 0, 28)
toggle.Parent = itemContainer

local toggleFrame = Instance.new("Frame")
toggleFrame.Name = "ToggleFrame"
toggleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
toggleFrame.BackgroundColor3 = Theme.ItemFrame
toggleFrame.BorderSizePixel = 0
toggleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
toggleFrame.Size = UDim2.new(0, 171, 0, 24)
toggleFrame.Parent = toggle

local toggleText = Instance.new("TextLabel")
toggleText.Name = "toggleText"
toggleText.Font = Enum.Font.GothamBold
toggleText.Text = Info.Text
toggleText.TextColor3 = Theme.ItemText
toggleText.TextSize = 12
toggleText.TextXAlignment = Enum.TextXAlignment.Left
toggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleText.BackgroundTransparency = 1
toggleText.Position = UDim2.new(0.0234, 0, 0, 0)
toggleText.Size = UDim2.new(0, 167, 0, 24)
toggleText.Parent = toggleFrame

local toggleTextButton = Instance.new("TextButton")
toggleTextButton.Name = "toggleTextButton"
toggleTextButton.Font = Enum.Font.SourceSans
toggleTextButton.Text = ""
toggleTextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleTextButton.TextSize = 14
toggleTextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleTextButton.BackgroundTransparency = 1
toggleTextButton.Size = UDim2.new(0, 171, 0, 24)
toggleTextButton.Parent = toggleFrame

local toggleUIStroke = Instance.new("UIStroke")
toggleUIStroke.Name = "toggleUIStroke"
toggleUIStroke.Color = Theme.ItemUIStroke
toggleUIStroke.Parent = toggleFrame

library.Signals[#library.Signals + 1] = toggleFrame.MouseEnter:Connect(function()
    TweenService:Create(toggleFrame, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Theme.HoverItemFrame}):Play()
end)

library.Signals[#library.Signals + 1] = toggleFrame.MouseLeave:Connect(function()
    TweenService:Create(toggleFrame, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Theme.ItemFrame}):Play()
    TweenService:Create(toggleUIStroke, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Color = Theme.ItemUIStroke}):Play()
end)

library.Signals[#library.Signals + 1] = toggleTextButton.MouseButton1Down:Connect(function()
    TweenService:Create(toggleUIStroke, TweenInfo.new(.13, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Color = Theme.ItemUIStrokeSelected}):Play()
end)

library.Signals[#library.Signals + 1] = toggleTextButton.MouseButton1Up:Connect(function()
    TweenService:Create(toggleUIStroke, TweenInfo.new(.13, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Color = Theme.ItemUIStroke}):Play()
end)

local toggleOuter = Instance.new("Frame")
toggleOuter.Name = "ToggleOuter"
toggleOuter.BackgroundColor3 = Theme.ToggleOuter
toggleOuter.Position = UDim2.new(-0.023, 139, 0.167, 1)
toggleOuter.Size = UDim2.new(0, 30, 0, 14)
toggleOuter.Parent = toggleFrame

local toggleOuterUIStroke = Instance.new("UIStroke")
toggleOuterUIStroke.Name = "toggleOuterUIStroke"
toggleOuterUIStroke.Color = Theme.ToggleOuterUIStroke
toggleOuterUIStroke.Parent = toggleOuter

local toggleOuterUICorner = Instance.new("UICorner")
toggleOuterUICorner.Name = "toggleOuterUICorner"
toggleOuterUICorner.CornerRadius = UDim.new(1, 0)
toggleOuterUICorner.Parent = toggleOuter

local toggleInner = Instance.new("ImageLabel")
toggleInner.Name = "toggleInner"
toggleInner.Image = getcustomasset("Unnamed/Circle.png")
toggleInner.ImageColor3 = Theme.ToggleInner
toggleInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleInner.BackgroundTransparency = 1
toggleInner.BorderSizePixel = 0
toggleInner.Position = UDim2.new(0, 2, 0, 2)
toggleInner.Size = UDim2.new(0, 10, 0, 10)
toggleInner.Parent = toggleOuter

function toggletable:Set(bool)
Enabled = bool
if Info.Flag ~= nil then
    library.Flags[Info.Flag] = bool
end
TweenService:Create(toggleOuter, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = bool and Theme.ToggleOuterEnabled or Theme.ToggleOuter}):Play()
TweenService:Create(toggleInner, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {ImageColor3 = bool and Theme.ToggleInnerEnabled or Theme.ToggleInner}):Play()
TweenService:Create(toggleInner, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Position = bool and UDim2.new(0, 18, 0, 2) or UDim2.new(0, 2, 0, 2)}):Play()
TweenService:Create(toggleOuterUIStroke, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Color = bool and Theme.ToggleOuterUIStrokeEnabled or Theme.ToggleOuterUIStroke}):Play()
task.spawn(function()
    pcall(Info.Callback, bool)
end)
end

task.spawn(function()
    if Info.Default then
        toggletable:Set(true)
    end
end)

library.Signals[#library.Signals + 1] = toggleTextButton.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    
    toggletable:Set(Enabled)
end)

return toggletable
end

function sectiontable:Button(Info)
Info.Text = Info.Text or "Button"
Info.Callback = Info.Callback or function() end

local button = Instance.new("Frame")
button.Name = "Button"
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundTransparency = 1
button.Size = UDim2.new(0, 175, 0, 28)
button.Parent = itemContainer

local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.AnchorPoint = Vector2.new(0.5, 0.5)
buttonFrame.BackgroundColor3 = Theme.ItemFrame
buttonFrame.BorderSizePixel = 0
buttonFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
buttonFrame.Size = UDim2.new(0, 171, 0, 24)
buttonFrame.Parent = button

local buttonUIStroke = Instance.new("UIStroke")
buttonUIStroke.Name = "buttonUIStroke"
buttonUIStroke.Color = Theme.ItemUIStroke
buttonUIStroke.Parent = buttonFrame

library.Signals[#library.Signals + 1] = buttonFrame.MouseEnter:Connect(function()
    TweenService:Create(buttonFrame, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Theme.HoverItemFrame}):Play()
end)

library.Signals[#library.Signals + 1] = buttonFrame.MouseLeave:Connect(function()
    TweenService:Create(buttonFrame, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Theme.ItemFrame}):Play()
    TweenService:Create(buttonUIStroke, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Color = Theme.ItemUIStroke}):Play()
end)

local buttonText = Instance.new("TextLabel")
buttonText.Name = "ButtonText"
buttonText.Font = Enum.Font.GothamBold
buttonText.Text = Info.Text
buttonText.TextColor3 = Theme.ItemText
buttonText.TextSize = 12
buttonText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
buttonText.BackgroundTransparency = 1
buttonText.Size = UDim2.new(0, 171, 0, 24)
buttonText.Parent = buttonFrame

local buttonTextButton = Instance.new("TextButton")
buttonTextButton.Name = "ButtonTextButton"
buttonTextButton.Font = Enum.Font.SourceSans
buttonTextButton.Text = ""
buttonTextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
buttonTextButton.TextSize = 12
buttonTextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
buttonTextButton.BackgroundTransparency = 1
buttonTextButton.Size = UDim2.new(0, 171, 0, 24)
buttonTextButton.Parent = buttonFrame

library.Signals[#library.Signals + 1] = buttonTextButton.MouseButton1Down:Connect(function()
    TweenService:Create(buttonUIStroke, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Color = Theme.ItemUIStrokeSelected}):Play()
end)

library.Signals[#library.Signals + 1] = buttonTextButton.MouseButton1Up:Connect(function()
    TweenService:Create(buttonUIStroke, TweenInfo.new(.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Color = Theme.ItemUIStroke}):Play()
end)

library.Signals[#library.Signals + 1] = buttonTextButton.MouseButton1Click:Connect(function()
    task.spawn(function()
        pcall(Info.Callback)
    end)
end)
end

return sectiontable
end

function tabtable:Select()
    if SelectedTab == tab then return end
    
    SelectedTab = tab
    
    task.spawn(function()
        for _,v in next, containers:GetChildren() do
            if v.ClassName == "ScrollingFrame" and v ~= Left and v ~= Right then
                v.Visible = false
            end
        end
    end)
    
    task.spawn(function()
        for _,v in next, tabContainerScrolling:GetChildren() do
            if v.ClassName == "Frame" and v ~= tab then
                v.TabFrame.BackgroundColor3 = Theme.TabFrame
                v.TabFrame.TabName.TextColor3 = Theme.TabText
                TweenService:Create(v.TabFrame, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 118,0, 25)}):Play()
                v.TabFrame.UIStroke.Color = Theme.TabUIStroke
                TweenService:Create(v.TabFrame.TabName, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 118,0, 25)}):Play()
            end
        end
    end)
    Left.Visible = true
    Right.Visible = true
    TweenService:Create(tabFrame, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 122,0, 25)}):Play()
    TweenService:Create(tabName, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 122,0, 25)}):Play()
    TweenService:Create(tabuIStroke, TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Color = Theme.HighlightUIStroke}):Play()
    TweenService:Create(tabName, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {TextColor3 = Theme.Highlight}):Play()
    TweenService:Create(tabFrame, TweenInfo.new(.125, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {BackgroundColor3 = Theme.SelectedTabFrame}):Play()
end

library.Signals[#library.Signals + 1] = tabButton.MouseButton1Click:Connect(function()
    tabtable:Select()
end)

return tabtable
end

return window
end

return library
