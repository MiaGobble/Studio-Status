-- Constants
local SERVICE_TO_STATUS = {
    Workspace = "Editing workspace instances",
    ReplicatedStorage = "Editing replicated storage instances",
    ServerStorage = "Editing server storage instances",
    ServerScriptService = "Editing server script instances",
    ReplicatedFirst = "Editing replicated first instances",
    StarterGui = "Working on user interface",
}

local CLASS_NAME_TO_STATUS = {
    Script = "Selecting server script",
    LocalScript = "Selecting client script",
    ModuleScript = "Selecting module script",
    StarterGui = "Navigating user interface",
    GuiObject = "Working on user interface",
}

local FALLBACK_STATUS_SELECTED = "Currently working on something..."
local FALLBACK_STATUS_NON_SELECTED = "Thinking right now..."

-- Imports
local Bin = script.Parent.Parent
local Objects = Bin:FindFirstChild("Objects")
local Packages = Bin:FindFirstChild("Packages")
local States = require(Objects:FindFirstChild("States"))
local Fusion = require(Packages:FindFirstChild("Fusion"))
local Scope = Fusion.scoped(Fusion)
local Children = Fusion.Children
local Peek = Fusion.peek

local function GetAutomaticStatus(SelectedInstances : {Instance})
    if #SelectedInstances == 0 then
        return FALLBACK_STATUS_NON_SELECTED
    end

    local Status = nil
    local AllAncestorServices = {}
    local AllSelectedClassNames = {}

    for _, Instance in SelectedInstances do
        if Instance:IsA("Service") and SERVICE_TO_STATUS[Instance.Name] then
            table.insert(AllAncestorServices, Instance.Name)
        else
            local AncestorService = Instance:FindFirstAncestorWhichIsA("Service")

            if AncestorService and SERVICE_TO_STATUS[AncestorService.Name] then
                table.insert(AllAncestorServices, AncestorService.Name)
            end
        end

        for ClassName, _ in CLASS_NAME_TO_STATUS do
            if Instance:IsA(ClassName) then
                table.insert(AllSelectedClassNames, ClassName)
            end
        end
    end

    if #AllSelectedClassNames == 1 then
        local ClassName = AllSelectedClassNames[1]

        if CLASS_NAME_TO_STATUS[ClassName] then
            Status = CLASS_NAME_TO_STATUS[ClassName]
        end
    elseif #AllAncestorServices == 1 then
        local ServiceName = AllAncestorServices[1]

        if SERVICE_TO_STATUS[ServiceName] then
            Status = SERVICE_TO_STATUS[ServiceName]
        end
    end

    if not Status then
        Status = FALLBACK_STATUS_SELECTED
    end

    return Status
end

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
            local CanUseStatus = use(States.IsStatusEnabled)

            if not CanUseStatus then
                return ""
            end

            local UseAutomaticStatus = use(States.UseAutomaticStatus)
            local Status = use(States.Status)

            if UseAutomaticStatus then
                local NewStatus = nil

                if use(States.IsRojoSyncing) then
                    NewStatus = "Programming in outside code editor"
                elseif use(States.CurrentActiveScript) then
                    NewStatus = "Programming: " .. use(States.CurrentActiveScript):GetFullName()
                else
                    local SelectedInstances = use(States.CurrentlySelected)
                    local AutomaticStatus = GetAutomaticStatus(SelectedInstances)
    
                    NewStatus = AutomaticStatus
                end
                
                task.defer(function() -- Prevent cyclic errors, hacky as hell
                    if Peek(States.Status).Text == NewStatus then
                        return
                    end

                    Status.Text = NewStatus
                    States.Status:set(Status)
                end)

                return NewStatus
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