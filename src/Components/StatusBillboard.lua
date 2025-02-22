-- Imports
local Bin = script.Parent.Parent
local Objects = Bin:FindFirstChild("Objects")
local Packages = Bin:FindFirstChild("Packages")
local States = require(Objects:FindFirstChild("States"))
local Fusion = require(Packages:FindFirstChild("Fusion"))
local Scope = Fusion.scoped(Fusion)

return function(Properties : {[string] : any})
    return Scope:Hydrate(Scope:New "BillboardGui" {
        Name = Scope:Computed(function(use)
            local Player = use(States.LocalPlayer)

            if not Player then
                return "StatusBillboard"
            end

            return "StatusBillboard_" .. Player.Name
        end),

        PlayerToHideFrom = Scope:Computed(function(use)
            local Player = use(States.LocalPlayer)

            if not Player then
                return nil
            end

            if use(States.SeeOwnStatus) then
                return nil
            end

            return Player
        end),

        Archivable = false,
        Active = true,
        Enabled = States.IsStatusEnabled,
        Size = UDim2.fromScale(8, 1.5) + UDim2.fromOffset(50, 25),
        ResetOnSpawn = false,
        LightInfluence = 0.2,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = workspace.Terrain,
        MaxDistance = 100,
        AlwaysOnTop = true,
    })(Properties)
end