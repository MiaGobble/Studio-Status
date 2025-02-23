-- Constants
local TICK_RATE = 1 / 2
local AFK_TIMEOUT = 60

-- Services
local RunService = game:GetService("RunService")
local SelectionService = game:GetService("Selection") :: Selection
local StudioService = game:GetService("StudioService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

-- Imports
local Components = script.Parent:FindFirstChild("Components")
local IconicDesign = Components:FindFirstChild("IconicDesign")
local PluginComponents = IconicDesign:FindFirstChild("PluginComponents")
local Objects = script.Parent:FindFirstChild("Objects")
local Interface = require(script.Parent:FindFirstChild("Interface"))
local Toolbar = require(PluginComponents:FindFirstChild("Toolbar"))
local ToolbarButton = require(PluginComponents:FindFirstChild("ToolbarButton"))
local States = require(Objects:FindFirstChild("States"))
local StateOutput = require(script.Parent:FindFirstChild("StateOutput"))
local StudioPlayer = require(Objects:FindFirstChild("StudioPlayer"))
local Fusion = require(script.Parent:FindFirstChild("Packages"):FindFirstChild("Fusion"))
local Peek = Fusion.peek

-- Variables
local ThisToolbar = Toolbar {
    Name = "Studio Status",
}

local MainButton = ToolbarButton {
    ToolTip = "Studio Status",
    Name = "Studio Status",
    Image = "rbxassetid://130617606456456",
    Toolbar = ThisToolbar,
} :: PluginToolbarButton

local function Init()
    if RunService:IsRunning() or RunService:IsRunMode() then -- Don't init if running in studio
        return
    end

    StateOutput:Init()

    local Widget : DockWidgetPluginGui = Interface:Init()
    local LastTick = os.clock()
    local LastInteraction = os.clock()

    StudioPlayer.new()

    MainButton.Click:Connect(function()
        Widget.Enabled = not Widget.Enabled
    end)

    SelectionService.SelectionChanged:Connect(function()
        LastInteraction = os.clock()
        States.CurrentlySelected:set(SelectionService:Get())
    end)

    RunService.Heartbeat:Connect(function()
        if os.clock() - LastTick >= TICK_RATE then
            LastTick = os.clock()

            local IsRojoSyncing = _G.ROJO_DEV_CREATE ~= nil or ServerStorage:FindFirstChild("__Rojo_SessionLock") ~= nil
            local CurrentActiveScript = StudioService.ActiveScript

            if IsRojoSyncing or IsRojoSyncing ~= Peek(States.IsRojoSyncing) then
                LastInteraction = os.clock()
            elseif CurrentActiveScript or CurrentActiveScript ~= Peek(States.CurrentActiveScript) then
                LastInteraction = os.clock()
            end

            States.IsRojoSyncing:set(IsRojoSyncing)
            States.CurrentActiveScript:set(CurrentActiveScript)

            if not Peek(States.IsOffline) then
                if os.clock() - LastInteraction >= AFK_TIMEOUT then
                    States.StatusType:set("Away")
                elseif Peek(States.StatusType) == "Away" then
                    States.StatusType:set("Online")
                end
            end
        end
    end)
end

Init()