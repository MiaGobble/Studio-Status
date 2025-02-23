-- Constants
local STATUS_TYPE_COLOR_MAP = {
    Online = Color3.fromRGB(0, 0, 0),
    Offline = Color3.fromRGB(90, 90, 90),
    Away = Color3.fromRGB(255, 213, 0),
}

-- Imports
local Bin = script.Parent.Parent
local Objects = Bin:FindFirstChild("Objects")
local Packages = Bin:FindFirstChild("Packages")
local States = require(Objects:FindFirstChild("States"))
local Fusion = require(Packages:FindFirstChild("Fusion"))
local Scope = Fusion.scoped(Fusion)
local Children = Fusion.Children

return function(Properties : {[string] : any})
    return Scope:Hydrate(Scope:New "TextLabel" {
        Name = "StatusSelection",
        BackgroundTransparency = 1,
        TextScaled = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansItalic,
        Size = UDim2.fromScale(1, 0.4),
        Position = UDim2.fromScale(0, 0.6),

        Text = Scope:Computed(function(use)
            local SelectedInstances = use(States.CurrentlySelected)
            local CanUseStatus = use(States.IsStatusEnabled)
            local ShowSelectedInstances = use(States.ShowSelectedInstances)

            if not CanUseStatus or not ShowSelectedInstances then
                return ""
            end

            if #SelectedInstances == 0 then
                return "No instances selected"
            end

            if #SelectedInstances > 1 then
                return "Multiple instances selected"
            end

            return `Selecting: {SelectedInstances[1].Name}`
        end),

        [Children] = {
            Scope:New "UIPadding" {
                PaddingTop = UDim.new(0.05, 0),
                PaddingBottom = UDim.new(0.05, 0),
                PaddingLeft = UDim.new(0.05, 0),
                PaddingRight = UDim.new(0.05, 0),
            },

            Scope:New "UIStroke" {
                Thickness = 1,
                Transparency = 0.5,

                Color = Scope:Computed(function(use)
                    local StatusType = use(States.StatusType)
                    return STATUS_TYPE_COLOR_MAP[StatusType] or Color3.fromRGB(255, 255, 255)
                end),
            }
        }
    })(Properties)
end