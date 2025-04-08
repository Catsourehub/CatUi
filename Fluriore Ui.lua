local TweenService = game:GetService("TweenService")

local FlurioreLib = {}

function FlurioreLib:MakeGui()
    local Tabs = {}
    local CountTab = 0

    function Tabs:CreateTab(TabConfig)
        local TabConfig = TabConfig or {}
        TabConfig.Title = TabConfig.Title or "Tab"
        
        local Sections = {}
        local CountSection = 0

        -- Tạo ScrollLayer để chứa nội dung của Tab
        local ScrollLayer = Instance.new("ScrollingFrame")
        ScrollLayer.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollLayer.ScrollBarImageTransparency = 0.9
        ScrollLayer.ScrollBarThickness = 3
        ScrollLayer.Active = true
        ScrollLayer.BackgroundTransparency = 1
        ScrollLayer.Size = UDim2.new(1, 0, 1, 0)
        ScrollLayer.Name = "ScrollLayer"
        ScrollLayer.Parent = LayersFolder -- Giả sử LayersFolder đã được định nghĩa

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 4)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = ScrollLayer

        -- Hàm cập nhật CanvasSize
        local function UpSize(ScrollFrame)
            local OffsetY = 0
            for _, child in ScrollFrame:GetChildren() do
                if child:IsA("GuiObject") then
                    OffsetY = OffsetY + child.Size.Y.Offset + 4 -- Padding từ UIListLayout
                end
            end
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
        end

        function Sections:Section(SectionConfig)
            local SectionConfig = SectionConfig or {}
            SectionConfig.Title = SectionConfig.Title or "Section"
            SectionConfig.Content = SectionConfig.Content or ""

            -- Tạo Section
            local Section = Instance.new("Frame")
            Section.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(1, -8, 0, 44)
            Section.Name = "Section"
            Section.LayoutOrder = CountSection
            Section.Parent = ScrollLayer

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 3)
            UICorner.Parent = Section

            local SectionName = Instance.new("TextLabel")
            SectionName.Font = Enum.Font.GothamBold
            SectionName.Text = SectionConfig.Title
            SectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionName.TextSize = 13
            SectionName.TextXAlignment = Enum.TextXAlignment.Left
            SectionName.BackgroundTransparency = 1
            SectionName.Position = UDim2.new(0, 10, 0, 10)
            SectionName.Size = UDim2.new(1, -70, 0, 13)
            SectionName.Name = "SectionName"
            SectionName.Parent = Section

            local SectionDescription = Instance.new("TextLabel")
            SectionDescription.Font = Enum.Font.GothamBold
            SectionDescription.Text = SectionConfig.Content
            SectionDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
            SectionDescription.TextSize = 11
            SectionDescription.TextTransparency = 0.5
            SectionDescription.TextXAlignment = Enum.TextXAlignment.Left
            SectionDescription.BackgroundTransparency = 1
            SectionDescription.Position = UDim2.new(0, 10, 0, 22)
            SectionDescription.Size = UDim2.new(1, -70, 0, 11)
            SectionDescription.Name = "SectionDescription"
            SectionDescription.Parent = Section

            if SectionDescription.Text == "" then
                Section.Size = UDim2.new(1, -8, 0, 33)
            else
                SectionDescription:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    SectionDescription.TextWrapped = false
                    SectionDescription.Size = UDim2.new(1, -70, 0, 11 + (11 * (SectionDescription.TextBounds.X // SectionDescription.AbsoluteSize.X)))
                    Section.Size = UDim2.new(1, -8, 0, SectionDescription.AbsoluteSize.Y + 33)
                    SectionDescription.TextWrapped = true
                    UpSize(ScrollLayer)
                end)

                SectionDescription.TextWrapped = false
                SectionDescription.Size = UDim2.new(1, -70, 0, 11 + (11 * (SectionDescription.TextBounds.X // SectionDescription.AbsoluteSize.X)))
                Section.Size = UDim2.new(1, -8, 0, SectionDescription.AbsoluteSize.Y + 33)
                SectionDescription.TextWrapped = true
                UpSize(ScrollLayer)
            end

            local SectionImage = Instance.new("ImageLabel")
            SectionImage.Image = "rbxassetid://16851841101"
            SectionImage.ImageTransparency = 0.7
            SectionImage.AnchorPoint = Vector2.new(1, 0.5)
            SectionImage.BackgroundTransparency = 1
            SectionImage.Position = UDim2.new(1, -10, 0.5, 0)
            SectionImage.Rotation = -90
            SectionImage.Size = UDim2.new(0, 22, 0, 22)
            SectionImage.Name = "SectionImage"
            SectionImage.Parent = Section

            local SectionButton = Instance.new("TextButton")
            SectionButton.Text = ""
            SectionButton.BackgroundTransparency = 1
            SectionButton.Size = UDim2.new(1, 0, 1, 0)
            SectionButton.Name = "SectionButton"
            SectionButton.Parent = Section

            -- Hiệu ứng chuột vào/ra
            SectionButton.MouseEnter:Connect(function()
                TweenService:Create(
                    Section,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
                ):Play()
            end)

            SectionButton.MouseLeave:Connect(function()
                TweenService:Create(
                    Section,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}
                ):Play()
            end)

            -- Sự kiện bấm
            SectionButton.Activated:Connect(function()
                -- Hiệu ứng thu nhỏ và trở lại
                TweenService:Create(
                    Section,
                    TweenInfo.new(0.1),
                    {Size = UDim2.new(1, -8, 0, Section.Size.Y.Offset - 2)}
                ):Play()
                wait(0.1)
                TweenService:Create(
                    Section,
                    TweenInfo.new(0.1),
                    {Size = UDim2.new(1, -8, 0, Section.Size.Y.Offset)}
                ):Play()

                -- Chuyển trang
                UIPageLayout:JumpToIndex(ScrollLayer.LayoutOrder)
                TweenService:Create(
                    BackButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {TextTransparency = 0.7}
                ):Play()
                BackButton1.Text = SectionName.Text
                TweenService:Create(
                    BackButton1,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {TextTransparency = 0}
                ):Play()
                TweenService:Create(
                    ForwardImage,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {ImageTransparency = 0}
                ):Play()
            end)

            -- Hàm AddSection
            local Items = {}
            local CountItem = 0

            function Sections:AddSection(Title)
                local Title = Title or "Sub Section"
                
                local SubSection = Instance.new("Frame")
                SubSection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SubSection.BackgroundTransparency = 0.999
                SubSection.BorderSizePixel = 0
                SubSection.LayoutOrder = CountItem
                SubSection.ClipsDescendants = true
                SubSection.Size = UDim2.new(1, 0, 0, 30)
                SubSection.Name = "SubSection"
                SubSection.Parent = ScrollLayer

                local SubSectionReal = Instance.new("Frame")
                SubSectionReal.AnchorPoint = Vector2.new(0.5, 0)
                SubSectionReal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SubSectionReal.BackgroundTransparency = 0.935
                SubSectionReal.BorderSizePixel = 0
                SubSectionReal.Position = UDim2.new(0.5, 0, 0, 0)
                SubSectionReal.Size = UDim2.new(1, 1, 0, 30)
                SubSectionReal.Name = "SubSectionReal"
                SubSectionReal.Parent = SubSection

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = SubSectionReal

                local SubSectionButton = Instance.new("TextButton")
                SubSectionButton.Font = Enum.Font.SourceSans
                SubSectionButton.Text = ""
                SubSectionButton.BackgroundTransparency = 1
                SubSectionButton.Size = UDim2.new(1, 0, 1, 0)
                SubSectionButton.Name = "SubSectionButton"
                SubSectionButton.Parent = SubSectionReal

                local FeatureFrame = Instance.new("Frame")
                FeatureFrame.AnchorPoint = Vector2.new(1, 0.5)
                FeatureFrame.BackgroundTransparency = 1
                FeatureFrame.Position = UDim2.new(1, -5, 0.5, 0)
                FeatureFrame.Size = UDim2.new(0, 20, 0, 20)
                FeatureFrame.Name = "FeatureFrame"
                FeatureFrame.Parent = SubSectionReal

                local FeatureImg = Instance.new("ImageLabel")
                FeatureImg.Image = "rbxassetid://16851841101"
                FeatureImg.AnchorPoint = Vector2.new(0.5, 0.5)
                FeatureImg.BackgroundTransparency = 1
                FeatureImg.Position = UDim2.new(0.5, 0, 0.5, 0)
                FeatureImg.Rotation = -90
                FeatureImg.Size = UDim2.new(1, 6, 1, 6)
                FeatureImg.Name = "FeatureImg"
                FeatureImg.Parent = FeatureFrame

                local SubSectionTitle = Instance.new("TextLabel")
                SubSectionTitle.Font = Enum.Font.GothamBold
                SubSectionTitle.Text = Title
                SubSectionTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
                SubSectionTitle.TextSize = 13
                SubSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
                SubSectionTitle.TextYAlignment = Enum.TextYAlignment.Top
                SubSectionTitle.AnchorPoint = Vector2.new(0, 0.5)
                SubSectionTitle.BackgroundTransparency = 1
                SubSectionTitle.Position = UDim2.new(0, 10, 0.5, 0)
                SubSectionTitle.Size = UDim2.new(1, -50, 0, 13)
                SubSectionTitle.Name = "SubSectionTitle"
                SubSectionTitle.Parent = SubSectionReal

                local SubSectionAdd = Instance.new("Frame")
                SubSectionAdd.AnchorPoint = Vector2.new(0.5, 0)
                SubSectionAdd.BackgroundTransparency = 1
                SubSectionAdd.ClipsDescendants = true
                SubSectionAdd.Position = UDim2.new(0.5, 0, 0, 38)
                SubSectionAdd.Size = UDim2.new(1, 0, 0, 0)
                SubSectionAdd.Name = "SubSectionAdd"
                SubSectionAdd.Parent = SubSection

                local UICornerAdd = Instance.new("UICorner")
                UICornerAdd.CornerRadius = UDim.new(0, 2)
                UICornerAdd.Parent = SubSectionAdd

                local UIListLayoutAdd = Instance.new("UIListLayout")
                UIListLayoutAdd.Padding = UDim.new(0, 3)
                UIListLayoutAdd.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayoutAdd.Parent = SubSectionAdd

                local OpenSection = false
                local function UpdateSizeSection()
                    if OpenSection then
                        local SectionSizeY = 38
                        for _, v in SubSectionAdd:GetChildren() do
                            if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
                                SectionSizeY = SectionSizeY + v.Size.Y.Offset + 3
                            end
                        end
                        TweenService:Create(FeatureImg, TweenInfo.new(0.5), {Rotation = 90}):Play()
                        TweenService:Create(SubSection, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, SectionSizeY)}):Play()
                        TweenService:Create(SubSectionAdd, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, SectionSizeY - 38)}):Play()
                    else
                        TweenService:Create(FeatureImg, TweenInfo.new(0.5), {Rotation = -90}):Play()
                        TweenService:Create(SubSection, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 30)}):Play()
                        TweenService:Create(SubSectionAdd, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    end
                    task.wait(0.5)
                    UpSize(ScrollLayer)
                end

                SubSectionButton.Activated:Connect(function()
                    OpenSection = not OpenSection
                    UpdateSizeSection()
                end)

                SubSectionAdd.ChildAdded:Connect(UpdateSizeSection)
                SubSectionAdd.ChildRemoved:Connect(UpdateSizeSection)

                CountItem = CountItem + 1
                return Items
            end

            CountSection = CountSection + 1
            return Sections
        end

        CountTab = CountTab + 1
        return Sections
    end

    return Tabs
end

return FlurioreLib