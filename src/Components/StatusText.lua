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
        Name = "StatusText",
        BackgroundTransparency = 1,
        TextScaled = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        Size = UDim2.fromScale(1, 0.6),
        Position = UDim2.fromScale(0, 0),

        Text = Scope:Computed(function(use)
            local Status = use(States.Status)
            local CanUseStatus = use(States.IsStatusEnabled)

            if not CanUseStatus then
                return ""
            end

            if Status.Text == "" then
                return ""
            end

            return Status.Text
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
            }
        }
    })(Properties)
end