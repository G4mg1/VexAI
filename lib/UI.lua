return function(Theme, Icons)
    local Players = game:GetService("Players")
    local Tween   = game:GetService("TweenService")
    local UIS     = game:GetService("UserInputService")
    local lp      = Players.LocalPlayer

    local UI = {}
    UI.onSend         = nil
    UI.onOpenSettings = nil

    local gui = Instance.new("ScreenGui")
    gui.Name = "VEX"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = (gethui and gethui()) or lp:WaitForChild("PlayerGui")

    local scale = Instance.new("UIScale", gui)
    local function fit()
        local vp = workspace.CurrentCamera.ViewportSize
        scale.Scale = math.clamp(math.min(vp.X / 1180, vp.Y / 780), 0.35, 1)
    end
    fit()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)

    local function n(cls, props, parent)
        local i = Instance.new(cls)
        for k, v in pairs(props or {}) do i[k] = v end
        if parent then i.Parent = parent end
        return i
    end
    local function round(p, r) return n("UICorner", { CornerRadius = UDim.new(0, r or 12) }, p) end
    local function pad(p, t, r, b, l)
        return n("UIPadding", {
            PaddingTop    = UDim.new(0, t or 0),
            PaddingRight  = UDim.new(0, r or t or 0),
            PaddingBottom = UDim.new(0, b or t or 0),
            PaddingLeft   = UDim.new(0, l or r or t or 0),
        }, p)
    end
    local function stroke(p, c, t)
        return n("UIStroke", {
            Color = c or Theme.border,
            Thickness = t or 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, p)
    end

    local main = n("Frame", {
        Name = "VEX_Main",
        Size = UDim2.fromOffset(1080, 680),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, gui)
    round(main, 14)
    stroke(main, Theme.border)

    local side = n("Frame", {
        Size = UDim2.new(0, 240, 1, 0),
        BackgroundColor3 = Theme.sidebar,
        BorderSizePixel = 0,
    }, main)
    pad(side, 14, 12, 14, 12)

    local logoRow = n("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1 }, side)
    local logoDot = n("Frame", {
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.fromOffset(0, 4),
        BackgroundColor3 = Theme.accent,
        BorderSizePixel = 0,
    }, logoRow)
    round(logoDot, 8)
    n("TextLabel", {
        Text = "V", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
        Font = Theme.fontBold, TextColor3 = Theme.text, TextSize = 15,
    }, logoDot)
    n("TextLabel", {
        Text = "VEX", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -36, 1, 0),
        Font = Theme.fontBold, TextColor3 = Theme.text, TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, logoRow)
    n("TextLabel", {
        Text = "v" .. getgenv().VEX.version, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 4), Size = UDim2.new(1, -60, 1, 0),
        Font = Theme.font, TextColor3 = Theme.textMuted, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, logoRow)

    local newChat = n("TextButton", {
        Text = "+  New chat",
        BackgroundColor3 = Theme.panel, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.fromOffset(0, 46),
        Font = Theme.font, TextColor3 = Theme.text, TextSize = 13,
        AutoButtonColor = false,
    }, side)
    round(newChat, 8)
    newChat.MouseEnter:Connect(function()
        Tween:Create(newChat, TweenInfo.new(0.12), { BackgroundColor3 = Theme.panelHover }):Play()
    end)
    newChat.MouseLeave:Connect(function()
        Tween:Create(newChat, TweenInfo.new(0.12), { BackgroundColor3 = Theme.panel }):Play()
    end)

    local navItems = {
        { name = "Home",     icon = "home-5-line" },
        { name = "Chat",     icon = "chat-3-line" },
        { name = "Tools",    icon = "tools-line" },
        { name = "Settings", icon = "settings-3-line" },
    }
    local navY = 92
    local function navButton(item)
        local b = n("TextButton", {
            Text = "", BackgroundTransparency = 1, AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.fromOffset(0, navY),
        }, side)
        pad(b, 0, 8, 0, 8)
        local _, glyph = Icons.get(item.icon)
        n("TextLabel", {
            Text = glyph, BackgroundTransparency = 1,
            Size = UDim2.fromOffset(18, 30), Font = Theme.font,
            TextColor3 = Theme.textMuted, TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
        }, b)
        n("TextLabel", {
            Text = item.name, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -24, 1, 0),
            Font = Theme.font, TextColor3 = Theme.textMuted, TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, b)
        b.MouseEnter:Connect(function()
            Tween:Create(b, TweenInfo.new(0.12), { BackgroundTransparency = 0.9 }):Play()
        end)
        b.MouseLeave:Connect(function()
            Tween:Create(b, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
        end)
        if item.name == "Settings" then
            b.MouseButton1Click:Connect(function()
                if UI.onOpenSettings then UI.onOpenSettings() end
            end)
        end
        navY = navY + 32
    end
    for _, it in ipairs(navItems) do navButton(it) end

    n("TextLabel", {
        Text = "Recents", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, navY + 12), Size = UDim2.new(1, 0, 0, 18),
        Font = Theme.fontBold, TextColor3 = Theme.textMuted, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, side)

    local recents = n("ScrollingFrame", {
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, navY + 34),
        Size = UDim2.new(1, 0, 1, -(navY + 90)),
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.border,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, side)
    n("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, recents)
    UI.recents = recents

    local chip = n("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, 1, -34),
        BackgroundColor3 = Theme.panel, BorderSizePixel = 0,
    }, side)
    round(chip, 8)
    n("TextLabel", {
        Text = "\u{25CF}", BackgroundTransparency = 1,
        Size = UDim2.fromOffset(24, 34), Font = Theme.font,
        TextColor3 = Theme.accent, TextSize = 12,
    }, chip)
    n("TextLabel", {
        Text = lp.DisplayName, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -24, 1, 0),
        Font = Theme.font, TextColor3 = Theme.text, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, chip)

    local content = n("Frame", {
        Size = UDim2.new(1, -240, 1, 0),
        Position = UDim2.fromOffset(240, 0),
        BackgroundColor3 = Theme.bg, BorderSizePixel = 0,
    }, main)
    n("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        BackgroundColor3 = Theme.border, BorderSizePixel = 0,
    }, content)

    local greeting = n("Frame", {
        Size = UDim2.new(1, 0, 1, -160), BackgroundTransparency = 1,
    }, content)
    local greetBox = n("Frame", {
        Size = UDim2.fromOffset(600, 80),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.45),
        BackgroundTransparency = 1,
    }, greeting)
    n("TextLabel", {
        Text = "\u{2726}", BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30), Font = Theme.font,
        TextColor3 = Theme.accent, TextSize = 22,
    }, greetBox)
    n("TextLabel", {
        Text = "Bonjour, " .. lp.DisplayName, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 30), Size = UDim2.new(1, 0, 0, 40),
        Font = Theme.fontBold, TextColor3 = Theme.text, TextSize = 28,
    }, greetBox)

    local msgs = n("ScrollingFrame", {
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, -140), Visible = false,
        ScrollBarThickness = 4, ScrollBarImageColor3 = Theme.border,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, content)
    pad(msgs, 24, 24, 12, 24)
    n("UIListLayout", { Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder }, msgs)

    local inputWrap = n("Frame", {
        Size = UDim2.new(1, -48, 0, 92),
        Position = UDim2.new(0, 24, 1, -108),
        BackgroundColor3 = Theme.panel, BorderSizePixel = 0,
    }, content)
    round(inputWrap, 14)
    stroke(inputWrap, Theme.border)

    local txt = n("TextBox", {
        PlaceholderText = "How can VEX help you today?",
        PlaceholderColor3 = Theme.textMuted,
        Text = "", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -70, 0, 34),
        Font = Theme.font, TextColor3 = Theme.text, TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
    }, inputWrap)

    local send = n("TextButton", {
        Text = "\u{2191}",
        BackgroundColor3 = Theme.accent, BorderSizePixel = 0,
        Position = UDim2.new(1, -46, 0, 12), Size = UDim2.fromOffset(34, 34),
        Font = Theme.fontBold, TextColor3 = Theme.text, TextSize = 18,
        AutoButtonColor = false,
    }, inputWrap)
    round(send, 10)

    n("TextButton", {
        Text = "  Claude 4.5 Sonnet  \u{25BE}",
        BackgroundTransparency = 1, AutoButtonColor = false,
        Position = UDim2.fromOffset(10, 52), Size = UDim2.fromOffset(200, 26),
        Font = Theme.font, TextColor3 = Theme.textMuted, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, inputWrap)

    n("TextLabel", {
        Text = "+ Add context", BackgroundTransparency = 1,
        Position = UDim2.new(1, -140, 0, 52), Size = UDim2.fromOffset(130, 26),
        Font = Theme.font, TextColor3 = Theme.textMuted, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, inputWrap)

    local function submit()
        local t = txt.Text
        txt.Text = ""
        if UI.onSend then UI.onSend(t) end
    end
    send.MouseButton1Click:Connect(submit)
    txt.FocusLost:Connect(function(enter) if enter then submit() end end)

    local order = 0
    local function nextOrder() order = order + 1; return order end

    local function addBubble(role, text)
        greeting.Visible = false
        msgs.Visible = true
        local isUser = role == "user"
        local wrap = n("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = nextOrder(),
        }, msgs)
        local lbl = n("TextLabel", {
            Text = text,
            BackgroundColor3 = isUser and Theme.panel or Theme.bg,
            BackgroundTransparency = isUser and 0 or 1,
            Size = UDim2.new(isUser and 0.7 or 1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Position = isUser and UDim2.new(1, 0, 0, 0) or UDim2.fromOffset(0, 0),
            AnchorPoint = isUser and Vector2.new(1, 0) or Vector2.new(0, 0),
            Font = Theme.font, TextColor3 = Theme.text, TextSize = 14,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            BorderSizePixel = 0,
        }, wrap)
        pad(lbl, 12, 16, 12, 16)
        if isUser then round(lbl, 12) end
        return wrap
    end

    function UI.addMessage(role, text)
        addBubble(role, text)
        task.defer(function()
            msgs.CanvasPosition = Vector2.new(0, msgs.AbsoluteCanvasSize.Y)
        end)
    end

    function UI.addStatus(text)
        local wrap = n("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 22),
            LayoutOrder = nextOrder(),
        }, msgs)
        n("TextLabel", {
            Text = "\u{00B7} " .. text, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0), Font = Theme.font,
            TextColor3 = Theme.textMuted, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, wrap)
        greeting.Visible = false
        msgs.Visible = true
        task.defer(function()
            msgs.CanvasPosition = Vector2.new(0, msgs.AbsoluteCanvasSize.Y)
        end)
    end

    local thinkingWrap
    function UI.showThinking()
        greeting.Visible = false
        msgs.Visible = true
        thinkingWrap = n("Frame", {
            BackgroundColor3 = Theme.panel, BorderSizePixel = 0,
            Size = UDim2.fromOffset(76, 36),
            LayoutOrder = nextOrder(),
        }, msgs)
        round(thinkingWrap, 12)
        n("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Theme.accent),
                ColorSequenceKeypoint.new(1, Theme.accentSoft),
            }),
        }, thinkingWrap)
        for i = 1, 3 do
            local d = n("Frame", {
                Size = UDim2.fromOffset(8, 8),
                BackgroundColor3 = Theme.text,
                BorderSizePixel = 0,
                Position = UDim2.fromOffset(14 + (i - 1) * 16, 14),
            }, thinkingWrap)
            round(d, 4)
            task.spawn(function()
                while d.Parent do
                    Tween:Create(d, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        BackgroundTransparency = 0.55,
                        Size = UDim2.fromOffset(6, 6),
                        Position = d.Position + UDim2.fromOffset(1, 1),
                    }):Play()
                    task.wait(0.45)
                    Tween:Create(d, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        BackgroundTransparency = 0,
                        Size = UDim2.fromOffset(8, 8),
                        Position = d.Position - UDim2.fromOffset(1, 1),
                    }):Play()
                    task.wait(0.45)
                end
            end)
        end
        task.defer(function()
            msgs.CanvasPosition = Vector2.new(0, msgs.AbsoluteCanvasSize.Y)
        end)
    end

    function UI.hideThinking()
        if thinkingWrap then
            thinkingWrap:Destroy()
            thinkingWrap = nil
        end
    end

    function UI:addRecent(title)
        local b = n("TextButton", {
            Text = title, BackgroundTransparency = 1, AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 26),
            Font = Theme.font, TextColor3 = Theme.textMuted, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, UI.recents)
        pad(b, 0, 8, 0, 8)
    end

    local settingsOverlay = n("Frame", {
        Size = UDim2.new(1, -240, 1, 0),
        Position = UDim2.fromOffset(240, 0),
        BackgroundColor3 = Theme.bg, BorderSizePixel = 0, Visible = false,
    }, main)

    local header = n("Frame", { Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1 }, settingsOverlay)
    pad(header, 0, 24, 0, 24)
    n("TextLabel", {
        Text = "Settings", BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 1, 0), Font = Theme.fontBold,
        TextColor3 = Theme.text, TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)
    local closeBtn = n("TextButton", {
        Text = "\u{2715}", BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 14), Size = UDim2.fromOffset(30, 30),
        Font = Theme.font, TextColor3 = Theme.textMuted, TextSize = 16,
    }, header)

    local body = n("ScrollingFrame", {
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 60),
        Size = UDim2.new(1, 0, 1, -60),
        ScrollBarThickness = 4, ScrollBarImageColor3 = Theme.border,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, settingsOverlay)
    pad(body, 0, 24, 24, 24)
    n("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }, body)

    function UI.openSettings(Settings, Perms)
        for _, c in ipairs(body:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        local ord = 0
        local function section(title)
            ord = ord + 1
            n("TextLabel", {
                Text = title, BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 22), LayoutOrder = ord,
                Font = Theme.fontBold, TextColor3 = Theme.textMuted, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, body)
        end
        local function field(label, value, onCommit)
            ord = ord + 1
            local row = n("Frame", {
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = Theme.panel, BorderSizePixel = 0,
                LayoutOrder = ord,
            }, body)
            round(row, 10)
            n("TextLabel", {
                Text = label, BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 6),
                Size = UDim2.new(1, -28, 0, 16),
                Font = Theme.font, TextColor3 = Theme.textMuted, TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, row)
            local box = n("TextBox", {
                Text = value or "", BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 22),
                Size = UDim2.new(1, -28, 0, 26),
                Font = Theme.font, TextColor3 = Theme.text, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
            }, row)
            box.FocusLost:Connect(function() onCommit(box.Text) end)
        end
        local function toggle(label, key)
            ord = ord + 1
            local row = n("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.panel, BorderSizePixel = 0,
                LayoutOrder = ord,
            }, body)
            round(row, 10)
            n("TextLabel", {
                Text = label, BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 0),
                Size = UDim2.new(1, -80, 1, 0),
                Font = Theme.font, TextColor3 = Theme.text, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, row)
            local on = Perms.get(key) and true or false
            local btn = n("TextButton", {
                Text = on and "ON" or "OFF",
                BackgroundColor3 = on and Theme.accent or Theme.panelHover,
                Position = UDim2.new(1, -60, 0, 9),
                Size = UDim2.fromOffset(48, 24),
                Font = Theme.fontBold, TextColor3 = Theme.text, TextSize = 11,
                AutoButtonColor = false, BorderSizePixel = 0,
            }, row)
            round(btn, 6)
            btn.MouseButton1Click:Connect(function()
                local nv = not Perms.get(key)
                Perms.set(key, nv)
                btn.Text = nv and "ON" or "OFF"
                btn.BackgroundColor3 = nv and Theme.accent or Theme.panelHover
            end)
        end

        section("API")
        field("HuggingFace API Key", Settings.get("apikey"), function(v) Settings.set("apikey", v) end)
        field("Model ID", Settings.get("model"), function(v) Settings.set("model", v) end)
        field("Persona (system prompt)", Settings.get("persona"), function(v) Settings.set("persona", v) end)

        section("Permissions")
        toggle("isfile", "isfile")
        toggle("writefile", "writefile")
        toggle("createfolder", "createfolder")
        toggle("read_device_file", "read_device_file")
        toggle("decompile_toread", "decompile_toread")
        toggle("AutoRun scripts", "autorun")

        settingsOverlay.Visible = true
    end

    closeBtn.MouseButton1Click:Connect(function()
        settingsOverlay.Visible = false
    end)

    function UI:toggle() main.Visible = not main.Visible end

    do
        local dragging, dragStart, startPos
        local dragBar = n("Frame", {
            Size = UDim2.new(1, 0, 0, 12), BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 0),
        }, main)
        dragBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = i.Position
                startPos = main.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    return UI
end