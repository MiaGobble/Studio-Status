-- Constants
local STATUS_TYPE_COLOR_MAP = {
    Online = Color3.fromRGB(70, 228, 83),
    Offline = Color3.fromRGB(221, 63, 63),
    Away = Color3.fromRGB(255, 213, 0),
}

-- Imports
local Components = script.Parent
local Bin = Components.Parent
local Objects = Bin:FindFirstChild("Objects")
local Packages = Bin:FindFirstChild("Packages")
local StatusSelection = require(Components:FindFirstChild("StatusSelection"))
local StatusText = require(Components:FindFirstChild("StatusText"))
local States = require(Objects:FindFirstChild("States"))
local Fusion = require(Packages:FindFirstChild("Fusion"))
local Scope = Fusion.scoped(Fusion)
local Children = Fusion.Children

return function(Properties : {[string] : any})
    return Scope:Hydrate(Scope:New "CanvasGroup" {
        Name = "StatusBin",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.fromRGB(21, 21, 21),
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(0, 100),
        ZIndex = 1,

        [Children] = {
            Scope:New "UICorner" {
                CornerRadius = UDim.new(0, 20),
            },

            Scope:New "UIListLayout" {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0, 5),
            },

            Scope:New "Frame" {
                Name = "StatusTypeIndicator",
                AnchorPoint = Vector2.new(0, 0),
                BackgroundTransparency = 0,
                Size = UDim2.new(0, 25, 1, 0),
                LayoutOrder = 0,
                BorderSizePixel = 0,

                BackgroundColor3 = Scope:Computed(function(use)
                    local StatusType = use(States.StatusType)
                    return STATUS_TYPE_COLOR_MAP[StatusType] or Color3.fromRGB(255, 255, 255)
                end),
            },

            Scope:New "Frame" {
                Name = "Status",
                AnchorPoint = Vector2.new(0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 1),
                LayoutOrder = 1,

                [Children] = {
                    Scope:New "UIPadding" {
                        PaddingTop = UDim.new(0, 12),
                        PaddingBottom = UDim.new(0, 12),
                        PaddingLeft = UDim.new(0, 20),
                        PaddingRight = UDim.new(0, 12),
                    },

                    Scope:New "UIListLayout" {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        FillDirection = Enum.FillDirection.Vertical,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        Padding = UDim.new(0, 0),
                    },

                    StatusText {
                        LayoutOrder = 0,
                        Size = UDim2.new(0, 50, 0.5, 0),
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextScaled = false,
                        TextWrapped = false,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Center,
                        LineHeight = 0,
                        TextSize = 40,
                    },

                    StatusSelection {
                        LayoutOrder = 1,
                        Size = UDim2.new(0, 50, 0.4, 0),
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextScaled = false,
                        TextWrapped = false,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Center,
                        LineHeight = 0,
                        TextSize = 30,
                    },
                }
            }
        }
    })(Properties)
end