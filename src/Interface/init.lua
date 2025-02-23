local Interface = {}

-- Imports
local Bin = script.Parent
local Components = Bin:FindFirstChild("Components")
local Objects = Bin:FindFirstChild("Objects")
local Packages = Bin:FindFirstChild("Packages")
local IconicDesign = Components:FindFirstChild("IconicDesign")
local PluginComponents = IconicDesign:FindFirstChild("PluginComponents")
local StudioComponents = IconicDesign:FindFirstChild("StudioComponents")
local Widget = require(PluginComponents:FindFirstChild("Widget"))
local Background = require(StudioComponents:FindFirstChild("Background"))
local Shadow = require(StudioComponents:FindFirstChild("Shadow"))
local ScrollFrame = require(StudioComponents:FindFirstChild("ScrollFrame"))
local TextInput = require(StudioComponents:FindFirstChild("TextInput"))
local VerticalCollapsibleSection = require(StudioComponents:FindFirstChild("VerticalCollapsibleSection"))
local Checkbox = require(StudioComponents:FindFirstChild("Checkbox"))
local Label = require(StudioComponents:FindFirstChild("Label"))
local States = require(Objects:FindFirstChild("States"))
local Fusion = require(Packages:FindFirstChild("Fusion"))
local Scope = Fusion.scoped(Fusion)
local Peek = Fusion.peek
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

-- Variables
local MainWidget = Widget {
    Id = "StudioStatus",
    Name = "Studio Status",
    InitialDockTo = Enum.InitialDockState.Float,
    InitialEnabled = false,
    ForceInitialEnabled = false,
    FloatingSize = Vector2.new(300, 300),
    MinimumSize = Vector2.new(300, 300),
}

function Interface:Init() : DockWidgetPluginGui
    local MainBackground = Background {
        Name = "Background",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1,
        Parent = MainWidget,
    }

    local Container = ScrollFrame({
        ScrollBarThickness = 12,
        CanvasScaleConstraint = Enum.ScrollingDirection.X,

        UIPadding = Scope:New "UIPadding" {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 30),
            PaddingRight = UDim.new(0, 30),
        },

        UILayout = Scope:New "UIListLayout" {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
        },

        ZIndex = 2,
        Parent = MainWidget,
    }):FindFirstChild("Canvas")

    local StatusContainer = Background {
        Name = "Status",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Parent = Container,
    }

    local StatusInputText; StatusInputText = TextInput {
        Name = "StatusInput",
        AnchorPoint = Vector2.new(0.5, 0),
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.fromScale(0.5, 0),

        PlaceholderText = Scope:Computed(function(use)
            if use(States.UseAutomaticStatus) then
                return "Using automatic status..."
            end

            return "Enter your status here..."
        end),

        TextEditable = true,
        ClearTextOnFocus = false,

        Enabled = Scope:Computed(function(use)
            return use(States.IsEnabled) and use(States.IsStatusEnabled) and not use(States.UseAutomaticStatus)
        end),

        Parent = StatusContainer,
        Text = Peek(States.Status).Text,

        [OnEvent "FocusLost"] = function()
            local Status = Peek(States.Status)
            local NewStatusText = StatusInputText.Text

            if Status.Text == NewStatusText then
                return
            end

            Status.Text = NewStatusText
            States.Status:set(Status)
        end,
    }

    Scope:Observer(States.Status):onChange(function()
        local Status = Peek(States.Status)
        StatusInputText.Text = Status.Text
    end)

    local StatusSettings = VerticalCollapsibleSection {
        Name = "StatusSettings",
        --Size = UDim2.new(1, 0, 0, 50),
        Collapsed = false,
        Padding = UDim.new(0, 10),
        Text = "Status Settings",
        Enabled = States.IsEnabled,
        Parent = Container,

        [Children] = {
            Checkbox {
                Enabled = States.IsEnabled,
                Alignment = Enum.HorizontalAlignment.Left,
                Name = "ShowStatus",
                Text = "Show Status",
                Value = States.IsStatusEnabled,
            },

            Checkbox {
                Enabled = States.IsEnabled,
                Alignment = Enum.HorizontalAlignment.Left,
                Name = "ShowSelectedInstances",
                Text = "Show Selected Instances",
                Value = States.ShowSelectedInstances,
            },

            Checkbox {
                Enabled = States.IsEnabled,
                Alignment = Enum.HorizontalAlignment.Left,
                Name = "SeeOwnStatus",
                Text = "See Your Own Status",
                Value = States.SeeOwnStatus,
            },

            Checkbox {
                Enabled = States.IsEnabled,
                Alignment = Enum.HorizontalAlignment.Left,
                Name = "UseAutomaticStatus",
                Text = "Use Automatic Status",
                Value = States.UseAutomaticStatus,
            },
        }
    }

    local CommandSettings = VerticalCollapsibleSection {
        Name = "CommandSettings",
        --Size = UDim2.new(1, 0, 0, 50),
        Collapsed = true,
        Padding = UDim.new(0, 10),
        Text = "Command Settings",
        Enabled = States.IsEnabled,
        Parent = Container,

        [Children] = {
            Checkbox {
                Enabled = States.IsEnabled,
                Alignment = Enum.HorizontalAlignment.Left,
                Name = "EnableCommands",
                Text = "Enable Commands",
                Value = States.AllowCommands,
            },

            Label {
                Enabled = States.IsEnabled,
                Text = "Below are the commands you can use:",
                TextXAlignment = Enum.TextXAlignment.Left,
            },

            Label {
                Enabled = States.IsEnabled,
                TextSize = 12,
                Text = "shared.StudioStatus_HidePlugin()",
                TextXAlignment = Enum.TextXAlignment.Left,
            },

            Label {
                Enabled = States.IsEnabled,
                TextSize = 12,
                Text = "shared.StudioStatus_ShowPlugin()",
                TextXAlignment = Enum.TextXAlignment.Left,
            },

            Label {
                Enabled = States.IsEnabled,
                TextSize = 12,
                Text = "shared.StudioStatus_SetStatusText(Text : string))",
                TextXAlignment = Enum.TextXAlignment.Left,
            },
        }
    }

    MainWidget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    return MainWidget
end

return Interface