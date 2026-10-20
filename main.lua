local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera           = workspace.CurrentCamera

local player = Players.LocalPlayer
local scriptStartTime = os.time()

local C = {
    orange     = Color3.fromRGB(255, 105, 45),
    white      = Color3.fromRGB(235, 240, 248),
    dim        = Color3.fromRGB(130, 140, 158),
    bg         = Color3.fromRGB(8,  13,  19),
    sidebar    = Color3.fromRGB(10, 15,  22),
    border     = Color3.fromRGB(40, 51,  65),
    highlight  = Color3.fromRGB(31, 24,  23),
    itemBg     = Color3.fromRGB(15, 20,  30),
}

local State = {
    aimbot360  = false,
    aimFov     = false,
    aimPart    = "Head",
    aimDist360 = 150,
    aimDistFov = 150,
    fovRadius  = 120,
    espLines   = false,
    espHealth  = false,
    speedVal   = 16,
    jumpVal    = 50,
}

local gui = Instance.new("ScreenGui")
gui.Name           = "AimbotMenu"
gui.ResetOnSpawn   = false
gui.IgnoreGuiInset = true
gui.DisplayOrder   = 100
gui.Parent         = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name             = "Main"
main.AnchorPoint      = Vector2.new(0.5, 0.5)
main.Size             = UDim2.new(0.66, 0, 0.65, 0)
main.Position         = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = C.bg
main.BorderSizePixel  = 0
main.ClipsDescendants = true
main.Parent           = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local ms = Instance.new("UIStroke", main)
ms.Color = C.border; ms.Thickness = 1.5
local sc = Instance.new("UISizeConstraint", main)
sc.MinSize = Vector2.new(300, 260); sc.MaxSize = Vector2.new(900, 640)

local sidebar = Instance.new("Frame")
sidebar.Size             = UDim2.new(0.23, 0, 1, 0)
sidebar.BackgroundColor3 = C.sidebar
sidebar.BorderSizePixel  = 0
sidebar.Parent           = main
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)
local sl = Instance.new("Frame", sidebar)
sl.Size = UDim2.new(0, 1, 1, 0); sl.Position = UDim2.new(1, -1, 0, 0)
sl.BackgroundColor3 = C.border; sl.BorderSizePixel = 0

local header = Instance.new("TextLabel")
header.Position               = UDim2.new(0.27, 8, 0, 10)
header.Size                   = UDim2.new(0.62, -35, 0, 38)
header.BackgroundTransparency = 1
header.Text                   = "⊙  AIMBOT"
header.TextColor3             = C.orange
header.TextSize               = 20
header.Font                   = Enum.Font.GothamBold
header.TextXAlignment         = Enum.TextXAlignment.Left
header.Parent                 = main

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint            = Vector2.new(1, 0)
closeBtn.Position               = UDim2.new(1, -8, 0, 7)
closeBtn.Size                   = UDim2.fromOffset(34, 34)
closeBtn.BackgroundTransparency = 1
closeBtn.Text                   = "×"
closeBtn.TextColor3             = C.orange
closeBtn.TextSize               = 30
closeBtn.Font                   = Enum.Font.Gotham
closeBtn.Parent                 = main
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local content = Instance.new("Frame")
content.Position               = UDim2.new(0.23, 2, 0, 50)
content.Size                   = UDim2.new(0.77, -4, 1, -52)
content.BackgroundTransparency = 1
content.ClipsDescendants       = true
content.Parent                 = main

local moon = Instance.new("TextButton")
moon.AnchorPoint      = Vector2.new(1, 0)
moon.Position         = UDim2.new(1, -10, 0, 10)
moon.Size             = UDim2.fromOffset(40, 40)
moon.BackgroundColor3 = Color3.fromRGB(20, 27, 37)
moon.Text             = "🌙"; moon.TextSize = 22
moon.Font             = Enum.Font.Gotham
moon.AutoButtonColor  = true
moon.Parent           = gui
Instance.new("UICorner", moon).CornerRadius = UDim.new(1, 0)
local mnS = Instance.new("UIStroke", moon)
mnS.Color = C.border; mnS.Thickness = 1

local menuVisible = true
moon.MouseButton1Click:Connect(function()
    menuVisible  = not menuVisible
    main.Visible = menuVisible
    moon.Text    = menuVisible and "🌙" or "☀️"
end)

local function makePage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name                  = name .. "Page"
    sf.Size                  = UDim2.fromScale(1, 1)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel       = 0
    sf.ScrollBarThickness    = 3
    sf.ScrollBarImageColor3  = C.border
    sf.CanvasSize            = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    sf.Visible               = false
    sf.Parent                = content
    local lay = Instance.new("UIListLayout", sf)
    lay.Padding              = UDim.new(0, 8)
    lay.HorizontalAlignment  = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", sf).PaddingTop = UDim.new(0, 10)
    return sf
end

local function makeRow(parent, h)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, -16, 0, h or 44)
    row.BackgroundColor3 = C.itemBg
    row.BorderSizePixel  = 0
    row.Parent           = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    return row
end

local function makeToggle(parent, label, sublabel, onChange)
    local row = makeRow(parent, 50)
    local lbl = Instance.new("TextLabel")
    lbl.Position               = UDim2.new(0, 12, 0, 0)
    lbl.Size                   = UDim2.new(0.65, 0, 0.55, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = label
    lbl.TextColor3             = C.white
    lbl.TextSize               = 14
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.Parent                 = row

    if sublabel then
        local sub = Instance.new("TextLabel")
        sub.Position               = UDim2.new(0, 12, 0.52, 0)
        sub.Size                   = UDim2.new(0.65, 0, 0.48, 0)
        sub.BackgroundTransparency = 1
        sub.Text                   = sublabel
        sub.TextColor3             = C.dim
        sub.TextSize               = 11
        sub.Font                   = Enum.Font.Gotham
        sub.TextXAlignment         = Enum.TextXAlignment.Left
        sub.Parent                 = row
    end

    local pill = Instance.new("Frame")
    pill.AnchorPoint      = Vector2.new(1, 0.5)
    pill.Position         = UDim2.new(1, -12, 0.5, 0)
    pill.Size             = UDim2.fromOffset(44, 24)
    pill.BackgroundColor3 = C.border
    pill.BorderSizePixel  = 0
    pill.Parent           = row
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.fromOffset(18, 18)
    knob.Position         = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel  = 0
    knob.Parent           = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local on = false
    local function set(v)
        on                    = v
        pill.BackgroundColor3 = on and C.orange or C.border
        knob.Position         = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        if onChange then onChange(on) end
    end

    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                   = ""
    btn.Parent                 = row
    btn.MouseButton1Click:Connect(function() set(not on) end)
    return function() return on end, set
end

local function makeStepper(parent, label, minV, maxV, defaultV, step, suffix, onChange)
    local row = makeRow(parent, 54)
    local lbl = Instance.new("TextLabel")
    lbl.Position               = UDim2.new(0, 12, 0, 6)
    lbl.Size                   = UDim2.new(0.55, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = label
    lbl.TextColor3             = C.white
    lbl.TextSize               = 13
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.Parent                 = row

    local btnMinus = Instance.new("TextButton")
    btnMinus.AnchorPoint      = Vector2.new(0, 0.5)
    btnMinus.Position         = UDim2.new(0, 10, 0.62, 0)
    btnMinus.Size             = UDim2.fromOffset(28, 24)
    btnMinus.BackgroundColor3 = Color3.fromRGB(25, 33, 45)
    btnMinus.Text             = "−"
    btnMinus.TextColor3       = C.orange
    btnMinus.TextSize         = 18
    btnMinus.Font             = Enum.Font.GothamBold
    btnMinus.BorderSizePixel  = 0
    btnMinus.AutoButtonColor  = false
    btnMinus.Parent           = row
    Instance.new("UICorner", btnMinus).CornerRadius = UDim.new(0, 6)

    local valLbl = Instance.new("TextLabel")
    valLbl.AnchorPoint            = Vector2.new(0, 0.5)
    valLbl.Position               = UDim2.new(0, 44, 0.62, 0)
    valLbl.Size                   = UDim2.new(0, 70, 0, 24)
    valLbl.BackgroundTransparency = 1
    valLbl.Text                   = tostring(defaultV) .. (suffix or "")
    valLbl.TextColor3             = C.orange
    valLbl.TextSize               = 13
    valLbl.Font                   = Enum.Font.GothamBold
    valLbl.TextXAlignment         = Enum.TextXAlignment.Center
    valLbl.Parent                 = row

    local btnPlus = Instance.new("TextButton")
    btnPlus.AnchorPoint      = Vector2.new(0, 0.5)
    btnPlus.Position         = UDim2.new(0, 120, 0.62, 0)
    btnPlus.Size             = UDim2.fromOffset(28, 24)
    btnPlus.BackgroundColor3 = Color3.fromRGB(25, 33, 45)
    btnPlus.Text             = "+"
    btnPlus.TextColor3       = C.orange
    btnPlus.TextSize         = 18
    btnPlus.Font             = Enum.Font.GothamBold
    btnPlus.BorderSizePixel  = 0
    btnPlus.AutoButtonColor  = false
    btnPlus.Parent           = row
    Instance.new("UICorner", btnPlus).CornerRadius = UDim.new(0, 6)

    local value = defaultV
    local function update(v)
        value       = math.clamp(v, minV, maxV)
        valLbl.Text = tostring(value) .. (suffix or "")
        if onChange then onChange(value) end
    end

    local function holdLoop(btn, dir)
        btn.MouseButton1Down:Connect(function()
            update(value + dir * step)
            local held = true
            task.delay(0.4, function()
                while held and btn.Parent do
                    update(value + dir * step)
                    task.wait(0.08)
                end
            end)
            btn.MouseButton1Up:Connect(function() held = false end)
            btn.MouseLeave:Connect(function() held = false end)
        end)
    end
    holdLoop(btnMinus, -1)
    holdLoop(btnPlus, 1)
    return function() return value end
end

local tabData = {
    {name = "Aimbot",  icon = "⊙"},
    {name = "Visuals", icon = "◎"},
    {name = "Misc",    icon = "◇"},
    {name = "Account", icon = "♙"},
}
local pages   = {}
local buttons = {}

local function switchTab(name, icon)
    for k, p in pairs(pages) do
        local sel = (k == name)
        p.Visible                   = sel
        buttons[k].TextColor3       = sel and C.orange or C.white
        buttons[k].BackgroundColor3 = sel and C.highlight or C.sidebar
    end
    header.Text = icon .. "  " .. string.upper(name)
end

for i, d in ipairs(tabData) do
    local btn = Instance.new("TextButton")
    btn.Position         = UDim2.new(0, 6, 0, 10 + (i-1)*62)
    btn.Size             = UDim2.new(1, -12, 0, 54)
    btn.BackgroundColor3 = C.sidebar
    btn.BorderSizePixel  = 0
    btn.Text             = d.icon .. "\n" .. d.name
    btn.TextColor3       = C.white
    btn.TextSize         = 14
    btn.Font             = Enum.Font.GothamMedium
    btn.TextWrapped      = true
    btn.AutoButtonColor  = false
    btn.Parent           = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    buttons[d.name] = btn
    pages[d.name]   = makePage(d.name)
    btn.MouseButton1Click:Connect(function() switchTab(d.name, d.icon) end)
end

local aimbotPage = pages["Aimbot"]

local partRow = makeRow(aimbotPage, 46)
local partLbl = Instance.new("TextLabel", partRow)
partLbl.Position = UDim2.new(0, 12, 0, 0); partLbl.Size = UDim2.new(0.5, 0, 1, 0)
partLbl.BackgroundTransparency = 1; partLbl.Text = "Khu vực Aim"
partLbl.TextColor3 = C.white; partLbl.TextSize = 14; partLbl.Font = Enum.Font.GothamMedium; partLbl.TextXAlignment = Enum.TextXAlignment.Left

local partBtn = Instance.new("TextButton", partRow)
partBtn.AnchorPoint = Vector2.new(1, 0.5); partBtn.Position = UDim2.new(1, -12, 0.5, 0)
partBtn.Size = UDim2.fromOffset(90, 28); partBtn.BackgroundColor3 = Color3.fromRGB(25, 33, 45)
partBtn.Text = "HEAD"; partBtn.TextColor3 = C.orange; partBtn.TextSize = 13; partBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", partBtn).CornerRadius = UDim.new(0, 6)

partBtn.MouseButton1Click:Connect(function()
    if State.aimPart == "Head" then
        State.aimPart = "Torso"
        partBtn.Text = "TORSO"
    else
        State.aimPart = "Head"
        partBtn.Text = "HEAD"
    end
end)

makeToggle(aimbotPage, "Aimbot 360°", "Bật để tự động ngắm toàn bản đồ", function(on) State.aimbot360 = on end)
makeStepper(aimbotPage, "Khoảng cách 360°", 10, 500, 150, 10, " stud", function(v) State.aimDist360 = v end)

local sep1 = Instance.new("Frame", aimbotPage)
sep1.Size = UDim2.new(1, -16, 0, 1); sep1.BackgroundColor3 = C.border; sep1.BorderSizePixel = 0

makeToggle(aimbotPage, "Aim FOV", "Bật để tự động ngắm trong vòng tròn", function(on) State.aimFov = on end)
makeStepper(aimbotPage, "Bán kính FOV", 30, 400, 120, 10, " px", function(v) State.fovRadius = v end)
makeStepper(aimbotPage, "Khoảng cách FOV", 10, 500, 150, 10, " stud", function(v) State.aimDistFov = v end)

local visualPage = pages["Visuals"]
makeToggle(visualPage, "ESP Line + Box", "Đường kẻ từ góc trên + box nhân vật", function(on) State.espLines = on end)
makeToggle(visualPage, "Health Bar", "Xanh / Cam / Đỏ kế bên nhân vật", function(on) State.espHealth = on end)

local miscPage = pages["Misc"]
makeStepper(miscPage, "Speed Boost", 16, 250, 16, 2, " sp", function(v)
    State.speedVal = v
    local char = player.Character
    if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed = v end end
end)
makeStepper(miscPage, "Jump Boost", 50, 500, 50, 10, " jp", function(v)
    State.jumpVal = v
    local char = player.Character
    if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum.JumpPower = v end end
end)

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = State.speedVal
    hum.JumpPower = State.jumpVal
end)

local accountPage = pages["Account"]
local infoRow     = makeRow(accountPage, 215)
infoRow.Size      = UDim2.new(1, -16, 0, 215)

local infoFields = {
    {key = "Name",         val = player.DisplayName},
    {key = "@name",        val = "@" .. player.Name},
    {key = "Time Play",    val = "00:00:00"},
    {key = "Ngày tạo Acc", val = "..."},
    {key = "Real Time",    val = ""},
}
local fieldLabels = {}
for i, f in ipairs(infoFields) do
    local y = 12 + (i-1)*38
    local kLbl = Instance.new("TextLabel", infoRow)
    kLbl.Position = UDim2.new(0, 14, 0, y); kLbl.Size = UDim2.new(0.44, 0, 0, 28)
    kLbl.BackgroundTransparency = 1; kLbl.Text = f.key .. ":"
    kLbl.TextColor3 = C.dim; kLbl.TextSize = 13; kLbl.Font = Enum.Font.GothamMedium

    local vLbl = Instance.new("TextLabel", infoRow)
    vLbl.Position = UDim2.new(0.44, 0, 0, y); vLbl.Size = UDim2.new(0.53, 0, 0, 28)
    vLbl.BackgroundTransparency = 1; vLbl.Text = f.val
    vLbl.TextColor3 = C.orange; vLbl.TextSize = 13; vLbl.Font = Enum.Font.GothamBold
    fieldLabels[f.key] = vLbl
end

task.spawn(function()
    task.wait(1)
    if fieldLabels["Ngày tạo Acc"] then fieldLabels["Ngày tạo Acc"].Text = tostring(player.AccountAge) .. " ngày" end
end)

local fovCircle        = Drawing.new("Circle")
fovCircle.Visible      = false
fovCircle.Radius       = State.fovRadius
fovCircle.Color        = Color3.fromRGB(85, 255, 85)
fovCircle.Thickness    = 2
fovCircle.Filled       = false
fovCircle.Transparency = 1

local espData = {}
local function getOrCreateEsp(plr)
    if not espData[plr] then
        local function L(col, thick)
            local l = Drawing.new("Line")
            l.Visible   = false
            l.Thickness = thick or 2
            l.Color     = col or Color3.fromRGB(255, 255, 255)
            return l
        end
        espData[plr] = {
            line = L(Color3.fromRGB(255, 105, 45)),
            boxT = L(), boxB = L(), boxL = L(), boxR = L(),
            hpBg = L(Color3.fromRGB(25, 25, 25), 6),
            hpFg = L(nil, 4),
        }
    end
    return espData[plr]
end

Players.PlayerRemoving:Connect(function(plr)
    if espData[plr] then
        for _, d in pairs(espData[plr]) do d:Remove() end
        espData[plr] = nil
    end
end)

local function hasWall(origin, target)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local chars = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then table.insert(chars, p.Character) end
    end
    params.FilterDescendantsInstances = chars
    return workspace:Raycast(origin, target - origin, params) ~= nil
end

local function getClosestTarget(useFov)
    local myChar = player.Character
    if not myChar then return nil end
    
    local camPos  = Camera.CFrame.Position
    local vp      = Camera.ViewportSize
    local center  = Vector2.new(vp.X / 2, vp.Y / 2)
    local maxDist = useFov and State.aimDistFov or State.aimDist360
    local best, bestScore = nil, useFov and State.fovRadius or math.huge

    for _, p in ipairs(Players:GetPlayers()) do
        if p == player or not p.Character then continue end
        
        local targetPart = nil
        if State.aimPart == "Head" then
            targetPart = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
        else
            targetPart = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("UpperTorso")
        end
        
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if not targetPart or not hum or hum.Health <= 0 then continue end
        
        local distToCam = (targetPart.Position - camPos).Magnitude
        if distToCam > maxDist then continue end
        if State.aimbot360 and hasWall(camPos, targetPart.Position) then continue end

        if useFov then
            local sp, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if not onScreen then continue end
            local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
            if d < bestScore then bestScore = d; best = targetPart end
        else
            if distToCam < bestScore then bestScore = distToCam; best = targetPart end
        end
    end
    return best
end

local function hpColor(pct)
    if pct > 0.6 then return Color3.fromRGB(85, 255, 85)
    elseif pct > 0.3 then return Color3.fromRGB(255, 165, 0)
    else return Color3.fromRGB(255, 60, 60) end
end

RunService.RenderStepped:Connect(function()
    local vp     = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local topMid = Vector2.new(vp.X / 2, 0)

    fovCircle.Visible = State.aimFov
    if State.aimFov then
        fovCircle.Position = center
        fovCircle.Radius   = State.fovRadius
    end

    local aiming = State.aimbot360 or State.aimFov
    if aiming then
        local target = getClosestTarget(State.aimFov)
        if target then
            -- Khóa góc nhìn thẳng vào mục tiêu ngay lập tức (bỏ Lerp để không bị trễ)
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == player then continue end
        local d    = getOrCreateEsp(p)
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")

        if (not State.espLines and not State.espHealth) or not root or not head or not hum or hum.Health <= 0 then
            for _, dr in pairs(d) do dr.Visible = false end
            continue
        end

        local headPos = head.Position + Vector3.new(0, 0.8, 0)
        local legPos  = root.Position - Vector3.new(0, 3.0, 0)
        
        local topScreen, topVis = Camera:WorldToViewportPoint(headPos)
        local botScreen, botVis = Camera:WorldToViewportPoint(legPos)

        if not topVis or not botVis then
            for _, dr in pairs(d) do dr.Visible = false end
            continue
        end

        local boxHeight = math.abs(topScreen.Y - botScreen.Y)
        local boxWidth  = boxHeight * 0.65
        local bL = topScreen.X - boxWidth / 2
        local bR = topScreen.X + boxWidth / 2
        local bT = topScreen.Y
        local bB = botScreen.Y

        if State.espLines then
            d.line.Visible = true; d.line.From = topMid; d.line.To = Vector2.new(topScreen.X, bT)
            d.boxT.Visible = true; d.boxT.From = Vector2.new(bL,bT); d.boxT.To = Vector2.new(bR,bT)
            d.boxB.Visible = true; d.boxB.From = Vector2.new(bL,bB); d.boxB.To = Vector2.new(bR,bB)
            d.boxL.Visible = true; d.boxL.From = Vector2.new(bL,bT); d.boxL.To = Vector2.new(bL,bB)
            d.boxR.Visible = true; d.boxR.From = Vector2.new(bR,bT); d.boxR.To = Vector2.new(bR,bB)
        else
            d.line.Visible = false; d.boxT.Visible = false
            d.boxB.Visible = false; d.boxL.Visible = false; d.boxR.Visible = false
        end

        if State.espHealth then
            local pct     = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barX    = bL - 8
            local filledY = bB - (bB - bT) * pct
            d.hpBg.Visible = true; d.hpBg.From = Vector2.new(barX, bT); d.hpBg.To = Vector2.new(barX, bB)
            d.hpFg.Visible = true; d.hpFg.Color = hpColor(pct)
            d.hpFg.From = Vector2.new(barX, bB); d.hpFg.To = Vector2.new(barX, filledY)
        else
            d.hpBg.Visible = false
            d.hpFg.Visible = false
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        local e = os.time() - scriptStartTime
        if fieldLabels["Time Play"] then
            fieldLabels["Time Play"].Text = string.format("%02d:%02d:%02d", math.floor(e / 3600), math.floor((e % 3600) / 60), e % 60)
        end
        local t = os.date("*t")
        if fieldLabels["Real Time"] then
            fieldLabels["Real Time"].Text = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
        end
    end
end)

switchTab("Aimbot", "⊙")
