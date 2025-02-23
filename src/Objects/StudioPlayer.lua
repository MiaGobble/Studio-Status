local StudioPlayer = {}
StudioPlayer.__index = StudioPlayer

-- Constants
local REFRESH_RATE = 60

-- Services
local PlayersService = game:GetService("Players")
local DebrisService = game:GetService("Debris")
local RunService = game:GetService("RunService")

-- Imports
local Bin = script.Parent.Parent
local Components = Bin:FindFirstChild("Components")
local Packages = Bin:FindFirstChild("Packages")
local StatusBillboard = require(Components:FindFirstChild("StatusBillboard"))
-- local StatusText = require(Components:FindFirstChild("StatusText"))
-- local StatusSelection = require(Components:FindFirstChild("StatusSelection"))
local StatusBin = require(Components:FindFirstChild("StatusBin"))
local Fusion = require(Packages:FindFirstChild("Fusion"))
local Scope = Fusion.scoped(Fusion)
local Children = Fusion.Children

-- Variables
local Camera = workspace.CurrentCamera

function StudioPlayer.new()
    local self = setmetatable({}, StudioPlayer)

    self.Player = PlayersService.LocalPlayer
    self.Attachment = nil
    self.Billboard = nil

    self:Init()

    return self
end

function StudioPlayer:Init()
    if not self.Player then
        return
    end

    for _, Child in workspace.Terrain:GetChildren() do
        if Child:IsA("Attachment") and string.find(Child.Name, "StatusAttachment") then
           if Child.Name == "StatusAttachment_" .. self.Player.Name then
                Child:Destroy()
            end
        end
    end

    self.Attachment = Scope:New "Attachment" {
        Name = "StatusAttachment_" .. self.Player.Name,
        Parent = workspace.Terrain,
        Archivable = false,
        CFrame = CFrame.new(Camera.CFrame.Position)
    }

    self.Billboard = StatusBillboard {
        Parent = self.Attachment,
        Adornee = self.Attachment,

        [Children] = {
            StatusBin {},
        }
    }

    local Connection = RunService.RenderStepped:Connect(function()
        if self.Attachment and self.Attachment.Parent then
            self.Attachment.CFrame = CFrame.new(Camera.CFrame.Position) + Vector3.new(0, 2, 0)
        end
    end)

    DebrisService:AddItem(self.Attachment, REFRESH_RATE)

    task.delay(REFRESH_RATE, function()
        Connection:Disconnect()
        StudioPlayer.new()
    end)
end

return StudioPlayer