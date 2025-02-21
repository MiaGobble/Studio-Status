-- Services
local PlayersService = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Imports
local Components = script.Parent:FindFirstChild("Components")
local IconicDesign = Components:FindFirstChild("IconicDesign")
local PluginComponents = IconicDesign:FindFirstChild("PluginComponents")
local Objects = script.Parent:FindFirstChild("Objects")
local Interface = require(script.Parent:FindFirstChild("Interface"))
local Toolbar = require(PluginComponents:FindFirstChild("Toolbar"))
local ToolbarButton = require(PluginComponents:FindFirstChild("ToolbarButton"))
local States = require(Objects:FindFirstChild("States"))

-- Variables
local ThisToolbar = Toolbar {
    Name = "Studio Status",
}

local MainButton = ToolbarButton {
    ToolTip = "Studio Status",
    Name = "Studio Status",
    Image = "rbxassetid://14184355227",
    Toolbar = ThisToolbar,
} :: PluginToolbarButton

local function Init()
    if RunService:IsRunning() or RunService:IsRunMode() then -- Don't init if running in studio
        return
    end

    local Widget : DockWidgetPluginGui = Interface:Init()

    MainButton.Click:Connect(function()
        Widget.Enabled = not Widget.Enabled
    end)

    PlayersService.PlayerAdded:Once(function()
        States.IsTeamCreate:set(true)
    end)
end

Init()