-- Services
local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

-- Imports
local Fusion = require(script.Parent.Parent:FindFirstChild("Packages"):FindFirstChild("Fusion"))
local Scope = Fusion.scoped(Fusion)


return {
    -- The current user
    LocalPlayer = Scope:Value(PlayersService.LocalPlayer),

    -- Whether team create is enabled
    IsTeamCreate = Scope:Value(if #PlayersService:GetPlayers() > 1 then true else false),

    -- The user-set status
    Status = Scope:Value({
        Emoji = "",
        ColorR = 255,
        ColorG = 255,
        ColorB = 255,
        Text = "",
    }),

    -- Whether the user is online, offline, or away
    StatusType = Scope:Value("Online"),

    -- The instances the current user has selected
    CurrentlySelected = Scope:Value({}),

    -- Whether studio is not in run mode
    IsEnabled = Scope:Value(not (RunService:IsRunning() or RunService:IsRunMode())),

    -- Whether Rojo is being used
    IsRojoSyncing = Scope:Value(false),

    -- The script being edited
    CurrentActiveScript = Scope:Value(nil),

    -- Set by command
    IsPluginVisible = Scope:Value(true),

    -- Status Settings
    IsStatusEnabled = Scope:Value(true),
    ShowSelectedInstances = Scope:Value(true),
    SeeOwnStatus = Scope:Value(false),
    UseAutomaticStatus = Scope:Value(false),
    IsOffline = Scope:Value(false),

    -- Command Settings
    AllowCommands = Scope:Value(false),
}