-- Services
local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Imports
local Fusion = require(script.Parent.Parent:FindFirstChild("Packages"):FindFirstChild("Fusion"))
local Scope = Fusion.scoped(Fusion)


return {
    -- Whether team create is enabled
    IsTeamCreate = Scope:Value(if #PlayersService:GetPlayers() > 1 then true else false),

    -- The user-set status
    Status = Scope:Value({
        Emoji = "",
        Color = Color3.fromRGB(255, 255, 255),
        Text = "",
    }),

    -- The instances the current user has selected
    CurrentlySelected = Scope:Value({}),

    -- Whether studio is not in run mode
    IsEnabled = Scope:Value(not (RunService:IsRunning() or RunService:IsRunMode())),

    -- Status Settings
    IsStatusEnabled = Scope:Value(true),
    ShowSelectedInstances = Scope:Value(true),
    SeeOwnStatus = Scope:Value(false),

    -- Command Settings
    AllowCommands = Scope:Value(false),
}