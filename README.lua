local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
if not game:IsLoaded() then game.Loaded:Wait() end
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end
local GUI_NAME = "DAPPERDAN DADDY"
local LOGO_ID = 14653905878
local BG_ID = 126614954679548
local env = (getgenv and getgenv()) or _G
env.NexvyrCatOverride = env.NexvyrCatOverride or {}
if env.NexvyrToolsVisualCleanup then
    pcall(env.NexvyrToolsVisualCleanup)
end
local conns = {}
local function track(c)
    conns[#conns + 1] = c
    return c
end
local function withTimeout(secs, fn)
    local res, done = nil, false
    task.spawn(function()
        local ok, r = pcall(fn)
        if ok then res = r end
        done = true
    end)
    local t0 = os.clock()
    while not done and os.clock() - t0 < secs do task.wait(0.05) end
    return res
end
local probeCache = {}
local function probeImage(id)
    if probeCache[id] ~= nil then return probeCache[id] end
    local p = Instance.new("ImageLabel")
    p.Image = id
    withTimeout(3, function() ContentProvider:PreloadAsync({ p }) end)
    local ok, loaded = pcall(function() return p.IsLoaded end)
    pcall(function() p:Destroy() end)
    local r = (ok and loaded) and true or false
    probeCache[id] = r
    return r
end
local function textureFromAsset(direct)
    local ok, obj = pcall(function() return game:GetObjects(direct)[1] end)
    if not (ok and obj) then return nil end
    local tex
    if obj:IsA("Decal") or obj:IsA("Texture") then
        tex = obj.Texture
    else
        local d = obj:FindFirstChildWhichIsA("Decal", true)
        if d then tex = d.Texture end
    end
    pcall(function() obj:Destroy() end)
    if tex and tex ~= "" then return tex end
    return nil
end
local Logo = { image = nil, ready = false, subs = {} }
local LOGO_THUMB = "rbxthumb://type=Asset&id=" .. LOGO_ID .. "&w=150&h=150"
local LOGO_DIRECT = "rbxassetid://" .. LOGO_ID
local function logoApply(image)
    if Logo.ready then return end
    Logo.ready, Logo.image = true, image
    for _, fn in ipairs(Logo.subs) do task.spawn(fn, image) end
end
function Logo.onReady(fn)
    Logo.subs[#Logo.subs + 1] = fn
    if Logo.ready then task.spawn(fn, Logo.image) end
end
task.spawn(function()
    task.spawn(function()
        if probeImage(LOGO_THUMB) then logoApply(LOGO_THUMB) end
    end)
    task.spawn(function()
        if probeImage(LOGO_DIRECT) then logoApply(LOGO_DIRECT) end
    end)
    task.spawn(function()
        local tex = textureFromAsset(LOGO_DIRECT)
        if tex and probeImage(tex) then logoApply(tex) end
    end)
    task.delay(3, function()
        if not Logo.ready then logoApply(LOGO_THUMB) end
    end)
end)
local Bg = { image = nil, ready = false, subs = {} }
local BG_THUMB = "rbxthumb://type=Asset&id=" .. BG_ID .. "&w=768&h=432"
local BG_DIRECT = "rbxassetid://" .. BG_ID
local function bgApply(image)
    if Bg.ready then return end
    Bg.ready, Bg.image = true, image
    for _, fn in ipairs(Bg.subs) do task.spawn(fn, image) end
end
function Bg.onReady(fn)
    Bg.subs[#Bg.subs + 1] = fn
    if Bg.ready then task.spawn(fn, Bg.image) end
end
task.spawn(function()
    task.spawn(function()
        if probeImage(BG_THUMB) then bgApply(BG_THUMB) end
    end)
    task.spawn(function()
        if probeImage(BG_DIRECT) then bgApply(BG_DIRECT) end
    end)
    task.spawn(function()
        local tex = textureFromAsset(BG_DIRECT)
        if tex and probeImage(tex) then bgApply(tex) end
    end)
    task.delay(4, function()
        if not Bg.ready then bgApply(BG_THUMB) end
    end)
end)
task.wait(0.2)
local function getParent()
    local ok, ui = pcall(function() return gethui and gethui() end)
    if ok and ui then return ui end
    ok, ui = pcall(function() return game:GetService("CoreGui") end)
    if ok and ui then
        local t = Instance.new("Folder")
        local good = pcall(function() t.Parent = ui end)
        t:Destroy()
        if good then return ui end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local parent = getParent()
local old = parent:FindFirstChild(GUI_NAME)
if old then old:Destroy() end
local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)
local IC = {
    title = Color3.fromRGB(228, 230, 238),
    titleLow = Color3.fromRGB(168, 172, 190),
    gold = Color3.fromRGB(210, 178, 120),
    goldLight = Color3.fromRGB(240, 214, 160),
    soft = Color3.fromRGB(176, 168, 152),
    btnText = Color3.fromRGB(206, 206, 214),
    btnBg = Color3.fromRGB(10, 10, 14),
    btnBgMain = Color3.fromRGB(64, 56, 44),
    btnLine = Color3.fromRGB(110, 108, 118),
}
local T = {
    text = IC.title,
    sub = IC.soft,
    line = IC.btnLine,
    gold = IC.gold,
    red = Color3.fromRGB(232, 72, 92),
    green = Color3.fromRGB(62, 212, 142),
    warn = Color3.fromRGB(255, 196, 84),
}
local STYLES = {
    main = { bg = IC.btnBgMain, bgT = 0.3, stroke = IC.gold, strokeT = 0.35, text = WHITE },
    dark = { bg = IC.btnBg, bgT = 0.5, stroke = IC.btnLine, strokeT = 0.7, text = IC.btnText },
    danger = { bg = Color3.fromRGB(58, 24, 32), bgT = 0.35, stroke = T.red, strokeT = 0.5, text = Color3.fromRGB(255, 214, 220) },
    green = { bg = Color3.fromRGB(22, 58, 42), bgT = 0.3, stroke = T.green, strokeT = 0.5, text = WHITE },
}
local UI = {}
local touchOnly = UIS.TouchEnabled and not UIS.MouseEnabled
function UI.new(class, props)
    local o = Instance.new(class)
    local p
    for k, v in pairs(props) do
        if k == "Parent" then p = v else o[k] = v end
    end
    if p then o.Parent = p end
    return o
end
local new = UI.new
function UI.corner(o, r)
    return new("UICorner", { Parent = o, CornerRadius = UDim.new(0, r) })
end
local corner = UI.corner
function UI.stroke(o, color, thick, trans)
    return new("UIStroke", {
        Parent = o, Color = color, Thickness = thick or 1,
        Transparency = trans or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end
local stroke = UI.stroke
function UI.grad(o, c1, c2, rot)
    return new("UIGradient", { Parent = o, Color = ColorSequence.new(c1, c2), Rotation = rot or 90 })
end
local grad = UI.grad
function UI.tween(o, info, props)
    local t = TweenService:Create(o, info, props)
    t:Play()
    return t
end
local tween = UI.tween
local gui = new("ScreenGui", {
    Name = GUI_NAME, ResetOnSpawn = false, IgnoreGuiInset = true,
    DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parent,
})
function UI.viewport()
    local s = gui.AbsoluteSize
    if s.X < 10 or s.Y < 10 then s = workspace.CurrentCamera.ViewportSize end
    return s
end
function UI.clampPos(target, x, y)
    local vp = UI.viewport()
    local sz = target.AbsoluteSize
    return math.clamp(x, 0, math.max(0, vp.X - sz.X)), math.clamp(y, 0, math.max(0, vp.Y - sz.Y))
end
local clampPos = UI.clampPos
function UI.draggable(handle, target, onTap, onDown, onUp)
    local dragging, moved, active, startIn, startX, startY = false, false, nil, nil, 0, 0
    track(handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging, moved, active = true, false, input
            startIn = input.Position
            startX, startY = target.Position.X.Offset, target.Position.Y.Offset
            if onDown then onDown() end
            local c
            c = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    c:Disconnect()
                    local wasDrag = moved
                    dragging = false
                    if onUp then onUp(wasDrag) end
                    if not wasDrag and onTap then onTap() end
                end
            end)
        end
    end))
    track(UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input == active then
            local d = input.Position - startIn
            if not moved and d.Magnitude < 6 then return end
            moved = true
            local x, y = clampPos(target, startX + d.X, startY + d.Y)
            target.Position = UDim2.fromOffset(x, y)
        end
    end))
end
function UI.logo(img, fallback)
    img.ImageTransparency = 1
    if fallback then fallback.Visible = true end
    Logo.onReady(function(image)
        if not image or not img.Parent then return end
        img.Image = image
        tween(img, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 })
        if fallback then
            task.delay(0.25, function() fallback.Visible = false end)
        end
    end)
end
function UI.background(host, overlayT)
    local holder = new("Frame", {
        Parent = host, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true,
    })
    local img = new("ImageLabel", {
        Parent = holder, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Crop, Image = "", ImageTransparency = 1,
    })
    local sc = new("UIScale", { Parent = img, Scale = 1.12 })
    new("Frame", {
        Parent = host, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK,
        BackgroundTransparency = overlayT, BorderSizePixel = 0,
    })
    local shade = new("Frame", {
        Parent = host, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK,
        BackgroundTransparency = 0, BorderSizePixel = 0,
    })
    new("UIGradient", {
        Parent = shade, Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(0.5, 0.85),
            NumberSequenceKeypoint.new(1, 0.3),
        }),
    })
    Bg.onReady(function(image)
        if not image or not img.Parent then return end
        img.Image = image
        tween(img, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { ImageTransparency = 0 })
    end)
    return sc
end
function UI.icon(kind, parent_, color, size)
    size = size or 16
    local root = new("Frame", {
        Parent = parent_, Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1,
    })
    local inner = new("Frame", {
        Parent = root, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
    })
    new("UIScale", { Parent = inner, Scale = size / 16 })
    local fills, strokes = {}, {}
    local function bar(cx, cy, w, h, rot)
        local f = new("Frame", {
            Parent = inner, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx, cy),
            Size = UDim2.fromOffset(w, h), Rotation = rot or 0, BackgroundColor3 = color, BorderSizePixel = 0,
        })
        corner(f, math.min(w, h) / 2)
        fills[#fills + 1] = f
    end
    local function line(x1, y1, x2, y2, th)
        local dx, dy = x2 - x1, y2 - y1
        local len = math.sqrt(dx * dx + dy * dy)
        bar((x1 + x2) / 2, (y1 + y2) / 2, len, th or 1.8, math.deg(math.atan2(dy, dx)))
    end
    local function box(cx, cy, w, h, r, th)
        local f = new("Frame", {
            Parent = inner, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx, cy),
            Size = UDim2.fromOffset(w, h), BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        corner(f, r)
        strokes[#strokes + 1] = new("UIStroke", {
            Parent = f, Color = color, Thickness = th, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        })
    end
    if kind == "close" then
        line(3.8, 3.8, 12.2, 12.2, 2)
        line(12.2, 3.8, 3.8, 12.2, 2)
    elseif kind == "min" then
        bar(8, 11, 10, 2)
    elseif kind == "plus" then
        bar(8, 8, 11, 2)
        bar(8, 8, 2, 11)
    elseif kind == "search" then
        box(7, 7, 10, 10, 5, 1.6)
        line(10.8, 10.8, 14.2, 14.2, 2)
    elseif kind == "trash" then
        box(8, 2.9, 4.6, 3.2, 1.4, 1.4)
        bar(8, 4.9, 12.5, 1.8)
        box(8, 10.6, 9, 8.6, 2, 1.5)
        bar(6.2, 10.8, 1.3, 4.6)
        bar(9.8, 10.8, 1.3, 4.6)
    end
    local icon = { root = root }
    function icon.set(c)
        for _, f in ipairs(fills) do f.BackgroundColor3 = c end
        for _, s in ipairs(strokes) do s.Color = c end
    end
    return icon
end
function UI.button(o)
    local S = STYLES[o.style or "dark"]
    local b = new("TextButton", {
        Parent = o.parent, Size = o.size, BackgroundColor3 = S.bg, BackgroundTransparency = S.bgT,
        AutoButtonColor = false, Text = "", BorderSizePixel = 0, LayoutOrder = o.order or 0,
    })
    if o.pos then b.Position = o.pos end
    if o.anchor then b.AnchorPoint = o.anchor end
    corner(b, o.radius or 4)
    local st = stroke(b, S.stroke, 1, S.strokeT)
    local sc = new("UIScale", { Parent = b, Scale = 1 })
    local row = new("Frame", { Parent = b, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 })
    new("UIListLayout", {
        Parent = row, FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
    })
    local tc = o.textColor or S.text
    local icColor = o.iconColor or tc
    local ic, lbl
    if o.icon then
        ic = UI.icon(o.icon, row, icColor, o.iconSize or 14)
        ic.root.LayoutOrder = 1
    end
    if o.text then
        lbl = new("TextLabel", {
            Parent = row, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 16), Text = o.text, Font = Enum.Font.GothamMedium,
            TextSize = o.textSize or 12, TextColor3 = tc, LayoutOrder = 2,
        })
    end
    local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
    local pinfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local rinfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local function paint(mode)
        local bgT, stT, bgC
        if mode == "hover" then
            bgT, stT = math.max(0, S.bgT - 0.18), math.max(0, S.strokeT - 0.3)
            bgC = S.bg:Lerp(S.stroke, 0.18)
        elseif mode == "press" then
            bgT, stT = math.max(0, S.bgT - 0.3), math.max(0, S.strokeT - 0.4)
            bgC = S.bg:Lerp(S.stroke, 0.3)
        else
            bgT, stT, bgC = S.bgT, S.strokeT, S.bg
        end
        tween(b, info, { BackgroundTransparency = bgT, BackgroundColor3 = bgC })
        tween(st, info, { Transparency = stT })
    end
    b.MouseEnter:Connect(function()
        if touchOnly then return end
        paint("hover")
        if ic and o.iconHover then ic.set(o.iconHover) end
    end)
    b.MouseLeave:Connect(function()
        paint("idle")
        tween(sc, rinfo, { Scale = 1 })
        if ic and o.iconHover then ic.set(icColor) end
    end)
    b.MouseButton1Down:Connect(function()
        paint("press")
        tween(sc, pinfo, { Scale = 0.95 })
        if ic and o.iconHover then ic.set(o.iconHover) end
    end)
    b.MouseButton1Up:Connect(function()
        tween(sc, rinfo, { Scale = 1 })
        if touchOnly then
            paint("idle")
            if ic and o.iconHover then ic.set(icColor) end
        else
            paint("hover")
        end
    end)
    local h = { btn = b, label = lbl, icon = ic, stroke = st }
    function h.setStyle(name)
        S = STYLES[name] or S
        local c = o.textColor or S.text
        if lbl then lbl.TextColor3 = c end
        if ic and not o.iconColor then ic.set(c) end
        tween(st, info, { Color = S.stroke })
        paint("idle")
    end
    return h
end
local makeButton = UI.button
function UI.winButton(parent_, kind, xOff, accent)
    local b = new("TextButton", {
        Parent = parent_, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOff, 0.5, 0),
        Size = UDim2.fromOffset(28, 28), BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.45,
        AutoButtonColor = false, Text = "", BorderSizePixel = 0,
    })
    corner(b, 4)
    local st = stroke(b, IC.btnLine, 1, 0.65)
    local sc = new("UIScale", { Parent = b, Scale = 1 })
    local ic = UI.icon(kind, b, IC.soft, 14)
    ic.root.AnchorPoint = Vector2.new(0.5, 0.5)
    ic.root.Position = UDim2.fromScale(0.5, 0.5)
    local info = TweenInfo.new(0.14, Enum.EasingStyle.Quad)
    local pinfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local rinfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local function state(bgColor, bgT, strokeColor, strokeT, iconColor)
        tween(b, info, { BackgroundColor3 = bgColor, BackgroundTransparency = bgT })
        tween(st, info, { Color = strokeColor, Transparency = strokeT })
        ic.set(iconColor)
    end
    local function idle() state(IC.btnBg, 0.45, IC.btnLine, 0.65, IC.soft) end
    local function over() state(accent:Lerp(BLACK, 0.7), 0.15, accent, 0.2, WHITE) end
    b.MouseEnter:Connect(function()
        if touchOnly then return end
        over()
        if kind == "close" then
            tween(ic.root, rinfo, { Rotation = 90 })
        end
    end)
    b.MouseLeave:Connect(function()
        idle()
        tween(sc, rinfo, { Scale = 1 })
        tween(ic.root, rinfo, { Rotation = 0 })
    end)
    b.MouseButton1Down:Connect(function()
        over()
        tween(sc, pinfo, { Scale = 0.88 })
    end)
    b.MouseButton1Up:Connect(function()
        tween(sc, rinfo, { Scale = 1 })
        if touchOnly then
            idle()
        else
            over()
        end
    end)
    return b
end
function UI.modal(host)
    local overlay = new("Frame", {
        Parent = host, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK,
        BackgroundTransparency = 1, BorderSizePixel = 0, Active = true, Visible = false, ZIndex = 100,
    })
    local box = new("Frame", {
        Parent = overlay, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(300, 142), BackgroundColor3 = IC.btnBg, BackgroundTransparency = 0.08,
        BorderSizePixel = 0, ZIndex = 101,
    })
    corner(box, 6)
    local boxStroke = stroke(box, WHITE, 1.2, 0.2)
    grad(boxStroke, IC.gold, IC.btnLine, 60)
    local scale = new("UIScale", { Parent = box, Scale = 0.9 })
    local title = new("TextLabel", {
        Parent = box, Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -28, 0, 26),
        BackgroundTransparency = 1, Text = "", Font = Enum.Font.Garamond,
        TextSize = 22, TextColor3 = IC.title, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 102,
    })
    local text = new("TextLabel", {
        Parent = box, Position = UDim2.fromOffset(14, 42), Size = UDim2.new(1, -28, 0, 34),
        BackgroundTransparency = 1, Text = "", Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = IC.soft, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 102,
    })
    local left = makeButton({
        parent = box, text = "Volver", size = UDim2.fromOffset(129, 34),
        pos = UDim2.fromOffset(14, 94), style = "dark", textSize = 13,
    })
    local right = makeButton({
        parent = box, text = "Aceptar", size = UDim2.fromOffset(129, 34),
        pos = UDim2.fromOffset(157, 94), style = "danger", textSize = 13,
    })
    for _, d in ipairs(box:GetDescendants()) do
        if d:IsA("GuiObject") and d.ZIndex < 102 then d.ZIndex = 102 end
    end
    
