-- Load Moonlib Library
local success, library = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/jakepscripts/moonlib/main/moonlibv1.lua'))()
end)

if not success or not library then
    warn("Failed to load Moonlib library.")
    return
end

-- Create GUI Window
local window = library:CreateWindow("Zombie Rush Moon Hub V7")

-- Add Notification Function
local function notify(message)
    library:Notify({
        Title = "Moon Hub Notification",
        Text = message,
        Duration = 5
    })
end

-- Display Initial Notifications
notify("Welcome to Zombie Rush Moon Hub V7! Discord - meowbucks")
task.wait(1)  -- Wait before the next notification
notify("Moon Hub V7!!!!!!")

-- Variables
local espEnabled = false
local rainbowESPEnabled = false
local espColor = Color3.fromRGB(255, 0, 0)
local espRainbowSpeed = 1
local espOutlineThickness = 2
local espTextSize = 14
local armVisualsEnabled = false
local zombieVisualsEnabled = false
local tracersEnabled = false
local hvhSpinbotEnabled = false
local killAllEnabled = false
local silentAimEnabled = false

-- Visuals Tab
local visualsTab = window:CreateTab("Visuals")

-- Create ESP and Visuals Options in the GUI
local function updateESP()
    if not espEnabled then return end

    for _, zombie in ipairs(workspace.Zombies:GetChildren()) do
        if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
            local esp = zombie:FindFirstChild("ESP")
            if not esp then
                esp = Instance.new("BillboardGui", zombie)
                esp.Name = "ESP"
                esp.Size = UDim2.new(0, 150, 0, 50)
                esp.StudsOffset = Vector3.new(0, 3, 0)
                esp.AlwaysOnTop = true

                local textLabel = Instance.new("TextLabel", esp)
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = zombie.Name
                textLabel.TextColor3 = espColor
                textLabel.TextStrokeTransparency = 0.5
                textLabel.TextSize = espTextSize
            end
        end
    end
end

local function drawTracers()
    if not tracersEnabled then return end
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera

    for _, zombie in ipairs(workspace.Zombies:GetChildren()) do
        if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = camera:WorldToScreenPoint(zombie.HumanoidRootPart.Position)
            if onScreen then
                local tracer = Instance.new("Frame", player.PlayerGui)
                tracer.Size = UDim2.new(0, 2, 0, (screenPos.Y - camera.ViewportSize.Y / 2) / camera.ViewportSize.Y)
                tracer.Position = UDim2.new((screenPos.X / camera.ViewportSize.X) - 0.5, 0, 0.5, 0)
                tracer.BackgroundColor3 = espColor
                tracer.BackgroundTransparency = 0
            end
        end
    end
end

-- Rainbow ESP Color Function
local function rainbowESP()
    local hue = tick() * espRainbowSpeed % 1
    espColor = Color3.fromHSV(hue, 1, 1)
end

-- Function to Update Visuals
local function updateVisuals()
    if armVisualsEnabled then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("RightArm") then
                player.Character.RightArm.BrickColor = BrickColor.new("Bright blue")
            end
        end
    end
    
    if zombieVisualsEnabled then
        for _, zombie in ipairs(workspace.Zombies:GetChildren()) do
            if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
                zombie.HumanoidRootPart.BrickColor = BrickColor.new("Bright red")
            end
        end
    end
end

-- HVH Features
local function spinbot()
    while hvhSpinbotEnabled do
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
        end
        task.wait(0.1)
    end
end

local function killAllZombies()
    local player = game.Players.LocalPlayer
    local currentWeapon = player.Backpack:FindFirstChildWhichIsA("Tool")

    if currentWeapon then
        for _, zombie in ipairs(workspace.Zombies:GetChildren()) do
            if zombie:IsA("Model") and zombie:FindFirstChild("Humanoid") then
                zombie.Humanoid.Health = 0
            end
        end
    end
end

-- GUI Controls
local silentAimToggle = window:CreateToggle("Silent Aim V2", false, function(state)
    silentAimEnabled = state
end)

local espToggle = window:CreateToggle("ESP", false, function(state)
    espEnabled = state
    updateESP()
end)

local tracersToggle = window:CreateToggle("Tracers", false, function(state)
    tracersEnabled = state
end)

local rainbowESPToggle = visualsTab:CreateToggle("Rainbow ESP", false, function(state)
    rainbowESPEnabled = state
end)

local espRainbowSpeedSlider = visualsTab:CreateSlider("Rainbow Speed", 0, 5, 1, function(value)
    espRainbowSpeed = value
end)

local espOutlineThicknessSlider = visualsTab:CreateSlider("ESP Outline Thickness", 1, 10, 1, function(value)
    espOutlineThickness = value
end)

local espTextSizeSlider = visualsTab:CreateSlider("ESP Text Size", 10, 30, 1, function(value)
    espTextSize = value
end)

local armVisualsToggle = visualsTab:CreateToggle("Arm Visuals", false, function(state)
    armVisualsEnabled = state
    updateVisuals()
end)

local zombieVisualsToggle = visualsTab:CreateToggle("Zombie Visuals", false, function(state)
    zombieVisualsEnabled = state
    updateVisuals()
end)

local hvhSpinbotToggle = window:CreateToggle("Spinbot", false, function(state)
    hvhSpinbotEnabled = state
    if state then
        task.spawn(spinbot)
    end
end)

local killAllToggle = window:CreateToggle("Kill All Zombies", false, function(state)
    killAllEnabled = state
    if state then
        killAllZombies()
    end
end)

-- Rainbow ESP Update Loop
task.spawn(function()
    while true do
        if rainbowESPEnabled then
            rainbowESP()
            updateESP()
        end
        task.wait(0.1)
    end
end)

-- Tracer Update Loop
task.spawn(function()
    while true do
        if tracersEnabled then
            drawTracers()
        end
        task.wait(0.1)
    end
end)

-- Notifications for Features
notify("Moon Hub V7 Features Loaded!")

-- End of Script
